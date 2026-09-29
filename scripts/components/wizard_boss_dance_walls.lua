-- chunkname: @scripts/components/wizard_boss_dance_walls.lua

local WizardBossDanceWalls = component("WizardBossDanceWalls")
local FixedFrame = require("scripts/utilities/fixed_frame")
local CLIENT_RPCS = {
	"rpc_wizard_boss_start_rotation",
	"rpc_wizard_boss_dance_wall_hot_join_sync",
}
local SERVER_RPCS = {}
local RADIAN = math.pi * 2
local HITBOX_WIDTH = 1
local HITBOX_HEIGHT = 6
local HITBOX_LENGTH = 25
local WALL_FORWARD_OFFSET = 2.5
local HITBOX_HORIZONTAL_OFFSET = HITBOX_LENGTH / 2 + WALL_FORWARD_OFFSET
local HITBOX_VERTICAL_OFFSET = HITBOX_HEIGHT / 2
local ROTATION_DELTA = RADIAN / 8
local ROTATION_DURATION = 3.8
local SPAWN_RISE_DURATION = 5
local SPAWN_RISE_HEIGHT = HITBOX_HEIGHT
local SIDE_ID = 2
local COLLISION_FILTER = "filter_minion_melee"
local NUM_WALLS_PER_DIFFICULTY = {
	2,
	2,
	2,
	2,
	3,
}
local SFX_EVENTS = {
	loop = "wwise/events/world/play_event_spillway_boss_nurgle_wall_loop",
}

local function _offset_rotation(rotation, degrees_of_offset)
	return Quaternion.multiply(rotation, Quaternion.axis_angle(Vector3.up(), degrees_of_offset))
end

WizardBossDanceWalls.init = function (self, unit)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	local connection_manager = Managers.connection
	local network_event_delegate = connection_manager:network_event_delegate()

	self._network_event_delegate = network_event_delegate
	self._world = Managers.world:world("level_world")
	self._physics_world = World.physics_world(self._world)
	self._should_rotate = false
	self._rotation_target_quat = nil
	self._rotation_start_quat = nil
	self._rotation_start_time = 0
	self._cumulative_rotation = 0
	self._num_walls = Managers.state.difficulty and Managers.state.difficulty:get_table_entry_by_challenge(NUM_WALLS_PER_DIFFICULTY)
	self._hitbox_extents = Vector3Box(HITBOX_WIDTH / 2, HITBOX_LENGTH / 2, HITBOX_HEIGHT / 2)
	self._sfx_source_ids = {}

	local world = Managers.world:world("level_world")

	self._world = world

	local wwise_world = Managers.world:wwise_world(world)

	self._wwise_world = wwise_world
	self._wall_transforms = {}

	for i = 1, self._num_walls do
		self._wall_transforms[i] = {
			sfx_node_positions = {},
		}
	end

	if self.is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
		self:_server_init(unit)
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._wall_particles = self:_spawn_wall_particles(unit)
	self._spawn_start_time = FixedFrame.get_latest_fixed_time()

	return true
end

WizardBossDanceWalls._server_init = function (self, unit)
	self._group_system = Managers.state.extension:system("group_system")

	local side_system = Managers.state.extension:system("side_system")
	local side_names = side_system:side_names()
	local side_name = side_names[SIDE_ID]
	local side = side_system:get_side_from_name(side_name)

	self._enemy_sides = side:relation_sides("enemy")
	self._timer = 0
	self._progress = 0
	self._unit = unit
	self._is_rotating = false
	self._start_frame_server = 0
	self._overlapping_units = {}
	self._sweep_t = 0
end

WizardBossDanceWalls.hot_join_sync = function (self, joining_client, joining_channel)
	if not self.is_server then
		return
	end

	local unit = self.unit
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	if not game_object_id then
		return
	end

	local rotation_target_quat = self._rotation_target_quat
	local rotation_start_quat = self._rotation_start_quat

	RPC.rpc_wizard_boss_dance_wall_hot_join_sync(joining_channel, game_object_id, Unit.world_rotation(unit, 1), self._should_rotate or false, self._is_rotating or false, rotation_target_quat and rotation_target_quat:unbox(), rotation_start_quat and rotation_start_quat:unbox(), self._start_frame_server or 0)
end

