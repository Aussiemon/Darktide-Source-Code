local hud_element_player_weapon_handler_settings = {
	wield_anim_speed = 8,
	scan_delay = 1,
	size = {
		300,
		80
	},
	size_small = {
		250,
		60
	},
	icon_size = {
		150,
		60
	},
	weapon_icon_size = {
		240,
		60
	},
	weapon_spacing = {
		0,
		10
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
