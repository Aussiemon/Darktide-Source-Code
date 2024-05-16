-- chunkname: @scripts/settings/slot/slot_type_settings.lua

local slot_type_settings = {
	normal = {
		count = 9,
		dialogue_surrounded_count = 4,
		distance = 1.85,
		priority = 2,
		queue_distance = 4.5,
		radius = 0.5,
	},
	medium = {
		count = 8,
		dialogue_surrounded_count = 3,
		distance = 2.2,
		priority = 1.5,
		queue_distance = 5,
		radius = 1,
	},
	large = {
		count = 5,
		dialogue_surrounded_count = 2,
		distance = 2.25,
		priority = 1,
		queue_distance = 5.5,
		radius = 2,
	},
}

return settings("SlotTypeSettings", slot_type_settings)
