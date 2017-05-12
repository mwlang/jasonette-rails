module Jasonette::Properties
  TYPES = [:is_many, :is_single]

  class PropertyEnum
    include Enumerable
    attr_accessor :properties

    def initialize properties = {}
      @properties = properties
    end

    def merge! value
      properties.merge! value if value.is_a? Hash
      properties.merge! value.properties if value.is_a? self.class
    end

    def names; properties.keys end
    def value; properties end

    def has_type?(name, ptype)
      value[name.to_sym][ptype.to_sym] rescue false
    end
  end

  module ClassMethods

    def super_property
      properties.merge!(superclass.properties)
    end

    def property name, *types
      properties.merge! "#{name}".to_sym => TYPES.map { |type| { type => types.include?(type) } }.reduce({}, :merge)
    end

    def properties
      PropertyEnum.new @properties ||= {}
    end
  end

  def self.included base
    base.send :extend, ClassMethods
  end

  def property_names
    self.class.properties.names
  end

  def property_variables
    property_names.map { |i| "@#{i}".to_sym }
  end

  TYPES.each do |type|
    define_method("#{type}?") { |name| self.class.properties.has_type?(name, type) }
    define_method("ivar_#{type}_for_property") { |name| "@#{type}_#{name}" }
    define_method("get_#{type}_ivar") do |name|
      instance_variable_get(send("ivar_#{type}_for_property", name)) || (is_many?(name) ? [] : nil)
    end
    define_method("set_#{type}_ivar") do |name, value|
      instance_variable_set(send("ivar_#{type}_for_property", name), value)
    end
  end
  define_method("property_type_methods") { TYPES.map { |type| "#{type}?" } }

  def has_any_property_type? name
    property_type_methods.map { |m| send(m, name) }.any?
  end

  def has_property? name
    property_names.include?(name.to_sym)
  end

  def ivar_for_property name
    "@#{name}"
  end

  def set_ivar name, value
    instance_variable_set(ivar_for_property(name), value)
  end

  def get_ivar name
    instance_variable_get(ivar_for_property(name))
  end

  def get_default_for_property name
    is_many?(name) ? [] : {}
  end

  def prop name
    instance_variable_get("@#{name}")
  end

  def properties_empty?
    property_names.all? do |ivar_name|
      ivar = get_ivar(ivar_name)
      ivar.nil? || ivar.empty?
    end
  end

  def klass_for_property name
    name = name.to_s.camelize
    klass = "#{self.class}::#{name}".constantize rescue nil
    klass ||= "Jasonette::#{name}".constantize rescue Jasonette::Base
    klass
  end

  def parent_jasonette_set klass
    instance_variable_set("@_parent_jasonette", klass)

    (klass.instance_variables - klass.property_variables).each do |var|
      instance_variable_set(var, klass.instance_variable_get(var)) unless instance_variable_get(var)
    end
    klass
  end

  def parent_jasonette
    instance_variable_get("@_parent_jasonette")
  end

  def create_new_klass name
    klass = klass_for_property name
    new_klass = klass.new(@context)
    new_klass.parent_jasonette_set self
    new_klass
  end

  def all_instance_variable_set name, *args
    new_klass = create_new_klass name

    set_ivar(name, new_klass) if (get_ivar(name).nil? || is_many?(name))
    ivar = get_ivar(name)

    if is_single?(name)
      new_klass.set_is_single_ivar(name, args.first)
    end

    if is_many?(name)
      ivar_all = get_is_many_ivar(name)
      set_is_many_ivar(name, ivar_all << ivar)
    end
  end

  def property_get! name, *args
    all_instance_variable_set(name, *args)
    get_ivar(name)
  end

  def property_set! name, *args, &block
    ivar = property_get! name, *args
    return ivar unless block_given?
    ivar.tap { |v| v.encode(&block) }
  end

  def merge_properties
    property_names.each do |property_name|
      property_name = property_name.to_s
      ivar = get_ivar(property_name)
      next if ivar.nil? || ivar.empty?
      @attributes[property_name] = get_default_for_property(property_name)

      if !has_any_property_type?(property_name)
        @attributes[property_name].merge! ivar.attributes!
        next
      end

      if is_many?(property_name)
        get_is_many_ivar(property_name).each do |iv|
          if is_single?(property_name) && (single_ivar = iv.get_is_single_ivar(property_name))
            @attributes[property_name] = @attributes[property_name].reduce({}, :merge) if @attributes[property_name].is_a?(Array)
            @attributes[property_name][single_ivar] ||= {}
            @attributes[property_name][single_ivar].merge! iv.attributes!
          else
            if @attributes[property_name].is_a?(Hash)
              @attributes[property_name].merge! iv.attributes!
            else
              @attributes[property_name] << iv.attributes!
            end
          end
        end
      end
    end
  end

  def property_sender target, name, *args, &block
    raise "unhandled definition! : use different property name then `#{name}`" if Object.new.methods.include?(name.to_sym)
    if block_given?
      target.send name, *args, &block
    elsif args.one? && args.first.is_a?(Hash)
      target.send name do
        args.first.each{ |key, value| set! key, value.to_s }
      end
    else
      raise "unhandled definition!"
    end
    self
  end
end
