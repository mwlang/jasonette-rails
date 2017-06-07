RSpec.describe Jasonette::Map do

  it "#components" do
    results = build_with(described_class) do
      pins do
        title "Pin 1"
        coord "40.7197614,-73.9909211"
        style do
          align "right"
        end
      end
      pins do
        title "Pin 2"
        coord "40.7197614,-73.9909211"
      end
      style do
        align "right"
      end
    end

    expect(results).to eqj "pins" => [
      {"title"=>"Pin 1", "coord"=>"40.7197614,-73.9909211", "style"=>{"align"=>"right"}},
      {"title"=>"Pin 2", "coord"=>"40.7197614,-73.9909211"}],
      "style" => {"align"=>"right"}
  end
end
