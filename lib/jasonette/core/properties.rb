module Jasonette::Properties
  module ClassMethods
    def property name
      properties << name
    end

    def properties
      @properties ||= []
    end
  end

  def self.included base
    base.send :extend, ClassMethods
  end

  def properties
    self.class.properties
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
    ivar_name = "@#{name}"
    if instance_variable_get(ivar_name).nil?
      klass = klass_for_property name
      instance_variable_set(ivar_name, klass.new(@context))
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
      ivar = instance_variable_get(:"@#{property_name}")
      next if ivar.nil? || ivar.empty?
      @attributes[property_name.to_s] ||= {}
      @attributes[property_name.to_s].merge! ivar.attributes!
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
