-- Load globals
require './globals'

-- Load libs
local push = require './libs/push'

-- Load states
local Menu = require './menu'
local Play = require './play'

-- Push set up
function love.resize(w, h)
    push:resize(w, h)
end

push:setupScreen(GAME_WIDTH, GAME_HEIGHT, 800, 600, {
    vsync = true,
    fullscreen = false,
    resizable = true,
})

-- Set up imputs
function love.keypressed(key)
    KEY_TABLE[key] = true
end

-- Set up state machine
local states = {
    menu = Menu:new(),
    play = Play:new(),
}
local return_value = false;
local current_state = 'menu'

function love.load()

end

function love.update(dt)
    if KEY_TABLE['escape'] then
        love.event.quit()
    end

    return_value = states[current_state]:update(dt)
    if return_value then
        current_state = return_value
        states[current_state]:load()
    end

    KEY_TABLE = {}
end

function love.draw()
    push:start()
    states[current_state]:draw()
    push:finish()
end