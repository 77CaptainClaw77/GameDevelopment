Pipe=Class{}


local PIPE_IMG = love.graphics.newImage('assets/images/pipe.png')

PIPE_SCROLL=60
PIPE_HEIGHT=288
PIPE_WIDTH=70

function Pipe:init(oreintation,y) --orientation specifies top or bottom pipe
    self.x=VIRTUAL_WIDTH --start at the rightmost corner of the screen
    self.y=y
    --self.y=math.random(VIRTUAL_HEIGHT/4,VIRTUAL_HEIGHT-10) --spawn at a random height
    
    self.width=PIPE_IMG:getWidth()
    self.height=PIPE_HEIGHT

    self.orientation=oreintation
end

--update is now handled in PipePair
-- function Pipe:update(dt) --move pipe from right to left
--     self.x=self.x+PIPE_SCROLL*dt
-- end

function Pipe:render()
    y_scale=1
    if self.orientation=="top" then --to rotate the pipe image
        y_scale=-1
    end 
    y_pos=self.y
    if self.orientation=="top" then --to set the image position
        y_pos=self.y+PIPE_HEIGHT
    end 
    love.graphics.draw(PIPE_IMG,self.x,y_pos,0,1,y_scale )--0 is for rotation, 1 is for x scaling
end