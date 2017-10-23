local options = {}

local arrow, changes, op, windows, currenrW

function options:load()

    input = require('simpleKey')
    input:keyInit({'w','s','a','d','return'})

    arrow = {}
    arrow.img = love.graphics.newImage('arrow.png')
    arrow.pos = 1
        
    local wW, wH, full = love.window.getMode( )
    
    if full['fullscreen'] then
        currenrW = 5
    elseif wW == 800 and wH == 600 then
        currenrW = 1
    elseif wW == 1000 and wH == 750 then
        currenrW = 2
    elseif wW == 1200 and wH == 900 then
        currenrW = 3
    elseif wW == 1600 and wH == 1200 then
        currenrW = 4
    end

    windows = {{'800x600',800,600, false},
               {'1000x750',1000,750, false},
               {'1200x900',1200,900, false},
               {'1600x1200',1600,1200, false},
               {'Full Screen',1600,1200, true}}

    op = {  'SFX' .. ' ' .. (sfxV * 100),
            'Musica'  .. ' ' .. (musicV * 100),
            'Pantalla' .. ' ' .. windows[currenrW][1],
            'Guardar',
            'Menu'}

    changes = false

end

local function change(amount, dt)

    local help = 0
    if arrow.pos == 1 then
        -- The + 0.1 avoids a bug in math.floor
        help = math.floor(sfxV * 100 + amount * 10 + 0.1)
        if help <= 100 and help >= 0 then
            sfxV = help/100
            op[1] = 'SFX' .. ' ' .. help
            changes = true
        end
    elseif arrow.pos == 2 then
        help = math.floor(musicV * 100 + amount * 10 + 0.1)
        if help <= 100 and help >= 0 then
            musicV = help/100
            op[2] = 'Musica' .. ' ' .. help
            changes = true
        end
    elseif arrow.pos == 3 then
        help = currenrW + amount
        if help < 1 then
            currenrW = 5
        elseif help > 5 then
            currenrW = 1
        else
            currenrW = help
        end
        op[3] = 'Pantalla' .. ' ' ..  windows[currenrW][1]
        love.window.setMode( windows[currenrW][2], windows[currenrW][3], {fullscreen = windows[currenrW][4]})
        constants:Resize()
        changes = true
    end

end

function options:update(dt)

    input:updateInput()

    if input:isReleased('w') then arrow.pos = arrow.pos - 1 end
    if input:isReleased('s') then arrow.pos = arrow.pos + 1 end
    if input:isReleased('a') then 
        change(-1, dt)
    end
    if input:isReleased('d') then
        change( 1, dt)
    end
    if input:isReleased('return') and arrow.pos == 4 then 
        constants:Save()
    end
    if input:isReleased('return') and arrow.pos == 5 then return 'menu' end
    if arrow.pos < 1 then arrow.pos = 5 end
    if arrow.pos > 5 then arrow.pos = 1 end

end

function options:draw()
    local r, v, a = love.graphics.getColor()
    local mV, sV = musicV * 100, sfxV * 100
    local fh = front:getHeight(' ')
    
    for i, s in pairs(op) do
        local fw = front:getWidth(s)
        local h1, h2 =  -fw/2 + (ww/2), -(fh * (3 - i)) + (wh/2)
        love.graphics.setColor(255,255,255)
        love.graphics.print(s, h1, h2)
        if arrow.pos == i then
            love.graphics.draw(arrow.img, h1 - 16, h2 + 5)
        end
    end

    love.graphics.setColor(r, v, a)
end

return options