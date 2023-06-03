class Game
  attr_gtk
  attr_accessor :current_state

  def initialize
    self.current_state = StartScreen.new
  end

  def tick
    args.state.screenshot_counter ||= 1
    if inputs.keyboard.key_down.p
      args.outputs.screenshots << {
        x: 0, y: 0, w: WIDTH, h: HEIGHT,
        path: "screenshot#{args.state.screenshot_counter}.png"
      }
      args.state.screenshot_counter += 1
    end

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