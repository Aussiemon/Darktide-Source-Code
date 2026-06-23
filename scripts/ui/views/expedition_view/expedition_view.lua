-- chunkname: @scripts/ui/views/expedition_view/expedition_view.lua

local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local ExpeditionService = require("scripts/managers/data_service/services/expedition_service")
local ExpeditionViewDefinitions = require("scripts/ui/views/expedition_view/expedition_view_definitions")
local ExpeditionViewOptionsElement = require("scripts/ui/views/expedition_view/expedition_view_options_element")
local ExpeditionViewSidebar = require("scripts/ui/views/expedition_view/expedition_view_sidebar")
local InputDevice = require("scripts/managers/input/input_device")
local InputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local QPCode = require("scripts/utilities/qp_code")
local Settings = require("scripts/ui/views/expedition_view/expedition_view_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementTutorialPopup = require("scripts/ui/view_elements/view_element_tutorial_popup/view_element_tutorial_popup")
local MATCH_VISIBILITY = ExpeditionViewDefinitions.MATCH_VISIBILITY
local UNLOCK_STATUS = ExpeditionService.UNLOCK_STATUS
local UNLOCK_TYPE = ExpeditionService.UNLOCK_TYPE
local ExpeditionView = class("ExpeditionView", "BaseView")

ExpeditionView.init = function (self, settings, context)
	self._expedition_service = Managers.data_service.expedition
	self.save_data = self._expedition_service:get_character_mission_board_save_data()
	self._current_match_visibility = self:_get_saved_match_visibility()
	self._page_index = self.save_data.page_index and math.clamp(self.save_data.page_index - 1, 1, #DangerSettings - 1) or 1
	self._party_manager = Managers.party_immaterium
	self._player_level = self:_player():profile().current_level
	self._enable_input_delay = Settings.enable_input_delay
	self._node_unlock_queue = {}
	self._nodes = nil
	self._selectables = nil
	self._selection_index = nil
	self._previous_selection_index = nil
	self._hovered = nil
	self._previous_hovered = nil
	self._promise_container = nil
	self._quickplay_unlocked = self:_is_quickplay_unlocked()
	self._block_input = nil

	self:_fetch_data()
	ExpeditionView.super.init(self, ExpeditionViewDefinitions, settings, context)
end

ExpeditionView._get_saved_match_visibility = function (self)
	local save_data = self.save_data
	local match_visibility

	if save_data.private_match == false then
		match_visibility = MATCH_VISIBILITY.public
	elseif save_data.private_match == true then
		match_visibility = MATCH_VISIBILITY.private
	end

	return match_visibility
end

ExpeditionView._is_quickplay_unlocked = function (self)
	local progression_data = self._expedition_service:get_game_modes_progression_data()

	return progression_data and progression_data.quickplay and progression_data.quickplay.unlocked or false
end

ExpeditionView._fetch_data = function (self)
	if self._promise_container then
		self._promise_container:destroy()

		self._promise_container = nil
	end

	self._promise_container = PromiseContainer:new()

	self:_despawn_nodes()

	if self._sidebar then
		self._sidebar:hide_widgets()
		self._sidebar:remove_mission_info()
	end

	self._update_node_presentations = true

	self:_set_has_fetched(false)

	local player = self:_player()
	local account_id = player:account_id()
	local character_id = player:character_id()
	local promises = {
		Managers.data_service.region_latency:fetch_regions_latency(),
		self._expedition_service:fetch_nodes(),
		self._expedition_service:get_quickplay_bonus(),
		self._expedition_service:fetch_player_journey_data(account_id, character_id, false),
	}

	self._promise_container:cancel_on_destroy(Promise.all(unpack(promises))):next(function (data)
		self._regions_latency = data[1]
		self._personal_stats = data[2] and data[2].personal_stats
		self._nodes = data[2] and data[2].nodes_by_id
		self._selectables = data[2] and data[2].nodes_by_index
		self._quickplay_bonus_range = data[3]

		if not self._expedition_service:has_cached_progression_data() then
			return Promise.rejected("Progression data was unavailable.")
		end

		self._difficulty_progress_data = self._expedition_service:get_difficulty_progression_data()
		self._page_settings = self:_create_page_settings(self._difficulty_progress_data)

		local automatic_node_unlock_promises = {}

		for _, node in pairs(self._nodes) do
			local node_id = node.id
			local unlock_status = node.unlock_status

			if unlock_status == UNLOCK_STATUS.unlockable and self:_is_unlocked_by_default(node) then
				automatic_node_unlock_promises[#automatic_node_unlock_promises + 1] = self._expedition_service:claim_track_node(node_id):next(function ()
					node.unlock_status = UNLOCK_STATUS.unlocked
				end)
			end
		end

		return self._promise_container:cancel_on_destroy(Promise.all(unpack(automatic_node_unlock_promises))):next(function ()
			self:_set_has_fetched(true)
		end):catch(function (error)
			return Promise.rejected(error)
		end)
	end):catch(function (error)
		if not error or type(error) ~= "string" then
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
	end)
end

ExpeditionView._is_unlocked_by_default = function (self, node)
	local to_unlock_data = node.to_unlock

	for i = 1, #to_unlock_data do
		local requirement_package = to_unlock_data[i]

		for j = 1, #requirement_package do
			local requirement = requirement_package[j]
			local requirement_type = requirement.type

			if requirement_type == UNLOCK_TYPE.unlocked_by_default then
				return true
			end
		end
	end

	return false
end

ExpeditionView.on_enter = function (self)
	ExpeditionView.super.on_enter(self)
	self:_setup_background_world(self._definitions.background_world_params)

	self._options = ExpeditionViewOptionsElement:new(self)

	self:_setup_input_legend(self._definitions.input_legend_params)
	self:_show_tutorial_popup()

	self._widgets_by_name.play_button.visible = false
end

ExpeditionView._setup_node_presentations = function (self)
	local quickplay_button_node = self._sidebar:quickplay_button_node()

	self._selectables[#self._selectables + 1] = quickplay_button_node

	local nodes = self._selectables
	local world = self._world_spawner:world()

	for _, node in pairs(nodes) do
		if not self:_is_quickplay_button(node) then
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
		end
	end

	self._selection_index = self:_get_quickplay_button_index()
	self._update_node_presentations = false

	self:_update_nodes()
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
		self:_start_material_animation(terrain_unit, "start_time_uv_offset")
		self:_start_material_animation(terrain_unit, "start_time_height")
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

ExpeditionView.update = function (self, dt, t, input_service)
	if self:get_has_fetched() and self._entered then
		if self._initialized then
			if self._expedition_service:has_track_expired() then
				self:_fetch_data()
			end
		else
			self._sidebar = ExpeditionViewSidebar:new(self, {
				widgets_by_name = self._widgets_by_name,
				personal_stats = self._personal_stats,
				quickplay_bonus_range = self._quickplay_bonus_range,
				ui_scenegraph = self._ui_scenegraph,
				quickplay_unlocked = self._quickplay_unlocked,
			})
			self._initialized = true
		end
	end

	self:_update_tutorial(dt, t, input_service)

	if self._tutorial_popup then
		input_service = input_service:null_service()
	end

	local can_update_nodes = self:get_has_fetched()

	if self._update_node_presentations and self:get_has_fetched() and self._entered then
		self:_setup_node_presentations()
	end

	if can_update_nodes then
		self:_update_nodes(dt, t, input_service)
		self:_update_nodes_mission_data(dt, t, input_service)
	end

	self:_update_play_button()
	self:_update_can_start_mission()

	if self._sidebar then
		self._sidebar:update(dt, t, input_service)
	end

	ExpeditionView.super.update(self, dt, t, input_service)
end

ExpeditionView._update_tutorial = function (self, dt, t, input_service)
	if self._show_tutorial_on_next_update and not self._tutorial_popup then
		self:_show_tutorial_popup()
	elseif self._remove_tutorial_popup_next_update then
		if self:_element("tutorial_popup") then
			self:_remove_element("tutorial_popup")
		end

		self._remove_tutorial_popup_next_update = nil
	elseif self._tutorial_popup then
		self._elements.tutorial_popup:update(dt, t, input_service)
	end

	if self._tutorial_popup then
		self._stored_input = input_service
	end
end

ExpeditionView._show_tutorial_popup = function (self)
	local save_manager = Managers.save
	local save_data = save_manager:account_data()
	local show_tutorial_popup = self._show_tutorial_on_next_update or not save_data or not save_data.expedition_tutorial_popup_shown

	if not show_tutorial_popup then
		return
	end

	self._show_tutorial_on_next_update = nil

	local context = {
		close_callback = function ()
			self._remove_tutorial_popup_next_update = true

			if save_data and not save_data.expedition_tutorial_popup_shown then
				save_data.expedition_tutorial_popup_shown = true

				save_manager:queue_save()
			end

			self._tutorial_popup = nil

			self:_set_block_input(false)
		end,
		popup_pages = Settings.popup_pages,
	}

	self._tutorial_popup = self:_add_element(ViewElementTutorialPopup, "tutorial_popup", 90, context, "tutorial_popup_pivot")
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

ExpeditionView._update_nodes = function (self, dt, t, input_service)
	if t and not self._node_enter_anim_time and not self._node_enter_anim_finished then
		self._node_enter_anim_time = t + Settings.node_drop_delay + Settings.node_drop_frequency * #self._selectables
	end

	local nodes = self._selectables
	local selected_node = self:get_selection()
	local node_drop_index = 0

	for _, node in pairs(nodes) do
		if not self:_is_quickplay_button(node) then
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
								self:_set_material_animation_duration(dotted_line_unit, "dotted_line_fill_anim_duration", Settings.dotted_line_anim_duration)
								self:_start_material_animation(dotted_line_unit, "dotted_line_fill_start_time")
							else
								self:_set_material_animation_duration(dotted_line_unit, "dotted_line_anim_duration", Settings.dotted_line_anim_duration)
								self:_start_material_animation(dotted_line_unit, "dotted_line_start_time")
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

		if self._node_enter_anim_time and t > self._node_enter_anim_time and not self._node_enter_anim_finished then
			self._node_enter_anim_time = nil
			self._node_enter_anim_finished = true

			self:_preselect_quickplay_button()

			if self._sidebar then
				self._sidebar:show_widgets()
			end
		end
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

ExpeditionView._set_material_animation_duration = function (self, unit, name, duration)
	Unit.set_scalar_for_materials(unit, name, duration)
end

ExpeditionView._start_material_animation = function (self, unit, name)
	local world = Unit.world(unit)
	local start_time = World.render_time(world) + 0.01

	Unit.set_scalar_for_materials(unit, name, start_time)
end

ExpeditionView._preselect_quickplay_button = function (self)
	local quickplay_button = self:_get_quickplay_button()

	self:_set_hovered(nil)
	self:_set_selection(nil)
	self:_set_hovered(quickplay_button)
	self:_set_selection(quickplay_button)
end

ExpeditionView._update_nodes_mission_data = function (self, dt, t, input_service)
	self:_update_node_unlock_queue(dt, t, input_service)

	local missions_expired = self._expedition_service:check_missions_expired()
	local should_refresh_missions = missions_expired and self._has_fetched and not self._fetching_missions

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
		local missions = missions_for_all_nodes[node.id]

		if missions == nil or table.is_empty(missions) then
			Log.exception("ExpeditionView", "Was unable to retrieve new mission data for node %s", node.id)

			return
		end

		node.missions = missions
	end

	local loading_widget = self._widgets_by_name and self._widgets_by_name.loading

	if loading_widget then
		loading_widget.content.visible = true
	end

	self._fetching_missions = true

	self._promise_container:cancel_on_destroy(self._expedition_service:fetch_expedition_missions():next(function (data)
		local temp_nodes = {}

		for _, new_mission in pairs(data) do
			local node_id = get_mission_node_id(new_mission)

			if not temp_nodes[node_id] then
				temp_nodes[node_id] = {}
			end

			table.insert(temp_nodes[node_id], new_mission)
		end

		for _, node in pairs(self._nodes) do
			_replace_mission_data(node, temp_nodes)
		end

		self._fetching_missions = false

		local loading_widget = self._widgets_by_name and self._widgets_by_name.loading

		if loading_widget then
			loading_widget.content.visible = false
		end
	end))
end

ExpeditionView.draw = function (self, dt, t, input_service, layer)
	if not self._entered then
		return
	end

	if self:_element("tutorial_popup") then
		input_service = input_service:null_service()
	end

	ExpeditionView.super.draw(self, dt, t, input_service, layer)
end

ExpeditionView._draw_elements = function (self, dt, t, ui_renderer, render_settings, input_service)
	local elements_array = self._elements_array

	if elements_array then
		for i = 1, #elements_array do
			local element = elements_array[i]

			if element then
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

ExpeditionView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._sidebar then
		self._sidebar:draw_widgets(dt, t, input_service, ui_renderer, render_settings)
	end

	ExpeditionView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ExpeditionView._handle_input = function (self, input_service, dt, t)
	if not self:get_has_fetched() and self._initialized then
		return
	end

	if self._enable_input_delay > 0 then
		self._enable_input_delay = self._enable_input_delay - dt

		return
	end

	if self._node_enter_anim_finished ~= true or self:_get_block_input() then
		return
	end

	if InputDevice.gamepad_active then
		self:_handle_gamepad_input(input_service, dt, t)
	else
		self:_handle_mouse_input(input_service, dt, t)
	end
end

ExpeditionView._handle_gamepad_input = function (self, input_service, dt, t)
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
		local current_selection = self:get_selection()
		local current_selection_position = self:_is_quickplay_button(current_selection) and current_selection.ui.screen_position:unbox() or self:_get_node_screenspace(current_selection, self._world_spawner:camera())
		local current_selection_index = self:_get_selection_index()
		local best_selection_index = current_selection_index

		for i, node in ipairs(self._selectables) do
			if node ~= current_selection and node.ui then
				local node_position = self:_is_quickplay_button(node) and node.ui.screen_position:unbox() or self:_get_node_screenspace(node, self._world_spawner:camera())
				local direction_to_node = Vector3.normalize(node_position - current_selection_position)
				local dot = Vector3.dot(input, direction_to_node)
				local distance, score

				if dot > Settings.switch_dot_threshold then
					distance = Vector3.distance(current_selection_position, node_position)
					score = dot / distance
				else
					score = -math.huge
				end

				if best_score < score then
					best_score = score
					best_selection_index = i
				end
			end
		end

		if best_selection_index ~= current_selection_index then
			self:_set_selection_by_index(best_selection_index)

			local selection = self:get_selection()

			self:_set_hovered(selection)
		end
	end
end

ExpeditionView._handle_mouse_input = function (self, input_service, dt, t)
	local hovered = self:_determine_mouseover_node(dt, t, input_service)

	self:_set_hovered(hovered)

	if Mouse.pressed(Mouse.button_id("left")) and hovered then
		local selection = hovered

		self:_set_selection(selection)
	end

	local selected_node = self:get_selection()

	if selected_node and self._widgets_by_name.unlock_button.content.hotspot.on_pressed and selected_node.unlock_status == UNLOCK_STATUS.unlockable then
		self:_unlock_node_if_eligible(selected_node)
	end
end

ExpeditionView._determine_mouseover_node = function (self, dt, t, input_service)
	local camera = self._world_spawner:camera()
	local nodes = self._nodes
	local cursor = input_service:get("cursor")

	for _, node in pairs(nodes) do
		local upper_left_corner, size = self:_get_node_screenspace(node, camera)

		if math.point_is_inside_2d_box(cursor, upper_left_corner, size) then
			return node
		end
	end

	return nil
end

ExpeditionView._update_play_button = function (self)
	local selected_node = self:get_selection()
	local widgets_by_name = self._widgets_by_name
	local is_node_unlockable = selected_node and selected_node.unlock_status == UNLOCK_STATUS.unlockable
	local enter_anim_finished = self._node_enter_anim_finished

	widgets_by_name.unlock_button.content.visible = is_node_unlockable and enter_anim_finished
	widgets_by_name.play_button.content.visible = not is_node_unlockable and enter_anim_finished
	widgets_by_name.play_button_legend.content.visible = not is_node_unlockable and enter_anim_finished
end

ExpeditionView._unlock_node_if_eligible = function (self, node)
	if node == nil or node.unlock_status ~= UNLOCK_STATUS.unlockable or self:_is_quickplay_button(node) or self._node_unlock_queue[node.id] ~= nil then
		return
	end

	self:_play_sound(UISoundEvents.expedition_view_unlocking)
	self:_set_material_animation_duration(node.ui.node_unit, "unlock_anim_duration", Settings.unlock_anim_duration)
	self:_start_material_animation(node.ui.node_unit, "unlock_start_time")
	Unit.set_flow_variable(node.ui.node_unit, "unlock_delay", Settings.unlock_anim_duration - 0.1)
	Unit.flow_event(node.ui.node_unit, "unlock")

	self._node_unlock_queue[node.id] = Settings.unlock_anim_duration

	self._expedition_service:claim_track_node(node.id):next(function ()
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
	local node = self:get_selection()

	if not node then
		self:_set_can_start_mission(false, "warning", Localize("loc_no_mission_selected"))

		return
	end

	local missions = node.missions
	local not_quickplay_button = not self:_is_quickplay_button(node)

	if not missions and not_quickplay_button then
		self:_set_can_start_mission(false, "warning", Localize("loc_missing_missions_data"))

		return
	end

	local difficulty = self._page_settings[self._page_index]
	local mission = self:_find_mission_of_difficulty(missions, difficulty.filter.challenge, difficulty.filter.resistance)

	if not mission and not_quickplay_button then
		self:_set_can_start_mission(false, "warning", Localize("loc_missing_mission_data_for_difficulty"))

		return
	end

	if mission and not mission.id and not_quickplay_button then
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

	if self._current_match_visibility == MATCH_VISIBILITY.private then
		if self:_is_quickplay_button(node) then
			self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_locked_issue"))

			return
		end

		if party_manager:num_other_members() < 1 then
			self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_cannot_private_match"))

			return
		end
	end

	local selected = self:get_selection()

	if selected and selected.unlock_status ~= UNLOCK_STATUS.unlocked and not_quickplay_button then
		self:_set_can_start_mission(false, "warning", Localize("loc_mission_board_locked_issue"))

		return
	end

	self:_set_can_start_mission(true, "info", nil)
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
	if self:_get_block_input() then
		return
	end

	self:_set_block_input(true)
	self._options:present(self._regions_latency, callback(self, "cb_close_options_element"))
end

ExpeditionView.cb_switch_tab = function (self)
	if self._sidebar then
		self._sidebar:switch_tab()
	end
end

ExpeditionView.cb_widget_node_pressed = function (self, node)
	if not node or not node.widget then
		return
	end

	self:_set_selection(node)
end

ExpeditionView.cb_toggle_private_match = function (self)
	local match_visibility = self._current_match_visibility

	if match_visibility == MATCH_VISIBILITY.private then
		match_visibility = MATCH_VISIBILITY.public
	elseif match_visibility == MATCH_VISIBILITY.public then
		match_visibility = MATCH_VISIBILITY.private
	else
		return
	end

	self._current_match_visibility = match_visibility

	self:set_saved_match_visibility(match_visibility)

	if self._sidebar then
		self._sidebar:update_match_visibility_text(match_visibility)
		self._sidebar:update_quickplay_widget_locking()
	end

	self:_set_quickplay_button_state(self._current_match_visibility == MATCH_VISIBILITY.private)
end

ExpeditionView.cb_show_tutorial = function (self)
	if self:_get_block_input() then
		return
	end

	self:_set_block_input(true)

	self._show_tutorial_on_next_update = true
end

ExpeditionView._set_quickplay_button_state = function (self, is_locked)
	local quickplay_button_index = self:_get_quickplay_button_index()
	local quickplay_button = self._selectables[quickplay_button_index]

	if quickplay_button then
		local content = quickplay_button.widget and quickplay_button.widget.content
		local style = quickplay_button.widget and quickplay_button.widget.style

		content.is_locked = is_locked

		local icon_style = style and style.static_button_icon

		if icon_style then
			icon_style.is_selected = true
		end
	end
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
	if self:_get_block_input() then
		return
	end

	if not self._can_start_mission then
		Log.exception("ExpeditionView", "Unable to start mission because: %s", self._info_text or "<unknown>")

		return
	end

	local preferred_mission_region = Managers.data_service.region_latency:get_prefered_mission_region()
	local private_match = self._current_match_visibility == MATCH_VISIBILITY.private

	self:_play_sound(UISoundEvents.expedition_menu_start)
	Managers.event:trigger("event_story_mission_started")

	local node = self:get_selection()
	local is_quickplay = self:_is_quickplay_button(node)

	if is_quickplay then
		local page_settings = self._page_settings[self._page_index]
		local qp_settings = page_settings.qp

		qp_settings = table.clone(qp_settings)
		qp_settings.category = {
			"expedition",
		}

		local qp_string = QPCode.encode(qp_settings)

		self._party_manager:wanted_mission_selected(qp_string, self._current_match_visibility == MATCH_VISIBILITY.private, preferred_mission_region)
		self:cb_on_back_pressed()
	else
		local mission = self:get_selected_mission_data()
		local mission_id = mission and mission.id or nil

		self._party_manager:wanted_mission_selected(mission_id, private_match, preferred_mission_region)
		self:cb_on_back_pressed()
	end
end

ExpeditionView.cb_on_unlock_node_input_pressed = function (self)
	if not InputDevice.gamepad_active then
		return
	end

	local selected_node = self:get_selection()
	local hovered_node = self:_get_hovered()

	if hovered_node ~= selected_node then
		return
	end

	self:_unlock_node_if_eligible(selected_node)
end

ExpeditionView.cb_on_back_pressed = function (self)
	self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)
	Managers.ui:close_view(self.view_name)
end

ExpeditionView.cb_close_options_element = function (self)
	if self:_element("options_element") then
		self:_remove_element("options_element")
	end

	self:_set_block_input(false)

	local options = self._options

	if options then
		options:close_options_element()
	end
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

ExpeditionView._is_quickplay_button = function (self, selectable)
	return selectable and selectable.id == "quickplay_button"
end

ExpeditionView.sidebar_create_widget = function (self, widget_id, definition)
	return self:_create_widget(widget_id, definition)
end

ExpeditionView.sidebar_add_element = function (self, class, reference_name, layer, context, pivot)
	if self:_element(reference_name) then
		self:_remove_element(reference_name)
	end

	return self:_add_element(class, reference_name, layer, context, pivot)
end

ExpeditionView.sidebar_remove_element = function (self, reference_name)
	if self:_element(reference_name) then
		self:_remove_element(reference_name)
	end
end

ExpeditionView.get_has_fetched = function (self)
	return self._has_fetched
end

ExpeditionView._set_has_fetched = function (self, value)
	local loading_widget = self._widgets_by_name and self._widgets_by_name.loading

	if loading_widget then
		loading_widget.content.visible = not value
	end

	self._has_fetched = value
end

ExpeditionView.get_all_nodes = function (self)
	return self._nodes
end

ExpeditionView._get_current_match_visibility = function (self)
	return self._current_match_visibility
end

ExpeditionView._get_quickplay_button = function (self)
	local cached_index = self._quickplay_button_index

	if cached_index then
		return self._selectables[cached_index]
	end

	for index, selectable in pairs(self._selectables) do
		if self:_is_quickplay_button(selectable) then
			return selectable
		end
	end

	return #self._selectables
end

ExpeditionView._get_quickplay_button_index = function (self)
	local cached_index = self._quickplay_button_index

	if cached_index then
		return cached_index
	end

	for index, selectable in pairs(self._selectables) do
		if self:_is_quickplay_button(selectable) then
			return index
		end
	end

	return #self._selectables
end

ExpeditionView._set_selection_by_index = function (self, to_select)
	self:_set_selection(self._selectables[to_select])
end

ExpeditionView._set_selection = function (self, to_select)
	local to_select_index

	for i, selectable in pairs(self._selectables) do
		if selectable == to_select then
			to_select_index = i

			break
		end
	end

	local has_changed = to_select_index ~= self._selection_index

	if not has_changed then
		self:_unlock_node_if_eligible(to_select)

		return
	end

	self._previous_selection_index = self._selection_index

	local old = self._previous_selection_index and self._selectables[self._previous_selection_index] or nil

	if old then
		if self:_is_quickplay_button(old) then
			local quickplay_widget = old.widget

			quickplay_widget.content.hotspot.is_selected = false
		else
			Unit.flow_event(old.ui.node_unit, "unselect")
			Unit.set_scalar_for_materials(old.ui.node_unit, "emissive_multiplier", 1)
		end
	end

	self._selection_index = to_select_index

	local new = self._selection_index and self._selectables[self._selection_index] or nil

	if new then
		local is_quickplay_button = self:_is_quickplay_button(new)

		if is_quickplay_button then
			local quickplay_widget = new.widget

			quickplay_widget.content.hotspot.is_selected = true
		else
			Unit.flow_event(new.ui.node_unit, "select")
			Unit.set_scalar_for_materials(new.ui.node_unit, "emissive_multiplier", Settings.node_selection_emissive_multiplier)
		end

		if is_quickplay_button then
			self:_play_sound(UISoundEvents.story_mission_option_selected)
		elseif new.unlock_status == UNLOCK_STATUS.locked then
			self:_play_sound(UISoundEvents.expedition_view_select_locked)
		elseif new.unlock_status == UNLOCK_STATUS.unlocked then
			self:_play_sound(UISoundEvents.expedition_view_select_unlocked)
		elseif new.unlock_status == UNLOCK_STATUS.unlockable then
			self:_play_sound(UISoundEvents.expedition_view_select_unlockable)
		end

		if new.unlock_status == UNLOCK_STATUS.unlocked and not self._unlocked_sound_looping then
			self:_play_sound(UISoundEvents.expedition_view_select_unlocked_loop)

			self._unlocked_sound_looping = true
		elseif new.unlock_status ~= UNLOCK_STATUS.unlocked then
			self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)

			self._unlocked_sound_looping = false
		end

		self._sidebar:show_mission_info(new)
	elseif new == nil and self:_element("view_element_expedition_view_mission_info") then
		self:_remove_element("view_element_expedition_view_mission_info")
	end
end

ExpeditionView.get_selection = function (self)
	local selectables = self._selectables
	local selection_index = self._selection_index

	if selectables and selection_index then
		return selectables[selection_index]
	end
end

ExpeditionView._get_selection_index = function (self)
	return self._selection_index
end

ExpeditionView._set_hovered = function (self, to_hover)
	local has_changed = to_hover ~= self._hovered

	if not has_changed then
		return
	end

	self._previous_hovered = self._hovered
	self._hovered = to_hover

	local old = self._previous_hovered
	local old_unit = old and old.ui and old.ui.node_unit or nil

	if old_unit then
		Unit.flow_event(old_unit, "unhover")
	end

	local new = self._hovered
	local new_unit = new and new.ui and new.ui.node_unit or nil

	if new and new_unit then
		Unit.flow_event(new_unit, "hover")
		self:_play_sound(UISoundEvents.expedition_view_hover)
	end
end

ExpeditionView._get_hovered = function (self)
	return self._hovered
end

ExpeditionView._get_previous_hovered = function (self)
	return self._previous_hovered
end

ExpeditionView._set_block_input = function (self, value)
	self._block_input = value
end

ExpeditionView._get_block_input = function (self)
	return self._block_input
end

ExpeditionView._set_can_start_mission = function (self, can_start_mission, info_level, info_text)
	self._can_start_mission = can_start_mission
	self._info_level = info_level
	self._info_text = info_text
end

ExpeditionView.get_can_start_mission = function (self)
	return self._can_start_mission, self._info_level, self._info_text
end

ExpeditionView.set_saved_match_visibility = function (self, match_visibility)
	local save_data = self.save_data

	save_data.page_index = self._page_index + 1
	save_data.private_match = match_visibility == MATCH_VISIBILITY.private

	Managers.save:queue_save()
end

ExpeditionView.get_selected_mission_data = function (self, node_override)
	local node = node_override or self:get_selection()

	if not node then
		return nil
	end

	local missions = node and node.missions
	local difficulty = self._page_settings and self._page_index and self._page_settings[self._page_index]
	local challenge = difficulty and difficulty.filter and difficulty.filter.challenge
	local resistance = difficulty and difficulty.filter and difficulty.filter.resistance

	return self:_find_mission_of_difficulty(missions, challenge, resistance)
end

ExpeditionView.on_exit = function (self)
	self:_despawn_nodes()

	if self._sidebar then
		self._sidebar:delete()

		self._sidebar = nil
	end

	self._world_spawner:delete()
	ExpeditionView.super.on_exit(self)
end

ExpeditionView._despawn_nodes = function (self)
	local world = self._world_spawner and self._world_spawner:world()
	local nodes = self._nodes

	if nodes then
		for _, node in pairs(nodes) do
			local node_ui = node.ui

			if node_ui.node_unit then
				World.destroy_unit(world, node_ui.node_unit)
			end

			if node_ui.dotted_line_units then
				for _, dotted_line_unit in pairs(node_ui.dotted_line_units) do
					World.destroy_unit(world, dotted_line_unit)
				end
			end
		end
	end

	self._nodes = nil
	self._selectables = nil
	self._hovered = nil
	self._previous_hovered = false
	self._selection_index = nil
	self._previous_selection_index = nil
	self._node_enter_anim_time = nil
	self._node_enter_anim_finished = nil
end

ExpeditionView.destroy = function (self)
	self:_play_sound(UISoundEvents.expedition_view_select_unlocked_end)

	local save_data = self.save_data

	if save_data then
		local match_visibility = self._current_match_visibility

		save_data.private_match = match_visibility == MATCH_VISIBILITY.private
		save_data.page_index = self._page_index + 1

		Managers.save:queue_save()
	end

	self._promise_container:delete()
	ExpeditionView.super.destroy(self)
end

return ExpeditionView
