local menu = {}

local fw, fh, options, arrow, input

function menu:load()

    input = require('simpleKey')
    input:keyInit({'w','s','return'})

    options = { 'Start',
                 'Options',
                 'Exit'}

    love.mouse.setVisible(false)

    arrow = {} 
    arrow.img = love.graphics.newImage('arrow.png')
    arrow.pos = 1

    fw = front:getWidth('Options')
    fh = front:getHeight(' ')

end

function menu:update(dt)

    input:updateInput()

    -- Move the arrow
    if input:isReleased('w') then arrow.pos = arrow.pos - 1 end
    if input:isReleased('s') then arrow.pos = arrow.pos + 1 end
    if arrow.pos < 1 then arrow.pos = 3 end
    if arrow.pos > 3 then arrow.pos = 1 end

    -- Select an option
    if input:isReleased('return') and arrow.pos == 1 then return 'game/game' end
    if input:isReleased('return') and arrow.pos == 2 then return 'options' end
    if input:isReleased('return') and arrow.pos == 3 then love.event.quit() end

end

function menu:draw(dt)

    -- Get the default color
    local r, v, a = love.graphics.getColor()

    -- For each option we create
    for i, _ in ipairs(options) do
        -- Get the midle of the scren
        local h1, h2 =  -fw/2 + (ww/2), -(fh * (2 - i)) + (wh/2)
        -- Set the draw color white
        love.graphics.setColor(255,255,255)
        -- Draw the text
        love.graphics.print(options[i], h1, h2)
        -- If the arrow is selecting the text, drwa the arrow
        if arrow.pos == i then
            love.graphics.draw(arrow.img, h1 - 16, h2 + 5)
        end
    end

    -- Set draw color default
    love.graphics.setColor(r, v, a)

end

return menu