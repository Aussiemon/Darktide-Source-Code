-- chunkname: @scripts/ui/views/expedition_view/expedition_view.lua

local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local ExpeditionViewDefinitions = require("scripts/ui/views/expedition_view/expedition_view_definitions")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local Settings = require("scripts/ui/views/expedition_view/expedition_view_settings")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local ExpeditionViewOptionsElement = require("scripts/ui/views/expedition_view/expedition_view_options_element")
local ExpeditionViewSidebar = require("scripts/ui/views/expedition_view/expedition_view_sidebar")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local InputDevice = require("scripts/managers/input/input_device")
local MissionBoardBlueprints = require("scripts/ui/view_content_blueprints/mission_tile_blueprints/mission_tile_blueprints")
local UIWidget = require("scripts/managers/ui/ui_widget")
local QPCode = require("scripts/utilities/qp_code")
local ViewElementTutorialPopup = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup")
local InputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local MATCH_VISIBILITY = ExpeditionViewDefinitions.MATCH_VISIBILITY
local UNLOCK_STATUS = ExpeditionService.UNLOCK_STATUS
local UNLOCK_TYPE = ExpeditionService.UNLOCK_TYPE
local ExpeditionView = class("ExpeditionView", "BaseView")

ExpeditionView.init = function (self, settings, context)
	self._context = context
	self._promise_container = PromiseContainer:new()

	self:_fetch_data()

	self.save_data = Managers.data_service.expedition:get_character_mission_board_save_data()
	self.current_match_visibility = self:get_saved_match_visibility()
	self._page_index = self.save_data.page_index and math.clamp(self.save_data.page_index - 1, 1, #DangerSettings - 1) or 1
	self._player_level = self:_player():profile().current_level

	local party_manager = Managers.party_immaterium

	self._party_manager = party_manager
	self._enable_input_delay = Settings.enable_input_delay
	self._selected_node_index = 1
	self._node_unlock_queue = {}

	ExpeditionView.super.init(self, ExpeditionViewDefinitions, settings, context)
end

ExpeditionView._fetch_data = function (self)
	self.has_synced = false

	local player = self:_player()
	local account_id = player:account_id()
	local character_id = player:character_id()
	local promises = {
		Managers.data_service.region_latency:fetch_regions_latency(),
		Managers.data_service.expedition:fetch_nodes(),
		Managers.data_service.expedition:get_quickplay_bonus(),
		Managers.data_service.expedition:fetch_player_journey_data(account_id, character_id, false),
	}

	self._promise_container:cancel_on_destroy(Promise.all(unpack(promises)):next(function (data)
		self.regions_latency = data[1]
		self._personal_stats = data[2] and data[2].personal_stats
		self.nodes = data[2] and data[2].nodes_by_id
		self._ordered_nodes = data[2] and data[2].nodes_by_index
		self.quickplay_bonus_range = data[3]

		if not Managers.data_service.expedition:has_cached_progression_data() then
			return Promise.rejected("Progression data was unavailable.")
		end

		self._difficulty_progress_data = Managers.data_service.expedition:get_difficulty_progression_data()
		self._page_settings = self:_create_page_settings(self._difficulty_progress_data)

		local automatic_node_unlock_promises = {}

		for i = 1, #self._ordered_nodes do
			local node = self._ordered_nodes[i]
			local node_id = node.id
			local unlock_status = node.unlock_status
			local unlock_type = node.to_unlock[1][1].type

			if unlock_status == UNLOCK_STATUS.unlockable and unlock_type == UNLOCK_TYPE.unlocked_by_default then
				automatic_node_unlock_promises[#automatic_node_unlock_promises + 1] = Managers.data_service.expedition:claim_track_node(node_id):next(function ()
					self.nodes[node_id].unlock_status = UNLOCK_STATUS.unlocked
				end)
			end
		end

		return self._promise_container:cancel_on_destroy(Promise.all(unpack(automatic_node_unlock_promises))):next(function ()
			self.has_synced = true
		end):catch(function ()
			self.has_synced = true
		end)
	end):catch(function (error)
		if not error then
			error = Localize("loc_popup_description_backend_error")
		else
			error = Localize("loc_popup_description_backend_error") .. ": " .. error
		end

		Log.exception("ExpeditionView", "Exception fetching data: ", error)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = error,
		})

		if Managers.ui:view_active(self.view_name) then
			Managers.ui:close_view(self.view_name)
		end
	end))
end

ExpeditionView.get_saved_match_visibility = function (self)
	local save_data = self.save_data
	local match_visibility

	if save_data.private_match == false then
		match_visibility = MATCH_VISIBILITY.public
	elseif save_data.private_match == true then
		match_visibility = MATCH_VISIBILITY.private
	end

	return match_visibility
end

