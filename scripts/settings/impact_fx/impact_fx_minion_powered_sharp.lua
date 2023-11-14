local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local blood_ball = {
	"content/decals/blood_ball/blood_ball"
}
local unarmored = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		died = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		}
	},
	vfx = {},
	blood_ball = {
		died = blood_ball,
		damage = blood_ball
	}
}
local armored, super_armor = nil
local disgustingly_resilient = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		died = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage_negated = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		}
	},
	vfx = {},
	blood_ball = {
		died = blood_ball,
		damage = blood_ball
	}
}
local resistant, berserker = nil
local player = {
	sfx = {
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		},
		toughness_absorbed_melee = {
			{
				event = "wwise/events/player/play_toughness_hits",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain",
				hit_direction_interface = true
			},
			{
				event = "wwise/events/player/play_player_get_hit_sword_captain_husk",
				only_3p = true
			}
		}
	},
	vfx = {
		damage = {
			{
				effects = {
					"content/fx/particles/impacts/flesh/blood_splatter_01",
					only_3p = true
				}
			}
		},
		blocked = {
			{
				effects = {
					"content/fx/particles/impacts/damage_blocked",
					only_3p = true
				}
			}
		}
	},
	blood_ball = {
		died = blood_ball,
		damage = blood_ball
	}
}

return {
	armor = {
		[armor_types.armored] = armored,
		[armor_types.berserker] = berserker,
		[armor_types.disgustingly_resilient] = disgustingly_resilient,
		[armor_types.player] = player,
		[armor_types.resistant] = resistant,
		[armor_types.super_armor] = super_armor,
		[armor_types.unarmored] = unarmored
	}
}
