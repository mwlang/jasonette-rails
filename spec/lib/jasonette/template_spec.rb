RSpec.describe Jasonette::Template do
  let(:builder) { build_with(described_class) }

  context "$jason" do
    it "#jason with head and title" do
      results = build_with(described_class) do
        head do
          title "Foobar"
        end
      end

      expect(results).to eqj "{\"$jason\":{\"head\":{\"title\":\"Foobar\"}}}"
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head do
          title "Head"
        end
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head"}})
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head do
          title "Head"
          foo "bar"
        end
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head", "foo" => "bar"}})
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head.title "Head"
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head"}})
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head.title "Head"
        head.foo "bar"
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head", "foo" => "bar"}})
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head.title "Head"
        body do
          header.title "Header"
        end
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head"}, "body" => {"header" => {"title" => "Header"}}})
    end

    it "#jason with head and title" do
      build = build_with(described_class) do
        head.title "Head"
        body.header.title "Header"
      end
      expect(build).to eqj("$jason" => {"head" => {"title" => "Head"}, "body" => {"header" => {"title" => "Header"}}})
    end
  end

end
