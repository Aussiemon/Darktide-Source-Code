-- chunkname: @scripts/settings/equipment/reload_templates/rippergun_reload_template.lua

local reload_template = {
	name = "rippergun",
	states = {
		"eject_mag",
		"fit_new_mag",
		"gunlugger_ability",
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3,
		state_transitions = {
			eject_mag = 2.1333333333333333,
			fit_new_mag = 0.7333333333333333,
		},
		functionality = {
			refill_ammunition = 2.1333333333333333,
			remove_ammunition = 0.7333333333333333,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.8,
		state_transitions = {
			eject_mag = 0.8666666666666667,
		},
		functionality = {
			refill_ammunition = 0.8666666666666667,
		},
	},
	gunlugger_ability = {
		anim_1p = "reload_middle",
		time = 1.8,
		state_transitions = {
			eject_mag = 1.6666666666666667,
		},
		functionality = {
			refill_ammunition = 1.0666666666666667,
		},
	},
}

return reload_template
