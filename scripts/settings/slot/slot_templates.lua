-- chunkname: @scripts/settings/slot/slot_templates.lua

local slot_templates = {
	renegade_melee = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = true,
			slot_type = "normal",
		},
	},
	renegade_executor = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = true,
			slot_type = "medium",
		},
	},
	chaos_ogryn = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = false,
			slot_type = "large",
		},
	},
	chaos_spawn = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = false,
			slot_type = "large",
		},
	},
	chaos_poxwalker = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = true,
			slot_type = "normal",
		},
	},
	cultist_berzerker = {
		{
			abandon_slot_when_blocked = false,
			abandon_slot_when_blocked_time = 0.3,
			abandon_slot_when_staggered = false,
			abandon_slot_when_staggered_time = 0.3,
			avoid_slots_behind_overwhelmed_target = true,
			slot_type = "medium",
		},
	},
}

return settings("SlotTemplates", slot_templates)
