-- chunkname: @scripts/settings/equipment/reload_templates/stubrevolver_reload_template.lua

local reload_template = {
	name = "stubrevolver",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload",
		show_magazine_ammo_time = 1,
		time = 3.5,
		state_transitions = {
			cock_weapon = 1.9,
			eject_mag = 2.6,
			fit_new_mag = 0.8,
		},
		functionality = {
			refill_ammunition = 2.6,
			remove_ammunition = 0.8,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle_speedloader",
		show_magazine_ammo_time = 0.2,
		time = 2.5,
		state_transitions = {
			cock_weapon = 0.9,
			eject_mag = 1.75,
		},
		functionality = {
			refill_ammunition = 1.75,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		show_magazine_ammo_time = 0,
		time = 1,
		state_transitions = {
			eject_mag = 0.75,
		},
		functionality = {
			refill_ammunition = 0.75,
		},
	},
}

return reload_template
