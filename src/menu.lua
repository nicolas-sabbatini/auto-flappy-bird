local menu = {}

local fw, fh, options, arrow, temp

function menu:load()

    options = { "Start",
                 "Options",
                 "Exit"}

    love.mouse.setVisible(false)

    arrow = {} 
    arrow.img = love.graphics.newImage("arrow.png")
    arrow.pos = 1

    fw = front:getWidth("Options")
    fh = front:getHeight(" ")

    temp = 0.3
end

function menu:update(dt)

    temp = temp - dt
    local key = love.keyboard.isDown
    -- Move the arrow
    if key("w") and (temp < 0) then arrow.pos, temp = arrow.pos - 1, 0.3 end
    if key("s") and (temp < 0) then arrow.pos, temp = arrow.pos + 1, 0.3 end
    if arrow.pos < 1 then arrow.pos = 3 end
    if arrow.pos > 3 then arrow.pos = 1 end

    -- Select an option
    if key("return") and arrow.pos == 1 and (temp < 0) then return "game/game" end
    if key("return") and arrow.pos == 2 and (temp < 0) then return "opciones" end
    if key("return") and arrow.pos == 3 and (temp < 0) then love.event.quit() end

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