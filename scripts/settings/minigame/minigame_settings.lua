-- chunkname: @scripts/settings/minigame/minigame_settings.lua

local minigame_settings = {}

minigame_settings.types = table.enum("none", "decode_symbols", "drill", "scan")
minigame_settings.states = table.enum("none", "active", "completed")
minigame_settings.game_states = table.enum("none", "intro", "gameplay", "transition", "outro")
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
minigame_settings.drill_transition_time = 0.6
minigame_settings.drill_search_time = 0.5
minigame_settings.drill_stage_amount = 3
minigame_settings.drill_stage_targets = 5
minigame_settings.drill_move_delay = 0.25
minigame_settings.drill_move_distance_power = 0.75

return settings("MinigameSettings", minigame_settings)
