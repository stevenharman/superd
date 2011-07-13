require_relative '../lib/poster.rb'

describe Poster do

  context 'a new poster' do
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
end
