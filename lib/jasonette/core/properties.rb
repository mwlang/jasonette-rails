module Jasonette::Properties
  module ClassMethods

    def super_property
      properties.push(*superclass.properties)
    end

    def property name, is_many = false
      properties.merge! "#{name}".to_sym => { is_many: is_many }
    end

    def properties
      @properties ||= {}
    end
  end

  def self.included base
    base.send :extend, ClassMethods
  end

  def properties
    self.class.properties.keys
  end

  def full_properties
    self.class.properties
  end

  def is_many? name
    full_properties[name.to_sym][:is_many] rescue false
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
    instance_variable_get(all_ivar_for_property(name))
  end

  def get_default_for_property name
    is_many?(name) ? [] : {}
  end

  def prop name
    instance_variable_get("@#{name}")
  end

  def properties_empty?
    properties.all? do |ivar_name|
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
      ivar_all = get_all_ivar(name) || []
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
    properties.each do |property_name|
      ivar = get_ivar(property_name)
      next if ivar.nil? || ivar.empty?
      @attributes[property_name.to_s] ||= get_default_for_property(property_name)
      if @attributes[property_name.to_s].is_a?(Array)
        @attributes[property_name.to_s] << ivar.attributes!
      else
        @attributes[property_name.to_s].merge! ivar.attributes!
      end

      if is_many?(property_name)
        property_name = property_name.to_s
        @attributes.delete property_name if @attributes.has_key?(property_name)
        if !get_all_ivar(property_name).nil?
          @attributes[property_name] = [] if @attributes[property_name].nil? || @attributes[property_name].empty?
          get_all_ivar(property_name).each do |iv|
            @attributes[property_name] << iv.attributes!
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
        args.first.each{ |key, value| json.set! key, value.to_s }
      end
    else
      raise "unhandled definition!"
    end
    self
  end
end