ExpeditionView.on_enter = function (self)
	if not self.has_synced then
		return
	end

	ExpeditionView.super.on_enter(self)
	self:_setup_background_world(self._definitions.background_world_params)

	self._options = ExpeditionViewOptionsElement:new(self)

	self:_setup_input_legend(self._definitions.input_legend_params)
	self:_update_nodes()

	self._sidebar = ExpeditionViewSidebar:new(self)

	local progression = Managers.data_service.expedition:get_game_modes_progression_data()

	self.quickplay_unlocked = progression and progression.quickplay and progression.quickplay.unlocked

	self:_setup_quickplay_button()

	self._selected_node_index = #self._ordered_nodes
	self.selected_node = self._ordered_nodes[#self._ordered_nodes]
	self._widgets_by_name.unlock_button.content.visible = false
	self._widgets_by_name.mapwide_stats.content.personal_total_number = self._personal_stats and self._personal_stats.total_loot and tonumber(self._personal_stats.total_loot) or 0
	self._widgets_by_name.mapwide_stats.content.personal_best_number = self._personal_stats and self._personal_stats.best_loot and tonumber(self._personal_stats.best_loot) or 0
	self._widgets_by_name.mapwide_stats.visible = false

	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	local show_tutorial_popup = not save_data or not save_data.expedition_tutorial_popup_shown

	if show_tutorial_popup then
		local context = {
			close_callback = function ()
				self._remove_tutorial_popup_next_frame = true

				local save_manager = Managers.save
				local save_data = save_manager:account_data()

				if save_data and not save_data.expedition_tutorial_popup_shown then
					save_data.expedition_tutorial_popup_shown = true

					save_manager:queue_save()
				end

				self._tutorial_popup = nil
			end,
			popup_pages = Settings.popup_pages,
		}
		local scenegraph_id = "tutorial_popup_pivot"

		self._tutorial_popup = self:_add_element(ViewElementTutorialPopup, "tutorial_popup", 90, context, scenegraph_id)
	end
end

local function set_material_animation_duration(unit, name, duration)
	Unit.set_scalar_for_materials(unit, name, duration)
end

local function start_material_animation(unit, name)
	local world = Unit.world(unit)
	local start_time = World.render_time(world) + 0.01

	Unit.set_scalar_for_materials(unit, name, start_time)
end

ExpeditionView._setup_background_world = function (self, params)
	self:_register_event(params.register_camera_event)
	self:_register_event(params.table_pivot_event)

	local world_name = params.world_name or self.view_name .. "_world"
	local world_layer = params.world_layer or 1
	local world_timer_name = params.timer_name or "ui"

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	self:_register_event("event_register_character_spawn_point")

	local level_name = params.level_name

	self._world_spawner:spawn_level(level_name)

	local world = self._world_spawner:world()
	local terrain_unit = World.units_by_resource(world, Settings.hologram_terrain_unit_path)[1]

	if terrain_unit then
		start_material_animation(terrain_unit, "start_time_uv_offset")
		start_material_animation(terrain_unit, "start_time_height")
	end
end

ExpeditionView._setup_input_legend = function (self, input_legend_params)
	if self:_element("input_legend") then
		self:_remove_element("input_legend")
	end

	local layer = input_legend_params.layer or 20

	self._input_legend = self:_add_element(InputLegend, "input_legend", layer)

	local buttons_params = input_legend_params.buttons_params

	for i = 1, #buttons_params do
		self:add_input_legend_entry(buttons_params[i])
	end
end

ExpeditionView.add_input_legend_entry = function (self, entry_params)
	local input_legend = self:_element("input_legend")
	local press_callback
	local on_pressed_callback = entry_params.on_pressed_callback
	local callback_parent = self[on_pressed_callback] and self or nil

	if not callback_parent and self._active_view then
		local view_instance = self._active_view and Managers.ui:view_instance(self._active_view)

		callback_parent = view_instance
	end

	press_callback = callback_parent and callback(callback_parent, on_pressed_callback)

	local display_name = entry_params.display_name
	local input_action = entry_params.input_action
	local visibility_function = entry_params.visibility_function
	local alignment = entry_params.alignment
	local suffix_function = entry_params.suffix_function

	return input_legend:add_entry(display_name, input_action, visibility_function, press_callback, alignment, nil, nil, nil, suffix_function)
end

ExpeditionView._create_node_from_widget = function (self, widget, id, unlocked_status)
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
	self._ordered_nodes[#self._ordered_nodes + 1] = node

	return node
end

ExpeditionView._ensure_selection_variables_synchronised = function (self)
	if not self._node_enter_anim_finished then
		return
	end

	local selected_node = self.selected_node
	local selected_ordered_node_index = self._selected_node_index
	local selected_ordered_node = self._ordered_nodes[selected_ordered_node_index]

	if selected_node ~= selected_ordered_node then
		Log.error("ExpeditionView", "Node selection has diverged between the different variables.")
	end
end

ExpeditionView.update = function (self, dt, t, input_service)
	if not self._entered then
		if self.has_synced then
			self:on_enter()
		end

		return
	end

	self:_ensure_selection_variables_synchronised()

	if self._present_tutorial_popup and not self._tutorial_popup then
		self:_show_tutorial_popup()
	end

	if self._tutorial_popup then
		self._stored_input = input_service
		input_service = input_service:null_service()
	end

	self:_update_node_unlock_queue(dt, t, input_service)
	self:_update_nodes(dt, t, input_service)
	self:_update_nodes_mission_data(dt, t, input_service)

	local selected_node = self.selected_node
	local widgets_by_name = self._widgets_by_name
	local is_node_unlockable = selected_node and selected_node.unlock_status == UNLOCK_STATUS.unlockable

	widgets_by_name.unlock_button.content.visible = is_node_unlockable
	widgets_by_name.play_button.content.visible = not is_node_unlockable
	widgets_by_name.play_button_legend.content.visible = not is_node_unlockable

	self:_update_can_start_mission()
	self._sidebar:update(dt, t, input_service)

	if self._remove_tutorial_popup_next_frame then
		self:_remove_element("tutorial_popup")

		self._remove_tutorial_popup_next_frame = nil
	end

	ExpeditionView.super.update(self, dt, t, input_service)

	if self._stored_input then
		input_service = self._stored_input
		self._stored_input = nil
	end
end

ExpeditionView._update_elements = function (self, dt, t, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local tutorial_popup_element = self._elements.tutorial_popup

				if self._stored_input and tutorial_popup_element == element then
					element:update(dt, t, self._stored_input)
				else
					element:update(dt, t, input_service)
				end
			end
		end
	end
end

ExpeditionView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
				local element_name = element.__class_name
				local tutorial_popup_element = self._elements.tutorial_popup

				if self._stored_input and tutorial_popup_element == element then
					element:draw(dt, t, ui_renderer, render_settings, self._stored_input)
				else
					element:draw(dt, t, ui_renderer, render_settings, input_service)
				end
			end
		end
	end
end

ExpeditionView._update_nodes_mission_data = function (self, dt, t, input_service)
	local missions_expired = Managers.data_service.expedition:check_missions_expired()
	local should_refresh_missions = missions_expired and not self._fetching_missions

	if not should_refresh_missions then
		return
	end

	local function get_mission_node_id(mission)
		for flag, _ in pairs(mission.flags) do
			local start_i, end_i = string.find(flag, "exped%-node%-")

			if start_i == 1 and end_i + 1 < #flag then
				return string.sub(flag, end_i + 1)
			end
		end

		return nil
	end

	local function _replace_mission_data(node, missions_for_all_nodes)
		if node.id == "quickplay_button" then
			return
		end

		local missions = missions_for_all_nodes[node.id]

		if missions == nil or table.is_empty(missions) then
			Log.exception("ExpeditionView", "Was unable to retrieve new mission data for node %s", node.id)

			return
		end

		node.missions = missions
	end

	self._fetching_missions = true

	self._promise_container:cancel_on_destroy(Managers.data_service.expedition:fetch_expedition_missions():next(function (data)
		local temp_nodes = {}

		for _, new_mission in pairs(data) do
			local node_id = get_mission_node_id(new_mission)

			if not temp_nodes[node_id] then
				temp_nodes[node_id] = {}
			end

			table.insert(temp_nodes[node_id], new_mission)
		end

		for _, node in pairs(self._ordered_nodes) do
			_replace_mission_data(node, temp_nodes)
		end

		self._fetching_missions = false
	end))
end

ExpeditionView._update_node_unlock_queue = function (self, dt, t, input_service)
	for key, time_remaining in pairs(self._node_unlock_queue) do
		local new_time_remaining = time_remaining - dt

		if new_time_remaining <= 0 then
			self._node_unlock_queue[key] = nil
		else
			self._node_unlock_queue[key] = new_time_remaining
		end
	end
end

ExpeditionView.draw = function (self, dt, t, input_service, layer)
	if not self._entered then
		return
	end

	if self:_element("tutorial_popup") then
		self._stored_input = input_service
		input_service = input_service:null_service()
	end

	ExpeditionView.super.draw(self, dt, t, input_service, layer)

	if self._stored_input then
		input_service = self._stored_input
		self._stored_input = nil
	end
end

ExpeditionView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self.quickplay_button_widget then
		UIWidget.draw(self.quickplay_button_widget, ui_renderer)
	end

	ExpeditionView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ExpeditionView._handle_input = function (self, input_service, dt, t)
	if self._enable_input_delay > 0 then
		self._enable_input_delay = self._enable_input_delay - dt

		return
	end

	if self._node_enter_anim_finished ~= true then
		return
	end

	if InputDevice.gamepad_active then
		self:_handle_gamepad_input(input_service, dt, t)
	else
		local new_hovered_node = self:_get_hovered_node(dt, t, input_service)

		if new_hovered_node ~= nil and new_hovered_node ~= self._hovered_node then
			self:_play_sound(UISoundEvents.expedition_view_hover)
		end

		self._hovered_node = new_hovered_node

		if self._hovered_node then
			if self._hovered_node ~= self._last_hovered_node then
				if self._hovered_node.ui and self._hovered_node.ui.node_unit then
					Unit.flow_event(self._hovered_node.ui.node_unit, "hover")
				end

				if self._last_hovered_node ~= nil and self._last_hovered_node.ui and self._last_hovered_node.ui.node_unit then
					Unit.flow_event(self._last_hovered_node.ui.node_unit, "unhover")
				end

				self._last_hovered_node = self._hovered_node
			end
		elseif self._last_hovered_node ~= nil then
			if self._last_hovered_node and self._last_hovered_node.ui and self._last_hovered_node.ui.node_unit then
				Unit.flow_event(self._last_hovered_node.ui.node_unit, "unhover")
			end

			self._last_hovered_node = nil
		end

		if Mouse.pressed(Mouse.button_id("left")) and self._hovered_node then
			self:_select_node(self._hovered_node)
		end

		local selected_node = self.selected_node

		if selected_node and self._widgets_by_name.unlock_button.content.hotspot.on_pressed and selected_node.unlock_status == UNLOCK_STATUS.unlockable then
			self:_unlock_node(selected_node)
		end
	end
end

ExpeditionView._handle_gamepad_input = function (self, input_service, dt, t)
	local currently_selected_node = self._ordered_nodes and self._ordered_nodes[self._selected_node_index] or nil

	if not currently_selected_node then
		return
	end

	local virtual_axis = input_service:get("navigation_keys_virtual_axis")
	local controller_input = input_service:get("navigate_controller")
	local input = virtual_axis + controller_input

	input[2] = -input[2]

	local magnitude = Vector3.length(input)

	if magnitude > 1 then
		input = input / magnitude
		magnitude = 1
	end

	if self._gamepad_input_cooldown and self._gamepad_input_cooldown > 0 then
		self._gamepad_input_cooldown = self._gamepad_input_cooldown - dt

		return
	end

	local threshold = Settings.analog_input_threshold

	if threshold < magnitude then
		self._gamepad_input_cooldown = Settings.gamepad_input_cooldown

		local best_score = -math.huge
		local best_node_index = self._selected_node_index
		local current_selected_node = self._ordered_nodes[best_node_index]
		local current_selected_node_type = current_selected_node.type
		local current_selected_node_position = current_selected_node_type == "from_widget" and current_selected_node.ui.screen_position:unbox() or self:_get_node_screenspace(current_selected_node, self._world_spawner:camera())

		for i, node in ipairs(self._ordered_nodes) do
			if i ~= self._selected_node_index and node.ui then
				local node_type = node.type
				local node_position = node_type == "from_widget" and node.ui.screen_position:unbox() or self:_get_node_screenspace(node, self._world_spawner:camera())
				local direction_to_node = Vector3.normalize(node_position - current_selected_node_position)
				local dot = Vector3.dot(input, direction_to_node)
				local distance, score

				if dot > Settings.switch_dot_threshold then
					distance = Vector3.distance(current_selected_node_position, node_position)
					score = dot / distance
				else
					score = -math.huge
				end

				if best_score < score then
					best_score = score
					best_node_index = i
				end
			end
		end

		if best_node_index ~= self._selected_node_index then
			self._selected_node_index = best_node_index

			local selected_node = self._ordered_nodes[self._selected_node_index]

			self._hovered_node = selected_node

			self:_select_node(selected_node)
			self:_update_node_hover_state()
		end
	end
end

ExpeditionView.cb_on_unlock_node_input_pressed = function (self)
	if not InputDevice.gamepad_active then
		return
	end

	local selected_node = self.selected_node
	local hovered_node = self._hovered_node

	if hovered_node ~= selected_node then
		return
	end

	local can_unlock = selected_node and selected_node.unlock_status == UNLOCK_STATUS.unlockable

	if can_unlock then
		self:_unlock_node(selected_node)
	end
end

ExpeditionView._update_node_hover_state = function (self)
	if self._hovered_node then
		if self._hovered_node ~= self._last_hovered_node then
			if self._hovered_node.ui and self._hovered_node.ui.node_unit then
				Unit.flow_event(self._hovered_node.ui.node_unit, "hover")
			end

			if self._last_hovered_node ~= nil and self._last_hovered_node.ui and self._last_hovered_node.ui.node_unit then
				Unit.flow_event(self._last_hovered_node.ui.node_unit, "unhover")
			end

			self._last_hovered_node = self._hovered_node
		end
	elseif self._last_hovered_node ~= nil then
		if self._last_hovered_node.ui and self._last_hovered_node.ui.node_unit then
			Unit.flow_event(self._last_hovered_node.ui.node_unit, "unhover")
		end

		self._last_hovered_node = nil
	end
end

ExpeditionView._new_selection = function (self, selected_node, unselected_node)
	if selected_node.type == "from_widget" then
		local widget = selected_node.widget

		if widget then
			widget.content.hotspot.is_selected = true
		end
	else
		Unit.flow_event(selected_node.ui.node_unit, "select")
		Unit.set_scalar_for_materials(selected_node.ui.node_unit, "emissive_multiplier", Settings.node_selection_emissive_multiplier)
	end

	if unselected_node then
		if unselected_node.type == "from_widget" then
			local widget = unselected_node.widget

			if widget then
				widget.content.hotspot.is_selected = false
			end
		else
			Unit.flow_event(unselected_node.ui.node_unit, "unselect")
			Unit.set_scalar_for_materials(unselected_node.ui.node_unit, "emissive_multiplier", 1)
		end
	end

	if selected_node.unlock_status == UNLOCK_STATUS.locked then
		self:_play_sound(UISoundEvents.expedition_view_select_locked)
	elseif selected_node.unlock_status == UNLOCK_STATUS.unlocked then
		self:_play_sound(UISoundEvents.expedition_view_select_unlocked)
	elseif selected_node.unlock_status == UNLOCK_STATUS.unlockable then
		self:_play_sound(UISoundEvents.expedition_view_select_unlockable)
	end

	if selected_node.unlock_status == UNLOCK_STATUS.unlocked and not self._unlocked_sound_looping then
		self:_play_sound(UISoundEvents.expedition_view_select_unlocked_loop)

		self._unlocked_sound_looping = true
	elseif selected_node.unlock_status ~= UNLOCK_STATUS.unlocked then
		self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)

		self._unlocked_sound_looping = false
	end

	self._sidebar:show_mission_info(selected_node)
end

ExpeditionView._unlock_node = function (self, node)
	if node.unlock_status ~= UNLOCK_STATUS.unlockable or node.id == "quickplay_button" or self._node_unlock_queue[node.id] ~= nil then
		return
	end

	self:_play_sound(UISoundEvents.expedition_view_unlocking)
	set_material_animation_duration(node.ui.node_unit, "unlock_anim_duration", Settings.unlock_anim_duration)
	start_material_animation(node.ui.node_unit, "unlock_start_time")
	Unit.set_flow_variable(node.ui.node_unit, "unlock_delay", Settings.unlock_anim_duration - 0.1)
	Unit.flow_event(node.ui.node_unit, "unlock")

	self._node_unlock_queue[node.id] = Settings.unlock_anim_duration

	Managers.data_service.expedition:claim_track_node(node.id):next(function ()
		node.unlock_status = UNLOCK_STATUS.unlocked
	end):catch(function (error)
		local error_message = error or "Error calling claim_track_node."

		if type(error_message) == "table" then
			error_message = table.tostring(error_message, 5)
		end

		Log.exception("ExpeditionView", "Exception claiming node: ", error_message)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = error_message,
		})
	end)
