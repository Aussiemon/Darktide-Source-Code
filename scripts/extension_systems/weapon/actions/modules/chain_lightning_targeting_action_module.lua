local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTargetingActionModule = class("ChainLightningTargetingActionModule")
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local Vector3_up = Vector3.up

ChainLightningTargetingActionModule.init = function (self, physics_world, player_unit, component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._first_person_component = unit_data_extension:read_component("first_person")
end

ChainLightningTargetingActionModule.start = function (self, action_settings, t)
	local component = self._component
	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

local RADIUS = 20
local MAX_Z_DIFF = RADIUS
local MAX_ANGLE = math.pi * 0.1
local BROADPHASE_RESULTS = {}
local hit_units = {}

ChainLightningTargetingActionModule.fixed_update = function (self, dt, t)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local player_unit = self._player_unit
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local query_position = POSITION_LOOKUP[player_unit]
	local rotation = self._first_person_component.rotation
	local forward_direction = Vector3_normalize(Vector3_flat(Quaternion.forward(rotation)))
	local component = self._component

	table.clear(BROADPHASE_RESULTS)
	table.clear(hit_units)

	local num_results = broadphase:query(query_position, RADIUS, BROADPHASE_RESULTS, enemy_side_names)

	if DevParameters.draw_chain_lightning_targeting_action_module then
		QuickDrawer:sphere(query_position, RADIUS, Color.magenta())
	end

	local num_targets = 0

	for i = 1, num_results do
		local target_unit = BROADPHASE_RESULTS[i]

		if target_unit and not hit_units[target_unit] then
			local valid_target = ChainLightning.is_valid_target(self._physics_world, player_unit, target_unit, query_position, -forward_direction, MAX_ANGLE, MAX_Z_DIFF)

			if valid_target then
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

ChainLightningTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component
		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return ChainLightningTargetingActionModule
