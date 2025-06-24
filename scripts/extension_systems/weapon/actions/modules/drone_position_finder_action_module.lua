-- chunkname: @scripts/extension_systems/weapon/actions/modules/drone_position_finder_action_module.lua

local BallisticRaycast = require("scripts/extension_systems/weapon/actions/utilities/ballistic_raycast")
local DroneTargetPositionFinderActionModule = class("DroneTargetPositionFinderActionModule")

DroneTargetPositionFinderActionModule.init = function (self, is_server, physics_world, player_unit, position_finder_component, action_settings)
	self._is_server = is_server
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._position_finder_component = position_finder_component
	self._action_settings = action_settings
	self._instant_cast = action_settings.instant_cast

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
end

DroneTargetPositionFinderActionModule.start = function (self, action_settings, t)
	self._position_finder_component.position = Vector3.zero()
end

DroneTargetPositionFinderActionModule.fixed_update = function (self, dt, t)
	local physics_world = self._physics_world
	local collision_filter = "filter_place_force_field"
	local max_steps = 5
	local max_time = 2
	local instant_cast = self._instant_cast
	local speed = instant_cast and 2.5 or 12.5
	local angle = math.pi / 16
	local gravity = -19.64
	local hit, hit_position, _, normal, actor = BallisticRaycast.cast(physics_world, collision_filter, self._first_person_component, max_steps, max_time, speed, angle, gravity)

	if hit and Vector3.dot(normal, Vector3.up()) < 0.75 then
		local player_position = self._locomotion_component.position
		local half_step_back = 1 * Vector3.normalize(hit_position - player_position)
		local step_back_position = hit_position - half_step_back
		local _, new_position, _, _, _ = PhysicsWorld.raycast(physics_world, step_back_position, Vector3(0, 0, -1), 5, "closest", "types", "both", "collision_filter", collision_filter)

		if new_position then
			hit_position = new_position
		else
			hit = false
			hit_position = Vector3.zero()
			actor = nil
		end
	end

	hit_position = hit_position and hit_position + Vector3.up() * 2
	self._position_finder_component.position = hit_position
end

DroneTargetPositionFinderActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		self._position_finder_component.position = Vector3.zero()
	end
end

return DroneTargetPositionFinderActionModule
