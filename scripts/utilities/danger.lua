-- chunkname: @scripts/utilities/danger.lua

local DangerSettings = require("scripts/settings/difficulty/danger_settings")
local QpCode = require("scripts/utilities/qp_code")
local Text = require("scripts/utilities/ui/text")
local DANGER_LEVELS = DangerSettings.danger_levels
local DANGER_LEVELS_BY_NAME = DangerSettings.danger_levels_by_name
local DEFAULT_DANGER_LEVEL = DangerSettings.default_danger_level
local Danger = {}
local _calculate_danger_level

Danger.danger_by_name = function (danger_name)
	return DANGER_LEVELS_BY_NAME[danger_name]
end

Danger.danger_by_qp_code = function (qp_code)
	local qp_keys = QpCode.decode(qp_code)
	local challenge, resistance = qp_keys.challenge, qp_keys.resistance

	return Danger.danger_by_difficulty(challenge, resistance)
end

Danger.danger_by_mission = function (mission_data)
	local challenge, resistance = mission_data.challenge, mission_data.resistance

	return Danger.danger_by_difficulty(challenge, resistance)
end

Danger.danger_by_difficulty = function (challenge, resistance)
	local index = _calculate_danger_level(challenge, resistance)

	if not index then
		local default_danger_settings = table.clone(DEFAULT_DANGER_LEVEL)

		default_danger_settings.challenge = challenge
		default_danger_settings.resistance = resistance

		return default_danger_settings
	end

	return DANGER_LEVELS[index]
end

Danger.required_level_by_mission_type = function (index, mission_type)
	return DANGER_LEVELS[index] and DANGER_LEVELS[index].unlocks_at
end

Danger.text_bars = function (difficulty_index)
	local difficulty_settings = DANGER_LEVELS[difficulty_index]
	local difficulty_color = difficulty_settings and difficulty_settings.color

	if not difficulty_color then
		return nil
	end

	local pre = Text.apply_color_to_text(" ", Color.terminal_text_header(255, true))
	local before = Text.apply_color_to_text(string.rep("", difficulty_index), difficulty_settings.color)
	local post = ""
	local remaining_count = #DANGER_LEVELS - difficulty_index

	if remaining_count > 0 then
		post = string.rep("", remaining_count)
	end

	return string.format("%s%s%s", pre, before, post)
end

Danger.index_by_name = function (danger_name)
	return DANGER_LEVELS_BY_NAME[danger_name].index
end

Danger.sort_missions_by_danger = function (missions)
	local function sort_func(a, b)
		local a_danger_level = _calculate_danger_level(a.challenge, a.resistance)
		local b_danger_level = _calculate_danger_level(b.challenge, b.resistance)

		return a_danger_level < b_danger_level
	end

	table.sort(missions, sort_func)
end

function _calculate_danger_level(challenge, resistance)
	local danger_by_index = DANGER_LEVELS

	for ii = 1, #danger_by_index do
		local danger = danger_by_index[ii]
		local correct_challenge = danger.challenge == challenge
		local correct_resistance = resistance == nil or danger.resistance == resistance

		if correct_challenge and correct_resistance then
			return ii
		end
	end
end

return Danger
