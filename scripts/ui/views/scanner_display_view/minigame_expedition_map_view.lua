-- chunkname: @scripts/ui/views/scanner_display_view/minigame_expedition_map_view.lua

local ScannerDisplayViewExpeditionMapSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_expedition_map_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISettings = require("scripts/settings/ui/ui_settings")
local MinigameExpeditionMapView = class("MinigameExpeditionMapView")
local PLAYER_SLOT_COLORS = UISettings.player_slot_colors

MinigameExpeditionMapView.init = function (self, context, ui_renderer)
	self._owner_unit = context.device_owner_unit
	self._ui_renderer = ui_renderer
	self._exit_widgets = {}
	self._extraction_widgets = {}
	self._opportunity_widgets = {}
	self._player_widgets = {}
	self._background_widgets = {}
	self._navigation_handler = nil
	self._minigame = nil
end

MinigameExpeditionMapView.destroy = function (self)
	return
end

MinigameExpeditionMapView.update = function (self, dt, t, widgets_by_name)
	local navigation_handler = self._navigation_handler

	if not navigation_handler then
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()
		local collectibles_handler = game_mode:get_collectibles_handler()

		navigation_handler = game_mode:get_navigation_handler()
		self._minigame = navigation_handler:minigame()
		self._navigation_handler = navigation_handler
		self._collectibles_handler = collectibles_handler
	end

	if not ALIVE[self._owner_unit] then
		return
	end

	if #self._background_widgets == 0 then
		self:_create_background_widgets()
	end

	local local_player = Managers.player:local_player(1)
	local camera_angle = Quaternion.yaw(Managers.state.camera:camera_rotation(local_player.viewport_name))

	self:_update_target_widgets(widgets_by_name, navigation_handler)
	self:_update_background_widgets(camera_angle)
	self:_update_player_widgets(camera_angle)
end

