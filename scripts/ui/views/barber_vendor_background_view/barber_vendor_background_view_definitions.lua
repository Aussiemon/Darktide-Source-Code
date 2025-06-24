-- chunkname: @scripts/ui/views/barber_vendor_background_view/barber_vendor_background_view_definitions.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
}
local widget_definitions = {}
local input_legend_params = {
	layer = 10,
	buttons_params = {
		{
			alignment = "left_alignment",
			display_name = "loc_settings_menu_close_menu",
			input_action = "back",
			on_pressed_callback = "cb_on_close_pressed",
			visibility_function = function (parent)
				return parent._presenting_options
			end,
		},
	},
}
local intro_texts = {
	description_text = "loc_barber_vendor_view_intro_description",
	title_text = "loc_barber_vendor_view_intro_title",
}

local function button_options_definitions()
	local buttons = {
		{
			display_name = "loc_barber_vendor_view_option_modify",
			callback = function (self)
				local tab_bar_params = {
					hide_tabs = true,
					layer = 10,
					tabs_params = {
						{
							blur_background = false,
							display_name = "loc_credits_vendor_view_title",
							view = "character_appearance_view",
							context_function = function ()
								return {
									is_barber_appearance = true,
									pass_draw = false,
									pass_input = true,
								}
							end,
						},
					},
				}

				self:_setup_tab_bar(tab_bar_params, {
					fetch_store_items_on_enter = true,
				})
			end,
		},
		{
			display_name = "loc_barber_vendor_view_option_mindwipe",
			callback = function (self)
				if self:can_afford_mindwipe() then
					local tab_bar_params = {
						hide_tabs = true,
						layer = 10,
						tabs_params = {
							{
								blur_background = false,
								display_name = "loc_credits_vendor_view_title",
								view = "character_appearance_view",
								context_function = function ()
									return {
										is_barber_mindwipe = true,
										pass_draw = false,
										pass_input = true,
									}
								end,
							},
						},
					}

					self:_setup_tab_bar(tab_bar_params, {
						fetch_store_items_on_enter = true,
					})
				elseif self._operations then
					local context = {
						description_text = "loc_mindwipe_insufficient_funds_popup_description",
						title_text = "loc_mindwipe_insufficient_funds_popup_title",
						description_text_params = {
							cost = self._cost,
							balance = self._balance,
						},
						options = {
							{
								close_on_pressed = true,
								text = "loc_popup_button_close",
								on_pressed_sound = UISoundEvents.default_click,
							},
						},
					}

					Managers.event:trigger("event_show_ui_popup", context)

					local result = "cannot_enter_view"

					return result
				else
					local context = {
						description_text = "loc_crafting_failure",
						title_text = "loc_popup_header_error",
						options = {
							{
								close_on_pressed = true,
								text = "loc_barber_vendor_confirm_button",
								on_pressed_sound = UISoundEvents.default_click,
							},
						},
					}

					Managers.event:trigger("event_show_ui_popup", context)

					local result = "cannot_enter_view"

					return result
				end
			end,
		},
	}
	local player = Managers.player:local_player(1)
	local real_profile = player:profile()
	local archetype = real_profile.archetype.name

	if archetype == "adamant" then
		table.insert(buttons, 2, {
			unlocalized_name = "Modify Cyber-Mastiff Appearance",
			callback = function (self)
				local tab_bar_params = {
					hide_tabs = true,
					layer = 10,
					tabs_params = {
						{
							blur_background = false,
							display_name = "loc_credits_vendor_view_title",
							view = "character_appearance_view",
							context_function = function ()
								return {
									is_barber_companion_appearance = true,
									pass_draw = false,
									pass_input = true,
								}
							end,
						},
					},
				}

				self:_setup_tab_bar(tab_bar_params, {
					fetch_store_items_on_enter = true,
				})
			end,
		})
	end

	return buttons
end

local background_world_params = {
	level_name = "content/levels/ui/barber/barber",
	register_camera_event = "event_register_barber_camera",
	shading_environment = "content/shading_environments/ui/barber",
	timer_name = "ui",
	total_blur_duration = 0.5,
	viewport_layer = 1,
	viewport_name = "ui_credits_vendor_world_viewport",
	viewport_type = "default",
	world_layer = 1,
	world_name = "ui_credits_vendor_world",
}

return {
	intro_texts = intro_texts,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition,
	button_options_definitions = button_options_definitions,
	input_legend_params = input_legend_params,
	background_world_params = background_world_params,
}
