require_relative "../lib/immutable_assets"

describe ImmutableAssets do
  let(:downstream) { proc { |_env| [status, {"content-type" => "text/css"}, ["body"]] } }
  let(:status) { 200 }
  subject(:middleware) { ImmutableAssets.new(downstream) }

  def cache_control_for(path)
    _, headers, _ = middleware.call("PATH_INFO" => path)
    headers["cache-control"]
  end

  it "marks a fingerprinted stylesheet immutable" do
    expect(cache_control_for("/stylesheets/app-1a2b3c4d.css"))
      .to eq "public, max-age=31536000, immutable"
  end

  it "leaves an un-fingerprinted stylesheet alone" do
    expect(cache_control_for("/stylesheets/app.css")).to be_nil
  end

  it "leaves other static assets alone" do
    expect(cache_control_for("/fonts/fontawesome-webfont.woff")).to be_nil
  end

  it "leaves poster images alone" do
    expect(cache_control_for("/images/posters/success.png")).to be_nil
  end

  context "when the digest is not the expected length" do
    it "leaves the response alone" do
      expect(cache_control_for("/stylesheets/app-1a2b.css")).to be_nil
    end
  end

  context "when the response is not a 200" do
    let(:status) { 404 }

    it "does not promise a missing asset is cacheable forever" do
      expect(cache_control_for("/stylesheets/app-1a2b3c4d.css")).to be_nil
    end
  end
end
