-- chunkname: @scripts/settings/pickup/pickups/deployable/ammo_cache_deployable_pickup.lua

local pickup_data = {
	description = "loc_pickup_deployable_ammo_crate_01",
	name = "ammo_cache_deployable",
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	ammo_crate = true,
	group = "ammo",
	interaction_type = "ammunition",
	num_charges = 4,
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	spawn_flow_event = "lua_deploy",
	smart_tag_target_type = "pickup",
	auto_tag_on_spawn = true,
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		local modifier = pickup_data.modifier or 1
		local amount = math.ceil((max_ammunition_reserve + max_ammo_clip) * modifier)

		return amount
	end
}

return pickup_data
