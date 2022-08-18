local minigame_settings = {
	types = table.enum("none", "decode_symbols", "scan")
}

local function _require_minigame_class(minigame)
	local base = "scripts/extension_systems/minigame/minigames/minigame_"
	local minigame_file_name = base .. minigame
	local class = require(minigame_file_name)

	return class
end

minigame_settings.minigame_classes = {
	none = _require_minigame_class("none"),
	decode_symbols = _require_minigame_class("decode_symbols"),
	scan = _require_minigame_class("scan")
}
minigame_settings.states = table.enum("none", "active", "completed")
local num_stages = 4
local num_symbols_per_stage = 7
minigame_settings.decode_needle_angle_sweep = math.degrees_to_radians(130)
minigame_settings.decode_needle_angle_sweep_offset = math.degrees_to_radians(25)
minigame_settings.decode_target_radii = {
	220,
	370,
	530
}
minigame_settings.decode_default_sweep_duration = 1
minigame_settings.decode_target_margin = 0.2
minigame_settings.disengage_view_angle_h = math.degrees_to_radians(70)
minigame_settings.disengage_view_angle_v = math.degrees_to_radians(58)
minigame_settings.decode_symbols_stage_amount = num_stages
minigame_settings.decode_symbols_items_per_stage = num_symbols_per_stage
minigame_settings.decode_symbols_total_items = num_stages * num_symbols_per_stage
minigame_settings.decode_symbols_target_margin = 1 / num_symbols_per_stage

return settings("MinigameSettings", minigame_settings)
