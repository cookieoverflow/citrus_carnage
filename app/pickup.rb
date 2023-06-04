module Pickups
  class Pickup
    include AttrSprite

    attr_accessor :rotation, :reusable

    class << self
      attr_accessor :speed, :luck
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

    def reset(x, y, rotation, **opts)
      self.x = x
      self.y = y
      self.w = opts[:w] || 10
      self.h = opts[:h] || 10
      self.rotation = rotation
      self.reusable = false
      self.path = opts[:path] || 'sprites/pickup.png'
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
      return if self.reusable

      pickup_circle = { x: self.x, y: self.y, radius: self.w/2 }
      player_circle = { x: player.x, y: player.y, radius: player.w/2 }
  
      dx = pickup_circle.x - player_circle.x
      dy = pickup_circle.y - player_circle.y
      distance = Math.sqrt(dx*dx + dy*dy)
  
      if distance < pickup_circle.radius + player_circle.radius # hit detected
        case self.class.name
        when 'Pickups::Standard'
          level_manager.collected += 1
          self.reusable = true
          args.audio[:pickup] = { input: 'sounds/pickup.wav', gain: 0.6 }
        when 'Pickups::Repel'
          args.state.repel = true
          args.state.repel_circle = { x: ORIGIN.x, y: ORIGIN.y, radius: 5, target_radius: 200 }
          level_manager.pickup_messages << { x: player.x, y: player.y, text: 'Spray repellent', font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: 1, target: player.y + 100, delete: false, r: 255, g: 255, b: 255 }
          self.reusable = true
        when 'Pickups::RestoreTrees'
          args.state.hp += 5
          level_manager.game_level.trees.randomize_trees(5)
          level_manager.pickup_messages << { x: self.x, y: self.y, text: '5 Trees Restored', font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: 1, target: self.y + 100, delete: false, r: 255, g: 255, b: 255 }
          self.reusable = true
        when 'Pickups::Shoot360'
          Bullets::Orange.spawn_360(player, args)
          level_manager.pickup_messages << { x: player.x, y: player.y, text: ' 360 Shot', font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: 1, target: player.y + 100, delete: false, r: 255, g: 255, b: 255 }
          self.reusable = true
        end
      end
    end
  end

  class Repel < Standard
    def initialize(x, y, angle)
      reset(x, y, angle, w: 24, h: 24, path: 'sprites/pu_repel.png')
    end
  end

  class RestoreTrees < Standard
    def initialize(x, y, angle)
      reset(x, y, angle, w: 24, h: 24, path: 'sprites/pu_trees.png')
    end
  end

  class Shoot360 < Standard
    def initialize(x, y, angle)
      reset(x, y, angle, w: 24, h: 24, path: 'sprites/pu_shoot360.png')
    end
  end

  Pickup.luck = 0.95 # rand needs to be higher thank this to spawn special pickup
  Pickup.speed = 5
end