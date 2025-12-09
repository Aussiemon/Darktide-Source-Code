-- chunkname: @scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list.lua

local Definitions = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_definitions")
local Styles = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_styles")
local Settings = require("scripts/ui/view_elements/view_element_campaign_mission_list/view_element_campaign_mission_list_settings")
local Blueprints = require("scripts/ui/view_content_blueprints/mission_tile_blueprints/mission_tile_blueprints")
local MissionTemplates = require("scripts/settings/mission/mission_templates")
local MissionTypes = require("scripts/settings/mission/mission_types")
local PlayerVOStoryStage = require("scripts/utilities/player_vo_story_stage")
local Zones = require("scripts/settings/zones/zones")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local CampaignSettings = require("scripts/settings/campaign/campaign_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIResolution = require("scripts/managers/ui/ui_resolution")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local InputUtils = require("scripts/managers/input/input_utils")
local InputDevice = require("scripts/managers/input/input_device")
local ViewElementCampaignMissionList = class("ViewElementCampaignMissionList", "ViewElementBase")
local DEFAULT_FILTERS = {
	required_category = {
		"story",
	},
	required_campaign = {
		"player-journey",
	},
}
local DEFAULT_GRID_ROWS = 3
local DEFAULT_GRID_COLS = 20
local CELL_WIDTH = 280
local CELL_HEIGHT = 200

local function _get_grid_cell_data(grid, row, col)
	if grid[row] and grid[row][col] then
		return grid[row][col]
	end

	return nil
end

local function _are_cells_adjacent(cell1, cell2)
	if not cell1 or not cell2 then
		return false
	end

	local row_diff = math.abs(cell1.row - cell2.row)
	local col_diff = math.abs(cell1.col - cell2.col)

	if row_diff == 0 and col_diff == 1 then
		return true
	elseif row_diff == 1 and col_diff == 0 then
		return true
	else
		return false
	end
end

local function _get_cell_direction(cell1, cell2)
	if not cell1 or not cell2 then
		return nil
	end

	local row_diff = math.abs(cell1.row - cell2.row)
	local col_diff = math.abs(cell1.col - cell2.col)

	if row_diff == 0 and col_diff >= 1 then
		return "horizontal"
	elseif row_diff >= 1 and col_diff == 0 then
		return "vertical"
	else
		return nil
	end
end

local function _get_vertical_directiion(cell1, cell2)
	if not cell1 or not cell2 then
		return nil
	end

	local row_diff = cell2.row - cell1.row

	if row_diff > 0 then
		return "down"
	elseif row_diff < 0 then
		return "up"
	else
		return nil
	end
end

local function _get_horizontal_direction(cell1, cell2)
	if not cell1 or not cell2 then
		return nil
	end

	local col_diff = cell2.col - cell1.col

	if col_diff > 0 then
		return "right"
	elseif col_diff < 0 then
		return "left"
	else
		return nil
	end
end

local function _get_farthest_occupied_column(grid)
	local farthest_col = 1

	for row = 1, #grid do
		for col = #grid[row], 1, -1 do
			local cell = grid[row][col]

			if cell and cell.data then
				if farthest_col < col then
					farthest_col = col
				end

				break
			end
		end
	end

	return farthest_col
end

ViewElementCampaignMissionList.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementCampaignMissionList.super.init(self, parent, draw_layer, start_scale, Definitions)

	local ui_renderer = parent._ui_renderer

	self._ui_renderer = ui_renderer
	self._visible = false
	self._missions = {}
	self._data_synced = false
	self._context = context

	self:_create_offscreen_renderer()

	self._current_filters = table.clone(DEFAULT_FILTERS)
	self._selected_panel_id = "player-journey"
	self._selected_panel_index = 1
end

ViewElementCampaignMissionList.initialize_data = function (self)
	local parent = self:parent()
	local campaign_data = parent._mission_board_logic:get_campaigns_data()

	self._campaigns_data = campaign_data

	self:_setup_panel_widgets()
end

ViewElementCampaignMissionList.on_enter = function (self)
	self:set_visibility(true)
	self:refresh_mission_list()

	self._enter_animation = self:_start_animation("title_enter", nil, {
		ui_renderer = self._ui_renderer,
	})

	self:_play_sound("story_mission_enter")
end

ViewElementCampaignMissionList.on_exit = function (self)
	self._background_entry_done = nil
	self._enter_animation = nil
	self._exit_animation = self:_start_animation("title_exit", nil, {
		ui_renderer = self._ui_renderer,
	})

	self:_play_sound("story_mission_exit")
end

ViewElementCampaignMissionList.update = function (self, dt, t, input_service)
	if not self:visible() then
		return
	end

	local parent = self:parent()
	local has_synced_data = parent._mission_board_logic:has_synced_missions_data()

	if has_synced_data and self._data_synced ~= has_synced_data then
		self._data_synced = has_synced_data
	end

	for id, mission_data in pairs(self._missions) do
		local is_alive = mission_data ~= nil and t <= mission_data.expiry_game_time

		if not is_alive then
			self._should_refresh_mission_list = true

			break
		end
	end

	if self._should_refresh_mission_list then
		self:refresh_mission_list()

		return
	end

	local scrollbar_widget = self._scrollbar_widget
	local scrollbar_content = scrollbar_widget and scrollbar_widget.content

	if self._update_scroll then
		local max_value = self._selected_col / self._farthest_col > 1 / self._farthest_col and self._selected_col / self._farthest_col or 0
		local min_value = scrollbar_content.scroll_percentage or 0

		scrollbar_content.scroll_percentage = math.lerp(min_value, max_value, 0.25)
		scrollbar_content.scroll_value = math.lerp(min_value, max_value, 0.25)

		if max_value == scrollbar_content.scroll_percentage or max_value > min_value - 0.01 and max_value < min_value + 0.01 then
			self._update_scroll = nil
		end
	end

	if scrollbar_content then
		local scroll_percentage = scrollbar_content.scroll_percentage or 0

		if scroll_percentage then
			self._ui_scenegraph.list_anchor.local_position[1] = 100 + math.clamp(-(scrollbar_content.scroll_length * scroll_percentage - 100), -(scrollbar_content.scroll_length - 100), 0)

			UIScenegraph.update_scenegraph(self._ui_scenegraph, self._render_scale)

			self._scroll_percentage = scroll_percentage
		end
	end

	local selected_mission_id = self:_get_selected_mission_id()

	if self._mission_grid then
		for row, columns in pairs(self._mission_grid) do
			for col, cell_data in pairs(columns) do
				if cell_data and cell_data.data then
					local tile_widget = cell_data.widget
					local tile_content = tile_widget.content
					local tile_hotspot = tile_content.hotspot
					local is_selected = cell_data.data.id == selected_mission_id

					tile_hotspot.is_selected = is_selected

					local debrief_widget = cell_data.debrief_widget

					if debrief_widget then
						local debrief_content = debrief_widget.content
						local debrief_hotspot = debrief_content.hotspot

						debrief_hotspot.is_selected = is_selected
					end

					if cell_data.data.id == selected_mission_id then
						self._selected_row = row
						self._selected_col = col
					end
				end
			end
		end
	end

	for _, widget in pairs(self._panel_button_widgets) do
		local content = widget.content
		local hotspot = content.panel_button_hotspot

		hotspot.is_selected = content.index == self._selected_panel_index
	end

	self:_handle_gamepad_input(dt, t, input_service)
	ViewElementCampaignMissionList.super.update(self, dt, t, input_service)
end

ViewElementCampaignMissionList.is_playing_transition_animation = function (self)
	return not not self._exit_animation or not not self._enter_animation
end

ViewElementCampaignMissionList._handle_gamepad_input = function (self, dt, t, input_service)
	if not InputDevice.gamepad_active then
		return
	end

	if input_service:get("navigate_right_continuous") then
		local has_found_target = false
		local target_row = self._selected_row
		local target_column = self._selected_col + 1 < DEFAULT_GRID_COLS and self._selected_col + 1 or DEFAULT_GRID_COLS
		local target_cell = self._mission_grid[target_row] and self._mission_grid[target_row][target_column]

		has_found_target = not not target_cell.data

		if has_found_target then
			self:on_mission_tile_pressed(target_cell.data, target_cell.slot)

			self._selected_col = target_column
			self._selected_row = target_row

			if not self:_is_cell_within_mask(target_cell) then
				self._update_scroll = true
			end
		else
			for col = target_column, DEFAULT_GRID_COLS do
				for row = 1, #self._mission_grid do
					local cell = self._mission_grid[row][col]

					if cell and cell.data then
						self:on_mission_tile_pressed(cell.data, cell.slot)

						self._selected_col = col
						self._selected_row = row
						has_found_target = true

						if not self:_is_cell_within_mask(cell) then
							self._update_scroll = true
						end

						break
					end
				end

				if has_found_target then
					break
				end
			end
		end
	elseif input_service:get("navigate_left_continuous") then
		local has_found_target = false
		local target_row = self._selected_row
		local target_column = self._selected_col - 1 > 1 and self._selected_col - 1 or 1
		local target_cell = self._mission_grid[target_row] and self._mission_grid[target_row][target_column]

		has_found_target = not not target_cell.data

		if has_found_target then
			self:on_mission_tile_pressed(target_cell.data, target_cell.slot)

			self._selected_col = target_column
			self._selected_row = target_row

			if not self:_is_cell_within_mask(target_cell) then
				self._update_scroll = true
			end
		else
			for col = target_column, 1, -1 do
				for row = 1, #self._mission_grid do
					local cell = self._mission_grid[row][col]

					if cell and cell.data then
						self:on_mission_tile_pressed(cell.data, cell.slot)

						self._selected_col = col
						self._selected_row = row

						if not self:_is_cell_within_mask(cell) then
							self._update_scroll = true
						end

						has_found_target = true

						break
					end
				end

				if has_found_target then
					break
				end
			end
		end
	elseif input_service:get("navigate_up_continuous") then
		local target_row = self._selected_row - 1 > 1 and self._selected_row - 1 or 1
		local target_column = self._selected_col

		for row = target_row, 1, -1 do
			local cell = self._mission_grid[row] and self._mission_grid[row][target_column]

			if cell and cell.data then
				self:on_mission_tile_pressed(cell.data, cell.slot)

				self._selected_row = row
				self._selected_col = target_column

				if not self:_is_cell_within_mask(cell) then
					self._update_scroll = true
				end

				break
			end
		end
	elseif input_service:get("navigate_down_continuous") then
		local target_row = self._selected_row + 1 < #self._mission_grid and self._selected_row + 1 or #self._mission_grid
		local target_column = self._selected_col

		for row = target_row, #self._mission_grid do
			local cell = self._mission_grid[row] and self._mission_grid[row][target_column]

			if cell and cell.data then
				self:on_mission_tile_pressed(cell.data, cell.slot)

				self._selected_row = row
				self._selected_col = target_column

				if not self:_is_cell_within_mask(cell) then
					self._update_scroll = true
				end

				break
			end
		end
	elseif input_service:get("mission_board_play_debrief") then
		local cell = _get_grid_cell_data(self._mission_grid, self._selected_row, self._selected_col)
		local debrief_widget = cell and cell.debrief_widget
		local mission_data = cell and cell.data
		local debrief_widget_content = debrief_widget and debrief_widget.content
		local is_locked = debrief_widget_content and debrief_widget_content.is_locked

		if mission_data and not is_locked then
			local circumstance = mission_data.circumstance

			self:_queue_debrief_video(circumstance)
		end
	elseif input_service:get("navigate_secondary_right_pressed") then
		self:_switch_next_campaign_tab()
	elseif input_service:get("navigate_secondary_left_pressed") then
		self:_switch_previous_campaign_tab()
	end
end

ViewElementCampaignMissionList.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not self:visible() then
		return
	end

	local render_scale = self._render_scale
	local render_settings = render_settings or self._render_settings
	local ui_renderer = self._ui_renderer
	local offscreen_renderer = self._offscreen_renderer

	render_settings.start_layer = self._draw_layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local ui_scenegraph = self._ui_scenegraph

	ViewElementCampaignMissionList.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._scrollbar_widget then
		UIWidget.draw(self._scrollbar_widget, ui_renderer)
	end

	if self._panel_button_widgets then
		for _, widget in pairs(self._panel_button_widgets) do
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)

	render_settings.start_layer = self._draw_layer + 1

	UIRenderer.begin_pass(offscreen_renderer, ui_scenegraph, input_service, dt, render_settings)

	if self._background_entry_done then
		if self._mission_grid then
			for row, columns in pairs(self._mission_grid) do
				for col, cell_data in pairs(columns) do
					if cell_data and cell_data.widget then
						UIWidget.draw(cell_data.widget, offscreen_renderer)
					end

					if cell_data and cell_data.debrief_widget then
						UIWidget.draw(cell_data.debrief_widget, offscreen_renderer)
					end

					if cell_data and cell_data.line_widgets then
						for _, line_widget in ipairs(cell_data.line_widgets) do
							UIWidget.draw(line_widget, offscreen_renderer)
						end
					end
				end
			end
		end

		if self._line_widgets then
			for _, line_widget in ipairs(self._line_widgets) do
				UIWidget.draw(line_widget, offscreen_renderer)
			end
		end
	end

	UIRenderer.end_pass(offscreen_renderer)
