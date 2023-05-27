class BulletManager
  attr_accessor :enemies, :active_bullet_types
  
  def initialize(enemies)
    self.enemies = enemies
    self.active_bullet_types = [Bullets::Kumquat]
  end

  def update(args, player)
    self.active_bullet_types.each do |bt|
      if bt.count_down <= 0
        bt.count_down = bt.rate_of_fire
        spawn_bullet(player, player.angle, bt.speed, bt)
      else
        bt.count_down -= 1
      end
      bt.bullets.each { |bullet| bullet.update(args) }
    end
  end

  def draw(args)
    self.active_bullet_types.each do |bt|
      args.outputs.debug.labels << { text: "#{bt.bullets.count}", x: 10, y: 640, r:255, g:255, b:255 }

      bt.bullets.each do |bullet|
        bullet.draw(args)
      end
    end
  end

  def spawn_bullet(player, angle, speed, klass)
    x = player.x + Math.cos(angle * DEGREES_TO_RADIANS) * speed
    y = player.y + Math.sin(angle * DEGREES_TO_RADIANS) * speed
    klass.bullets << klass.new(x, y, angle)
  end
end