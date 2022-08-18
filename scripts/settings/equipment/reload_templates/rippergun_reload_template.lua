local reload_template = {
	name = "rippergun",
	states = {
		"eject_mag",
		"fit_new_mag"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3,
		state_transitions = {
			eject_mag = 2.1333333333333333,
			fit_new_mag = 0.7333333333333333
		},
		functionality = {
			refill_ammunition = 2.1333333333333333,
			remove_ammunition = 0.7333333333333333
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.8,
		state_transitions = {
			eject_mag = 1.3333333333333333
		},
		functionality = {
			refill_ammunition = 0.8666666666666667
		}
	}
}

return reload_template
