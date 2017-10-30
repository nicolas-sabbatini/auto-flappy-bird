local options = {}

local input, conf, fh, fw, saveData, complete, time, optionsMenu, state

----------------------------------------------------------
-------------Help Function--------------------------------
----------------------------------------------------------

local function change(amount, dt)
   if optionsMenu.opt == 0 then
       -- The + 0.1 avoids a bug in math.floor
       local help = math.floor(sfxV * 100 + amount * 10 + 0.1)
       if help <= 100 and help >= 0 then
           sfxV = help/100
       end
   elseif optionsMenu.opt == 1 then
       local help = math.floor(musicV * 100 + amount * 10 + 0.1)
       if help <= 100 and help >= 0 then
           musicV = help/100
       end
   elseif optionsMenu.opt == 2 then
       local help1, help2 = conf.ww + (200 * amount), conf.wh + (150 * amount)
       local full = conf.full
       if help1 >= 800 and help1 <= 1600 and not full then
           conf.ww = conf.ww + (200 * amount)
       end 
       if help2 >= 600 and help2 <= 1200 and not full then
           conf.wh = conf.wh + (150 * amount)
       end
       if full and amount == -1 then
           conf.full = false
           conf.ww, conf.wh = 1600, 1200
       elseif help1 > 1600 and help2 > 1200 then
           conf.full = true
       end
       love.window.setMode( conf.ww, conf.wh, {fullscreen = conf.full})
       constants:Resize()
       complete.update()
       saveData.update(saveData.opt)
   end
   optionsMenu.update(optionsMenu.opt) 
end

local function screenState()
    if conf.full then
        conf.screen = 'Full Screen'
    else
        conf.screen = 'Screen ' .. conf.ww .. 'x' .. conf.wh
    end
end

local function quit(newState)
    input = nil
    conf = nil
    fh = nil
    fw = nil
    saveData = nil
    complete = nil
    time = nil
    optionsMenu = nil
    state = nil
    return newState
end

----------------------------------------------------------
----------------------------------------------------------

function options:load()

    input = require('simpleKey')
    input:keyInit({'w','s','a','d','return'})

    conf = {}
    conf.ww, conf.wh, conf.full = love.window.getMode( )
    conf.full = conf.full.fullscreen
    conf.screen = ''
    screenState()

    fh = front:getHeight(' ')

    fw = front:getWidth('Save options') + 16
    saveData = {}
    saveData.canvas = love.graphics.newCanvas(fw, fh * 3)
    saveData.ch = fh*3
    saveData.cw = fw
    saveData.opt = 0
    function saveData.update(num)
        love.graphics.setCanvas(saveData.canvas)
            love.graphics.clear()
            -- Black rectangle that cobers all canvas, if not you can see through
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle('fill', 0, 0, saveData.cw, fh * 3)
            love.graphics.setColor(141, 153, 255)
            love.graphics.circle('fill', 8, (fh*(num + 1))+(fh/2), 8, 3)
            love.graphics.setColor(255, 255, 255)
            love.graphics.print('Save options', 0, 0)
            love.graphics.print('YES', 16, fh)
            love.graphics.print('NO', 16, fh*2)
        love.graphics.setCanvas()
    end
    function saveData.optUpdate(num)
        saveData.opt = saveData.opt + num
        if saveData.opt < 0 then saveData.opt = 1 end
        if saveData.opt > 1 then saveData.opt = 0 end
    end
    saveData.update(saveData.opt)

    fw = front:getWidth('Saved completed')
    time = 1
    complete = {}
    complete.canvas = love.graphics.newCanvas(fw,fh)
    complete.ch = fh
    complete.cw = fw
    function complete.update()
        love.graphics.setCanvas(complete.canvas)
            love.graphics.clear()
            -- Black rectangle that cobers all canvas, if not you can see through
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle('fill',0,0,fw,fh)
            love.graphics.setColor(255,255,255)
            love.graphics.print('Saved completed',0,0)
        love.graphics.setCanvas()
    end
    complete.update()

    fw = front:getWidth('Screen 1600x1200') + 16
    optionsMenu = {}
    optionsMenu.canvas = love.graphics.newCanvas(fw,fh*5)
    optionsMenu.ch = fh*5
    optionsMenu.cw = fw
    optionsMenu.opt = 0
    function optionsMenu.update(num)
        love.graphics.setCanvas(optionsMenu.canvas)
            love.graphics.clear()
            -- Black rectangle that cobers all canvas, if not you can see through
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle('fill', 0, 0, optionsMenu.cw, fh * 3)
            love.graphics.setColor(141, 153, 255)
            love.graphics.circle('fill', 8, (fh*(num))+(fh/2), 8, 3)
            love.graphics.setColor(255,255,255)
            love.graphics.print('SFX '.. (sfxV * 100), 16, 0)
            love.graphics.print('Musica ' .. (musicV * 100), 16, fh)
            screenState()
            love.graphics.print(conf.screen, 16, fh*2)
            love.graphics.print('Save', 16, fh*3)
            love.graphics.print('Menu', 16, fh*4)
        love.graphics.setCanvas()
    end
    function optionsMenu.optUpdate(num)
        optionsMenu.opt = optionsMenu.opt + num
        if optionsMenu.opt < 0 then optionsMenu.opt = 4 end
        if optionsMenu.opt > 4 then optionsMenu.opt = 0 end
    end
    optionsMenu.update(optionsMenu.opt)

    state = 0

end

function options:update(dt)

    input:updateInput()
 
    if state == 0 then
        if input:isReleased('w') then
            optionsMenu.optUpdate(-1)
            optionsMenu.update(optionsMenu.opt)
        end
        if input:isReleased('s') then
            optionsMenu.optUpdate(1)
            optionsMenu.update(optionsMenu.opt)
        end
        if input:isReleased('a') then 
            change(-1, dt)
        end
        if input:isReleased('d') then
            change( 1, dt)
        end
        if input:isReleased('return') and optionsMenu.opt == 3 then 
            state = 1
        end
        if input:isReleased('return') and optionsMenu.opt == 4 then
            return quit('menu')
        end
    elseif state == 1 then
        if input:isReleased('w') then
            saveData.optUpdate(-1)
            saveData.update(saveData.opt)
        end
        if input:isReleased('s') then
            saveData.optUpdate(1)
            saveData.update(saveData.opt)
        end
        if input:isReleased('return') then
            if saveData.opt == 0 then
                state = 2
                constants:Save()
            else
                state = 0
            end
        end
    elseif state == 2 then
        time = time - dt
        if time < 0 then
            time = 1
            state = 0
        end
    end
end

function options:draw()
    local ww, wh = ww/2, wh/2
    love.graphics.draw(optionsMenu.canvas, ww - optionsMenu.cw/2, wh - optionsMenu.ch/2)
    if state == 1 then
        love.graphics.draw(saveData.canvas, ww - saveData.cw/2, wh - saveData.ch/2)
    elseif state == 2 then
        love.graphics.draw(complete.canvas, ww - complete.cw/2, 0)
    end
end

return options