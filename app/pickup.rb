module Pickups
  class Pickup
    include AttrSprite

    attr_accessor :rotation, :reusable

    def self.speed
      5
    end
  end

  class Standard < Pickup
    def initialize(x, y, rotation)
      reset(x, y, rotation)
    end

    def update(args, player, level_manager)
      unless self.reusable
        self.rotation = player.angle
        # self.x -= Math.cos(self.rotation * DEGREES_TO_RADIANS) * Pickup.speed
        # self.y -= Math.sin(self.rotation * DEGREES_TO_RADIANS) * Pickup.speed
        move_towards_player(player)
        check_collision_with_player(player, level_manager, args)
      end  
    end

    def draw(args)
      args.outputs.sprites << self unless self.reusable
    end

    def reset(x, y, rotation)
      self.x = x
      self.y = y
      self.w = 10
      self.h = 10
      self.rotation = rotation
      self.reusable = false
      self.path = 'sprites/pickup.png'
    end

    def move_towards_player(player)
      dx = player.x - self.x
      dy = player.y - self.y
      target = Math.sqrt( (dx * dx) + (dy * dy) )
      
      if target > Pickup.speed # not yet reached target
        ratio = Pickup.speed / target
        self.x += ratio * dx    
        self.y += ratio * dy 
      end
    end

    def check_collision_with_player(player, level_manager, args)
      pickup_circle = { x: self.x, y: self.y, radius: self.w/2 }
      player_circle = { x: player.x, y: player.y, radius: player.w/2 }
  
      dx = pickup_circle.x - player_circle.x
      dy = pickup_circle.y - player_circle.y
      distance = Math.sqrt(dx*dx + dy*dy)
  
      if distance < pickup_circle.radius + player_circle.radius # dit detected
        level_manager.collected += 1
        self.reusable = true
        args.audio[:pickup] = { input: 'sounds/pickup.wav', gain: 0.6 }
      end
    end
  end
end