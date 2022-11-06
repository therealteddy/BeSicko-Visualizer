-- Libraries 
local suit = require 'suit' --GUI
local wf = require 'windfield' --love.physics Wrapper
local fpsgraph = require 'grapher/FPSGraph'

-- Variables 
local checkbox = {text="check"}
local input = {text=""} -- SUIT needs this!
local input2 = {text=""} -- And this?!
local physics = {
    mass = 1, 
    acceleration = 1, 
    force =1,
    str_force,
    g_Constant = 9.81 * 100, -- *100 to get an acceptable value for wf
    wf_force,
}

local entity = { 
    Ground = {
        size = { length = 10000, width = 10,}, 
        position = {x=0,y=710,},
        type = 'static',
    },
    Box = {
        size = 50,
        position = {x=200,y=600}, 
        type = 'dynamic'
    },
    Wall = {
        size = { length  = 10, width = 2000,},
        -- Pos differs for the 2 walls
        type='static'
    },

}

love.load = function() 
    
    -- Font
    font = love.graphics.newFont("data/scp.ttf", 14)
    love.graphics.setFont(font)

    -- World 
    world = wf.newWorld(0,0,true)
    world:setGravity(0, physics.g_Constant)

    -- Entities 
    ground = world:newRectangleCollider(entity.Ground.position.x, entity.Ground.position.y, entity.Ground.size.length, entity.Ground.size.width) 
    ground:setType(entity.Ground.type) 
    
    box = world:newRectangleCollider(entity.Box.position.x, entity.Box.position.y, entity.Box.size, entity.Box.size)
    box:setType(entity.Box.type)

    wall_one = world:newRectangleCollider(0, 0, entity.Wall.size.length, entity.Wall.size.width) 
    wall_one:setType(entity.Wall.type)

    wall_two = world:newRectangleCollider(1270, 0, entity.Wall.size.length, entity.Wall.size.width)
    wall_two:setType(entity.Wall.type)

    -- Graphs
    xgraph = fpsgraph.createGraph(1000, 50)
    ygraph = fpsgraph.createGraph(1000, 250)

end

love.update = function(dt)

    suit.Checkbox(checkbox, 1150, 10, 20, 20)
    suit.Label("Show Log?", 1175, 10)

    suit.layout:reset(140,10) --The layout grows down from 0,0 - left and down
    suit.Label("Acceleration", 20, 10)
    suit.Input(input, suit.layout:row(200, 20)) -- size 200 by 20
    suit.layout:row() -- Empty cell. Has the same size as the last one 
    
    suit.layout:reset(140, 40)
    suit.Label("Mass", 20, 40)
    suit.Input(input2, suit.layout:row(200, 20))
    suit.layout:row()

    if tonumber(input.text) ~= nil and tonumber(input2.text) ~= nil then 
        --print(tonumber(input2.text)*tonumber(input.text))
        
        physics.acceleration = tonumber(input.text) -- 1st Input is (a)
        physics.mass = tonumber(input2.text) -- 2nd Input is (m)
        physics.force = (physics.mass * physics.acceleration)
        physics.str_force = tostring(physics.force)
       
        suit.layout:reset(100, 100) 
        suit.Label("Force is "..physics.str_force, 20, 70)

        physics.wf_force = physics.force * 100 -- *100 to get and acceptable value for wf
        box:applyLinearImpulse(physics.wf_force,0)
    end

    xGraph(xgraph, dt, box:getX())
    yGraph(ygraph, dt, box:getY())

    world:update(dt) --Update Physics RLT
end

love.draw = function()
    if checkbox.checked then 
       fpsgraph.drawGraphs({xgraph, ygraph}) 
       love.graphics.setFont(font)
       love.graphics.print("Cords (X): "..math.floor(box:getX()).." | Cords (Y): "..math.floor(box:getY()), 1000, 500)
       print("Cords (X): "..math.floor(box:getX()).." | Cords (Y): "..math.floor(box:getY()))
    end
    suit.draw()
    world:draw() --Draw Colliders
end

-- SUIT needs these for input
function love.textinput(t) 
    suit.textinput(t) 
end

function love.keypressed(t) 
    suit.keypressed(t)
end

function xGraph(graph, dt, n) 
    fpsgraph.updateGraph(graph, n, "X "..math.floor(box:getX()), dt)
end

function yGraph(graph, dt, n) 
    fpsgraph.updateGraph(graph, n, "Y "..math.floor(box:getY()), dt)
end
