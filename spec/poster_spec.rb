require_relative '../lib/poster.rb'

describe Poster do

  describe 'a new poster' do
    it 'requires a path to the image' do
      expect { Poster.new }.to raise_error ArgumentError
    end

    context 'with a path to the image' do
      before { @poster = Poster.new('images/posters/foo-bar.png') }

      it { @poster.name.should == 'foo-bar' }
      it { @poster.path.should == 'images/posters/foo-bar.png'}
      it { @poster.title.should == 'Foo Bar' }
    end
  end

  describe '#all, given a path to images' do
    before do
      Dir.stub(:glob).and_return(['public/images/posters/FOO.png', 'public/images/posters/bar.jpg', 'public/images/posters/baz.gif'])
      @posters = Poster.all('public/images/posters/')
    end

    it { @posters.should have(3).items }

    it 'strip leading public directory from path' do
      @posters.each { |p| p.path.should_not match(/^public\//)}
    end
  end
end
