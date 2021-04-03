local Menu = {}
Menu.__index = Menu

function Menu:new()
    local m = {}
    setmetatable(m, Menu)
    return m
end

function Menu.load(self)
end

function Menu.update(self, dt)
    if KEY_TABLE['return'] then
        return 'play'
    end
end

function Menu.draw(self)
    -- Draw title
    love.graphics.setFont(FONT_BIG)
    local screen_center = (GAME_WIDTH - FONT_BIG:getWidth('Auto FlappyBird')) / 2
    love.graphics.print('Auto FlappyBird', screen_center, 150)

    -- Draw menu
    love.graphics.setFont(FONT_MEDIUM)
    local screen_center = (GAME_WIDTH - FONT_MEDIUM:getWidth('Press "ENTER" to start')) / 2
    love.graphics.print('Press "ENTER" to start', screen_center, 260)
end

return Menu