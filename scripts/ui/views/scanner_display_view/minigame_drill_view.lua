local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewDrillSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_drill_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local MinigameDrillView = class("MinigameDrillView")

MinigameDrillView.init = function (self, context)
	self._minigame_extension = context.minigame_extension
	self._target_widgets = {}
	self._stage_widgets = {}
	self._background_widgets = {}
end

MinigameDrillView.destroy = function (self)
	return
end

MinigameDrillView.update = function (self, dt, t, widgets_by_name)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.drill)

	if not minigame:is_completed() then
		if #self._background_widgets == 0 then
			self:_create_background_widgets()
		end

		if #self._target_widgets == 0 then
			self:_create_target_widgets()
		end

		if #self._stage_widgets == 0 then
			self:_create_stage_widgets()
		end
	end

	if #self._target_widgets > 0 then
		self:_update_target(widgets_by_name, minigame, t)
		self:_update_search(widgets_by_name, minigame)
		self:_update_cursor(widgets_by_name, minigame)
		self:_update_background(widgets_by_name, minigame)
	end
end

MinigameDrillView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.drill)
	local background_widgets = self._background_widgets

	for i = 1, #background_widgets do
		local widget = background_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	local current_stage = minigame:current_stage()
	local state = minigame:state()

	if not current_stage or current_stage > #self._target_widgets then
		return
	end

	if state == MinigameSettings.game_states.gameplay then
		local target_widgets = self._target_widgets[current_stage]

		for i = 1, #target_widgets do
			local widget = target_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local stage_widgets = self._stage_widgets

	for i = 1, #stage_widgets do
		local widget = stage_widgets[i]

		if i < current_stage or i == current_stage and t % 1 > 0.5 then
			widget.style.highlight.color = {
				255,
				0,
				255,
				0
			}
		else
			widget.style.highlight.color = {
				255,
				0,
				64,
				0
			}
		end

		UIWidget.draw(widget, ui_renderer)
	end
end

MinigameDrillView._create_stage_widgets = function (self)
	local stages = MinigameSettings.drill_stage_amount

	if stages > 0 then
		local scenegraph_id = "center_pivot"
		local widget_size = ScannerDisplayViewDrillSettings.stage_widget_size
		local starting_offset_x = ScannerDisplayViewDrillSettings.stages_starting_offset_x
		local starting_offset_y = ScannerDisplayViewDrillSettings.stages_starting_offset_y
		local spacing = ScannerDisplayViewDrillSettings.stage_spacing
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
			local widget_name = "stage_0" .. tostring(i)
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

