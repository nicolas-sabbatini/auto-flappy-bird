local game = {}

local mx = require "game/matrix/matrix"
local bird, pipe, alive, generation, best

---------------------------------------------------------------------
-- All Auxiliar functions -------------------------------------------
---------------------------------------------------------------------
-- Activation function of the neuron
local function sigmoid( x )
    return 1 / (1 + math.exp(-x))
end
-- Flat a number to 0 or 1
local function flat( x )
    if x < 0.5 then return 0
    else return 1 end
end
-- Neural Network foward propagation and flat the result
local function think(bird, pipe)
    -- The input is the distant to the center rigth of the gap of the pipe
    local input = mx{{(pipe.x + pipe.w) - bird.x, (pipe.y + math.floor(pipe.g/2)) - bird.y}}
    local result = mx.replace(mx.mul(input, bird.hiden), sigmoid)
    result = mx.replace(mx.mul(result, bird.output), sigmoid)
    result = flat(mx.getelement(result, 1, 1))
    return result
end
-- Sort birds
local function sortB(bird1, bird2)
return  bird1.fitnes > bird2.fitnes
end
-- Cros 2 birds, parent1 ~= parent2 or parent1 == parent2
local function reproduce(parent1, parent2)
    local newBird = {}
    newBird.x = 40
    newBird.y = 280
    newBird.speed = 0
    -- Neuron input x Amount of neurons
    -- Hiden layer
    -- mx.copy is not working corectly
    newBird.hiden = mx.mulnum(parent2.hiden,1)
    -- Output layer
    newBird.output = mx.mulnum(parent1.output,1)
    -- Mutation
    if math.random() > 0.5 then
        if math.random() > 0.5 then
            mx.random(newBird.output)
        else
            mx.random(newBird.hiden)
        end
    end
    -- The color always change
    newBird.color = {parent1.color[2], parent2.color[1], math.random(0, 255)}
    return newBird
end
-- Kill and Reproduce
local function killAndReproduce(bird)
    generation = generation + 1
    -- Kill half of the population randomly, the best 3 always survive
    while #bird > 5 do
        local kill = math.random(4, #bird)
        table.remove(bird,kill)
    end
    -- Breed randomly between survivors
    while #bird < 10 do
        local parent1, parent2 = math.random(1, 5), math.random(1, 5)
        table.insert(bird, reproduce(bird[parent1], bird[parent2]))
    end
    -- Set the bird variables to default
    for i=1, 10 do
        bird[i].alive = true
        bird[i].fitnes = 0
        bird[i].y = 280
    end
    pipe.x = 500
    pipe.y = love.math.random( 50, 400)
end
-- Check if a bird and a pipe colida
local function colition(bird, pipe)
    if (bird.x + 40 > pipe.x) 
            and (bird.x < pipe.x + pipe.w) 
            and ((bird.y < pipe.y)
            or (bird.y + 40 > pipe.y + pipe.g))
            or (bird.y < 0) 
            or (bird.y > 600) then
                bird.alive = false
            end
end
----------------------------------------------------------------------
----------------------------------------------------------------------

function game:load()

    input = require('simpleKey')
    input:keyInit({'k','s','q'})
    
    -- Set the seed
    --math.randomseed(1)
    math.randomseed(os.time())
    generation = 1
    best = 0
    alive = 10

    -- Create the pipe
    pipe = {}
    pipe.x = 500
    pipe.y = love.math.random( 50, 400)
    pipe.g = 150
    pipe.w = 80

    -- Create te base population
    bird = {}
    for i=1, 10 do
        bird[i] = {}
        -- Bird variables
        bird[i].x = 40
        bird[i].y = 280
        bird[i].speed = 0
        -- Neuron input x Amount of neurons
        -- Hiden layer
        bird[i].hiden = mx(2, 5)
        mx.random(bird[i].hiden)
        -- Output layer
        bird[i].output = mx(5, 1)
        mx.random(bird[i].output)
        -- Fitnes
        bird[i].fitnes = 0
        bird[i].alive = true
        bird[i].color = {math.random(0, 255), math.random(0, 255), math.random(0, 255)}
    end

end

function game:update(dt)

    input:updateInput()

    -- Kill the current generation
    if input:isReleased('k') then killAndReproduce(bird) end
    -- Enable or disable vsync
    if input:isReleased('s') then
        local ww, wh, mode = love.window.getMode( )
        love.window.setMode(ww, wh, { fullscreen = mode.fullscreen, vsync= not mode.vsync})
    end
    -- Exit main menu
    if input:isReleased('q') then
        function game:update(dt) return 'menu' end
    end

    -- Every frame the game is going to move foward 0.005 sec
    local dt = 0.005
    local dead = 0
    -- Pipe movement
    pipe.x = pipe.x - (175 * dt)
    if pipe.x < -pipe.w then
        pipe.x = 500
        pipe.y = love.math.random( 50, 400)
    end
    for i=1, 10 do
        if bird[i].alive then
            local result
            -- Foward propagation in the neural network of the bird
            result = think(bird[i], pipe)
            -- If the result of that fp is 1 the bird is going to flap
            if result == 1 then
                bird[i].speed = -250
            end
            -- Bird muvement
            bird[i].speed = bird[i].speed + (250*dt)
            bird[i].y = bird[i].y + (bird[i].speed*dt)
            bird[i].fitnes = bird[i].fitnes + dt
            colition(bird[i], pipe)
        else
            dead = dead + 1
        end
    end
    alive = 10 - dead
    -- Sort the birds by fitnes
    table.sort(bird, sortB)
    best = bird[1].fitnes
    -- If every bird is dead make a new generation
    if dead >= 10 then
        killAndReproduce(bird)
    end

end

function game:draw()
    -- Draw bird
    for i=1, 10 do
        if bird[i].alive then
            love.graphics.setColor(bird[i].color[1], bird[i].color[2], bird[i].color[3])
            love.graphics.rectangle('fill', bird[i].x, bird[i].y, 40, 40)
        end
    end
    -- Draw pipe
    love.graphics.setColor(0,155,0)
    love.graphics.rectangle("fill", pipe.x, 0, pipe.w, pipe.y)
    love.graphics.rectangle("fill", pipe.x, pipe.y + pipe.g, pipe.w, 600 - pipe.y - pipe.g)
    -- Draw info
    love.graphics.setColor(255,255,255)
    love.graphics.print("Genetation " .. generation .. " Alive" .. alive .. " Best Fitnest = " .. best, 10, 10)
end

return game