-- chunkname: @scripts/utilities/attack/hit_zone_tests.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local DEFAULT_BASE_HEIGHT = 3

local function _check_for_unassigned_actors(unit, world, hit_zone_lookup, breed)
	local base_height = breed.base_height or DEFAULT_BASE_HEIGHT
	local pos = Unit.world_position(unit, 1)

	pos.z = pos.z + base_height * 0.5

	local physics_world = World.physics_world(world)
	local collision_filter = "filter_hit_zones_test"
	local hit_actors = {}
	local success = true
	local actors, num_actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", pos, "size", base_height * 2, "collision_filter", collision_filter)

	for i = 1, num_actors do
		repeat
			local actor = actors[i]
			local actor_unit = Actor.unit(actor)

			if actor_unit ~= unit then
				break
			end

			hit_actors[actor] = true

			local hit_zone = hit_zone_lookup[actor]

			if not hit_zone then
				Log.info("HitZoneTest", "%s does not have a hit zone assigned to it. Assign it in the breed or switch shape template if it's not supposed to be a hit zone.", actor)

				success = false
			end
		until true
	end

	for actor, _ in pairs(hit_zone_lookup) do
		if not hit_actors[actor] then
			Log.info("HitZoneTest", "Could not find actor %q", actor)

			success = false
		end
	end

	return success, "Faulty actors above error message."
end

local function _actors_string(unit, actor_indicies)
	local actor_s = ""
	local num_indicies = #actor_indicies

	for i = 1, num_indicies do
		local index = actor_indicies[i]
		local actor = Unit.actor(unit, index)

		if i == 1 then
			actor_s = string.format("%s", tostring(actor))
		else
			actor_s = string.format("%s, %s", actor_s, tostring(actor))
		end
	end

	return string.format("%s", actor_s)
end

local function _check_hit_zone_actor_index_boundaries(unit, hit_zone_lookup)
	local actor_index_maximum = 0

	for actor, hit_zone in pairs(hit_zone_lookup) do
		local node = Actor.node(actor)
		local recursive = false
		local use_global_table = true
		local actor_indicies = Unit.get_node_actors(unit, node, recursive, use_global_table)

		if #actor_indicies > 1 then
			return false, string.format("Multiple actors pointing towards same node(node:%i actors:%q)", node, _actors_string(unit, actor_indicies))
		end

		local actor_index = HitZone.actor_index(unit, actor)

		if actor_index == nil then
			return false, string.format("Could not find an actor_index for hit zone %q", hit_zone.name)
		end

		if actor_index > NetworkConstants.max_hit_zone_actor_index then
			return false, string.format("actor_index (%i) for hit zone %q is larger than maximum (%i). Up hit_zone_actor_index max value by a factor of 2 in global.network_conig.", actor_index, hit_zone.name, NetworkConstants.max_hit_zone_actor_index)
		end

		if actor_index == NetworkConstants.invalid_hit_zone_actor_index then
			return false, string.format("actor_index found for hit zone %q is the same as NetworkConstants.invalid_hit_zone_actor_index (%i). Need to set hit_zone_actor_index min value to something else in global.network_config.", hit_zone.name, actor_index)
		end

		if actor_index_maximum < actor_index then
			actor_index_maximum = actor_index
		end
	end

	return true
end

local function _hit_zone_tests(unit, breed, world)
	local hit_zone_lookup = HitZone.initialize_lookup(unit, breed.hit_zones)
	local error_msg = "HitZoneTests failed for unit %s using breed %q. %s"
	local s, m = _check_for_unassigned_actors(unit, world, hit_zone_lookup, breed)

	s, m = _check_hit_zone_actor_index_boundaries(unit, hit_zone_lookup)
end

return _hit_zone_tests