end

ExpeditionView._select_node = function (self, node)
	local selected = self.selected_node
	local hovered = self._hovered_node

	if hovered and hovered ~= selected then
		self:_new_selection(hovered, selected)
	end

	if selected == hovered then
		self:_unlock_node(selected)
	end

	self.selected_node = self._hovered_node
	self._selected_node_index = self:_get_ordered_index_from_node(self.selected_node)
end

ExpeditionView._get_ordered_index_from_node = function (self, node)
	if not node or not node.id then
		return nil
	end

	if not self._ordered_nodes then
		return nil
	end

	local node_id = node.id

	for i = 1, #self._ordered_nodes do
		if self._ordered_nodes[i].id == node_id then
			return i
		end
	end
end

ExpeditionView._get_hovered_node = function (self, dt, t, input_service)
	local camera = self._world_spawner:camera()
	local nodes = self.nodes
	local cursor = input_service:get("cursor")

	for _, node in pairs(nodes) do
		local upper_left_corner, size = self:_get_node_screenspace(node, camera)

		if math.point_is_inside_2d_box(cursor, upper_left_corner, size) then
			return node
		end
	end

	return nil
end

ExpeditionView._update_nodes = function (self, dt, t, input_service)
	if t and not self._node_enter_anim_time and not self._node_enter_anim_finished then
		self._node_enter_anim_time = t + Settings.node_drop_delay + Settings.node_drop_frequency * #self._ordered_nodes
	end

	local nodes = self._ordered_nodes
	local world = self._world_spawner:world()
	local selected_node = self.selected_node
	local node_drop_index = 0

	for index, node in ipairs(nodes) do
		if node.type ~= "from_widget" then
			if not node.ui.root_position_boxed then
				node.ui.root_position_boxed = Vector3Box(self:_2d_to_3d_position_on_table(node.ui.x, node.ui.y))
			end

			if not node.ui.node_unit then
				node.ui.node_unit = World.spawn_unit_ex(world, Settings.node_unit_path, nil, node.ui.root_position_boxed:unbox() + Vector3.up() * Settings.node_height_offset, Quaternion.identity(), true, false)
				node.ui.drop_timer = 0.01

				local symbol_index = node.ui.display_name_atlas_index

				Unit.set_scalar_for_materials(node.ui.node_unit, "symbol_atlas_index", symbol_index)
				Unit.set_scalar_for_materials(node.ui.node_unit, "alpha", 0)

				if node.unlock_status ~= UNLOCK_STATUS.unlocked then
					Unit.flow_event(node.ui.node_unit, "lock")
				end

				if node.unlock_status == UNLOCK_STATUS.unlockable then
					node.unlockable_anim_timer = 0.01
				end

				if node.next then
					for _, next_node in pairs(node.next) do
						local pos_a = node.ui.root_position_boxed:unbox()
						local pos_b = self:_2d_to_3d_position_on_table(next_node.ui.x, next_node.ui.y)
						local direction = Quaternion.look(pos_b - pos_a)
						local distance = Vector3.distance(pos_a, pos_b)

						if not node.ui.dotted_line_units then
							node.ui.dotted_line_units = {}
						end

						local dotted_line_unit = World.spawn_unit_ex(world, Settings.hologram_dotted_line_unit_path, nil, node.ui.root_position_boxed:unbox() + Vector3.up() * Settings.node_height_offset, direction, true, false)

						Unit.set_local_scale(dotted_line_unit, 1, Vector3(1, distance * 20, 1))

						node.ui.dotted_line_units[#node.ui.dotted_line_units + 1] = dotted_line_unit
					end
				end
			end

			if node.ui.drop_timer and dt then
				node.ui.drop_timer = node.ui.drop_timer + dt

				local total_anim_time = Settings.node_drop_delay + Settings.node_drop_frequency * node_drop_index
				local drop_anim_progress = math.clamp(node.ui.drop_timer / total_anim_time, 0, 1)

				if total_anim_time <= node.ui.drop_timer then
					node.ui.drop_timer = nil

					Unit.flow_event(node.ui.node_unit, "drop")

					if node.ui.dotted_line_units then
						for _, dotted_line_unit in pairs(node.ui.dotted_line_units) do
							if node.unlock_status == UNLOCK_STATUS.unlocked then
								set_material_animation_duration(dotted_line_unit, "dotted_line_fill_anim_duration", Settings.dotted_line_anim_duration)
								start_material_animation(dotted_line_unit, "dotted_line_fill_start_time")
							else
								set_material_animation_duration(dotted_line_unit, "dotted_line_anim_duration", Settings.dotted_line_anim_duration)
								start_material_animation(dotted_line_unit, "dotted_line_start_time")
							end
						end
					end
				end

				local fade_in_progress = math.ease_in_exp(drop_anim_progress)

				Unit.set_scalar_for_materials(node.ui.node_unit, "alpha", fade_in_progress)
			end

			node_drop_index = node_drop_index + 1

			if node.unlockable_anim_timer and dt and not node.ui.drop_timer then
				node.unlockable_anim_timer = node.unlockable_anim_timer + dt

				local duration = Settings.unlockable_anim_duration
				local progress = node.unlockable_anim_timer / duration

				Unit.set_scalar_for_materials(node.ui.node_unit, "unlockable_anim_progress", progress)

				if duration <= node.unlockable_anim_timer then
					node.unlockable_anim_timer = nil
				end
			end

			if self._node_enter_anim_finished then
				if node.unlock_status == UNLOCK_STATUS.unlockable and node ~= selected_node then
					local pulse_speed = 5
					local pulse_anim_progress = 1 - (0.5 + math.sin(Application.time_since_launch() * pulse_speed) * 0.5)

					Unit.set_scalar_for_materials(node.ui.node_unit, "emissive_multiplier", 1 + 3 * pulse_anim_progress)
				end
			else
				local is_selected = node == selected_node
				local widget = node.widget

				if widget then
					local content = widget.content

					content.selected = is_selected
				end
			end
		end
	end

	if self._node_enter_anim_time and t > self._node_enter_anim_time and not self._node_enter_anim_finished then
		self._node_enter_anim_time = nil
		self._node_enter_anim_finished = true

		local preselected_node = self._ordered_nodes[self._selected_node_index]

		if preselected_node then
			self:_new_selection(self._ordered_nodes[self._selected_node_index])

			self._hovered_node = preselected_node
			self.selected_node = preselected_node

			self:_update_node_hover_state()
		end

		self._sidebar:show_widgets()

		self._widgets_by_name.mapwide_stats.visible = true
		self.quickplay_button_widget.visible = true
	end
end

ExpeditionView._2d_to_3d_position_on_table = function (self, normalized_x, normalized_y)
	local x = -Settings.table_width * 0.5 + Settings.table_width * normalized_x
	local y = -Settings.table_length * 0.5 + Settings.table_length * normalized_y
	local absolute_position = Vector3(x, y, 0)
	local pivot_pose = Unit.world_pose(self._table_spawn_pivot_unit, 1)
	local relative_pose = Matrix4x4.transform(pivot_pose, absolute_position)
	local raycast_success, hit_position = self:_ray_cast(self._world_spawner:world(), relative_pose + Vector3.up() * 2, relative_pose + Vector3.down() * 10, Settings.collision_filter)

	return hit_position
end

ExpeditionView._ray_cast = function (self, world, from, to, collision_filter)
	local physics_world = World.physics_world(world)
	local to_target = to - from
	local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter or "filter_detailed")

	return result, hit_position, hit_distance, normal
