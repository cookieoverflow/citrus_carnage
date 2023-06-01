class UpgradeUI
  attr_accessor :spr_arrow, :spr_panel, :spr_inset, :txt_intro, :spr_button1, :spr_button2,
    :txt_choice1, :txt_choice2, :choices, :current_choice, :init

  def initialize(choices)
    reset(choices)
  end

  def update(args)
    if self.init
      if self.spr_panel.x > WIDTH/2 - 300
        self.spr_panel.x = WIDTH/2 - 300
        self.init = false # we're in position and can now interact with panel
        self.spr_arrow.x = self.spr_button1.x + self.spr_button1.w + 10
      end
      self.spr_panel.x += 20
      self.spr_inset.x = self.spr_panel.x + 50
      self.txt_intro.x = self.spr_inset.x + 250
      self.spr_button1.x = self.spr_inset.x + 50
      self.spr_button2.x = self.spr_inset.x + 50
      self.txt_choice1.x = self.spr_button1.x + 200
      self.txt_choice2.x = self.spr_button2.x + 200
    end

    unless self.init
      if args.inputs.keyboard.down && self.current_choice == 0
        self.current_choice = 1
        self.spr_arrow.y -= 60
      elsif args.inputs.keyboard.up && self.current_choice == 1
        self.current_choice = 0
        self.spr_arrow.y += 60
      end
    end
  end

  def draw(args)
    args.outputs.sprites << self.spr_panel
    args.outputs.sprites << self.spr_inset
    args.outputs.labels. << self.txt_intro
    args.outputs.sprites << self.spr_button1
    args.outputs.sprites << self.spr_button2
    args.outputs.labels. << self.txt_choice1
    args.outputs.labels. << self.txt_choice2
    args.outputs.sprites << self.spr_arrow
  end

  def reset(choices)
    self.init = true
    self.choices = choices
    self.spr_panel = { x: -600, y: HEIGHT/2 - 200, w: 600, h: 300, path: 'sprites/panel_brown.png' }
    self.spr_inset = { x: self.spr_panel.x + 50, y: self.spr_panel.y + 25, w: 500, h: 250, path: 'sprites/panelInset_beige.png' }
    self.txt_intro = { x: self.spr_inset.x + 250, y: self.spr_inset.y + 225, text: 'Choose an upgrade', font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: -2 }
    self.spr_button1 = { x: self.spr_inset.x + 50, y: self.spr_inset.y + 120, w: 400, h: 45, path: 'sprites/buttonLong_blue_pressed.png' }
    self.spr_button2 = { x: self.spr_inset.x + 50, y: self.spr_inset.y + 65, w: 400, h: 45, path: 'sprites/buttonLong_blue_pressed.png' }
    self.txt_choice1 = { x: self.spr_button1.x + 200, y: self.spr_button1.y + 30, text: self.choices[0][1] , font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: -3 }
    self.txt_choice2 = { x: self.spr_button2.x + 200, y: self.spr_button2.y + 30, text: self.choices[1][1] , font: 'fonts/joystix.ttf', alignment_enum: 1, size_enum: -3 }
    self.current_choice = 0
    self.spr_arrow = { x: self.spr_button1.x + self.spr_button1.w + 10, y: self.spr_button1.y + 15, w: 22, h: 21, path: 'sprites/arrowSilver_left.png' }
  end
end

class UpgradeManager
  attr_accessor :level, :current_choices, :display_choices, :standard_choices, :weapon_unlock, :ui, :showing
  
  def initialize(level)
    self.level = level
    self.showing = true
    self.current_choices = {}
    self.display_choices = []
    self.standard_choices = { 
      fire_rate: { title: 'Increse fire rate 10%', amount: 0.1 }, 
      bullet_speed: { title: 'Increase bullet speed 10%', amount: 0.1 }, 
      aoe: { title: 'Increase area of affect 10%', amount: 0.1 }
      # additional: { title: 'Fire additional bullet', amount: 1 }
    }
    self.weapon_unlock = {
      oranges2: { title: 'Oranges level 2', group: :orange, order: 1, unlocked: false},
      oranges3: { title: 'Oranges level 3', group: :orange, order: 2, unlocked: false},
      diag1: { title: 'Shoot diagonally', group: :diag, order: 1, unlocked: false},
      diag2: { title: 'Shoot additional stream diagonally', group: :diag, order: 2, unlocked: false},
      explosions1: { title: 'Drop explosive blood oranges', group: :exp, order: 1, unlocked: false},
      explosions2: { title: 'Drop more explosive blood oranges', group: :exp, order: 2, unlocked: false},
      explosions3: { title: 'Drop more explosive blood oranges', group: :exp, order: 3, unlocked: false}
    }  
  end

  def update(args)
    if self.showing
      self.ui.update(args)
      if args.inputs.keyboard.key_down.enter
        process_choice(self.display_choices[self.ui.current_choice])
        self.showing = false
        self.level.pause = false
      end
    end
  end

  def draw(args)
    if self.showing
      self.ui.draw(args)
    end
  end

  def enter
    self.showing = true
    self.current_choices = {}
    self.display_choices = []
    new_choices
    self.ui = UpgradeUI.new(self.display_choices)
  end

  def new_choices
    first_choice = self.standard_choices.keys.sample
    second_choice = ''
    
    if rand(100) > 80
      # select weapons that haven't been unlocked and group by :group
      options = self.weapon_unlock.reject { |k,v| v.unlocked}.group_by { |k,v| v.group }
      # select the first item of a randomly selected group (order must be weakest to strongest from top to bottom)
      second_choice = options[options.keys.sample].first[0]
    else
      second_choice = self.standard_choices.keys.sample
    end
    self.current_choices[first_choice] = self.standard_choices[first_choice]
    self.current_choices[second_choice] = self.standard_choices[second_choice] || self.weapon_unlock[second_choice]
    self.display_choices << [first_choice, self.current_choices[first_choice].title]
    self.display_choices << [second_choice, self.current_choices[second_choice].title]
  end

  def process_choice(choice)
    key = choice[0]

    # TODO: Mark weapon as unlocked if weapon

    case key
    when :fire_rate
      if Bullets::Kumquat.rate_of_fire > 10
        Bullets::Kumquat.rate_of_fire *= 0.9
      end
    when :bullet_speed
      if Bullets::Kumquat.speed < 20
        Bullets::Kumquat.speed *= 1.0
      end
    when :aoe
    when :additional
    when :oranges2
    when :oranges3
    when :diag1
    when :diag2
    when :explosions1
    when :explosions2
    when :explosions3  
    end
  end
end