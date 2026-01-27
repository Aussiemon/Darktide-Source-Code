-- chunkname: @scripts/extension_systems/liquid_area/husk_liquid_area_extension.lua

local LiquidAreaSettings = require("scripts/settings/liquid_area/liquid_area_settings")
local CLIENT_RPCS = {
	"rpc_add_liquid",
	"rpc_add_liquid_multiple",
	"rpc_set_liquid_filled",
	"rpc_set_liquid_filled_multiple",
	"rpc_remove_liquid_multiple",
}
local HuskLiquidAreaExtension = class("HuskLiquidAreaExtension")

HuskLiquidAreaExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	local world, wwise_world = extension_init_context.world, extension_init_context.wwise_world

	self._world, self._nav_world, self._wwise_world = world, extension_init_context.nav_world, wwise_world
	self._traverse_logic = extension_init_context.traverse_logic
	self._unit = unit
	self._flow = {}
	self._particle_group = World.create_particle_group(world)

	local template = extension_init_data.template

	self._vfx_name_rim = template.vfx_name_rim
	self._vfx_name_filled = template.vfx_name_filled

	local sfx_name_start = template.sfx_name_start

	self._sfx_name_start = sfx_name_start
	self._sfx_name_stop = template.sfx_name_stop

	local position = Unit.world_position(unit, 1)

	if sfx_name_start then
		local wwise_source_id = WwiseWorld.make_manual_source(wwise_world, position)

		WwiseWorld.trigger_resource_event(wwise_world, sfx_name_start, wwise_source_id)

		self._wwise_source_id = wwise_source_id
		self._sfx_source_z_offset = template.sfx_source_z_offset
	end

	local network_event_delegate = extension_init_context.network_event_delegate

	self._network_event_delegate, self._game_object_id = network_event_delegate, game_object_id

	network_event_delegate:register_session_unit_events(self, game_object_id, unpack(CLIENT_RPCS))

	self._liquid_center, self._liquid_radius = Vector3Box(), 0
	self._recalculate_liquid_size = false

	local additional_unit_vfx = template.additional_unit_vfx

	if additional_unit_vfx then
		local particle_group

		if GameParameters.destroy_unmanaged_particles then
			particle_group = self._particle_group
		end

		self._additional_unit_particle_id = World.create_particles(self._world, additional_unit_vfx, position, Quaternion.identity(), nil, particle_group)
	end

	self._area_template_name = template.name
	self._use_liquid_drawer = template.use_liquid_drawer
end

HuskLiquidAreaExtension.set_drawer = function (self, drawers)
	if self._use_liquid_drawer and self._area_template_name then
		self._drawer = drawers[self._area_template_name]
	end
end

HuskLiquidAreaExtension.destroy = function (self)
	local wwise_source_id = self._wwise_source_id

	if wwise_source_id then
		local wwise_world = self._wwise_world
		local sfx_name_stop = self._sfx_name_stop

		if sfx_name_stop then
			WwiseWorld.trigger_resource_event(wwise_world, sfx_name_stop, wwise_source_id)
		end

		WwiseWorld.destroy_manual_source(wwise_world, wwise_source_id)
	end

	local world = self._world

	for _, liquid in pairs(self._flow) do
		local rim_particle_id = liquid.rim_particle_id

		if rim_particle_id then
			World.stop_spawning_particles(world, rim_particle_id)
		end

		local filled_particle_id = liquid.filled_particle_id

		if filled_particle_id then
			if self._drawer then
				self._drawer:remove_cell(filled_particle_id)
			else
				World.stop_spawning_particles(world, filled_particle_id)
			end
		end
	end

	local additional_unit_particle_id = self._additional_unit_particle_id

	if additional_unit_particle_id then
		World.stop_spawning_particles(world, additional_unit_particle_id)
	end

	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))
	World.destroy_particle_group(world, self._particle_group)
end

HuskLiquidAreaExtension.update = function (self, unit, dt, t, context, listener_position_or_nil)
	if self._recalculate_liquid_size then
		self:_calculate_liquid_size()

		self._recalculate_liquid_size = false
	end

	if self._wwise_source_id and listener_position_or_nil then
		local liquid_center = self._liquid_center:unbox()
		local liquid_radius = self._liquid_radius
		local source_position = listener_position_or_nil

		if not math.point_in_sphere(liquid_center, liquid_radius, listener_position_or_nil) then
			source_position = math.closest_point_on_sphere(liquid_center, liquid_radius, listener_position_or_nil)
		end

		source_position.z = liquid_center.z + (self._sfx_source_z_offset or 0)

		WwiseWorld.set_source_position(self._wwise_world, self._wwise_source_id, source_position)
	end
end

