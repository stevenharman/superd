require "spec_helper"

describe "superd" do
  let(:poster) { Poster.new("some/path/image.gif") }
  before do
    poster.next = poster.previous = Poster.new("some/path/other.png")
  end

  describe "when visiting the root" do
    before do
      poster.next = poster.previous = Poster.new("some/path/other.png")
      allow_any_instance_of(Catalog).to receive(:random).and_return(poster)
      get "/"
    end

    it { expect(last_response).to be_successful }
    it { expect(last_response.body).to include(poster.path) }
  end

  describe "when looking at a poster" do
    context "that exists" do
      before do
        allow_any_instance_of(Catalog).to receive(:find_by_name).and_return(poster)
        get "/#{poster.name}"
      end

      it { expect(last_response).to be_successful }

      it "show the poster" do
        expect(last_response.body).to include(poster.path)
      end
    end

    context "that doesn't exist" do
      before do
        get "/no-such-poster"
      end

      it { expect(last_response.status).to eq(404) }
    end
  end
end
