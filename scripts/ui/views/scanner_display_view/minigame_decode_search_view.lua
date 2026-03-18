-- chunkname: @scripts/ui/views/scanner_display_view/minigame_decode_search_view.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewDecodeSearchSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_decode_search_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameDecodeSearchView = class("MinigameDecodeSearchView")

MinigameDecodeSearchView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._grid_widgets = {}
	self._target_widgets = {}
	self._stage_widgets = {}
end

MinigameDecodeSearchView.destroy = function (self)
	return
end

local system_name = "dialogue_system"

MinigameDecodeSearchView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

MinigameDecodeSearchView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)

	if not minigame:is_completed() then
		if #self._grid_widgets == 0 then
			self:_create_grid_widgets()
		end

		if #self._stage_widgets == 0 then
			self:_create_stage_widgets()
		end

		if #self._grid_widgets > 0 then
			if #self._target_widgets == 0 then
				self:_create_target_widgets(widgets_by_name)
			end

			local on_target = minigame:is_on_target()
			local state = minigame:state()
			local transition = state == "transition" or state == "outro"
			local highlight = on_target and minigame:time_since_move() > MinigameSettings.decode_highlight_time

			self:_update_grid(widgets_by_name, t, transition, highlight)
			self:_update_cursor(widgets_by_name, t, transition, highlight)
			self:_update_target(widgets_by_name, t, transition, highlight)
		end
	end
end

