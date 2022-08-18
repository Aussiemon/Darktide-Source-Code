local state_machine_settings = {}

local function _extract_state_machine_settings(path)
	local collection = require(path)

	for state_machine_name, settings in pairs(collection) do
		fassert(state_machine_settings[state_machine_name] == nil, "Found duplicate entry for state_machine %q when running through path %q", state_machine_name, path)

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
