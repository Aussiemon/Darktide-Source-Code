-- chunkname: @scripts/settings/slot/slot_type_settings.lua

local slot_type_settings = {
	normal = {
		count = 9,
		distance = 1.85,
		priority = 2,
		queue_distance = 2.65,
		radius = 0.5,
	},
	medium = {
		count = 8,
		distance = 2.2,
		priority = 1.5,
		queue_distance = 2.8,
		radius = 1,
	},
	large = {
		count = 5,
		distance = 2.25,
		priority = 1,
		queue_distance = 3.25,
		radius = 2,
	},
}

return settings("SlotTypeSettings", slot_type_settings)
