local mx = require './libs/matrix/matrix'

---------------------------------------------------------------------
-- All Auxiliar functions -------------------------------------------
---------------------------------------------------------------------
-- Activation function of the neuron
local function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

local function searchTarget(bird, pipes)
    for i, pipe in pairs(pipes) do
        if (pipe.x + pipe.w) > bird.x then
            bird.target_pipe = pipe
            return
        end
    end
end

-- Neural Network forward propagation and flat the result
local function think(bird, pipes)
    local t_x, t_y

    -- If the bird dont have a target
    if not bird.target_pipe then
        -- Serch for one
        searchTarget(bird, pipes)
    end

    -- If there still no target
    if bird.target_pipe then
        t_x = (bird.target_pipe.x + bird.target_pipe.w)
        t_y = (bird.target_pipe.y + math.floor(bird.target_pipe.g / 2))
        -- Clear target once the distance to the pipe is 0
        if t_x - bird.x <= 0 then
            bird.target_pipe = nil
        end
    else
        -- Set target to an arbitrary point
        t_x = 980
        t_y = 300
    end

    -- The input is the distant to the center right of the gap of the pipe
    local input = mx { { t_x - bird.x, t_y - bird.y } }
    local result = mx.replace(mx.mul(input, bird.hidden), sigmoid)
    result = mx.replace(mx.mul(result, bird.output), sigmoid)
    result = mx.getelement(result, 1, 1)
    return result
end

-- Sort birds
local function sortBirds(bird1, bird2)
    return bird1.fitness > bird2.fitness
end

-- Cross 2 birds, parent1 ~= parent2 or parent1 == parent2
local function reproduce(parent1, parent2)
    local newBird = {}
    newBird.x = (parent1.x + parent2 .x) / 2
    newBird.y = love.math.random(40, 560)
    newBird.speed = 0
    -- Neuron input x Amount of neurons
    -- hidden layer
    -- mx.copy is not working correctly
    newBird.hidden = mx.mulnum(parent2.hidden, 1)
    -- Output layer
    newBird.output = mx.mulnum(parent1.output, 1)
    -- Mutation
    if love.math.random() > 0.5 then
        if love.math.random() > 0.5 then
            mx.random(newBird.output)
        else
            mx.random(newBird.hidden)
        end
    end
    -- The color always change
    return newBird
end

