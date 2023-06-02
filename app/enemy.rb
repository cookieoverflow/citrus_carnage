module Enemies
  class Enemy
    include AttrSprite

    attr_accessor :hp, :hit_orchard, :speed, :dead, :been_through_center

    def update(args, trees)
      self.x -= (Math.cos(angle * DEGREES_TO_RADIANS) * self.speed)
      self.y -= (Math.sin(angle * DEGREES_TO_RADIANS) * self.speed)

      check_collision_with_orchard(args, trees)
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

    def check_collision_with_orchard(args, trees)
      return false if hit_orchard # can only hit orchard once

      trees.trees.each do |tree|
        next if tree.dead
        
        if self.intersect_rect? tree
          tree.dead = true
          self.hit_orchard = true
          args.state.hp -= 1
          self.been_through_center = true
          # TODO: play hit sound
        end
      end
    end

    def reset(x, y, angle, **opts)
      self.x = x
      self.y = y
      self.w = 32
      self.h = 32
      self.speed = opts[:speed]
      self.hp = opts[:hp]
      self.angle = angle
      self.dead = false
      self.hit_orchard = false # player in this case is any tree in the orhard
      self.been_through_center = false
      self.path = opts[:path] || self.path
    end
  end

  class Ant1 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:1, path:'sprites/ant1.png', speed: 0.6)
    end
  end

  class Beetle1 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:1, path:'sprites/beetle1.png', speed: 0.6)
    end
  end

  class Ant2 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:2, path:'sprites/ant2.png', speed: 0.6)
    end
  end

  class Beetle2 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:3, path:'sprites/beetle2.png', speed: 0.6)
    end
  end

  class Ant3 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:3, path:'sprites/ant3.png', speed: 0.6)
    end
  end

  class Beetle3 < Enemy
    def initialize(x, y, angle)
      reset(x, y, angle, hp:3, path:'sprites/beetle3.png', speed: 0.6)
    end
  end
end