local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")

local function validation_is_in_mission()
	local host_type = Managers.multiplayer_session:host_type()

	if host_type == MatchmakingConstants.HOST_TYPES.mission_server then
		return true
	end

	return false
end

local function _members_in_party()
	return #Managers.party_immaterium:other_members()
end

local main_menu_list = {
	{
		text = "loc_options_view_display_name",
		type = "button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("options_view")
		end
	},
	{
		type = "spacing_vertical"
	},
	{
		text = "loc_social_view_display_name",
		required_dev_parameter = "ui_show_social_menu",
		type = "button",
		trigger_function = function (parent, widget, entry)
			Managers.ui:open_view("social_menu_view")
		end
	},
	{
		text = "loc_leave_party_display_name",
		type = "button",
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
						template_type = "default_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	},
	{
		type = "spacing_vertical"
	},
	{
		text = "loc_credits_view_display_name",
		type = "button",
		trigger_function = function (parent, widget, entry)
			return
		end
	}
}

if PLATFORM == "win32" then
	main_menu_list[#main_menu_list] = {
		type = "spacing_vertical"
	}
	main_menu_list[#main_menu_list] = {
		text = "loc_quit_game_display_name",
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
						template_type = "default_button_small",
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
		text = "loc_inventory_view_display_name",
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

			return is_in_hub
		end
	},
	{
		text = "loc_social_view_display_name",
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
		text = "loc_options_view_display_name",
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
		type = "spacing_group_divder"
	},
	{
		type = "spacing_group_divder"
	},
	{
		text = "loc_exit_to_main_menu_display_name",
		type = "button",
		validation_function = function ()
			local game_mode_manager = Managers.state.game_mode

			if not game_mode_manager then
				return false
			end

			local game_mode_name = game_mode_manager:game_mode_name()
			local is_in_hub = game_mode_name == "hub"
			local is_in_matchmaking = Managers.data_service.social:is_in_matchmaking()

			return is_in_hub, is_in_matchmaking
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
						template_type = "default_button_small",
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
						template_type = "default_button_small",
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
						template_type = "default_button_small",
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
						template_type = "default_button_small",
						close_on_pressed = true,
						hotkey = "back"
					}
				}
			}

			Managers.event:trigger("event_show_ui_popup", context)
		end
	}
}

if false then
	local debug_list = {
		{
			text = "DEBUG",
			type = "button",
			trigger_function = function ()
				local view_name = "debug_view"

				Managers.ui:open_view(view_name)
			end
		},
		{
			text = "LOADING VIEW",
			type = "button",
			trigger_function = function ()
				local context = {
					can_exit = true
				}
				local view_name = "loading_view"

				Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
			end
		},
		{
			text = "TEST BUTTON",
			type = "button",
			trigger_function = function ()
				Log.info("[SystemView]", "Test Button 4")
			end
		},
		{
			text = "CINEMATIC VIEW",
			type = "button",
			trigger_function = function ()
				local context = {
					video_name = "content/videos/fatshark_splash",
					sound_name = "wwise/events/ui/play_ui_eor_character_lvl_up",
					can_exit = true,
					debug_preview = true
				}
				local view_name = "cinematic_view"

				Managers.ui:open_view(view_name, nil, nil, nil, nil, context)
			end
		},
		{
			text = "SPLASH",
			type = "button",
			trigger_function = function ()
				local view_name = "splash_view"

				Managers.ui:open_view(view_name)
			end
		},
		{
			text = "TITLE",
			type = "button",
			trigger_function = function ()
				local view_name = "title_view"

				Managers.ui:open_view(view_name)
			end
		}
	}
	default_list = table.append(debug_list, default_list)
end

local content_list = {
	StateMainMenu = main_menu_list,
	default = default_list
}

return content_list
