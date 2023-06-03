class Trees
  attr_accessor :trees
  def initialize
    self.trees = []
    @init = true
  end
  
  def update(args)
    if @init
      randomize_trees(args.state.hp)
      @init = false
    end
  end

  def draw(args)
    self.trees.each do |tree|
      args.outputs.sprites << tree unless tree.dead
    end
  end

  def randomize_trees(number_of_trees)
    number_of_trees.times do
      random_angle = 2 * Math::PI * rand
      random_radius = (ORIGIN.radius - 20) * Math.sqrt(rand)
      x = random_radius * Math.cos(random_angle) + ORIGIN.x
      y = random_radius * Math.sin(random_angle) + ORIGIN.y - 20
      self.trees << { x: x, y: y, w: 37, h: 42, path: 'sprites/tree.png', dead: false }
    end
  end
end