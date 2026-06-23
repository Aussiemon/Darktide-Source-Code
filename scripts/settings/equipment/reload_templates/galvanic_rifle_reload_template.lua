-- chunkname: @scripts/settings/equipment/reload_templates/galvanic_rifle_reload_template.lua

local reload_template = {
	name = "galvanic_rifle",
	states = {
		"eject_mag",
		"fit_new_mag",
		"push_down_bullets",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		time = 3.83,
		state_transitions = {
			cock_weapon = 2.1,
			eject_mag = 2.9,
			fit_new_mag = 0.83,
			push_down_bullets = 1.766,
		},
		functionality = {
			refill_ammunition = 2.9,
			remove_ammunition = 0.83,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		time = 3,
		state_transitions = {
			cock_weapon = 1.33,
			eject_mag = 2,
			push_down_bullets = 0.93,
		},
		functionality = {
			refill_ammunition = 2,
		},
	},
	push_down_bullets = {
		anim_1p = "reload_middle_mag_on",
		anim_3p = "reload_middle",
		time = 3,
		state_transitions = {
			cock_weapon = 1.33,
			eject_mag = 2,
		},
		functionality = {
			refill_ammunition = 2,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		time = 1.5,
		state_transitions = {
			eject_mag = 0.53,
		},
		functionality = {
			refill_ammunition = 0.53,
		},
	},
}

return reload_template
