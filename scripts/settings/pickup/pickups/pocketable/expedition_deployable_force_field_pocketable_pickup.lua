-- chunkname: @scripts/settings/pickup/pickups/pocketable/expedition_deployable_force_field_pocketable_pickup.lua

local pickup_data = {
	description = "loc_expeditions_pickup_description_force_field_pocketable",
	extra_description = "loc_expeditions_pickup_extra_description_force_field_pocketable",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/void_shield",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/expedition_force_field_pocketable",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "expedition_deployable_force_field_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_box",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/void_shield/pickup_void_shield",
}

return pickup_data
