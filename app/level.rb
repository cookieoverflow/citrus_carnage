class Level
  attr_accessor :player, :bullet_manager, :enemies

  def initialize
    self.player = Player.new(self)
    self.bullet_manager = BulletManager.new(enemies)
    self.enemies = []
  end

  def run(args)
    # Update, player, projectiles, enemy
    self.player.update(args)
    self.bullet_manager.update(args, self.player)

    # Draw backgrouns
    # Draw track/trees
    # Draw player
    self.player.draw(args)
    # Draw enemies
    # Draw player and enemy projectiles
    self.bullet_manager.draw(args)
  end
end