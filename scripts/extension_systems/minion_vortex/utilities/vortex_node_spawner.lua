-- chunkname: @scripts/extension_systems/minion_vortex/utilities/vortex_node_spawner.lua

local VortexLocomotion = require("scripts/extension_systems/locomotion/utilities/vortex_locomotion")
local VortexNodeSpawner = class("VortexNodeSpawner")

VortexNodeSpawner.init = function (self, settings, world)
	local vortex_template = settings.vortex_template

	self._vortex_template = vortex_template
	self._vortex_height = vortex_template.vortex_height
	self._inner_radius = vortex_template.inner_radius
	self._outer_radius = vortex_template.outer_radius
	self._node_count = vortex_template.node_count
	self._node_lifetime = vortex_template.node_lifetime
	self._max_grow_time = vortex_template.max_grow_time
	self._spawn_mode = vortex_template.spawn_mode
	self._start_angle = settings.start_angle
	self._vfx_particle_names = settings.vfx_particle_names or {}
	self._nodes = {}
	self._start_position = settings.start_position
	self._world = world

	local node_life = self._node_lifetime
	local interval = node_life / self._node_count

	for i = self._node_count, 1, -1 do
		local start_duration = i * interval

		if self._spawn_mode == "stagger" then
			start_duration = start_duration * -1
		else
			start_duration = i * interval
		end

		self:_add_node(start_duration)
	end
end

VortexNodeSpawner._add_node = function (self, start_duration)
	local vfx_particle_names = self._vfx_particle_names

	self._nodes[#self._nodes + 1] = {
		duration = start_duration or 0,
		spawn_particles = #vfx_particle_names > 0,
	}
end

VortexNodeSpawner._spawn_node_particles = function (self, node)
	local world = self._world
	local start_position = self._start_position
	local start_position_vector = Vector3.from_array(start_position)
	local vfx_particle_names = self._vfx_particle_names
	local vfx_particle_ids = {}

	for i = 1, #vfx_particle_names do
		local vfx_name = vfx_particle_names[i]
		local vfx_particle_id = World.create_particles(world, vfx_name, start_position_vector, Quaternion.identity())

		vfx_particle_ids[#vfx_particle_ids + 1] = vfx_particle_id
	end

	node.vfx_particle_ids = vfx_particle_ids
	node.spawn_particles = false
end

VortexNodeSpawner._delete_node = function (self, node)
	local world = self._world
	local vfx_particle_ids = node.vfx_particle_ids

	if vfx_particle_ids then
		for i = 1, #vfx_particle_ids do
			local vfx_particle_id = vfx_particle_ids[i]

			World.destroy_particles(world, vfx_particle_id)
		end

		table.clear(vfx_particle_ids)
	end
end

VortexNodeSpawner._offset_by_height = function (self, vortex_lifetime, height, max_height, max_width, dt, t)
	local outer_radius = self._outer_radius
	local vortex_width_max = outer_radius * 2
	local sin_offset_progress = 0.5 + math.sin(vortex_lifetime + height * 0.25) * 0.5
	local cos_offset_progress = 0.5 + math.cos(vortex_lifetime + height * 0.25) * 0.5
	local vortex_width_anim_offset = vortex_width_max * math.clamp((height - 1) / (max_height - 1), 0, 1)
	local pivot_offset_x = sin_offset_progress * vortex_width_anim_offset
	local pivot_offset_y = cos_offset_progress * vortex_width_anim_offset

	return pivot_offset_x, pivot_offset_y
end

VortexNodeSpawner.update = function (self, vortex_lifetime, growth_progress, parent_position, dt, t)
	local world = self._world
	local vortex_height_max = self._vortex_height
	local outer_radius = self._outer_radius
	local vortex_width_max = outer_radius * 2
	local two_pi = 2 * math.pi
	local vortex_height = vortex_height_max * 0.1 + vortex_height_max * 0.9 * growth_progress
	local total_node_laps = vortex_height_max
	local total_laps_radians = total_node_laps * two_pi
	local node_lifetime = self._node_lifetime
	local start_angle = self._start_angle
	local vortex_template = self._vortex_template
	local nodes = self._nodes
	local node_count = self._node_count
	local previous_node_position

	for i = #nodes, 1, -1 do
		local node = nodes[i]
		local duration = node.duration
		local duration_progress = math.min(node.duration / node_lifetime, 1)
		local anim_progress = 1 - (1 - duration_progress)^2
		local node_height = vortex_height * anim_progress
		local node_radius = vortex_width_max * 0.2 + vortex_width_max * 0.8 * anim_progress
		local angle_anim_progress = math.ease_out_quad(duration_progress)
		local angle0 = start_angle + two_pi / node_count
		local angle = angle0 + total_laps_radians * angle_anim_progress
		local node_pos_x = math.cos(angle) * node_radius
		local node_pos_y = math.sin(angle) * node_radius
		local pivot_offset_x, pivot_offset_y = VortexLocomotion.pivot_offset_by_height(vortex_template, node_height, vortex_lifetime)
		local node_position = Vector3(parent_position.x + node_pos_x + pivot_offset_x, parent_position.y + node_pos_y + pivot_offset_y, parent_position.z + node_height)
		local positive_height = node_position.z >= parent_position.z
		local vfx_particle_ids = node.vfx_particle_ids

		if vfx_particle_ids then
			for j = 1, #vfx_particle_ids do
				local vfx_particle_id = vfx_particle_ids[j]

				World.move_particles(world, vfx_particle_id, node_position)
			end
		elseif positive_height and node.spawn_particles then
			self:_spawn_node_particles(node)
		end

		if duration_progress >= 1 then
			self:_delete_node(node)
			table.remove(nodes, i)
			self:_add_node()

			previous_node_position = nil
		else
			node.duration = duration + dt
		end
	end
end

VortexNodeSpawner.destroy = function (self)
	local nodes = self._nodes

	for i = #nodes, 1, -1 do
		local node = nodes[i]

		self:_delete_node(node)
	end

	table.clear(nodes)
end

return VortexNodeSpawner
