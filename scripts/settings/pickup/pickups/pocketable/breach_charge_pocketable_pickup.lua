-- chunkname: @scripts/settings/pickup/pickups/pocketable/breach_charge_pocketable_pickup.lua

local pickup_data = {
	description = "loc_pickup_breaching_charge",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/breach_charge_pocketable",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "breach_charge_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/syringe/pup_syringe_case",
}

return pickup_data
