local Effect = {}

local function _is_follow_target_unit(target_unit_or_nil)
	local first_person_extension = ScriptUnit.has_extension(target_unit_or_nil, "first_person_system")
	local is_camera_follow_target = first_person_extension and first_person_extension:is_camera_follow_target() or false

	return is_camera_follow_target
end

local TARGETED_BY_RANGED_MINION_WWISE_PARAMETER = "targeted_by_ranged_minion"
local TARGETED_BY_SPECIAL_WWISE_PARAMETER = "targeted_by_special"
local TARGETED_BY_MELEE_WWISE_PARAMETER = "targeted_in_melee"

Effect.update_targeted_by_ranged_minion_wwise_parameters = function (target_unit_or_nil, wwise_world, source_id, optional_was_camera_follow_target)
	local is_camera_follow_target = _is_follow_target_unit(target_unit_or_nil)

	if optional_was_camera_follow_target ~= is_camera_follow_target then
		local parameter_value = is_camera_follow_target and 1 or 0

		WwiseWorld.set_source_parameter(wwise_world, source_id, TARGETED_BY_RANGED_MINION_WWISE_PARAMETER, parameter_value)
	end

	return is_camera_follow_target
end

Effect.update_targeted_by_special_wwise_parameters = function (target_unit_or_nil, wwise_world, source_id, optional_was_camera_follow_target, optional_special_unit)
	local is_camera_follow_target = _is_follow_target_unit(target_unit_or_nil)

	if optional_was_camera_follow_target ~= is_camera_follow_target then
		local parameter_value = is_camera_follow_target and 1 or 0

		WwiseWorld.set_source_parameter(wwise_world, source_id, TARGETED_BY_SPECIAL_WWISE_PARAMETER, parameter_value)
	end

	if optional_special_unit and is_camera_follow_target then
		local fx_extension = ScriptUnit.extension(target_unit_or_nil, "fx_system")

		fx_extension:set_targeted_by_special(optional_special_unit, true)
	end

	return is_camera_follow_target
end

Effect.update_targeted_in_melee_wwise_parameters = function (target_unit_or_nil, wwise_world, source_id, optional_was_camera_follow_target)
	local is_camera_follow_target = _is_follow_target_unit(target_unit_or_nil)

	if optional_was_camera_follow_target ~= is_camera_follow_target then
		local parameter_value = is_camera_follow_target and 1 or 0

		WwiseWorld.set_source_parameter(wwise_world, source_id, TARGETED_BY_MELEE_WWISE_PARAMETER, parameter_value)
	end

	return is_camera_follow_target
end

return Effect