end

ExpeditionView._get_node_screenspace = function (self, node, camera)
	local mesh = Unit.mesh(node.ui.node_unit, Settings.node_selection_mesh)
	local pose, half_extents = Mesh.box(mesh)
	local position = Matrix4x4.translation(pose)
	local screen_position = Camera.world_to_screen(camera, position)
	local half_extents_to_screen_position = Camera.world_to_screen(camera, position + half_extents)
	local half_extents_screen_size = half_extents_to_screen_position - screen_position

	half_extents_screen_size.x = math.abs(half_extents_screen_size.x * (Settings.node_scale * (node.ui.node_scale_multiplier or 1)))
	half_extents_screen_size.y = math.abs(half_extents_screen_size.y * (Settings.node_scale * (node.ui.node_scale_multiplier or 1)))

	local screen_size = {
		math.abs(half_extents_screen_size.x * 2),
		math.abs(half_extents_screen_size.y * 2),
	}
	local screen_upper_left_corner = Vector2(screen_position.x - screen_size[1] / 2, screen_position.y - screen_size[2] / 2)

	return screen_upper_left_corner, screen_size
end

local _required_level_loc_table = {
	required_level = -1,
}

ExpeditionView._update_can_start_mission = function (self)
	local node = self.selected_node

	if not node then
		self:_set_can_start_mission(false, "warning", Localize("loc_no_mission_selected"))

		return
	end

	local missions = node.missions

	if not missions and node.id ~= "quickplay_button" then
		self:_set_can_start_mission(false, "warning", Localize("loc_missing_missions_data"))

		return
	end

	local difficulty = self._page_settings[self._page_index]
	local mission = self:_find_mission_of_difficulty(missions, difficulty.filter.challenge, difficulty.filter.resistance)

	if not mission and node.id ~= "quickplay_button" then
		self:_set_can_start_mission(false, "warning", Localize("loc_missing_mission_data_for_difficulty"))

		return
	end

	if mission and not mission.id and node.id ~= "quickplay_button" then
		self:_set_can_start_mission(false, "warning", Localize("loc_missing_mission_id"))

		return
	end

	local required_level = mission and mission.requiredLevel or 0

	if required_level > self._player_level then
		_required_level_loc_table.required_level = required_level

		self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_view_required_level", true, _required_level_loc_table))

		return
	end

	local party_manager = self._party_manager

	if party_manager:is_in_matchmaking() then
		self:_set_can_start_mission(false, "warning", Localize("loc_hud_presence_matchmaking"))

		return
	end

	if not party_manager:are_all_members_in_hub() then
		self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_team_mate_not_available"))

		return
	end

	if self.current_match_visibility == MATCH_VISIBILITY.private then
		if node.id == "quickplay_button" then
			self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_locked_issue"))

			return
		end

		if party_manager:num_other_members() < 1 then
			self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_cannot_private_match"))

			return
		end
	end

	if self.selected_node and self.selected_node.unlock_status ~= UNLOCK_STATUS.unlocked and node.id ~= "quickplay_button" then
		self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_locked_issue"))

		return
	end

	self:_set_can_start_mission(true, "info", nil)
