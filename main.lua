ROT = require 'src.rot'

conditions = {}
reactions = {}
actions = {}
components = {}
actors = {}

--[[
function randBiDirectional()
    return (math.random()-.5)*2
end

function flicker(baseColor, period, intensity)
    local t = 0
    local color = {baseColor[1], baseColor[2], baseColor[3], baseColor[4]}
    return function(dt)
        t = t + dt

        if t > period then
            t = 0
            local r = 1 - randBiDirectional() * intensity
            color[1] = baseColor[1] * r
            color[2] = baseColor[2] * r
            color[3] = baseColor[3] * r
        end

        return color
    end
end


--]]

-- This is horrible please stop.
local info = {}

targets = require "target"

for k, item in pairs(love.filesystem.getDirectoryItems("actions")) do
    fileName = "actions/" .. item
    love.filesystem.getInfo(fileName, info)
    if info.type == "file" then
        fileName = string.gsub(fileName, ".lua", "")
        local name = string.gsub(item:sub(1,1):upper()..item:sub(2), ".lua", "")

        actions[name] = require(fileName)
    end
end

for k, item in pairs(love.filesystem.getDirectoryItems("actions/reactions")) do
    fileName = "actions/reactions/" .. item
    love.filesystem.getInfo(fileName, info)
    if info.type == "file" then
        fileName = string.gsub(fileName, ".lua", "")
        local name = string.gsub(item:sub(1,1):upper()..item:sub(2), ".lua", "")

        reactions[name] = require(fileName)
    end
end

for k, item in pairs(love.filesystem.getDirectoryItems("components")) do
    fileName = "components/" .. item
    love.filesystem.getInfo(fileName, info)
    if info.type == "file" then
        fileName = string.gsub(fileName, ".lua", "")
        local name = string.gsub(item:sub(1,1):upper()..item:sub(2), ".lua", "")

        components[name] = require(fileName)
    end
end


for k, item in pairs(love.filesystem.getDirectoryItems("conditions")) do
    fileName = "conditions/" .. item
    love.filesystem.getInfo(fileName, info)
    if info.type == "file" then
        fileName = string.gsub(fileName, ".lua", "")
        local name = string.gsub(item:sub(1,1):upper()..item:sub(2), ".lua", "")

        conditions[name] = require(fileName)
    end
end

for k, item in pairs(love.filesystem.getDirectoryItems("actors")) do
    fileName = "actors/" .. item
    love.filesystem.getInfo(fileName, info)
    if info.type == "file" then
        fileName = string.gsub(fileName, ".lua", "")
        local name = string.gsub(item:sub(1,1):upper()..item:sub(2), ".lua", "")

        actors[name] = require(fileName)
    end
end

local Level = require "level"
local Interface = require "interface"

function love.load()
    display = ROT.Display(66, 66)
    map = ROT.Map.Rogue(display:getWidth(), 50)

    interface = Interface(display)
    level = Level(map)

    player = actors.Player()
    local x, y = level:getRandomWalkableTile()
    player.position.x = x
    player.position.y = y
    level:addActor(player)

    for i = 1, 20 do
        local monster = actors.Monster()
        local x, y = level:getRandomWalkableTile()
        monster.position.x = x
        monster.position.y = y
        level:addActor(monster)
    end

    for i = 1, 5 do
        local potion = actors.Potion()
        local x, y = level:getRandomWalkableTile()
        potion.position.x = x
        potion.position.y = y
        level:addActor(potion)
    end

    local potion = actors.Potion()
    local armor = actors.Armor()
    table.insert(player.inventory, potion)
    table.insert(player.inventory, armor)
end

function love.draw()
    display:clear()
        interface:draw(display)
    display:draw()
end

function love.update(dt)
    --print(dt)
    waitingInput = level:update(dt, interface:getAction())
    interface:update(dt, level, waitingInput)
end

function love.keypressed(key, scancode)
    interface:handleKeyPress(key, scancode)
end

