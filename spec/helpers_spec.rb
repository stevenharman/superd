require 'spec_helper'

describe 'helpers' do

  describe 'link_to_poster creates a link' do
    include LinkHelpers

    subject(:link) { link_to_poster(poster, 'link text', :class => 'blurgh foo', :'data-x' => '2') }
    let(:poster) { Poster.new("some/path/an-image.jpg") }

    it 'with href of poster name' do
      expect(link).to include("href='/an-image'")
    end

    it 'with poster title' do
      expect(link).to include("title='An Image'")
    end

    it 'with content' do
      expect(link).to include(">link text</a>")
    end

    it 'with optional attributes' do
      expect(link).to include("class='blurgh foo' data-x='2'")
    end

  end
end
