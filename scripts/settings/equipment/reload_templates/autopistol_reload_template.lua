-- chunkname: @scripts/settings/equipment/reload_templates/autopistol_reload_template.lua

local reload_template = {
	name = "autopistol",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		show_magazine_ammo_time = 0.5,
		time = 2.16,
		state_transitions = {
			cock_weapon = 0.93,
			eject_mag = 1.6,
			fit_new_mag = 0.36,
		},
		functionality = {
			refill_ammunition = 1.6,
			remove_ammunition = 0.27,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		show_magazine_ammo_time = 0.2,
		time = 1.6,
		state_transitions = {
			cock_weapon = 0.43,
			eject_mag = 1.15,
		},
		functionality = {
			refill_ammunition = 1.15,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		show_magazine_ammo_time = 0,
		time = 0.883,
		state_transitions = {
			eject_mag = 0.4,
		},
		functionality = {
			refill_ammunition = 0.4,
		},
	},
}

return reload_template
