--[[
LUA MODULE
        Simple Key v$(_VERSION)

AUTHOR 
        Nicolas C. Sabbatini V.

LICENSE
        MIT License - Copyright (c) 2017

HOME PAGE
        https://github.com/NicolasSabba/simpleKey

DESCRIPTION
        Simple Key is a simple yet awesome input library for Love2d.
        The objective of this library is to make the keyboard input handle
        easy in a small and compact way.
        The library is aimed to be used in small projects.
    
MOTIVATIONS
        There is a lot of input libraries for Love2d, but all of them are big
        and complex, and can be a little over kill use a library that can handel 
        joystick and touch screen for a small project, so I made this.

USAGE
        key = require('simpleKey')
        
        function love.load()
            key:keyInit({'space'})
        end
        
        function love.update(dt)
            key:updateInput()
            if key:isDown('space') then print('space dawn') end
            if key:isReleased('space') then print('space got relised') end
        end

API
        keyInit() -> Init all variables.
        keyBind() -> Bind a key or a table of keys.
        keyUnbind() -> Unbind a key or a table of keys.
        updateInput() -> Update the state of all bound keys.
        isDown() -> Return true if a bound key is down.
        isReleased() -> Return true if a bound key relesed in this frame.
        checkDown() -> Check if a key is dawn, this key don't need to be bound.

DEPENDENCIES
        Love2D

]]--

local simpleKey = {
    _LICENSE     = "MIT License - Copyright (c) 2017",
    _URL         = "https://github.com/NicolasSabba/simpleKey",
    _VERSION     = "0.01"
}

local key = {}

-- Init all variables.
function simpleKey:keyInit(keys)
    keys = keys or {}
    key.keysPressed = {}
    key.keysReleased ={}
    simpleKey:keyBind(keys)
end

-- Check if a key is dawn, this key don't need to be bound.
function simpleKey:checkDown(key)
    return love.keyboard.isDown(key)
end

-- Bind a key or a table of keys.
function simpleKey:keyBind(keys)
    if type(keys)=="table" then
        -- If the keys are a table add all of them to check
        for _, k in pairs(keys) do
            key.keysPressed[k] = false
            key.keysReleased[k] =false
        end
    else
        -- Else add the key intro the keys to check
        key.keysPressed[keys] = false
        key.keysReleased[keys] = false
    end
end

-- Unbind a key or a table of keys.
function simpleKey:keyUnbind(keys)
    if type(keys)=="table" then
        -- If the keys are a table remove all of them
        for _, k in pairs(keys) do
            key.keysPressed[k] = nil
            key.keysReleased[k] = nil
        end
    else
        -- Else remove the key of the keys to check
        key.keysPressed[keys] = nil
        key.keysReleased[keys] = nil
    end
end

-- Update the state of all bound keys.
function simpleKey:updateInput()
    for k, value in pairs(key.keysPressed) do
        local previus = value
        key.keysPressed[k] = simpleKey:checkDown(k)
        key.keysReleased[k] = previus and (not key.keysPressed[k])
    end
end

-- Return true if a bound key is down.
function simpleKey:isDown(k)
    return key.keysPressed[k]
end

-- Return true if a bound key relesed in this frame.
function simpleKey:isReleased(k)
    return key.keysReleased[k]
end

return simpleKey