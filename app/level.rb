class Level
  attr_accessor :player

  def initialize
    self.player = Player.new
  end

  def run(args)
    # Update, player, projectiles, enemy
    self.player.update(args)

    # Draw backgrouns
    # Draw track/trees
    # Draw player
    self.player.draw(args)
    # Draw enemies
    # Draw player and enemy projectiles
  end
end