require 'spec_helper'

describe 'superd' do

  describe 'looking at root' do
    before { get '/' }

    specify { last_response.should be_successful }
    specify { last_response.body.should include("Hello, Worlds!") }
  end

  describe 'looking at a specific poster', :type => :request do

    context 'that exists' do
      before { visit '/foo-bar' }

      it 'show the poster' do
        page.should have_selector('.poster img')
      end
    end
  end
end
