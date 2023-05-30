local minigame_settings = {
	types = table.enum("none", "decode_symbols", "scan"),
	states = table.enum("none", "active", "completed")
}
local num_stages = 4
local num_symbols_per_stage = 7
minigame_settings.decode_symbols_sweep_duration = 2
minigame_settings.decode_target_margin = 0.2
minigame_settings.disengage_view_angle_h = math.degrees_to_radians(70)
minigame_settings.disengage_view_angle_v = math.degrees_to_radians(58)
minigame_settings.decode_symbols_stage_amount = num_stages
minigame_settings.decode_symbols_items_per_stage = num_symbols_per_stage
minigame_settings.decode_symbols_total_items = num_stages * num_symbols_per_stage
minigame_settings.decode_search_board_width = 8
minigame_settings.decode_search_board_height = 6
minigame_settings.decode_search_cursor_width = 2
minigame_settings.decode_search_cursor_height = 2
minigame_settings.decode_move_delay = 0.15
minigame_settings.frequency_width_min_scale = 0.7
minigame_settings.frequency_width_max_scale = 2.3
minigame_settings.frequency_height_min_scale = 1
minigame_settings.frequency_height_max_scale = 3
minigame_settings.frequency_speed = 1.5
minigame_settings.frequency_change_ratio = 1
minigame_settings.frequency_accuracy_margin = 0.1

return settings("MinigameSettings", minigame_settings)
