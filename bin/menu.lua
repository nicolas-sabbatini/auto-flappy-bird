local menu = {}

local fw, fh, input, menuCanvas, opt

----------------------------------------------------------
-------------Help Function--------------------------------
----------------------------------------------------------

local function menuCanvasUpdate(num)
    love.graphics.setCanvas(menuCanvas)
        love.graphics.clear()
        love.graphics.setColor(141, 153, 255)
        love.graphics.circle('fill', 8, (fh*num)+(fh/2), 8, 3)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Start', 16, 0)
        love.graphics.print('Options', 16, fh)
        love.graphics.print('Exit', 16, fh*2)
    love.graphics.setCanvas()
end

local function optUpdate(num)
    opt = opt + num
    if opt < 0 then opt = 2 end
    if opt > 2 then opt = 0 end
end

local function quit(newState)
    fw = nil
    fh = nil
    input = nil
    menuCanvas = nil
    opt = nil
    return newState
end


----------------------------------------------------------
----------------------------------------------------------


function menu:load()

    love.mouse.setVisible(false)

    input = require('simpleKey')
    input:keyInit({'w', 's', 'return'})

    fw = front:getWidth('Options')
    fh = front:getHeight(' ')

    menuCanvas = love.graphics.newCanvas(fw + 16, fh * 3)
    opt = 0
    menuCanvasUpdate(opt)

end

function menu:update(dt)

    input:updateInput()

    -- Move the arrow
    if input:isReleased('w') then 
        optUpdate(-1)
        menuCanvasUpdate(opt)
    end
    if input:isReleased('s') then
        optUpdate(1) 
        menuCanvasUpdate(opt)
    end
    
    -- Select an option
    if input:isReleased('return') and opt == 0 then return quit('game/game') end
    if input:isReleased('return') and opt == 1 then return quit('options') end
    if input:isReleased('return') and opt == 2 then love.event.quit() end

end

function menu:draw(dt)
    love.graphics.draw(menuCanvas, ww/2 - 8 - fw/2, wh/2 - fh*1.5 )
end

return menu