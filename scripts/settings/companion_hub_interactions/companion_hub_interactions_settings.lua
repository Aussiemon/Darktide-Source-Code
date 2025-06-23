-- chunkname: @scripts/settings/companion_hub_interactions/companion_hub_interactions_settings.lua

local companion_hub_interactions_settings = {
	default_anim_event = "companion_interaction",
	invalid_position_anim_event = "companion_interaction_no_contact",
	distance_to_player = 2,
	delay_before_can_interact_with_companion_when_idled = 0.05,
	animation_selection_variable_name = "companion_interaction",
	interactions = {
		{
			duration = 12,
			animation_name = "interaction_01_sit"
		},
		{
			duration = 6,
			animation_name = "interaction_02_pet"
		},
		{
			duration = 10,
			animation_name = "interaction_03_pet"
		}
	}
}

return settings("companion_hub_interactions_settings", companion_hub_interactions_settings)
