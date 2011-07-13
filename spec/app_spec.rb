require 'spec_helper'

describe 'superd' do

  describe 'when visiting the root' do
    before { get '/' }

    it { last_response.should be_successful }
    it { last_response.body.should include("Hello, Worlds!") }
  end

  describe 'when looking at a poster' do

    context 'that exists' do
      before do
        @poster = Poster.new('some/path/image.gif')
        Catalog.any_instance.stub(:find_by_name).and_return(@poster)
        get "/#{@poster.name}"
      end

      it { last_response.should be_successful }

      it 'show the poster' do
        last_response.body.should include(@poster.path)
      end
    end

    context "that doesn't exist" do
      before { get '/no-such-poster' }

      it { last_response.status.should be 404 }
    end

  end
end
