-- chunkname: @scripts/extension_systems/weapon/actions/modules/closest_targeting_action_module.lua

local ClosestTargetingActionModule = class("ClosestTargetingActionModule")

ClosestTargetingActionModule.init = function (self, physics_world, player_unit, component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
end

ClosestTargetingActionModule.start = function (self, action_settings, t)
	local component = self._component

	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

local RADIUS = 20
local MAX_ANGLE = math.pi * 0.1
local BROADPHASE_RESULTS = {}
local hit_units = {}

ClosestTargetingActionModule.fixed_update = function (self, dt, t)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local player_unit = self._player_unit
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local query_position = POSITION_LOOKUP[player_unit]
	local rotation = self._first_person_component.rotation
	local forward_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local component = self._component

	table.clear(BROADPHASE_RESULTS)
	table.clear(hit_units)

	local num_results = broadphase.query(broadphase, query_position, RADIUS, BROADPHASE_RESULTS, enemy_side_names)
	local num_targets = 0

	for i = 1, num_results do
		local target_unit = BROADPHASE_RESULTS[i]

		if target_unit and not hit_units[target_unit] then
			local direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[target_unit] - query_position))
			local angle = Vector3.angle(forward_direction, direction)

			if angle <= MAX_ANGLE then
				num_targets = num_targets + 1
				hit_units[target_unit] = true

				if num_targets == 1 then
					component.target_unit_1 = target_unit
				elseif num_targets == 2 then
					component.target_unit_2 = target_unit
				elseif num_targets == 3 then
					component.target_unit_3 = target_unit
				end

				if num_targets >= 3 then
					break
				end
			end
		end
	end
end

ClosestTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component

		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return ClosestTargetingActionModule
