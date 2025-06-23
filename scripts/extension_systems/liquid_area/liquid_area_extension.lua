-- chunkname: @scripts/extension_systems/liquid_area/liquid_area_extension.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local HexGrid = require("scripts/foundation/utilities/hex_grid")
local LiquidAreaSettings = require("scripts/settings/liquid_area/liquid_area_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local LiquidAreaExtension = class("LiquidAreaExtension")
local EXTRA_XY_EXTENTS = 10
local MAX_XY_EXTENTS = 50
local Z_EXTENTS, Z_CELL_SIZE = 10, 1
local NAV_MESH_ABOVE, NAV_MESH_BELOW = LiquidAreaSettings.nav_mesh_above, LiquidAreaSettings.nav_mesh_below
local NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH = LiquidAreaSettings.nav_mesh_lateral, LiquidAreaSettings.distance_from_nav_mesh
local max_size = NetworkConstants.liquid_real_index_array_max_size
local ADD_LIQUID_REAL_INDEX_SEND_ARRAY = Script.new_array(max_size)
local ADD_LIQUID_OFFSET_POSITION_SEND_ARRAY = Script.new_array(max_size)
local ADD_LIQUID_IS_FILLED_SEND_ARRAY = Script.new_array(max_size)

LiquidAreaExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local world, nav_world, wwise_world = extension_init_context.world, extension_init_context.nav_world, extension_init_context.wwise_world

	self._world, self._nav_world, self._wwise_world = world, nav_world, wwise_world
	self._unit = unit

	local traverse_logic = extension_init_context.traverse_logic

	self._traverse_logic = traverse_logic

	local unit_position = POSITION_LOOKUP[unit]
	local nav_mesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, unit_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH)
	local template = extension_init_data.template
	local cell_size = template.cell_size
	local max_liquid = extension_init_data.optional_max_liquid or template.max_liquid
	local z_cell_size = template.z_cell_size or Z_CELL_SIZE
	local xy_extents = math.min(max_liquid + EXTRA_XY_EXTENTS, MAX_XY_EXTENTS)

	self._grid = HexGrid:new(nav_mesh_position, xy_extents, Z_EXTENTS, cell_size, z_cell_size)
	self._cell_radius = cell_size / 2
	self._ignore_bot_threat = template.ignore_bot_threat
	self._liquid_paint_id = extension_init_data.optional_liquid_paint_id

	local t = Managers.time:time("gameplay")

	self._time_to_remove = t + template.life_time
	self._spread_function = template.spread_function
	self._flow, self._active_flow, self._inactive_flow = {}, {}, {}
	self._num_filled_liquid, self._max_filled_liquid = 0, max_liquid
	self._start_pressure, self._end_pressure = template.start_pressure, template.end_pressure
	self._flow_done = false
	self._in_liquid_buff_template_name = template.in_liquid_buff_template_name
	self._leaving_liquid_buff_template_name = template.leaving_liquid_buff_template_name
	self._buff_affected_units = {}

	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	local side_names
	local buff_target_side_relation = template.buff_target_side_relation
	local source_side_name = extension_init_data.optional_source_side

	if buff_target_side_relation and source_side_name then
		local source_side = side_system:get_side_from_name(source_side_name)

		if source_side then
			side_names = source_side:relation_side_names(buff_target_side_relation)
		end
	end

	self._area_template_name = template.name
	self._source_side_name = source_side_name
	self._sides = side_system:sides()
	self._side_names = side_names or side_system:side_names()

	local broadphase_system = extension_manager:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase
	self._broadphase_center, self._broadphase_radius = Vector3Box(), 0
	self._recalculate_broadphase_size = false
	self._vfx_name_rim = template.vfx_name_rim
	self._vfx_name_filled = template.vfx_name_filled

	local sfx_name_start = template.sfx_name_start

	self._sfx_name_start = sfx_name_start
	self._sfx_name_stop = template.sfx_name_stop
	self._spawn_brush_size = template.spawn_brush_size
	self._forbidden_keyword = template.forbidden_keyword

	local starting_angle = 0
	local flow_direction = extension_init_data.flow_direction_or_nil

	if flow_direction then
		local flat_flow_direction = Vector3.flat(flow_direction)

		starting_angle = math.atan2(flat_flow_direction.y, flat_flow_direction.x)
	else
		self._flow_done = true
	end

	self._linearized_flow = template.linearized_flow
	self._starting_flow_angle = starting_angle
	self._source_unit = extension_init_data.source_unit
	self._optional_source_item = extension_init_data.optional_source_item

	local disable_covers_within_radius = template.disable_covers_within_radius

	if disable_covers_within_radius then
		self._disable_covers_within_radius = disable_covers_within_radius
		self._disabled_cover_slots = {}
		self._cover_system = Managers.state.extension:system("cover_system")
	end

	local nav_cost_map_name = template.nav_cost_map_name

	if nav_cost_map_name then
		self._nav_cost_map_cost = template.nav_cost_map_cost
		self._nav_cost_map_id = Managers.state.nav_mesh:nav_cost_map_id(nav_cost_map_name)
		self._nav_cost_map_volume_uses_cells = template.nav_cost_map_volume_uses_cells
	end

	if sfx_name_start then
		local wwise_source_id = WwiseWorld.make_manual_source(wwise_world, unit_position)

		WwiseWorld.trigger_resource_event(wwise_world, sfx_name_start, wwise_source_id)

		self._wwise_source_id = wwise_source_id
		self._sfx_source_z_offset = template.sfx_source_z_offset
	end

	local additional_unit_vfx = template.additional_unit_vfx

	if additional_unit_vfx then
		self._additional_unit_particle_id = World.create_particles(self._world, additional_unit_vfx, unit_position)
	end

	local real_index_max_size = NetworkConstants.liquid_real_index_array_max_size
	local add_liquid_buffer = Script.new_array(real_index_max_size)

	add_liquid_buffer[0] = 0
	self._add_liquid_buffer = add_liquid_buffer
	self._set_filled_buffer = {
		size = 0
	}
	self._set_filled_send_array = Script.new_array(real_index_max_size)
	self._use_liquid_drawer = template.use_liquid_drawer
