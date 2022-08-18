local LightControllerUtilities = require("core/scripts/common/light_controller_utilities")
local DestructibleUtilities = {
	FORCE_DIRECTION = table.enum("random_direction", "attack_direction"),
	setup_stages = function (unit, parts_mass, parts_speed, force_direction_type, health_extension)
		local destructible_parameters = {
			current_stage_index = 1,
			stages = {},
			parts_mass = parts_mass,
			parts_speed = parts_speed,
			force_direction_type = force_direction_type
		}
		local initial_actor = Unit.actor(unit, "c_destructible")
		destructible_parameters.initial_actor = ActorBox(initial_actor)

		Unit.set_visibility(unit, "main", true)

		if Unit.has_visibility_group(unit, "chunks") then
			Unit.set_visibility(unit, "chunks", false)
		end

		local parent_nodes = {}
		local parent_index = 1

		while Unit.has_node(unit, "ds_" .. parent_index) do
			local parent_node = Unit.node(unit, "ds_" .. parent_index)
			parent_nodes[#parent_nodes + 1] = parent_node
			parent_index = parent_index + 1
		end

		local num_stages = #parent_nodes

		fassert(num_stages < 8, "[DestructibleUtilities][setup_stages] Update the parameter type 'current_stage' of 'rpc_sync_destructible'.")

		local health_per_stage = 1

		if health_extension then
			local max_health = health_extension:max_health()
			health_per_stage = max_health / math.max(num_stages, 1)
			health_per_stage = math.max(health_per_stage, 1)
		end

		if num_stages == 0 then
			local stage = {
				static_meshes = {},
				dynamic_meshes = {},
				lights = {},
				health = health_per_stage,
				actors = {}
			}
			destructible_parameters.stages[1] = stage
		else
			for i = 1, num_stages, 1 do
				local parent_node = parent_nodes[i]
				local stage = {}
				local dynamic_meshes = {}
				local static_meshes = {}
				local meshes = Unit.get_node_meshes(unit, parent_node, true, false) or {}

				for j = 1, #meshes, 1 do
					local mesh = meshes[j]
					local mesh_node = Mesh.node(Unit.mesh(unit, mesh))
					local mesh_actors = Unit.get_node_actors(unit, mesh_node, true, false)

					if mesh_actors ~= nil then
						local mesh_actor = Unit.actor(unit, mesh_actors[1])

						if Actor.is_dynamic(mesh_actor) then
							dynamic_meshes[#dynamic_meshes + 1] = mesh
						else
							static_meshes[#static_meshes + 1] = mesh
						end
					elseif Unit.scene_graph_children(unit, mesh, false, false) ~= nil then
						dynamic_meshes[#dynamic_meshes + 1] = mesh
					else
						static_meshes[#static_meshes + 1] = mesh
					end

					Unit.set_mesh_visibility(unit, mesh, false)
				end

				stage.static_meshes = static_meshes
				stage.dynamic_meshes = dynamic_meshes

				if Unit.num_lights(unit) > 0 then
					local recursive = true
					local use_global_table = false
					stage.lights = Unit.get_node_lights(unit, parent_node, recursive, use_global_table)
				end

				stage.lights = stage.lights or {}
				local recursive = true
				local use_global_table = false
				local unit_actors = Unit.get_node_actors(unit, parent_node, recursive, use_global_table)
				local actors = {}

				for j = 1, #unit_actors, 1 do
					local actor = Unit.actor(unit, unit_actors[j])

					if Actor.is_dynamic(actor) then
						Actor.set_kinematic(actor, true)

						actors[j] = ActorBox(actor)
					end
				end

				stage.health = health_per_stage
				stage.actors = actors
				destructible_parameters.stages[#destructible_parameters.stages + 1] = stage
			end
		end

		return destructible_parameters
	end
}

local function _wake_up_actors(actors)
	for _, stored_actor in pairs(actors) do
		local actor = ActorBox.unbox(stored_actor)

		Actor.set_kinematic(actor, false)
		Actor.wake_up(actor)
	end
end

local function _set_stage_meshes_visiblity(unit, destructible_stage, visible)
	local Unit_set_mesh_visibility = Unit.set_mesh_visibility
	local meshes = destructible_stage.static_meshes

	for i = 1, #meshes, 1 do
		Unit_set_mesh_visibility(unit, meshes[i], visible)
	end

	meshes = destructible_stage.dynamic_meshes

	for i = 1, #meshes, 1 do
		Unit_set_mesh_visibility(unit, meshes[i], visible)
	end
end

local function _set_all_dynamic_meshes_visiblity(unit, stages, visible)
	local Unit_set_mesh_visibility = Unit.set_mesh_visibility

	for i = 1, #stages, 1 do
		local dynamic_meshes = stages[i].dynamic_meshes

		for j = 1, #dynamic_meshes, 1 do
			Unit_set_mesh_visibility(unit, dynamic_meshes[j], visible)
		end
	end
end

local function _add_force_on_parts(actors, mass, speed, attack_direction)
	for _, stored_actor in pairs(actors) do
		local actor = ActorBox.unbox(stored_actor)
		local random_x = math.random() * 2 - 1
		local random_y = math.random() * 2 - 1
		local random_z = math.random() * 2 - 1
		local random_direction = Vector3(random_x, random_y, random_z)
		random_direction = Vector3.normalize(random_direction)
		local direction = attack_direction or random_direction

		Actor.add_impulse(actor, direction * mass * speed)
	end
end

local function _dequeue_stage(unit, destructible_parameters, visibility_info, attack_direction, silent_transition)
	local current_stage_index = destructible_parameters.current_stage_index

	if current_stage_index > 0 then
		if current_stage_index == 1 then
			local initial_actor = ActorBox.unbox(destructible_parameters.initial_actor)

			Actor.set_collision_filter(initial_actor, "filter_destructible")
			Unit.set_visibility(unit, "main", false)

			if Unit.has_visibility_group(unit, "chunks") then
				Unit.set_visibility(unit, "chunks", true)
			end
		end

		local current_stage = destructible_parameters.stages[current_stage_index]

		_set_stage_meshes_visiblity(unit, current_stage, true)
		_wake_up_actors(current_stage.actors)

		if not silent_transition then
			if destructible_parameters.force_direction_type == DestructibleUtilities.FORCE_DIRECTION.random_direction then
				attack_direction = nil
			end

			_add_force_on_parts(current_stage.actors, destructible_parameters.parts_mass, destructible_parameters.parts_speed, attack_direction)
		end

		current_stage_index = current_stage_index + 1

		if current_stage_index > #destructible_parameters.stages then
			destructible_parameters.current_stage_index = 0

			if not silent_transition then
				Unit.flow_event(unit, "lua_last_destruction")
			end

			local initial_actor = ActorBox.unbox(destructible_parameters.initial_actor)

			Actor.set_scene_query_enabled(initial_actor, false)
		else
			destructible_parameters.current_stage_index = current_stage_index

			if not silent_transition then
				Unit.flow_event(unit, "lua_destruction")
			end
		end

		DestructibleUtilities.set_lights_enabled(unit, destructible_parameters, visibility_info)
	end

	return destructible_parameters.current_stage_index
end

DestructibleUtilities.add_damage = function (unit, destructible_parameters, visibility_info, damage, attack_direction)
	local current_stage_index = destructible_parameters.current_stage_index

	if current_stage_index > 0 and damage > 0 then
		local current_stage = destructible_parameters.stages[current_stage_index]
		local health_after_damage = current_stage.health - damage
		current_stage.health = math.max(0, health_after_damage)

		if health_after_damage <= 0 then
			local silent_transition = false

			_dequeue_stage(unit, destructible_parameters, visibility_info, attack_direction, silent_transition)

			local rest_damage = -health_after_damage
			rest_damage = math.max(0, rest_damage)

			DestructibleUtilities.add_damage(unit, destructible_parameters, visibility_info, rest_damage, attack_direction)
		end
	end
end

DestructibleUtilities.calculate_total_health = function (destructible_parameters)
	local current_stage_index = destructible_parameters.current_stage_index
	local health = 0

	if current_stage_index > 0 then
		local num_stages = #destructible_parameters.stages

		for i = current_stage_index, num_stages, 1 do
			local stage = destructible_parameters.stages[i]
			health = health + stage.health
		end
	end

	return health
end

DestructibleUtilities.set_stage = function (unit, destructible_parameters, new_stage, visibility_info, silent_transition)
	local current_stage_index = destructible_parameters.current_stage_index

	while current_stage_index ~= new_stage do
		current_stage_index = _dequeue_stage(unit, destructible_parameters, visibility_info, nil, silent_transition)
	end
end

local function _are_lights_destroyed(destructible_parameters)
	local current_stage_index = destructible_parameters.current_stage_index

	if current_stage_index <= 0 then
		return true
	end

	for ii = 1, current_stage_index, 1 do
		local stage = destructible_parameters.stages[ii]

		if #stage.lights > 0 then
			return true
		end
	end

	return false
end

DestructibleUtilities.set_lights_enabled = function (unit, destructible_parameters, visibility_info)
	local unit_visible = visibility_info.visible
	local lights_enabled = visibility_info.lights_enabled
	local fake_light = visibility_info.fake_light
	local destroyed = _are_lights_destroyed(destructible_parameters)

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
