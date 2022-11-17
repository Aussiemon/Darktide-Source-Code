local reload_template = {
	name = "ogryn_thumper",
	states = {
		"eject_mag",
		"fit_new_mag",
		"gunlugger_ability"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 2.333,
		state_transitions = {
			eject_mag = 1.45,
			fit_new_mag = 0.5
		},
		functionality = {
			refill_ammunition = 1.45,
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
	},
	gunlugger_ability = {
		anim_1p = "reload_middle",
		time = 1.8333333333333333,
		state_transitions = {
			eject_mag = 1.6666666666666667
		},
		functionality = {
			refill_ammunition = 1
		}
	}
}

return reload_template
