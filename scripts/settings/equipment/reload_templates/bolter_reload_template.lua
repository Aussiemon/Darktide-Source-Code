-- chunkname: @scripts/settings/equipment/reload_templates/bolter_reload_template.lua

local reload_template = {
	name = "bolter",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload_start",
		show_magazine_ammo_time = 1.7,
		time = 5,
		state_transitions = {
			cock_weapon = 2.3,
			eject_mag = 3.6,
			fit_new_mag = 1.15,
		},
		functionality = {
			refill_ammunition = 3.6,
			remove_ammunition = 1.15,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle",
		show_magazine_ammo_time = 0.7,
		time = 3.4,
		state_transitions = {
			cock_weapon = 1.2,
			eject_mag = 2.9,
		},
		functionality = {
			refill_ammunition = 2.9,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end_long",
		show_magazine_ammo_time = 0,
		time = 1.75,
		state_transitions = {
			eject_mag = 1.2,
		},
		functionality = {
			refill_ammunition = 1.2,
		},
	},
}

return reload_template
