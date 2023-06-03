module Bullets
  class Bullet
    @@bullets = []

    class << self
      def bullets
        @@bullets
      end

      def bullets=(value)
        @@bullets = value
      end
    end

    include AttrSprite

    attr_accessor :damage, :radius, :passthrough, :reusable
  end

  class Orange < Bullet
    class << self
      attr_accessor :current_level, :count_down, :rate_of_fire, :speed, :passthrough
    end

    def initialize(x, y, angle)
      reset(x, y, angle)
      @@bullets << self
    end

    def update(args)
      self.x += Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
      self.y += Math.sin(angle * DEGREES_TO_RADIANS) * Orange.speed

      check_bullets_offscreen
    end

    def draw(args)
      args.outputs.sprites << self unless self.reusable
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

    def self.spawn_bullets(player, args)
      angle = player.angle
      Bullet.bullets = Bullet.bullets.reject { |bullet| bullet.reusable } # delete bullets that have gone off screen
      
      if Orange.current_level == 1
        x = player.x + 8 + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        y = player.y + 32 + Math.sin(angle * DEGREES_TO_RADIANS) * Orange.speed
  
        Orange.new(x, y, angle)
      elsif Orange.current_level == 2
        x1 = (player.x + 8 - 10) + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        x2 = (player.x + 8 + 10) + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        y = player.y + 32 +  Math.sin(angle * DEGREES_TO_RADIANS) * Orange.speed

        Orange.new(x1, y, angle)
        Orange.new(x2, y, angle)
      elsif Orange.current_level == 3
        x1 = player.x + 8 + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        x2 = player.x + 9 - 20 + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        x3 = player.x + 8 + 20 + Math.cos(angle * DEGREES_TO_RADIANS) * Orange.speed
        y = player.y + 32 + Math.sin(angle * DEGREES_TO_RADIANS) * Orange.speed

        Orange.new(x1, y, angle)
        Orange.new(x2, y, angle)
        Orange.new(x3, y, angle)
      end
      args.audio[:bullet_diad] = { input: 'sounds/bullet1.wav', gain: 0.4, pitch: 1 }
    end
  end

  class Diagonal < Orange
    class << self
      attr_accessor :current_level, :count_down, :rate_of_fire, :speed
    end

    def initialize(x, y, angle)
      super(x, y, angle)
    end

    def self.spawn_bullets(player, args)
      angle = player.angle
      # Orange.bullets = Orange.bullets.reject { |bullet| bullet.reusable } # delete bullets that have gone off screen

      if Diagonal.current_level == 1
        angle1 = angle - 45
        angle2 = angle + 45
        x1 = player.x + Math.cos(angle1* DEGREES_TO_RADIANS) * Diagonal.speed
        x2 = player.x + Math.cos(angle2 * DEGREES_TO_RADIANS) * Diagonal.speed
        y = player.y + 32 +  Math.sin(angle * DEGREES_TO_RADIANS) * Diagonal.speed

        Diagonal.new(x1, y, angle1)
        Diagonal.new(x2, y, angle2)
      elsif Diagonal.current_level == 2
        angle1 = angle - 45
        angle2 = angle - 50
        angle3 = angle + 45
        angle4 = angle + 50
        x1 = (player.x - 10) + Math.cos(angle1 * DEGREES_TO_RADIANS) * Diagonal.speed
        x2 = (player.x - 10) + Math.cos(angle2 * DEGREES_TO_RADIANS) * Diagonal.speed
        x3 = (player.x + 10) + Math.cos(angle3 * DEGREES_TO_RADIANS) * Diagonal.speed
        x4 = (player.x + 10) + Math.cos(angle4 * DEGREES_TO_RADIANS) * Diagonal.speed
        y = player.y + 32 + Math.sin(angle * DEGREES_TO_RADIANS) * speed

        Diagonal.new(x1, y, angle1)
        Diagonal.new(x2, y, angle2)
        Diagonal.new(x3, y, angle3)
        Diagonal.new(x4, y, angle4)
      elsif Diagonal.current_level == 3
        angle1 = angle - 40
        angle2 = angle - 45
        angle3 = angle - 50
        angle4 = angle + 40
        angle5 = angle + 45
        angle6 = angle + 50
        x1 = (player.x - 10) + Math.cos(angle1 * DEGREES_TO_RADIANS) * Diagonal.speed
        x2 = (player.x - 10) + Math.cos(angle2 * DEGREES_TO_RADIANS) * Diagonal.speed
        x3 = (player.x + 10) + Math.cos(angle3 * DEGREES_TO_RADIANS) * Diagonal.speed
        x4 = (player.x + 10) + Math.cos(angle4 * DEGREES_TO_RADIANS) * Diagonal.speed
        x5 = (player.x + 10) + Math.cos(angle5 * DEGREES_TO_RADIANS) * Diagonal.speed
        x6 = (player.x + 10) + Math.cos(angle6 * DEGREES_TO_RADIANS) * Diagonal.speed
        y = player.y + 32 + Math.sin(angle * DEGREES_TO_RADIANS) * speed

        Diagonal.new(x1, y, angle1)
        Diagonal.new(x2, y, angle2)
        Diagonal.new(x3, y, angle3)
        Diagonal.new(x4, y, angle4)
        Diagonal.new(x5, y, angle5)
        Diagonal.new(x6, y, angle6)
      end
      args.audio[:bullet_diad] = { input: 'sounds/bullet1.wav', gain: 0.4, pitch: 0.8 }
    end
  end

  Orange.count_down = 80
  Orange.rate_of_fire = 80
  Orange.speed = 3
  Orange.current_level = 1
  Orange.passthrough = 1
  Diagonal.count_down = 80
  Diagonal.rate_of_fire = 80
  Diagonal.speed = 3 
  Diagonal.current_level = 1
end