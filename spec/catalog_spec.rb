require_relative '../lib/catalog.rb'
require_relative '../lib/poster.rb'

describe Catalog do

  context 'with posters' do
    before do
      #Dir.stub(:glob).and_return(['public/images/posters/foo.png', 'public/images/posters/bar.jpg', 'public/images/posters/baz.gif'])
      posters = %w(foo.png bar.gif BAZ.jpg).collect { |f| Poster.new("images/posters/#{f}") }
      @catalog = Catalog.new(posters)
    end

    it 'can retrieve a poster by name' do
      @catalog.find_by_name('bar').should_not be_nil
    end

    it 'can retrieve a poster by name with mixed case' do
      @catalog.find_by_name('BaR').should_not be_nil
    end

    it 'can retrieve a poster by name with wrong case' do
      @catalog.find_by_name('baz').should_not be_nil
    end

    it 'returns nil for non-existant posters' do
      @catalog.find_by_name('no-such-poster').should be_nil
    end
  end
end