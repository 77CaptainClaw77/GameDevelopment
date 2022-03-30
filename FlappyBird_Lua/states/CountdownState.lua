CountdownState=Class{__includes=BaseState}

COUNTDOWN_TIME=0.75 --Counts down intervals of 0.75 seconds and 1 second

function CountdownState:init()
    self.count=3
    self.timer=0
end

function CountdownState:update(dt)
    self.timer=self.timer+dt
    if self.timer>COUNTDOWN_TIME then
        self.timer=self.timer%COUNTDOWN_TIME
        self.count=self.count-1
    end
    if self.count==0 then --start the game
        gStateMachine:change('play')
    end
end

function CountdownState:render()
    love.graphics.setFont(large_font)
    love.graphics.printf(tostring(self.count),0,120,VIRTUAL_WIDTH,'center')
end