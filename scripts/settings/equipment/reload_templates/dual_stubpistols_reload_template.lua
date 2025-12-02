-- chunkname: @scripts/settings/equipment/reload_templates/dual_stubpistols_reload_template.lua

local reload_template = {
	name = "dual_stubpistols",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.31,
		state_transitions = {
			cock_weapon = 1.45,
			eject_mag = 1.95,
			fit_new_mag = 0.333,
		},
		functionality = {
			refill_ammunition = 1.95,
			remove_ammunition = 0.333,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.583,
		state_transitions = {
			cock_weapon = 0.8,
			eject_mag = 1.233,
		},
		functionality = {
			refill_ammunition = 1.233,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 0.58,
		state_transitions = {
			eject_mag = 0.3,
		},
		functionality = {
			refill_ammunition = 0.3,
		},
	},
}

return reload_template
