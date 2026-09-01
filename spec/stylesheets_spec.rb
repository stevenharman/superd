require "pathname"
require "tmpdir"
require_relative "../lib/stylesheets"

describe Stylesheets do
  around do |example|
    Dir.mktmpdir do |dir|
      @source_dir = Pathname(dir) / "assets"
      @output_dir = Pathname(dir) / "public" / "stylesheets"
      @source_dir.mkpath
      example.run
    end
  end

  subject(:stylesheets) { Stylesheets.new(source_dir: @source_dir, output_dir: @output_dir) }

  def write_source(name, scss)
    (@source_dir / name).write(scss)
  end

  def compiled_files
    @output_dir.glob("*.css").map { |path| String(path.basename) }
  end

  def compiled_css
    (@output_dir / compiled_files.first).read
  end

  describe "#sources" do
    it "ignores partials, which are only ever @imported" do
      write_source("app.css.scss", "a { color: red; }")
      write_source("_variables.scss", "$x: 1px;")

      expect(stylesheets.sources.map { |s| String(s.basename) }).to contain_exactly("app.css.scss")
    end
  end

  describe "#precompile" do
    before { write_source("app.css.scss", "a { color: red; }") }

    it "compiles SCSS to a fingerprinted file" do
      stylesheets.precompile

      expect(compiled_files).to match [/\Aapp-\h{8}\.css\z/]
    end

    it "compiles the SCSS rather than copying it" do
      stylesheets.precompile

      expect(compiled_css).to include("color:red")
    end

    it "minifies the output" do
      stylesheets.precompile

      expect(compiled_css).to eq "a{color:red}"
    end

    it "records the logical name in the manifest" do
      stylesheets.precompile

      manifest = JSON.parse((@output_dir / Stylesheets::MANIFEST_NAME).read)
      expect(manifest["app.css"]).to match(/\Aapp-\h{8}\.css\z/)
    end

    it "resolves @import of a partial" do
      write_source("_variables.scss", "$blueish: #0087ff;")
      write_source("app.css.scss", "@import 'variables'; a { color: $blueish; }")

      stylesheets.precompile

      expect(compiled_css).to include("#0087ff")
    end
  end

  describe "fingerprinting" do
    it "gives identical content the same digest" do
      write_source("app.css.scss", "a { color: red; }")

      first = stylesheets.precompile
      second = stylesheets.precompile

      expect(second).to eq first
    end

    it "gives changed content a different digest" do
      write_source("app.css.scss", "a { color: red; }")
      before_digest = stylesheets.precompile

      write_source("app.css.scss", "a { color: blue; }")
      after_digest = stylesheets.precompile

      expect(after_digest).to_not eq before_digest
    end

    it "does not leave the superseded file behind" do
      write_source("app.css.scss", "a { color: red; }")
      stylesheets.precompile

      write_source("app.css.scss", "a { color: blue; }")
      stylesheets.precompile

      expect(compiled_files.length).to eq 1
    end
  end

  describe "#path_for" do
    it "returns the fingerprinted path once precompiled" do
      write_source("app.css.scss", "a { color: red; }")
      stylesheets.precompile

      expect(stylesheets.path_for("app.css")).to match(%r{\A/stylesheets/app-\h{8}\.css\z})
    end

    it "falls back to the plain path when nothing is precompiled" do
      expect(stylesheets.path_for("app.css")).to eq "/stylesheets/app.css"
    end

    it "falls back for a name missing from the manifest" do
      write_source("app.css.scss", "a { color: red; }")
      stylesheets.precompile

      expect(stylesheets.path_for("nope.css")).to eq "/stylesheets/nope.css"
    end
  end

  describe "#clean" do
    it "removes the compiled output and manifest" do
      write_source("app.css.scss", "a { color: red; }")
      stylesheets.precompile

      stylesheets.clean

      expect(@output_dir.glob("*")).to be_empty
    end

    it "sends path_for back to the un-fingerprinted fallback" do
      write_source("app.css.scss", "a { color: red; }")
      stylesheets.precompile
      stylesheets.clean

      expect(stylesheets.path_for("app.css")).to eq "/stylesheets/app.css"
    end
  end
end
