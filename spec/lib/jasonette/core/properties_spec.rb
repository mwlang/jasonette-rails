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

      its(:property_names) { is_expected.to_not be_empty }
      its(:property_names) { is_expected.to include :bar }
      its(:attributes!) { is_expected.to eq({"bar" => {"type"=>"foo"}}) }
      its(:properties_empty?) { is_expected.to be false }
      it "instantiates a builder class" do
        expect(builder.bar).to be_a Jasonette::Base
      end
    end

    context "bar.type 'baz'" do
      subject { builder.bar.type 'baz'; builder }

      its(:property_names) { is_expected.to_not be_empty }
      its(:property_names) { is_expected.to include :bar }
      its(:attributes!) { is_expected.to eq({"bar" => {"type"=>"baz"}}) }
      its(:properties_empty?) { is_expected.to be false }
      it "instantiates a builder class" do
        expect(builder.bar).to be_a Jasonette::Base
      end
    end

    context "bar=nil" do
      subject { builder }

      its(:property_names) { is_expected.to_not be_empty }
      its(:property_names) { is_expected.to include :bar }
      its(:properties_empty?) { is_expected.to be true }
    end
  end

  context "#super_property" do
    class FooBuilder < BarBuilder
      super_property
      property :foo
    end

    subject { FooBuilder.new }

    its(:property_names) { is_expected.to include :bar, :foo }
  end

  describe "Method" do
    let(:builder) { build_with(Jasonette::Base) }
    describe "#set!" do
      it "build key/values that are not easily expressed as method" do
        build = builder.encode do
          set! "color:disabled", "1100"
        end
        expect(build).to eqj "color:disabled"=>"1100"
      end

      it "build any simple value as string" do
        build = builder.encode do
          set! "color", 1
        end
        expect(build).to eqj "color"=>"1"
      end

      context "with Jasonette instance" do
        it "build instance attributrs!" do
          _builder = build_with(Jasonette::Jason).encode do
            color "1100"
          end
          build = builder.encode do
            set! "head", _builder
          end
          expect(build).to eqj "head" => {"color"=>"1100"}
        end
      end

      context "with Block" do
        it "build its content" do
          build = builder.encode do
            set! "color" do
              white "000000"
              black "fffff"
            end  
          end
          expect(build).to eqj "color" => {"white"=>"000000", "black"=>"fffff"}
        end

        context "having argument as collection" do  
          it "build its content with Array values" do
            build = builder.encode do
              set! "color", [{ encode: "000000", name: "white" }, { encode: "fffff", name: "black" }] do |color|
                set! color[:name], color[:encode]
              end  
            end
            expect(build).to eqj "color" => [{"white"=>"000000"}, {"black"=>"fffff"}]
          end

          it "build its content with Hash values" do
            build = builder.encode do
              set! "color", { "white"=>"000000", "black"=>"fffff" } do |color_name, encode|
                set! color_name, encode
              end  
            end
            expect(build).to eqj "color" => [{"white"=>"000000"}, {"black"=>"fffff"}]
          end
        end
      end

      context "without Block" do
        it "build collection" do
          build = builder.encode do
            set! "color", [{ encode: "000000", name: "white" }, { encode: "fffff", name: "black" }], :encode, :name
          end
          expect(build).to eqj "color" => [{"encode"=>"000000", "name"=>"white"}, {"encode"=>"fffff", "name"=>"black"}]
        end
      end  
    end 

    describe "#merge!" do
      context "with hash having symbolised key, integer value" do
        it "build hash key/value in string" do
          build = builder.encode do
            merge! title: "foo", "color" => "1100", file: 1 
          end
          expect(build).to eqj "title"=>"foo", "color"=>"1100", "file"=>"1"
        end
      end

      context "with Jasonette instance" do
        it "build attributrs" do
          _builder = build_with(Jasonette::Jason).encode do
            color "1100"
          end
          build = builder.encode do
            merge! _builder
          end
          expect(build).to eqj "color"=>"1100"
        end
      end
    end
  end
end
