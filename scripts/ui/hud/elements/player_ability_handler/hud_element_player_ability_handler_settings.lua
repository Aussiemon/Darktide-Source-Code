local ability_size = {
	92,
	80
}
local hud_element_player_ability_handler_settings = {
	scan_delay = 0.25,
	ability_size = ability_size,
	item_slots = {},
	setup_settings_by_slot = {
		slot_combat_ability = {
			definition_path = "scripts/ui/hud/elements/player_ability/hud_element_player_ability_vertical_definitions",
			scenegraph_definition = {
				vertical_alignment = "bottom",
				parent = "screen",
				horizontal_alignment = "right",
				size = ability_size,
				position = {
					-450,
					-40,
					1
				}
			}
		}
	}
}

return settings("HudElementPlayerAbilityHandlerSettings", hud_element_player_ability_handler_settings)
