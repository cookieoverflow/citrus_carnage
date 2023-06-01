module Bullets
  class Bullet
    include AttrSprite

    attr_accessor :damage, :radius, :passthrough, :reusable
  end
  
  class Kumquat < Bullet
    @@count_down = 80
    @@rate_of_fire = 80
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

      def rate_of_fire=(value)
        @@rate_of_fire = value
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

      check_bullets_offscreen
    end

    def draw(args)
      args.outputs.sprites << self
    end

    def reset(x, y, angle)
      self.x = x
      self.y = y
      self.w = 16
      self.h = 16
      self.angle = angle
      self.damage = 1
      self.radius = false
      self.passthrough = 1
      self.reusable = false
      self.path = 'sprites/orange.png'
    end

    def check_bullets_offscreen
      if self.x < -self.w || self.x > WIDTH || self.y < -self.h || self.y > HEIGHT
        self.reusable = true
      end
    end
  end
end