end

LiquidAreaExtension.set_drawer = function (self, drawers)
	if self._use_liquid_drawer and self._area_template_name then
		self._drawer = drawers[self._area_template_name]
	end
end

LiquidAreaExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id

	local unit = self._unit
	local position = POSITION_LOOKUP[unit]
	local grid = self._grid
	local i, j, k = grid:ijk_from_position(position)
	local real_index = grid:real_index_from_ijk(i, j, k)
	local starting_angle = self._starting_flow_angle
	local base_liquid = self:_create_liquid(real_index, starting_angle)

	self:_set_filled(real_index)

	local spawn_brush_size = self._spawn_brush_size

	if spawn_brush_size and spawn_brush_size > 0 then
		local _, num_directions = grid:directions()

		self:_fill_neighbors(base_liquid, num_directions, spawn_brush_size)
	end
end

LiquidAreaExtension._fill_neighbors = function (self, liquid, num_directions, depth)
	local flow = self._flow
	local neighbors = liquid.neighbors
	local next_depth = depth - 1

	for neighbor_index = 1, num_directions do
		local neighbor_real_index = neighbors[neighbor_index]

		if neighbor_real_index then
			local neighbor_liquid = flow[neighbor_real_index]

			if not neighbor_liquid.full then
				self:_set_filled(neighbor_real_index)
			end

			if next_depth > 0 then
				self:_fill_neighbors(neighbor_liquid, num_directions, next_depth)
			end
		end
	end
end

LiquidAreaExtension._position_and_rotation_from_nav_mesh = function (self, position, nav_world, traverse_logic)
	local altitude, vertex_1, vertex_2, vertex_3 = GwNavQueries.triangle_from_position(nav_world, position, NAV_MESH_ABOVE, NAV_MESH_BELOW, traverse_logic)
	local projected_position, rotation

	if altitude then
		local v1_to_v2 = Vector3.normalize(vertex_2 - vertex_1)
		local v1_to_v3 = Vector3.normalize(vertex_3 - vertex_1)
		local normal = Vector3.normalize(Vector3.cross(v1_to_v2, v1_to_v3))

		rotation = Quaternion.look(v1_to_v2, normal)
		projected_position = Vector3(position.x, position.y, altitude)
	else
		rotation = Quaternion.identity()
		projected_position = position
	end

	return projected_position, rotation
