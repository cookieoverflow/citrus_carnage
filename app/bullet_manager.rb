class BulletManager
  attr_accessor :enemies, :active_bullet_types, :additional, :blood_splats, :level
  
  def initialize(level)
    self.level = level
    self.active_bullet_types = [Bullets::Orange]
    self.blood_splats = []
    self.additional = 1 # additional bullets in same cycle
  end

  def update(args, player)
    self.active_bullet_types.each do |bt|
      if self.additional > 1 && additional_bullet_step(bt)
        bt.spawn_bullets(player, args)
        bt.count_down -= 1
      elsif bt.count_down <= 0
        bt.count_down = bt.rate_of_fire
        bt.spawn_bullets(player, args)
      else
        bt.count_down -= 1
      end
      bt.bullets.each do |bullet|
        bullet.update(args)
        self.level.enemy_manager.enemies.each do |enemy|
          check_collision(bullet, enemy, args)
        end
      end
    end
  end

  def draw(args)
    self.blood_splats.each { |splat| args.outputs.sprites << splat }
    self.active_bullet_types.each do |bt|
      bt.bullets.each do |bullet|
        bullet.draw(args)
      end
    end
  end

  def check_collision(bullet, enemy, args)
    return if bullet.reusable || enemy.dead

    if bullet.intersect_rect? enemy
      enemy.hp -= bullet.damage
      if enemy.hp < 1
        enemy.dead = true
        filename = "sprites/blood#{rand(4) + 1}.png"
        self.blood_splats << { x: enemy.x, y: enemy.y, w: 32, h: 32, path: filename }
        self.level.level_manager.spawn_pickup(enemy, args)
        args.audio[:enemy_dead] = { input: 'sounds/enemy_dead.wav', gain: 0.8 }
      end
      bullet.passthrough -= 1
      bullet.reusable = true if bullet.passthrough < 1
    end
  end

  def additional_bullet_step(bt)
    steps = 2.step.take(self.additional - 1).map { |i| i * (bt.rate_of_fire/self.additional).to_i }
    return true if steps.include?(bt.count_down)
    false
  end
end