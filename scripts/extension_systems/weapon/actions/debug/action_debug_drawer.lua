-- chunkname: @scripts/extension_systems/weapon/actions/debug/action_debug_drawer.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local ActionDebugDrawer = class("ActionDebugDrawer")
local _screenspace_position, _chain_actions_size_y, _action_duration, _timeline_bars_size_y
local DRAWER_ALIGNMENT_X = "right"
local DRAWER_ALIGNMENT_Y = "top"
local DRAWER_POS_X = 0
local DRAWER_POS_Y = 0
local DRAWER_LAYER = 10
local DRAWER_SIZE_X = 540
local ACTION_NAME_FONT_SIZE = 18
local TIMELINE_SIZE_X = DRAWER_SIZE_X * 0.95
local TIMELINEBAR_POS_Y = 40
local TIMELINEBAR_OFFSET_Y = 20 + ACTION_NAME_FONT_SIZE
local TIMELINEBAR_SIZE_Y = 4
local TIMELINEBAR_INDICATOR_Y = 4
local TIMELINEBAR_INDICATOR_SIZE_X = 2
local TIMELINEBAR_INDICATOR_SIZE_Y = 5
local CHAIN_ACTION_BAR_POS_Y = 30 + ACTION_NAME_FONT_SIZE * 2
local CHAIN_ACTION_BAR_SIZE_Y = 15
local CHAIN_ACTION_BAR_GAP = 2
local CHAIN_ACTION_BAR_OFFSET_Y = CHAIN_ACTION_BAR_SIZE_Y + CHAIN_ACTION_BAR_GAP
local VARIABLE_POS_X = 10
local VARIABLE_POS_Y = 40
local VARIABLE_OFFSET_Y = 20
local EMPTY_TABLE = {}

ActionDebugDrawer.init = function (self, action_settings, weapon_action_component)
	self._action_settings = action_settings
	self._weapon_action_component = weapon_action_component
	self._variables = {}
	self._timeline_bars = {}
end

ActionDebugDrawer.reset = function (self)
	self._variables = {}
	self._timeline_bars = {}
end

ActionDebugDrawer.draw = function (self, has_running_action)
	local gui = Debug:debug_gui()
	local added_height = self:_added_background_height()
	local bg_pos, bg_size = self:_draw_background(gui, added_height)

	self:_draw_action_name(gui, bg_pos, has_running_action)
	self:_draw_chain_actions(gui, bg_pos, bg_size)
	self:_draw_timeline_indicator(gui, bg_pos, bg_size)
	self:_draw_timeline_bars(gui, bg_pos, bg_size)
	self:_draw_variables(gui, bg_pos, bg_size)
end

ActionDebugDrawer.add_variable = function (self, name, source, id)
	self._variables[#self._variables + 1] = {
		name = name,
		source = source,
		id = id
	}
end

ActionDebugDrawer.add_timeline_bar = function (self, name, indicators)
	self._timeline_bars[#self._timeline_bars + 1] = {
		name = name,
		indicators = indicators
	}
end

ActionDebugDrawer._added_background_height = function (self)
	local chain_action_size_y = _chain_actions_size_y(self._action_settings)
	local timeline_bars_size_y = TIMELINEBAR_OFFSET_Y * #self._timeline_bars
	local variables_size_y = VARIABLE_OFFSET_Y * #self._variables

	return chain_action_size_y + timeline_bars_size_y + variables_size_y
end

ActionDebugDrawer._draw_background = function (self, gui, added_height)
	local bg_size = Vector2(DRAWER_SIZE_X, 40 + added_height + ACTION_NAME_FONT_SIZE * 2)
	local x, y = _screenspace_position(DRAWER_POS_X, DRAWER_POS_Y, bg_size, DRAWER_ALIGNMENT_X, DRAWER_ALIGNMENT_Y)
	local bg_pos = Vector3(x, y, DRAWER_LAYER)

	Gui.rect(gui, bg_pos, bg_size, Color.black(200))

	return bg_pos, bg_size
end

ActionDebugDrawer._draw_action_name = function (self, gui, anchor_position, has_running_action)
	local text_pos = Vector3(anchor_position.x + 10, anchor_position.y + 5, DRAWER_LAYER + 1)
	local weapon_action_component = self._weapon_action_component
	local action_start_t = weapon_action_component.start_t
	local action_end_t = weapon_action_component.end_t
	local latest_fixed_t = FixedFrame.get_latest_fixed_time()
	local time_in_action = latest_fixed_t - action_start_t

	if not has_running_action then
		time_in_action = action_end_t - action_start_t
	end

	local action_settings = self._action_settings
	local action_timeline = _action_duration(self._weapon_action_component, action_settings)
	local text = string.format("%s\nrunning time: %.3f\ntotal time: %.3f (%.3f)", action_settings.name, time_in_action, action_timeline, action_settings.total_time)

	Gui.slug_text(gui, text, DevParameters.debug_text_font, ACTION_NAME_FONT_SIZE, text_pos, Vector3(DRAWER_SIZE_X, ACTION_NAME_FONT_SIZE * 3, 0), Color.cheeseburger())
