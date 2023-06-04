class EnemyManager
  attr_accessor :enemies, :spawn_rate, :count_down, :spawn_radius, :enemy_types, :spawn_groups,
    :current_spawn_group, :level

  def initialize(level)
    self.level = level
    self.enemies = []
    self.spawn_rate = 220
    self.spawn_radius = 660
    self.count_down = self.spawn_rate
    # self.enemy_types = [Enemies::Ant1, Enemies::Beetle1]
    self.spawn_groups = {
      easy: [Enemies::Ant1, Enemies::Beetle1],
      medium: [Enemies::Ant1, Enemies::Beetle1, Enemies::Ant2, Enemies::Beetle2],
      hard: [Enemies::Ant3, Enemies::Beetle3]
    }
    self.current_spawn_group = :easy
  end

  def update(args)
    if self.count_down <= 0
      self.count_down = self.spawn_rate
      spawn_enemy(self.spawn_groups[current_spawn_group].sample, rand(3)+3)
    else
      self.count_down -= 1
    end
    self.enemies.each { |enemy| enemy.update(args, level.trees) unless enemy.dead }
  end

  def draw(args)
    self.enemies.each { |enemy| enemy.draw(args) unless enemy.dead }
  end

  def spawn_enemy(klass, number)
    self.enemies = self.enemies.reject { |enemy| enemy.dead }
    number.to_i.times do
      angle = rand(360)
      x = ORIGIN.x + Math.cos(angle * DEGREES_TO_RADIANS) * self.spawn_radius
      y = ORIGIN.y + Math.sin(angle * DEGREES_TO_RADIANS) * self.spawn_radius

      self.enemies << klass.new(x, y, angle)
    end
  end
end