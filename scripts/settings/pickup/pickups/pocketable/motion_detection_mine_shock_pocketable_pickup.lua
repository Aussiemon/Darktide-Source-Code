-- chunkname: @scripts/settings/pickup/pickups/pocketable/motion_detection_mine_shock_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_motion_detection_mine_shock",
	extra_description = "loc_expeditions_pickup_extra_description_motion_detection_mine_shock",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/landmine_shock",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/mines/motion_detection_mine_shock",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "motion_detection_mine_shock_pocketable",
	pickup_sound = "wwise/events/player/play_pickup_metal_object",
	smart_tag_target_type = "pickup",
	unit_name = "content/weapons/player/pickups/pup_landmine_shock/pickup_landmine_shock",
}

return pickup_data
