local reload_template = {
	name = "bolter",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 5,
		state_transitions = {
			eject_mag = 3.6,
			cock_weapon = 2.3,
			fit_new_mag = 1.15
		},
		functionality = {
			refill_ammunition = 3.6,
			remove_ammunition = 1.15
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 3.4,
		state_transitions = {
			eject_mag = 2.9,
			cock_weapon = 1.2
		},
		functionality = {
			refill_ammunition = 2.9
		}
	},
	cock_weapon = {
		anim_1p = "reload_end_long",
		time = 1.75,
		state_transitions = {
			eject_mag = 1.2
		},
		functionality = {
			refill_ammunition = 1.2
		}
	}
}

return reload_template
