local PropData = require("scripts/settings/prop_data/prop_data")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PropUnitDataExtension = class("PropUnitDataExtension")

PropUnitDataExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
	self._breed = nil
end

PropUnitDataExtension.setup_from_component = function (self, armor_data_name)
	local breed = PropData[armor_data_name]
	local unit = self._unit
	self._breed = breed
	local hit_zones = breed.hit_zones
	self._hit_zone_lookup, self._hit_zone_actors_lookup = HitZone.initialize_lookup(unit, hit_zones)

	fassert(self._hit_zone_actors_lookup.center_mass, "PropData %q does not have center_mass hit zone", breed.name)

	local bind_pose = Unit.local_pose(unit, 1)
	self._bind_pose = Matrix4x4Box(bind_pose)
	self._node_to_bind_pose = {}
	local inv_bind_pose = Matrix4x4.inverse(bind_pose)

	for i = 1, #hit_zones do
		local hit_zone = hit_zones[i]
		local actors = hit_zone.actors

		for j = 1, #actors do
			local actor_name = actors[j]
			local actor_id = Unit.find_actor(unit, actor_name)
			local actor = Unit.actor(unit, actor_id)
			local node_index = Actor.node(actor)

			if not self._node_to_bind_pose[node_index] then
				local bind_pose_for_node = Actor.pose(actor)
				bind_pose_for_node = Matrix4x4.multiply(bind_pose_for_node, inv_bind_pose)
				self._node_to_bind_pose[node_index] = Matrix4x4Box(bind_pose_for_node)
			end
		end
	end
end

PropUnitDataExtension.breed = function (self)
	return self._breed
end

PropUnitDataExtension.faction_name = function (self)
	return self._breed.faction_name
end

PropUnitDataExtension.breed_name = function (self)
	local breed = self._breed
	local breed_name = breed.name

	return breed_name
end

PropUnitDataExtension.archetype = function (self)
	ferror("PropUnitDataExtension does not support archetype.")
end

PropUnitDataExtension.archetype_name = function (self)
	ferror("PropUnitDataExtension does not support archetype.")
end

PropUnitDataExtension.bind_pose = function (self)
	return self._bind_pose:unbox()
end

PropUnitDataExtension.node_bind_pose = function (self, node_index)
	local bind_pose = self._node_to_bind_pose[node_index]

	if bind_pose then
		return bind_pose:unbox()
	end

	return nil
end

PropUnitDataExtension.breed_size_variation = function (self)
	ferror("PropUnitDataExtension does not support breed_size_variation.")
end

PropUnitDataExtension.hit_zone = function (self, actor)
	return self._hit_zone_lookup[actor]
end

PropUnitDataExtension.hit_zone_actors = function (self, hit_zone_name)
	return self._hit_zone_actors_lookup[hit_zone_name]
end

PropUnitDataExtension.is_owned_by_death_manager = function (self)
	return false
end

return PropUnitDataExtension
