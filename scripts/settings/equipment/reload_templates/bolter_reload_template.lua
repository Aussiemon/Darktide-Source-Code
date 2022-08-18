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
			eject_mag = 3,
			cock_weapon = 1.5,
			fit_new_mag = 0.5
		},
		functionality = {
			refill_ammunition = 3,
			remove_ammunition = 0.75
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 3,
		state_transitions = {
			eject_mag = 2.5,
			cock_weapon = 1
		},
		functionality = {
			refill_ammunition = 2.5
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.25,
		state_transitions = {
			eject_mag = 0.5
		},
		functionality = {
			refill_ammunition = 0.5
		}
	}
}

return reload_template