-- Kill and Reproduce
local function killAndReproduce(data)
    data.generation = data.generation + 1
    -- Kill half of the population randomly, the best 3 always survive
    while #data.birds > (data.birds_amount / 2) do
        local kill = love.math.random(4, #data.birds)
        table.remove(data.birds, kill)
    end
    -- Breed randomly between survivors
    while #data.birds < data.birds_amount do
        local parent1, parent2 = love.math.random(1, (data.birds_amount / 2)), love.math.random(1, (data.birds_amount / 2))
        table.insert(data.birds, reproduce(data.birds[parent1], data.birds[parent2]))
    end
    -- Set the bird variables to default
    for _, bird in pairs(data.birds) do
        bird.alive = true
        bird.fitness = 0
        bird.target_pipe = nil
    end
    data.alive = #data.birds
    data.pipes = {
        new_pipe(),
    }
    data.pipes_timer_delta = 0
end

-- Check if a bird and a pipe collide
local function collision(bird, pipes)
    for i, pipe in pairs(pipes) do
        if (bird.x + 16 > pipe.x)
                and (bird.x < pipe.x + pipe.w)
                and ((bird.y < pipe.y)
                or (bird.y + 16 > pipe.y + pipe.g))
                or (bird.y < 0)
                or (bird.y > 600) then
            bird.alive = false
            return true
        end
    end
end

-- Create new pipe
function new_pipe()
    return {
        x = 900,
        y = love.math.random(50, 400),
        g = 150,
        w = 80,
    }
end

-- Create a new random bird
function new_random_bird()
    local b = {
        x = love.math.random(40, 760),
        y = love.math.random(40, 560),
        speed = 0,
        -- Neuron input x Amount of neurons
        -- Hidden layer
        hidden = mx(2, 6),
        -- Output layer
        output = mx(6, 1),
        -- Fitness
        fitness = 0,
        alive = true,
    }
    mx.random(b.hidden)
    mx.random(b.output)
    return b
end
----------------------------------------------------------------------
----------------------------------------------------------------------

local Play = {}
Play.__index = Play

function Play:new()
    local p = {}
    setmetatable(p, Play)
    return p
end

function Play.load(self)
    -- Set the seed
    love.math.setRandomSeed(os.time())

    -- Birds
    -- Create generation info
    self.generation = 1
    self.best = 0
    self.alive = 40
    self.birds_amount = 40

    -- Create te base population
    self.birds = {}
    for i = 1, self.alive do
        table.insert(self.birds, new_random_bird())
    end

    -- Pipes
    self.pipes = {
        new_pipe(),
    }

    self.pipes_timer = 3
    self.pipes_timer_delta = 0


    -- Set simulation speed
    self.simulation_speed = 10

    -- Create canvas UI
    self.canvasUI = {}
    self.canvasUI.canvas = love.graphics.newCanvas(220, 190)
    function self.canvasUI.draw(data)
        love.graphics.setCanvas(data.canvasUI.canvas)
        love.graphics.clear()
        love.graphics.setColor(0.2, 0.3, 0.2, 0.4)
        love.graphics.rectangle('fill', 0, 0, 220, 600)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(FONT_SMALL)
        love.graphics.print('Genetation: ' .. data.generation, 10, 10)
        love.graphics.print('Alive: ' .. data.alive, 10, 40)
        love.graphics.print('Best fitness: ' .. math.floor(data.best), 10, 70)
        love.graphics.print('Simulation speed: - ' .. data.simulation_speed .. ' +', 10, 100)
        love.graphics.print('"K" - New generation', 10, 130)
        love.graphics.print('"ESC" - Quit', 10, 160)
        love.graphics.setCanvas()
    end
    self.canvasUI.draw(self)
end

function Play.update(self, _dt)
    if KEY_TABLE['-'] or KEY_TABLE['kp-'] then
        self.simulation_speed = math.max(self.simulation_speed - 1, 1)
    end

    if KEY_TABLE['+'] or KEY_TABLE['kp+'] then
        self.simulation_speed = math.min(self.simulation_speed + 1, 40)
    end

    if KEY_TABLE['k'] then
        killAndReproduce(self)
    end

    for _step = 1, self.simulation_speed do
        local dt = 0.005

        self.pipes_timer_delta = self.pipes_timer_delta + dt
        if self.pipes_timer_delta > self.pipes_timer then
            table.insert(self.pipes, new_pipe())
            self.pipes_timer_delta = 0
        end

        -- Update pipes
        for i, pipe in pairs(self.pipes) do
            pipe.x = pipe.x - (175 * dt)
            if pipe.x < -pipe.w then
                table.remove(self.pipes, i)
                i = i - 1
            end
        end

        -- Update birds
        for _, bird in pairs(self.birds) do
            if bird.alive then
                if think(bird, self.pipes) >= 0.5 then
                    bird.speed = -250
                end
                bird.speed = bird.speed + (250 * dt)
                bird.y = bird.y + (bird.speed * dt)
                bird.fitness = bird.fitness + dt
                if collision(bird, self.pipes) then
                    self.alive = self.alive - 1
                end
            end
        end

        -- Sort
        table.sort(self.birds, sortBirds)
        self.best = self.birds[1].fitness

        if self.alive <= 0 then
            killAndReproduce(self)
        end

        self.canvasUI.draw(self)
    end
end

function Play.draw(self)
    -- Draw birds
    for _, bird in pairs(self.birds) do
        if bird.alive then
            love.graphics.rectangle('fill', bird.x, bird.y, 16, 16)
        end
    end

    -- Draw pipes
    love.graphics.setColor(0, 0.5, 0)
    for _, pipe in pairs(self.pipes) do
        love.graphics.rectangle('fill', pipe.x, 0, pipe.w, pipe.y)
        love.graphics.rectangle('fill', pipe.x, pipe.y + pipe.g, pipe.w, 600 - pipe.y - pipe.g)
    end
    love.graphics.setColor(1, 1, 1)

    -- Draw UI
    love.graphics.draw(self.canvasUI.canvas, 580, 0)
end

return Play