end

ViewElementCampaignMissionList.destroy = function (self, ui_renderer)
	ViewElementCampaignMissionList.super.destroy(self, ui_renderer)
	self:_destroy_offscreen_renderer()
end

ViewElementCampaignMissionList._widget_from_blueprint = function (self, widget_id, blueprint_setting_name, mission_data, creation_context, ...)
	local blueprint_settings = Settings.mission_tile_settings[blueprint_setting_name]

	if not blueprint_settings then
		Log.error("ViewElementCampaignMissionList", "No blueprint settings found for '%s'.", blueprint_setting_name)

		return
	end

	local blueprint_name = blueprint_settings.blueprint_name
	local blueprint = Blueprints[blueprint_name]

	if not blueprint then
		return
	end

	local size = blueprint_settings.size
	local scenegraph_id = blueprint_settings.scenegraph_id
	local definition = Blueprints.make_blueprint(blueprint, scenegraph_id, size)
	local widget = UIWidget.init(widget_id, definition)

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

ViewElementCampaignMissionList._setup_scrollbar = function (self)
	local scrollbar_definition = Definitions.create_scrollbar_widget("horizontal")
	local scrollbar_widget = UIWidget.init("scrollbar", scrollbar_definition)
	local content = scrollbar_widget.content
	local area_length = CELL_WIDTH * 5
	local farthest_col = _get_farthest_occupied_column(self._mission_grid)

	self._farthest_col = farthest_col

	local scroll_length = math.max(farthest_col * CELL_WIDTH + CELL_WIDTH + 150 - area_length, 0)
	local scroll_amount = scroll_length > 0 and CELL_WIDTH / scroll_length or 0

	content.area_length = area_length
	content.scroll_length = scroll_length
	content.scroll_amount = scroll_amount
	content.scroll_area_size = self._ui_scenegraph.list_mask.size
	content.scroll_area_position = self._ui_scenegraph.list_mask.world_position
	self._scrollbar_widget = scrollbar_widget