MinigameExpeditionMapView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local background_widgets = self._background_widgets

	for i = 1, #background_widgets do
		local widget = background_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	for _, widget in pairs(self._exit_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end

	for _, widget in pairs(self._extraction_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end

	for _, widget in pairs(self._opportunity_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end

	for _, widget in pairs(self._player_widgets) do
		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameExpeditionMapView._create_background_widgets = function (self)
	local scenegraph_id = "center_pivot"
	local widget_size = ScannerDisplayViewExpeditionMapSettings.background_rings_size
	local background = {}
	local widget_name = "background_01"
	local widget_definition = UIWidget.create_definition(ScannerDisplayViewExpeditionMapSettings.background_ring_definitions, scenegraph_id, nil, widget_size)
	local widget = UIWidget.init(widget_name, widget_definition)

	background[#background + 1] = widget

	local offset = widget.offset

	offset[1] = ScannerDisplayViewExpeditionMapSettings.board_starting_offset_x - widget_size[1] / 2
	offset[2] = ScannerDisplayViewExpeditionMapSettings.board_starting_offset_y - widget_size[2] / 2
	offset[3] = 1
	self._background_widgets = background
end

MinigameExpeditionMapView._update_background_widgets = function (self, camera_angle)
	local background_widgets = self._background_widgets

	for i = 1, #background_widgets do
		local widget = background_widgets[i]
		local angle = camera_angle

		widget.style.highlight.angle = -angle
	end
end

MinigameExpeditionMapView._world_pos_to_map_pos = function (self, x, y, widget_size)
	x, y = self._minigame:world_pos_to_map_pos(x, y)
	x = ScannerDisplayViewExpeditionMapSettings.board_starting_offset_x + x * ScannerDisplayViewExpeditionMapSettings.board_width - widget_size[1] / 2
	y = ScannerDisplayViewExpeditionMapSettings.board_starting_offset_y + y * ScannerDisplayViewExpeditionMapSettings.board_height - widget_size[2] / 2

	return x, y
end

MinigameExpeditionMapView._rot_to_map_angle = function (self, rotation, camera_rotation)
	local angle = Quaternion.yaw(rotation)

	angle = angle - camera_rotation

	return angle + math.pi / 2
end

MinigameExpeditionMapView._create_icon_widget = function (self, widget_name, value)
	local definitions = ScannerDisplayViewExpeditionMapSettings.target_definitions

	definitions[1].value = "content/ui/materials/backgrounds/scanner/" .. value

	local widget_definition = UIWidget.create_definition(ScannerDisplayViewExpeditionMapSettings.target_definitions, "center_pivot", nil, ScannerDisplayViewExpeditionMapSettings.target_widget_size)

	return UIWidget.init(widget_name, widget_definition)
end

local OPP_ID = {
	"scanner_map_greek_01",
	"scanner_map_greek_02",
	"scanner_map_greek_03",
	"scanner_map_greek_04",
	"scanner_map_greek_05",
	"scanner_map_greek_06",
	"scanner_map_greek_07",
	"scanner_map_greek_08",
	"scanner_map_greek_09",
	"scanner_map_greek_10",
	"scanner_map_greek_11",
	"scanner_map_greek_12",
	"scanner_map_greek_13",
	"scanner_map_greek_14",
	"scanner_map_greek_15",
	"scanner_map_greek_16",
	"scanner_map_greek_17",
	"scanner_map_greek_18",
	"scanner_map_greek_19",
	"scanner_map_greek_20",
	"scanner_map_greek_21",
	"scanner_map_greek_22",
	"scanner_map_greek_23",
	"scanner_map_greek_24",
}
local COLOR_HIDDEN = {
	0,
	0,
	0,
	0,
}

MinigameExpeditionMapView._update_target_widgets = function (self, widgets_by_name, navigation_handler)
	local minigame = navigation_handler:minigame()
	local cursor_widget = widgets_by_name.cursor

	cursor_widget.style.frame.color = COLOR_HIDDEN

	local function _copy_color(from, to)
		for i = 1, #from do
			to[i] = from[i]
		end
	end

	local function _check_marked(level_index, widget)
		local selected = minigame:selected_level()

		if selected == level_index then
			local player = minigame:local_player()
			local player_slot = player and player.slot and player:slot()
			local player_slot_color = player_slot and PLAYER_SLOT_COLORS[player_slot]

			if player_slot_color then
				cursor_widget.style.frame.color = player_slot_color
			end

			local target_offset = widget.offset
			local offset = cursor_widget.offset

			offset[1] = target_offset[1]
			offset[2] = target_offset[2]
			offset[3] = target_offset[3] + 1
		end

		local color = widget.style.highlight.color

		widget.style.title.color = color

		local player_slot_index = navigation_handler:player_slot_by_level_marked(level_index)

		if player_slot_index then
			_copy_color(PLAYER_SLOT_COLORS[player_slot_index], color)
		else
			_copy_color(ScannerDisplayViewExpeditionMapSettings.target_base_color, color)
		end

		if navigation_handler:is_level_completed(level_index) then
			color[1] = 32
		end
	end

	local registered_exits = navigation_handler:get_registered_exits()
	local exit_widgets = self._exit_widgets

	for level_index, location in pairs(registered_exits) do
		local widget = exit_widgets[level_index]

		if not widget then
			widget = self:_create_icon_widget(string.format("exit_%s", level_index), "scanner_map_exit")
			exit_widgets[level_index] = widget
		end

		local position = location:unbox()
		local offset = widget.offset

		offset[1], offset[2] = self:_world_pos_to_map_pos(position.x, position.y, ScannerDisplayViewExpeditionMapSettings.target_widget_size)
		offset[3] = 5

		_check_marked(level_index, widget)
	end

	local registered_extractions = navigation_handler:get_registered_extractions()
	local extraction_widgets = self._extraction_widgets

	for level_index, location in pairs(registered_extractions) do
		local widget = extraction_widgets[level_index]

		if not widget then
			widget = self:_create_icon_widget(string.format("extraction_%s", level_index), "scanner_map_extract")
			extraction_widgets[level_index] = widget
		end

		local position = location:unbox()
		local offset = widget.offset

		offset[1], offset[2] = self:_world_pos_to_map_pos(position.x, position.y, ScannerDisplayViewExpeditionMapSettings.target_widget_size)
		offset[3] = 5

		_check_marked(level_index, widget)
	end

	local registered_opportunities = navigation_handler:get_registered_opportunities()
	local opportunity_widgets = self._opportunity_widgets
	local location_index = 0

	for level_index, location in pairs(registered_opportunities) do
		location_index = location_index + 1

		local widget = opportunity_widgets[level_index]

		if not widget then
			widget = self:_create_icon_widget(string.format("opportunity_%s", level_index), OPP_ID[1 + level_index % #OPP_ID])
			widget.style.title.visible = true
			widget.content.value_id_2 = "content/ui/materials/backgrounds/scanner/scanner_map_" .. location_index
			opportunity_widgets[level_index] = widget
		end

		local position = location:unbox()
		local offset = widget.offset

		offset[1], offset[2] = self:_world_pos_to_map_pos(position.x, position.y, ScannerDisplayViewExpeditionMapSettings.target_widget_size)
		offset[3] = 4

		_check_marked(level_index, widget)
	end
end

MinigameExpeditionMapView._create_player_widget = function (self, widget_name)
	local definitions = {
		{
			pass_type = "rotated_texture",
			style_id = "highlight",
			value = "content/ui/materials/buttons/arrow_01",
			style = {
				angle = 0,
				hdr = true,
				horizontal_alignment = "center",
				vertical_alignment = "center",
				color = {
					255,
					0,
					255,
					0,
				},
			},
		},
	}
	local widget_definition = UIWidget.create_definition(definitions, "center_pivot", nil, ScannerDisplayViewExpeditionMapSettings.target_widget_size)

	return UIWidget.init(widget_name, widget_definition)
end

local ACTIVE_PLAYERS = {}

MinigameExpeditionMapView._update_player_widgets = function (self, camera_angle)
	local players = Managers.player:players()
	local player_widgets = self._player_widgets
	local local_player = Managers.player:local_player(1)

	table.clear(ACTIVE_PLAYERS)

	for unique_id, player in pairs(players) do
		local player_unit = player.player_unit

		if player_unit and ALIVE[player_unit] then
			local widget = player_widgets[unique_id]

			ACTIVE_PLAYERS[unique_id] = true

			if not widget then
				widget = self:_create_player_widget(string.format("player_%s", unique_id))
				player_widgets[unique_id] = widget
			end

			local position = POSITION_LOOKUP[player_unit]
			local offset = widget.offset
			local angle

			if player == local_player then
				angle = math.pi / 2
			else
				angle = self:_rot_to_map_angle(Unit.world_rotation(player_unit, 1), camera_angle)
			end

			widget.style.highlight.angle = angle
			offset[1], offset[2] = self:_world_pos_to_map_pos(position.x, position.y, ScannerDisplayViewExpeditionMapSettings.target_widget_size)
			offset[3] = 5

			local player_slot = player and player.slot and player:slot()
			local player_slot_color = player_slot and PLAYER_SLOT_COLORS[player_slot]

			if player_slot_color then
				widget.style.highlight.color = player_slot_color
			elseif player_unit == self._owner_unit then
				widget.style.highlight.color = {
					255,
					255,
					255,
					150,
				}
			else
				widget.style.highlight.color = {
					128,
					255,
					165,
					0,
				}
			end
		end
	end

	for unique_id, widget in pairs(player_widgets) do
		if not ACTIVE_PLAYERS[unique_id] then
			UIWidget.destroy(self._ui_renderer, widget)

			player_widgets[unique_id] = nil
		end
	end
end

return MinigameExpeditionMapView
