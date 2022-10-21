local SoundReflection = component("SoundReflection")

SoundReflection.init = function (self, unit)
	if rawget(_G, "AnimationEditor") then
		return
	end

	self._unit = unit

	if not Unit.has_node(unit, "j_head") then
		return false
	end

	if not ScriptUnit.has_extension(self._unit, "first_person_system") then
		return false
	end

	self._first_person_extension = ScriptUnit.extension(self._unit, "first_person_system")
	self._world = Unit.world(unit)
	self._wwise_world = Wwise.wwise_world(self._world)
	self._physics_world = World.physics_world(self._world)
	self._node_index = Unit.node(unit, "j_head")
	self._max_distance = 10
	self._t = 0
	self._update_time = 0
	self._update_interval = 1
	self._directions = {
		QuaternionBox(Quaternion.axis_angle(Vector3.up(), 45)),
		QuaternionBox(Quaternion.axis_angle(Vector3.up(), -45)),
		QuaternionBox(Quaternion.axis_angle(Vector3.up(), 90)),
		QuaternionBox(Quaternion.axis_angle(Vector3.up(), -90))
	}
	self._distances = {}
	self._positions = {}
	self._materials = {}
	self._use_material_reactions = true
	self._last_position = Vector3Box(0, 0, 0)
	self._material_reaction_event = "wwise/events/weapon/play_weapon_material_reaction_rattle"
	self._MaterialQuery = require("scripts/utilities/material_query")
	self._event_time = 0
	self._event_limit = 0.3

	return true
end

SoundReflection.editor_init = function (self, unit)
	return
end

SoundReflection.events.update_sound_reflection = function (self)
	if self._event_time <= self._t then
		self._event_time = self._t + self._event_limit

		self:_set_reflection(true)
	end
end

SoundReflection.enable = function (self, unit)
	return
end

SoundReflection.disable = function (self, unit)
	return
end

SoundReflection.destroy = function (self, unit)
	return
end

SoundReflection.editor_update = function (self, unit, dt, t)
	return
end

SoundReflection.update = function (self, unit, dt, t)
	self._t = t

	if self._update_time <= t then
		self._update_time = t + self._update_interval

		self:_set_reflection()
	end

	return true
end

SoundReflection._set_reflection = function (self, from_event)
	local position = Unit.world_position(self._unit, self._node_index)
	local rotation = self._first_person_extension:extrapolated_rotation()
	local query_material = self._use_material_reactions and from_event and Vector3.distance(position, self._last_position:unbox()) > 0.1
	self._last_position = Vector3Box(position)

	for i = 1, #self._directions do
		local rotation = Quaternion.multiply(rotation, self._directions[i]:unbox())
		local distance, reflection_position, material = self:_get_reflection_distance(position, Quaternion.forward(rotation), self._max_distance, query_material)
		distance = math.clamp(distance or self._max_distance, 0, self._max_distance)
		self._distances[i] = distance
		self._positions[i] = reflection_position
		self._materials[i] = material
	end

	local index = #self._directions + 1
	self._distances[index], self._positions[index], self._materials[index] = self:_get_reflection_distance(position, Quaternion.up(rotation), self._max_distance, query_material)

	self:_set_wwise_reflection_parameters()

	if self._use_material_reactions and from_event then
		self:_play_material_reaction()
	end
end

local INDEX_POSITION = 1
local INDEX_ACTOR = 4

SoundReflection._get_reflection_distance = function (self, position, direction, max_distance, query_material)
	local results = PhysicsWorld.raycast(self._physics_world, position, direction, max_distance, "all", "types", "both", "collision_filter", "filter_player_character_shooting_statics")

	if results then
		for i = 1, #results do
			local result = results[i]
			local actor = result[INDEX_ACTOR]
			local unit = Actor.unit(actor)

			if unit ~= nil and unit ~= self._unit then
				local hit_pos = result[INDEX_POSITION]
				local hit_distance = Vector3.distance(hit_pos, position)
				local material = nil

				if query_material then
					local material_ids = Unit.query_material(unit, hit_pos - direction * 0.2, hit_pos + direction * 0.2, {
						"surface_material"
					})

					if material_ids[1] ~= nil then
						material = self._MaterialQuery.lookup[material_ids[1]]
					end
				end

				return hit_distance, hit_pos, material
			end
		end
	end
end

SoundReflection._set_wwise_reflection_parameters = function (self)
	local reflection_avg = math.abs(self._distances[1]) * math.abs(self._distances[2]) * math.abs(self._distances[3]) * math.abs(self._distances[4]) / 4

	WwiseWorld.set_global_parameter(self._wwise_world, "reflection_lf", self._distances[1])
	WwiseWorld.set_global_parameter(self._wwise_world, "reflection_rf", self._distances[2])
	WwiseWorld.set_global_parameter(self._wwise_world, "reflection_lb", self._distances[3])
	WwiseWorld.set_global_parameter(self._wwise_world, "reflection_rb", self._distances[4])
	WwiseWorld.set_global_parameter(self._wwise_world, "reflection_avg", reflection_avg)
end

SoundReflection._play_material_reaction = function (self)
	for i = 1, #self._positions do
		if self._positions[i] ~= nil then
			local auto_source_id = WwiseWorld.make_auto_source(self._wwise_world, self._positions[i])

			if self._materials[i] ~= nil then
				WwiseWorld.set_switch(self._wwise_world, "surface_material", self._materials[i], auto_source_id)
			else
				WwiseWorld.set_switch(self._wwise_world, "surface_material", "default", auto_source_id)
			end

			WwiseWorld.trigger_resource_event(self._wwise_world, self._material_reaction_event, auto_source_id)
		end
	end
end

SoundReflection.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true
}
SoundReflection.component_data = {}

return SoundReflection
