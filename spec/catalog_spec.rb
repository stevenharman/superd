require_relative "../lib/catalog"
require_relative "../lib/poster"

describe Catalog do
  context "with posters" do
    subject(:catalog) { Catalog.new(posters) }
    let(:posters) { %w[foo.png bar.gif BAZ.jpg].collect { |f| Poster.new("images/posters/#{f}") } }

    it "retrieve a poster by name" do
      expect(catalog.find_by_name("bar")).to be_a Poster
    end

    it "retrieve a poster by name with mixed case" do
      expect(catalog.find_by_name("BaR")).to be_a Poster
    end

    it "retrieve a poster by name with wrong case" do
      expect(catalog.find_by_name("baz")).to be_a Poster
    end

    it "returns nil for non-existant posters" do
      expect(catalog.find_by_name("no-such-poster")).to be_nil
    end

    it "retrieve random poster" do
      expect(catalog.random).to be_a Poster
    end
  end
end
