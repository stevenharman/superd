require 'active_support/all'

class Poster
  attr_reader :name, :path, :title
  attr_accessor :next, :previous

  def self.all(path)
    @poster_cache ||= {}
    @poster_cache[path] ||= FileSearchStrategy.call(path)
  end

  def initialize(path)
    raise ArgumentError.new('Must supply a path to the poster image') if path.blank?

    @path = path
    @name = File.basename(path, '.*')
    @title = name.titleize
  end

  FileSearchStrategy = Proc.new do |path|
    Dir.glob(File.join(path, '*.*')).collect { |p|
      Poster.new(p.gsub(/^public\//, '/'))
    }
  end
end
