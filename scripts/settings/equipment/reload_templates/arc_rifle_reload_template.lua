-- chunkname: @scripts/settings/equipment/reload_templates/arc_rifle_reload_template.lua

local ONE_FRAME = 0.019230769230769232
local reload_template = {
	name = "arc_rifle",
	states = {
		"lift_weapon",
		"sever_connection",
		"remove_magazine",
		"replace_magazine",
	},
	lift_weapon = {
		anim_1p = "reload",
		hide_magazine_ammo_time = 2.67,
		show_magazine_ammo_time = 4.48,
		time = 6.33,
		abort_anims = {
			{
				anim_1p = "reload_cancel",
				t = 0,
			},
			{
				anim_1p = "reload_cancel_severed_connection",
				t = 1.2 - ONE_FRAME,
			},
			{
				anim_1p = "reload_cancel_mag_removed",
				t = 2.6 - ONE_FRAME,
			},
			{
				anim_1p = "reload_cancel",
				t = 4.23 - ONE_FRAME,
			},
			{
				anim_1p = "reload_finished",
				t = 5.1 - ONE_FRAME,
			},
		},
		state_transitions = {
			lift_weapon = 5.1,
			remove_magazine = 2.6,
			replace_magazine = 4.23,
			sever_connection = 1.2,
		},
		functionality = {
			refill_ammunition = 5.1,
			remove_ammunition = 1.2,
		},
	},
	sever_connection = {
		anim_1p = "reload_middle",
		show_magazine_ammo_time = 1.11,
		time = 4.38,
		abort_anims = {
			{
				anim_1p = "reload_cancel_severed_connection",
				t = 0,
			},
			{
				anim_1p = "reload_cancel_mag_removed",
				t = 0.7 - ONE_FRAME,
			},
			{
				anim_1p = "reload_cancel",
				t = 2.33 - ONE_FRAME,
			},
			{
				anim_1p = "reload_finished",
				t = 3.16 - ONE_FRAME,
			},
		},
		state_transitions = {
			lift_weapon = 3.16,
			remove_magazine = 0.7,
			replace_magazine = 2.33,
		},
		functionality = {
			refill_ammunition = 3.16,
		},
	},
	remove_magazine = {
		anim_1p = "reload_middle_mag_removed",
		show_magazine_ammo_time = 0,
		time = 3.01,
		abort_anims = {
			{
				anim_1p = "reload_cancel_mag_removed",
				t = 0,
			},
			{
				anim_1p = "reload_cancel",
				t = 0.96 - ONE_FRAME,
			},
			{
				anim_1p = "reload_finished",
				t = 1.76 - ONE_FRAME,
			},
		},
		state_transitions = {
			lift_weapon = 1.76,
			replace_magazine = 0.96,
		},
		functionality = {
			refill_ammunition = 1.76,
		},
	},
	replace_magazine = {
		anim_1p = "reload_end",
		show_magazine_ammo_time = 0,
		time = 1.783,
		abort_anims = {
			{
				anim_1p = "reload_cancel",
				t = 0,
			},
			{
				anim_1p = "reload_finished",
				t = 1.783 - ONE_FRAME,
			},
		},
		state_transitions = {
			lift_weapon = 0.56,
		},
		functionality = {
			refill_ammunition = 0.56,
		},
	},
}

return reload_template