end

ExpeditionView._set_can_start_mission = function (self, can_start_mission, info_level, info_text)
	self._can_start_mission = can_start_mission
	self._info_level = info_level
	self._info_text = info_text
end

ExpeditionView.get_can_start_mission = function (self)
	return self._can_start_mission, self._info_level, self._info_text
end

ExpeditionView.event_register_table_spawn_pivot = function (self, pivot_unit)
	local params = self._definitions.background_world_params

	self:_unregister_event(params.table_pivot_event)

	self._table_spawn_pivot_unit = pivot_unit
end

ExpeditionView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit
end

ExpeditionView.event_register_camera = function (self, camera_unit)
	local params = self._definitions.background_world_params

	self:_unregister_event(params.register_camera_event)

	local viewport_name = params.viewport_name or self.view_name .. "_viewport"
	local viewport_type = params.viewport_type or "default"
	local viewport_layer = params.viewport_layer or 1
	local shading_environment = params.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
end

ExpeditionView.cb_on_options_pressed = function (self)
	if self.block_legend_input then
		return
	end

	self.block_legend_input = true

	self._options:present()
end

ExpeditionView.cb_switch_tab = function (self)
	self._sidebar:switch_tab()
end

ExpeditionView.cb_toggle_private_match = function (self)
	local match_visibility = self.current_match_visibility

	if match_visibility == MATCH_VISIBILITY.private then
		match_visibility = MATCH_VISIBILITY.public
	elseif match_visibility == MATCH_VISIBILITY.public then
		match_visibility = MATCH_VISIBILITY.private
	else
		return
	end

	self.current_match_visibility = match_visibility

	self:set_saved_match_visibility(match_visibility)
	self._sidebar:update_match_visibility_text(match_visibility)

	local quickplay_widget = self.quickplay_button_widget

	if quickplay_widget then
		local content = quickplay_widget.content

		content.is_locked = not self.quickplay_unlocked or match_visibility ~= MATCH_VISIBILITY.public
	end
