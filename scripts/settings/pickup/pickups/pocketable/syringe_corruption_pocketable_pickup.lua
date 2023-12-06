local pickup_data = {
	description = "loc_pickup_pocketable_01",
	name = "syringe_corruption_pocketable",
	look_at_tag = "pocketable",
	spawn_unit_component_event = "set_colors",
	group = "pocketable",
	game_object_type = "pickup",
	spawn_weighting = 0,
	inventory_slot_name = "slot_pocketable_small",
	unit_name = "content/pickups/pocketables/syringe/pup_syringe_case",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_syringe_corruption",
	unit_template_name = "pickup",
	interaction_type = "pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_syringe",
	smart_tag_target_type = "pickup",
	inventory_item = "content/items/pocketable/syringe_corruption_pocketable"
}

return pickup_data
