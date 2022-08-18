local reload_template = {
	name = "ogryn_thumper",
	states = {
		"eject_mag",
		"fit_new_mag"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.333,
		state_transitions = {
			eject_mag = 2,
			fit_new_mag = 0.55
		},
		functionality = {
			refill_ammunition = 1.4,
			remove_ammunition = 0.5
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.833,
		state_transitions = {
			eject_mag = 1.4
		},
		functionality = {
			refill_ammunition = 1.35
		}
	}
}

return reload_template