MinigameDecodeSearchView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local grid_widgets = self._grid_widgets

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local current_stage = minigame:current_stage()

	if not current_stage then
		return
	end

	if current_stage <= #self._target_widgets then
		local target_widgets = self._target_widgets[current_stage]

		for i = 1, #target_widgets do
			local widget = target_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local stage_widgets = self._stage_widgets

	for i = 1, #stage_widgets do
		local widget = stage_widgets[i]

		if i == current_stage then
			widget.style.highlight.color = {
				255,
				0,
				255,
				0,
			}
		elseif i < current_stage then
			widget.style.highlight.color = {
				128,
				0,
				128,
				0,
			}
		else
			widget.style.highlight.color = {
				64,
				0,
				64,
				0,
			}
		end

		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameDecodeSearchView._create_grid_widgets = function (self)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local symbols = minigame:symbols()

	if #symbols > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDecodeSearchSettings.symbol_widget_size
		local material_path = "content/ui/materials/backgrounds/scanner/"
		local material_prefix = "scanner_decode_"
		local starting_offset_x = ScannerDisplayViewDecodeSearchSettings.symbol_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDecodeSearchSettings.symbol_starting_offset_y
		local spacing = ScannerDisplayViewDecodeSearchSettings.symbol_spacing
		local grid_widgets = {}

		for y = 1, MinigameSettings.decode_search_board_height do
			for x = 1, MinigameSettings.decode_search_board_width do
				local widget_name = "symbol_"
				local symbol_id = symbols[#grid_widgets + 1]

				if symbol_id < 10 then
					widget_name = widget_name .. "0" .. tostring(symbol_id)
				else
					widget_name = widget_name .. tostring(symbol_id)
				end

				local widget_definition = UIWidget.create_definition({
					{
						pass_type = "texture",
						value = material_path .. material_prefix .. widget_name,
						style = {
							hdr = true,
							color = {
								255,
								0,
								255,
								0,
							},
						},
					},
				}, scenegraph_id, nil, widget_size)
				local widget = UIWidget.init(widget_name, widget_definition)

				grid_widgets[#grid_widgets + 1] = widget

				local offset = widget.offset

				offset[1] = starting_offset_x + (widget_size[1] + spacing) * (x - 1)
				offset[2] = starting_offset_y + (widget_size[2] + spacing) * (y - 1)
				offset[3] = 2
			end
		end

		self._grid_widgets = grid_widgets
	end
end

MinigameDecodeSearchView._create_target_widgets = function (self, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local targets = minigame:decode_targets()

	if targets and #targets > 0 then
		local starting_offset_x = ScannerDisplayViewDecodeSearchSettings.target_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDecodeSearchSettings.target_starting_offset_y
		local widget_target = widgets_by_name.symbol_highlight

		widget_target.style.highlight.offset[1] = starting_offset_x + ScannerDisplayViewDecodeSearchSettings.cursor_widget_offset[1]
		widget_target.style.highlight.offset[2] = starting_offset_y + ScannerDisplayViewDecodeSearchSettings.cursor_widget_offset[2]

		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDecodeSearchSettings.symbol_widget_size
		local material_path = "content/ui/materials/backgrounds/scanner/"
		local material_prefix = "scanner_decode_"
		local spacing = ScannerDisplayViewDecodeSearchSettings.symbol_spacing
		local target_widgets = {}

		for i = 1, #targets do
			local target = targets[i]
			local t_widgets = {}

			for y = 1, MinigameSettings.decode_search_cursor_height do
				for x = 1, MinigameSettings.decode_search_cursor_width do
					local widget_name = "symbol_"
					local symbol_id = target[#t_widgets + 1]

					if symbol_id < 10 then
						widget_name = widget_name .. "0" .. tostring(symbol_id)
					else
						widget_name = widget_name .. tostring(symbol_id)
					end

					local widget_definition = UIWidget.create_definition({
						{
							pass_type = "texture",
							value = material_path .. material_prefix .. widget_name,
							style = {
								hdr = true,
								color = {
									255,
									0,
									255,
									0,
								},
							},
						},
					}, scenegraph_id, nil, widget_size)
					local widget = UIWidget.init(widget_name, widget_definition)

					t_widgets[#t_widgets + 1] = widget

					local offset = widget.offset

					offset[1] = starting_offset_x + (widget_size[1] + spacing) * (x - 1)
					offset[2] = starting_offset_y + (widget_size[2] + spacing) * (y - 1)
					offset[3] = 2
				end
			end

			target_widgets[#target_widgets + 1] = t_widgets
		end

		self._target_widgets = target_widgets
	end
end

MinigameDecodeSearchView._create_stage_widgets = function (self)
	local stages = MinigameSettings.decode_search_stage_amount

	if stages > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDecodeSearchSettings.stage_widget_size
		local starting_offset_x = ScannerDisplayViewDecodeSearchSettings.stages_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDecodeSearchSettings.stages_starting_offset_y
		local spacing = ScannerDisplayViewDecodeSearchSettings.stage_spacing
		local pass_definitions = {
			{
				pass_type = "texture",
				style_id = "highlight",
				value = "content/ui/materials/backgrounds/default_square",
				style = {
					hdr = true,
					color = {
						255,
						0,
						255,
						0,
					},
				},
			},
		}
		local stage_widgets = {}

		for i = 1, stages do
			local widget_name = "symbol_0" .. tostring(i)
			local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_id, nil, widget_size)
			local widget = UIWidget.init(widget_name, widget_definition)

			stage_widgets[#stage_widgets + 1] = widget

			local offset = widget.offset

			offset[1] = starting_offset_x + (widget_size[1] + spacing) * (i - 1)
			offset[2] = starting_offset_y
		end

		self._stage_widgets = stage_widgets
	end
end

MinigameDecodeSearchView._update_grid = function (self, widgets_by_name, t, transition, highlight)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local cursor_position = minigame:cursor_position()
	local widgets = self._grid_widgets
	local i = 0

	for y = 1, MinigameSettings.decode_search_board_height do
		for x = 1, MinigameSettings.decode_search_board_width do
			i = i + 1

			local widget = widgets[i]

			if cursor_position.x >= x - 1 and cursor_position.y >= y - 1 and cursor_position.x < x - 1 + MinigameSettings.decode_search_cursor_width and cursor_position.y < y - 1 + MinigameSettings.decode_search_cursor_height then
				if highlight or transition then
					widget.style.style_id_1.color = {
						255,
						255,
						255,
						150,
					}
				else
					widget.style.style_id_1.color = {
						255,
						128,
						255,
						0,
					}
				end
			else
				widget.style.style_id_1.color = {
					255,
					0,
					128,
					0,
				}
			end
		end
	end
end

MinigameDecodeSearchView._update_cursor = function (self, widgets_by_name, t, transition, highlight)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local cursor_position = minigame:cursor_position()
	local widget_size = ScannerDisplayViewDecodeSearchSettings.symbol_widget_size
	local spacing = ScannerDisplayViewDecodeSearchSettings.symbol_spacing
	local starting_offset_x = ScannerDisplayViewDecodeSearchSettings.symbol_starting_offset_x
	local starting_offset_y = ScannerDisplayViewDecodeSearchSettings.symbol_starting_offset_y
	local widget_target = widgets_by_name.symbol_frame

	widget_target.style.frame.offset[1] = starting_offset_x + (widget_size[1] + spacing) * (cursor_position.x - 1) + ScannerDisplayViewDecodeSearchSettings.cursor_widget_offset[1]
	widget_target.style.frame.offset[2] = starting_offset_y + (widget_size[2] + spacing) * (cursor_position.y - 1) + ScannerDisplayViewDecodeSearchSettings.cursor_widget_offset[2]
	widget_target.style.frame.offset[3] = 1

	if highlight or transition then
		widget_target.style.frame.color = {
			255,
			255,
			255,
			150,
		}
	else
		widget_target.style.frame.color = {
			255,
			255,
			165,
			0,
		}
	end
end

MinigameDecodeSearchView._update_target = function (self, widgets_by_name, t, transition, highlight)
	local widget_target = widgets_by_name.symbol_highlight

	if highlight or transition then
		widget_target.style.highlight.color = {
			255,
			255,
			255,
			150,
		}
	else
		widget_target.style.highlight.color = {
			255,
			138,
			90,
			1,
		}
	end

	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_search)
	local current_stage = minigame:current_stage()

	if not current_stage or current_stage > #self._target_widgets then
		return
	end

	if transition then
		current_stage = current_stage - 1
	end

	local widgets = self._target_widgets[current_stage]
	local i = 0

	for y = 1, MinigameSettings.decode_search_cursor_height do
		for x = 1, MinigameSettings.decode_search_cursor_width do
			i = i + 1

			local widget = widgets[i]

			if highlight or transition then
				widget.style.style_id_1.color = {
					255,
					255,
					255,
					150,
				}
			else
				widget.style.style_id_1.color = {
					255,
					0,
					255,
					0,
				}
			end
		end
	end
end

return MinigameDecodeSearchView
