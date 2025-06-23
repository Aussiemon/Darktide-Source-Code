-- chunkname: @scripts/settings/equipment/reload_templates/heavy_stubber_reload_template.lua

local reload_template = {
	name = "heavy_stubber",
	states = {
		"eject_mag",
		"fit_new_mag",
		"gunlugger_ability"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 5.8,
		state_transitions = {
			eject_mag = 4.233333333333333,
			fit_new_mag = 2
		},
		functionality = {
			refill_ammunition = 4.233333333333333,
			remove_ammunition = 2
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 3.2,
		state_transitions = {
			eject_mag = 2
		},
		functionality = {
			refill_ammunition = 2
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
