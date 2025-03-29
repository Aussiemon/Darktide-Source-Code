-- chunkname: @scripts/extension_systems/weapon/actions/modules/ballistic_raycast_position_finder_action_module.lua

local BallisticRaycast = require("scripts/extension_systems/weapon/actions/utilities/ballistic_raycast")
local BallisticRaycastPostionFinderActionModule = class("BallisticRaycastPostionFinderActionModule")

BallisticRaycastPostionFinderActionModule.init = function (self, physics_world, player_unit, position_finder_component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._position_finder_component = position_finder_component
	self._action_settings = action_settings

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
end

BallisticRaycastPostionFinderActionModule.start = function (self, action_settings, t)
	self._position_finder_component.position = Vector3.zero()
end

BallisticRaycastPostionFinderActionModule.fixed_update = function (self, dt, t)
	local physics_world = self._physics_world
	local collision_filter = "filter_player_character_ballistic_raycast"
	local hit, hit_position, _, normal, _ = BallisticRaycast.cast(physics_world, collision_filter, self._first_person_component, nil, nil, nil, nil, nil)

	if hit then
		local up = Vector3.up()

		if Vector3.dot(normal, up) < 0.75 then
			local player_position = self._locomotion_component.position
			local half_step_back = 1 * Vector3.normalize(hit_position - player_position)
			local new_position = hit_position - half_step_back
			local _, new_hit_position, _, _, _ = PhysicsWorld.raycast(physics_world, new_position, Vector3(0, 0, -1), 5, "closest", "types", "both", "collision_filter", collision_filter)

			if new_hit_position then
				hit_position = new_hit_position
			end
		end
	end

	self._position_finder_component.position = hit_position
end

BallisticRaycastPostionFinderActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		self._position_finder_component.position = Vector3.zero()
	end
end

return BallisticRaycastPostionFinderActionModule
