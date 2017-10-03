local cons = {}

local ConfSetings

-- Initialize the constants
function cons:init()

    if love.filesystem.exists('ConfSetings.lua') then
        ConfSetings, _ = love.filesystem.read('ConfSetings.lua')
        ConfSetings = dofile('ConfSetings.lua')
    end
    -- Create global options
    ww, wh = ConfSetings.windowsWidth or 800, ConfSetings.windowsHeight or 600
    musicV = ConfSetings.musicVolume or 1
    sfxV = ConfSetings.sfxVolume or 1
    
    -- Set the windows dimentions
    love.window.setMode(ww, wh)
    scaleX = ww / 800
    scaleY = wh / 600
    ww = ww / scaleX
    wh = wh / scaleY

    -- Creates the default front
    front = love.graphics.newFont(24)
    love.graphics.setFont(front)

end

-- Update the windows dimentios variables
function cons:Resize()
   
    ww = love.graphics.getWidth()
    wh = love.graphics.getHeight()
    scaleX = ww / 800
    scaleY = wh / 600
    ww = ww / scaleX
    wh = wh / scaleY

end


function cons:debug()
    -- Debug statics
    local stats = love.graphics.getStats( )
    print("----------------------------")
    print(stats.drawcalls .. "   drawcalls")
    print(stats.canvasswitches .. "   canvasswitches")
    print(stats.texturememory / 1024 / 1024 .. " MB   texturememory")
    print(stats.images .. "    images")
    print(stats.canvases .. "    canvases")
    print(stats.fonts .. "    fonts")
    print(love.timer.getFPS().. "     FPS")
    print("----------------------------")
end


return cons