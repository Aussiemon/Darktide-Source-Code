local reload_template = {
	name = "autopistol",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.5,
		show_magazine_ammo_time = 0.5,
		state_transitions = {
			eject_mag = 1.6,
			cock_weapon = 0.93,
			fit_new_mag = 0.36
		},
		functionality = {
			refill_ammunition = 1.6,
			remove_ammunition = 0.27
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 1.6,
		show_magazine_ammo_time = 0.2,
		state_transitions = {
			eject_mag = 1.15,
			cock_weapon = 0.43
		},
		functionality = {
			refill_ammunition = 1.15
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 0.883,
		show_magazine_ammo_time = 0,
		state_transitions = {
			eject_mag = 0.4
		},
		functionality = {
			refill_ammunition = 0.4
		}
	}
}

return reload_template
