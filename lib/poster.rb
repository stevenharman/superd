require 'active_support/all'

class Poster
  attr_reader :name, :path, :title

  def initialize(path)
    raise ArgumentError.new('Must supply a path to the poster image') if path.blank?

    @path = path
    @name = File.basename(path, '.*')
    @title = name.titleize
  end

  def self.all(path)
    @all_posters || Dir.glob(File.join(path, '*.*')).collect { |p| Poster.new(p.gsub(/^public\//, '/')) }
  end
end
