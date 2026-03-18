-- chunkname: @scripts/ui/views/expedition_view/expedition_view_sidebar.lua

local ExpeditionViewDefinitions = require("scripts/ui/views/expedition_view/expedition_view_definitions")
local ViewElementExpeditionViewMissionInfo = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info")
local DifficultySelector = require("scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector")
local InputDevice = require("scripts/managers/input/input_device")
local MATCH_VISIBILITY = ExpeditionViewDefinitions.MATCH_VISIBILITY
local Sidebar = class("Sidebar")

Sidebar.init = function (self, owner_view)
	self._owner_view = owner_view

	local play_button = self:_get_widget("play_button")

	play_button.content.hotspot.pressed_callback = callback(owner_view, "cb_start_selected_mission")

	self:_setup_difficulty_selector()
	self:show_mission_info()
end

Sidebar._get_widget = function (self, widget_name)
	return self._owner_view._widgets_by_name[widget_name]
end

Sidebar._setup_difficulty_selector = function (self)
	local owner_view = self._owner_view

	if owner_view:_element("difficulty_selector") then
		owner_view:_remove_element("difficulty_selector")
	end

	local context = {
		show_progress = true,
		callbacks = {
			on_indicator_pressed = "request_page_at",
			on_left_pressed = "request_prev_page",
			on_right_pressed = "request_next_page",
		},
	}

	owner_view:_add_element(DifficultySelector, "difficulty_selector", 20, context)
end

Sidebar.show_mission_info = function (self, node)
	local owner = self._owner_view

	if owner:_element("view_element_expedition_view_mission_info") then
		owner:_remove_element("view_element_expedition_view_mission_info")
	end

	local mission_data = owner:get_selected_mission_data(node)
	local nodes = owner.nodes

	if not node or not nodes then
		return
	end

	local context = {
		node = node,
		mission = mission_data,
		all_nodes = nodes,
	}

	owner:_add_element(ViewElementExpeditionViewMissionInfo, "view_element_expedition_view_mission_info", 20, context)
end

Sidebar.update = function (self, dt, t, input_service)
	local has_synced = self._owner_view.has_synced
	local difficulty_selector = self._owner_view:_element("difficulty_selector")

	difficulty_selector:set_visibility(has_synced)

	if not self._difficulty_selector_initialized_data and has_synced then
		difficulty_selector:initialize_data()

		self._difficulty_selector_initialized_data = true
	end

	self:update_match_visibility_text(self._owner_view.current_match_visibility)
	self:_update_info_text()
	self:_handle_play_button_input(input_service)
end

Sidebar.update_match_visibility_text = function (self, match_visibility)
	local play_button_legend = self:_get_widget("play_button_legend")

	if match_visibility == MATCH_VISIBILITY.public then
		play_button_legend.content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	elseif match_visibility == MATCH_VISIBILITY.private then
		play_button_legend.content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

Sidebar._update_info_text = function (self)
	local can_start_mission, _, text = self._owner_view:get_can_start_mission()
	local play_button = self:_get_widget("play_button")

	play_button.content.hotspot.disabled = not can_start_mission
	play_button.content.disabled_text = text
end

Sidebar.switch_tab = function (self)
	local element = self._owner_view:_element("view_element_expedition_view_mission_info")

	if element then
		element:switch_tab()
	end
end

Sidebar._handle_play_button_input = function (self, input_service)
	local play_button = self:_get_widget("play_button")
	local using_gamepad = InputDevice.gamepad_active

	if not using_gamepad then
		return
	end

	local hotspot = play_button.content.hotspot

	if hotspot.disabled then
		return
	end

	local gamepad_action = play_button.content.gamepad_action

	if gamepad_action and input_service:get(gamepad_action) then
		hotspot.pressed_callback()
	end
end

return Sidebar
