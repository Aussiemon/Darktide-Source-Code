-- chunkname: @scripts/managers/mutator/mutators/mutator_minion_extra_spread.lua

require("scripts/managers/mutator/mutators/mutator_base")

local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local MutatorMinionExtraSpread = class("MutatorMinionExtraSpread", "MutatorBase")
local FixedFrame = require("scripts/utilities/fixed_frame")
local FALLOFF_TIME = 2
local vortex_grabbed_time_stamps = {}
local HIT_CHANCE = 0.01

MutatorMinionExtraSpread.get_hitscan_template_override = function (self, target_unit)
	if HIT_CHANCE > math.random() then
		return
	end

	if not target_unit or not Unit.alive(target_unit) then
		return
	end

	local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local disabled_character_state_component = unit_data_extension.has_component and unit_data_extension:has_component("disabled_character_state") and unit_data_extension:read_component("disabled_character_state")

	if not disabled_character_state_component then
		return
	end

	local vortex_grabbed_timestamp = vortex_grabbed_time_stamps[target_unit]
	local t = FixedFrame.get_latest_fixed_time()
	local is_vortex_grabbed = PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component)

	if not is_vortex_grabbed and not vortex_grabbed_timestamp then
		return
	elseif vortex_grabbed_timestamp and t > vortex_grabbed_timestamp + FALLOFF_TIME then
		vortex_grabbed_time_stamps[target_unit] = nil

		return
	elseif is_vortex_grabbed then
		vortex_grabbed_time_stamps[target_unit] = t
	end

	return "filter_minion_shooting_geometry"
end

return MutatorMinionExtraSpread
