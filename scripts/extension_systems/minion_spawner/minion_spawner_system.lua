require("scripts/extension_systems/minion_spawner/minion_spawner_extension")

local MinionSpawnerSystem = class("MinionSpawnerSystem", "ExtensionSystemBase")
local BROADPHASE_CELL_RADIUS = 50
local BROADPHASE_MAX_NUM_ENTITIES = 256
local BROADPHASE_CATEGORIES = {
	"minion_spawner"
}
local BROADPHASE_UNIT_RADIUS = 1

MinionSpawnerSystem.init = function (self, extension_system_creation_context, ...)
	MinionSpawnerSystem.super.init(self, extension_system_creation_context, ...)

	local nav_world = extension_system_creation_context.nav_world
	local extension_init_context = self._extension_init_context
	extension_init_context.nav_world = nav_world
	local nav_tag_cost_table = GwNavTagLayerCostTable.create()
	local traverse_logic = GwNavTraverseLogic.create(nav_world)

	GwNavTraverseLogic.set_navtag_layer_cost_table(traverse_logic, nav_tag_cost_table)

	extension_init_context.nav_tag_cost_table = nav_tag_cost_table
	extension_init_context.traverse_logic = traverse_logic
	self._nav_tag_cost_table = nav_tag_cost_table
	self._traverse_logic = traverse_logic
	self._extension_broadphase_lookup = {}
	self._spawner_group_extensions = {}
	self._broadphase = Broadphase(BROADPHASE_CELL_RADIUS, BROADPHASE_MAX_NUM_ENTITIES, BROADPHASE_CATEGORIES)
end

MinionSpawnerSystem.extensions_ready = function (self, world, unit, extension_name)
	self:_add_spawner_groups(unit)
end

MinionSpawnerSystem.on_remove_extension = function (self, unit, extension_name)
	self:_remove_spawner_groups(unit)
	MinionSpawnerSystem.super.on_remove_extension(self, unit, extension_name)
end

MinionSpawnerSystem.change_spawner_group_names = function (self, unit, spawner_group_names)
	self:_remove_spawner_groups(unit)
	self:_add_spawner_groups(unit, spawner_group_names)
end

MinionSpawnerSystem._add_spawner_groups = function (self, unit, new_spawnergroup_names)
	local extension = self._unit_to_extension_map[unit]
	local spawner_group_extensions = self._spawner_group_extensions
	local ext_spawner_groups = extension:spawner_groups()
	local spawner_groups = new_spawnergroup_names or ext_spawner_groups

	for i = 1, #spawner_groups do
		local spawner_group = spawner_groups[i]
		local extensions = spawner_group_extensions[spawner_group] or {}
		extensions[#extensions + 1] = extension
		spawner_group_extensions[spawner_group] = extensions
	end

	self:add_spawner_to_ranged_search(extension)
end

MinionSpawnerSystem._remove_spawner_groups = function (self, unit)
	local extension = self._unit_to_extension_map[unit]

	for _, extensions in pairs(self._spawner_group_extensions) do
		for i = #extensions, 1, -1 do
			if extensions[i] == extension then
				table.remove(extensions, i)

				break
			end
		end
	end

	if self._extension_broadphase_lookup[extension] then
		self:remove_spawner_from_ranged_search(extension)
	end
end

MinionSpawnerSystem.spawners_in_group = function (self, group)
	local spawners = self._spawner_group_extensions[group]

	if spawners then
		return table.shallow_copy(spawners)
	end
end

local function _sort_spawners_by_distance(s1, s2)
	local distance_1 = s1.distance
	local distance_2 = s2.distance

	return distance_1 < distance_2
end

MinionSpawnerSystem.spawners_in_group_distance_sorted = function (self, group, position)
	local spawners = self._spawner_group_extensions[group]

	if spawners then
		local spawners_table = table.shallow_copy(spawners)

		for i = #spawners_table, 1, -1 do
			local spawner = spawners[i]
			local distance = Vector3.distance(position, spawner:position())
			spawner.distance = distance
		end

		table.sort(spawners_table, _sort_spawners_by_distance)

		return spawners_table
	end
end

MinionSpawnerSystem.average_position_of_spawners = function (self, group)
	local spawners = self._spawner_group_extensions[group]

	if not spawners then
		return
	end

	local average_position = Vector3(0, 0, 0)
	local num_spawners = #spawners

	for i = 1, num_spawners do
		local extension = spawners[i]
		local position = extension:position()
		average_position = average_position + position
	end

	average_position = average_position / num_spawners

	return average_position
end

local broadphase_results = {}

MinionSpawnerSystem.spawners_in_range = function (self, position, radius)
	local broadphase = self._broadphase
	local extension_broadphase_lookup = self._extension_broadphase_lookup
	local num_results = broadphase:query(position, radius, broadphase_results, BROADPHASE_CATEGORIES)
	local hit_extensions = {}
	local num_extensions = 0

	for i = 1, num_results do
		local hit_id = broadphase_results[i]
		local extension = extension_broadphase_lookup[hit_id]

		if not extension:is_excluded_from_pacing() then
			num_extensions = num_extensions + 1
			hit_extensions[num_extensions] = extension_broadphase_lookup[hit_id]
		end
	end

	return hit_extensions
end

MinionSpawnerSystem.add_spawner_to_ranged_search = function (self, extension)
	local extension_broadphase_lookup = self._extension_broadphase_lookup

	if extension_broadphase_lookup[extension] then
		Log.info("MinionSpawnerSystem", "Spawner already added to ranged search")

		return
	end

	local position = extension:position()
	local broadphase_id = Broadphase.add(self._broadphase, nil, position, BROADPHASE_UNIT_RADIUS, BROADPHASE_CATEGORIES)
	extension_broadphase_lookup[broadphase_id] = extension
	extension_broadphase_lookup[extension] = broadphase_id
end

MinionSpawnerSystem.remove_spawner_from_ranged_search = function (self, extension)
	local extension_broadphase_lookup = self._extension_broadphase_lookup
	local broadphase_id = extension_broadphase_lookup[extension]

	if not broadphase_id then
		Log.info("MinionSpawnerSystem", "Couldn't remove spawner from ranged search since it's not included in it")

		return
	end

	Broadphase.remove(self._broadphase, broadphase_id)

	extension_broadphase_lookup[extension] = nil
	extension_broadphase_lookup[broadphase_id] = nil
end

MinionSpawnerSystem.destroy = function (self, ...)
	self._extension_broadphase_lookup = {}
	self._spawner_group_extensions = nil
	self._broadphase = nil
	self._broadphase_ids = nil

	GwNavTagLayerCostTable.destroy(self._nav_tag_cost_table)

	self._nav_tag_cost_table = nil

	GwNavTraverseLogic.destroy(self._traverse_logic)

	self._traverse_logic = nil

	MinionSpawnerSystem.super.destroy(self, ...)
end

return MinionSpawnerSystem