end

LiquidAreaExtension._create_liquid = function (self, real_index, angle)
	local grid = self._grid
	local i, j, k = grid:ijk_from_real_index(real_index)
	local position = grid:position_from_ijk(i, j, k)
	local nav_world, traverse_logic = self._nav_world, self._traverse_logic
	local from, rotation = self:_position_and_rotation_from_nav_mesh(position, nav_world, traverse_logic)
	local neighbors = {}
	local GwNavQueries_raycango = GwNavQueries.raycango
	local directions, num_directions = grid:directions()

	for index = 1, num_directions do
		local direction = directions[index]
		local offset_i, offset_j = direction.i, direction.j
		local new_i, new_j, new_k = i + offset_i, j + offset_j, k
		local new_position = grid:position_from_ijk(new_i, new_j, new_k)
		local to = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, new_position, NAV_MESH_ABOVE, NAV_MESH_BELOW, NAV_MESH_LATERAL, DISTANCE_FROM_NAV_MESH)

		if to and GwNavQueries_raycango(nav_world, from, to, traverse_logic) then
			local neighbor_real_index = grid:real_index_from_position(to)

			neighbors[index] = neighbor_real_index
		end
	end

	local particle_id
	local vfx_name_rim = self._vfx_name_rim

	if vfx_name_rim then
		particle_id = World.create_particles(self._world, vfx_name_rim, from, rotation)
	end

	local is_filled = false
	local add_liquid_buffer = self._add_liquid_buffer
	local num_buffered = add_liquid_buffer[0] + 1

	add_liquid_buffer[num_buffered] = real_index
	add_liquid_buffer[0] = num_buffered

	local liquid = {
		amount = 0,
		full = is_filled,
		neighbors = neighbors,
		position = Vector3Box(from),
		rotation = QuaternionBox(rotation),
		particle_id = particle_id,
		angle = angle,
		real_index = real_index
	}

	self._flow[real_index] = liquid
	self._inactive_flow[real_index] = liquid
	self._recalculate_broadphase_size = true

	return liquid
end

local LIQUID_FULL_AMOUNT = 1

