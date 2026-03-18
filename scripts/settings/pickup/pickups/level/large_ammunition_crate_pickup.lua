-- chunkname: @scripts/settings/pickup/pickups/level/large_ammunition_crate_pickup.lua

local pickup_data = {
	ammo_crate = true,
	description = "loc_pickup_deployable_ammo_crate_01",
	group = "ammo",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	interaction_type = "ammunition",
	name = "large_ammunition_crate",
	pickup_sound = "wwise/events/player/play_pick_up_full_ammo",
	refill_blitz = false,
	smart_tag_target_type = "pickup",
	spawn_flow_event = "lua_deploy",
	unit_name = "content/environment/gameplay/expeditions/large_ammo_crate/ammo_crate_large_01",
	num_charges = math.huge,
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		return max_ammunition_reserve + max_ammo_clip
	end,
}

return pickup_data
