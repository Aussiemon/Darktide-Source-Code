-- chunkname: @scripts/ui/view_elements/view_element_session_stats/view_element_session_stats.lua

local Definitions = require("scripts/ui/view_elements/view_element_session_stats/view_element_session_stats_definitions")
local Settings = require("scripts/ui/view_elements/view_element_session_stats/view_element_session_stats_settings")
local SessionStatsDisplay = require("scripts/settings/stats/session_stats_display")
local Text = require("scripts/utilities/ui/text")
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local StatDefinitions = require("scripts/managers/stats/stat_definitions")
local ViewElementSessionStats = class("ViewElementSessionStats", "ViewElementBase")

local function read_local_value(stats_key, stat_name)
	if not stat_name then
		return nil
	end

	local flags = StatDefinitions[stat_name].flags

	if flags.hook or flags.no_sync then
		return nil
	end

	return math.round(Managers.stats:read_user_stat(stats_key, stat_name))
end

ViewElementSessionStats.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementSessionStats.super.init(self, parent, draw_layer, start_scale, Definitions)

	local title_widget = self._widgets_by_name.title

	title_widget.content.reveal_bottom = Settings.title_height

	local context_time = context and context.session_time_seconds

	self:set_mission_time(context_time)

	local header_widget = self._widgets_by_name.column_headers
	local header_content = header_widget.content

	header_content.label = ""

	local local_player = Managers.player:local_player(1)

	header_content.own = local_player and local_player:name() or Localize(Settings.private_column_loc_key)
	header_content.team = Localize(Settings.team_column_loc_key)
	header_content.reveal_bottom = Settings.title_height + Settings.row_height

	self:_populate_rows()

	self._expanded = false
	self._expand_progress = 0

	self:_apply_expand_progress(0)
end

ViewElementSessionStats.set_pivot_offset = function (self, x, y)
	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementSessionStats.set_mission_time = function (self, seconds)
	local title_widget = self._widgets_by_name.title

	if seconds then
		local minutes = math.floor(seconds / 60)
		local remaining_seconds = math.floor(seconds % 60)

		title_widget.content.text = Localize(Settings.total_time_loc_key, true, {
			minutes = minutes,
			seconds = remaining_seconds,
		})
	else
		title_widget.content.text = ""
	end
end

ViewElementSessionStats._padding_prompt_widget = function (self)
	return self._widgets_by_name["session_stat_padding_" .. Settings.num_padding_rows]
end

ViewElementSessionStats.set_collapse_prompt_text = function (self, loc_key, action)
	local service_type = DefaultViewInputSettings.service_type
	local text = Text.localize_with_button_hint(action, loc_key, nil, service_type, Localize("loc_input_legend_text_template"))

	self:_padding_prompt_widget().content.text = text
end

ViewElementSessionStats.set_collapse_callback = function (self, pressed_callback)
	self:_padding_prompt_widget().content.hotspot.pressed_callback = pressed_callback
end

ViewElementSessionStats.expanded = function (self)
	return self._expanded
end

ViewElementSessionStats.set_expanded = function (self, expanded)
	self._expanded = expanded

	Managers.telemetry_events:eor_session_stats_toggled(Managers.player:local_player(1), expanded)
end

ViewElementSessionStats.set_expand_time = function (self, seconds)
	self._expand_time = seconds
end

ViewElementSessionStats.update = function (self, dt, t, input_service)
	local target = self._expanded and 1 or 0
	local progress = self._expand_progress

	if progress ~= target then
		local step = dt / (self._expand_time or Settings.expand_time)

		progress = progress < target and math.min(progress + step, 1) or math.max(progress - step, 0)
		self._expand_progress = progress

		self:_apply_expand_progress(progress)
	end

	return ViewElementSessionStats.super.update(self, dt, t, input_service)
end

ViewElementSessionStats._apply_expand_progress = function (self, progress)
	local eased = math.easeOutCubic(progress)
	local revealed_height = self._full_height * eased

	self:_set_scenegraph_size("panel", nil, revealed_height)
	self:set_alpha_multiplier(eased)
	self:set_visibility(revealed_height > 0)

	local widgets = self._widgets

	for i = 1, #widgets do
		local widget = widgets[i]
		local reveal_bottom = widget.content.reveal_bottom

		if reveal_bottom then
			widget.visible = reveal_bottom <= revealed_height
		end
	end
end

ViewElementSessionStats._populate_rows = function (self)
	local row_height = Settings.row_height
	local rows_y = Settings.title_height + row_height
	local unavailable_text = Localize(Settings.unavailable_loc_key)
	local widgets = self._widgets
	local num_rows = #SessionStatsDisplay
	local local_player = Managers.player:local_player(1)
	local stats_key = local_player and local_player:local_player_id()
	local pushed_rows = stats_key and Managers.stats:leaderboard_session_stats(stats_key)
	local game_session = not pushed_rows and Managers.state and Managers.state.game_session
	local live_key = game_session and game_session:is_client() and stats_key or nil

	if live_key and Managers.stats:user_state(live_key) == nil then
		live_key = nil
	end

	for i = 1, num_rows do
		local widget = self:_create_widget("session_stat_row_" .. i, Definitions.row_definition)

		widget.offset[2] = (i - 1) * row_height

		local row = SessionStatsDisplay[i]
		local content = widget.content

		content.label = Localize(row.display_name)

		local pushed = pushed_rows and pushed_rows[i]
		local own_value = pushed and pushed.private or live_key and read_local_value(live_key, row.private)
		local team_value = pushed and pushed.team or live_key and read_local_value(live_key, row.team)
		local format_value = row.format_value

		content.own = row.private and (own_value and format_value(own_value) or unavailable_text) or ""
		content.team = row.team and (team_value and format_value(team_value) or unavailable_text) or ""
		content.reveal_bottom = rows_y + i * row_height

		if i % 2 == 0 then
			widget.style.shade.default_color[1] = Definitions.row_shade_alpha
		end

		widgets[#widgets + 1] = widget
	end

	local num_padding_rows = Settings.num_padding_rows

	for k = 1, num_padding_rows do
		local widget = self:_create_widget("session_stat_padding_" .. k, Definitions.padding_definition)

		widget.offset[2] = (num_rows + k - 1) * row_height
		widget.content.reveal_bottom = rows_y + (num_rows + k) * row_height

		if (num_rows + 1) % 2 == 0 then
			widget.style.shade.color[1] = Definitions.row_shade_alpha
			widget.style.shade.default_color[1] = Definitions.row_shade_alpha
		end

		if k < num_padding_rows then
			widget.content.hotspot.visible = false
		end

		widgets[#widgets + 1] = widget
	end

	self._full_height = rows_y + (num_rows + num_padding_rows) * row_height + Settings.bottom_padding
end

return ViewElementSessionStats
