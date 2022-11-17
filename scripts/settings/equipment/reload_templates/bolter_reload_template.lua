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
			cock_weapon = 2.2,
			fit_new_mag = 1.15
		},
		functionality = {
			refill_ammunition = 3.6,
			remove_ammunition = 1.15
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 3,
		state_transitions = {
			eject_mag = 2.5,
			cock_weapon = 0.8
		},
		functionality = {
			refill_ammunition = 2.5
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.25,
		state_transitions = {
			eject_mag = 0.65
		},
		functionality = {
			refill_ammunition = 0.65
		}
	}
}

return reload_template
