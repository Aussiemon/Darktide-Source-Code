-- chunkname: @scripts/settings/impact_fx/impact_fx_chaos_plague_ogryn_charge.lua

local ArmorSettings = require("scripts/settings/damage/armor_settings")
local NO_SURFACE_DECAL = false
local armor_types = ArmorSettings.types
local unarmored, armored, super_armor, disgustingly_resilient, resistant, berserker
local player = {
	sfx = {
		damage = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_player_impact",
			},
		},
		damage_negated = {
			{
				append_husk_to_event_name = true,
				event = "wwise/events/minions/play_enemy_character_foley_plague_ogryn_player_impact",
			},
		},
	},
	vfx = {},
	blood_ball = {},
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
	},
}
