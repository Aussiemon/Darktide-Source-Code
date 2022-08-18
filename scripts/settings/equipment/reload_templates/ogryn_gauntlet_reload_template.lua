local reload_template = {
	name = "ogryn_gauntlet",
	states = {
		"eject_mag",
		"fit_new_mag"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 4.166667,
		state_transitions = {
			eject_mag = 4.16,
			fit_new_mag = 0.6
		},
		functionality = {
			refill_ammunition = 2.91,
			remove_ammunition = 0.6
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 2.666667,
		state_transitions = {
			eject_mag = 2.66
		},
		functionality = {
			refill_ammunition = 1.51
		}
	}
}

return reload_template
