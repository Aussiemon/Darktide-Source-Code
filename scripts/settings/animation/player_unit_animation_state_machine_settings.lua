-- chunkname: @scripts/settings/animation/player_unit_animation_state_machine_settings.lua

local state_machine_settings = {}

local function _extract_state_machine_settings(path)
	local collection = require(path)

	for state_machine_name, settings in pairs(collection) do
		state_machine_settings[state_machine_name] = settings
	end
end

_extract_state_machine_settings("scripts/settings/animation/state_machine_ranged_first_person")
_extract_state_machine_settings("scripts/settings/animation/state_machine_ranged_third_person")
_extract_state_machine_settings("scripts/settings/animation/state_machine_melee_first_person")
_extract_state_machine_settings("scripts/settings/animation/state_machine_melee_third_person")
_extract_state_machine_settings("scripts/settings/animation/state_machine_misc_first_person")
_extract_state_machine_settings("scripts/settings/animation/state_machine_misc_third_person")

return settings("PlayerUnitAnimationStateMachineSettings", state_machine_settings)
