local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local attack_results = AttackSettings.attack_results
local hud_element_damage_indicator_settings = {
	life_time = 1,
	pulse_distance = -40,
	center_distance = 247,
	pulse_speed_multiplier = 2,
	size = {
		200,
		80
	},
	indicator_colors_lookup = {
		default = {
			background = UIHudSettings.color_tint_alert_2,
			front = {
				255,
				255,
				255,
				255
			}
		},
		[attack_results.blocked] = {
			background = {
				255,
				120,
				118,
				118
			},
			front = {
				255,
				255,
				255,
				255
			}
		},
		[attack_results.friendly_fire] = {
			background = {
				255,
				58,
				125,
				58
			},
			front = {
				255,
				255,
				255,
				255
			}
		},
		[attack_results.toughness_absorbed] = {
			background = UIHudSettings.color_tint_6,
			front = {
				255,
				255,
				255,
				255
			}
		},
		[attack_results.toughness_broken] = {
			background = UIHudSettings.color_tint_6,
			front = {
				255,
				255,
				255,
				255
			}
		}
	}
}

return settings("HudElementDamageIndicatorSettings", hud_element_damage_indicator_settings)
