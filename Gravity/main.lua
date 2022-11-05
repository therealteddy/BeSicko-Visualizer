-- Libraries 
local wf = require 'windfield' 

-- Global Variables 
gConstant = 981

Box = {
    mass = 5,
    acceleration = 25,
    force = 5 * 25,
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

Circle = {
    radius = 20, 
    type = 'dynamic',
    mass = 4, 
    acceleration = 16, 
    force = 4 * 16,
    weight = 4 * gConstant,
}

function love.load() 

    world = wf.newWorld(0,0,true)
    world:setGravity(0, gConstant) 

    function love.mousepressed(x,y,button) 
        if button == 1 then
            box = world:newRectangleCollider(x,y, Box.side,Box.side)
            box:applyLinearImpulse(0, Box.force) 
            box:applyAngularImpulse(Box.weight)
            box:setType(Box.type)
        end
        if button == 2 then 
            circle = world:newCircleCollider(x,y,Circle.radius)
            circle:applyLinearImpulse(0,Circle.force)
            circle:applyAngularImpulse(Circle.weight)
            circle:setType(Circle.type)
        end
    end

    ground = world:newRectangleCollider(Ground.posx, Ground.posy, Ground.xside, Ground.yside)
    ground:setType(Ground.type)

end

function love.update(dt) 
    world:update(dt)
end

function love.draw()
    love.graphics.print("Press Rb for Rectangle Colliders! \n Press Rl for Circle colliders!", 10, 10) 
    world:draw()
end

