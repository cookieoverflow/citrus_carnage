module Enemies
  class Enemy
    include AttrSprite

    attr_accessor :hp, :hit_orchard, :speed, :dead, :been_through_center

    def update(args)
      self.x -= Math.cos(angle * DEGREES_TO_RADIANS) * self.speed
      self.y -= Math.sin(angle * DEGREES_TO_RADIANS) * self.speed

      check_collision_with_orchard(args)
      check_enemy_is_offscreen
    end

    def draw(args)
      args.outputs.sprites << self
    end

    def check_enemy_is_offscreen
      return unless self.been_through_center
      
      if self.x < -self.w || self.x > WIDTH || self.y < -self.h || self.y > HEIGHT
        self.dead = true
      end
    end

    def check_collision_with_orchard(args)
      return false if hit_orchard # can only hit orchard once

      circle = { x: self.x, y: self.y, radius: self.w/2 }
      dx = circle.x - ORIGIN.x
      dy = circle.y - ORIGIN.y
      distance = Math.sqrt(dx*dx + dy*dy)

      if distance < circle.radius + ORIGIN.radius # dit detected
        self.been_through_center = true
        self.hit_orchard = true
        args.state.hp -= 1
      end
    end

    def reset(x, y, angle, path=nil)
      self.x = x
      self.y = y
      self.w = 32
      self.h = 32
      self.speed = 0.6
      self.hp = 1
      self.angle = angle
      self.dead = false
      self.hit_orchard = false # player in this case is any tree in the orhard
      self.been_through_center = false
      self.path = path || self.path
    end
  end

  class Ant1 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, 'sprites/ant1.png')
    end
  end

  class Beetle1 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, 'sprites/beetle1.png')
    end
  end
end