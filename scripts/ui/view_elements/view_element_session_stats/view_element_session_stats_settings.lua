-- chunkname: @scripts/ui/view_elements/view_element_session_stats/view_element_session_stats_settings.lua

local column_spacing = 50
local label_column_width = 330
local value_column_width = 220
local num_value_columns = 2
local panel_padding = 20
local scale = 1.25

column_spacing = column_spacing * scale
label_column_width = label_column_width * scale
value_column_width = value_column_width * scale
panel_padding = panel_padding * scale

local view_element_session_stats_settings = {
	expand_time = 0.25,
	highlighted_material = "content/ui/materials/font_gradients/slug_font_gradient_gold",
	num_padding_rows = 2,
	private_column_loc_key = "loc_view_element_session_stats_stat_column_mine",
	team_column_loc_key = "loc_view_element_session_stats_stat_column_team",
	title_loc_key = "loc_view_element_session_stats_title",
	total_time_loc_key = "loc_end_view_stat_title_total_time",
	unavailable_loc_key = "loc_view_element_session_stats_stat_unavailable",
	panel_width = 2 * panel_padding + label_column_width + num_value_columns * (column_spacing + value_column_width),
	panel_padding = panel_padding,
	title_height = 44 * scale,
	row_height = 30 * scale,
	column_spacing = column_spacing,
	label_column_width = label_column_width,
	value_column_width = value_column_width,
	debug_height = 26 * scale,
	bottom_padding = 12 * scale,
}

return settings("ViewElementSessionStatsSettings", view_element_session_stats_settings)
