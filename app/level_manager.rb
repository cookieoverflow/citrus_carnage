class LevelManager
  attr_accessor :collected, :required, :pickups, :pickup_messages, :bar_border, :bar_fill,
    :current_level, :game_level
  
  def initialize(game_level)
    self.collected = 0
    self.required = 5
    self.pickups = []
    self.pickup_messages = []
    self.bar_border = { x: ORIGIN.x - 300, y: 10, w: 600, h: 30, r: 255, g: 255, b: 255 }
    self.bar_fill = { x: ORIGIN.x - 300, y: 10, w: 0, h: 30, r: 0, g: 0, b: 180, path: 'sprites/level_fill.png' }
    self.current_level = 1
    self.game_level = game_level
  end

  def update(args, player)
    if self.collected >= self.required
      self.current_level += 1

      if self.current_level > 4 && self.game_level.enemy_manager.current_spawn_group == :easy
        self.game_level.enemy_manager.spawn_rate = 180
        self.game_level.enemy_manager.current_spawn_group = :medium
      elsif self.current_level > 8 && self.game_level.enemy_manager.current_spawn_group = :medium 
        self.game_level.enemy_manager.spawn_rate = 130
        self.game_level.enemy_manager.current_spawn_group = :hard
      elsif self.current_level > 12 && self.current_level <= 16
        self.game_level.enemy_manager.spawn_rate = 100
        self.game_level.enemy_manager.current_spawn_group = :hard
      elsif self.current_level > 16
        self.game_level.enemy_manager.spawn_rate = 80
        self.game_level.enemy_manager.current_spawn_group = :hard
      end
      
      self.collected = 0
      self.required = (self.required * 1.4).to_i
      args.audio[:level_up] = { input: 'sounds/level_up.wav', gain: 0.8 }
      self.game_level.show_upgrades
    end

    self.pickups.each do |pickup| 
      pickup.update(args, player, self)
    end

    self.pickup_messages.each do |message|
      message.y += 1
      message.delete = true if message.y > message.target
    end

    if args.state.repel
      args.state.repel_circle.radius += 2
      if args.state.repel_circle.radius > args.state.repel_circle.target_radius
        args.state.repel = false
      end
    end

    self.bar_fill.w = (self.bar_border.w / self.required) * self.collected
  end

  def draw(args)
    self.pickups.each { |pickup| pickup.draw(args) }
    self.pickup_messages.each { |message| args.outputs.labels << message unless message[:delete] }
    if args.state.repel
      circle = args.state.repel_circle
      args.outputs.sprites << { x: circle.x - circle.radius, y: circle.y - circle.radius, w: circle.radius*2, h: circle.radius*2, path: 'sprites/repel.png'}
    end
    draw_bar(args)
  end

  def spawn_pickup(enemy, args, klass=Pickups::Standard)
    chance = rand
    if chance > Pickups::Pickup.luck
      self.pickup_messages = self.pickup_messages.reject { |msg| msg[:delete] }
      klass = [Pickups::Repel, Pickups::RestoreTrees, Pickups::Shoot360].sample
      klass = [Pickups::Repel, Pickups::Shoot360].sample if args.state.hp > 95
    end

    x = enemy.x + Math.cos(enemy.angle * DEGREES_TO_RADIANS) * Pickups::Pickup.speed
    y = enemy.y + Math.sin(enemy.angle * DEGREES_TO_RADIANS) * Pickups::Pickup.speed

    puts klass
    if klass == Pickups::Standard
      reusable_pickups = self.pickups.select { |pickup| pickup.reusable }

      if reusable_pickups.any?
        reusable_pickups.first.reset(x, y, enemy.angle)
      else
        self.pickups << klass.new(x, y, enemy.angle)
      end
    else
      self.pickups << klass.new(x, y, enemy.angle)
    end
  end

  def draw_bar(args)
    args.outputs.sprites << self.bar_fill
    args.outputs.borders << self.bar_border
    args.outputs.labels << { text: "Level: #{self.current_level}", x: ORIGIN.x, y: 35, r: 255, g: 255, b: 255, alignment_enum: 1, font: "fonts/joystix.ttf" }
  end
end