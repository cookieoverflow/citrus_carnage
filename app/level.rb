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

  def run(args, game)
    args.state.secs ||= 0
    args.state.secs += 1 if args.state.tick_count % 60 == 0

    if self.pause
      self.upgrade_manager.update(args)
    else
      self.trees.update(args)
      self.player.update(args)
      self.bullet_manager.update(args, self.player)
      self.enemy_manager.update(args)
      self.level_manager.update(args, player)
      self.bar_fill.w = (self.bar_border.w / 100) * args.state.hp
    end

    args.outputs.sprites << { x: 0, y: -16, w: 1280, h: 736, path: 'sprites/bg.png' }
    self.bullet_manager.draw(args)
    self.player.draw(args)
    self.enemy_manager.draw(args)
    self.trees.draw(args)
    self.level_manager.draw(args)

    # Draw health bar
    args.outputs.sprites << self.bar_fill
    args.outputs.borders << self.bar_border
    args.outputs.labels << { text: "Trees left: #{args.state.hp}", x: ORIGIN.x, y: 65, r: 255, g: 255, b: 255, alignment_enum: 1, font: "fonts/joystix.ttf" }

    # Draw timer
    secs = args.state.secs % 60
    mins = args.state.secs / 60
    sec_string = secs < 10 ? "0#{secs}" : "#{secs}"
    min_string = mins < 10 ? "0#{mins.to_i}" : "#{mins}"
    args.outputs.labels << { text: "#{min_string}:#{sec_string}", x: 1200, y: 720, r: 255, g: 255, b: 255, alignment_enum: 1, size_enum: 8, font: "fonts/joystix.ttf" }

    # Spawn lots of enemies once over 5 minutes
    if mins > 5
      klass = self.enemy_manager.current_spawn_group.sample
      if arg.state.secs % (5 * 60) == 0
        self.enemy_manager.spawn_enemy(klass, 20)
      elsif arg.state.secs % (5 * 60 + 15) == 0
        self.enemy_manager.spawn_enemy(klass, 20)
      elsif arg.state.secs % (5 * 60 + 30) == 0
        self.enemy_manager.spawn_enemy(klass, 20)
      elsif arg.state.secs % (5 * 60 + 45) == 0
        self.enemy_manager.spawn_enemy(klass, 20)
      end
    end

    if self.pause
      self.upgrade_manager.draw(args)
    end

    if args.state.hp <= 0
      args.audio[:bg] = nil
      game.current_state = GameOver.new
    end
  end

  def show_upgrades
    self.pause = true
    self.upgrade_manager.enter
  end
end