end

ExpeditionView.cb_show_tutorial = function (self)
	if self.block_legend_input then
		return
	end

	self.block_legend_input = true
	self._present_tutorial_popup = true
end

ExpeditionView._show_tutorial_popup = function (self)
	self._present_tutorial_popup = nil

	local context = {
		close_callback = function ()
			self._remove_tutorial_popup_next_frame = true
			self._tutorial_popup = nil
			self.block_legend_input = false
		end,
		popup_pages = Settings.popup_pages,
	}

	self._tutorial_popup = self:_add_element(ViewElementTutorialPopup, "tutorial_popup", 90, context, "tutorial_popup_pivot")
end

ExpeditionView.set_saved_match_visibility = function (self, match_visibility)
	local save_data = self.save_data

	save_data.page_index = self._page_index + 1
	save_data.private_match = match_visibility == MATCH_VISIBILITY.private

	Managers.save:queue_save()
end

ExpeditionView.get_selected_mission_data = function (self, node_override)
	local node = node_override or self.selected_node

	if not node then
		return nil
	end

	local missions = node and node.missions
	local difficulty = self._page_settings and self._page_index and self._page_settings[self._page_index]
	local challenge = difficulty and difficulty.filter and difficulty.filter.challenge
	local resistance = difficulty and difficulty.filter and difficulty.filter.resistance

	return self:_find_mission_of_difficulty(missions, challenge, resistance)
