-- chunkname: @scripts/managers/mutator/mutators/mutator_spawner/mutator_spawner_node.lua

local NavQueries = require("scripts/utilities/nav_queries")
local RoamerSlotPlacementFunctions = require("scripts/settings/roamer/roamer_slot_placement_functions")
local MutatorSpawnerNode = class("MutatorSpawnerNode")
local ABOVE, BELOW = 2, 3

MutatorSpawnerNode.SINGLE_PLACEMENT = function (nav_world, spawn_position_boxed, placement_settings, traverse_logic, roamer_pacing)
	return {
		{
			position = Vector3Box(NavQueries.position_on_mesh_guaranteed(nav_world, spawn_position_boxed:unbox(), ABOVE, BELOW, traverse_logic)),
			rotation = QuaternionBox(placement_settings.randomize_rotation and Quaternion.axis_angle(Vector3.up(), math.random() * (math.pi * 2)) or Quaternion.identity()),
		},
	}
end

MutatorSpawnerNode.CIRCLE_PLACEMENT = RoamerSlotPlacementFunctions.circle_placement_guaranteed
MutatorSpawnerNode.FLOOD_FILL_PLACEMENT = RoamerSlotPlacementFunctions.flood_fill

MutatorSpawnerNode.init = function (self, template)
	self._run_on_init = template.run_on_init or false
	self._asset_package = template.asset_package
	self._placement_method = template.placement_method or MutatorSpawnerNode.SINGLE_PLACEMENT
	self._spawn_settings = template.spawn_settings or {}
	self._use_raycast = template.use_raycast
	self._spawners = {}

	local template_spawners = template.spawners or {}

	for i = 1, #template_spawners do
		local spawner_template = template_spawners[i]
		local class = require(spawner_template.class)

		table.insert(self._spawners, class:new(spawner_template.template))
	end
end

MutatorSpawnerNode.placement_logic_functions = function (self)
	local placement_logic_functions = {
		_random = function (seed, ...)
			local _, value = math.next_random(Managers.state.pacing:level_seed(), ...)

			return value
		end,
	}

	return placement_logic_functions
end

MutatorSpawnerNode.destroy = function (self)
	return
end

MutatorSpawnerNode.should_run_on_init = function (self)
	return self._run_on_init
end

MutatorSpawnerNode.is_runtime = function (self)
	return not self._run_on_init
end

local RAY_LENGTH = 2

MutatorSpawnerNode.trigger_spawn = function (self, raycast_object, spawn_position, ahead_target_unit, optional_spawn_rotation, optional_level_size)
	local nav_mesh_manager = Managers.state.nav_mesh
	local nav_world = nav_mesh_manager:nav_world()
	local placement_settings = {
		num_slots = self._spawn_settings.count or 1,
		position_offset = self._spawn_settings.position_offset or 0,
		circle_radius = self._spawn_settings.radius or 1,
		randomize_rotation = self._spawn_settings.randomize_rotation or false,
	}
	local spawn_locations = self._placement_method(nav_world, Vector3Box(spawn_position), placement_settings, nil)
	local did_hit

	for i = 1, #spawn_locations do
		did_hit = false

		local spawn_location = spawn_locations[i].position:unbox()
		local spawn_rotation = spawn_locations[i].rotation:unbox()

		if optional_spawn_rotation then
			spawn_rotation = optional_spawn_rotation:unbox()
		end

		if self._use_raycast then
			local hit, hit_position, _, normal, _ = Raycast.cast(raycast_object, spawn_location, Vector3.down(), RAY_LENGTH)

			if hit then
				spawn_location = hit_position

				local normal_quat = Quaternion.axis_angle(normal, 0)

				spawn_rotation = Quaternion.multiply(spawn_rotation, normal_quat)
				did_hit = true
			end
		end

		if self._use_raycast and did_hit or not self._use_raycast then
			self:_do_spawn(spawn_location, ahead_target_unit, spawn_rotation, Vector3(1, 1, 1), optional_level_size)

			for j = 1, #self._spawners do
				self._spawners[j]:trigger_spawn(raycast_object, spawn_location, ahead_target_unit)
			end
		end
	end
end

MutatorSpawnerNode._do_spawn = function (self, spawn_position, ahead_target_unit, spawn_rotation, spawn_scale)
	return
end

return MutatorSpawnerNode
