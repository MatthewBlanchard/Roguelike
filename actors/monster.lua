local Actor = require "actor"
local Vector2 = require "vector"

local Monster = Actor()

Monster:addComponent(
	components.Sight{ range = 12, fov = true, explored = false }
)

Monster:addComponent(
	components.Move()
)

Monster:addComponent(
	components.Stats
	{
		STR = 10,
		DEX = 10,
		INT = 10,
		CON = 10,
		maxHP = 10,
		AC = 10
	}
)

Monster:addComponent(
	components.Attacker
	{
		defaultAttack = 
		{
			name = "Claws",
			stat = "DEX",
			dice = "1d2"
		}
	}
)

Monster:addComponent(
	components.Controller{ inputControlled = false }
)

function Monster:__new()
	Actor.__new(self)
	self.char = "z"
	self.name = "zombie"
end

function Monster:act()
	for k,v in pairs(self.seenActors) do
		if v:is(actors.Player) then
			if self:getRange("box", v) == 1 then
				return self:getAction(actions.Attack)(self, v)
			end

			local mx = v.position.x - self.position.x > 0 and 1 or v.position.x - self.position.x < 0 and -1 or 0
			local my = v.position.y - self.position.y > 0 and 1 or v.position.y - self.position.y < 0 and -1 or 0
			return self:getAction(actions.Move)(self, Vector2(mx, my))
		end
	end

	return self:getAction(actions.Move)(self, Vector2(math.random(1, 2)-2, math.random(1, 2)-2))
end

return Monster