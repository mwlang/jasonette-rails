module Jasonette::Properties
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
      properties.merge! "#{name}".to_sym => { is_many: types.include?(:is_many) }
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

  def is_many? name
    self.class.properties.has_type?(name, :is_many)
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

  def all_ivar_for_property name
    "@all_#{name}"
  end

  def set_all_ivar name, value
    instance_variable_set(all_ivar_for_property(name), value)
  end

  def get_all_ivar name
    instance_variable_get(all_ivar_for_property(name)) || []
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

  def all_instance_variable_set name
    klass = klass_for_property name
    new_klass = klass.new(@context)

    set_ivar(name, new_klass)
    ivar = get_ivar(name)
    if is_many?(name)
      ivar_all = get_all_ivar(name)
      set_all_ivar(name, ivar_all << ivar)
    end
  end

  def property_get! name
    if get_ivar(name).nil? || is_many?(name)
      all_instance_variable_set(name)
    end
    get_ivar(name)
  end

  def property_set! name, *args, &block
    ivar = property_get! name
    return ivar unless block_given?
    ivar.tap { |v| v.encode(&block) }
  end

  def merge_properties
    property_names.each do |property_name|
      property_name = property_name.to_s
      ivar = get_ivar(property_name)
      next if ivar.nil? || ivar.empty?
      @attributes[property_name] = get_default_for_property(property_name)
      if is_many?(property_name)
        get_all_ivar(property_name).each do |iv|
          @attributes[property_name] << iv.attributes!
        end
      else
        @attributes[property_name].merge! ivar.attributes!
      end
    end
  end

  def property_sender target, name, *args, &block
    raise "unhandled definition! : use different property name then `#{name}`" if Object.new.methods.include?(name.to_sym)
    if block_given?
      target.send name, *args, &block
    elsif args.one? && args.first.is_a?(Hash)
      target.send name do
        args.first.each{ |key, value| json.set! key, value.to_s }
      end
    else
      raise "unhandled definition!"
    end
    self
  end
end
