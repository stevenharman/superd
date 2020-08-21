require_relative "../lib/poster.rb"

describe Poster do
  describe "a new poster" do
    it "requires a path to the image" do
      expect { Poster.new }.to raise_error ArgumentError
    end

    context "with a path to the image" do
      subject(:poster) { Poster.new("images/posters/foo-bar.png") }

      it { expect(poster.name).to eq("foo-bar") }
      it { expect(poster.path).to eq("images/posters/foo-bar.png") }
      it { expect(poster.title).to eq("Foo Bar") }
    end
  end

  describe "::all, given a path to images" do
    it "to find all posters at the path" do
      allow(Poster::PublicFileStrategy).to receive(:call).with("public/images/posters/") {
        [Poster.new("FOO.png"), Poster.new("bar.jpg")]
      }

      posters = Poster.all("public/images/posters/")
      expect(posters.size).to eq(2)
    end

    it "caches posters for the path" do
      expect(Poster::PublicFileStrategy).to(receive(:call).with("public/images/x").once) { [:poster] }
      Poster.all("public/images/x")
      Poster.all("public/images/x")
    end
  end

  describe Poster::PublicFileStrategy do
    subject(:strategy) { Poster::PublicFileStrategy.call("public/images/posters") }
    let(:posters) { strategy.to_a }

    it "strip leading public directory from path" do
      expect(posters).not_to be_empty
      posters.to_a.each { |p| expect(p.path).not_to match(/^public\//) }
    end
  end

  describe Poster::VisibleFile do
    subject(:filter) { Poster::VisibleFile }
    let(:fixtures) { Pathname.new(__FILE__).dirname.join("support/fixtures") }

    it "includes files" do
      path = fixtures.join("a-file.txt")
      expect(filter.call(path)).to be true
    end

    it "excludes directories" do
      expect(filter.call(fixtures)).to be false
    end

    it "excludes hidden (dot) files" do
      path = fixtures.join(".text-hidden-file")
      expect(filter.call(path)).to be false
    end
  end
end
