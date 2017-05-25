RSpec.describe Jasonette::Body::Layers do

  context "labels" do
    it "builds multiple label with style" do
      build = build_with(described_class) do
        label "one" do
          style do
            top "100"
            left "50%-25"
          end
        end
        label "two"
      end

      expect(build).to eqj [
        {"text"=>"one", "type"=>"label", "style"=>{"top"=>"100", "left"=>"50%-25"}},
        {"text"=>"two", "type"=>"label"}
      ]
    end
  end
end
