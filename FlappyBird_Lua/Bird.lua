Bird=Class{}

local GRAVITY=20 --essentially y acceleration

function Bird:init()
    self.image=love.graphics.newImage('assets/images/bird.png')
    self.width=self.image:getWidth()
    self.height=self.image:getHeight()
    self.x=(VIRTUAL_WIDTH/2)-(self.width/2)
    self.y=(VIRTUAL_HEIGHT/2)-(self.height/2)
    self.dy=0 --speed in y axis
end

function Bird:update(dt)
    if love.keyboard.keypressmap['space']==true then
        self.dy=-5
        sounds['jump']:play()
    end
    self.dy=self.dy+GRAVITY*dt --creates the effect of gravity
    self.y=math.max(self.y+self.dy,0) --update y position and prevent moving above screen top
end

function Bird:collides(pipe)
    --allow for a bit of collision and not checck pixel perfect collsions to make the game easier
    --and look more natural
    if (self.x+2)+(self.width-4)>=pipe.x and (self.x+2)<=pipe.x+PIPE_WIDTH then
        if (self.y+2)+(self.height-4)>=pipe.y and (self.y+2)<=pipe.y+PIPE_HEIGHT then
            return true
        end
    end
end

function Bird:render()
    love.graphics.draw(self.image,self.x,self.y)
end