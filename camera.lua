_camera = class()

function _camera:init()
    self.px,self.py = (world.player.x+world.player.width/2-0.5)*game.block_size-WIDTH/2,(world.player.y+world.player.height/2-0.5)*game.block_size-HEIGHT/3
    self:reset()
end

function _camera:draw()
    self.px,self.py = (world.player.x+world.player.width/2-0.5)*game.block_size-WIDTH/2,(world.player.y+world.player.height/2-0.5)*game.block_size-HEIGHT/3
    local mu = WIDTH/8 -- Move the camera.
    if vec2(self.x,self.y):dist(vec2(self.px,self.py)) >= mu then
        self.moving = true
    end
    if self.moving then
        self.x,self.y = math.round((self.px-self.x)*0.1+self.x),math.round((self.py-self.y)*0.1+self.y)
        if vec2(self.x,self.y):dist(vec2(self.px,self.py)) <= mu*0.003 then
            self.moving = false
            self.x,self.y = self.px,self.py
        end
    end
end

function _camera:reset()
    self.x,self.y = self.px,self.py
end
