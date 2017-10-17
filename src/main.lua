local state
constants = require 'init'

function love.load()
    constants:Init()
    state = dofile('menu.lua')
    state:load()
end

function love.update(dt) 
    local switchState
    switchState = state:update(dt)
    if switchState ~= nil then
        state = dofile(switchState .. '.lua')
        state:load()
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(scaleX, scaleY)
    state:draw()
    love.graphics.pop()
    --constants:Debug()
end