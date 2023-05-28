class EnemyManager
  attr_accessor :enemies, :spawn_rate, :count_down, :spawn_radius, :enemy_types, :spawn_groups, :current_spawn_group

  def initialize
    self.enemies = []
    self.spawn_rate = 180
    self.spawn_radius = 1500
    self.count_down = self.spawn_rate
    self.enemy_types = [Enemies::Locust]
    self.spawn_groups = {
      easy: [Enemies::Locust],
      medium: [],
      hard: []
    }
    self.current_spawn_group = :easy
  end

  def update(args)
    if self.count_down <= 0
      self.count_down = self.spawn_rate
      spawn_enemy(self.spawn_groups[current_spawn_group].sample)
    else
      self.count_down -= 1
    end
    self.enemies.each { |enemy| enemy.update(args) }
  end

  def draw(args)
    self.enemies.each { |enemy| enemy.draw(args) }
  end

  def spawn_enemy(klass)
    angle = rand(360)
    x = ORIGIN.x + Math.cos(angle * DEGREES_TO_RADIANS) * self.spawn_radius
    y = ORIGIN.y + Math.sin(angle * DEGREES_TO_RADIANS) * self.spawn_radius
    # x = rand(360) + Math.cos(angle * DEGREES_TO_RADIANS) * speed
    # y = rand(360) + Math.sin(angle * DEGREES_TO_RADIANS) * speed
    self.enemies << klass.new(x, y, angle)
  end
end