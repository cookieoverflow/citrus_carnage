class LevelManager
  attr_accessor :collected, :required, :pickups, :bar_border, :bar_fill, :current_level, :game_level
  
  def initialize(game_level)
    self.collected = 0
    self.required = 5
    self.pickups = []
    self.bar_border = { x: ORIGIN.x - 300, y: 10, w: 600, h: 30, r: 255, g: 255, b: 255 }
    self.bar_fill = { x: ORIGIN.x - 300, y: 10, w: 0, h: 30, r: 0, g: 0, b: 180, path: 'sprites/level_fill.png' }
    self.current_level = 1
    self.game_level = game_level
  end

  def update(args, player)
    if self.collected == self.required
      self.current_level += 1
      self.game_level.enemy_manager.spawn_rate -=20
      self.collected = 0
      self.required *= 2
      self.game_level.show_upgrades
    end

    self.pickups.each do |pickup| 
      pickup.update(args, player, self)
    end

    self.bar_fill.w = (self.bar_border.w / self.required) * self.collected
  end

  def draw(args)
    self.pickups.each { |pickup| pickup.draw(args) }
    draw_bar(args)
  end

  def spawn_pickup(enemy, klass=Pickups::Standard)
    # TODO: Should pickups spawn with a percentage chance e.g 80% of the time?
    x = enemy.x + Math.cos(enemy.angle * DEGREES_TO_RADIANS) * klass.speed
    y = enemy.y + Math.sin(enemy.angle * DEGREES_TO_RADIANS) * klass.speed

    reusable_pickups = self.pickups.select { |pickup| pickup.reusable }

    if reusable_pickups.any?
      reusable_pickups.first.reset(x, y, enemy.angle)
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