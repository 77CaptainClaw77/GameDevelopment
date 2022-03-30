PipePair=Class{}

local GAP_HEIGHT = 0

function PipePair:init(y)
    self.x=VIRTUAL_WIDTH
    self.y=y
    math.randomseed(os.time())
    GAP_HEIGHT = math.random(85,105)
    self.pipes={
        ['upper'] = Pipe('top',self.y),
        ['lower'] = Pipe('bottom',self.y+PIPE_HEIGHT+GAP_HEIGHT)--spawns lower pipe 90 units below top pipe's bottom
    }
    self.scored=false --checks if bird crossed pipe, then increments score
    self.remove=false --keeps track if pipe is in view
end

function PipePair:update(dt)
    if self.x>-PIPE_WIDTH then 
        self.x=self.x-PIPE_SCROLL*dt --calculate new position
        self.pipes['lower'].x=self.x
        self.pipes['upper'].x=self.x 
    else
        self.remove=true --mark for removal
    end
end

function PipePair:render()  
    for k,pipe in pairs(self.pipes) do
        pipe:render() --render each pipe in the pair
    end
end