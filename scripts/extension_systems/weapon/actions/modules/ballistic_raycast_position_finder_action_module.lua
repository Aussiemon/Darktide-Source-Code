local BallisticRaycastPostionFinderActionModule = class("BallisticRaycastPostionFinderActionModule")

BallisticRaycastPostionFinderActionModule.init = function (self, physics_world, player_unit, component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
end

BallisticRaycastPostionFinderActionModule.start = function (self, action_settings, t)
	local action_component = self._component
	action_component.position = Vector3.zero()
end

BallisticRaycastPostionFinderActionModule.fixed_update = function (self, dt, t)
	local physics_world = self._physics_world
	local collision_filter = "filter_player_character_shooting_statics"
	local hit, hit_position, _, normal = self:_ballistic_raycast(physics_world, collision_filter)

	if hit then
		local up = Vector3(0, 0, 1)

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

	local action_component = self._component
	action_component.position = hit_position
end

BallisticRaycastPostionFinderActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local action_component = self._component
		action_component.position = Vector3.zero()
	end
end

BallisticRaycastPostionFinderActionModule._ballistic_raycast = function (self, physics_world, collision_filter)
	local max_steps = 10
	local max_time = 1.5
	local speed = 15
	local angle = 0
	local gravity = Vector3(0, 0, -9.82)
	local time_step = max_time / max_steps
	local first_person_position = self._first_person_component.position
	local first_person_rotation = self._first_person_component.rotation
	local velocity = Quaternion.forward(Quaternion.multiply(first_person_rotation, Quaternion(Vector3.right(), angle))) * speed
	local position = first_person_position

	for i = 1, max_steps do
		local new_position = position + velocity * time_step
		local delta = new_position - position
		local direction = Vector3.normalize(delta)
		local distance = Vector3.length(delta)
		local hit, hit_position, hit_distance, normal, hit_actor = PhysicsWorld.raycast(physics_world, position, direction, distance, "closest", "types", "both", "collision_filter", collision_filter)

		if hit_position then
			return hit, hit_position, hit_distance, normal, hit_actor
		end

		velocity = velocity + gravity * time_step
		position = new_position
	end

	return false, position
end

return BallisticRaycastPostionFinderActionModule