end

ExpeditionView._find_mission_of_difficulty = function (self, missions, challenge_filter, resistance_filter)
	if missions and challenge_filter and resistance_filter then
		for i = 1, #missions do
			local mission = missions[i]

			if mission and mission.challenge == challenge_filter and mission.resistance == resistance_filter then
				return mission
			end
		end
	end

	return nil
end

ExpeditionView.cb_start_selected_mission = function (self)
	if not self._can_start_mission then
		Log.exception("ExpeditionView", "Unable to start mission because: %s", self._info_text or "<unknown>")

		return
	end

	local preferred_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()
	local private_match = self.current_match_visibility == MATCH_VISIBILITY.private

	self:_play_sound(UISoundEvents.expedition_menu_start)
	Managers.event:trigger("event_story_mission_started")

	local node_id = self.selected_node and self.selected_node.id or nil
	local is_quickplay = node_id == "quickplay_button"

	if is_quickplay then
		local page_settings = self._page_settings[self._page_index]
		local qp_settings = page_settings.qp

		qp_settings = table.clone(qp_settings)
		qp_settings.category = {
			"expedition",
		}

		local qp_string = QPCode.encode(qp_settings)

		self._party_manager:wanted_mission_selected(qp_string, self.current_match_visibility == MATCH_VISIBILITY.private, preferred_mission_region)
		self:cb_on_back_pressed()
	else
		local mission = self:get_selected_mission_data()
		local mission_id = mission and mission.id or nil

		self._party_manager:wanted_mission_selected(mission_id, private_match, preferred_mission_region)
		self:cb_on_back_pressed()
	end
end

ExpeditionView.cb_on_back_pressed = function (self)
	self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)
	Managers.ui:close_view(self.view_name)
end

