-- Libraries 
local wf = require 'windfield' 

-- Global Variables 
gConstant = 981

Box = {
    mass = 5,
    acceleration = 36,
    force = (5 * 36),
    weight = 5 * gConstant,
    type = 'dynamic',
    side = 50,
}

Ground = {
    xside = 1000, 
    yside = 100, 
    type = 'static',
    posx = 0, 
    posy = 500,
}

function love.load() 

    world = wf.newWorld(0,0,true)
    world:setGravity(0, gConstant) 

    box = world:newRectangleCollider(0, Ground.posy - 20, Box.side, Box.side)
    box2 = world:newRectangleCollider(700, Ground.posy - 20, Box.side, Box.side) 

    ground = world:newRectangleCollider(Ground.posx, Ground.posy, Ground.xside, Ground.yside)
    ground:setType(Ground.type)

end

function love.update(dt) 
    if love.keyboard.isDown("return") then 
        box:applyLinearImpulse(((Box.force+Box.force)*(2)), 0) 
        box2:applyLinearImpulse(-(Box.force+Box.force),0)
    end
    world:update(dt)
end

function love.draw() 
    love.graphics.push()
    love.graphics.translate(-box:getX()+(1280/2),-box:getY()+(720/2)) -- Camera follows `box`
    world:draw()
    love.graphics.pop()
    love.graphics.print("Please press RETURN!", 10, 10)
end

