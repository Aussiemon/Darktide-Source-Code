-- chunkname: @scripts/settings/pickup/pickups/pocketable/motion_detection_mine_fire_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_motion_detection_mine_fire",
	extra_description = "loc_expeditions_pickup_extra_description_motion_detection_mine_fire",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/landmine_fire",
	interaction_type = "pocketable",
	inventory_item = "content/items/weapons/player/mines/motion_detection_mine_fire",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "motion_detection_mine_fire_pocketable",
	pickup_sound = "wwise/events/player/play_pickup_metal_object",
	retain_charges = true,
	smart_tag_target_type = "pickup",
	unit_name = "content/weapons/player/pickups/pup_landmine_fire/pickup_landmine_fire",
}

return pickup_data
