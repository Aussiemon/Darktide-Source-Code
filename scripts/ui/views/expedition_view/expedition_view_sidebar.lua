-- chunkname: @scripts/ui/views/expedition_view/expedition_view_sidebar.lua

local DifficultySelector = require("scripts/ui/view_elements/view_element_mission_board_difficulty_selector/view_element_mission_board_difficulty_selector")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local ExpeditionViewDefinitions = require("scripts/ui/views/expedition_view/expedition_view_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local MissionBoardBlueprints = require("scripts/ui/view_content_blueprints/mission_tile_blueprints/mission_tile_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementExpeditionViewMissionInfo = require("scripts/ui/view_elements/view_element_expedition_view_mission_info/view_element_expedition_view_mission_info")
local MATCH_VISIBILITY = ExpeditionViewDefinitions.MATCH_VISIBILITY
local UNLOCK_STATUS = ExpeditionService.UNLOCK_STATUS
local Sidebar = class("Sidebar")

Sidebar.init = function (self, owner, context)
	self._owner = owner
	self._widgets_by_name = context.widgets_by_name
	self._personal_stats = context.personal_stats
	self._quickplay_bonus_range = context.quickplay_bonus_range
	self._ui_scenegraph = context.ui_scenegraph
	self._quickplay_unlocked = context.quickplay_unlocked

	self:_setup_quickplay_button()
	self:_setup_play_button()
	self:_setup_difficulty_selector()
	self:_setup_mapwide_stats()
end

Sidebar._setup_quickplay_button = function (self)
	local bonus_text
	local bonus_low, bonus_high = self._quickplay_bonus_range[1], self._quickplay_bonus_range[2]

	if bonus_low and bonus_high then
		local internal_bonus_text = bonus_low == bonus_high and tostring(bonus_low) or string.format("+%s%% - %s%%", bonus_low, bonus_high)

		bonus_text = Localize("loc_mission_board_card_bonus_text", true, {
			bonus_text = internal_bonus_text,
		})
	end

	local is_unlocked = self._quickplay_unlocked and self._owner:_get_current_match_visibility() == MATCH_VISIBILITY.public
	local widget_id = "quickplay_button"
	local optional_blueprint_settings = "quickplay_tile"
	local optional_creation_context = {
		icon = "content/ui/textures/icons/mission_types_pj/mission_type_quick",
		is_locked = not is_unlocked,
		sub_header_text = bonus_text,
		header_text = Localize("loc_mission_board_quickplay_header"),
	}
	local widget = self:_widget_from_blueprint(widget_id, optional_blueprint_settings, nil, optional_creation_context)

	self._quickplay_button_widget = widget

	local node = self:_create_node_from_widget(widget, widget_id)

	self._quickplay_button_node = node

	local callback_function = callback(self._owner, "cb_widget_node_pressed", node)

	widget.content.hotspot.pressed_callback = callback_function
	widget.visible = false
end

Sidebar.quickplay_button_node = function (self)
	return self._quickplay_button_node
end

Sidebar._setup_play_button = function (self)
	local play_button = self._widgets_by_name.play_button

	play_button.content.hotspot.pressed_callback = callback(self._owner, "cb_start_selected_mission")
	play_button.visible = false
	self._widgets_by_name.play_button_legend.visible = false
end

Sidebar._widget_from_blueprint = function (self, widget_id, blueprint_setting_name, mission_data, creation_context, ...)
	local blueprint_settings = {
		blueprint_name = "small_static_tile_pass_templates",
		is_large = false,
		scenegraph_id = "quickplay_button",
		size = {
			280,
			48,
		},
	}

	if not blueprint_settings then
		Log.error("MissionBoardView", "No blueprint settings found for '%s'.", blueprint_setting_name)

		return
	end

	local blueprint_name = blueprint_settings.blueprint_name
	local blueprint = MissionBoardBlueprints[blueprint_name]

	if not blueprint then
		return
	end

	local size = blueprint_settings.size
	local scenegraph_id = blueprint_settings.scenegraph_id

	creation_context.is_large = blueprint_settings.is_large

	local definition = MissionBoardBlueprints.make_blueprint(blueprint, scenegraph_id, size)
	local widget = self._owner:sidebar_create_widget(widget_id, definition)

	if not widget then
		return
	end

	local content = widget.content

	for i = 1, select("#", ...), 2 do
		local key, value = select(i, ...)

		content[key] = value
	end

	widget.content.blueprint_name = blueprint_setting_name
	widget.content.blueprint = definition

	local init = definition.init

	if init then
		local width, height = init(definition, widget, mission_data, creation_context)

		return widget, width, height
	end

	return widget
end

Sidebar._create_node_from_widget = function (self, widget, id, unlocked_status)
	if not widget then
		return nil
	end

	local node = {}

	node.ui = {}

	local widget_scenegraph_id = widget.scenegraph_id
	local scenegraph_node = self._ui_scenegraph[widget_scenegraph_id]
	local widget_offset = widget.offset or {
		0,
		0,
		1,
	}
	local scenegraph_position = scenegraph_node.world_position

	node.ui.screen_position = Vector3Box(scenegraph_position[1] + widget_offset[1], scenegraph_position[2] + widget_offset[2], scenegraph_position[3] + widget_offset[3])
	node.type = "from_widget"
	node.id = id
	node.unlocked_status = unlocked_status or UNLOCK_STATUS.unlocked
	node.widget = widget

	return node
end

Sidebar._setup_difficulty_selector = function (self)
	local context = {
		show_progress = true,
		callbacks = {
			on_indicator_pressed = "request_page_at",
			on_left_pressed = "request_prev_page",
			on_right_pressed = "request_next_page",
		},
	}

	self._owner:sidebar_add_element(DifficultySelector, "difficulty_selector", 20, context)
end

Sidebar._setup_mapwide_stats = function (self)
	self._widgets_by_name.mapwide_stats.content.personal_total_number = self._personal_stats and self._personal_stats.total_loot and tonumber(self._personal_stats.total_loot) or 0
	self._widgets_by_name.mapwide_stats.content.personal_best_number = self._personal_stats and self._personal_stats.best_loot and tonumber(self._personal_stats.best_loot) or 0
end

Sidebar.show_mission_info = function (self, node)
	local owner = self._owner
	local mission_data = owner:get_selected_mission_data(node)
	local nodes = owner:get_all_nodes()

	if not node or not nodes then
		return
	end

	local context = {
		node = node,
		mission = mission_data,
		all_nodes = nodes,
	}

	owner:sidebar_add_element(ViewElementExpeditionViewMissionInfo, "view_element_expedition_view_mission_info", 20, context)
end

Sidebar.remove_mission_info = function (self)
	local owner = self._owner

	owner:sidebar_remove_element("view_element_expedition_view_mission_info")
end

Sidebar.update = function (self, dt, t, input_service)
	local has_fetched = self._owner:get_has_fetched()
	local difficulty_selector = self._owner:_element("difficulty_selector")

	difficulty_selector:set_visibility(has_fetched and self._owner:node_enter_anim_finished())

	if not self._difficulty_selector_initialized_data and has_fetched then
		difficulty_selector:initialize_data()

		self._difficulty_selector_initialized_data = true
	end

	self:update_match_visibility_text(self._owner.current_match_visibility)
	self:_update_info_text()
	self:_handle_play_button_input(input_service)
end

Sidebar.update_match_visibility_text = function (self, match_visibility)
	local play_button_legend = self._widgets_by_name.play_button_legend

	if match_visibility == MATCH_VISIBILITY.public then
		play_button_legend.content.text = Utf8.upper(Localize("loc_mission_board_play_public"))
	elseif match_visibility == MATCH_VISIBILITY.private then
		play_button_legend.content.text = Utf8.upper(Localize("loc_mission_board_play_private"))
	end
end

Sidebar._update_info_text = function (self)
	local can_start_mission, _, text = self._owner:get_can_start_mission()
	local play_button = self._widgets_by_name.play_button

	play_button.content.hotspot.disabled = not can_start_mission
	play_button.content.disabled_text = text
end

Sidebar.update_quickplay_widget_locking = function (self)
	local quickplay_widget = self._quickplay_button_widget

	if quickplay_widget then
		local content = quickplay_widget.content
		local is_unlocked = self._quickplay_unlocked and self._owner:_get_current_match_visibility() == MATCH_VISIBILITY.public

		content.is_locked = not is_unlocked
	end
end

Sidebar.draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local quickplay_button_widget = self._widgets_by_name.quickplay_button

	if quickplay_button_widget then
		UIWidget.draw(quickplay_button_widget, ui_renderer)
	end
end

Sidebar.switch_tab = function (self)
	local element = self._owner:_element("view_element_expedition_view_mission_info")

	if element then
		element:switch_tab()
	end
end

Sidebar.show_widgets = function (self)
	self._node_enter_anim_finished = true
	self._widgets_by_name.play_button.visible = true
	self._widgets_by_name.play_button_legend.visible = true
	self._widgets_by_name.quickplay_button.visible = true
	self._widgets_by_name.mapwide_stats.content.visible = true
end

Sidebar.hide_widgets = function (self)
	self._node_enter_anim_finished = false
	self._widgets_by_name.play_button.visible = false
	self._widgets_by_name.play_button_legend.visible = false
	self._widgets_by_name.quickplay_button.visible = false
	self._widgets_by_name.mapwide_stats.content.visible = false
end

Sidebar._update_play_button = function (self)
	local selected_node = self._owner:get_selection()
	local widgets_by_name = self._widgets_by_name
	local is_node_unlockable = selected_node and selected_node.unlock_status == UNLOCK_STATUS.unlockable
	local enter_anim_finished = self._node_enter_anim_finished

	widgets_by_name.unlock_button.content.visible = is_node_unlockable and enter_anim_finished
	widgets_by_name.play_button.content.visible = not is_node_unlockable and enter_anim_finished
	widgets_by_name.play_button_legend.content.visible = not is_node_unlockable and enter_anim_finished
end

Sidebar._handle_play_button_input = function (self, input_service)
	local play_button = self._widgets_by_name.play_button
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
