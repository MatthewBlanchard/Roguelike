local Actor = require "actor"

local Armor = Actor()

Armor:addComponents(
	components.Item(),
	components.Equipment{
		slot = "armor",
		effects = {
			conditions.Modifystats{
				AC = 4
			}
		}
	}
)

function Armor:__new()
	Actor.__new(self)
	self.name = "Chainmail"
end

return Armor