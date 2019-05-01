require "active_support/all"

class Poster
  attr_reader :name, :path, :title
  attr_accessor :next, :previous

  def self.all(path)
    @poster_cache ||= {}
    @poster_cache[path] ||= PublicFileStrategy.call(path)
  end

  def initialize(path)
    raise ArgumentError.new("Must supply a path to the poster image") if path.nil?

    path = Pathname(path)
    @path = String(path)
    @name = String(path.basename(".*"))
    @title = name.titleize
  end

  PublicFileStrategy = proc { |path|
    Pathname(path).children
      .select(&VisibleFile)
      .collect { |p| Poster.new(p.sub(/^public\//, "/")) }
  }

  VisibleFile = proc { |pathname|
    pathname.file? && !pathname.basename.fnmatch?(".*")
  }
end
