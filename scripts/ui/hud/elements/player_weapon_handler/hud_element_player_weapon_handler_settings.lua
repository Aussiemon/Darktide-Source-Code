-- chunkname: @scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings.lua

local hud_element_player_weapon_handler_settings = {
	icon_shrink_scale = 0.25,
	wield_anim_speed = 8,
	scan_delay = 0,
	size = {
		200,
		80
	},
	size_small = {
		150,
		50
	},
	weapon_size = {
		456,
		80
	},
	weapon_size_small = {
		150,
		50
	},
	icon_size = {
		84,
		84
	},
	weapon_icon_size = {
		256,
		96
	},
	weapon_spacing = {
		0,
		10
	},
	ammo_offsets_icon = {
		default = {
			15,
			0
		},
		small = {
			5,
			0
		}
	},
	ammo_offsets_weapon = {
		default = {
			20,
			0
		},
		small = {
			10,
			0
		}
	},
	screen_offset = {
		-50,
		-40,
		1
	},
	slots_settings = {
		slot_primary = {
			default_icon = "content/ui/materials/icons/weapons/flat/knife",
			order_index = 2
		},
		slot_secondary = {
			default_wield_slot = true,
			default_icon = "content/ui/materials/icons/weapons/flat/rifle",
			order_index = 1
		},
		slot_grenade_ability = {
			default_icon = "content/ui/materials/icons/weapons/flat/grenade",
			order_index = 3
		},
		slot_pocketable = {
			default_icon = "content/ui/materials/icons/weapons/flat/grenade",
			order_index = 4
		}
	}
}

return settings("HudElementPlayerWeaponHandlerSettings", hud_element_player_weapon_handler_settings)
