class Level
  attr_accessor :player, :bullet_manager, :enemy_manager

  def initialize
    self.player = Player.new(self)
    self.enemy_manager = EnemyManager.new()
    self.bullet_manager = BulletManager.new(self.enemy_manager.enemies)
  end

  def run(args)
    # Update, player, projectiles, enemy
    self.player.update(args)
    self.bullet_manager.update(args, self.player)
    self.enemy_manager.update(args)

    args.outputs.debug.labels << { text: "Health: #{args.state.hp}", x: 10, y: 680, r:255, g:255, b:255 }

    # Draw backgrouns
    # Draw track/trees
    # Draw player
    self.player.draw(args)
    # Draw enemies
    # Draw player and enemy projectiles
    self.bullet_manager.draw(args)
    self.enemy_manager.draw(args)
  end
end