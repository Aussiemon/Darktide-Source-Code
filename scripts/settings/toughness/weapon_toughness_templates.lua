local ToughnessSettings = require("scripts/settings/toughness/toughness_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local weapon_toughness_templates = {}
local replenish_types = ToughnessSettings.replenish_types
local gunlugger_talent_settings = TalentSettings.ogryn_1
weapon_toughness_templates.default = {
	regeneration_delay_modifier = {
		lerp_perfect = 0,
		lerp_basic = 1
	},
	regeneration_speed_modifier = {
		still = {
			lerp_perfect = 2,
			lerp_basic = 1
		},
		moving = {
			lerp_perfect = 2,
			lerp_basic = 1
		}
	},
	recovery_percentage_modifiers = {
		[replenish_types.melee_kill] = 1,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.gunslinger_crit_regen] = 1
	}
}
weapon_toughness_templates.auspex = {
	melee_damage_modifier = 0.25,
	toughness_damage_modifier = 0.5,
	optional_on_depleted_function_name_override = "block",
	regeneration_delay_modifier = {
		lerp_perfect = 0,
		lerp_basic = 1
	},
	regeneration_speed_modifier = {
		still = {
			lerp_perfect = 2,
			lerp_basic = 1
		},
		moving = {
			lerp_perfect = 2,
			lerp_basic = 1
		}
	},
	recovery_percentage_modifiers = {
		[replenish_types.melee_kill] = 1,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.gunslinger_crit_regen] = 1
	}
}
weapon_toughness_templates.luggable = {
	melee_damage_modifier = 0.25,
	toughness_damage_modifier = 1,
	optional_on_depleted_function_name_override = "block",
	regeneration_delay_modifier = {
		lerp_perfect = 2,
		lerp_basic = 2
	},
	regeneration_speed_modifier = {
		still = {
			lerp_perfect = 0.01,
			lerp_basic = 0.01
		},
		moving = {
			lerp_perfect = 0.01,
			lerp_basic = 0.01
		}
	},
	recovery_percentage_modifiers = {
		[replenish_types.melee_kill] = 1,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.gunslinger_crit_regen] = 1
	}
}
weapon_toughness_templates.assault = {
	regeneration_delay_modifier = {
		lerp_perfect = 0,
		lerp_basic = 1
	},
	regeneration_speed_modifier = {
		still = {
			lerp_perfect = 2,
			lerp_basic = 1
		},
		moving = {
			lerp_perfect = 2,
			lerp_basic = 1
		}
	},
	recovery_percentage_modifiers = {
		[replenish_types.melee_kill] = 1,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.gunslinger_crit_regen] = 1
	}
}
weapon_toughness_templates.killshot_zoomed = {
	optional_on_depleted_function_name_override = "spill_over",
	regeneration_delay_modifier = {
		lerp_perfect = 0,
		lerp_basic = 1
	},
	regeneration_speed_modifier = {
		still = {
			lerp_perfect = 2,
			lerp_basic = 1
		},
		moving = {
			lerp_perfect = 2,
			lerp_basic = 1
		}
	},
	recovery_percentage_modifiers = {
		[replenish_types.melee_kill] = 1,
		[replenish_types.ogryn_braced_regen] = gunlugger_talent_settings.defensive_3.braced_toughness_regen,
		[replenish_types.gunslinger_crit_regen] = 1
	}
}

for name, settings in pairs(weapon_toughness_templates) do
	settings.name = name
end

return settings("WeaponToughnessTemplates", weapon_toughness_templates)
