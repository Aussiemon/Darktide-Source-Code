-- chunkname: @scripts/ui/views/scanner_display_view/minigame_frequency_view.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewFrequencySettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_frequency_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameFrequencyView = class("MinigameFrequencyView")

MinigameFrequencyView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._frequency_widgets = {}
	self._stage_widgets = {}
end

MinigameFrequencyView.destroy = function (self)
	return
end

local system_name = "dialogue_system"

MinigameFrequencyView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

MinigameFrequencyView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.frequency)

	if not minigame:is_completed() then
		if #self._stage_widgets == 0 then
			self:_create_stage_widgets()
		end

		if #self._frequency_widgets == 0 and minigame:frequency() then
			self:_create_frequency_widgets("selector")
		end
	end
end

MinigameFrequencyView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.frequency)
	local current_stage = minigame:current_stage()

	if not current_stage then
		return
	end

	local on_target = minigame:is_visually_on_target()
	local target_frequency = minigame:target_frequency()
	local frequency

	if on_target then
		frequency = target_frequency
	else
		frequency = minigame:frequency()
	end

	local color

	color = {
		255,
		0,
		128,
		0
	}

	self:_draw_frequency(target_frequency, color, t, ui_renderer)

	if on_target then
		color = {
			255,
			255,
			255,
			150
		}
	else
		color = {
			255,
			255,
			165,
			0
		}
	end

	self:_draw_frequency(frequency, color, t, ui_renderer)

	local stage_widgets = self._stage_widgets

	for i = 1, #stage_widgets do
		local widget = stage_widgets[i]

		if i == current_stage then
			widget.style.highlight.color = {
				255,
				0,
				255,
				0
			}
		elseif i < current_stage then
			widget.style.highlight.color = {
				128,
				0,
				128,
				0
			}
		else
			widget.style.highlight.color = {
				64,
				0,
				64,
				0
			}
		end

		UIWidget.draw(widget, ui_renderer)
	end
end

local WIDGET_SCALE_SIZE = {}

MinigameFrequencyView._draw_frequency = function (self, frequency, color, t, ui_renderer)
	if #self._frequency_widgets == 0 then
		return
	end

	local starting_offset_x = ScannerDisplayViewFrequencySettings.frequency_starting_offset_x
	local starting_offset_y = ScannerDisplayViewFrequencySettings.frequency_starting_offset_y
	local frequency_width = ScannerDisplayViewFrequencySettings.frequency_width
	local widget_width = ScannerDisplayViewFrequencySettings.frequency_widget_size[1] * frequency.x
	local widget_height = ScannerDisplayViewFrequencySettings.frequency_widget_size[2] * frequency.y

	WIDGET_SCALE_SIZE[1] = widget_width
	WIDGET_SCALE_SIZE[2] = widget_height

	local max_widgets = frequency_width / WIDGET_SCALE_SIZE[1] + 2
	local frequency_widgets = self._frequency_widgets

	for i = 1, max_widgets do
		local widget = frequency_widgets[i]

		widget.content.size = WIDGET_SCALE_SIZE
		widget.style.style_id_1.color = color
		widget.offset[1] = starting_offset_x + widget_width * (i - 0.5 - t * MinigameSettings.frequency_speed % 1 - math.floor(max_widgets * 0.5))
		widget.offset[2] = starting_offset_y - widget_height * 0.5
		widget.offset[3] = 1

		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameFrequencyView._create_stage_widgets = function (self)
	local stages = MinigameSettings.frequency_search_stage_amount

	if stages > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewFrequencySettings.stage_widget_size
		local starting_offset_x = ScannerDisplayViewFrequencySettings.stages_starting_offset_x
		local starting_offset_y = ScannerDisplayViewFrequencySettings.stages_starting_offset_y
		local spacing = ScannerDisplayViewFrequencySettings.stage_spacing
		local pass_definitions = {
			{
				value = "content/ui/materials/backgrounds/default_square",
				style_id = "highlight",
				pass_type = "texture",
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
			offset[3] = 3
		end

		self._stage_widgets = stage_widgets
	end
end

MinigameFrequencyView._create_frequency_widgets = function (self, name)
	local widgets = self._frequency_widgets
	local frequency_width = ScannerDisplayViewFrequencySettings.frequency_width
	local scenegraph_id = "center_pivot"
	local base_widget_size = ScannerDisplayViewFrequencySettings.frequency_widget_size
	local max_widgets = frequency_width / (MinigameSettings.frequency_width_min_scale * base_widget_size[1]) + 2
	local widget_size = table.clone(base_widget_size)

	widget_size[1] = widget_size[1]
	widget_size[2] = widget_size[2]

	local material_path = "content/ui/materials/backgrounds/scanner/scanner_sine_wave_01"
	local color = {
		255,
		0,
		255,
		0
	}

	for x = 1, max_widgets do
		local widget_name = "target_frequency_" .. name .. "_"

		if x < 7 then
			widget_name = widget_name .. "0" .. tostring(x)
		else
			widget_name = widget_name .. tostring(x)
		end

		local widget_definition = UIWidget.create_definition({
			{
				pass_type = "texture",
				value = material_path,
				style = {
					hdr = true,
					color = color
				}
			}
		}, scenegraph_id, nil, widget_size)
		local widget = UIWidget.init(widget_name, widget_definition)

		widgets[#widgets + 1] = widget

		local offset = widget.offset

		offset[1] = 0
		offset[2] = 0
	end
end

return MinigameFrequencyView
