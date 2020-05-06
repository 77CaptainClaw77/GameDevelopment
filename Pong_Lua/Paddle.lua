Paddle=Class{}

function Paddle:init( x,y,width,height )
    self.X=x --self is the 'this' pointer in c++
    self.Y=y
    self.width=width
    self.height=height
    self.default_speed_Y=200
    self.speed_Y=0
    self.score=0
end

function Paddle:update_position(dt)
    if self.speed_Y<0 then
        self.Y=math.max( self.Y+self.speed_Y*dt,0) --max is used to prevent out of bounds movement of paddles
    else --min is used for the same reason
        self.Y=math.min( self.Y+self.speed_Y*dt,VIRTUAL_HEIGHT-self.height )
    end
end

function Paddle:render()
    love.graphics.rectangle('fill',self.X,self.Y,self.width,self.height)
end