$game = Game.new

def tick args
  $gtk.warn_array_primitives!
  $game.args = args
  $game.tick
end

$gtk.reset