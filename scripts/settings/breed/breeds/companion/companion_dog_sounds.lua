-- chunkname: @scripts/settings/breed/breeds/companion/companion_dog_sounds.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local sound_data = {
	events = {
		footstep_land = "wwise/events/minions/play_enemy_chaos_hound_footstep_land",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground_gore",
		sfx_breath = "wwise/events/minions/play_enemy_chaos_hound_vce_breath",
		foley = "wwise/events/minions/play_enemy_chaos_hound_footstep_foley",
		sfx_death = "wwise/events/minions/play_enemy_chaos_hound_death",
		sfx_growl_probability = "wwise/events/minions/play_enemy_chaos_hound_vce_growl_probability",
		sfx_leap = "wwise/events/minions/play_enemy_chaos_hound_vce_leap",
		sfx_bark = "wwise/events/minions/play_enemy_chaos_hound_vce_bark",
		sfx_growl = "wwise/events/minions/play_enemy_chaos_hound_vce_growl",
		footstep = "wwise/events/player/play_npc_dog_footstep",
		sfx_hurt = "wwise/events/minions/play_enemy_chaos_hound_hurt",
		sfx_bite = {
			[armor_types.unarmored] = "wwise/events/weapon/play_companion_bite_flesh",
			[armor_types.armored] = "wwise/events/weapon/play_companion_bite_armour",
			[armor_types.resistant] = "wwise/events/weapon/play_companion_bite_flesh",
			[armor_types.player] = "wwise/events/weapon/play_companion_bite_flesh",
			[armor_types.berserker] = "wwise/events/weapon/play_companion_bite_flesh",
			[armor_types.super_armor] = "wwise/events/weapon/play_companion_bite_armour",
			[armor_types.disgustingly_resilient] = "wwise/events/weapon/play_companion_bite_flesh",
			[armor_types.void_shield] = "wwise/events/weapon/play_companion_bite_armour"
		}
	},
	use_proximity_culling = {
		footstep_land = false,
		ground_impact = false,
		sfx_breath = false,
		foley = false,
		sfx_death = false,
		sfx_growl_probability = false,
		sfx_leap = false,
		sfx_bite = false,
		sfx_bark = false,
		sfx_growl = false,
		footstep = false,
		sfx_hurt = false
	}
}

return sound_data
