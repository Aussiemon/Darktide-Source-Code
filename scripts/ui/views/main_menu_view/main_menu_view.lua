-- chunkname: @scripts/ui/views/main_menu_view/main_menu_view.lua

local definition_path = "scripts/ui/views/main_menu_view/main_menu_view_definitions"
local CharacterSelectPassTemplates = require("scripts/ui/pass_templates/character_select_pass_templates")
local InputDevice = require("scripts/managers/input/input_device")
local MainMenuViewSettings = require("scripts/ui/views/main_menu_view/main_menu_view_settings")
local MainMenuViewTestify = GameParameters.testify and require("scripts/ui/views/main_menu_view/main_menu_view_testify")
local ProfileUtils = require("scripts/utilities/profile_utils")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementServerMigration = require("scripts/ui/view_elements/view_element_server_migration/view_element_server_migration")
local ViewElementWallet = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet")
local ViewElementNewsSlide = require("scripts/ui/view_elements/view_element_news_slide/view_element_news_slide")
local MainMenuView = class("MainMenuView", "BaseView")

MainMenuView.init = function (self, settings, context)
	local definitions = require(definition_path)

	MainMenuView.super.init(self, definitions, settings, context)

	self._context = context
	self._parent = context and context.parent
	self._pass_draw = true
	self._keybind_is_reset_on_start = false
	self._show_news_popup = context.show_news_popup
end

MainMenuView.on_enter = function (self)
	MainMenuView.super.on_enter(self)

	self._character_list_widgets = {}
	self._character_slot_spawn_id = 0
	self._character_wait_overlay_active = self._parent and self._parent._character_is_syncing or false
	self._is_main_menu_open = false
	self._character_list_grid = nil
	self._news_list_requested = false
	self._news_list = self:_reset_news_list()
	self._news_element = self:_add_element(ViewElementNewsSlide, "news_element", 101)

	self:_create_character_list_renderer()
	self:_setup_input_legend()
	self:_show_character_details(false)
	self:_set_waiting_for_characters(false)
	self:_setup_interactions()

	if IS_XBS or IS_PLAYSTATION then
		self._widgets_by_name.gamertag.content.gamertag = Managers.account:user_display_name()
	end

	if GameParameters.reset_keybind_on_start and not self._keybind_is_reset_on_start then
		local keybind_settings = require("scripts/settings/options/keybind_settings")

		keybind_settings.reset_function()

		self._keybind_is_reset = true
	end

	self:_register_event("event_main_menu_profiles_changed", "_event_profiles_changed")
	self:_register_event("event_main_menu_selected_profile_changed", "_event_selected_profile_changed")
	self:_register_event("update_character_sync_state", "_event_profile_sync_changed")
	Managers.event:trigger("event_main_menu_entered")
	Managers.event:trigger("event_update_reward_claim_state")

	local save_manager = Managers.save
	local save_data = save_manager:account_data()

	if save_data.latest_backend_migration_index >= 0 then
		self:_create_wallet_element()
	end

	if self._context.migration_data then
		for i = 1, #self._context.migration_data do
			local migration_to_check = self._context.migration_data[i]

			if migration_to_check and migration_to_check.name == "wallet-migration" then
				local data = self._context.migration_data[1].data
				local should_present_data = false

				if data.wallets then
					for j = 1, #data.wallets do
						local wallet = data.wallets[j]

						if wallet.amount and wallet.amount > 0 then
							should_present_data = true

							break
						end
					end
				end

				if should_present_data then
					self:_create_server_migration_element(data)
				end

				break
			end
		end
	end

	if self._show_news_popup then
		self:_update_news_list()
	end
end

MainMenuView._create_server_migration_element = function (self, data)
	self._server_migration_element = self:_add_element(ViewElementServerMigration, "server_migration_element", 200, {
		on_destroy_callback = callback(self, "on_server_migration_removed"),
	})

	self._server_migration_element:present(data)
end

MainMenuView.on_server_migration_removed = function (self)
	for i = 1, #self._context.migration_data do
		local migration_to_check = self._context.migration_data[i]

		if migration_to_check.name == "wallet-migration" then
			self._context.migration_data[i] = nil

			break
		end
	end

	self:_destroy_migration_element()
end

