-- chunkname: @scripts/settings/minigame/minigame_settings.lua

local minigame_settings = {}

minigame_settings.types = table.enum("none", "balance", "decode_symbols", "drill", "frequency")
minigame_settings.states = table.enum("none", "active", "completed")
minigame_settings.game_states = table.enum("none", "intro", "gameplay", "transition", "outro")
minigame_settings.default_minigame_type = minigame_settings.types.decode_symbols
minigame_settings.balance_move_ratio = 4.2
minigame_settings.balance_push_ratio = 1.08
minigame_settings.balance_disrupt_interval = 2.5
minigame_settings.balance_disrupt_power = 0.6
minigame_settings.balance_max_speed = 6
minigame_settings.balance_sound_block = 0.4

local num_stages = 4
local num_symbols_per_stage = 7

minigame_settings.decode_symbols_sweep_duration = 2
minigame_settings.decode_target_margin = 0.2
minigame_settings.disengage_view_angle_h = math.degrees_to_radians(76)
minigame_settings.disengage_view_angle_v = math.degrees_to_radians(62)
minigame_settings.decode_symbols_stage_amount = num_stages
minigame_settings.decode_symbols_items_per_stage = num_symbols_per_stage
minigame_settings.decode_symbols_total_items = num_stages * num_symbols_per_stage
minigame_settings.frequency_search_stage_amount = 3
minigame_settings.frequency_width_min_scale = 1.5
minigame_settings.frequency_width_max_scale = 3
minigame_settings.frequency_height_min_scale = 1.5
minigame_settings.frequency_height_max_scale = 3.5
minigame_settings.frequency_speed = 1.5

local frequency_change_ratio = 0.75

minigame_settings.frequency_change_ratio_x = (minigame_settings.frequency_width_max_scale - minigame_settings.frequency_width_min_scale) * frequency_change_ratio
minigame_settings.frequency_change_ratio_y = (minigame_settings.frequency_height_max_scale - minigame_settings.frequency_height_min_scale) * frequency_change_ratio
minigame_settings.frequency_success_margin = 0.1
minigame_settings.frequency_directional_control = true
minigame_settings.frequency_driection_change_ratio = 100
minigame_settings.frequency_help_enabled = true
minigame_settings.frequency_help_margin = 0.6
minigame_settings.frequency_help_power = 1
minigame_settings.drill_transition_time = 0.6
minigame_settings.drill_search_time = 0.5
minigame_settings.drill_stage_amount = 3
minigame_settings.drill_stage_targets = 5
minigame_settings.drill_move_delay = 0.25
minigame_settings.drill_move_distance_power = 0.75

return settings("MinigameSettings", minigame_settings)
