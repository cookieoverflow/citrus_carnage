class Player
  include AttrSprite
  
  attr_accessor :dir, :spd

  def initialize(x=10, y=10)
    self.x = x
    self.y = y
    self.w = 20
    self.h = 20

    @radius = 150
    @roation_speed = 1
    @angle = 0
    @origin = { x: WIDTH/2, y: HEIGHT/2 }
  end

  def update(args)
    if args.inputs.keyboard.left
      @angle += 2
    elsif args.inputs.keyboard.right
      @angle -= 2
    end

    self.x = @origin.x + Math.cos(@angle * DEGREES_TO_RADIANS) * @radius
    self.y = @origin.y + Math.sin(@angle * DEGREES_TO_RADIANS) * @radius

    # move to centre of player sprite
    self.x -= self.w/2
    self.y -= self.h/2
  end
  
  def draw(args)
    args.outputs.sprites << { x: @origin.x - @radius, y: @origin.y - @radius, w: @radius*2 ,h: @radius*2, path: 'sprites/track.png'}
    args.outputs.sprites << { x: self.x, y: self.y, w: self.w, h: self.h, angle: self.angle_to(@origin) + 90, path: 'sprites/player.png'}
    args.outputs.labels << { text: "X #{self.x.to_i}, Y: #{self.y.to_i}", x: 10, y: 700, r:255, g:255, b:255 }
    args.outputs.labels << { text: "Angle from: #{self.angle_from(@origin).to_i}, Angle to: #{self.angle_to(@origin).to_i}", x: 10, y: 670, r:255, g:255, b:255 }
  end
end