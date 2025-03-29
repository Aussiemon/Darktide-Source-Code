-- chunkname: @scripts/settings/pickup/pickups/pocketable/medical_crate_pocketable_pickup.lua

local pickup_data = {
	description = "loc_pickup_pocketable_medical_crate_01",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/med_crate_pocketable",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "medical_crate_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_box",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/medical_crate/pickup_medical_crate",
}

return pickup_data
