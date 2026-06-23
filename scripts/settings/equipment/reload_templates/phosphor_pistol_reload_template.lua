-- chunkname: @scripts/settings/equipment/reload_templates/phosphor_pistol_reload_template.lua

local reload_template = {
	name = "phosphor_pistol",
	states = {
		"eject_mag",
		"fit_new_mag",
		"cock_weapon",
	},
	eject_mag = {
		anim_1p = "reload",
		show_magazine_ammo_time = 1,
		time = 2.9,
		abort_anims = {
			{
				anim_1p = "reload_cancel",
				t = 0,
			},
			{
				anim_1p = "reload_cancel_empty",
				t = 0.3,
			},
			{
				anim_1p = "reload_cancel_full",
				t = 1.46,
			},
			{
				anim_1p = "reload_finished",
				t = 2.2,
			},
		},
		state_transitions = {
			cock_weapon = 1.46,
			eject_mag = 2.2,
			fit_new_mag = 0.3,
		},
		functionality = {
			refill_ammunition = 2.2,
			remove_ammunition = 0.3,
		},
	},
	fit_new_mag = {
		anim_1p = "reload_middle_speedloader",
		show_magazine_ammo_time = 0.2,
		time = 2.36,
		abort_anims = {
			{
				anim_1p = "reload_cancel_empty",
				t = 0,
			},
			{
				anim_1p = "reload_cancel_full",
				t = 0.83,
			},
			{
				anim_1p = "reload_finished",
				t = 1.66,
			},
		},
		state_transitions = {
			cock_weapon = 0.83,
			eject_mag = 1.66,
		},
		functionality = {
			refill_ammunition = 1.66,
		},
	},
	cock_weapon = {
		anim_1p = "reload_end",
		show_magazine_ammo_time = 0,
		time = 1.13,
		abort_anims = {
			{
				anim_1p = "reload_cancel_full",
				t = 0,
			},
			{
				anim_1p = "reload_finished",
				t = 0.36,
			},
		},
		state_transitions = {
			eject_mag = 0.36,
		},
		functionality = {
			refill_ammunition = 0.36,
		},
	},
}

return reload_template