MinigameDrillView._create_background_widgets = function (self)
	local scenegraph_id = "center_pivot"
	local widget_size = ScannerDisplayViewDrillSettings.background_rings_size
	local starting_offset_x = ScannerDisplayViewDrillSettings.board_starting_offset_x
	local starting_offset_y = ScannerDisplayViewDrillSettings.board_starting_offset_y
	local pass_definitions = {
		{
			value = "content/ui/materials/backgrounds/scanner/scanner_drill_wireframe_small",
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
	local background = {}

	for i = 1, 6 do
		local widget_name = "background_0" .. tostring(i)
		local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_id, nil, widget_size)
		local widget = UIWidget.init(widget_name, widget_definition)
		background[#background + 1] = widget
		local offset = widget.offset
		offset[1] = starting_offset_x - widget_size[1] / 2
		offset[2] = starting_offset_y - widget_size[2] / 2
		offset[3] = 1

		if i == 1 then
			pass_definitions[1].value = "content/ui/materials/backgrounds/scanner/scanner_drill_wireframe"
		end
	end

	self._background_widgets = background
end

MinigameDrillView._create_target_widgets = function (self)
	local minigame_extension = self._minigame_extension
	local minigame = minigame_extension:minigame(MinigameSettings.types.drill)
	local targets = minigame:targets()
	local stage_count = #targets

	if stage_count > 0 then
		local target_widgets = {}

		for stage = 1, stage_count do
			local stage_targets = targets[stage]
			local target_count = #stage_targets
			local scenegraph_id = "center_pivot"
			local widget_size = ScannerDisplayViewDrillSettings.target_widget_size
			local starting_offset_x = ScannerDisplayViewDrillSettings.board_starting_offset_x
			local starting_offset_y = ScannerDisplayViewDrillSettings.board_starting_offset_y
			local pass_definitions = {
				{
					value = "content/ui/materials/backgrounds/scanner/scanner_drill_circle_empty",
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

			for target_index = 1, target_count do
				local target = stage_targets[target_index]
				local widget_name = string.format("target_%s-%s", stage, target_index)
				local widget_definition = UIWidget.create_definition(pass_definitions, scenegraph_id, nil, widget_size)
				local widget = UIWidget.init(widget_name, widget_definition)
				stage_widgets[target_index] = widget
				local offset = widget.offset
				offset[1] = starting_offset_x + target.x * ScannerDisplayViewDrillSettings.board_width - widget_size[1] / 2
				offset[2] = starting_offset_y + target.y * ScannerDisplayViewDrillSettings.board_height - widget_size[2] / 2
				offset[3] = 4
			end

			target_widgets[stage] = stage_widgets
		end

		self._target_widgets = target_widgets
	end
end

local NO_TARGET = {
	x = 0,
	y = 0
}

MinigameDrillView._update_background = function (self, widgets_by_name, minigame)
	local stage = minigame:current_stage()
	local targets = minigame:targets()
	local correct_targets = minigame:correct_targets()

	if not stage or #correct_targets == 0 then
		return
	end

	local widget_size = ScannerDisplayViewDrillSettings.background_rings_size
	local starting_offset_x = ScannerDisplayViewDrillSettings.board_starting_offset_x
	local starting_offset_y = ScannerDisplayViewDrillSettings.board_starting_offset_y
	local state = minigame:state()
	local in_transition = state ~= MinigameSettings.game_states.gameplay
	local scale_percentage = 1
	local previous_pos = NO_TARGET
	local current_pos = NO_TARGET

	if stage > 2 then
		local s = stage - 2
		previous_pos = targets[s][correct_targets[s]]
	end

	if stage > 1 then
		local s = stage - 1
		current_pos = targets[s][correct_targets[s]]
	end

	local x_pos, y_pos = nil

	if in_transition then
		local t_gameplay = Managers.time:time("gameplay")
		local transition_percentage = minigame:transition_percentage(t_gameplay)
		local move_percentage = math.clamp(transition_percentage * 2, 0, 1)
		x_pos = math.lerp(previous_pos.x, current_pos.x, move_percentage)
		y_pos = math.lerp(previous_pos.y, current_pos.y, move_percentage)
		scale_percentage = math.clamp(transition_percentage * 2 - 1, 0, 1)
	else
		x_pos = current_pos.x
		y_pos = current_pos.y
	end

	x_pos = starting_offset_x + x_pos * ScannerDisplayViewDrillSettings.board_width
	y_pos = starting_offset_y + y_pos * ScannerDisplayViewDrillSettings.board_height
	local background_widgets = self._background_widgets

	for i = 1, #background_widgets do
		local widget = background_widgets[i]
		local size = widget.content.size
		local scale = (i - 1 + scale_percentage) / 3
		size[1] = widget_size[1] * scale
		size[2] = widget_size[2] * scale
		widget.offset[1] = x_pos - size[1] / 2
		widget.offset[2] = y_pos - size[2] / 2
	end
end

MinigameDrillView._update_target = function (self, widgets_by_name, minigame, t)
	local stage = minigame:current_stage()

	if not stage or stage > #self._target_widgets then
		return
	end

	local on_target = minigame:is_on_target()
	local selected_index = minigame:selected_index()
	local correct_target = minigame:correct_targets()[stage]
	local positions = minigame:targets()[stage]
	local target_position = positions[correct_target]
	local is_searching = minigame:is_searching()
	local t_gameplay = Managers.time:time("gameplay")
	local search_percentage = minigame:search_percentage(t_gameplay)
	local target_widgets = self._target_widgets[stage]

	for i = 1, #target_widgets do
		local widget = target_widgets[i]

		if selected_index == i and is_searching and search_percentage >= 1 then
			if on_target then
				widget.style.highlight.color = {
					255,
					255,
					255,
					255
				}
			else
				widget.style.highlight.color = {
					255,
					255,
					0,
					0
				}
			end
		else
			local target = positions[i]
			local distance = math.sqrt((target_position.x - target.x) * (target_position.x - target.x) + (target_position.y - target.y) * (target_position.y - target.y))
			local alpha = math.clamp(0.55 + math.cos(t + distance * 3) * 0.45, 0, 1)
			widget.style.highlight.color = {
				alpha * 255,
				0,
				255,
				0
			}
		end
	end
end

MinigameDrillView._update_search = function (self, widgets_by_name, minigame)
	local cursor_position = minigame:cursor_position()

	if not cursor_position then
		return
	end

	local state = minigame:state()
	local on_target = minigame:is_on_target()
	local t_gameplay = Managers.time:time("gameplay")
	local is_searching = minigame:is_searching()
	local search_percentage = minigame:search_percentage(t_gameplay)
	local starting_offset_x = ScannerDisplayViewDrillSettings.board_starting_offset_x
	local starting_offset_y = ScannerDisplayViewDrillSettings.board_starting_offset_y
	local widget = widgets_by_name.search_fade
	widget.style.frame.offset[1] = starting_offset_x + cursor_position.x * ScannerDisplayViewDrillSettings.board_width - widget.content.size[1] / 2
	widget.style.frame.offset[2] = starting_offset_y + cursor_position.y * ScannerDisplayViewDrillSettings.board_height - widget.content.size[2] / 2
	widget.style.frame.offset[3] = 3

	if state ~= MinigameSettings.game_states.gameplay then
		widget.style.frame.color = {
			0,
			0,
			0,
			0
		}
	elseif is_searching then
		if search_percentage >= 1 then
			if on_target then
				widget.style.frame.color = {
					255,
					255,
					255,
					255
				}
			else
				widget.style.frame.color = {
					255,
					255,
					0,
					0
				}
			end
		else
			local alpha = search_percentage * 255
			widget.style.frame.color = {
				alpha,
				0,
				255,
				0
			}
		end
	else
		widget.style.frame.color = {
			0,
			0,
			0,
			0
		}
	end
end

MinigameDrillView._update_cursor = function (self, widgets_by_name, minigame)
	local cursor_position = minigame:cursor_position()

	if not cursor_position then
		return
	end

	local state = minigame:state()
	local on_target = minigame:is_on_target()
	local t_gameplay = Managers.time:time("gameplay")
	local selected_index = minigame:selected_index()
	local search_percentage = minigame:search_percentage(t_gameplay)
	local starting_offset_x = ScannerDisplayViewDrillSettings.board_starting_offset_x
	local starting_offset_y = ScannerDisplayViewDrillSettings.board_starting_offset_y
	local widget = widgets_by_name.cursor
	widget.style.frame.offset[1] = starting_offset_x + cursor_position.x * ScannerDisplayViewDrillSettings.board_width - widget.content.size[1] / 2
	widget.style.frame.offset[2] = starting_offset_y + cursor_position.y * ScannerDisplayViewDrillSettings.board_height - widget.content.size[2] / 2
	widget.style.frame.offset[3] = 5

	if state ~= MinigameSettings.game_states.gameplay then
		widget.style.frame.color = {
			0,
			0,
			0,
			0
		}
	elseif on_target and search_percentage >= 1 then
		widget.style.frame.color = {
			255,
			255,
			255,
			150
		}
	elseif selected_index then
		widget.style.frame.color = {
			255,
			255,
			165,
			0
		}
	else
		widget.style.frame.color = {
			128,
			255,
			165,
			0
		}
	end
end

return MinigameDrillView
