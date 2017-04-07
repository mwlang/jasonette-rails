module Jasonette::Properties
  module ClassMethods
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

  def all_instance_variable_set name
    ivar_name     = ivar_name_for_property name
    all_ivar_name = all_ivar_name_for_property name
    klass = klass_for_property name
    new_klass = klass.new(@context)
    ivar_all = instance_variable_get(all_ivar_name)

    instance_variable_set(ivar_name, new_klass)
    ivar = instance_variable_get(ivar_name)
    if is_many?(name)
      ivar_all ||= []
      instance_variable_set(all_ivar_name, ivar_all << ivar)
    end
  end

  def ivar_name_for_property name
    "@#{name}"
  end

  def all_ivar_name_for_property name
    "@all_#{name}"
  end

  def get_default_for_property name
    is_many?(name) ? [] : {}
  end

  def prop name
    instance_variable_get("@#{name}")
  end

  def properties_empty?
    properties.all? do |ivar_name|
      ivar = instance_variable_get(:"@#{ivar_name}")
      ivar.nil? || ivar.empty?
    end
  end

  def klass_for_property name
    name = name.to_s.camelize
    klass = "#{self.class}::#{name}".constantize rescue nil
    klass ||= "Jasonette::#{name}".constantize rescue Jasonette::Base
    klass
  end

  def property_get! name
    ivar_name = ivar_name_for_property name
    if instance_variable_get(ivar_name).nil? || is_many?(name)
      all_instance_variable_set(name)
    end
    instance_variable_get(ivar_name)
  end

  def property_set! name, *args, &block
    ivar = property_get! name
    return ivar unless block_given?
    ivar.tap { |v| v.encode(&block) }
  end

  def merge_properties
    properties.each do |property_name|
      ivar = instance_variable_get("#{ivar_name_for_property(property_name)}")
      next if ivar.nil? || ivar.empty?
      @attributes[property_name.to_s] ||= get_default_for_property(property_name)
      if @attributes[property_name.to_s].is_a?(Array)
        @attributes[property_name.to_s] << ivar.attributes!
      else
        @attributes[property_name.to_s].merge! ivar.attributes!
      end
    end
  end

  def property_sender target, name, *args, &block
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
