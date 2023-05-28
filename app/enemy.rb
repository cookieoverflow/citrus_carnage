module Enemies
  class Enemy
    include AttrSprite

    attr_accessor :hp
  end

  class Locust < Enemy
    attr_accessor :speed, :dead

    def initialize(x, y, angle)
      self.x = x
      self.y = y
      self.w = 10
      self.h = 10
      self.speed = 0.6
      self.hp = 1
      self.angle = angle
      self.dead = false
    end

    def update(args)
      self.x -= Math.cos(angle * DEGREES_TO_RADIANS) * self.speed
      self.y -= Math.sin(angle * DEGREES_TO_RADIANS) * self.speed
    end

    def draw(args)
      if self.dead
        args.outputs.solids << { x: self.x, y: self.y, w: self.w, h: self.h, r:200, g: 0, b: 0  }
      else  
        args.outputs.solids << { x: self.x, y: self.y, w: self.w, h: self.h, r:0, g: 0, b: 255  }
      end
    end
  end
end