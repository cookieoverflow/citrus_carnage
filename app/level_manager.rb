class LevelManager
  attr_accessor :collected, :required, :pickups
  
  def initialize
    self.collected = 0
    self.required = 5
    self.pickups = []
  end

  def update(args, player)
    if self.collected == self.required
      player.level += 1
      self.collected = 0
      self.required *= 2
    end

    self.pickups.each do |pickup| 
      pickup.update(args, player, self)
    end
  end

  def draw(args)
    self.pickups.each { |pickup| pickup.draw(args) }
  end

  def spawn_pickup(enemy, klass=Pickups::Standard)
    x = enemy.x + Math.cos(enemy.angle * DEGREES_TO_RADIANS) * klass.speed
    y = enemy.y + Math.sin(enemy.angle * DEGREES_TO_RADIANS) * klass.speed

    reusable_pickups = self.pickups.select { |pickup| pickup.reusable }

    if reusable_pickups.any?
      reusable_pickups.first.reset(x, y, enemy.angle)
    else
      self.pickups << klass.new(x, y, enemy.angle)
    end
  end
end