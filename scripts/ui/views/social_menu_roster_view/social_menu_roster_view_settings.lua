local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local social_menu_roster_view_settings = {
	popup_start_layer = 100,
	max_number_kill_team_members = 4,
	roster_grid_mask_expansion = 18,
	widget_fade_time = 0.5,
	panel_header_height = 50,
	command_confirmation_params = {
		leave_party = {
			description = "loc_social_menu_confirmation_popup_leave_party_description",
			title = "loc_social_menu_confirmation_popup_leave_party_header",
			on_confirm_sound = UISoundEvents.social_menu_leave_party
		},
		initiate_kick_vote = {
			description = "loc_social_menu_confirmation_popup_initiate_kick_vote_description",
			title = "loc_social_menu_confirmation_popup_initiate_kick_vote_header",
			on_confirm_sound = UISoundEvents.social_menu_initiate_kick_vote
		},
		unfriend_player = {
			description = "loc_social_menu_confirmation_popup_unfriend_player_description",
			title = "loc_social_menu_confirmation_popup_unfriend_player_header",
			on_confirm_sound = UISoundEvents.social_menu_unfriend_player
		},
		block_account = {
			description = "loc_social_menu_confirmation_popup_block_account_description",
			title = "loc_social_menu_confirmation_popup_block_account_header",
			on_confirm_sound = UISoundEvents.social_menu_block_player
		},
		unblock_account = {
			description = "loc_social_menu_confirmation_popup_unblock_account_description",
			title = "loc_social_menu_confirmation_popup_unblock_account_header",
			on_confirm_sound = UISoundEvents.social_menu_unblock_player
		}
	}
}

return settings("SocialMenuRosterViewSettings", social_menu_roster_view_settings)
