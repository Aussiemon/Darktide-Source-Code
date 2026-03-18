-- chunkname: @scripts/utilities/minion_target_override.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionTargetOverride = {}
local vector3_distance_squared = Vector3.distance_squared

MinionTargetOverride.check_for_target_overrides = function (unit, target_units, buff_extension)
	local taunter_unit = buff_extension:owner_of_buff_with_id("taunted")

	if target_units[taunter_unit] then
		return target_units
	end

	local blackboard = BLACKBOARDS[unit]
	local group_data_component = blackboard.group_data
	local owning_auto_event_id = group_data_component.owning_auto_event_id
	local group_target = group_data_component.group_target

	if owning_auto_event_id ~= "" then
		target_units = MinionTargetOverride._minion_has_auto_event_targets_override(unit, blackboard, target_units, owning_auto_event_id)
	end

	if group_target then
		target_units = MinionTargetOverride._minion_has_group_target_override(unit, blackboard, target_units, group_target)
	end

	return target_units
end

MinionTargetOverride._minion_has_auto_event_targets_override = function (unit, blackboard, target_units, owning_auto_event_id)
	local damage_taken = MinionTargetOverride._damage_taken(unit)
	local check_break_distance = MinionTargetOverride._distance_check(unit, target_units)

	if damage_taken or check_break_distance then
		local writable_group_data_component = Blackboard.write_component(blackboard, "group_data")

		writable_group_data_component.owning_auto_event_id = ""

		MinionTargetOverride._try_break_override_on_nearby_allies(unit)

		return target_units
	else
		local valid_event_targets, num_valid_units = Managers.state.pacing:get_all_valid_units_in_event(owning_auto_event_id)

		if valid_event_targets and num_valid_units > 0 then
			return valid_event_targets
		else
			local writable_group_data_component = Blackboard.write_component(blackboard, "group_data")

			writable_group_data_component.owning_auto_event_id = ""

			return target_units
		end
	end
end

local TEMP_TARGET_TABLE = {}

MinionTargetOverride._minion_has_group_target_override = function (unit, blackboard, target_units, group_target)
	table.clear(TEMP_TARGET_TABLE)

	local damage_taken = MinionTargetOverride._damage_taken(unit)
	local check_break_distance = MinionTargetOverride._distance_check(unit, target_units)

	if not HEALTH_ALIVE[group_target] or damage_taken or check_break_distance then
		local writable_group_data_component = Blackboard.write_component(blackboard, "group_data")

		writable_group_data_component.group_target = nil

		MinionTargetOverride._try_break_override_on_nearby_allies(unit)

		return target_units
	else
		TEMP_TARGET_TABLE[group_target] = 1
		TEMP_TARGET_TABLE[1] = group_target

		return TEMP_TARGET_TABLE
	end
end

MinionTargetOverride._damage_taken = function (unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension then
		return
	end

	local has_taken_damage = health_extension:has_taken_damage_over_percentage()

	return has_taken_damage
end

local BREAK_DISTANCE_SQ = 150

MinionTargetOverride._distance_check = function (unit, target_units)
	local position = POSITION_LOOKUP[unit]

	for i = 1, #target_units do
		local target_unit = target_units[i]
		local target_position = POSITION_LOOKUP[target_unit]
		local distance_sq = vector3_distance_squared(position, target_position)

		if distance_sq < BREAK_DISTANCE_SQ then
			return true
		end
	end

	return false
end

local RADIUS_RESULT = {}
local radius = 10

MinionTargetOverride._try_break_override_on_nearby_allies = function (unit)
	local position = POSITION_LOOKUP[unit]
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("villains")
	local target_side_names = side:relation_side_names("allied")

	table.clear(RADIUS_RESULT)

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_results = broadphase.query(broadphase, position, radius, RADIUS_RESULT, target_side_names)

	for i = 1, num_results do
		local enemy = RADIUS_RESULT[i]
		local blackboard = BLACKBOARDS[enemy]

		if blackboard then
			local has_group_data_component = Blackboard.has_component(blackboard, "group_data")

			if has_group_data_component then
				local group_data_component = Blackboard.write_component(blackboard, "group_data")

				group_data_component.group_target = nil
				group_data_component.owning_auto_event_id = ""
			end
		end
	end
end

return MinionTargetOverride
