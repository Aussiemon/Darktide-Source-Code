local reload_template = {
	name = "ogryn_gauntlet",
	states = {
		"eject_mag",
		"fit_new_mag",
		"gunlugger_ability"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 4.166667,
		state_transitions = {
			eject_mag = 2.91,
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
			eject_mag = 1.51
		},
		functionality = {
			refill_ammunition = 1.51
		}
	},
	gunlugger_ability = {
		anim_1p = "reload_middle",
		time = 2.6666666666666665,
		state_transitions = {
			eject_mag = 1.6666666666666667
		},
		functionality = {
			refill_ammunition = 1.5
		}
	}
}

return reload_template
