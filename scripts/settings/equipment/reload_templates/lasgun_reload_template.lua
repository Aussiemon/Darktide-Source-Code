-- chunkname: @scripts/settings/equipment/reload_templates/lasgun_reload_template.lua

local reload_template = {
	name = "lasgun",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon"
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3.17,
		state_transitions = {
			eject_mag = 2.5,
			cock_weapon = 1.7,
			fit_new_mag = 0.51
		},
		functionality = {
			refill_ammunition = 2.5,
			remove_ammunition = 0.51
		}
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 2.5,
		state_transitions = {
			eject_mag = 1.8,
			cock_weapon = 1.1
		},
		functionality = {
			refill_ammunition = 1.8
		}
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1,
		state_transitions = {
			eject_mag = 0.5
		},
		functionality = {
			refill_ammunition = 0.5
		}
	}
}

return reload_template