MainMenuView._destroy_migration_element = function (self)
	self:_remove_element("server_migration_element")

	self._server_migration_element = nil
end

MainMenuView._create_wallet_element = function (self)
	self._wallet_element = self:_add_element(ViewElementWallet, "wallet_element", 100)

	self:_update_element_position("wallet_element_pivot", self._wallet_element, true)

	local currencies = {
		"credits",
		"marks",
		"plasteel",
		"diamantine",
	}

	self._wallet_element:_generate_currencies(currencies, {
		150,
		30,
	}, #currencies, {
		nil,
		10,
	})

	self._widgets_by_name.wallet_element_background.content.visible = true
end

MainMenuView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 20)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, function ()
			return legend_input.visibility_function(self)
		end, on_pressed_callback, legend_input.alignment)
	end
end

MainMenuView._update_counts_refreshes = function (self, dt, t)
	if Managers.account:user_detached() then
		return
	end

	local party_time = self._refresh_party_time or 0

	if party_time <= t then
		Managers.data_service.social:fetch_party_members():next(callback(self, "cb_update_strike_team_count"))

		self._refresh_party_time = t + 0.5
	end

	local friends_time = self._refresh_friends_time or 0

	if friends_time <= t then
		Managers.data_service.social:fetch_friends():next(callback(self, "cb_update_friends_count"))
		Managers.data_service.social:fetch_blocked_accounts()

		self._refresh_friends_time = t + 30
	end
end

MainMenuView.cb_on_open_main_menu_pressed = function (self)
	if self._server_migration_element then
		return
	end

	Managers.ui:open_view("system_view")
end

MainMenuView.cb_update_friends_count = function (self, friends)
	if self._destroyed then
		return
	end

	local text_style = self._widgets_by_name.friends_online.style.text
	local text_value = self._widgets_by_name.friends_online.content.text
	local icon_style = self._widgets_by_name.friends_online.style.icon
	local icon_value = self._widgets_by_name.friends_online.content.icon
	local text_count_style = self._widgets_by_name.friends_online.style.text_count
	local text_count_value = self._widgets_by_name.friends_online.content.text_count
	local text_width = UIRenderer.text_size(self._ui_renderer, text_value, text_style.font_type, text_style.font_size)
	local icon_width = UIRenderer.text_size(self._ui_renderer, icon_value, icon_style.font_type, icon_style.font_size)
	local text_count_width = UIRenderer.text_size(self._ui_renderer, text_count_value, text_count_style.font_type, text_count_style.font_size)
	local margin = 5

	icon_style.offset[1] = text_width + margin * 2
	text_count_style.offset[1] = icon_style.offset[1] + icon_width + margin

	self:_set_scenegraph_size("party_count", text_count_style.offset[1] + text_count_width, nil)

	local num_friends = 0

	for i = 1, #friends do
		local player_info = friends[i]
		local is_blocked = player_info:is_blocked()
		local is_online = SocialConstants.OnlineStatus.online == player_info:online_status()
		local is_friend = player_info:is_friend()

		if not is_blocked and is_online and is_friend then
			num_friends = num_friends + 1
		end
	end

	self._widgets_by_name.friends_online.content.text_count = num_friends
end

MainMenuView.cb_update_strike_team_count = function (self, party)
	if not self._destroyed then
		local num_party = 0

		for unique_id, player_info in pairs(party) do
			num_party = num_party + 1
		end

		local max_party_limit = MainMenuViewSettings.max_party_size

		self._widgets_by_name.strike_team.content.text_count = string.format("%d/%d", num_party, max_party_limit)

		local text_style = self._widgets_by_name.strike_team.style.text
		local text_value = self._widgets_by_name.strike_team.content.text
		local icon_style = self._widgets_by_name.strike_team.style.icon
		local icon_value = self._widgets_by_name.strike_team.content.icon
		local text_count_style = self._widgets_by_name.strike_team.style.text_count
		local text_count_value = self._widgets_by_name.strike_team.content.text_count
		local text_width = UIRenderer.text_size(self._ui_renderer, text_value, text_style.font_type, text_style.font_size)
		local icon_width = UIRenderer.text_size(self._ui_renderer, icon_value, icon_style.font_type, icon_style.font_size)
		local text_count_width = UIRenderer.text_size(self._ui_renderer, text_count_value, text_count_style.font_type, text_count_style.font_size)
		local margin = 5

		icon_style.offset[1] = text_width + margin * 2
		text_count_style.offset[1] = icon_style.offset[1] + icon_width + margin

		self:_set_scenegraph_size("strike_team_count", text_count_style.offset[1] + text_count_width, nil)
	end
