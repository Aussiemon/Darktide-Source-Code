-- chunkname: @scripts/settings/slot/slot_type_settings.lua

local slot_type_settings = {
	normal = {
		count = 9,
		priority = 2,
		distance = 1.85,
		queue_distance = 2.65,
		radius = 0.5
	},
	medium = {
		count = 8,
		priority = 1.5,
		distance = 2.2,
		queue_distance = 2.8,
		radius = 1
	},
	large = {
		count = 5,
		priority = 1,
		distance = 2.25,
		queue_distance = 3.25,
		radius = 2
	}
}

return settings("SlotTypeSettings", slot_type_settings)
