-- chunkname: @scripts/settings/live_event/stolen_rations.lua

local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local stolen_rations = {
	condition = "loc_stolen_rations_01_condition",
	description = "loc_stolen_rations_01_description",
	id = "stolen_rations",
	name = "loc_stolen_rations_01_name",
	stat = "stolen_rations_handled",
	interaction_type_loc_strings = {
		"loc_stolen_rations_recovered_notification",
		"loc_stolen_rations_destroyed_notification",
	},
	item_rewards = {
		"content/items/weapons/player/trinkets/trinket_21a",
		"content/items/2d/portrait_frames/event_stolenrations_destroy",
		"content/items/2d/portrait_frames/event_stolenrations_recover",
	},
	notifications = {
		notification_recover = {
			subtitle = "loc_stolen_rations_event_stat_trigger_subtitle",
			title = "loc_stolen_rations_event_stat_trigger_recover_title_01",
			sound_event = UISoundEvents.notification_warning,
		},
		notification_destroy = {
			subtitle = "loc_stolen_rations_event_stat_trigger_subtitle",
			title = "loc_stolen_rations_event_stat_trigger_destroy_title_01",
			sound_event = UISoundEvents.notification_warning,
		},
	},
	event_material_wallet_settings = {
		backend_index = 1,
		display_name = "loc_stolen_rations_pickup",
		font_gradient_material = "content/ui/materials/font_gradients/slug_font_gradient_diamantine",
		font_gradient_material_insufficient_funds = "content/ui/materials/font_gradients/slug_font_gradient_insufficient_funds",
		sort_order = 4,
		string_symbol = "",
		pickup_localization_by_size = {
			large = "loc_stolen_rations_pickup_large",
			medium = "loc_stolen_rations_pickup_medium",
			small = "loc_stolen_rations_pickup_small",
		},
		pickup_icon_by_size = {
			medium = "content/ui/materials/icons/currencies/stolen_rations/rations_live_event_medium",
			small = "content/ui/materials/icons/currencies/stolen_rations/rations_live_event_small",
		},
	},
	objective = {
		widgets = {
			{
				template = "dynamic_description",
				context = {
					{
						text = "loc_stolen_rations_recovered_won",
						condition = {
							"rations_recovered_res",
							">",
							"rations_destroyed_res",
						},
					},
					{
						text = "loc_stolen_rations_destroyed_won",
						condition = {
							"rations_recovered_res",
							"<",
							"rations_destroyed_res",
						},
					},
					{
						text = "loc_stolen_rations_first_round",
					},
				},
			},
			{
				template = "title",
				context = {
					text = "loc_stolen_rations_01_name",
				},
			},
			{
				template = "tug_o_war",
				context = {
					left_name = "loc_stolen_rations_recovered_team_name",
					left_stat = "rations_recovered",
					right_name = "loc_stolen_rations_destroyed_team_name",
					right_stat = "rations_destroyed",
				},
			},
		},
	},
}

return stolen_rations