LiquidAreaExtension._set_filled = function (self, real_index)
	local flow = self._flow
	local liquid = flow[real_index]

	liquid.full = true
	liquid.amount = LIQUID_FULL_AMOUNT

	local world = self._world
	local position = liquid.position:unbox()
	local vfx_name_filled = self._vfx_name_filled

	if vfx_name_filled then
		local rotation = liquid.rotation:unbox()

		if self._drawer then
			liquid.particle_id = self._drawer:add_cell(position, rotation)
		else
			liquid.particle_id = World.create_particles(world, vfx_name_filled, position, rotation)
		end
	else
		liquid.particle_id = nil
	end

	local disable_covers_within_radius = self._disable_covers_within_radius

	if disable_covers_within_radius then
		local disabled_cover_slots = self._disabled_cover_slots
		local cover_system = self._cover_system
		local nearby_cover_slots = cover_system:find_cover_slots(position, disable_covers_within_radius)

		for i = 1, #nearby_cover_slots do
			local cover_slot = nearby_cover_slots[i]

			cover_slot.disabled = true
			disabled_cover_slots[#disabled_cover_slots + 1] = cover_slot
		end
	end

	local set_filled_buffer = self._set_filled_buffer
	local new_size = set_filled_buffer.size + 1

	set_filled_buffer[new_size] = real_index
	set_filled_buffer.size = new_size
	self._active_flow[real_index] = liquid
	self._inactive_flow[real_index] = nil
	self._num_filled_liquid = self._num_filled_liquid + 1

	local nav_cost_map_id = self._nav_cost_map_id

	if nav_cost_map_id and self._nav_cost_map_volume_uses_cells then
		local nav_cost_map_volume_id = Managers.state.nav_mesh:add_nav_cost_map_sphere_volume(position, self._cell_radius, self._nav_cost_map_cost, nav_cost_map_id)

		liquid.nav_cost_map_volume_id = nav_cost_map_volume_id
	end

	local flow_angle, neighbors = liquid.angle, liquid.neighbors
	local _, num_directions = self._grid:directions()

	for index = 1, num_directions do
		local neighbor_real_index = neighbors[index]

		if neighbor_real_index and not flow[neighbor_real_index] then
			self:_create_liquid(neighbor_real_index, flow_angle)
		end
	end
end

LiquidAreaExtension.hot_join_sync = function (self, unit, sender, channel)
	local unit_pos = Unit.world_position(unit, 1)
	local game_object_id = self._game_object_id
	local send_array_i = 0
	local max_send_array_size = NetworkConstants.liquid_real_index_array_max_size
	local real_index_send_array = ADD_LIQUID_REAL_INDEX_SEND_ARRAY
	local offset_pos_send_array = ADD_LIQUID_OFFSET_POSITION_SEND_ARRAY
	local is_filled_send_array = ADD_LIQUID_IS_FILLED_SEND_ARRAY

	for real_index, liquid in pairs(self._flow) do
		local position, is_filled = liquid.position:unbox(), liquid.full
		local offset_position = position - unit_pos

		send_array_i = send_array_i + 1
		real_index_send_array[send_array_i] = real_index
		offset_pos_send_array[send_array_i] = offset_position
		is_filled_send_array[send_array_i] = is_filled

		if send_array_i == max_send_array_size then
			RPC.rpc_add_liquid_multiple(channel, game_object_id, real_index_send_array, offset_pos_send_array, is_filled_send_array)

			send_array_i = 0
		end
	end

	if send_array_i > 0 then
		for i = send_array_i + 1, max_send_array_size do
			real_index_send_array[i], offset_pos_send_array[i], is_filled_send_array[i] = nil
		end

		RPC.rpc_add_liquid_multiple(channel, game_object_id, real_index_send_array, offset_pos_send_array, is_filled_send_array)
	end
end

LiquidAreaExtension.destroy = function (self)
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
		local particle_id = liquid.particle_id

		if particle_id then
			if self._drawer then
				self._drawer:remove_cell(particle_id)
			else
				World.stop_spawning_particles(world, particle_id)
			end
		end
	end

	local additional_unit_particle_id = self._additional_unit_particle_id

	if additional_unit_particle_id then
		World.stop_spawning_particles(world, additional_unit_particle_id)
	end

	local t = FixedFrame.get_latest_fixed_time()

	for unit, buff_indices in pairs(self._buff_affected_units) do
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension then
			local local_index = buff_indices.local_index
			local component_index = buff_indices.component_index

			buff_extension:remove_externally_controlled_buff(local_index, component_index)

			local leaving_liquid_buff_template_name = self._leaving_liquid_buff_template_name

			if leaving_liquid_buff_template_name then
				buff_extension:add_internally_controlled_buff(leaving_liquid_buff_template_name, t, "owner_unit", self._source_unit, "source_item", self._optional_source_item)
			end
		end
	end

	local nav_cost_map_id = self._nav_cost_map_id

	if nav_cost_map_id then
		local nav_mesh_manager = Managers.state.nav_mesh

		if self._nav_cost_map_volume_uses_cells then
			for _, liquid in pairs(self._flow) do
				local volume_id = liquid.nav_cost_map_volume_id

				if volume_id then
					nav_mesh_manager:remove_nav_cost_map_volume(volume_id, nav_cost_map_id)
				end
			end
		else
			local existing_broadphase_nav_cost_volume_id = self._broadphase_nav_cost_map_volume_id

			if existing_broadphase_nav_cost_volume_id then
				nav_mesh_manager:remove_nav_cost_map_volume(existing_broadphase_nav_cost_volume_id, nav_cost_map_id)
			end
		end
	end
end

LiquidAreaExtension.source_side_name = function (self)
	return self._source_side_name
end

LiquidAreaExtension.area_template_name = function (self)
	return self._area_template_name
end

LiquidAreaExtension.is_position_inside = function (self, position)
	local grid = self._grid
	local i, j, k = grid:ijk_from_position(position)

	if grid:is_out_of_bounds(i, j, k) then
		return false
	end

	local real_index = grid:real_index_from_ijk(i, j, k)
	local liquid = self._flow[real_index]
	local is_inside = liquid and liquid.full or false

	return is_inside
end

LiquidAreaExtension.rim_nodes = function (self)
	return self._inactive_flow
end

LiquidAreaExtension.update = function (self, unit, dt, t, context, listener_position_or_nil)
	if t > self._time_to_remove then
		Managers.state.unit_spawner:mark_for_deletion(unit)

		return
	end

	if not self._flow_done then
		self:_update_flow(dt)
	end

	if self._recalculate_broadphase_size then
		self:_calculate_broadphase_size()

		self._recalculate_broadphase_size = false

		if self._flow_done and not self._ignore_bot_threat then
			local shape = "sphere"
			local size = self._broadphase_radius
			local rotation = Quaternion.identity()
			local duration = self._broadphase_radius * 0.5
			local position = POSITION_LOOKUP[unit]
			local group_system = Managers.state.extension:system("group_system")
			local bot_groups = group_system:bot_groups_from_sides(self._sides)
			local num_bot_groups = #bot_groups

			for i = 1, num_bot_groups do
				local bot_group = bot_groups[i]

				bot_group:aoe_threat_created(position, shape, size, rotation, duration)
			end
		end
	end

	self:_update_collision_detection(t)

	if self._wwise_source_id and listener_position_or_nil then
		local broadphase_center = self._broadphase_center:unbox()
		local broadphase_radius = self._broadphase_radius
		local source_position = listener_position_or_nil

		if not math.point_in_sphere(broadphase_center, broadphase_radius, listener_position_or_nil) then
			source_position = math.closest_point_on_sphere(broadphase_center, broadphase_radius, listener_position_or_nil)
		end

		source_position.z = broadphase_center.z + (self._sfx_source_z_offset or 0)

		WwiseWorld.set_source_position(self._wwise_world, self._wwise_source_id, source_position)
	end
end

LiquidAreaExtension.post_update = function (self, unit, dt, t)
	self:_handle_create_liquid_syncing()
	self:_handle_set_filled_syncing(t)
end

LiquidAreaExtension._handle_create_liquid_syncing = function (self)
	local add_liquid_buffer = self._add_liquid_buffer
	local num_added_this_frame = add_liquid_buffer[0]

	if num_added_this_frame == 0 then
		return
	end

	local unit_pos = Unit.world_position(self._unit, 1)

	if num_added_this_frame == 1 then
		local real_index = add_liquid_buffer[1]
		local liquid = self._flow[real_index]
		local pos = liquid.position:unbox()
		local offset_position = pos - unit_pos

		Managers.state.game_session:send_rpc_clients("rpc_add_liquid", self._game_object_id, real_index, offset_position, liquid.full)
	else
		local game_session_manager = Managers.state.game_session
		local game_object_id = self._game_object_id
		local flow = self._flow
		local real_index_send_array = ADD_LIQUID_REAL_INDEX_SEND_ARRAY
		local offset_position_send_array = ADD_LIQUID_OFFSET_POSITION_SEND_ARRAY
		local is_filled_send_array = ADD_LIQUID_IS_FILLED_SEND_ARRAY
		local max_send_array_size = NetworkConstants.liquid_real_index_array_max_size
		local send_array_i = 0

		for i = 1, num_added_this_frame do
			send_array_i = send_array_i + 1

			local real_index = add_liquid_buffer[i]
			local liquid = flow[real_index]
			local pos = liquid.position:unbox()

			real_index_send_array[send_array_i] = real_index
			offset_position_send_array[send_array_i] = pos - unit_pos
			is_filled_send_array[send_array_i] = liquid.full

			if send_array_i == max_send_array_size then
				game_session_manager:send_rpc_clients("rpc_add_liquid_multiple", game_object_id, real_index_send_array, offset_position_send_array, is_filled_send_array)

				send_array_i = 0
			end
		end

		if send_array_i > 0 then
			for i = send_array_i + 1, max_send_array_size do
				real_index_send_array[i], offset_position_send_array[i], is_filled_send_array[i] = nil
			end

			game_session_manager:send_rpc_clients("rpc_add_liquid_multiple", game_object_id, real_index_send_array, offset_position_send_array, is_filled_send_array)
		end
	end

	add_liquid_buffer[0] = 0
end

local SEND_FREQUENCY = 0.3333333333333333
local FORCE_SEND_AMOUNT = 64

LiquidAreaExtension._handle_set_filled_syncing = function (self, t)
	local set_filled_buffer = self._set_filled_buffer
	local size = set_filled_buffer.size
	local transmit_wait_t = self._transmit_wait_t

	if size > 0 and not transmit_wait_t then
		transmit_wait_t = t + SEND_FREQUENCY
		self._transmit_wait_t = transmit_wait_t
	end

	if size > 0 and transmit_wait_t < t or size >= FORCE_SEND_AMOUNT then
		self:_transmit_set_filled(set_filled_buffer, size)

		self._transmit_wait_t = nil
		self._old_filled_buffer_size = 0
	end
end

LiquidAreaExtension._transmit_set_filled = function (self, set_filled_buffer, size)
	local game_session_manager = Managers.state.game_session
	local game_object_id = self._game_object_id

	if size == 1 then
		game_session_manager:send_rpc_clients("rpc_set_liquid_filled", game_object_id, set_filled_buffer[1])
	else
		local set_filled_send_array = self._set_filled_send_array
		local max_send_array_size = NetworkConstants.liquid_real_index_array_max_size
		local send_array_i = 0

		repeat
			send_array_i = send_array_i + 1
			set_filled_send_array[send_array_i] = set_filled_buffer[size]
			size = size - 1

			if send_array_i == max_send_array_size then
				send_array_i = 0

				game_session_manager:send_rpc_clients("rpc_set_liquid_filled_multiple", game_object_id, set_filled_send_array)
			end
		until size == 0

		if send_array_i > 0 then
			for i = send_array_i + 1, max_send_array_size do
				set_filled_send_array[i] = nil
			end

			game_session_manager:send_rpc_clients("rpc_set_liquid_filled_multiple", game_object_id, set_filled_send_array)
		end
	end

	set_filled_buffer.size = 0
end

local add_list, remove_list = {}, {}
local fill_list = {
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	},
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	},
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	},
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	},
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	},
	{
		index = 0,
		relative_angle = 0,
		angle = 0,
		weight = 0
	}
}

