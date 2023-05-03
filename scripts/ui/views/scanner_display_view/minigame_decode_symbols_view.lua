local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameDecodeSymbolsView = class("MinigameDecodeSymbolsView")

MinigameDecodeSymbolsView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._grid_widgets = {}
end

MinigameDecodeSymbolsView.destroy = function (self)
	self._timer_start = nil
end

local system_name = "dialogue_system"

MinigameDecodeSymbolsView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

MinigameDecodeSymbolsView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_symbols)

	if not minigame:is_completed() then
		local decode_start_time = minigame:start_time()

		if #self._grid_widgets == 0 then
			self:_create_symbol_widgets()
		end

		if #self._grid_widgets > 0 and decode_start_time then
			local t_gameplay = Managers.time:time("gameplay")
			local on_target = minigame:is_on_target(t_gameplay)

			self:_draw_cursor(widgets_by_name, decode_start_time, on_target, t_gameplay)
			self:_draw_targets(widgets_by_name, decode_start_time, on_target)
		end
	end
end

MinigameDecodeSymbolsView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local grid_widgets = self._grid_widgets

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameDecodeSymbolsView._create_symbol_widgets = function (self)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_symbols)
	local symbols = minigame:symbols()

	if #symbols > 0 then
		local scenegraph_id = "center_pivot"
		local stage_amount = MinigameSettings.decode_symbols_stage_amount
		local symbols_per_stage = MinigameSettings.decode_symbols_items_per_stage
		local widget_size = ScannerDisplayViewSettings.decode_symbol_widget_size
		local material_path = "content/ui/materials/backgrounds/scanner/"
		local material_prefix = "scanner_decode_"
		local starting_offset_x = ScannerDisplayViewSettings.decode_symbol_starting_offset_x
		local starting_offset_y = ScannerDisplayViewSettings.decode_symbol_starting_offset_y
		local spacing = ScannerDisplayViewSettings.decode_symbol_spacing
		local grid_widgets = {}

		for i = 1, stage_amount do
			for j = 1, symbols_per_stage do
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
								0
							}
						}
					}
				}, scenegraph_id, nil, widget_size)
				local widget = UIWidget.init(widget_name, widget_definition)
				grid_widgets[#grid_widgets + 1] = widget
				local offset = widget.offset
				offset[1] = starting_offset_x + (widget_size[1] + spacing) * (j - 1)
				offset[2] = starting_offset_y + (widget_size[2] + spacing) * (i - 1)
			end
		end

		self._grid_widgets = grid_widgets
	end
end

MinigameDecodeSymbolsView._draw_cursor = function (self, widgets_by_name, decode_start_time, on_target, gameplay_time)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_symbols)
	local current_decode_stage = minigame:current_stage()
	local widget_size = ScannerDisplayViewSettings.decode_symbol_widget_size
	local spacing = ScannerDisplayViewSettings.decode_symbol_spacing
	local starting_offset_x = ScannerDisplayViewSettings.decode_symbol_starting_offset_x
	local starting_offset_y = ScannerDisplayViewSettings.decode_symbol_starting_offset_y
	local symbols_per_stage = MinigameSettings.decode_symbols_items_per_stage
	local cursor_position = self:_get_cursor_position_from_time(decode_start_time, gameplay_time)
	local widget_target = widgets_by_name.symbol_frame
	widget_target.style.frame.offset[1] = starting_offset_x + (widget_size[1] + spacing) * (symbols_per_stage - 1) * cursor_position
	widget_target.style.frame.offset[2] = starting_offset_y + (widget_size[2] + spacing) * (current_decode_stage - 1)

	if on_target then
		widget_target.style.frame.color = {
			255,
			255,
			255,
			150
		}
	else
		widget_target.style.frame.color = {
			255,
			255,
			165,
			0
		}
	end
end

MinigameDecodeSymbolsView._draw_targets = function (self, widgets_by_name, decode_start_time, on_target)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_symbols)
	local decode_target = minigame:current_decode_target()
	local current_decode_stage = minigame:current_stage()
	local spacing = ScannerDisplayViewSettings.decode_symbol_spacing
	local widget_size = ScannerDisplayViewSettings.decode_symbol_widget_size
	local starting_offset_x = ScannerDisplayViewSettings.decode_symbol_starting_offset_x
	local starting_offset_y = ScannerDisplayViewSettings.decode_symbol_starting_offset_y
	local widget_target = widgets_by_name.symbol_highlight
	widget_target.style.highlight.offset[1] = starting_offset_x + (widget_size[1] + spacing) * (decode_target - 1)
	widget_target.style.highlight.offset[2] = starting_offset_y + (widget_size[2] + spacing) * (current_decode_stage - 1)

	if on_target then
		widget_target.style.highlight.color = {
			255,
			255,
			255,
			150
		}
	else
		widget_target.style.highlight.color = {
			255,
			255,
			165,
			0
		}
	end
end

MinigameDecodeSymbolsView._get_cursor_position_from_time = function (self, decode_start_time, time)
	local delta_time = time - decode_start_time
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.decode_symbols)
	local sweep_duration = minigame:sweep_duration()
	local mod = delta_time % (sweep_duration * 2)
	local alpha = 0

	if sweep_duration < mod then
		mod = mod - sweep_duration
		alpha = 1 - mod / sweep_duration
	else
		alpha = mod / sweep_duration
	end

	return alpha
end

return MinigameDecodeSymbolsView