WizardBossDanceWalls.rpc_wizard_boss_dance_wall_hot_join_sync = function (self, channel, game_object_id, inital_rotation, should_rotate, is_rotating, rotation_target, rotation_start, start_frame)
	Unit.set_local_rotation(self.unit, 1, inital_rotation)

	self._should_rotate = should_rotate
	self._start_frame = start_frame

	if not should_rotate then
		return
	end

	local is_mid_rotation = is_rotating and rotation_target and rotation_start

	if not is_mid_rotation then
		self._catch_up_with_server = true

		return
	end

	local fixed_frame_time = Managers.state.game_session.fixed_time_step

	self._rotation_start_quat = QuaternionBox(rotation_start)
	self._rotation_target_quat = QuaternionBox(rotation_target)
	self._rotation_start_time = start_frame * fixed_frame_time
	self._start_time = FixedFrame.get_latest_fixed_frame() * fixed_frame_time
end

WizardBossDanceWalls.editor_init = function (self, unit)
	self:enable(unit)

	self._should_debug_draw = false
end

WizardBossDanceWalls.enable = function (self, unit)
	return
end

WizardBossDanceWalls.disable = function (self, unit)
	return
end

WizardBossDanceWalls.destroy = function (self, unit)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	if self.is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	for i = 1, #self._sfx_source_ids do
		local wwise_source_id = self._sfx_source_ids[i]

		WwiseWorld.destroy_manual_source(self._wwise_world, wwise_source_id)
	end

	local world = self._world
	local wall_particles = self._wall_particles

	if wall_particles then
		for i = 1, #wall_particles do
			local particles = wall_particles[i]

			for j = 1, #particles do
				World.stop_spawning_particles(world, particles[j])
			end
		end
	end
end

WizardBossDanceWalls.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

WizardBossDanceWalls.update = function (self, unit, dt, t)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	local unit_position = Unit.world_position(unit, 1)
	local unit_rotation = Unit.world_rotation(unit, 1)
	local wall_transform_data = self:_get_wall_transforms(unit, unit_rotation, unit_position, t)

	if self.is_server then
		self:_server_update(unit, dt, t, wall_transform_data)
	elseif not self.is_server then
		self:_client_update(unit, dt, t)
	end

	if not DEDICATED_SERVER then
		self:_update_sfx(wall_transform_data)
		self:_update_wall_particles(wall_transform_data)
	end

	if self._rotation_target_quat then
		local progress = math.clamp((t - self._rotation_start_time) / ROTATION_DURATION, 0, 1)

		self._progress = progress

		local new_rot = Quaternion.lerp(self._rotation_start_quat:unbox(), self._rotation_target_quat:unbox(), progress)

		Unit.set_local_rotation(unit, 1, new_rot)

		if progress >= 1 then
			self._rotation_target_quat = nil
			self._rotation_start_quat = nil
			self._should_rotate = false
			self._cumulative_rotation = self._cumulative_rotation + ROTATION_DELTA
		end
	elseif self._should_rotate then
		local target_rot = _offset_rotation(unit_rotation, ROTATION_DELTA)

		self._rotation_start_quat = QuaternionBox(unit_rotation)
		self._rotation_target_quat = QuaternionBox(target_rot)
		self._rotation_start_time = self._start_time or t
	end

	return true
end