LiquidAreaExtension._update_flow = function (self, dt)
	table.clear(add_list)
	table.clear(remove_list)

	local liquid_progress = self._num_filled_liquid / self._max_filled_liquid
	local pressure = math.lerp(self._start_pressure, self._end_pressure, liquid_progress)
	local two_pi, spread_function = math.two_pi, self._spread_function
	local directions, num_directions = self._grid:directions()
	local starting_angle, use_linearized_flow = self._starting_flow_angle, self._linearized_flow
	local active_flow, flow = self._active_flow, self._flow

	for real_index, liquid in pairs(active_flow) do
		local all_done, fill_list_index, total_weight = true, 0, 0
		local neighbors, flow_angle = liquid.neighbors, liquid.angle

		for i = 1, num_directions do
			repeat
				local neighbor_real_index = neighbors[i]

				if not neighbor_real_index then
					break
				end

				local neighbor_angle = directions[i].angle
				local forward_angle, backward_angle

				if flow_angle < neighbor_angle then
					forward_angle = neighbor_angle - flow_angle
					backward_angle = two_pi - forward_angle
				else
					backward_angle = flow_angle - neighbor_angle
					forward_angle = two_pi - backward_angle
				end

				local angle_relative_flow

				if forward_angle < backward_angle then
					angle_relative_flow = forward_angle
				else
					angle_relative_flow = -backward_angle
				end

				local weight = spread_function(math.abs(angle_relative_flow))

				total_weight = total_weight + weight

				local neighbor_liquid = flow[neighbor_real_index]

				if not neighbor_liquid.full and weight > 0 then
					fill_list_index, all_done = fill_list_index + 1, false

					local fill_list_entry = fill_list[fill_list_index]

					fill_list_entry.index = neighbor_real_index
					fill_list_entry.angle = neighbor_angle
					fill_list_entry.relative_angle = angle_relative_flow
					fill_list_entry.weight = weight
				end
			until true
		end

		for i = 1, fill_list_index do
			local entry = fill_list[i]
			local weight = entry.weight
			local flow_fraction = weight / total_weight
			local new_amount = dt * pressure * flow_fraction
			local neighbor_real_index = entry.index
			local neighbor_liquid = flow[neighbor_real_index]
			local old_amount = neighbor_liquid.amount
			local total_amount = new_amount + old_amount

			neighbor_liquid.amount = total_amount

			if use_linearized_flow then
				local relative_angle = entry.relative_angle
				local new_angle = starting_angle - relative_angle

				neighbor_liquid.angle = new_angle
			end

			if total_amount >= LIQUID_FULL_AMOUNT then
				add_list[neighbor_real_index] = true
			end
		end

		if all_done then
			remove_list[real_index] = true
		end
	end

	for real_index, _ in pairs(remove_list) do
		active_flow[real_index] = nil
	end

	for real_index, _ in pairs(add_list) do
		self:_set_filled(real_index)

		if self._num_filled_liquid == self._max_filled_liquid then
			self._flow_done = true

			break
		end
	end
