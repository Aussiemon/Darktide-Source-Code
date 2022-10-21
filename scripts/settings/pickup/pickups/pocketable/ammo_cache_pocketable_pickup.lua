local pickup_data = {
	description = "loc_pickup_pocketable_ammo_crate_01",
	name = "ammo_cache_pocketable",
	look_at_tag = "pocketable",
	smart_tag_target_type = "pickup",
	group = "pocketable",
	game_object_type = "pickup",
	spawn_weighting = 1,
	unit_name = "content/pickups/pocketables/ammo_crate/pickup_ammo_crate",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	unit_template_name = "pickup",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/ammo_cache_pocketable"
}

return pickup_data
