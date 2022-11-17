local reload_template = {
	name = "lasgun_elysian",
	states = {
		"eject_mag",
		"fit_new_mag"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.8,
		state_transitions = {
			eject_mag = 1.95,
			fit_new_mag = 0.45
		},
		functionality = {
			refill_ammunition = 1.95,
			remove_ammunition = 0.45
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.3,
		state_transitions = {
			eject_mag = 0.63
		},
		functionality = {
			refill_ammunition = 0.63
		}
	}
}

return reload_template
