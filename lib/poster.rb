require 'active_support/all'

class Poster
  attr_reader :name, :path, :title
  attr_accessor :next, :previous

  def self.all(path)
    @poster_cache ||= {}
    @poster_cache[path] ||= PublicFileStrategy.call(path)
  end

  def initialize(path)
    raise ArgumentError.new('Must supply a path to the poster image') if path.blank?

    @path = path
    @name = File.basename(path, '.*')
    @title = name.titleize
  end

  PublicFileStrategy = Proc.new do |path|
    Pathname.new(path).children
      .select(&VisibleFile)
      .collect { |p| Poster.new(p.sub(/^public\//, '/')) }
  end

  VisibleFile = Proc.new do |pathname|
    pathname.file? && !pathname.basename.fnmatch?('.*')
  end
end
