class Catalog
  attr_reader :posters

  def initialize()
    @posters = Dir.glob("public/images/posters/*")
  end

  def find_by_name(name)
    posters.find { |p| File.basename(p, '.*') == name.downcase }
  end
end
