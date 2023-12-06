local reload_template = {
	name = "stubrevolver",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload",
		time = 3.5,
		show_magazine_ammo_time = 1,
		state_transitions = {
			eject_mag = 2.6,
			cock_weapon = 1.9,
			fit_new_mag = 0.8
		},
		functionality = {
			refill_ammunition = 2.6,
			remove_ammunition = 0.8
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle_speedloader",
		time = 2.5,
		show_magazine_ammo_time = 0.2,
		state_transitions = {
			eject_mag = 1.75,
			cock_weapon = 0.9
		},
		functionality = {
			refill_ammunition = 1.75
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1,
		show_magazine_ammo_time = 0,
		state_transitions = {
			eject_mag = 0.75
		},
		functionality = {
			refill_ammunition = 0.75
		}
	}
}

return reload_template
