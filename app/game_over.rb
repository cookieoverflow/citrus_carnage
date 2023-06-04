class GameOver
  def initialize
    @started = true
    @message = "e\nIt is know the time of the insects!!"
  end
  def run(args, game)
    if @started
      args.audio[:game_over] ||= { input: 'sounds/game_over.mp3' }
      @started = false
    end
    
    if args.inputs.keyboard.key_down.enter
      args.audio[:game_over] = nil
      game.current_state = StartScreen.new
    end

    args.outputs.background_color = { r: 0, g: 0, b: 0 }
    args.outputs.labels << { x: ORIGIN.x, y: 650, text: 'Game Over', font: "fonts/joystix.ttf", alignment_enum: 1, size_enum: 48, r: 255, g: 255, b: 255 }
    args.outputs.labels << { x: ORIGIN.x, y: 500, text: 'Know that doom was inevitable', font: "fonts/joystix.ttf", alignment_enum: 1, size_enum: 10, r: 255, g: 255, b: 255 }
    args.outputs.labels << { x: ORIGIN.x, y: 460, text: 'It is now the time of the insects!!', font: "fonts/joystix.ttf", alignment_enum: 1, size_enum: 10, r: 255, g: 255, b: 255 }
    args.outputs.sprites << { x: ORIGIN.x - 220, y: 120, w: 440, h: 288, path: 'sprites/game_over_ant.png' }
    args.outputs.labels << { x: ORIGIN.x, y: 100, text: 'Press enter to go back to the main menu.', font: "fonts/joystix.ttf", alignment_enum: 1, size_enum: 10, r: 255, g: 255, b: 255 }
  end
end