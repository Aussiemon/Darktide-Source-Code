-- chunkname: @scripts/ui/views/scanner_display_view/minigame_defuse_view.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewDefuseSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_defuse_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameDefuseView = class("MinigameDefuseView")

MinigameDefuseView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._option_widgets = {}
	self._target_widgets = {}
	self._wire_widgets = {}
	self._stage_widgets = {}
end

MinigameDefuseView.destroy = function (self)
	return
end

local system_name = "dialogue_system"

MinigameDefuseView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

MinigameDefuseView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.defuse)

	if not minigame:is_completed() then
		if #self._option_widgets == 0 then
			self:_create_option_widgets()
		end

		if #self._stage_widgets == 0 then
			self:_create_stage_widgets()
		end
	end

	if #self._option_widgets > 0 then
		if #self._target_widgets == 0 then
			self:_create_target_widgets()
		end

		local success = minigame:last_click_success()
		local state = minigame:state()
		local state_time = minigame:state_start_time()
		local transition = state == "transition" or state == "outro"
		local blink_time = MinigameSettings.decode_transition_time / 1.5
		local highlight = transition and state_time % blink_time < blink_time / 2

		self:_update_option(widgets_by_name, success, highlight)
		self:_update_cursor(widgets_by_name, success, highlight)
		self:_update_target(widgets_by_name, success, highlight)
	end
end

MinigameDefuseView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local wire_widgets = self._wire_widgets

	for i = 1, #wire_widgets do
		local widget = wire_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.defuse)
	local current_stage = minigame:current_stage()

	if not current_stage then
		return
	end

	if current_stage <= #self._target_widgets then
		local option_widgets = self._option_widgets[current_stage]

		for i = 1, #option_widgets do
			local widget = option_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end

		local target_widget = self._target_widgets[current_stage]

		UIWidget.draw(target_widget, ui_renderer)
	end

	if MinigameSettings.defuse_stage_amount > 1 then
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
end

MinigameDefuseView._create_option_widgets = function (self)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.defuse)
	local options = minigame:options()

	if #options > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDefuseSettings.symbol_widget_size
		local material_path = "content/ui/materials/backgrounds/scanner/"
		local material_prefix = "scanner_decode_"
		local spacing = ScannerDisplayViewDefuseSettings.symbol_spacing
		local starting_offset_x = ScannerDisplayViewDefuseSettings.option_starting_offset_x - (MinigameSettings.defuse_wire_count * widget_size[1] + spacing * (MinigameSettings.defuse_wire_count - 1)) / 2
		local starting_offset_y = ScannerDisplayViewDefuseSettings.option_starting_offset_y
		local option_widgets = {}

		for s = 1, MinigameSettings.defuse_stage_amount do
			local stage_options = options[s]
			local stage_widgets = {}

			for o = 1, MinigameSettings.defuse_wire_count do
				local widget_name = "symbol_" .. string.format("%02d", stage_options[o])
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

				stage_widgets[#stage_widgets + 1] = widget

				local offset = widget.offset

				offset[1] = starting_offset_x + (widget_size[1] + spacing) * (o - 1)
				offset[2] = starting_offset_y
				offset[3] = 2
			end

			option_widgets[s] = stage_widgets
		end

		self._option_widgets = option_widgets
	end
end

MinigameDefuseView._create_target_widgets = function (self)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.defuse)
	local targets = minigame:targets()

	if #targets > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDefuseSettings.symbol_widget_size
		local material_path = "content/ui/materials/backgrounds/scanner/"
		local material_prefix = "scanner_decode_"
		local starting_offset_x = ScannerDisplayViewDefuseSettings.target_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDefuseSettings.target_starting_offset_y
		local target_widgets = {}

		for s = 1, MinigameSettings.defuse_stage_amount do
			local widget_name = "symbol_" .. string.format("%02d", targets[s])
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
			local offset = widget.offset

			offset[1] = starting_offset_x
			offset[2] = starting_offset_y
			offset[3] = 2
			target_widgets[s] = widget
		end

		self._target_widgets = target_widgets
	end
end

MinigameDefuseView._create_stage_widgets = function (self)
	local stages = MinigameSettings.defuse_stage_amount

	if stages > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDefuseSettings.symbol_widget_size
		local starting_offset_x = ScannerDisplayViewDefuseSettings.stages_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDefuseSettings.stages_starting_offset_y
		local spacing = ScannerDisplayViewDefuseSettings.stage_spacing
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

MinigameDefuseView._update_option = function (self, widgets_by_name, success)
	return
end

MinigameDefuseView._update_cursor = function (self, widgets_by_name, success, highlight)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.defuse)
	local selected = minigame:selected()
	local widget_target = widgets_by_name.symbol_frame
	local widget_option = self._option_widgets[1][selected]

	widget_target.style.frame.offset[1] = widget_option.offset[1]
	widget_target.style.frame.offset[2] = widget_option.offset[2]
	widget_target.style.frame.offset[3] = 3

	if highlight then
		if success then
			widget_target.style.frame.color = {
				255,
				255,
				255,
				255,
			}
		else
			widget_target.style.frame.color = {
				255,
				255,
				0,
				0,
			}
		end
	else
		widget_target.style.frame.color = {
			255,
			255,
			165,
			0,
		}
	end
end

MinigameDefuseView._update_target = function (self, widgets_by_name, success)
	return
end

return MinigameDefuseView
