local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local DestructibleUtilities = {
	FORCE_DIRECTION = table.enum("random_direction", "attack_direction", "provided_direction")
}

local function _set_meshes_visiblity(unit, meshes, visible)
	local Unit_set_mesh_visibility = Unit.set_mesh_visibility

	for i = 1, #meshes do
		Unit_set_mesh_visibility(unit, meshes[i], visible)
	end
end

DestructibleUtilities.setup_stages = function (unit, parts_mass, parts_speed, force_direction, force_direction_type, health_extension)
	local destructible_parameters = {
		current_stage_index = 1,
		parts_mass = parts_mass,
		parts_speed = parts_speed,
		force_direction = force_direction,
		force_direction_type = force_direction_type
	}
	local initial_actor = Unit.actor(unit, "c_destructible")
	destructible_parameters.initial_actor = ActorBox(initial_actor)

	Unit.set_visibility(unit, "main", true)

	local parent_node = nil

	if Unit.has_node(unit, "ds_1") then
		parent_node = Unit.node(unit, "ds_1")
	end

	destructible_parameters.health = 1

	if health_extension then
		destructible_parameters.health = health_extension:max_health()
	end

	if parent_node == nil then
		destructible_parameters.meshes = {}
		destructible_parameters.lights = {}
		destructible_parameters.dynamic_actors = {}
		destructible_parameters.static_actors = {}
	else
		destructible_parameters.meshes = Unit.get_node_meshes(unit, parent_node, true, false) or {}

		_set_meshes_visiblity(unit, destructible_parameters.meshes, false)

		destructible_parameters.lights = Unit.get_node_lights(unit, parent_node, true, false) or {}
		local unit_actors = Unit.get_node_actors(unit, parent_node, true, false) or {}
		local dynamic_actors = {}
		local static_actors = {}

		for i = 1, #unit_actors do
			local actor = Unit.actor(unit, unit_actors[i])

			if Actor.is_dynamic(actor) then
				Actor.set_kinematic(actor, true)
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)
				Actor.set_simulation_enabled(actor, false)

				dynamic_actors[#dynamic_actors + 1] = ActorBox(actor)
			elseif Actor.is_static(actor) then
				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)

				static_actors[#static_actors + 1] = ActorBox(actor)
			end
		end

		destructible_parameters.dynamic_actors = dynamic_actors
		destructible_parameters.static_actors = static_actors
	end

	return destructible_parameters
end

local function _wake_up_static_actors(actors)
	for i = 1, #actors do
		local actor = ActorBox.unbox(actors[i])

		Actor.set_collision_enabled(actor, true)
		Actor.set_scene_query_enabled(actor, true)
	end
end

local function _wake_up_dynamic_actors(actors)
	for i = 1, #actors do
		local actor = ActorBox.unbox(actors[i])

		Actor.set_collision_enabled(actor, true)
		Actor.set_kinematic(actor, false)
		Actor.set_simulation_enabled(actor, true)
		Actor.wake_up(actor)
	end
end

local function _add_force_on_parts(actors, mass, speed, attack_direction)
	local direction = attack_direction

	for i = 1, #actors do
		local actor = ActorBox.unbox(actors[i])

		if not attack_direction then
			local random_x = math.random() * 2 - 1
			local random_y = math.random() * 2 - 1
			local random_z = math.random() * 2 - 1
			local random_direction = Vector3(random_x, random_y, random_z)
			direction = Vector3.normalize(random_direction)
		end

		Actor.add_impulse(actor, direction * mass * speed)
	end
end

local function _dequeue_stage(unit, destructible_parameters, visibility_info, attack_direction, silent_transition)
	local current_stage_index = destructible_parameters.current_stage_index

	if current_stage_index > 0 then
		local initial_actor = ActorBox.unbox(destructible_parameters.initial_actor)

		Actor.set_collision_enabled(initial_actor, false)
		Actor.set_scene_query_enabled(initial_actor, false)

		if not DEDICATED_SERVER then
			Unit.set_visibility(unit, "main", false)
			_set_meshes_visiblity(unit, destructible_parameters.meshes, true)
			_wake_up_static_actors(destructible_parameters.static_actors)
			_wake_up_dynamic_actors(destructible_parameters.dynamic_actors)
		end

		if not silent_transition then
			if not DEDICATED_SERVER then
				if destructible_parameters.force_direction_type == DestructibleUtilities.FORCE_DIRECTION.random_direction then
					attack_direction = nil
				elseif destructible_parameters.force_direction_type == DestructibleUtilities.FORCE_DIRECTION.provided_direction then
					attack_direction = destructible_parameters.force_direction:unbox()
				end

				_add_force_on_parts(destructible_parameters.dynamic_actors, destructible_parameters.parts_mass, destructible_parameters.parts_speed, attack_direction)
			end

			Unit.flow_event(unit, "lua_last_destruction")
		end

		destructible_parameters.current_stage_index = 0

		DestructibleUtilities.set_lights_enabled(unit, destructible_parameters, visibility_info)
	end

	return destructible_parameters.current_stage_index
end

DestructibleUtilities.add_damage = function (unit, destructible_parameters, visibility_info, damage, attack_direction)
	local current_stage_index = destructible_parameters.current_stage_index

	if current_stage_index > 0 and damage > 0 then
		local health_after_damage = destructible_parameters.health - damage
		destructible_parameters.health = math.max(0, health_after_damage)

		if health_after_damage <= 0 then
			_dequeue_stage(unit, destructible_parameters, visibility_info, attack_direction, false)
		end
	end
end

DestructibleUtilities.calculate_total_health = function (destructible_parameters)
	local current_stage_index = destructible_parameters.current_stage_index
	local health = 0

	if current_stage_index > 0 then
		health = destructible_parameters.health
	end

	return health
end

DestructibleUtilities.set_stage = function (unit, destructible_parameters, new_stage, visibility_info, silent_transition)
	local current_stage_index = destructible_parameters.current_stage_index

	while current_stage_index ~= new_stage do
		current_stage_index = _dequeue_stage(unit, destructible_parameters, visibility_info, nil, silent_transition)
	end
end

DestructibleUtilities.set_lights_enabled = function (unit, destructible_parameters, visibility_info)
	local unit_visible = visibility_info.visible
	local lights_enabled = visibility_info.lights_enabled
	local fake_light = visibility_info.fake_light
	local destroyed = destructible_parameters.current_stage_index <= 0

	LightControllerUtilities.set_enabled(unit, unit_visible and lights_enabled and not destroyed, fake_light)
end

DestructibleUtilities.is_destructible = function (unit)
	local destructible_ext = ScriptUnit.has_extension(unit, "destructible_system")

	return destructible_ext ~= nil
end

DestructibleUtilities.set_physics_simulation = function (unit, val)
	return
end

return DestructibleUtilities
