-- chunkname: @scripts/settings/equipment/reload_templates/needlepistol_reload_template.lua

local reload_template = {
	name = "needlepistol",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.3,
		state_transitions = {
			cock_weapon = 1.066,
			eject_mag = 1.73,
			fit_new_mag = 0.37,
		},
		functionality = {
			refill_ammunition = 1.7,
			remove_ammunition = 0.37,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.783,
		state_transitions = {
			cock_weapon = 0.57,
			eject_mag = 1.22,
		},
		functionality = {
			refill_ammunition = 1.22,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.084,
		state_transitions = {
			eject_mag = 0.47,
		},
		functionality = {
			refill_ammunition = 0.47,
		},
	},
}

return reload_template
