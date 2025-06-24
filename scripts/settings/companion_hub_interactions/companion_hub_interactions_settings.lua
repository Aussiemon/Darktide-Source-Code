-- chunkname: @scripts/settings/companion_hub_interactions/companion_hub_interactions_settings.lua

local companion_hub_interactions_settings = {
	animation_selection_variable_name = "companion_interaction",
	default_anim_event = "companion_interaction",
	delay_before_can_interact_with_companion_when_idled = 0.05,
	distance_to_player = 2,
	invalid_position_anim_event = "companion_interaction_no_contact",
	interactions = {
		{
			animation_name = "interaction_01_sit",
			duration = 12,
		},
		{
			animation_name = "interaction_02_pet",
			duration = 6,
		},
		{
			animation_name = "interaction_03_pet",
			duration = 10,
		},
	},
}

return settings("companion_hub_interactions_settings", companion_hub_interactions_settings)
