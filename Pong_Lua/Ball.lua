Ball=Class{} --class declaration

function Ball:init(x,y,width,height) --constructor function
    --initializing the ball position and speed
    self.initial_X=x --saving initial position for reset
    self.initial_Y=y
    self.X=x --self is the 'this' pointer of c++
    self.Y=y
    self.width=width
    self.height=height
    self.speed_X=math.random(2)==1 and 100 or -100 --ternary operator implementation
    self.speed_Y=math.random( -50,50 )
end

function Ball:reset() --used to reset ball postion on the screen
    self.X=self.initial_X
    self.Y=self.initial_Y
    -- self.speed_X=math.random(2)==1 and 100 or -100  --these lines are unnecessary!
    -- self.speed_Y=math.random( -50,50 ) --not required as speed is directly set
end 

function Ball:update_position(dt) -- to move the ball in delta time
    self.X=self.X+ dt*self.speed_X
    self.Y=self.Y+ dt*self.speed_Y
end

function Ball:check_collision( paddle )
    --check is collsion with anyone of the two paddles
    --first check for collision with the ace of the paddle
    if self.X>paddle.X+paddle.width or self.X+self.width<paddle.X then --fisrt condition is for left second is for right paddle
        return false
    end
    --then check top and bottom edges
    if self.Y>paddle.Y+paddle.height or self.Y+self.height<paddle.Y then
        return false
    end
    --if neither hold then collison has occured
    return true
end

function Ball:rebound(paddle,direction) --rebound the ball on collision with a random speed
    
    if direction=='left' or direction=='right' then --collision with player1
        self.speed_X = -self.speed_X * 1.03
        self.speed_Y = self.speed_Y<0 and -math.random( 10,150 ) or math.random(10,150)
        if direction=='left' then
            self.X=paddle.X+paddle.width
        else
            self.X=paddle.X-self.width
        end
    else
        self.speed_Y=-self.speed_Y
        if direction=='top' then
            self.Y=0  
        else
            self.Y=VIRTUAL_HEIGHT-self.height
        end
    end

end

function Ball:render() --render the ball
    love.graphics.rectangle('fill',self.X,self.Y,self.width,self.height)
end

