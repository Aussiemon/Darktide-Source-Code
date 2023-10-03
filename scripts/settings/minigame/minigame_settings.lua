local minigame_settings = {
	types = table.enum("none", "decode_symbols", "scan"),
	states = table.enum("none", "active", "completed")
}
minigame_settings.default_minigame_type = minigame_settings.types.decode_symbols
local num_stages = 4
local num_symbols_per_stage = 7
minigame_settings.decode_symbols_sweep_duration = 2
minigame_settings.decode_target_margin = 0.2
minigame_settings.disengage_view_angle_h = math.degrees_to_radians(76)
minigame_settings.disengage_view_angle_v = math.degrees_to_radians(62)
minigame_settings.decode_symbols_stage_amount = num_stages
minigame_settings.decode_symbols_items_per_stage = num_symbols_per_stage
minigame_settings.decode_symbols_total_items = num_stages * num_symbols_per_stage
minigame_settings.decode_search_stage_amount = 3
minigame_settings.decode_search_board_width = 6
minigame_settings.decode_search_board_height = 6
minigame_settings.decode_search_cursor_width = 2
minigame_settings.decode_search_cursor_height = 2
minigame_settings.decode_move_delay = 0.17
minigame_settings.decode_move_deadzone = 0.5
minigame_settings.decode_search_symbols = {
	{
		4,
		5,
		12,
		16
	},
	{
		3,
		8,
		9
	},
	{
		10,
		11,
		13,
		15,
		18
	},
	{
		1,
		2,
		7
	},
	{
		14,
		17,
		19,
		23
	},
	{
		20,
		21,
		22
	},
	{
		26,
		27,
		28
	},
	{
		6,
		24,
		25
	}
}
minigame_settings.frequency_search_stage_amount = 3
minigame_settings.frequency_width_min_scale = 1.5
minigame_settings.frequency_width_max_scale = 3
minigame_settings.frequency_height_min_scale = 1.5
minigame_settings.frequency_height_max_scale = 3.5
minigame_settings.frequency_speed = 1.5
local frequency_change_ratio = 0.75
minigame_settings.frequency_change_ratio_x = (minigame_settings.frequency_width_max_scale - minigame_settings.frequency_width_min_scale) * frequency_change_ratio
minigame_settings.frequency_change_ratio_y = (minigame_settings.frequency_height_max_scale - minigame_settings.frequency_height_min_scale) * frequency_change_ratio
minigame_settings.frequency_help_margin = 0.6
minigame_settings.frequency_help_power = 1
minigame_settings.frequency_success_margin = 0.1

return settings("MinigameSettings", minigame_settings)
