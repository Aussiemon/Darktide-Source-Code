-- chunkname: @scripts/extension_systems/area_of_effect/area_of_effect_unit_spawner_extension.lua

local AreaOfEffectLocalUnitPathTypes = require("scripts/extension_systems/area_of_effect/area_of_effect_local_unit_path_types")
local AreaOfEffectUnitSpawnerTemplates = require("scripts/extension_systems/area_of_effect/area_of_effect_unit_spawner_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local DESYNC_MARGIN = 1
local AreaOfEffectUnitSpawnerExtension = class("AreaOfEffectUnitSpawnerExtension")

AreaOfEffectUnitSpawnerExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit
	self._world = extension_init_context.world
	self._wwise_world = extension_init_context.wwise_world
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server
	self._owner_unit = extension_init_data.owner_unit

	local aoe_template_name = extension_init_data.aoe_template_name
	local template = AreaOfEffectUnitSpawnerTemplates[aoe_template_name]
	local salvo = template.salvo

	if salvo then
		self._salvo_data = {
			next_spread_time = nil,
			num_salvos_spawned = 0,
			num_spread_units_spawned = nil,
			salvo = salvo,
			seed = extension_init_data.salvo_seed,
			source_position = Vector3Box(),
			next_salvo_time = salvo.initial_salvo_delay or 0,
		}
	end

	self._queued_sfx = {}
	self._queued_vfx = {}
	self._queued_explosions = {}
	self._local_units = {}
	self._cb_cancellation_token = {
		cancelled = false,
	}
	self._safe_raycast_cb = callback(self, "_async_raycast_result_cb", self._cb_cancellation_token)
	self._raycast_object = Managers.state.game_mode:create_safe_raycast_object("closest", "types", "statics", "collision_filter", "filter_player_character_shooting_raycast_statics")
end

AreaOfEffectUnitSpawnerExtension.update = function (self, unit, dt, t)
	self:_update_salvo(dt)
	self:_update_local_units(dt)
	self:_update_queued_sfx(dt)
	self:_update_queued_vfx(dt)
	self:_update_queued_explosions(dt)
end

AreaOfEffectUnitSpawnerExtension._update_salvo = function (self, dt)
	local salvo_data = self._salvo_data

	if not salvo_data then
		return
	end

	local next_spread_time = salvo_data.next_spread_time

	if next_spread_time then
		self:_handle_spread(salvo_data, dt, next_spread_time)
	elseif salvo_data.next_salvo_time then
		self:_handle_salvo(salvo_data, dt)
	end

	self:_check_should_mark_for_deletion(salvo_data, dt)
end

AreaOfEffectUnitSpawnerExtension._update_local_units = function (self, dt)
	local local_units = self._local_units

	for i = #local_units, 1, -1 do
		local data = local_units[i]

		data.time_in_path = data.time_in_path + dt

		if data.time_in_path > data.path_time then
			World.destroy_unit(self._world, data.unit)
			table.swap_delete(local_units, i)
		else
			local path_type = data.path_type

			if path_type == AreaOfEffectLocalUnitPathTypes.arc then
				self:_update_arc_movement(data)
			end
		end
	end
end

local function _extrapolate_arc_position(from, to, total_time, arrival_angle, time_in_path, initial_path_progress)
	time_in_path = math.clamp(time_in_path, 0, total_time)
	time_in_path = math.remap(0, total_time, initial_path_progress * total_time, total_time, time_in_path)

	local progress = time_in_path / total_time
	local peak_height = math.tan(arrival_angle) * 0.25 * Vector3.distance(from, to)
	local half_time = total_time * 0.5
	local gravity = peak_height / (0.5 * half_time^2)
	local current_height = peak_height - 0.5 * gravity * (time_in_path - half_time)^2
	local expected_position = from + (to - from) * progress

	expected_position[3] = to[3] + current_height

	return expected_position
end

AreaOfEffectUnitSpawnerExtension._update_arc_movement = function (self, local_unit_data)
	local unit = local_unit_data.unit
	local time_in_path = local_unit_data.time_in_path
	local from = local_unit_data.origin:unbox()
	local to = local_unit_data.target_position:unbox()
	local total_time = local_unit_data.path_time
	local arrival_angle = local_unit_data.arrival_angle
	local initial_path_progress = local_unit_data.initial_path_progress
	local expected_position = _extrapolate_arc_position(from, to, total_time, arrival_angle, time_in_path, initial_path_progress)
	local current_position = Unit.local_position(unit, 1)

	Unit.set_local_position(unit, 1, expected_position)
	Unit.set_local_rotation(unit, 1, Quaternion.look(expected_position - current_position))
end

AreaOfEffectUnitSpawnerExtension._update_queued_sfx = function (self, dt)
	local queued_sfx = self._queued_sfx

	for i = #queued_sfx, 1, -1 do
		local data = queued_sfx[i]
		local delay = data.delay - dt

		if delay < 0 then
			self:_play_sfx(data.sfx_name, Vector3(data.x, data.y, data.z))
			table.swap_delete(queued_sfx, i)
		end

		data.delay = delay
	end
end

AreaOfEffectUnitSpawnerExtension._update_queued_vfx = function (self, dt)
	local queued_vfx = self._queued_vfx

	for i = #queued_vfx, 1, -1 do
		local data = queued_vfx[i]
		local delay = data.delay - dt

		if delay < 0 then
			self:_play_vfx(data.sfx_name, Vector3(data.x, data.y, data.z))
			table.swap_delete(queued_vfx[i])
		end

		data.delay = delay
	end
end

AreaOfEffectUnitSpawnerExtension._update_queued_explosions = function (self, dt)
	local queued_explosions = self._queued_explosions

	for i = #queued_explosions, 1, -1 do
		local data = queued_explosions[i]
		local delay = data.delay - dt

		if delay < 0 then
			self:_play_explosion(data.explosion_template_name, Vector3(data.x, data.y, data.z), Quaternion.from_elements(data.qx, data.qy, data.qz, data.qw))
			table.swap_delete(queued_explosions, i)
		end

		data.delay = delay
	end
end

AreaOfEffectUnitSpawnerExtension._handle_spread = function (self, salvo_data, dt, next_spread_time)
	next_spread_time = next_spread_time - dt

	if next_spread_time < 0 then
		local spread = salvo_data.salvo.spread
		local inner_radius = spread.inner_radius or 0
		local outer_radius = spread.radius
		local seed = salvo_data.seed
		local dx, dy
		local num_spread_units_spawned = salvo_data.num_spread_units_spawned + 1

		if spread.first_shot_radius and num_spread_units_spawned == 1 then
			seed, dx, dy = math.get_uniformly_random_point_inside_sector_seeded(seed, 0, spread.first_shot_radius, 0, math.pi * 2)
		else
			seed, dx, dy = math.get_uniformly_random_point_inside_sector_seeded(seed, inner_radius, outer_radius, 0, math.pi * 2)
		end

		local raycast_height = spread.raycast_height
		local margin = 10
		local from_pos = Unit.local_position(self._unit, 1)

		from_pos[1] = from_pos[1] + dx
		from_pos[2] = from_pos[2] + dy
		from_pos[3] = from_pos[3] + raycast_height

		Managers.state.game_mode:add_safe_raycast(self._raycast_object, from_pos, Vector3.down(), raycast_height + margin, self._safe_raycast_cb)

		if num_spread_units_spawned >= spread.num_spread_units then
			next_spread_time = nil
			num_spread_units_spawned = nil
		else
			local spread_delay = spread.spread_delay

			if type(spread_delay) == "table" then
				local random_delay

				seed, random_delay = math.next_random(seed)
				spread_delay = spread_delay[1] + (spread_delay[2] - spread_delay[1]) * random_delay
			end

			next_spread_time = next_spread_time + spread_delay
		end

		salvo_data.num_spread_units_spawned = num_spread_units_spawned
		salvo_data.seed = seed
	end

	salvo_data.next_spread_time = next_spread_time
end

AreaOfEffectUnitSpawnerExtension._handle_salvo = function (self, salvo_data, dt)
	local next_salvo_time = salvo_data.next_salvo_time - dt

	if next_salvo_time < 0 then
		local salvo = salvo_data.salvo
		local seed = salvo_data.seed

		if salvo.generate_source_position then
			local source_position

			seed, source_position = salvo.generate_source_position(seed, self._unit)

			salvo_data.source_position:store(source_position)
		end

		self:_check_play_sfx(salvo, Unit.local_position(self._unit, 1))

		local spread = salvo.spread

		if spread then
			salvo_data.next_spread_time = spread.initial_spread_delay or 0
			salvo_data.num_spread_units_spawned = 0
		end

		local num_salvos_spawned = salvo_data.num_salvos_spawned + 1

		if num_salvos_spawned >= salvo.num_salvos then
			next_salvo_time = nil
		else
			local time_between_salvos = salvo.time_between_salvos

			if type(time_between_salvos) == "table" then
				local random_delay

				seed, random_delay = math.next_random(seed)
				time_between_salvos = time_between_salvos[1] + (time_between_salvos[2] - time_between_salvos[1]) * random_delay
			end

			next_salvo_time = next_salvo_time + time_between_salvos
		end

		salvo_data.num_salvos_spawned = num_salvos_spawned
		salvo_data.seed = seed
	end

	salvo_data.next_salvo_time = next_salvo_time
end

AreaOfEffectUnitSpawnerExtension._async_raycast_result_cb = function (self, cb_cancellation_token, id, data, hit, hit_position)
	if cb_cancellation_token.cancelled or not hit then
		return
	end

	self:_spawn_spread(hit_position)
end

AreaOfEffectUnitSpawnerExtension._spawn_spread = function (self, position)
	local spread_data = self._salvo_data.salvo.spread

	self:_check_play_sfx(spread_data, position)

	local explosion = spread_data.explosion

	if explosion then
		local explosion_position = position
		local explosion_rotation = Quaternion.identity()

		if explosion.rotate_flat_towards_source_position then
			explosion_rotation = Quaternion.flat_no_roll(Quaternion.look(self._salvo_data.source_position:unbox() - position))
		end

		local explosion_template = explosion.explosion_template_name

		if explosion.delay then
			self:_queue_explosion(explosion_template, explosion.delay, explosion_position, explosion_rotation)
		else
			self:_play_explosion(explosion_template, explosion_position, explosion_rotation)
		end
	end

	local local_unit = spread_data.local_unit

	if local_unit then
		self:_spawn_local_unit(local_unit.unit_name, local_unit.path_type, local_unit.path_time, local_unit.arrival_angle, position, local_unit.initial_path_progress)
	end
end

AreaOfEffectUnitSpawnerExtension._check_play_sfx = function (self, data, position)
	local sfxs = data.sfxs

	if sfxs then
		for i = 1, #sfxs do
			local sfx = sfxs[i]
			local sfx_position = Vector3.from_array(position)

			if sfx.play_from_source_position then
				sfx_position = self._salvo_data.source_position:unbox()
			end

			if sfx.offset then
				sfx_position[1] = sfx_position[1] + sfx.offset[1]
				sfx_position[2] = sfx_position[2] + sfx.offset[2]
				sfx_position[3] = sfx_position[3] + sfx.offset[3]
			end

			if sfx.delay then
				self:_queue_sfx(sfx.sfx_name, sfx.delay, sfx_position)
			else
				self:_play_sfx(sfx.sfx_name, sfx_position)
			end
		end
	end
end

AreaOfEffectUnitSpawnerExtension._queue_sfx = function (self, sfx_name, delay, position)
	self._queued_sfx[#self._queued_sfx + 1] = {
		sfx_name = sfx_name,
		delay = delay,
		x = position[1],
		y = position[2],
		z = position[3],
	}
end

AreaOfEffectUnitSpawnerExtension._play_sfx = function (self, sfx_name, position)
	local source_id = WwiseWorld.make_auto_source(self._wwise_world, position)

	WwiseWorld.trigger_resource_event(self._wwise_world, sfx_name, source_id)
end

AreaOfEffectUnitSpawnerExtension._queue_vfx = function (self, vfx, delay, position)
	self._queued_vfx[#self._queued_vfx + 1] = {
		vfx = vfx,
		delay = delay,
		x = position[1],
		y = position[2],
		z = position[3],
	}
end

AreaOfEffectUnitSpawnerExtension._play_vfx = function (self, vfx, position)
	return
end

AreaOfEffectUnitSpawnerExtension._spawn_local_unit = function (self, unit_name, path_type, path_time, arrival_angle, target_position, initial_path_progress)
	local source_position = self._salvo_data.source_position:unbox()
	local unit = World.spawn_unit_ex(self._world, unit_name, source_position)
	local origin = Vector3Box(source_position)

	origin[3] = target_position[3]

	local particle_id = World.create_particles(self._world, "content/fx/particles/weapons/grenades/expeditions/artillery_strike_projectile", Vector3.zero())

	World.link_particles(self._world, particle_id, unit, 1, Matrix4x4.identity(), "stop")

	local local_units = self._local_units

	local_units[#local_units + 1] = {
		time_in_path = 0,
		unit = unit,
		path_type = path_type,
		path_time = path_time,
		arrival_angle = arrival_angle,
		target_position = Vector3Box(target_position),
		origin = origin,
		initial_path_progress = initial_path_progress,
	}
end

AreaOfEffectUnitSpawnerExtension._queue_explosion = function (self, explosion_template_name, delay, position, rotation)
	local qx, qy, qz, qw = Quaternion.to_elements(rotation)

	self._queued_explosions[#self._queued_explosions + 1] = {
		explosion_template_name = explosion_template_name,
		delay = delay,
		x = position[1],
		y = position[2],
		z = position[3],
		qx = qx,
		qy = qy,
		qz = qz,
		qw = qw,
	}
end

AreaOfEffectUnitSpawnerExtension._play_explosion = function (self, explosion_template_name, position, rotation)
	local explosion_func = self._is_server and Explosion.create_explosion or Explosion.predict_explosion
	local attacking_unit = self._unit
	local explosion_template = ExplosionTemplates[explosion_template_name]
	local power_level
	local charge_level = 1
	local attack_type
	local is_critical_strike = false
	local ignore_cover = true
	local item_or_nil, origin_slot_or_nil, optional_hit_units_table
	local optional_attacking_unit_owner_unit = self._owner_unit
	local optional_apply_owner_buffs
	local predicted = false
	local optional_line_of_sight = false
	local skip_sync = true

	explosion_func(self._world, self._physics_world, position, nil, attacking_unit, explosion_template, power_level, charge_level, attack_type, is_critical_strike, ignore_cover, item_or_nil, origin_slot_or_nil, optional_hit_units_table, optional_attacking_unit_owner_unit, optional_apply_owner_buffs, predicted, optional_line_of_sight, skip_sync)
end

AreaOfEffectUnitSpawnerExtension._check_should_mark_for_deletion = function (self, salvo_data, dt)
	if not self._is_server then
		return
	end

	local deletion_time = self._deletion_time

	if deletion_time then
		deletion_time = deletion_time - dt
		self._deletion_time = deletion_time

		if deletion_time < 0 then
			Managers.state.unit_spawner:mark_for_deletion(self._unit)
		end

		return
	end

	if salvo_data.next_salvo_time or salvo_data.next_spread_time then
		return
	end

	if next(self._queued_sfx) or next(self._queued_vfx) or next(self._queued_explosions) or next(self._local_units) then
		return
	end

	if salvo_data.salvo.put_owner_to_sleep_when_done then
		local locomotion_extension = ScriptUnit.has_extension(self._owner_unit, "locomotion_system")

		if locomotion_extension then
			locomotion_extension:switch_to_sleep()
		end
	end

	self._deletion_time = DESYNC_MARGIN
end

AreaOfEffectUnitSpawnerExtension.destroy = function (self)
	self._cb_cancellation_token.cancelled = true

	for _, unit_data in pairs(self._local_units) do
		World.destroy_unit(self._world, unit_data.unit)
	end
end

return AreaOfEffectUnitSpawnerExtension
