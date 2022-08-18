local Unit_actor = Unit.actor
local HitZone = {}
local hit_zone_names = table.enum("head", "torso", "tail", "tongue", "upper_left_arm", "lower_left_arm", "upper_right_arm", "lower_right_arm", "upper_left_leg", "lower_left_leg", "upper_right_leg", "lower_right_leg", "afro", "center_mass", "captain_void_shield", "corruptor_armor", "shield")
HitZone.hit_zone_names = hit_zone_names
local _hit_zone_position = nil

HitZone.get = function (unit, actor)
	local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_ext then
		return nil
	end

	return unit_data_ext:hit_zone(actor)
end

HitZone.get_name = function (unit, actor)
	local hit_zone = HitZone.get(unit, actor)

	if not hit_zone then
		return nil
	end

	return hit_zone.name
end

HitZone.get_actor_names = function (unit, hit_zone_name)
	local unit_data_ext = ScriptUnit.has_extension(unit, "unit_data_system")

	if not unit_data_ext then
		return nil
	end

	return unit_data_ext:hit_zone_actors(hit_zone_name)
end

HitZone.initialize_lookup = function (unit, hit_zones)
	local hit_zone_lookup = {}
	local hit_zone_actors_lookup = {}

	for ii = 1, #hit_zones, 1 do
		local hit_zone = hit_zones[ii]
		local create_on_startup = hit_zone.create_on_startup
		local actors = hit_zone.actors
		local actors_lookup = {}
		hit_zone_actors_lookup[hit_zone.name] = actors_lookup

		for jj = 1, #actors, 1 do
			local actor_name = actors[jj]

			if create_on_startup then
				fassert(not Unit_actor(unit, actor_name), "Tried creating an actor that already exists %q for unit %q", actor_name, unit)
				Unit.create_actor(unit, actor_name)
			end

			local actor = Unit_actor(unit, actor_name)
			hit_zone_lookup[actor] = hit_zone
			actors_lookup[#actors_lookup + 1] = actor_name
		end
	end

	return hit_zone_lookup, hit_zone_actors_lookup
end

local destroy_actor = Unit.destroy_actor

HitZone.destroy_hit_zone = function (unit, hit_zone_lookup, hit_zone_actors_lookup, hit_zone_name)
	local actor_names = hit_zone_actors_lookup[hit_zone_name]

	for ii = 1, #actor_names, 1 do
		local actor_name = actor_names[ii]
		local actor = Unit_actor(unit, actor_name)
		hit_zone_lookup[actor] = nil

		destroy_actor(unit, actor)
	end

	hit_zone_actors_lookup[hit_zone_name] = nil
end

HitZone.actor_index = function (unit, actor)
	local node = Actor.node(actor)
	local recursive = false
	local use_global_table = true
	local actor_indices = Unit.get_node_actors(unit, node, recursive, use_global_table)

	return actor_indices[1]
end

HitZone.hit_zone_center_of_mass = function (target_unit, hit_zone_name, average_positions)
	local target_unit_data = ScriptUnit.extension(target_unit, "unit_data_system")
	local target_hitzone_actors_names = target_unit_data:hit_zone_actors(hit_zone_name)
	target_hitzone_actors_names = target_hitzone_actors_names or target_unit_data:hit_zone_actors(hit_zone_names.center_mass)
	local position = nil

	if average_positions then
		position = Vector3.zero()
		local num_actors = #target_hitzone_actors_names

		for ii = 1, num_actors, 1 do
			position = position + _hit_zone_position(target_unit, target_hitzone_actors_names[ii])
		end

		position = position / num_actors
	else
		position = _hit_zone_position(target_unit, target_hitzone_actors_names[1])
	end

	return position
end

function _hit_zone_position(unit, actor_name)
	local actor = Unit_actor(unit, actor_name)
	local position = (Actor.is_dynamic(actor) and Actor.center_of_mass(actor)) or Actor.position(actor)

	return position
end

return HitZone