end

ActionDebugDrawer._draw_single_chain_action = function (self, action_timeline, time_scale, chain_action_index, chain_action, gui, anchor_position, anchor_size, extra_background_y_size, action_available)
	local bar_size_x = TIMELINE_SIZE_X
	local chain_time = chain_action.chain_time or 0
	local chain_start_t = chain_time / time_scale
	local chain_end_t = action_timeline
	local chain_time_window = chain_end_t == math.huge and 1 or chain_end_t - chain_start_t

	chain_time_window = action_timeline > 0 and chain_time_window / action_timeline or 0

	local offset_y = CHAIN_ACTION_BAR_OFFSET_Y * (chain_action_index - 1)
	local chain_bar_size_x = bar_size_x * chain_time_window
	local pos = Vector3(anchor_position.x + (anchor_size.x - bar_size_x) * 0.5 + (bar_size_x - chain_bar_size_x), CHAIN_ACTION_BAR_POS_Y + offset_y, DRAWER_LAYER + 1)
	local size = Vector2(chain_bar_size_x, CHAIN_ACTION_BAR_SIZE_Y + (extra_background_y_size or 0))
	local chain_color = chain_action.auto_chain and Color.red() or Color.cheeseburger()
	local font_size = 12
	local chain_action_name = chain_action.action_name or "missing"

	Gui.rect(gui, pos, size, chain_color)
	Gui.slug_text(gui, chain_action_name, DevParameters.debug_text_font, font_size, pos + Vector3(2, CHAIN_ACTION_BAR_SIZE_Y * 0.5 - font_size * 0.5 - 1, 1), nil, Color.black())
end

ActionDebugDrawer._draw_chain_actions = function (self, gui, anchor_position, anchor_size)
	local action_settings = self._action_settings
	local weapon_action_component = self._weapon_action_component
	local allowed_chain_actions = action_settings.allowed_chain_actions or EMPTY_TABLE
	local action_timeline = _action_duration(self._weapon_action_component, action_settings)
	local time_scale = weapon_action_component.time_scale
	local chain_action_index = 0

	for chain_id, chain_action in pairs(allowed_chain_actions) do
		local num_chain_actions = #chain_action

		if num_chain_actions == 0 then
			chain_action_index = chain_action_index + 1

			self:_draw_single_chain_action(action_timeline, time_scale, chain_action_index, chain_action, gui, anchor_position, anchor_size)
		else
			for ii = 1, num_chain_actions do
				chain_action_index = chain_action_index + 1

				local extra_background_y_size = ii < num_chain_actions and CHAIN_ACTION_BAR_GAP or 0

				self:_draw_single_chain_action(action_timeline, time_scale, chain_action_index, chain_action[ii], gui, anchor_position, anchor_size, extra_background_y_size)
			end
		end
	end

	return CHAIN_ACTION_BAR_OFFSET_Y * chain_action_index
end

ActionDebugDrawer._draw_timeline_indicator = function (self, gui, anchor_position, anchor_size)
	local bar_size_x = TIMELINE_SIZE_X
	local weapon_action_component = self._weapon_action_component
	local action_start_t = weapon_action_component.start_t
	local action_end_t = weapon_action_component.end_t
	local latest_fixed_t = FixedFrame.get_latest_fixed_time()
	local action_timeline = action_end_t - action_start_t
	local current_t = latest_fixed_t - action_start_t
	local p = action_timeline == 0 and 0 or current_t / action_timeline
	local pos_x = anchor_position.x + anchor_size.x * 0.5 - bar_size_x * 0.5 + bar_size_x * p
	local pos_y = anchor_position.y + 23 + ACTION_NAME_FONT_SIZE * 2
	local pos = Vector3(pos_x, pos_y, DRAWER_LAYER + 2)
	local chain_action_size_y = _chain_actions_size_y(self._action_settings)
	local timeline_bars_size_y = _timeline_bars_size_y(self._timeline_bars)
	local size_x = 2
	local size_y = 10 + timeline_bars_size_y + chain_action_size_y
	local size = Vector2(size_x, size_y)

	Gui.rect(gui, pos, size, Color.white())