WizardBossDanceWalls._update_sfx = function (self, wall_transform_data)
	local wwise_world = self._wwise_world

	if not self._wwise_setup then
		for i = 1, self._num_walls do
			local wall_sfx_positions = wall_transform_data[i].sfx_node_positions
			local source_ids = {}

			for ii = 1, #wall_sfx_positions do
				local wanted_position = wall_sfx_positions[ii]
				local rotation = Quaternion.look(wanted_position)
				local source_id = WwiseWorld.make_manual_source(wwise_world, wanted_position, rotation)

				source_ids[ii] = source_id
				self._sfx_source_ids[#self._sfx_source_ids + 1] = source_id

				WwiseWorld.trigger_resource_event(wwise_world, SFX_EVENTS.loop, source_id)
			end

			wall_transform_data[i].sfx_source_ids = source_ids
		end

		self._wwise_setup = true

		return
	end

	for i = 1, self._num_walls do
		local wall_sfx_positions = wall_transform_data[i].sfx_node_positions
		local source_ids = wall_transform_data[i].sfx_source_ids

		for ii = 1, #source_ids do
			WwiseWorld.set_source_position(wwise_world, source_ids[ii], wall_sfx_positions[ii])
		end
	end
end

local SWEEP_TIME_OFFSET = 0.1

WizardBossDanceWalls._server_update = function (self, unit, dt, t, wall_transform_data)
	self._start_time = t

	if self._rotation_target_quat then
		self._is_rotating = true
	else
		self._is_rotating = false
	end

	local bot_groups = self._group_system:bot_groups_from_sides(self._enemy_sides)

	for i = 1, #bot_groups do
		self:update_bot_safe_spot_target(t, bot_groups[i]:data(), wall_transform_data)
	end

	local can_damage = self:_has_fully_risen(t)

	if can_damage and t > self._sweep_t then
		self:_obb_checks(wall_transform_data, unit)

		self._sweep_t = SWEEP_TIME_OFFSET + t
	end
end

WizardBossDanceWalls._client_update = function (self, unit, dt, t, wall_transforms)
	if self._catch_up_with_server then
		self:_catchup()
	end
end

WizardBossDanceWalls._catchup = function (self)
	local fixed_frame_time = Managers.state.game_session.fixed_time_step
	local current_frame = FixedFrame.get_latest_fixed_frame()
	local start_frame = self._start_frame
	local start_time = start_frame * fixed_frame_time
	local frames_elapsed = current_frame - start_frame
	local time_elapsed = frames_elapsed * fixed_frame_time
	local fake_t = start_time + time_elapsed

	self._start_time = fake_t
	self._catch_up_with_server = false
end

local CHECKED_OOBB_UNITS = {}

WizardBossDanceWalls._obb_checks = function (self, wall_data, unit)
	local extents = self._hitbox_extents:unbox()

	for i = 1, #wall_data do
		local data = wall_data[i]
		local position, rotation = data.hit_box_position, data.hit_box_rotation
		local actors, actor_count = PhysicsWorld.immediate_overlap(self._physics_world, "position", position, "rotation", rotation, "size", extents, "shape", "oobb", "types", "dynamics", "collision_filter", COLLISION_FILTER)

		table.clear(CHECKED_OOBB_UNITS)

		for j = 1, actor_count do
			local actor = actors[j]
			local hit_unit = Actor.unit(actor)

			if HEALTH_ALIVE[hit_unit] and not CHECKED_OOBB_UNITS[hit_unit] and hit_unit ~= unit then
				CHECKED_OOBB_UNITS[hit_unit] = true

				self:players_overlapping(hit_unit)
			end
		end
	end
end

WizardBossDanceWalls._get_spawn_rise_progress = function (self, t)
	local spawn_start_time = self._spawn_start_time

	if not t or not spawn_start_time then
		return 0
	end

	local rise_end_time = spawn_start_time + SPAWN_RISE_DURATION

	return math.ilerp(spawn_start_time, rise_end_time, t)
end

WizardBossDanceWalls._get_spawn_rise_z_offset = function (self, t)
	local rise_progress = self:_get_spawn_rise_progress(t)

	return math.lerp(-SPAWN_RISE_HEIGHT, 0, math.easeOutCubic(rise_progress))
end

WizardBossDanceWalls._has_fully_risen = function (self, t)
	return self:_get_spawn_rise_progress(t) >= 1
end

WizardBossDanceWalls._get_wall_transforms = function (self, unit, unit_rotation, unit_position, t)
	local x, y, z = Vector3.to_elements(unit_position)
	local visual_position = Vector3(x, y, z + self:_get_spawn_rise_z_offset(t))

	for i = 1, self._num_walls do
		table.clear(self._wall_transforms[i].sfx_node_positions)

		local wall_rotation = _offset_rotation(unit_rotation, RADIAN / self._num_walls * (i - 1))
		local forward = Quaternion.forward(wall_rotation)
		local up = Vector3.up()
		local hit_box_position = unit_position + forward * HITBOX_HORIZONTAL_OFFSET + up * HITBOX_VERTICAL_OFFSET
		local hit_box_rotation = Quaternion.look(forward, up)

		self._wall_transforms[i].position = visual_position
		self._wall_transforms[i].rotation = wall_rotation
		self._wall_transforms[i].hit_box_position = hit_box_position
		self._wall_transforms[i].hit_box_rotation = hit_box_rotation
		self._wall_transforms[i].sfx_node_positions[1] = hit_box_position + forward * WALL_FORWARD_OFFSET + up
		self._wall_transforms[i].sfx_node_positions[2] = hit_box_position
		self._wall_transforms[i].sfx_node_positions[3] = unit_position + forward * HITBOX_LENGTH + up
	end

	return self._wall_transforms
end

WizardBossDanceWalls.players_overlapping = function (self, unit)
	if not self.is_server then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_extension then
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff("spillway_wizard_warp_lightning", t)
	end
end

WizardBossDanceWalls.start_rotation = function (self)
	if not self.is_server then
		return
	end

	self._should_rotate = true

	local start_frame = FixedFrame.get_latest_fixed_frame()

	self._start_frame_server = start_frame

	Managers.state.game_session:send_rpc_clients("rpc_wizard_boss_start_rotation", true, start_frame)
end

WizardBossDanceWalls.has_completed_full_rotation = function (self)
	return self._cumulative_rotation >= RADIAN - 0.0001
end

WizardBossDanceWalls.reset_rotation_tracking = function (self)
	self._cumulative_rotation = 0
end

WizardBossDanceWalls.rpc_wizard_boss_start_rotation = function (self, channel_id, should_rotate, start_frame)
	self._should_rotate = should_rotate
	self._start_frame = start_frame
	self._catch_up_with_server = true
end

WizardBossDanceWalls.set_center_position = function (self, center_position)
	self._center_position_flat = Vector3Box(Vector3.flat(center_position))
end

local function _get_position_between_walls(center_pos_flat, bot_pos_flat, wall_data)
	local num_walls = #wall_data
	local half_spacing = Quaternion.axis_angle(Vector3.up(), RADIAN / num_walls / 2)
	local to_bot_pos = Vector3.normalize(bot_pos_flat - center_pos_flat)
	local highest_dot, best_pos

	for i = 1, num_walls do
		local wall_position_flat = Vector3.flat(wall_data[i].hit_box_position)
		local to_wall_pos = wall_position_flat - center_pos_flat
		local gap_direction = Quaternion.rotate(half_spacing, Vector3.normalize(to_wall_pos))
		local dot = Vector3.dot(gap_direction, to_bot_pos)

		if not highest_dot or highest_dot < dot then
			best_pos = center_pos_flat + gap_direction * Vector3.length(to_wall_pos)
			highest_dot = dot
		end
	end

	return best_pos
end

WizardBossDanceWalls.update_bot_safe_spot_target = function (self, t, bot_data, wall_data)
	local center_position_flat = self._center_position_flat

	if not center_position_flat or #wall_data == 0 then
		return
	end

	local center_pos_flat = center_position_flat:unbox()

	for unit, data in pairs(bot_data) do
		local hover_target_data = data.hover_target
		local is_expired = t > hover_target_data.expires

		if not is_expired then
			local bot_pos_flat = Vector3.flat(POSITION_LOOKUP[unit])
			local wanted_pos_flat = _get_position_between_walls(center_pos_flat, bot_pos_flat, wall_data)
			local wanted_direction = Vector3.normalize(wanted_pos_flat - center_pos_flat)

			hover_target_data.rotation = QuaternionBox(Quaternion.look(wanted_direction, Vector3.up()))
		end
	end
end

local VFX_RESOURCE = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_wall_nurgle"
local NUM_WALL_SECTIONS = 6
local WALL_LENGTH = 22 / NUM_WALL_SECTIONS

local function _section_world_position(wall_position, wall_rotation, section_index)
	local along_wall = Vector3.forward() * (section_index - 1) * WALL_LENGTH

	return wall_position + Quaternion.rotate(wall_rotation, along_wall)
end

WizardBossDanceWalls._spawn_wall_particles = function (self, unit)
	local unit_position = Unit.world_position(unit, 1)
	local unit_rotation = Unit.world_rotation(unit, 1)
	local wall_transform_data = self:_get_wall_transforms(unit, unit_rotation, unit_position)
	local world = self._world
	local wall_particles = {}

	for i = 1, self._num_walls do
		local wall_rotation = wall_transform_data[i].rotation
		local wall_position = wall_transform_data[i].position
		local particles = {}

		for j = 1, NUM_WALL_SECTIONS do
			local particle_position = _section_world_position(wall_position, wall_rotation, j)

			particles[j] = World.create_particles(world, VFX_RESOURCE, particle_position, wall_rotation)
		end

		wall_particles[i] = particles
	end

	return wall_particles
end

WizardBossDanceWalls._update_wall_particles = function (self, wall_transform_data)
	local world = self._world
	local wall_particles = self._wall_particles

	if not wall_particles then
		return
	end

	for i = 1, #wall_particles do
		local particles = wall_particles[i]
		local wall_position = wall_transform_data[i].position
		local wall_rotation = wall_transform_data[i].rotation

		for j = 1, #particles do
			local particle_position = _section_world_position(wall_position, wall_rotation, j)

			World.move_particles(world, particles[j], particle_position, wall_rotation)
		end
	end
end

function _offset_rotation(rotation, added_radians)
	return Quaternion.multiply(rotation, Quaternion.axis_angle(Vector3.up(), added_radians))
end

WizardBossDanceWalls.component_data = {
	inputs = {
		player_overlapping = {
			accessibility = "public",
			type = "event",
		},
		start_rotation = {
			accessibility = "public",
			type = "event",
		},
	},
}

return WizardBossDanceWalls
