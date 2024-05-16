-- chunkname: @scripts/settings/breed/breeds/renegade/renegade_common_sounds.lua

local sound_data = {
	events = {
		equip_melee = "wwise/events/weapon/play_weapon_equip_medium_sword_husk",
		footstep = "wwise/events/minions/play_footstep_boots_medium_enemy",
		footstep_land = "wwise/events/minions/play_footstep_boots_land_medium_enemy",
		ground_impact = "wwise/events/minions/play_enemy_foley_body_impact_medium_ground",
		swing_foley = "wwise/events/minions/play_shared_foley_traitor_guard_medium_drastic_short",
	},
	use_proximity_culling = {},
}

return sound_data