end

MainMenuView.cb_on_list_entry_pressed = function (self, widget, entry)
	local pressed_function = entry.pressed_function

	if pressed_function then
		pressed_function(self, widget, entry)
	end
end

MainMenuView._set_waiting_for_characters = function (self, waiting)
	self._widgets_by_name.overlay.content.visible = waiting == true

	if waiting then
		local character_slot_widgets = self._character_list_widgets

		for i = 1, #character_slot_widgets do
			local widget = character_slot_widgets[i]

			widget.content.hotspot.is_selected = false
		end
	end
end

MainMenuView._event_profiles_changed = function (self, profiles)
	self._character_profiles = profiles

	self:_sync_character_slots()

	local profile_list = self._character_profiles
	local num_characters = #profile_list or 0
	local max_num_characters = MainMenuViewSettings.max_num_characters
	local slots_remaining = num_characters < max_num_characters and max_num_characters - num_characters or 0

	self._widgets_by_name.slots_count.content.text = Localize("loc_main_menu_slots_remaining", true, {
		count = slots_remaining,
	})

	if num_characters == 0 then
		Managers.event:trigger("event_main_menu_set_new_profile")
		self:_show_character_details(false)
	end
end

MainMenuView._event_selected_profile_changed = function (self, profile)
	local ignore_sound_trigger = not self._selected_profile

	self._selected_profile = profile

	if profile then
		local character_id = profile.character_id
		local selected_index = 1
		local widgets = self._character_list_widgets

		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_profile = widget.content.profile

			if widget_profile and widget_profile.character_id == character_id then
				selected_index = i

				break
			end
		end

		self:_on_character_widget_selected(selected_index, ignore_sound_trigger)
	else
		self:_on_character_widget_selected(1, ignore_sound_trigger)
	end
end

MainMenuView._on_character_widget_selected = function (self, index, ignore_sound_trigger)
	local character_list_widgets = self._character_list_widgets
	local widget = character_list_widgets[index]
	local profile = widget and widget.content.profile

	if profile then
		self:_set_selected_character_list_index(index)

		local scroll_progress = self._character_list_grid:get_scrollbar_percentage_by_index(index)
		local is_using_gampepad = not self._using_cursor_navigation

		self._character_list_grid:select_grid_index(index, scroll_progress, true, is_using_gampepad)

		if not ignore_sound_trigger then
			self:_play_sound(UISoundEvents.main_menu_select_character)
		end

		Managers.event:trigger("event_request_select_new_profile", profile)

		self._selected_profile = profile
	end
end

MainMenuView._set_selected_character_list_index = function (self, index)
	local character_list_widgets = self._character_list_widgets

	if #character_list_widgets == 0 then
		return
	end

	self._selected_character_list_index = index

	local selected_widget = character_list_widgets[index]
	local selected_profile = selected_widget.content.profile

	for i = 1, #character_list_widgets do
		local widget = character_list_widgets[i]
		local is_selected = widget == selected_widget

		widget.content.hotspot.is_selected = is_selected
	end

	if selected_profile then
		self:_show_character_details(true, selected_profile)
		Managers.event:trigger("event_main_menu_set_presentation_profile", selected_profile)
	end
end

MainMenuView._reset_news_list = function (self)
	return {
		slides = {},
	}
end

MainMenuView._populate_news_list = function (self)
	Managers.data_service.news:get_news():next(function (raw_news)
		local slides = table.filter_array(raw_news, function (item)
			return not item:is_read()
		end)

		if #slides > 0 then
			self._news_list = {
				starting_slide_index = 1,
				slides = slides,
			}
		else
			self._news_list = self:_reset_news_list()
		end

		self._news_list_requested = false
	end)
end

MainMenuView._is_processing_backend_request = function (self)
	return self._news_list_requested
end

MainMenuView._update_news_list = function (self)
	self._news_list_requested = true

	self:_populate_news_list()
end