end

local MAX_BROADPHASE_RADIUS = 50
local TEMP_POSITIONS = {}

LiquidAreaExtension._calculate_broadphase_size = function (self)
	local flow = self._flow
	local Vector3_max, Vector3_min = Vector3.max, Vector3.min
	local _, first_liquid = next(flow)
	local first_position = first_liquid.position:unbox()
	local max_position, min_position = first_position, first_position
	local num_liquid = 0

	for _, liquid in pairs(flow) do
		local position = liquid.position:unbox()

		max_position = Vector3_max(max_position, position)
		min_position = Vector3_min(min_position, position)
		num_liquid = num_liquid + 1
		TEMP_POSITIONS[num_liquid] = position
	end

	local Vector3_distance_squared = Vector3.distance_squared
	local max_distance_sq = -math.huge
	local center_position = (max_position + min_position) / 2

	for i = 1, num_liquid do
		local position = TEMP_POSITIONS[i]
		local distance_sq = Vector3_distance_squared(center_position, position)

		if max_distance_sq < distance_sq then
			max_distance_sq = distance_sq
		end

		TEMP_POSITIONS[i] = nil
	end

	self._broadphase_center:store(center_position)

	self._broadphase_radius = math.min(math.sqrt(max_distance_sq), MAX_BROADPHASE_RADIUS)

	local nav_cost_map_id = self._nav_cost_map_id

	if nav_cost_map_id and not self._nav_cost_map_volume_uses_cells then
		local nav_mesh_manager = Managers.state.nav_mesh
		local existing_broadphase_nav_cost_map_volume_id = self._broadphase_nav_cost_map_volume_id

		if existing_broadphase_nav_cost_map_volume_id then
			local transform = Matrix4x4.from_translation(center_position)

			nav_mesh_manager:set_nav_cost_map_volume_transform(existing_broadphase_nav_cost_map_volume_id, nav_cost_map_id, transform)
			nav_mesh_manager:set_nav_cost_map_volume_scale(existing_broadphase_nav_cost_map_volume_id, nav_cost_map_id, self._broadphase_radius)
		else
			local broadphase_nav_cost_map_volume_id = nav_mesh_manager:add_nav_cost_map_sphere_volume(center_position, self._broadphase_radius, self._nav_cost_map_cost, nav_cost_map_id)

			self._broadphase_nav_cost_map_volume_id = broadphase_nav_cost_map_volume_id
		end
	end
