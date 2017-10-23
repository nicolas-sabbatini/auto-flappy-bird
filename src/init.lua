local cons = {}

-- Initialize the constants
function cons:Init()
    local ConfSetings = {}
    -- Check if a configuration file exist
    if love.filesystem.exists('ConfSetings.lua') then
        -- if it exist load the options
        ConfSetings = love.filesystem.load('ConfSetings.lua')
        ConfSetings = ConfSetings()
    end
    -- Set the configurations options
    Realww, Realwh = ConfSetings.windowsWidth or 800, ConfSetings.windowsHeight or 600
    musicV = ConfSetings.musicVolume or 1
    sfxV = ConfSetings.sfxVolume or 1
    fullScreen = ConfSetings.fullScreen or false
    -- Aplly the configuration options
    love.window.setMode(Realww, Realwh,{fullscreen = fullScreen})
    scaleX = Realww / 800
    scaleY = Realwh / 600
    ww = Realww / scaleX
    wh = Realwh / scaleY
    -- Creates the default front
    front = love.graphics.newFont(24)
    love.graphics.setFont(front)
end

-- Save the configuration
function cons:Save()
    -- Check if a configuration file exist
    if not love.filesystem.exists('ConfSetings.lua') then
        -- if it does not exist create one
        file = love.filesystem.newFile('ConfSetings.lua')
    end
    -- Create a table whit the configurations options and write to the configuration file
    local data = 'return { \nwindowsWidth = ' .. Realww .. ',\n windowsHeight = ' .. Realwh .. ',\n musicVolume = ' .. musicV
                .. ',\n sfxVolume = ' .. sfxV .. ',\n fullScreen = '.. tostring(fullScreen) ..'\n}'
    love.filesystem.write('ConfSetings.lua', data)
end

-- Update the windows dimentios variables
function cons:Resize()
    Realww, Realwh, fullScreen = love.window.getMode()
    fullScreen = fullScreen.fullscreen
    scaleX = Realww / 800
    scaleY = Realwh / 600
    ww = Realww / scaleX
    wh = Realwh / scaleY
end

function cons:Debug()
    -- Debug statics
    local stats = love.graphics.getStats( )
    print('----------------------------')
    print(stats.drawcalls .. '   drawcalls')
    print(stats.canvasswitches .. '   canvasswitches')
    print(stats.texturememory / 1024 / 1024 .. ' MB   texturememory')
    print(stats.images .. '    images')
    print(stats.canvases .. '    canvases')
    print(stats.fonts .. '    fonts')
    print(love.timer.getFPS().. '     FPS')
    print('----------------------------')
end

return cons