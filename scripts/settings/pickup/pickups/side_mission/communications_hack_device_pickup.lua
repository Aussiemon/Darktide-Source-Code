-- chunkname: @scripts/settings/pickup/pickups/side_mission/communications_hack_device_pickup.lua

local pickup_data = {
	description = "loc_pickup_side_mission_communications_hack_device",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_corrupted_auspex_scanner",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/communications_hack_device_pocketable",
	inventory_slot_name = "slot_pocketable_small",
	look_at_tag = "pocketable",
	name = "communications_hack_device",
	pickup_sound = "wwise/events/player/play_pick_up_auspex_scanner",
	smart_tag_target_type = "pickup",
	spawn_flow_event = "lua_pickup_spawned",
	unit_name = "content/pickups/pocketables/communications_hack_device/pup_communications_hack_device",
	spawn_offset = Vector3Box(0, 0, 0.04),
	spawn_rotation = Vector3Box(0, -90, 0),
	on_pickup_func = function (pickup_unit, interactor_unit, pickup_data)
		return
	end,
}

return pickup_data
