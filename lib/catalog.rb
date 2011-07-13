class Catalog
  attr_reader :posters

  def initialize(posters=[])
    @posters = posters.each_with_index do |p, i|
      p.next = posters[(i+1) % posters.length]
      p.previous = posters[(i-1) % posters.length]
    end
  end

  def find_by_name(name)
    posters.find { |p| p.name.downcase == name.downcase }
  end

  def random
    @posters[rand(@posters.length)]
  end
end
