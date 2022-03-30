PlayState=Class{__includes=BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird=Bird()
    self.onscreen_pipes={}
    self.time_elapsed_since_last_pipe=0
    self.lastY= -PIPE_HEIGHT+math.random(80)+20
    self.pipe_dist_time_var=math.random(2.5,3.0)
    self.score=0
end

function PlayState:update(dt)
    self.time_elapsed_since_last_pipe=self.time_elapsed_since_last_pipe+dt --continue counting time
    if self.time_elapsed_since_last_pipe>self.pipe_dist_time_var then
        self.time_elapsed_since_last_pipe=0
        self.pipe_dist_time_var=math.random(2.5,3.0)
        local Y_pos=math.max(-PIPE_HEIGHT+10,math.min(self.lastY+math.random(-20,20),VIRTUAL_HEIGHT-90-PIPE_HEIGHT))-- the max function ensures the the pipe does
        self.lastY=Y_pos
        --not spawn above top of the screen and the bottom of pipe is at VIRTUAL_HEIGHT-90 in the worst case
        table.insert(self.onscreen_pipes,PipePair(Y_pos)) --create a new pipe pair and insert it into table
    end 
    
    for k,pipe in pairs(self.onscreen_pipes) do     
        if not pipe.scored then
            if self.bird.x>pipe.x+PIPE_WIDTH then --check if bird has crossed pipe
                pipe.scored=true
                self.score=self.score+1
                sounds['score']:play()
            end
        end
        pipe:update(dt) --scroll the pipe 
        --deleting pipes at this point can lead to undefined behavior since we are calling an operation on them
        --so a better method is to mark the pipes and delete them later
        --this is because indices change on deletion so the value k maybe wrong leading to glitchy update
        -- if pipe.x<-pipe.width then
        --     table.remove(onscreen_pipes,k)
        -- end
    end
    
    for k,pipe in pairs(self.onscreen_pipes) do
        if pipe.remove then
            table.remove(self.onscreen_pipes,k)
        end
    end

    self.bird:update(dt) --update position of the bird for gravity
    
    for k,pipe in pairs(self.onscreen_pipes) do
        for l,p in pairs(pipe.pipes) do --check each pipe in pipe pair for collsion
            if self.bird:collides(p) then
                sounds['collision']:play()
                sounds['explosion']:play()
                gStateMachine:change('score',{
                    score=self.score --pass the score to score state
                }) --change back to title screen    
            end
        end
    end

    if self.bird.y>VIRTUAL_HEIGHT-15-BIRD_HEIGHT then --bird hit the floor
        gStateMachine:change('score',{
            score=self.score --pass the score to score state
        })
    end

end

function PlayState:render( ... )
    for k,pipe in pairs(self.onscreen_pipes) do
        pipe:render()
    end
    love.graphics.setFont(title_font)
    love.graphics.print('Score: '..tostring(self.score),8,8)
    self.bird:render()
end