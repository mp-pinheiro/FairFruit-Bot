local Queue = require("Queue")
local Table = require("Table")
local config = require("config")

-- queue implementation
local limit = config.limit
local queue = Queue:new(limit)

-- server info
local info = comm.socketServerGetInfo()
print(info)

-- joypad
local analogTime = config.analogTime
local analogThreshold = config.analogThreshold
local keyTime = config.keyTime
local keyThreshold = config.keyThreshold
local params = config.keys

-- positions, sizes and text
local joystickX = config.joystickX
local joystickY = config.joystickY
local joystickWidth = config.joystickWidth
local joystickHeight = config.joystickHeight
local twitcherX = config.twitcherX
local twitcherY = config.twitcherY
local fontFamily = config.fontFamily
local twitcherSize = config.twitcherSize
local twitcherNameSize = config.twitcherNameSize
local fairX = config.fairX
local fairY = config.fairY
local timerX = config.timerX
local timerY = config.timerY
local timerSize = config.timerSize
local joystickPath = config.joystickPath

-- runtime parameters
local run = config.run
local twitcher
local times = {} -- joypad times of each key

function start()
    run = true
    return "Listening for inputs..."
end

function stop()
    run = false
    return "No longer listening for inputs."
end

-- timer stuff
local counter
local players
local winner
local function _count()
    if counter and counter > 0 then
        counter = counter - 1
    end
end

event.onframestart(_count, "winnerCounter")

function count(t)
    counter = t * 60
    players = {}

    return "Counting down " .. t .. " seconds..."
end

function clear()
    winner = nil
    return "Cleared timer from screen."
end

-- draw text and shadow function
function drawText(x, y, message, size)
    message = message
    gui.drawText(x + 1, y + 1, message, "black", nil, size, fontFamily, "center", "center")
    gui.drawText(x, y, message, nil, nil, size, fontFamily, "center", "center")
end

-- splits string into table
function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

while true do
    -- draw base joystick image
    gui.drawImage(joystickPath, joystickX, joystickY, joystickWidth, joystickHeight)

    -- draw signature
    drawText(fairX, fairY, "fairfruit-bot", twitcherSize)

    -- fetch inputs
    local input = comm.socketServerResponse()
    if run then
        if input and input ~= "" then
            -- break message
            local keys = split(input, ";")
            for _, key in pairs(keys) do
                queue:push(key)
            end
        end

        -- pull and add inputs
        if queue:isEmpty() == false then
            -- get the input and current time
            local msg = queue:pop()
            twitcher, input = unpack(split(msg, ":"))

            -- check for repeated inputs
            local time = times[input] or 0
            local inputTime = params[input] and params[input]["inputTime"] or 0
            local threshold = params[input] and params[input]["threshold"] or 0
            if time == 0 or time >= inputTime - threshold then
                times[input] = 0
            end
        end

        -- draw chatter name and add player
        if twitcher then
            if players then
                table.insert(players, twitcher)
            end

            local size = #twitcher
            local oldName = nil
            if size > twitcherNameSize then
                oldName = twitcher
                twitcher = string.sub(twitcher, 1, twitcherNameSize)
                twitcher = twitcher .. "..."
            end
            drawText(twitcherX, twitcherY, oldName or twitcher, twitcherSize)
        end

        -- press added inputs
        local presses = {}
        for key, time in pairs(times) do
            -- get time
            local inputTime = params[key] and params[key]["inputTime"] or 0

            -- check whether input time is over
            if time >= inputTime then
                times[key] = nil
            else
                -- keep counting
                presses[key] = 1
                times[key] = times[key] + 1

                -- draw press
                local pressPath = "././img/joystick-" .. key .. ".png"
                gui.drawImage(pressPath, joystickX, joystickY, joystickWidth, joystickHeight)
            end
        end

        -- do the counter thing
        if counter then
            if counter > 0 then
                -- draw timer
                drawText(timerX, timerY, math.floor(counter / 60), timerSize)
            else
                winner = Table.random(players)
                counter = nil
                players = nil
            end
        elseif winner then
            drawText(timerX, timerY, winner, timerSize)
        end

        joypad.set(presses, 1)
    end

    -- advance frame
    emu.frameadvance()
end
