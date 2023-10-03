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
		text = "loc_achievements_view_display_name",
		icon = "content/ui/materials/icons/system/escape/achievements",
		type = "large_button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("account_profile_view")
		end
	},
	{
		text = "loc_social_view_display_name",
		required_dev_parameter = "ui_show_social_menu",
		type = "large_button",
		icon = "content/ui/materials/icons/system/escape/social",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("social_menu_view")
		end
	},
	{
		text = "loc_store_view_display_name",
		icon = "content/ui/materials/icons/system/escape/premium_store",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true
			}
			local view_name = "store_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	},
	{
		type = "spacing_vertical"
	},
	{
		type = "spacing_vertical"
	},
	{
		type = "spacing_vertical"
	},
	{
		text = "loc_news_view_title",
		required_dev_parameter = "ui_debug_news_screen",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/news",
		trigger_function = function ()
			local context = {
				can_exit = true
			}
			local view_name = "news_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	},
	{
		text = "loc_credits_view_title",
		icon = "content/ui/materials/icons/system/escape/credits",
		type = "button",
		trigger_function = function ()
			local context = {
				can_exit = true
			}
			local view_name = "credits_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	},
	{
		text = "loc_options_view_display_name",
		icon = "content/ui/materials/icons/system/escape/settings",
		type = "button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("options_view")
		end
	},
	{
		text = "loc_leave_party_display_name",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/leave_party",
		validation_function = function ()
			return _members_in_party() > 0
		end,
		trigger_function = function ()
			local context = {
				title_text = "loc_popup_header_leave_party",
				description_text = "loc_popup_description_leave_party",
				options = {
					{
						text = "loc_popup_button_leave_party",
						close_on_pressed = true,
						callback = callback(function ()
							if GameParameters.prod_like_backend then
								Managers.party_immaterium:leave_party()
							end
						end)
					},
					{
						text = "loc_popup_button_cancel_leave_party",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	}
}

if PLATFORM == "win32" then
	main_menu_list[#main_menu_list + 1] = {
		type = "spacing_vertical"
	}
	main_menu_list[#main_menu_list + 1] = {
		text = "loc_quit_game_display_name",
		icon = "content/ui/materials/icons/system/escape/quit",
		type = "button",
		trigger_function = function (parent, widget, entry)
			local context = {
				title_text = "loc_popup_header_quit_game",
				description_text = "loc_popup_description_quit_game",
				options = {
					{
						text = "loc_popup_button_quit_game",
						close_on_pressed = true,
						callback = callback(function ()
							Application.quit()
						end)
					},
					{
						text = "loc_popup_button_continue_game",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	}
end

local default_list = {
	{
		text = "loc_character_view_display_name",
		type = "large_button",
		icon = "content/ui/materials/icons/system/escape/inventory",
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
		end
	},
	{
		text = "loc_achievements_view_display_name",
		type = "large_button",
		icon = "content/ui/materials/icons/system/escape/achievements",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("account_profile_view")
		end,
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_in_hub = game_mode_name == "hub" or game_mode_name == "shooting_range"

			return is_in_hub
		end
	},
	{
		text = "loc_social_view_display_name",
		icon = "content/ui/materials/icons/system/escape/social",
		type = "large_button",
		trigger_function = function ()
			local context = {
				can_exit = true
			}
			local view_name = "social_menu_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	},
	{
		type = "spacing_vertical"
	},
	{
		type = "spacing_vertical"
	},
	{
		type = "spacing_vertical"
	},
	{
		text = "loc_options_view_display_name",
		icon = "content/ui/materials/icons/system/escape/settings",
		type = "button",
		trigger_function = function ()
			local context = {
				can_exit = true
			}
			local view_name = "options_view"

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
		end
	},
	{
		text = "loc_exit_to_main_menu_display_name",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/change_character",
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
				title_text = "loc_popup_header_leave_game",
				description_text = "loc_popup_description_leave_game",
				options = {
					{
						text = "loc_popup_button_leave_game",
						close_on_pressed = true,
						callback = callback(function ()
							Managers.multiplayer_session:leave("exit_to_main_menu")
						end)
					},
					{
						text = "loc_popup_button_leave_continue_game",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		text = "loc_leave_mission_display_name",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/leave_mission",
		validation_function = validation_is_in_mission,
		trigger_function = function ()
			local context = {
				title_text = "loc_popup_header_leave_mission",
				description_text = "loc_popup_description_leave_mission",
				options = {
					{
						text = "loc_popup_button_leave_mission",
						close_on_pressed = true,
						callback = callback(function ()
							Managers.multiplayer_session:leave("leave_mission")
						end)
					},
					{
						text = "loc_popup_button_leave_continue_mission",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		text = "loc_menu_skip_prologue",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/leave_mission",
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
				title_text = "loc_menu_skip_prologue",
				description_text = "loc_popup_description_skip_prologue",
				options = {
					{
						text = "loc_confirm",
						close_on_pressed = true,
						callback = callback(function ()
							Managers.narrative:skip_story(Managers.narrative.STORIES.onboarding)
							Managers.state.game_mode:complete_game_mode()
						end)
					},
					{
						text = "loc_popup_button_leave_continue_mission",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		text = "loc_tg_exit_training_grounds",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/leave_training",
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
				title_text = "loc_tg_exit_training_grounds",
				description_text = "loc_popup_description_leave_psykhanium",
				options = {
					{
						text = "loc_training_grounds_choice_quit",
						close_on_pressed = true,
						callback = callback(function ()
							Managers.state.game_mode:complete_game_mode()
						end)
					},
					{
						text = "loc_popup_button_leave_continue_mission",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		text = "loc_leave_party_display_name",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/leave_party",
		validation_function = function ()
			if validation_is_in_mission() then
				return false
			end

			return _members_in_party() > 0
		end,
		trigger_function = function ()
			local context = {
				title_text = "loc_popup_header_leave_party",
				description_text = "loc_popup_description_leave_party",
				options = {
					{
						text = "loc_popup_button_leave_party",
						close_on_pressed = true,
						callback = callback(function ()
							if GameParameters.prod_like_backend then
								Managers.party_immaterium:leave_party()
							end
						end)
					},
					{
						text = "loc_popup_button_cancel_leave_party",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		text = "loc_quit_game_display_name",
		type = "button",
		icon = "content/ui/materials/icons/system/escape/quit",
		validation_function = function ()
			return PLATFORM == "win32"
		end,
		trigger_function = function ()
			local context = {
				title_text = "loc_popup_header_quit_game",
				description_text = "loc_popup_description_quit_game",
				options = {
					{
						text = "loc_popup_button_quit_game",
						close_on_pressed = true,
						callback = callback(function ()
							Application.quit()
						end)
					},
					{
						text = "loc_popup_button_continue_game",
						template_type = "terminal_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	}
}
local content_list = {
	StateMainMenu = main_menu_list,
	default = default_list
}

return content_list