end

local TEMP_ALREADY_CHECKED_UNITS = {}
local BROADPHASE_RESULTS = {}

LiquidAreaExtension._update_collision_detection = function (self, t)
	local in_liquid_buff_template_name = self._in_liquid_buff_template_name

	if not in_liquid_buff_template_name then
		return
	end

	table.clear(TEMP_ALREADY_CHECKED_UNITS)

	local grid, buff_affected_units = self._grid, self._buff_affected_units
	local ALIVE = ALIVE

	for unit, buff_indices in pairs(buff_affected_units) do
		if not ALIVE[unit] or not self:_is_unit_colliding(grid, unit) then
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local local_index = buff_indices.local_index
				local component_index = buff_indices.component_index

				buff_extension:remove_externally_controlled_buff(local_index, component_index)

				local leaving_liquid_buff_template_name = self._leaving_liquid_buff_template_name

				if leaving_liquid_buff_template_name then
					buff_extension:add_internally_controlled_buff(leaving_liquid_buff_template_name, t, "owner_unit", self._source_unit, "source_item", self._optional_source_item)
				end
			end

			buff_affected_units[unit] = nil
		end

		TEMP_ALREADY_CHECKED_UNITS[unit] = true
	end

	local broadphase, side_names = self._broadphase, self._side_names
	local broadphase_center, broadphase_radius = self._broadphase_center:unbox(), self._broadphase_radius
	local num_results = broadphase.query(broadphase, broadphase_center, broadphase_radius, BROADPHASE_RESULTS, side_names)

	for i = 1, num_results do
		local unit = BROADPHASE_RESULTS[i]
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
		local is_companion_unit = unit_data_extension and unit_data_extension:is_companion()
		local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

		if buff_extension and not TEMP_ALREADY_CHECKED_UNITS[unit] and self:_is_unit_colliding(grid, unit) and (not self._forbidden_keyword or not buff_extension:has_keyword(self._forbidden_keyword)) and not is_companion_unit then
			local _, local_index, component_index = buff_extension:add_externally_controlled_buff(in_liquid_buff_template_name, t, "owner_unit", self._source_unit, "source_item", self._optional_source_item)

			buff_affected_units[unit] = {
				local_index = local_index,
				component_index = component_index
			}
		end
	end
