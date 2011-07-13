require_relative '../lib/catalog.rb'

describe Catalog do

  context 'a new catalog' do
    before do
      Dir.stub(:glob).and_return(['public/images/posters/foo.png', 'public/images/posters/bar.jpg', 'public/images/posters/baz.gif'])
      @catalog = Catalog.new
    end

    it 'populates itself with posters' do
      @catalog.posters.should have(3).items
    end

    it 'can retrieve a poster by name' do
      @catalog.find_by_name('bar').should_not be_nil
    end

    it 'can retrieve a poster by name regardless of case' do
      @catalog.find_by_name('BaR').should_not be_nil
    end

    it 'returns nil for non-existant posters' do
      @catalog.find_by_name('no-such-poster').should be_nil
    end
  end
end
