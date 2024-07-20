describe "helpers" do
  describe "link_to_poster creates a link" do
    class FakeApp # rubocop:disable Lint/ConstantDefinitionInBlock
      include App::LinkHelpers

      # When exectued w/in a running Sinatra app the `#url` method depends on a
      # live request. We don't have one, so fake the whole thing.
      def url(path)
        path
      end
    end

    subject(:link) { fake_app.link_to_poster(poster, "link text", class: "blurgh foo", "data-x": "2") }
    let(:fake_app) { FakeApp.new }
    let(:poster) { Poster.new("some/path/an-image.jpg") }

    it "with href of poster name" do
      expect(link).to include("href='/an-image'")
    end

    it "with poster title" do
      expect(link).to include("title='An Image'")
    end

    it "with content" do
      expect(link).to include(">link text</a>")
    end

    it "with optional attributes" do
      expect(link).to include("class='blurgh foo' data-x='2'")
    end
  end
end
