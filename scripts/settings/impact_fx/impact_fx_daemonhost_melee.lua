local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local unarmored = {
	sfx = {
		damage = {
			{
				event = "wwise/events/minions/play_enemy_daemonhost_combo_sweep_player_impact_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/minions/play_enemy_daemonhost_combo_sweep_player_impact_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		damage = {
			effects = {
				"content/fx/particles/debug/fx_debug_1m_burst"
			}
		},
		damage_reduced = {
			effects = {
				"content/fx/particles/debug/fx_debug_1m_burst"
			}
		}
	},
	blood_ball = {}
}
local armored = table.clone(unarmored)
local super_armor = table.clone(unarmored)
local disgustingly_resilient = table.clone(unarmored)
local resistant = table.clone(unarmored)
local berserker = table.clone(unarmored)
local prop_armor = table.clone(unarmored)
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/minions/play_enemy_daemonhost_combo_sweep_player_impact",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/minions/play_enemy_daemonhost_combo_sweep_player_impact_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			}
		},
		damage_reduced = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_small_01"
				}
			}
		}
	},
	blood_ball = {}
}

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored,
		[armor_types.prop_armor] = prop_armor
	}
}
