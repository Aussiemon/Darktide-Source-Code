-- chunkname: @scripts/ui/views/system_view/system_view_content_list.lua

local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local NarrativeStories = require("scripts/settings/narrative/narrative_stories")
local Promise = require("scripts/foundation/utilities/promise")
local SINGLEPLAY_TYPES = MatchmakingConstants.SINGLEPLAY_TYPES
local HOST_TYPES = MatchmakingConstants.HOST_TYPES

local function validation_is_in_mission()
	local host_type = Managers.multiplayer_session:host_type()

	if host_type == HOST_TYPES.mission_server then
		return true
	end

	return false
end

local function _members_in_party()
	local num_members = 0

	if GameParameters.prod_like_backend then
		num_members = Managers.party_immaterium:num_other_members()
	end

	return num_members
end

local main_menu_list = {
	{
		icon = "content/ui/materials/icons/system/escape/achievements",
		text = "loc_achievements_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "penance_overview_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
		has_highlight = function ()
			return Managers.achievements:is_reward_to_claim()
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/social",
		required_dev_parameter = "ui_show_social_menu",
		text = "loc_social_view_display_name",
		type = "large_button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("social_menu_view")
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/premium_store",
		text = "loc_store_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "store_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
		has_highlight = function ()
			return Managers.data_service.store:has_new_feature_store()
		end,
	},
	{
		type = "spacing_vertical",
	},
	{
		type = "spacing_vertical",
	},
	{
		type = "spacing_vertical",
	},
	{
		icon = "content/ui/materials/icons/system/escape/news",
		required_dev_parameter = "ui_debug_news_screen",
		text = "loc_news_view_title",
		type = "button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "news_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/credits",
		text = "loc_credits_view_title",
		type = "button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "credits_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/settings",
		text = "loc_options_view_display_name",
		type = "button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("options_view")
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/leave_party",
		text = "loc_leave_party_display_name",
		type = "button",
		validation_function = function ()
			return _members_in_party() > 0
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_leave_party",
				title_text = "loc_popup_header_leave_party",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_leave_party",
						callback = callback(function ()
							if GameParameters.prod_like_backend then
								Managers.party_immaterium:leave_party()
							end
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_cancel_leave_party",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
}

if PLATFORM == "win32" then
	main_menu_list[#main_menu_list + 1] = {
		type = "spacing_vertical",
	}
	main_menu_list[#main_menu_list + 1] = {
		icon = "content/ui/materials/icons/system/escape/quit",
		text = "loc_quit_game_display_name",
		type = "button",
		trigger_function = function (parent, widget, entry)
			local context = {
				description_text = "loc_popup_description_quit_game",
				title_text = "loc_popup_header_quit_game",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_quit_game",
						callback = callback(function ()
							Application.quit()
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_continue_game",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	}
end

local default_list = {
	{
		icon = "content/ui/materials/icons/system/escape/inventory",
		text = "loc_character_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local view_name = "inventory_background_view"

			Managers.ui:open_view(view_name)
		end,
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_in_hub = game_mode_name == "hub"
			local is_in_shooting_range = game_mode_name == "shooting_range"
			local is_prologue_hub = game_mode_name == "prologue_hub"
			local played_basic_training = Managers.narrative:is_chapter_complete("onboarding", "play_training")

			return is_in_hub or is_prologue_hub and played_basic_training or is_in_shooting_range
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/achievements",
		text = "loc_achievements_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "penance_overview_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_in_hub = game_mode_name == "hub" or game_mode_name == "shooting_range"

			return is_in_hub
		end,
		has_highlight = function ()
			return Managers.achievements:is_reward_to_claim()
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/social",
		text = "loc_social_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "social_menu_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/party_finder",
		text = "loc_group_finder_menu_title",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "group_finder_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_hub = game_mode_name == "hub"
			local is_training_grounds = game_mode_name == "training_grounds" or game_mode_name == "shooting_range"
			local can_show = is_hub or is_training_grounds
			local is_leaving_game = game_mode_manager:game_mode_state() == "leaving_game"
			local is_in_matchmaking = Managers.data_service.social:is_in_matchmaking()
			local is_disabled = is_leaving_game or is_in_matchmaking

			return can_show, is_disabled
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/premium_store",
		text = "loc_store_view_display_name",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "store_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_in_hub = game_mode_name == "hub" or game_mode_name == "shooting_range"

			return is_in_hub
		end,
		has_highlight = function ()
			return Managers.data_service.store:has_new_feature_store()
		end,
	},
	{
		type = "spacing_vertical",
	},
	{
		type = "spacing_vertical",
	},
	{
		type = "spacing_vertical",
	},
	{
		icon = "content/ui/materials/icons/system/escape/settings",
		text = "loc_options_view_display_name",
		type = "button",
		trigger_function = function ()
			local context = {
				can_exit = true,
			}
			local view_name = "options_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/change_character",
		text = "loc_exit_to_main_menu_display_name",
		type = "button",
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_onboarding = game_mode_name == "prologue" or game_mode_name == "prologue_hub"
			local is_hub = game_mode_name == "hub"
			local is_training_grounds = game_mode_name == "training_grounds" or game_mode_name == "shooting_range"
			local can_show = is_onboarding or is_hub or is_training_grounds
			local is_leaving_game = game_mode_manager:game_mode_state() == "leaving_game"
			local is_in_matchmaking = Managers.data_service.social:is_in_matchmaking()
			local is_disabled = is_leaving_game or is_in_matchmaking

			return can_show, is_disabled
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_leave_game",
				title_text = "loc_popup_header_leave_game",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_leave_game",
						callback = callback(function ()
							Managers.multiplayer_session:leave("exit_to_main_menu")
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_leave_continue_game",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/leave_mission",
		text = "loc_leave_mission_display_name",
		type = "button",
		validation_function = validation_is_in_mission,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_leave_mission",
				title_text = "loc_popup_header_leave_mission",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_leave_mission",
						callback = callback(function ()
							Managers.multiplayer_session:leave("leave_mission")
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_leave_continue_mission",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/leave_mission",
		text = "loc_menu_skip_prologue",
		type = "button",
		validation_function = function ()
			local data_service_manager = Managers.data_service

			if not data_service_manager then
				return false
			end

			if not data_service_manager.account:has_completed_onboarding() then
				return false
			end

			local narrative_manager = Managers.narrative

			if not narrative_manager then
				return false
			end

			local onboarding_chapters = NarrativeStories.stories.onboarding
			local last_chapter_name = onboarding_chapters[#onboarding_chapters].name

			if not narrative_manager:is_chapter_complete(Managers.narrative.STORIES.onboarding, last_chapter_name) then
				return true
			end

			return false
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_skip_prologue",
				title_text = "loc_menu_skip_prologue",
				options = {
					{
						close_on_pressed = true,
						text = "loc_confirm",
						callback = callback(function ()
							Managers.narrative:skip_story(Managers.narrative.STORIES.onboarding)
							Managers.state.game_mode:complete_game_mode()
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_leave_continue_mission",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/leave_training",
		text = "loc_tg_exit_training_grounds",
		type = "button",
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local narrative_manager = Managers.narrative

			if not narrative_manager then
				return false
			end

			if not narrative_manager:is_chapter_complete("onboarding", "play_training") then
				return false
			end

			local is_disabled = game_mode_manager:game_mode_state() == "leaving_game"
			local game_mode_name = game_mode_manager:game_mode_name()
			local can_show = game_mode_name == "training_grounds" or game_mode_name == "shooting_range"

			return can_show, is_disabled
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_leave_psykhanium",
				title_text = "loc_tg_exit_training_grounds",
				options = {
					{
						close_on_pressed = true,
						text = "loc_training_grounds_choice_quit",
						callback = callback(function ()
							Managers.state.game_mode:complete_game_mode()
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_leave_continue_mission",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/leave_party",
		text = "loc_leave_party_display_name",
		type = "button",
		validation_function = function ()
			if validation_is_in_mission() then
				return false
			end

			return _members_in_party() > 0
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_leave_party",
				title_text = "loc_popup_header_leave_party",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_leave_party",
						callback = callback(function ()
							if GameParameters.prod_like_backend then
								Managers.party_immaterium:leave_party()
							end
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_cancel_leave_party",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
	{
		icon = "content/ui/materials/icons/system/escape/quit",
		text = "loc_quit_game_display_name",
		type = "button",
		validation_function = function ()
			return PLATFORM == "win32"
		end,
		trigger_function = function ()
			local context = {
				description_text = "loc_popup_description_quit_game",
				title_text = "loc_popup_header_quit_game",
				options = {
					{
						close_on_pressed = true,
						text = "loc_popup_button_quit_game",
						callback = callback(function ()
							Application.quit()
						end),
					},
					{
						close_on_pressed = true,
						hotkey = "back",
						template_type = "terminal_button_small",
						text = "loc_popup_button_continue_game",
					},
				},
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end,
	},
}
local content_list = {
	StateMainMenu = main_menu_list,
	default = default_list,
}

return content_list
