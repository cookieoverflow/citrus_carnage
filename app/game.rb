class Game
  attr_gtk
  attr_accessor :current_state

  def initialize
    self.current_state = StartScreen.new
  end

  def tick
    outputs.background_color = [0, 0, 0]
    self.current_state.run(args, self)
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