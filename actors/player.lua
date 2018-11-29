local Actor = require "actor"

local Player = Actor()

Player:addComponents(
	components.Light{ 0.8666/.6, 0.4509/.6, 0.0862/.6, 1 },
	components.Sight{ range = 12, fov = true, explored = true },
	components.Message(),
	components.Move(),
	components.Inventory(),
	components.Controller{ inputControlled = true },
	
	components.Stats
	{
		STR = 20,
		DEX = 10,
		INT = 10,
		CON = 10,
		maxHP = 10,
		AC = 10
	},

	components.Attacker
	{
		defaultAttack = 
		{
			name = "Short Sword",
			stat = "STR",
			dice = "1d6"
		}
	},


	components.Equipper{
		"armor"
	}
)

function Player:__new()
	Actor.__new(self)
	self.name = "player"
end


return Player