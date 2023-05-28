module Bullets
  class Bullet
    include AttrSprite

    attr_accessor :damage, :radius, :passthrough, :reusable
  end
  
  class Kumquat < Bullet
    @@count_down = 30
    @@rate_of_fire = 30
    @@speed = 3
    @@bullets = []

    class << self
      def count_down
        @@count_down
      end

      def count_down=(value)
        @@count_down = value
      end

      def rate_of_fire
        @@rate_of_fire
      end

      def speed
        @@speed
      end

      def speed=(new_speed)
        @@speed = new_speed
      end

      def bullets
        @@bullets
      end
    end

    def initialize(x, y, angle)
      reset(x, y, angle)
      @@bullets << self
    end

    def update(args)
      self.x += Math.cos(angle * DEGREES_TO_RADIANS) * @@speed
      self.y += Math.sin(angle * DEGREES_TO_RADIANS) * @@speed

      if self.x < -self.w || self.x > WIDTH || self.y < -self.h || self.y > HEIGHT
        args.outputs.debug.labels << { text: "#{self.x.to_i}, #{self.y.to_i}", x: 10, y: 580, r: 255, g: 255, b: 255 }
        self.reusable = true
      end
    end

    def draw(args)
      args.outputs.solids << { x: self.x, y: self.y, w: self.w, h: self.h, r:255, g: 88, b: 0  }
    end

    def reset(x, y, angle)
      self.x = x
      self.y = y
      self.w = 10
      self.h = 10
      self.angle = angle
      self.damage = 1
      self.radius = false
      self.passthrough = 1
      self.reusable = false
    end
  end
end