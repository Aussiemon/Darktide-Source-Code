-- chunkname: @scripts/settings/pickup/pickups/pocketable/breach_charge_pocketable_pickup.lua

local pickup_data = {
	description = "loc_pickup_breaching_charge",
	name = "breach_charge_pocketable",
	look_at_tag = "pocketable",
	smart_tag_target_type = "pickup",
	group = "pocketable",
	interaction_type = "pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	inventory_slot_name = "slot_pocketable",
	unit_name = "content/pickups/pocketables/syringe/pup_syringe_case",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
	inventory_item = "content/items/pocketable/breach_charge_pocketable"
}

return pickup_data
