local Panel = require "panel"

local StatusPanel = Panel()

function StatusPanel:__new(display, parent)
	Panel.__new(self, display, parent, 1, 51, 15, 3)
end

function StatusPanel:draw(actor)
	local hpPercentage = actor.HP/actor.maxHP
	local barLength = math.floor(15 * hpPercentage)
	local hpString = tostring(actor.HP) .. "/" .. tostring(actor.maxHP) .. " HP"

	for i = 1, 15  do
		local c = string.sub(hpString, i, i)
		c = c == "" and " " or c

		local bg = barLength >= i and {.3, .3, .3, 1} or {.2, .1, .1, 1}
		self:write(c, i, 1, {.6, .6, .6, 1}, bg)
	end

	local statbonus = actor:getStatBonus(actor.attack.stat)
	self:write(actor.attack.name, 1, 2, {.5, .5, .5, 1})
	self:write("AC: " .. actor:getAC(), 1, 3, {.5, .5, .5, 1})
end

return StatusPanel