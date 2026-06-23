-- chunkname: @scripts/ui/hud/elements/minion_shield_health/hud_element_minion_shield_health_settings.lua

local hud_element_minion_shield_health_settings = {
	percentage_for_icons = {
		{
			health_value = 25,
			values = {
				icon_01 = true,
				icon_03 = true,
				icon_03_sub_icon_01 = true,
			},
		},
		{
			health_value = 50,
			values = {
				icon_01 = true,
				icon_03 = true,
				icon_03_sub_icon_01 = true,
				icon_03_sub_icon_02 = true,
			},
		},
		{
			health_value = 75,
			values = {
				icon_01 = true,
				icon_01_sub_icon_01 = true,
				icon_03 = true,
				icon_03_sub_icon_01 = true,
				icon_03_sub_icon_02 = true,
			},
		},
		{
			health_value = 100,
			values = {
				icon_01 = true,
				icon_01_sub_icon_01 = true,
				icon_01_sub_icon_02 = true,
				icon_03 = true,
				icon_03_sub_icon_01 = true,
				icon_03_sub_icon_02 = true,
			},
		},
	},
}

return settings("HudElementMinionShieldHealthSettings", hud_element_minion_shield_health_settings)
