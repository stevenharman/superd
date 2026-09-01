require "digest"
require "json"
require "pathname"
require "sass-embedded"

# Compiles the SCSS sources into minified, fingerprinted CSS on disk.
#
# In production we precompile at boot so Sinatra's static file handler serves
# the result straight from public/ - no Sass in the request path. Each file is
# named after a digest of its own contents (app-1a2b3c4d.css) and recorded in a
# manifest, so the URL changes whenever the CSS does. That's what makes it safe
# to cache the response forever; see ImmutableAssets.
#
# Development skips all of this and renders through the /stylesheets/:sheet.css
# route instead, so edits show up on reload.
class Stylesheets
  # Bourbon 4 and Font Awesome 4 predate modern Dart Sass; silence the
  # deprecations they trip so real warnings stay visible. Revisit if/when
  # those vendored stylesheets are upgraded.
  SILENCED_DEPRECATIONS = %w[
    color-functions
    elseif
    global-builtin
    if-function
    import
    slash-div
  ].freeze

  MANIFEST_NAME = "manifest.json"
  DIGEST_LENGTH = 8

  def initialize(source_dir:, output_dir:, url_prefix: "/stylesheets")
    @source_dir = Pathname(source_dir)
    @output_dir = Pathname(output_dir)
    @url_prefix = Pathname(url_prefix)
  end

  # Compiles every top-level *.css.scss source, returning the paths written.
  # Partials (_foo.scss) are pulled in via @import and never compiled alone.
  def precompile
    clean
    manifest = sources.to_h { |source| compile(source) }
    write_manifest(manifest)
    manifest.values.map { |name| @output_dir / name }
  end

  # Removes previously compiled output, so stale files can't accumulate or
  # shadow the dynamic route in development.
  def clean
    @manifest = nil
    stale = @output_dir.glob("*.css") + @output_dir.glob(MANIFEST_NAME)
    stale.each(&:delete)
    stale
  end

  # The public URL for a logical name ("app.css"). Falls back to the unhashed
  # path when nothing has been precompiled, which is the development case.
  def path_for(logical_name)
    String(@url_prefix / manifest.fetch(logical_name, logical_name))
  end

  def sources
    @source_dir.glob("*.css.scss").sort
  end

  private

  # Read once and memoized: in production the manifest is written before Puma
  # forks its workers, and it never changes while the process is alive.
  def manifest
    @manifest ||= begin
      JSON.parse(manifest_path.read)
    rescue Errno::ENOENT, JSON::ParserError
      {}
    end
  end

  def manifest_path
    @output_dir / MANIFEST_NAME
  end

  def compile(source)
    css = Sass.compile(
      String(source),
      load_paths: [String(@source_dir)],
      style: :compressed,
      silence_deprecations: SILENCED_DEPRECATIONS
    ).css

    logical_name = source.basename(".scss")
    fingerprinted = fingerprint(logical_name, css)

    @output_dir.mkpath
    (@output_dir / fingerprinted).write(css)

    [String(logical_name), String(fingerprinted)]
  end

  def fingerprint(logical_name, css)
    digest = Digest::SHA256.hexdigest(css)[0, DIGEST_LENGTH]
    logical_name.sub_ext("-#{digest}#{logical_name.extname}")
  end

  def write_manifest(manifest)
    @output_dir.mkpath
    manifest_path.write(JSON.pretty_generate(manifest))
    @manifest = manifest
  end
end
