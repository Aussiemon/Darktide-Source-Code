local RaycastTargetingActionModule = class("RaycastTargetingActionModule")

RaycastTargetingActionModule.init = function (self, physics_world, player_unit, component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._first_person_component = unit_data_extension:read_component("first_person")
end

RaycastTargetingActionModule.start = function (self, action_settings, t)
	local component = self._component
	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

local INDEX_ACTOR = 4

RaycastTargetingActionModule.fixed_update = function (self, dt, t)
	local component = self._component
	local physics_world = self._physics_world
	local first_person_component = self._first_person_component
	local position = first_person_component.position
	local rotation = first_person_component.rotation
	local direction = Quaternion.forward(rotation)
	local targeting_params = self._action_settings.targeting_params
	local sticky_targeting = targeting_params.sticky_targeting
	local collision_filter = targeting_params.collision_filter
	local target_validation_function = targeting_params.target_validation_function
	local range = targeting_params.range
	local hits = PhysicsWorld.raycast(physics_world, position, direction, range, "all", "types", "both", "collision_filter", collision_filter)

	if (not component.target_unit_1 or not sticky_targeting) and hits then
		local num_hits = #hits

		for index = 1, num_hits, 1 do
			local hit = hits[index]
			local hit_actor = hit[INDEX_ACTOR]
			local hit_unit = Actor.unit(hit_actor)

			if hit_unit ~= self._player_unit then
				local valid, stop = target_validation_function(self._player_unit, hit_unit)

				if valid then
					component.target_unit_1 = hit_unit
				elseif not sticky_targeting then
					component.target_unit_1 = nil
				end

				if stop then
					break
				end
			end
		end
	end
end

RaycastTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component
		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return RaycastTargetingActionModule
