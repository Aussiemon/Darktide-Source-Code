-- chunkname: @scripts/settings/equipment/reload_templates/dual_autopistols_reload_template.lua

local reload_template = {
	name = "dual_autopistols",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3,
		state_transitions = {
			cock_weapon = 1.2,
			eject_mag = 2.1,
			fit_new_mag = 0.4,
		},
		functionality = {
			refill_ammunition = 2.1,
			remove_ammunition = 0.34,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 2.35,
		state_transitions = {
			cock_weapon = 0.8,
			eject_mag = 1.45,
		},
		functionality = {
			refill_ammunition = 1.45,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.45,
		state_transitions = {
			eject_mag = 0.7,
		},
		functionality = {
			refill_ammunition = 0.7,
		},
	},
}

return reload_template