MainMenuView._event_profile_sync_changed = function (self, is_active)
	self._character_wait_overlay_active = is_active

	self:_set_waiting_for_characters(is_active)
end

MainMenuView.update = function (self, dt, t, input_service)
	if self._character_wait_overlay_active then
		input_service = input_service:null_service()
	else
		self:_update_counts_refreshes(dt, t)
	end

	self._is_main_menu_open = Managers.ui:view_active("system_view")

	if not self._server_migration_element and not self:_is_processing_backend_request() and self._news_list.starting_slide_index then
		local slide_data = table.clone(self._news_list)

		Managers.ui:open_view("news_view", nil, nil, nil, nil, {
			on_startup = true,
			slide_data = slide_data,
		})

		self._news_list = self:_reset_news_list()
	end

	local character_list_grid = self._character_list_grid

	if character_list_grid then
		character_list_grid:update(dt, t, input_service)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MainMenuViewTestify, self)
	end

	if (self._widgets_by_name.play_button.content.hotspot.is_focused or self._widgets_by_name.play_button.content.hotspot.is_hover) and not self._widgets_by_name.play_button.content.active then
		self._widgets_by_name.play_button.content.active = true

		self:_play_sound(UISoundEvents.main_menu_start_button_hover_enter)
	elseif not self._widgets_by_name.play_button.content.hotspot.is_focused and not self._widgets_by_name.play_button.content.hotspot.is_hover and self._widgets_by_name.play_button.content.active == true then
		self._widgets_by_name.play_button.content.active = false

		self:_play_sound(UISoundEvents.main_menu_start_button_hover_leave)
	end

	if self._wallet_element then
		local wallet_size = self._wallet_element:get_size()
		local width = math.max(wallet_size[1] + 20, 0)
		local height = wallet_size[2] + 20
		local scenegraph_size = self._ui_scenegraph.wallet_element_background.size

		if width ~= scenegraph_size[1] or height ~= scenegraph_size[2] then
			self:_set_scenegraph_size("wallet_element_background", width, height)
		end
	end

	return MainMenuView.super.update(self, dt, t, input_service)
end

MainMenuView.draw = function (self, dt, t, input_service, layer)
	local stored_service = input_service

	if self._character_wait_overlay_active or self._server_migration_element then
		input_service = input_service:null_service()
	end

	self:_draw_character_list(dt, t, input_service, layer)
	MainMenuView.super.draw(self, dt, t, input_service, layer)

	if self._server_migration_element then
		local elements_array = self._elements_array

		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name

				if element_name == "ViewElemenServerMigration" then
					element:draw(dt, t, self._ui_renderer, self._render_settings, stored_service)
				end
			end
		end
	end
end

MainMenuView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	for i = 1, #elements_array do
		local element = elements_array[i]

		if element then
			local element_name = element.__class_name

			if element_name ~= "ViewElemenServerMigration" then
				element:draw(dt, t, ui_renderer, render_settings, input_service)
			end
		end
	end
end

MainMenuView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	return MainMenuView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

MainMenuView._on_navigation_input_changed = function (self)
	MainMenuView.super._on_navigation_input_changed(self)

	local is_mouse = self._using_cursor_navigation
	local character_list_grid = self._character_list_grid

	if is_mouse then
		if character_list_grid then
			character_list_grid:focus_grid_index(nil)
		end
	elseif character_list_grid then
		local selected_index = self._selected_character_list_index
		local scroll_progress = character_list_grid:get_scrollbar_percentage_by_index(selected_index)

		character_list_grid:focus_grid_index(selected_index, scroll_progress, true)
	end
end