end

ViewElementCampaignMissionList._setup_grid = function (self, rows, cols)
	local rows = rows or DEFAULT_GRID_ROWS
	local cols = cols or DEFAULT_GRID_COLS
	local grid = {}

	for row = 1, rows do
		grid[row] = {}

		for col = 1, cols do
			grid[row][col] = {
				data = nil,
				widget = nil,
				row = row,
				col = col,
			}
		end
	end

	self._grid_rows = rows
	self._grid_cols = cols

	return grid
end

ViewElementCampaignMissionList._create_line_widget = function (self, start_cell, end_cell, locked_line)
	local direction = _get_cell_direction(start_cell, end_cell)
	local vertical_direction = _get_vertical_directiion(start_cell, end_cell)
	local size_x = direction == "horizontal" and math.abs(end_cell.col - start_cell.col) * CELL_WIDTH or 2
	local size_y = direction == "vertical" and math.abs(end_cell.row - start_cell.row) * CELL_HEIGHT or 2
	local offset = {
		(start_cell.col - 1) * CELL_WIDTH,
		(start_cell.row - 1) * CELL_HEIGHT - CELL_HEIGHT * 0.5,
		-1,
	}
	local start_cell_name = start_cell.name or "empty"
	local end_cell_name = end_cell.name or "empty"
	local offset_y = vertical_direction == "up" and -size_y or 0
	local is_locked_line = locked_line
	local line_color = is_locked_line and {
		255,
		127.5,
		44,
		13.5,
	} or {
		255,
		255,
		88,
		27,
	}
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style_id = "line_rect",
			style = {
				horizontal_alignment = "left",
				vertical_alignment = "top",
				color = line_color,
				size_addition = {
					0,
					0,
				},
				size = {
					size_x,
					size_y,
				},
				offset = {
					48,
					offset_y + 54.400000000000006,
					1,
				},
			},
		},
	}, "list_anchor")
	local widget = UIWidget.init("line_widget_" .. start_cell_name .. "_" .. end_cell_name, widget_definition)

	widget.offset = offset
	widget.content.direction = direction
	widget.content.default_size = {
		size_x,
		size_y,
	}

	return widget
