local ArmorSettings = require("scripts/settings/damage/armor_settings")
local armor_types = ArmorSettings.types
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker, prop_armor = nil
local player = {
	sfx = {
		weakspot_died = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		died = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		weakspot_damage = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		damage = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		damage_reduced = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		damage_negated = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		toughness_absorbed = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		shield_blocked = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		blocked = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		dead = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		},
		shove = {
			{
				event = "wwise/events/player/play_player_get_hit_light_2d"
			}
		}
	},
	vfx = {},
	linked_decal = {},
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