MainMenuView._handle_input = function (self, input_service, dt, t)
	if self._character_wait_overlay_active or self._server_migration_element then
		input_service = input_service:null_service()
	end

	MainMenuView.super._handle_input(self, input_service, dt, t)

	local selected_character_list_index = self._selected_character_list_index
	local create_button = self._widgets_by_name.create_button.content
	local play_button = self._widgets_by_name.play_button.content

	play_button.hotspot.disabled = self._is_main_menu_open
	create_button.hotspot.disabled = self._is_main_menu_open or self:_are_slots_full()

	local character_slot_widgets = self._character_list_widgets
	local num_character_slots = #character_slot_widgets or 0

	if selected_character_list_index then
		for i = 1, num_character_slots do
			local widget = character_slot_widgets[i]

			widget.content.hotspot.disabled = self._is_main_menu_open

			if widget.content.hotspot.on_pressed and i ~= selected_character_list_index then
				self:_on_character_widget_selected(i)

				break
			end
		end
	end

	if not self._is_main_menu_open then
		if input_service:get("navigate_up_continuous") then
			if selected_character_list_index and selected_character_list_index > 1 then
				self:_on_character_widget_selected(selected_character_list_index - 1)
			end
		elseif input_service:get("navigate_down_continuous") then
			local max_num_characters = MainMenuViewSettings.max_num_characters

			if selected_character_list_index and selected_character_list_index < num_character_slots and selected_character_list_index <= max_num_characters then
				self:_on_character_widget_selected(selected_character_list_index + 1)
			end
		elseif play_button.visible and play_button.hotspot.disabled ~= true and input_service:get("confirm_pressed") then
			self:_on_play_pressed()
		elseif create_button.hotspot.disabled ~= true and input_service:get("hotkey_menu_special_1") then
			self:_on_create_character_pressed()
		elseif IS_XBS and input_service:get("cycle_list_secondary") then
			Managers.account:show_profile_picker()
		elseif (IS_XBS or IS_PLAYSTATION) and input_service:get("back") and InputDevice.gamepad_active then
			Managers.account:return_to_title_screen()
		end
	end
end

MainMenuView._on_play_pressed = function (self)
	self:_play_sound(UISoundEvents.main_menu_start_game)
	Managers.event:trigger("event_state_main_menu_continue")
end

MainMenuView._on_create_character_pressed = function (self)
	self:_play_sound(UISoundEvents.character_create_enter)
	Managers.event:trigger("event_create_new_character_start")

	if Managers.ui:view_active("system_view") then
		Managers.ui:close_view("system_view")
	end
end

MainMenuView._on_delete_selected_character_pressed = function (self)
	if self._server_migration_element then
		return
	end

	local profile = self._selected_profile
	local popup_params = {}

	popup_params.title_text = "loc_main_menu_delete_character_popup_title"
	popup_params.title_text_params = {
		character_name = ProfileUtils.character_name(profile),
	}
	popup_params.title_text = "loc_main_menu_delete_character_popup_title"
	popup_params.description_text = "loc_main_menu_delete_character_popup_description"
	popup_params.type = "warning"
	popup_params.options = {
		{
			close_on_pressed = true,
			stop_exit_sound = true,
			template_type = "terminal_button_hold_small",
			text = "loc_main_menu_delete_character_popup_confirm",
			on_complete_sound = UISoundEvents.delete_character_confirm,
			callback = callback(function ()
				local character_id = profile.character_id

				Managers.event:trigger("event_request_delete_character", character_id)

				self._delete_popup_id = nil
			end),
			template_options = {
				start_delay = 2,
				start_input_action = "confirm_pressed",
				timer = 3,
			},
		},
		{
			close_on_pressed = true,
			hotkey = "back",
			template_type = "terminal_button_small",
			text = "loc_main_menu_delete_character_popup_cancel",
			callback = callback(function ()
				self._delete_popup_id = nil
			end),
		},
	}

	Managers.event:trigger("event_show_ui_popup", popup_params, function (id)
		self._delete_popup_id = id
	end)
end

MainMenuView._destroy_character_list_renderer = function (self)
	local world_data = self._character_list_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		world_data = nil
	end
end

MainMenuView.on_exit = function (self)
	if self._input_legend_element then
		self._input_legend_element = nil

		self:_remove_element("input_legend")
	end

	if self._news_element then
		self._news_element = nil

		self:_remove_element("news_element")
	end

	if self._delete_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._delete_popup_id)

		self._delete_popup_id = nil
	end

	self:_destroy_character_grid()
	self:_destroy_character_list_renderer()
	Managers.event:unregister(self, "event_main_menu_load_news")
	Managers.event:unregister(self, "event_main_menu_profiles_changed")
	Managers.event:unregister(self, "event_main_menu_selected_profile_changed")
	Managers.event:unregister(self, "update_character_sync_state")
	MainMenuView.super.on_exit(self)
end

