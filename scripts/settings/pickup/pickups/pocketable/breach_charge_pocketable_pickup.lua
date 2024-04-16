local pickup_data = {
	description = "loc_pickup_breaching_charge",
	name = "breach_charge_pocketable",
	look_at_tag = "pocketable",
	smart_tag_target_type = "pickup",
	group = "pocketable",
	game_object_type = "pickup",
	spawn_weighting = 0,
	inventory_slot_name = "slot_pocketable",
	unit_name = "content/pickups/pocketables/syringe/pup_syringe_case",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
	unit_template_name = "pickup",
	pickup_sound = "wwise/events/player/play_pick_up_ammopack",
	interaction_type = "pocketable",
	inventory_item = "content/items/pocketable/breach_charge_pocketable"
}

return pickup_data
