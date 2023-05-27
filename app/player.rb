class Player
  include AttrSprite
  
  attr_accessor :dir, :spd, :level, :active_bullet_types, :angle, :origin, :radius

  def initialize(level, x=10, y=10)
    self.x = x
    self.y = y
    self.w = 20
    self.h = 20
    self.level = level
    self.active_bullet_types = [Bullets::Kumquat]

    self.radius = 150
    @roation_speed = 1
    self.angle = 0
    self.origin = { x: WIDTH/2, y: HEIGHT/2 }
  end

  def update(args)
    if args.inputs.left
      self.angle += 2
    elsif args.inputs.right
      self.angle -= 2
    end

    self.x = self.origin.x + Math.cos(self.angle * DEGREES_TO_RADIANS) * self.radius
    self.y = self.origin.y + Math.sin(self.angle * DEGREES_TO_RADIANS) * self.radius

    # move to centre of player sprite
    self.x -= self.w/2
    self.y -= self.h/2
  end
  
  def draw(args)
    args.outputs.sprites << { x: self.origin.x - self.radius, y: self.origin.y - self.radius, w: self.radius*2 ,h: self.radius*2, path: 'sprites/track.png'}
    args.outputs.sprites << { x: self.x, y: self.y, w: self.w, h: self.h, angle: self.angle_to(self.origin) + 90, path: 'sprites/player.png'}
    args.outputs.debug.labels << { text: "X #{self.x.to_i}, Y: #{self.y.to_i}", x: 10, y: 700, r:255, g:255, b:255 }
    args.outputs.debug.labels << { text: "Angle from: #{self.angle_from(self.origin).to_i}, Angle to: #{self.angle_to(self.origin).to_i}", x: 10, y: 670, r:255, g:255, b:255 }
  end
end