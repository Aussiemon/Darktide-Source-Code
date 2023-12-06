local pickup_data = {
	description = "loc_pickup_syringe_pocketable_03",
	name = "syringe_power_boost_pocketable",
	look_at_tag = "pocketable",
	spawn_unit_component_event = "set_colors",
	group = "pocketable",
	game_object_type = "pickup",
	spawn_weighting = 0,
	inventory_slot_name = "slot_pocketable_small",
	unit_name = "content/pickups/pocketables/syringe/pup_syringe_case",
	interaction_icon = "content/ui/materials/hud/interactions/icons/pocketable_syringe_power",
	unit_template_name = "pickup",
	interaction_type = "pocketable",
	pickup_sound = "wwise/events/player/play_pick_up_syringe",
	smart_tag_target_type = "pickup",
	inventory_item = "content/items/pocketable/syringe_power_boost_pocketable"
}

return pickup_data
