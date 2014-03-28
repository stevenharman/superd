require_relative '../lib/poster.rb'

describe Poster do

  describe 'a new poster' do
    it 'requires a path to the image' do
      expect { Poster.new }.to raise_error ArgumentError
    end

    context 'with a path to the image' do
      subject(:poster) { Poster.new('images/posters/foo-bar.png') }

      it { expect(poster.name).to eq('foo-bar') }
      it { expect(poster.path).to eq('images/posters/foo-bar.png')}
      it { expect(poster.title).to eq('Foo Bar') }
    end
  end

  describe '#all, given a path to images' do
    subject(:posters) { Poster.all('public/images/posters/') }

    before do
      allow(Poster::FileSearchStrategy).to receive(:call).and_return([
        Poster.new('FOO.png'), Poster.new('bar.jpg'), Poster.new('baz.gif')])
    end

    it { expect(posters.size).to eq(3) }

  end

  describe Poster::FileSearchStrategy do
    subject(:posters) { Poster.all('public/images/posters/') }

    before do
      allow(Dir).to receive(:glob).and_return([
        'public/images/posters/FOO.png',
        'public/images/posters/bar.jpg',
        'public/images/posters/baz.gif'])
    end

    it 'strip leading public directory from path' do
      posters.each { |p| expect(p.path).not_to match(/^public\//)}
    end
  end
end
