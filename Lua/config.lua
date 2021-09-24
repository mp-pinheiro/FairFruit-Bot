local config = {
    --positions and sizes
    joystickX = 10,
    joystickY = 128,
    joystickWidth = 96,
    joystickHeight = 96,
    twitcherX = 57,
    twitcherY = 158,
    twitcherSize = 10,
    twitcherNameSize = 10,
    fairX = 59,
    fairY = 220,
    timerX = 265,
    timerY = 32,
    timerSize = 12,
    --font
    fontFamily = nil, --must be installed, set nil for default
    --images
    joystickPath = "./img/joystick.png",
    --runtime
    run = false, -- start script listening for inputs
    limit = 300, -- max amount of inputs the queue can hold
    --joypad
    analogTime = 60 / 8, -- how long to press diretional keys
    analogThreshold = 60 / 12, -- how much to keep holding directional keys
    keyTime = 8, -- how long to press action keys
    keyThreshold = 2 -- how much to keep holding action keys
}

-- key maps (map accordingly to `config.json`)
config.keys = {
    ["A Up"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["A Down"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["A Left"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["A Right"] = {
        inputTime = config.analogTime,
        threshold = config.analogThreshold
    },
    ["A"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    },
    ["B"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    },
    ["Z"] = {
        inputTime = config.keyTime,
        threshold = config.keyThreshold
    }
}

return config
