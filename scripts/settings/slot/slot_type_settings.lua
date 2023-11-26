-- chunkname: @scripts/settings/slot/slot_type_settings.lua

local slot_type_settings = {
	normal = {
		count = 9,
		priority = 2,
		distance = 1.85,
		queue_distance = 4.5,
		radius = 0.5,
		dialogue_surrounded_count = 4
	},
	medium = {
		count = 8,
		priority = 1.5,
		distance = 2.2,
		queue_distance = 5,
		radius = 1,
		dialogue_surrounded_count = 3
	},
	large = {
		count = 5,
		priority = 1,
		distance = 2.25,
		queue_distance = 5.5,
		radius = 2,
		dialogue_surrounded_count = 2
	}
}

return settings("SlotTypeSettings", slot_type_settings)