MainMenuView._sync_character_slots = function (self)
	self:_destroy_character_grid()

	self._character_slot_spawn_id = 0

	local profiles = self._character_profiles
	local num_characters = profiles and #profiles or 0
	local grid_direction = "down"
	local grid_scenegraph_id = "character_grid_start"
	local char_list = {}

	for i = 1, num_characters do
		local widget_definition = UIWidget.create_definition(CharacterSelectPassTemplates.character_select, "character_grid_content_pivot", nil, CharacterSelectPassTemplates.character_create_size)
		local profile = profiles[i]

		self._character_slot_spawn_id = self._character_slot_spawn_id + 1

		local widget_name = "character_slot_" .. self._character_slot_spawn_id
		local widget = self:_create_widget(widget_name, widget_definition)
		local widget_content = widget.content

		widget_content.profile = profile

		if profile then
			self:_set_player_profile_information(profile, widget)
			Managers.event:trigger("event_main_menu_load_profile", profile)
		end

		char_list[#char_list + 1] = widget
	end

	local grid = UIWidgetGrid:new(char_list, char_list, self._ui_scenegraph, grid_scenegraph_id, grid_direction, {
		0,
		0,
	})
	local scrollbar_widget = self._widgets_by_name.character_grid_scrollbar
	local grid_content_scenegraph_id = "character_grid_content_pivot"
	local interaction_scenegraph_id = "character_grid_interaction"

	grid:assign_scrollbar(scrollbar_widget, grid_content_scenegraph_id, interaction_scenegraph_id)
	grid:set_scrollbar_progress(0)

	self._character_list_widgets = char_list
	self._character_list_grid = grid
	self._selected_profile = nil
end

MainMenuView._draw_character_list = function (self, dt, t, input_service, layer)
	local offscreen_renderer = self._character_list_renderer
	local render_settings = self._render_settings

	if offscreen_renderer and self._character_list_grid then
		UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)

		local grid_widgets = self._character_list_widgets
		local grid = self._character_list_grid

		for i = 1, #grid_widgets do
			local widget = grid_widgets[i]

			if grid:is_widget_visible(widget) then
				UIWidget.draw(widget, offscreen_renderer)
			end
		end

		UIRenderer.end_pass(offscreen_renderer)
	end
end

MainMenuView._convert_world_to_screen_position = function (self, camera, world_position)
	if camera then
		local world_to_screen, distance = Camera.world_to_screen(camera, world_position)

		return world_to_screen.x, world_to_screen.y, distance
	end
end

MainMenuView.character_profiles = function (self)
	return self._character_profiles
end

MainMenuView.character_wait_overlay_active = function (self)
	return self._character_wait_overlay_active
end

MainMenuView.on_character_widget_selected = function (self, index)
	self:_on_character_widget_selected(index)
end

MainMenuView.on_create_character_pressed = function (self)
	self:_on_create_character_pressed()
end

MainMenuView.on_play_pressed = function (self)
	self:_on_play_pressed()
end

MainMenuView._create_character_list_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_character_list_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = "character_list_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "character_list_renderer"

	self._character_list_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._character_list_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

MainMenuView._destroy_character_grid = function (self)
	local widgets = self._character_list_widgets

	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]

			self:_unload_portrait_icon(widget)

			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end
	end

	self._character_list_grid = nil
	self._character_list_widgets = nil
end

MainMenuView._setup_interactions = function (self)
	self._widgets_by_name.play_button.content.hotspot.pressed_callback = callback(self, "_on_play_pressed")
	self._widgets_by_name.create_button.content.hotspot.pressed_callback = callback(self, "_on_create_character_pressed")

	self._widgets_by_name.counts_background.content.hotspot.pressed_callback = function ()
		Managers.ui:open_view("social_menu_view")
	end
end

MainMenuView._show_character_details = function (self, show, profile)
	self._character_details_active = show
	self._widgets_by_name.play_button.content.visible = show
	self._widgets_by_name.character_info.content.visible = show

	if show == true then
		local character_archetype_title = ProfileUtils.character_archetype_title(profile)
		local character_level = tostring(profile.current_level) .. " "

		self._widgets_by_name.character_info.content.character_archetype_title = string.format("%s %s", character_archetype_title, character_level)
		self._widgets_by_name.character_info.content.character_name = ProfileUtils.character_name(profile)
		self._widgets_by_name.character_info.content.archetype_icon = profile.archetype.archetype_badge

		local player_title = ProfileUtils.character_title(profile)

		if player_title then
			self._widgets_by_name.character_info.content.character_title = player_title
		end
	end