end

ActionDebugDrawer._draw_timeline_bars = function (self, gui, anchor_position, anchor_size)
	local bar_size_x = TIMELINE_SIZE_X
	local timeline_bars = self._timeline_bars
	local action_settings = self._action_settings
	local chain_action_size_y = _chain_actions_size_y(action_settings)
	local action_timeline = _action_duration(self._weapon_action_component, action_settings)
	local timeline_bar_layer = DRAWER_LAYER + 1

	for timeline_i = 1, #timeline_bars do
		local timeline_bar = timeline_bars[timeline_i]
		local pos_x = anchor_position.x + anchor_size.x * 0.5 - bar_size_x * 0.5
		local pos_y = anchor_position.y + chain_action_size_y + TIMELINEBAR_POS_Y + TIMELINEBAR_OFFSET_Y * (timeline_i - 1) + ACTION_NAME_FONT_SIZE * 2
		local pos = Vector3(pos_x, pos_y, timeline_bar_layer)

		Gui.slug_text(gui, timeline_bar.name, DevParameters.debug_text_font, ACTION_NAME_FONT_SIZE * 0.75, pos, nil, Color.white())

		pos.y = pos.y + ACTION_NAME_FONT_SIZE

		local size = Vector2(bar_size_x, TIMELINEBAR_SIZE_Y)

		Gui.rect(gui, pos, size, Color.white())

		local indicators = timeline_bar.indicators

		for indicator_i = 1, #indicators do
			local indicator = indicators[indicator_i]
			local p = action_timeline > 0 and indicator.time / action_timeline or 0
			local x = pos_x + bar_size_x * p
			local y = pos_y + TIMELINEBAR_INDICATOR_Y + ACTION_NAME_FONT_SIZE
			local indicator_pos = Vector3(x, y, timeline_bar_layer + 1)
			local indicator_size = Vector2(TIMELINEBAR_INDICATOR_SIZE_X, TIMELINEBAR_INDICATOR_SIZE_Y)
			local color = Color[indicator.color]()

			Gui.rect(gui, indicator_pos, indicator_size, color)
		end
	end
end

ActionDebugDrawer._draw_variables = function (self, gui, anchor_position)
	local variables = self._variables
	local timeline_bars_size_y = _timeline_bars_size_y(self._timeline_bars)
	local chain_action_size_y = _chain_actions_size_y(self._action_settings)
	local font_size = 14

	for i = 1, #variables do
		local variable = variables[i]
		local source = variable.source
		local id = variable.id
		local name = variable.name
		local value = tostring(source[id])
		local text = string.format("%s - %s", name, value)
		local pos_x = anchor_position.x + VARIABLE_POS_X
		local pos_y = anchor_position.y + chain_action_size_y + timeline_bars_size_y + VARIABLE_OFFSET_Y * (i - 1) + VARIABLE_POS_Y + ACTION_NAME_FONT_SIZE * 2
		local pos = Vector3(pos_x, pos_y, DRAWER_LAYER + 1)

		Gui.slug_text(gui, text, DevParameters.debug_text_font, font_size, pos, nil, Color.white())
	end
end

function _screenspace_position(x, y, size, alignment_x, alignment_y)
	local w, h = Gui.resolution()
	local screenspace_x, screenspace_y

	if alignment_x == "center" then
		screenspace_x = w * 0.5 - size.x * 0.5 + x
	elseif alignment_x == "right" then
		screenspace_x = w - size.x + x
	else
		screenspace_x = x
	end

	if alignment_y == "center" then
		screenspace_y = h * 0.5 - size.y * 0.5 + y
	elseif alignment_y == "bottom" then
		screenspace_y = h - size.y + y
	else
		screenspace_y = y
	end

	return screenspace_x, screenspace_y
end

function _chain_actions_size_y(action_settings)
	local allowed_chain_actions = action_settings.allowed_chain_actions or EMPTY_TABLE
	local num_chain_actions = 0

	for chain_id, chain_action in pairs(allowed_chain_actions) do
		num_chain_actions = num_chain_actions + math.max(#chain_action, 1)
	end

	return num_chain_actions * CHAIN_ACTION_BAR_OFFSET_Y
end

function _action_duration(weapon_action_component, action_settings)
	if action_settings.total_time == math.huge then
		return 1
	end

	local time_scale = weapon_action_component.time_scale

	return action_settings.total_time / time_scale
end

function _timeline_bars_size_y(timeline_bars)
	return TIMELINEBAR_OFFSET_Y * #timeline_bars
end

return ActionDebugDrawer
