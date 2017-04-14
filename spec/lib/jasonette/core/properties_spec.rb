RSpec.describe Jasonette::Properties do

  class MockBuilder
    attr_accessor :attributes

    def initialize
      @attributes = {}
    end

    def method_missing name, *args, &block
      property_set! name, *args, &block
    end

    def attributes!
      merge_properties
      @attributes
    end
  end

  # context "no properties" do
  #   class FooBuilder
  #     include Jasonette::Properties
  #   end
  #
  #   let(:builder) { FooBuilder.new }
  #
  #   subject { builder }
  #
  #   its(:properties) { is_expected.to be_empty }
  #   its(:properties_empty?) { is_expected.to be true }
  # end

  context "one property" do
    class BarBuilder < MockBuilder
      include Jasonette::Properties
      property :bar
    end

    let(:builder) { BarBuilder.new }

    require 'pry'

    context "bar { type 'foo' }" do
      subject do
        builder.bar { type 'foo' }
        builder
      end

      its(:properties) { is_expected.to_not be_empty }
      its(:properties) { is_expected.to include :bar }
      its(:attributes!) { is_expected.to eq({"bar" => {"type"=>"foo"}}) }
      its(:properties_empty?) { is_expected.to be false }
      it "instantiates a builder class" do
        expect(builder.bar).to be_a Jasonette::Base
      end
    end

    context "bar.type 'baz'" do
      subject { builder.bar.type 'baz'; builder }

      its(:properties) { is_expected.to_not be_empty }
      its(:properties) { is_expected.to include :bar }
      its(:attributes!) { is_expected.to eq({"bar" => {"type"=>"baz"}}) }
      its(:properties_empty?) { is_expected.to be false }
      it "instantiates a builder class" do
        expect(builder.bar).to be_a Jasonette::Base
      end
    end

    context "bar=nil" do
      subject { builder }

      its(:properties) { is_expected.to_not be_empty }
      its(:properties) { is_expected.to include :bar }
      its(:properties_empty?) { is_expected.to be true }
    end
  end

  context "#super_property" do
    class BarBuilder < MockBuilder
      include Jasonette::Properties
      property :bar
    end

    class FooBuilder < BarBuilder
      super_property
      property :foo
    end

    subject { FooBuilder.new }

    its(:properties) { is_expected.to include :bar, :foo }
  end

end