end

MainMenuView._are_slots_full = function (self)
	local profiles = self._character_profiles
	local num_characters = profiles and #profiles or 0
	local max_num_characters = MainMenuViewSettings.max_num_characters

	return max_num_characters <= num_characters
end

MainMenuView._set_player_profile_information = function (self, profile, widget)
	local character_name = ProfileUtils.character_name(profile)
	local character_level = tostring(profile.current_level) .. " "
	local character_archetype_title = ProfileUtils.character_archetype_title(profile)

	widget.content.character_name = character_name
	widget.content.character_archetype_title = string.format("%s %s", character_archetype_title, character_level)
	widget.content.archetype_icon = profile.archetype.archetype_icon_large

	local player_title = ProfileUtils.character_title(profile)

	if player_title then
		widget.content.character_title = player_title
	end

	if not player_title or player_title == "" then
		widget.style.character_name.offset[2] = -12
		widget.style.character_archetype_title.offset[2] = -1
	else
		widget.style.character_name.offset[2] = -30
		widget.style.character_archetype_title.offset[2] = 12
	end

	self:_request_player_icon(profile, widget)

	local loadout = profile.loadout
	local frame_item = loadout and loadout.slot_portrait_frame

	if frame_item then
		local cb = callback(self, "_cb_set_player_frame", widget)

		widget.content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb)
	end

	local insignia_item = loadout and loadout.slot_insignia

	if insignia_item then
		local cb = callback(self, "_cb_set_player_insignia", widget)

		widget.content.insignia_load_id = Managers.ui:load_item_icon(insignia_item, cb)
	end
end

MainMenuView._cb_set_player_frame = function (self, widget, item)
	local material_values = widget.style.character_portrait.material_values

	material_values.portrait_frame_texture = item.icon
end

MainMenuView._cb_set_player_insignia = function (self, widget, item)
	local icon_style = widget.style.character_insignia
	local material_values = icon_style.material_values

	if item.icon_material and item.icon_material ~= "" then
		if material_values.texture_map then
			material_values.texture_map = nil
		end

		widget.content.character_insignia = item.icon_material
	else
		material_values.texture_map = item.icon
	end

	icon_style.color[1] = 255
end

MainMenuView._request_player_icon = function (self, profile, widget)
	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon(profile, widget)
end

MainMenuView._load_portrait_icon = function (self, profile, widget)
	local load_cb = callback(self, "_cb_set_player_icon", widget)
	local unload_cb = callback(self, "_cb_unset_player_icon", widget)

	widget.content.icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)
end

MainMenuView._cb_set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local material_values = widget.style.character_portrait.material_values

	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base"
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

MainMenuView._cb_unset_player_icon = function (self, widget)
	local material_values = widget.style.character_portrait.material_values

	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.character_portrait = "content/ui/materials/base/ui_portrait_frame_base_no_render"
end

MainMenuView._unload_portrait_icon = function (self, widget)
	local ui_renderer = self._character_list_renderer

	UIWidget.set_visible(widget, ui_renderer, false)

	local icon_load_id = widget.content.icon_load_id
	local frame_load_id = widget.content.frame_load_id
	local insignia_load_id = widget.content.insignia_load_id

	if icon_load_id then
		Managers.ui:unload_profile_portrait(icon_load_id)

		widget.content.icon_load_id = nil
	end

	if frame_load_id then
		Managers.ui:unload_item_icon(frame_load_id)

		widget.content.frame_load_id = nil
	end

	if insignia_load_id then
		Managers.ui:unload_item_icon(insignia_load_id)

		widget.content.insignia_load_id = nil

		local icon_style = widget.style.character_insignia

		icon_style.color[1] = 0
	end
end

MainMenuView._news_requested = function (self)
	local news_element = self._news_element

	return news_element and news_element:view_requested()
end

MainMenuView._can_show_news = function (self)
	local news_element = self._news_element

	return news_element and news_element:can_open_view()
end

return MainMenuView
