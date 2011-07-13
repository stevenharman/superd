require 'spec_helper'

describe 'helpers' do

  describe 'link_to_poster creates a link' do
    include LinkHelpers

    before do
      @poster = Poster.new("some/path/an-image.jpg")
      @link = link_to_poster(@poster, 'link text')
    end

    it 'with href of poster name' do
      @link.should include("href='/an-image'")
    end

    it 'with poster title' do
      @link.should include("title='An Image'")
    end

    it 'with content' do
      @link.should include(">link text</a>")
    end

  end
end
