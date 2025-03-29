-- chunkname: @scripts/settings/pickup/pickups/pocketable/ammo_cache_pocketable_pickup.lua

local pickup_data = {
	description = "loc_pickup_pocketable_ammo_crate_01",
	group = "pocketable",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/ammo_cache_pocketable",
	inventory_slot_name = "slot_pocketable",
	look_at_tag = "pocketable",
	name = "ammo_cache_pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	smart_tag_target_type = "pickup",
	unit_name = "content/pickups/pocketables/ammo_crate/pickup_ammo_crate",
}

return pickup_data
