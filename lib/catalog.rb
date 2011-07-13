class Catalog
  attr_reader :posters

  def initialize(posters=[])
    @posters = posters
  end

  def find_by_name(name)
    posters.find { |p| p.name.downcase == name.downcase }
  end
end
