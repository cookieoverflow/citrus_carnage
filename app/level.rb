class Level
  attr_accessor :player, :bullet_manager, :enemy_manager, :level_manager, :bar_fill, :bar_border

  def initialize
    self.player = Player.new(self)
    self.enemy_manager = EnemyManager.new()
    self.bullet_manager = BulletManager.new(self.enemy_manager.enemies)
    self.level_manager = LevelManager.new
    self.bar_border = { x: ORIGIN.x - 300, y: 40, w: 600, h: 30, r: 255, g: 255, b: 255 }
    self.bar_fill = { x: ORIGIN.x - 300, y: 40, w: 0, h: 30, r: 180, g: 0, b: 0, path: 'sprites/health_fill.png' }
  end

  def run(args)
    # Update, player, projectiles, enemy
    self.player.update(args)
    self.bullet_manager.update(args, self.player)
    self.enemy_manager.update(args)
    self.level_manager.update(args, player)
    self.bar_fill.w = (self.bar_border.w / 100) * args.state.hp

    # Draw background
    # Draw track/trees
    args.outputs.sprites << { x: 0, y: -16, w: 1280, h: 736, path: 'sprites/bg.png' }
    self.player.draw(args)
    self.bullet_manager.draw(args)
    self.enemy_manager.draw(args)
    self.level_manager.draw(args)

    # Draw health bar
    args.outputs.sprites << self.bar_fill
    args.outputs.borders << self.bar_border
    args.outputs.labels << { text: "Trees left: #{args.state.hp}", x: ORIGIN.x, y: 65, r: 255, g: 255, b: 255, alignment_enum: 1, font: "fonts/joystix.ttf" }
  end
end