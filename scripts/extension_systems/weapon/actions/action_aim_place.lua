require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionAimPlace = class("ActionAimPlace", "ActionWeaponBase")

ActionAimPlace.init = function (self, action_context, ...)
	ActionAimPlace.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_place")
end

ActionAimPlace.start = function (self, dt, t)
	self._action_component.rotation_step = 0
end

ActionAimPlace.fixed_update = function (self, dt, t)
	local first_person_component = self._first_person_component
	local look_position = first_person_component.position
	local look_rotation = first_person_component.rotation
	local look_direction = Quaternion.forward(look_rotation)
	local place_configuration = self._action_settings.place_configuration
	local place_distance = place_configuration.distance
	local physics_world = self._physics_world
	local hit, position, _, normal, actor = PhysicsWorld.raycast(physics_world, look_position, look_direction, place_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")

	if not hit then
		local downward_raycast_position = look_position + look_direction * place_distance
		_, position, _, normal, actor = PhysicsWorld.raycast(physics_world, downward_raycast_position, Vector3.down(), place_distance, "closest", "types", "both", "collision_filter", "filter_player_place_deployable")
	end

	local can_place = false

	if position then
		if Vector3.dot(normal, Vector3.up()) > 0.7 then
			can_place = true
		end
	else
		position = Vector3.zero()
	end

	local unit_hit = nil

	if actor then
		unit_hit = Actor.unit(actor)
	end

	if unit_hit then
		local unit_spawner_manager = Managers.state.unit_spawner
		local game_object_id = unit_spawner_manager:game_object_id(unit_hit)
		local level_index = unit_spawner_manager:level_index(unit_hit)

		if not game_object_id and not level_index then
			unit_hit = nil
		end
	end

	local look_direction_flat = Vector3.flat(look_direction)
	local rotation = Quaternion.look(look_direction_flat)
	local current_rotation_step = self._action_component.rotation_step

	if place_configuration.allow_rotation then
		local rotate_input = place_configuration.rotation_input
		local rotation_steps = place_configuration.rotation_steps
		local has_input = self._input_extension:get(rotate_input)

		if has_input then
			current_rotation_step = (current_rotation_step + 1) % rotation_steps
			self._action_component.rotation_step = current_rotation_step
		end

		local angle = math.pi * 2 / rotation_steps * current_rotation_step
		local additional_rotation = Quaternion(Vector3.up(), angle)
		rotation = Quaternion.multiply(rotation, additional_rotation)
	end

	self._action_component.position = position
	self._action_component.rotation = rotation
	self._action_component.can_place = can_place
	self._action_component.aiming_place = true
	self._action_component.placed_on_unit = unit_hit
end

ActionAimPlace.finish = function (self, reason, data, t, time_in_action)
	self._action_component.aiming_place = false
end

return ActionAimPlace
