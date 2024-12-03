-- chunkname: @scripts/settings/pickup/pickups/deployable/ammo_cache_deployable_pickup.lua

local pickup_data = {
	ammo_crate = true,
	auto_tag_on_spawn = true,
	description = "loc_pickup_deployable_ammo_crate_01",
	game_object_type = "pickup",
	group = "ammo",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	interaction_type = "ammunition",
	look_at_tag = "ammo",
	name = "ammo_cache_deployable",
	num_charges = 4,
	pickup_sound = "wwise/events/player/play_pick_up_ammo_01",
	smart_tag_target_type = "pickup",
	spawn_flow_event = "lua_deploy",
	spawn_weighting = 0,
	unit_name = "content/pickups/pocketables/ammo_crate/deployable_ammo_crate",
	unit_template_name = "pickup",
	ammo_amount_func = function (max_ammunition_reserve, max_ammo_clip, pickup_data)
		local modifier = pickup_data.modifier or 1
		local amount = math.ceil((max_ammunition_reserve + max_ammo_clip) * modifier)

		return amount
	end,
}

return pickup_data
