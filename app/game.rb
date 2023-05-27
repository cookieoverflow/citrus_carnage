class Game
  attr_gtk
  attr_accessor :level

  def initialize
    self.level = Level.new
  end

  def tick
    outputs.background_color = [0, 0, 0]
    self.level.run(args)
  end

  def serialize
    { level: @level }
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end