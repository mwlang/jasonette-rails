RSpec.describe Jasonette do
  it 'setup block yields self' do
    described_class.setup do |config|
      expect(config).to be described_class
    end
  end

  it 'multi_json block yields MultiJson' do
    described_class.multi_json do |config|
      expect(config).to be MultiJson
    end
  end
end