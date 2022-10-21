local reload_template = {
	name = "heavy_stubber_twin_linked",
	states = {
		"eject_mag",
		"fit_new_mag",
		"gunlugger_ability"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 7,
		state_transitions = {
			eject_mag = 4.666666666666667,
			fit_new_mag = 2.2666666666666666
		},
		functionality = {
			refill_ammunition = 4.666666666666667,
			remove_ammunition = 2.2666666666666666
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 4.7,
		state_transitions = {
			eject_mag = 2.2333333333333334
		},
		functionality = {
			refill_ammunition = 2.2333333333333334
		}
	},
	gunlugger_ability = {
		anim_1p = "reload_middle",
		time = 2.8,
		state_transitions = {
			eject_mag = 2.7
		},
		functionality = {
			refill_ammunition = 2.3333333333333335
		}
	}
}

return reload_template
