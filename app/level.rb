class Level
  attr_accessor :player, :bullet_manager, :enemy_manager, :level_manager, :upgrade_manager, 
    :bar_fill, :bar_border, :pause, :trees

  def initialize
    self.player = Player.new(self)
    self.enemy_manager = EnemyManager.new(self)
    self.bullet_manager = BulletManager.new(self)
    self.level_manager = LevelManager.new(self)
    self.upgrade_manager = UpgradeManager.new(self)
    self.trees = Trees.new
    self.bar_border = { x: ORIGIN.x - 300, y: 40, w: 600, h: 30, r: 255, g: 255, b: 255 }
    self.bar_fill = { x: ORIGIN.x - 300, y: 40, w: 0, h: 30, r: 180, g: 0, b: 0, path: 'sprites/health_fill.png' }
    self.pause = false
  end

  def run(args)
    if self.pause
      self.upgrade_manager.update(args)
    else
      self.player.update(args)
      self.bullet_manager.update(args, self.player)
      self.enemy_manager.update(args)
      self.level_manager.update(args, player)
      self.bar_fill.w = (self.bar_border.w / 100) * args.state.hp
    end

    args.audio[:bg] ||= {
      input: 'sounds/bg.wav',  # Filename
      # x: 0.0, y: 0.0, z: 0.0,   # Relative position to the listener, x, y, z from -1.0 to 1.0
      gain: 0.4,                # Volume (0.0 to 1.0)
      pitch: 1.0,               # Pitch of the sound (1.0 = original pitch)
      paused: false,            # Set to true to pause the sound at the current playback position
      looping: true,           # Set to true to loop the sound/music until you stop it
    }

    args.outputs.sprites << { x: 0, y: -16, w: 1280, h: 736, path: 'sprites/bg.png' }
    self.player.draw(args)
    self.bullet_manager.draw(args)
    self.enemy_manager.draw(args)
    self.trees.draw(args)
    self.level_manager.draw(args)

    # Draw health bar
    args.outputs.sprites << self.bar_fill
    args.outputs.borders << self.bar_border
    args.outputs.labels << { text: "Trees left: #{args.state.hp}", x: ORIGIN.x, y: 65, r: 255, g: 255, b: 255, alignment_enum: 1, font: "fonts/joystix.ttf" }
  
    if self.pause
      self.upgrade_manager.draw(args)
    end
  end

  def show_upgrades
    self.pause = true
    self.upgrade_manager.enter
  end
end