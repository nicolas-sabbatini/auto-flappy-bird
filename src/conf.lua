function love.conf(t)
    t.identity = 'Auto-Flappy-Bird'             -- The name of the save directory (string)
    t.version = "11.3"                     -- The LÖVE version this game was made for (string)

    t.window.title = "Auto FlappyBird"         -- The window title (string)
--    t.window.icon = TODO                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = 800                   -- The window width (number)
    t.window.height = 600                  -- The window height (number)
    t.window.resizable = true              -- Let the window be user-resizable (boolean)
    t.window.minwidth = 400                -- Minimum window width if the window is resizable (number)
    t.window.minheight = 300               -- Minimum window height if the window is resizable (number)
    t.window.vsync = 1                     -- Vertical sync mode (number)
end