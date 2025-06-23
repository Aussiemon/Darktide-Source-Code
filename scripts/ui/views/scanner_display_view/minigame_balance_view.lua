-- chunkname: @scripts/ui/views/scanner_display_view/minigame_balance_view.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewBalanceSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_balance_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameBalanceView = class("MinigameBalanceView")

MinigameBalanceView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._progress_widgets = {}
end

MinigameBalanceView.destroy = function (self)
	return
end

local system_name = "dialogue_system"

MinigameBalanceView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

local COLOR_STALLED = {
	255,
	196,
	116,
	22
}
local COLOR_PROGRESSING = {
	255,
	0,
	196,
	0
}

MinigameBalanceView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.balance)

	if not minigame:is_completed() then
		if #self._progress_widgets == 0 then
			self:_create_progress_widgets()
		end

		local progressing = minigame:progressing()
		local widget_target = widgets_by_name.balance_progress
		local widget_style = widget_target.style.progress_texture

		widget_style.color = progressing and COLOR_PROGRESSING or COLOR_STALLED
	end

	self:_update_cursor(widgets_by_name)
end

MinigameBalanceView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local progress_widgets = self._progress_widgets
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.balance)
	local progress = minigame:progression()

	for i = 1, #progress_widgets do
		local widget = progress_widgets[i]

		widget.style.progress_bar.size[2] = widget.content.size[2] * (1 - progress)

		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameBalanceView._create_progress_widgets = function (self)
	local scenegraph_id = "center_pivot"
	local widget_size = ScannerDisplayViewBalanceSettings.progress_widget_size
	local starting_offset_x = ScannerDisplayViewBalanceSettings.progress_starting_offset_x
	local starting_offset_y = ScannerDisplayViewBalanceSettings.progress_starting_offset_y
	local pass_definitions = {
		{
			value = "content/ui/materials/backgrounds/default_square",
			style_id = "progress_bar",
			pass_type = "rotated_texture",
			style = {
				hdr = true,
				size = {},
				color = {
					200,
					0,
					0,
					0
				}
			}
		}
	}
	local progress_widgets = {}

	for i = 1, 2 do
		local widget_name = "progress_0" .. tostring(i)
		local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_id, nil, widget_size)
		local widget = UIWidget.init(widget_name, widget_definition)

		progress_widgets[#progress_widgets + 1] = widget

		local offset = widget.offset

		offset[1] = starting_offset_x * (i % 2 * 2 - 1) - widget_size[1] / 2
		offset[2] = starting_offset_y
		offset[3] = 1
	end

	self._progress_widgets = progress_widgets
end

local CURSOR_COLOR = {
	255,
	255,
	255,
	255
}
local CURSOR_ALERT = {
	255,
	255,
	151,
	29
}

MinigameBalanceView._update_cursor = function (self, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.balance)
	local stalled = not minigame:progressing()
	local widget_target = widgets_by_name.cursor
	local widget_style = widget_target.style.frame
	local position = minigame:position()
	local center_offset_x = ScannerDisplayViewBalanceSettings.center_offset_x
	local center_offset_y = ScannerDisplayViewBalanceSettings.center_offset_y

	widget_style.offset[1] = center_offset_x + position.x * ScannerDisplayViewBalanceSettings.board_width - widget_target.content.size[1] / 2
	widget_style.offset[2] = center_offset_y + position.y * ScannerDisplayViewBalanceSettings.board_height - widget_target.content.size[2] / 2
	widget_style.offset[3] = 3

	if stalled then
		widget_style.color[2] = 255
		widget_style.color[3] = 0
		widget_style.color[4] = 0
	else
		local alert_lerp = math.clamp(minigame:distance() * 2 - 0.5, 0, 1)

		widget_style.color[2] = math.lerp(CURSOR_COLOR[2], CURSOR_ALERT[2], alert_lerp)
		widget_style.color[3] = math.lerp(CURSOR_COLOR[3], CURSOR_ALERT[3], alert_lerp)
		widget_style.color[4] = math.lerp(CURSOR_COLOR[4], CURSOR_ALERT[4], alert_lerp)
	end
end

return MinigameBalanceView
