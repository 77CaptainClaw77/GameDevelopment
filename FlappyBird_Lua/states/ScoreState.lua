ScoreState=Class{__includes=BaseState}

function ScoreState:enter(enterparams)
    self.score=enterparams.score  --initialize score from parameter passed
end

function ScoreState:update(dt)
    --enter play state from score state
    if love.keyboard.detect_key_press('enter') or love.keyboard.detect_key_press('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(title_font)
    love.graphics.printf('You Lost!',0,64,VIRTUAL_WIDTH,'center')
    love.graphics.setFont(medium_font)
    love.graphics.printf('Score: '..tostring(self.score),0,100,VIRTUAL_WIDTH,'center')
    love.graphics.printf('Press Enter to Try Again!',0,160,VIRTUAL_WIDTH,'center')
end


