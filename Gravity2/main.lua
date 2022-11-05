-- libs
local wf = require 'windfield'
local suit = require 'suit'

-- g vars 
local slider = {value = 0.1, min = -100, max = 100}

function love.load() 
    world = wf.newWorld(0,0,true)

    suit.Slider(slider, 10, 10, 200, 20) --Why does this work? 

    ground = world:newRectangleCollider(0, 590, 1000, 10)
    ground:setType('static')
end

function love.update(dt)
    suit.Slider(slider, 10, 10, 200, 20)
    suit.Label(tostring(slider.value), 150, 10, 200,20)
    world:setGravity(0,slider.value*100)
    function love.mousepressed(x,y,button) 
        if button == 1 then 
            box = world:newRectangleCollider(x,y,50,50)
            box:setType('dynamic')
            box:applyAngularImpulse(5*slider.value*100)
            box:applyLinearImpulse(0,5*25)
        end
        if button == 2 then 
            circle = world:newCircleCollider(x,y,25)
            circle:setType('dynamic')
            circle:applyAngularImpulse(4*slider.value*100)
            circle:applyLinearImpulse(0, 4*16)
        end
    end
    world:update(dt)
end

function love.draw()
    if (slider.value == 100) then love.graphics.print("Almost Earth's Gravity!", 600, 20) end
    world:draw()
    suit.draw() 
end
