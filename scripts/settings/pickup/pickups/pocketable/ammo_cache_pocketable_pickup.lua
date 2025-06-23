-- chunkname: @scripts/settings/pickup/pickups/pocketable/ammo_cache_pocketable_pickup.lua

local pickup_data = {
	description = "loc_pickup_pocketable_ammo_crate_01",
	name = "ammo_cache_pocketable",
	look_at_tag = "pocketable",
	smart_tag_target_type = "pickup",
	group = "pocketable",
	interaction_type = "pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	inventory_slot_name = "slot_pocketable",
	unit_name = "content/pickups/pocketables/ammo_crate/pickup_ammo_crate",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	inventory_item = "content/items/pocketable/ammo_cache_pocketable"
}

return pickup_data