end

ViewElementCampaignMissionList._create_vertical_line = function (self, grid, start_cell, end_cell, vertical_direction, widgets, line_locked)
	local row_diff = math.abs(start_cell.row - end_cell.row)
	local s_cell = start_cell

	for diff = 1, row_diff do
		local row = 1

		if vertical_direction == "up" then
			row = s_cell.row - diff > 0 and s_cell.row - diff or 1
		else
			row = s_cell.row + diff
		end

		local n_cell = _get_grid_cell_data(grid, row, s_cell.col)

		if n_cell then
			local widget = self:_create_line_widget(s_cell, n_cell, line_locked)

			widget.visible = false

			if not s_cell.line_widgets then
				s_cell.line_widgets = {}
			end

			s_cell.line_widgets[#s_cell.line_widgets + 1] = widget
		end

		s_cell = n_cell
	end

	return s_cell
end

ViewElementCampaignMissionList._create_horizontal_line = function (self, grid, start_cell, end_cell, horizontal_direction, widgets, line_locked)
	local col_diff = math.abs(start_cell.col - end_cell.col)
	local s_cell = start_cell

	for diff = 1, col_diff do
		local col = horizontal_direction == "right" and start_cell.col + diff or start_cell.col - diff
		local n_cell = _get_grid_cell_data(grid, start_cell.row, col)

		if n_cell then
			local widget = self:_create_line_widget(s_cell, n_cell, line_locked)

			widget.visible = false

			if not s_cell.line_widgets then
				s_cell.line_widgets = {}
			end

			s_cell.line_widgets[#s_cell.line_widgets + 1] = widget
		end

		s_cell = n_cell
	end

	return s_cell
end

ViewElementCampaignMissionList._create_line_connection = function (self, grid, start_cell, end_cell)
	if not start_cell or not end_cell then
		return nil
	end

	local widgets = {}
	local are_adjacent = _are_cells_adjacent(start_cell, end_cell)
	local line_locked = end_cell.is_locked

	if are_adjacent then
		local line_widget = self:_create_line_widget(start_cell, end_cell, line_locked)

		line_widget.visible = false

		if not start_cell.line_widgets then
			start_cell.line_widgets = {}
		end

		start_cell.line_widgets[#start_cell.line_widgets + 1] = line_widget
	else
		local s_cell = start_cell
		local row_diff = math.abs(start_cell.row - end_cell.row)
		local col_diff = math.abs(start_cell.col - end_cell.col)
		local vertical_direction = _get_vertical_directiion(start_cell, end_cell)
		local horizontal_direction = _get_horizontal_direction(start_cell, end_cell)

		if s_cell.row ~= 2 then
			s_cell = self:_create_horizontal_line(grid, s_cell, end_cell, horizontal_direction, widgets, line_locked)
			s_cell = self:_create_vertical_line(grid, s_cell, end_cell, vertical_direction, widgets, line_locked)
		else
			s_cell = self:_create_vertical_line(grid, s_cell, end_cell, vertical_direction, widgets, line_locked)
			s_cell = self:_create_horizontal_line(grid, s_cell, end_cell, horizontal_direction, widgets, line_locked)
		end
	end

	return widgets
end

ViewElementCampaignMissionList._recursive_mission_placement = function (self, grid, mission_data, row, col, idx)
	if not mission_data then
		return idx
	end

	for r = 1, #grid do
		for c = 1, #grid[r] do
			local existing_data = grid[r][c]

			if existing_data and existing_data.data and existing_data.data.map == mission_data.mission then
				return idx
			end
		end
	end

	local mission = self:_get_mission_by_key(mission_data.mission)

	if not mission then
		return
	end

	local mission_template = MissionTemplates[mission.map]
	local title = Localize(mission_template.mission_name)
	local sub_title = Localize(Zones[mission_template.zone_id].name)
	local texture = mission_template.texture_small
	local parent = self:parent()
	local theme = parent:_get_ui_theme()
	local is_locked = parent._mission_board_logic:is_mission_locked(mission)
	local cell_data = {}
	local display_order = self:_get_mission_display_order(mission_data.mission, mission_data.campaign) or 1
	local unlock_data = parent._mission_board_logic:get_mission_unlock_data(mission_data.mission, mission_data.category)
	local is_story_mission = parent._mission_board_logic:is_story_mission(mission)
	local creation_context = {
		skip_background_frame = true,
		row = row,
		col = col,
		location_texture = texture,
		is_locked = is_locked or false,
		display_order = display_order,
		is_story = is_story_mission,
	}
	local widget = self:_widget_from_blueprint("mission_" .. idx, "mission_tile", mission, creation_context)
	local theme_slots = theme.slots.small
	local slot = theme_slots[math.fmod(display_order - 1, #theme_slots) + 1]

	widget.content.hotspot.pressed_callback = callback(self, "on_mission_tile_pressed", mission, slot)
	widget.visible = false
	cell_data.widget = widget
	cell_data.name = "cell_" .. mission_data.mission
	cell_data.data = mission
	cell_data.unlock_data = unlock_data
	cell_data.is_locked = is_locked
	cell_data.slot = slot
	cell_data.row = row
	cell_data.col = col

	if not grid[row] then
		grid[row] = {}
	end

	grid[row][col] = cell_data
	idx = idx + 1

	if mission_data.children and #mission_data.children > 0 then
		local child_1 = self:_get_campaign_mission_data(mission_data.children[1])

		if child_1 and child_1.campaign == mission_data.campaign then
			col = col + 1

			local first_child_row = #mission_data.children >= 2 and row - 1 or row

			if #child_1.parents > 1 then
				first_child_row = 2
			end

			idx = self:_recursive_mission_placement(grid, child_1, first_child_row, col, idx)
		end

		local child_2 = self:_get_campaign_mission_data(mission_data.children[2])

		if child_2 and child_2.campaign == mission_data.campaign and child_2 then
			idx = self:_recursive_mission_placement(grid, child_2, row + 1, col, idx)
		end

		return idx
	end

	return idx
end

ViewElementCampaignMissionList._populate_mission_grid = function (self, campaign_missions, filtered_missions)
	local grid = self._mission_grid or {}
	local idx = 1
	local mission_head = campaign_missions[1]

	self:_recursive_mission_placement(grid, mission_head, 2, 1, idx)

	for i = #campaign_missions, 1, -1 do
		local mission_data = campaign_missions[i]

		if mission_data then
			local parents = mission_data.parents

			if parents and #parents > 1 then
				local child = self:_get_cell_by_name(mission_data.mission)
				local parent_1 = self:_get_cell_by_name(parents[1].mission)
				local parent_2 = self:_get_cell_by_name(parents[2].mission)

				if child and parent_1 and parent_2 then
					local new_child_col = child.col or 1
					local should_move_child = false

					if parent_1.col ~= parent_2.col then
						if parent_1.col > parent_2.col then
							new_child_col = parent_1.col + 1
						else
							new_child_col = parent_2.col + 1
						end

						should_move_child = true
					end

					if should_move_child then
						if grid[child.row] and grid[child.row][child.col] then
							grid[child.row][child.col] = {
								row = child.row,
								col = child.col,
							}
						end

						child.col = new_child_col
						grid[child.row][new_child_col] = child
					end
				end
			end
		end
	end

	for row, columns in pairs(grid) do
		for col, cell_data in pairs(columns) do
			local cell_data = cell_data or {}

			cell_data.row = row
			cell_data.col = col

			local widget = cell_data.widget

			if widget then
				widget.offset = {
					(col - 1) * CELL_WIDTH,
					(row - 1) * CELL_HEIGHT - CELL_HEIGHT * 0.5,
					1,
				}
			end
		end
	end

	local line_widgets = {}

	for i = 1, #campaign_missions do
		local mission_data = campaign_missions[i]

		if mission_data and mission_data and mission_data.children and #mission_data.children > 0 then
			for _, child in ipairs(mission_data.children) do
				local start_cell = self:_get_cell_by_name(mission_data.mission)
				local end_cell = self:_get_cell_by_name(child.mission)

				if start_cell and end_cell then
					local widgets = self:_create_line_connection(grid, start_cell, end_cell)
				end
			end
		end
	end

	for row, columns in pairs(grid) do
		for col, cell_data in pairs(columns) do
			if cell_data.data then
				local mission = cell_data.data
				local mission_template = MissionTemplates[mission.map]
				local mission_circumstance = mission.circumstance
				local has_completed_mission = cell_data.unlock_data.completed
				local debrief_widget_definition = Definitions.create_debrief_widget("list_anchor", not has_completed_mission)
				local widget = UIWidget.init(mission_circumstance .. "_widget", debrief_widget_definition)

				widget.offset = {
					(col - 1) * CELL_WIDTH + 160,
					(row - 1) * CELL_HEIGHT - Settings.debrief_settings.size[2] * 0.5 - Settings.debrief_settings.size[2] * 0.25,
					10,
				}
				widget.visible = false

				local content = widget.content

				if Settings.debrief_videos[mission_circumstance] then
					content.hotspot.pressed_callback = has_completed_mission and callback(self, "_queue_debrief_video", mission_circumstance) or nil
					cell_data.debrief_widget = widget
				end
			end
		end
	end

	self._line_widgets = line_widgets
	self._mission_grid = grid

	self:_setup_scrollbar()
end

ViewElementCampaignMissionList.set_visibility = function (self, value)
	ViewElementCampaignMissionList.super.set_visibility(self, value)

	self._enter_animation = nil
	self._exit_animation = nil
end

ViewElementCampaignMissionList._setup_mission_data = function (self, missions, ordered_story_missions)
	local parent = self:parent()
	local story_t = table.clone(parent._mission_board_logic:_get_missions_per_category("story"))

	local function get_story_mission_by_key(key)
		for _, mission_data in pairs(story_t) do
			if mission_data.key == key then
				return mission_data
			end
		end
	end

	for i = #ordered_story_missions, 1, -1 do
		local mission = ordered_story_missions[i]
		local mission_data = get_story_mission_by_key(mission.key)

		if mission_data then
			local prerequisites = mission_data.prerequisites

			if prerequisites then
				for _, prerequisite in ipairs(prerequisites) do
					local parent_mission_data = get_story_mission_by_key(prerequisite.key)

					if parent_mission_data then
						if not parent_mission_data.children then
							parent_mission_data.children = {}
						end

						table.insert(parent_mission_data.children, mission_data)
					end
				end
			end
		end
	end

	return story_t
end

ViewElementCampaignMissionList._get_cell_by_name = function (self, map_name)
	local grid = self._mission_grid

	for row, columns in pairs(grid) do
		for col, cell_data in pairs(columns) do
			if cell_data.name == "cell_" .. map_name then
				return cell_data
			end
		end
	end

	return nil
end

ViewElementCampaignMissionList._get_mission_by_key = function (self, mission_key)
	if table.is_empty(self._missions) then
		return nil
	end

	for _, mission_data in pairs(self._missions) do
		if mission_data.map == mission_key then
			return mission_data
		end
	end

	return nil
end

ViewElementCampaignMissionList._get_mission_display_order = function (self, mission_key, mission_campaign)
	if not self._campaigns_data then
		return nil
	end

	for i, campaign in ipairs(self._campaigns_data) do
		if campaign.id == mission_campaign then
			for display_order, missions in pairs(campaign.missions) do
				if missions and missions.mission == mission_key then
					return display_order
				end
			end
		end
	end

	return nil
end

ViewElementCampaignMissionList._set_selected_mission = function (self, mission_id)
	local parent = self:parent()

	if parent and parent.set_selected_mission then
		parent:set_selected_mission(mission_id)
	end
end

ViewElementCampaignMissionList._get_selected_mission_id = function (self)
	local parent = self:parent()

	if parent and parent.get_selected_mission_id then
		return parent:get_selected_mission_id()
	end

	return nil
end

ViewElementCampaignMissionList._start_mission_list_entry_animation = function (self)
	local grid = self._mission_grid

	if not grid then
		return
	end

	for row, columns in pairs(grid) do
		for col, cell_data in pairs(columns) do
			if cell_data and (cell_data.widget or cell_data.debrief_widget or cell_data.line_widgets) then
				local params = {
					cell_data = cell_data,
				}
				local delay = (col - 1) * 0.025 + (row - 1) * 0.025

				self:_start_animation("mission_tile_entry", nil, params, nil, nil, delay)
			end
		end
	end
end

ViewElementCampaignMissionList._is_cell_within_mask = function (self, cell)
	if not cell or not cell.widget then
		return false
	end

	local anchor_position = self._ui_scenegraph.list_anchor.world_position
	local cell_position = cell.widget.offset
	local mask_world_position = self._ui_scenegraph.list_mask.world_position
	local mask_size = self._ui_scenegraph.list_mask.size
	local is_within_x = anchor_position[1] + 100 + cell_position[1] >= mask_world_position[1] and anchor_position[1] + 100 + cell_position[1] < mask_world_position[1] + mask_size[1]

	return is_within_x
end

ViewElementCampaignMissionList._queue_debrief_video = function (self, debrief_key)
	if not InputDevice.gamepad_active then
		local input_service = Managers.input:get_input_service("View")
		local cursor = input_service:get("cursor")
		local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local cursor_position = UIResolution.inverse_scale_vector(cursor, inverse_scale)
		local position = self._ui_scenegraph.list_mask.world_position
		local size = self._ui_scenegraph.list_mask.size
		local is_within_mask_bounds = math.point_is_inside_2d_box(cursor_position, position, size)

		if not is_within_mask_bounds then
			return
		end
	end

	local debrief_video = Settings.debrief_videos[debrief_key]

	if debrief_video then
		Managers.video:queue_video(debrief_video)
		Managers.video:play_queued_video()
	end
end

ViewElementCampaignMissionList._create_offscreen_renderer = function (self)
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil)
	local viewport_name = self.__class_name .. "_offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "_offscreen_renderer"

	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name,
	}
end

ViewElementCampaignMissionList._destroy_offscreen_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

ViewElementCampaignMissionList._get_campaign_required_categories = function (self, campaign_data, campaign_id)
	local required_categories = {}

	if campaign_data and campaign_id then
		for _, mission in pairs(campaign_data.missions) do
			if mission and mission.category and not table.contains(required_categories, mission.category) then
				required_categories[#required_categories + 1] = mission.category
			end
		end
	end

	return required_categories
end

ViewElementCampaignMissionList._setup_panel_widgets = function (self)
	local num_campaigns = table.size(self._campaigns_data)
	local tab_width = self._ui_scenegraph.list_panel.size[1] / num_campaigns
	local tab_height = self._ui_scenegraph.list_panel.size[2]
	local panel_button_widgets = {}

	for i, campaign_data in pairs(self._campaigns_data) do
		local campaign_id = campaign_data.id
		local panel_button_definition = Definitions.create_list_panel_widget("list_panel")
		local panel_button_widget = UIWidget.init("panel_button_" .. campaign_id, panel_button_definition)
		local content = panel_button_widget.content
		local campaign_settings = CampaignSettings[campaign_id]
		local display_name = campaign_settings and campaign_settings.display_name or campaign_id

		content.default_panel_button_campaign_title = Utf8.upper(Localize(display_name))
		content.size = {
			tab_width,
			tab_height,
		}
		content.id = campaign_id
		content.index = i
		panel_button_widgets[#panel_button_widgets + 1] = panel_button_widget

		panel_button_widget.content.panel_button_hotspot.pressed_callback = function ()
			if not table.find(self._current_filters.required_campaign, campaign_id) then
				local optional_filters = {}

				optional_filters.required_campaign = {
					campaign_id,
				}

				local required_categories = self:_get_campaign_required_categories(campaign_data, campaign_id)

				optional_filters.required_category = required_categories

				self:refresh_mission_list(optional_filters)

				self._selected_panel_index = i
			end
		end
	end

	for i, widget in ipairs(panel_button_widgets) do
		widget.offset = {
			(i - 1) * tab_width,
			0,
			1,
		}
	end

	self._panel_button_widgets = panel_button_widgets

	local left_stepper = self._widgets_by_name.panel_stepper_left
	local left_stepper_content = left_stepper.content

	left_stepper_content.hotspot.pressed_callback = callback(self, "_switch_previous_campaign_tab")

	local right_stepper = self._widgets_by_name.panel_stepper_right

	right_stepper.content.hotspot.pressed_callback = callback(self, "_switch_next_campaign_tab")
end

ViewElementCampaignMissionList._get_campaign_mission_data = function (self, data)
	if not data then
		return nil
	end

	local campaign_data = self._campaigns_data

	for _, campaign in pairs(campaign_data) do
		if data.campaign == campaign.id then
			for _, mission_data in pairs(campaign.missions) do
				if mission_data.mission == data.mission then
					return mission_data
				end
			end
		end
	end
end

ViewElementCampaignMissionList._get_campaign_missions = function (self, campaign_id)
	for _, campaign in pairs(self._campaigns_data) do
		if campaign.id == campaign_id then
			return campaign.missions
		end
	end

	return {}
end

ViewElementCampaignMissionList.refresh_mission_list = function (self, optional_filters)
	local parent = self:parent()
	local page_index = parent._mission_board_logic:get_current_page_index() or 1
	local difficulty_data = DangerSettings[page_index]
	local challenge = difficulty_data and difficulty_data.challenge
	local resistance = difficulty_data and difficulty_data.resistance
	local filter = {}

	filter.challenge = challenge
	filter.resistance = resistance
	filter.required_category = optional_filters and optional_filters.required_category or self._current_filters.required_category or {
		"story",
	}
	filter.required_campaign = optional_filters and optional_filters.required_campaign or self._current_filters.required_campaign or {
		"player-journey",
	}

	local filters = {
		filter,
	}

	self._current_filters = filter

	local grid = self:_setup_grid()

	self._mission_grid = grid

	local filtered_missions = parent._mission_board_logic:get_missions_by_filters(filters) or {}

	self._missions = filtered_missions

	local campaign_id = optional_filters and optional_filters.required_campaign[1] or self._current_filters.required_campaign[1] or "player-journey"
	local campaign_missions = self:_get_campaign_missions(campaign_id)

	self:_populate_mission_grid(campaign_missions, filtered_missions)

	if self._selected_row and self._selected_col then
		local cell = _get_grid_cell_data(self._mission_grid, self._selected_row, self._selected_col)

		if cell and cell.data then
			local mission_data = cell.data
			local slot = cell.slot

			parent:set_selected_mission(mission_data.id)
			parent:set_camera_target_zoom_rotation(slot.zoom, slot.rotation)

			local scrollbar_widget = self._scrollbar_widget
			local scrollbar_content = scrollbar_widget and scrollbar_widget.content

			scrollbar_content.scroll_percentage = self._scroll_percentage or 0
			scrollbar_content.scroll_value = self._scroll_percentage or 0
		end
	else
		local head_mission = campaign_missions[1]
		local mission_data = self:_get_mission_by_key(head_mission.mission)

		if mission_data then
			local theme = parent:_get_ui_theme()
			local slots = theme.slots.small
			local slot = slots[1]

			parent:set_selected_mission(mission_data.id, true)
			parent:set_camera_target_zoom_rotation(slot.zoom, slot.rotation)
		end
	end

	self:_start_mission_list_entry_animation()

	self._should_refresh_mission_list = nil
end

ViewElementCampaignMissionList.on_mission_tile_pressed = function (self, mission_data, slot)
	if not InputDevice.gamepad_active then
		local input_service = Managers.input:get_input_service("View")
		local cursor = input_service:get("cursor")
		local inverse_scale = RESOLUTION_LOOKUP.inverse_scale
		local cursor_position = UIResolution.inverse_scale_vector(cursor, inverse_scale)
		local position = self._ui_scenegraph.list_mask.world_position
		local size = self._ui_scenegraph.list_mask.size
		local is_within_mask_bounds = math.point_is_inside_2d_box(cursor_position, position, size)

		if not is_within_mask_bounds then
			return
		end
	end

	local parent = self:parent()

	if parent then
		parent:set_selected_mission(mission_data.id)
		parent:set_camera_target_zoom_rotation(slot.zoom, slot.rotation)
	end
end

ViewElementCampaignMissionList._switch_previous_campaign_tab = function (self)
	local parent = self:parent()
	local new_selected_index = self._selected_panel_index - 1 > 1 and self._selected_panel_index - 1 or 1

	if new_selected_index == self._selected_panel_index then
		return
	end

	self._selected_panel_index = new_selected_index

	local campaign_id = self._panel_button_widgets[self._selected_panel_index].content.id

	if not table.find(self._current_filters.required_campaign, campaign_id) then
		local optional_filters = {}

		optional_filters.required_campaign = {
			campaign_id,
		}

		local campaign_data = parent._mission_board_logic:get_data_by_campaign(campaign_id)
		local required_categories = self:_get_campaign_required_categories(campaign_data, campaign_id)

		optional_filters.required_category = required_categories

		self:refresh_mission_list(optional_filters)
	end
end

ViewElementCampaignMissionList._switch_next_campaign_tab = function (self)
	local parent = self:parent()
	local new_selected_index = self._selected_panel_index + 1 < #self._panel_button_widgets and self._selected_panel_index + 1 or #self._panel_button_widgets

	if new_selected_index == self._selected_panel_index then
		return
	end

	self._selected_panel_index = new_selected_index

	local campaign_id = self._panel_button_widgets[self._selected_panel_index].content.id

	if not table.find(self._current_filters.required_campaign, campaign_id) then
		local optional_filters = {}

		optional_filters.required_campaign = {
			campaign_id,
		}

		local campaign_data = parent._mission_board_logic:get_data_by_campaign(campaign_id)
		local required_categories = self:_get_campaign_required_categories(campaign_data, campaign_id)

		optional_filters.required_category = required_categories

		self:refresh_mission_list(optional_filters)
	end
end

return ViewElementCampaignMissionList