HuskLiquidAreaExtension._calculate_liquid_size = function (self)
	local Vector3_max, Vector3_min = Vector3.max, Vector3.min
	local temp_positions = Managers.frame_table:get_table()
	local flow = self._flow
	local _, first_liquid = next(flow)
	local first_position = first_liquid.position:unbox()
	local max_position, min_position = first_position, first_position
	local num_liquid = 0

	for _, liquid in pairs(flow) do
		local position = liquid.position:unbox()

		max_position = Vector3_max(max_position, position)
		min_position = Vector3_min(min_position, position)
		num_liquid = num_liquid + 1
		temp_positions[num_liquid] = position
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local max_distance_sq = -math.huge
	local center_position = (max_position + min_position) / 2

	for i = 1, num_liquid do
		local position = temp_positions[i]
		local distance_sq = Vector3_distance_squared(center_position, position)

		if max_distance_sq < distance_sq then
			max_distance_sq = distance_sq
		end

		temp_positions[i] = nil
	end

	self._liquid_center:store(center_position)

	self._liquid_radius = math.sqrt(max_distance_sq)
end

local NAV_MESH_ABOVE, NAV_MESH_BELOW = LiquidAreaSettings.NAV_MESH_ABOVE, LiquidAreaSettings.nav_mesh_below

HuskLiquidAreaExtension._rotation_from_nav_mesh = function (self, position)
	local altitude, vertex_1, vertex_2, vertex_3 = GwNavQueries.triangle_from_position(self._nav_world, position, NAV_MESH_ABOVE, NAV_MESH_BELOW, self._traverse_logic)
	local rotation

	if altitude then
		local v1_to_v2 = Vector3.normalize(vertex_2 - vertex_1)
		local v1_to_v3 = Vector3.normalize(vertex_3 - vertex_1)
		local normal = Vector3.normalize(Vector3.cross(v1_to_v2, v1_to_v3))

		rotation = Quaternion.look(v1_to_v2, normal)
	else
		rotation = Quaternion.identity()
	end

	return rotation
end

HuskLiquidAreaExtension._add_liquid = function (self, unit_position, real_index, offset_position, is_filled)
	local position = unit_position + offset_position
	local rotation = self:_rotation_from_nav_mesh(position)
	local rim_particle_id
	local vfx_name_rim = self._vfx_name_rim

	if vfx_name_rim then
		local particle_group

		if GameParameters.destroy_unmanaged_particles then
			particle_group = self._particle_group
		end

		rim_particle_id = World.create_particles(self._world, vfx_name_rim, position, rotation, nil, particle_group)
	end

	self._flow[real_index] = {
		full = is_filled,
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation),
		rim_particle_id = rim_particle_id,
	}

	if is_filled then
		self:_set_liquid_filled(real_index)
	end

	self._recalculate_liquid_size = true
end

HuskLiquidAreaExtension.rpc_add_liquid = function (self, channel, go_id, real_index, offset_position, is_filled)
	local unit_position = Unit.world_position(self._unit, 1)

	self:_add_liquid(unit_position, real_index, offset_position, is_filled)
end

HuskLiquidAreaExtension.rpc_add_liquid_multiple = function (self, channel, go_id, real_index_array, offset_position_array, is_filled_array)
	local unit_position = Unit.world_position(self._unit, 1)

	for i = 1, #real_index_array do
		self:_add_liquid(unit_position, real_index_array[i], offset_position_array[i], is_filled_array[i])
	end
end

HuskLiquidAreaExtension.rpc_remove_liquid_multiple = function (self, channel, go_id, real_index_array)
	local flow = self._flow

	for i = 1, #real_index_array do
		local real_index = real_index_array[i]
		local liquid = flow[real_index_array[i]]
		local rim_particle_id = liquid.rim_particle_id

		if rim_particle_id then
			World.stop_spawning_particles(self._world, rim_particle_id)
		end

		local filled_particle_id = liquid.filled_particle_id

		if filled_particle_id then
			if self._drawer then
				self._drawer:remove_cell(filled_particle_id)
			else
				World.stop_spawning_particles(self._world, filled_particle_id)
			end
		end

		self._flow[real_index] = nil
	end
end

HuskLiquidAreaExtension.rpc_set_liquid_filled = function (self, channel, go_id, real_index)
	self:_set_liquid_filled(real_index)
end

HuskLiquidAreaExtension.rpc_set_liquid_filled_multiple = function (self, channel, go_id, real_index_array)
	for i = 1, #real_index_array do
		self:_set_liquid_filled(real_index_array[i])
	end
end

HuskLiquidAreaExtension._set_liquid_filled = function (self, real_index)
	local liquid = self._flow[real_index]

	liquid.full = true

	local vfx_name_filled = self._vfx_name_filled

	if not liquid.filled_particle_id then
		if vfx_name_filled then
			local position, rotation = liquid.position:unbox(), liquid.rotation:unbox()

			if self._drawer then
				liquid.filled_particle_id = self._drawer:add_cell(position, rotation)
			else
				local particle_group

				if GameParameters.destroy_unmanaged_particles then
					particle_group = self._particle_group
				end

				liquid.filled_particle_id = World.create_particles(self._world, vfx_name_filled, position, rotation, nil, particle_group)
			end
		else
			liquid.filled_particle_id = nil
		end
	end
end

return HuskLiquidAreaExtension