end

LiquidAreaExtension._is_unit_colliding = function (self, grid, unit)
	local flow = self._flow
	local unit_position = POSITION_LOOKUP[unit]

	for index = 0, 1 do
		local i, j, k = grid:ijk_from_position(unit_position + index * Vector3.up())

		if grid:is_out_of_bounds(i, j, k) then
			return false
		end

		local real_index = grid:real_index_from_ijk(i, j, k)
		local liquid = flow[real_index]

		if liquid then
			if liquid.full then
				return true
			else
				return false
			end
		end
	end
end

LiquidAreaExtension.paint_liquid_at = function (self, position, optional_brush_size)
	local grid = self._grid
	local i, j, k = grid:ijk_from_position(position)

	if grid:is_out_of_bounds(i, j, k) then
		return
	end

	local real_index = grid:real_index_from_ijk(i, j, k)
	local flow = self._flow
	local liquid = flow[real_index]

	liquid = liquid or self:_create_liquid(real_index)

	if not liquid.full then
		self:_set_filled(real_index)
	end

	local brush_size = optional_brush_size or 0

	if brush_size > 0 then
		local _, num_directions = grid:directions()

		self:_fill_neighbors(liquid, num_directions, brush_size)
	end
end

LiquidAreaExtension.broadphase_center = function (self)
	local center = self._broadphase_center:unbox()

	return center
end

LiquidAreaExtension.liquid_paint_id = function (self)
	return self._liquid_paint_id
end

local TEMP_RI_TO_REMOVE = {}

LiquidAreaExtension.remove_any_cell_inside_of_radius = function (self, from_position, radius)
	if not self._flow_done then
		return
	end

	table.clear(TEMP_RI_TO_REMOVE)

	local flow = self._flow
	local size = 0

	for _, liquid in pairs(flow) do
		local position = liquid.position:unbox()

		if liquid.full then
			local distance = Vector3.distance(from_position, position)

			if distance < radius then
				TEMP_RI_TO_REMOVE[#TEMP_RI_TO_REMOVE + 1] = liquid.real_index
				size = size + 1
			end
		end

		if size >= max_size then
			break
		end
	end

	for i = 1, #TEMP_RI_TO_REMOVE do
		local liquid = flow[TEMP_RI_TO_REMOVE[i]]
		local particle_id = liquid.particle_id

		if particle_id then
			World.stop_spawning_particles(self._world, particle_id)
		end

		self._flow[liquid.real_index] = nil
	end

	Managers.state.game_session:send_rpc_clients("rpc_remove_liquid_multiple", self._game_object_id, TEMP_RI_TO_REMOVE)
end

return LiquidAreaExtension
