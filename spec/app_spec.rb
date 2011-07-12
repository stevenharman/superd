require 'spec_helper'

describe 'superd' do

  describe 'looking at root' do
    before { get '/' }

    it { last_response.should be_successful }
    it { last_response.body.should include("Hello, Worlds!") }
  end

  describe 'looking at a specific poster' do

    context 'that exists', :type => :request do
      before { visit '/foo-bar' }

      it 'show the poster' do
        page.should have_selector(".poster img[src='foo-bar.png']")
      end
    end

    context "that doesn't exist" do
      before { get '/no-such-poster' }

      xit { last_response.status.should be 404 }
    end

  end
end