ExpeditionView._create_page_settings = function (self, difficulty_progress_data)
	local pages = {}
	local current_difficulty = difficulty_progress_data.current

	for i, difficulty in ipairs(DangerSettings) do
		local is_uprising = difficulty.name == "uprising"

		if not is_uprising then
			local is_auric = difficulty.name == "auric"

			table.insert(pages, {
				name = difficulty.name,
				loc_name = difficulty.display_name,
				ui_theme = is_auric and "auric" or "default",
				is_unlocked = self:_difficulty_is_unlocked(difficulty, current_difficulty),
				filter = {
					challenge = difficulty.challenge,
					resistance = difficulty.resistance,
					category = {
						"expedition",
					},
				},
				qp = {
					challenge = difficulty.challenge,
					resistance = difficulty.resistance,
				},
				color = difficulty.color,
				icon = difficulty.icon,
			})
		end
	end

	return pages
end

ExpeditionView.get_threat_level_progress = function (self)
	local data = self._difficulty_progress_data

	if not data then
		return nil
	end

	local current_difficulty = data.current
	local next_difficulty = data.next
	local current_progress = next_difficulty and next_difficulty.progress or 0
	local target_progress = next_difficulty and next_difficulty.target or 0
	local current_difficulty_progress

	current_difficulty_progress = target_progress == 0 and 1 or math.clamp(current_progress / target_progress, 0, 1)

	return {
		progress = current_difficulty_progress,
		current = current_progress,
		target = target_progress,
		current_difficulty = current_difficulty and current_difficulty.name or "n/a",
		next_difficulty = next_difficulty and next_difficulty.name or "n/a",
	}
end

ExpeditionView.get_difficulty_settings = function (self)
	return self._page_settings
end

ExpeditionView._difficulty_is_unlocked = function (self, evaluated_difficulty, current_difficulty)
	local challenge = evaluated_difficulty.challenge
	local resistance = evaluated_difficulty.resistance

	return challenge <= current_difficulty.challenge and resistance <= current_difficulty.resistance
end

ExpeditionView._ignore_player_journey = function (self)
	return false
end

ExpeditionView.request_next_page = function (self)
	self:request_page_at(self._page_index + 1)
end

ExpeditionView.request_prev_page = function (self)
	self:request_page_at(self._page_index - 1)
end

ExpeditionView.request_page_at = function (self, index)
	if index < 1 or index > #self._page_settings or not self._page_settings[index] then
		return
	end

	if self._page_settings[index].is_unlocked or self:_ignore_player_journey() then
		self._page_index = index
	end
end

ExpeditionView.get_current_selected_difficulty = function (self)
	return self._page_index
end

ExpeditionView.get_current_selected_difficulty_name = function (self)
	return self._page_settings[self._page_index].name
end

ExpeditionView.node_enter_anim_finished = function (self)
	return self._node_enter_anim_finished
end

ExpeditionView._setup_quickplay_button = function (self)
	local bonus_text
	local bonus_low, bonus_high = self.quickplay_bonus_range[1], self.quickplay_bonus_range[2]

	if bonus_low and bonus_high then
		local internal_bonus_text = bonus_low == bonus_high and tostring(bonus_low) or string.format("+%s%% - %s%%", bonus_low, bonus_high)

		bonus_text = Localize("loc_mission_board_card_bonus_text", true, {
			bonus_text = internal_bonus_text,
		})
	end

	local is_unlocked = self.quickplay_unlocked and self.current_match_visibility == MATCH_VISIBILITY.public
	local widget_id = "quickplay_button"
	local optional_blueprint_settings = "quickplay_tile"
	local optional_creation_context = {
		icon = "content/ui/textures/icons/mission_types_pj/mission_type_quick",
		is_locked = not is_unlocked,
		sub_header_text = bonus_text,
		header_text = Localize("loc_mission_board_quickplay_header"),
	}
	local old_widget = self._widgets_by_name[widget_id]

	if old_widget ~= nil then
		UIWidget.destroy(self._ui_renderer, old_widget)
		self:_unregister_widget_name(old_widget.name)
	end

	local widget = self:_widget_from_blueprint(widget_id, optional_blueprint_settings, nil, optional_creation_context)

	self.quickplay_button_widget = widget

	local node = self:_create_node_from_widget(widget, widget_id)
	local callback_function = callback(self, "cb_widget_node_pressed", node)

	widget.content.hotspot.pressed_callback = callback_function
	widget.visible = false
end

ExpeditionView._widget_from_blueprint = function (self, widget_id, blueprint_setting_name, mission_data, creation_context, ...)
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
	local widget = self:_create_widget(widget_id, definition)

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

ExpeditionView.on_exit = function (self)
	self:_despawn_nodes()
	self._sidebar:delete()
	self._world_spawner:delete()
	ExpeditionView.super.on_exit(self)
end

ExpeditionView._despawn_nodes = function (self)
	local world = self._world_spawner and self._world_spawner:world()
	local nodes = self.nodes

	for _, node in pairs(nodes) do
		World.destroy_unit(world, node.ui.node_unit)

		if node.ui.dotted_line_units then
			for _, dotted_line_unit in pairs(node.ui.dotted_line_units) do
				World.destroy_unit(world, dotted_line_unit)
			end
		end
	end

	self.nodes = nil
end

ExpeditionView.destroy = function (self)
	self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)

	local save_data = self.save_data

	if save_data then
		local match_visibility = self.current_match_visibility

		save_data.private_match = match_visibility == MATCH_VISIBILITY.private
		save_data.page_index = self._page_index + 1

		Managers.save:queue_save()
	end

	self._promise_container:delete()
	ExpeditionView.super.destroy(self)
end

ExpeditionView.cb_do_nothing = function (self)
	return
end

ExpeditionView.cb_widget_node_pressed = function (self, node)
	if not node or not node.widget then
		return
	end

	self._hovered_node = node

	self:_select_node(node)
end

return ExpeditionView
