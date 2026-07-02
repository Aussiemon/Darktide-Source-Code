-- chunkname: @scripts/extension_systems/force_field/cryptic_personal_force_field_unit_extension.lua

local ForceFieldExtensionInterface = require("scripts/extension_systems/force_field/force_field_extension_interface")
local CrypticPersonalForceFieldUnitExtension = class("CrypticPersonalForceFieldUnitExtension")
local SPHERE_UNIT_RADIUS = 1
local SPAWNING = {
	particle_name = "content/fx/particles/abilities/cryptic/force_field_spawn",
	real_shield_visible_time = 0,
}
local DESPAWNING = {
	lingering_time_after_shield_expire = 0.1,
	particle_name = "content/fx/particles/abilities/cryptic/force_field_despawn",
	spawn_time_before_expired = 1,
}
local PULSING = {
	pulsing_animation_duration = 3,
	variable_names = {
		pulse = "pulse_on_off",
		pulse_intensity = "pulse_intensity",
		redness = "redness",
	},
}
local SHIELD_POWER_VARIABLE_NAME = "shield_power"
local WWISE_SHIELD_POWER_DURATION_VARIABLE_NAME = "ability_duration"

CrypticPersonalForceFieldUnitExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, unit_spawn_parameter_or_game_object_id)
	self._unit = unit

	local world = extension_init_context.world

	self._world = world
	self._wwise_world = extension_init_context.wwise_world
	self._physics_world = extension_init_context.physics_world

	local is_server = extension_init_context.is_server

	self._is_server = is_server

	local owner_unit = extension_init_data.owner_unit

	self.owner_unit = owner_unit

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local owner_player = player_unit_spawn_manager:owner(owner_unit)

	player_unit_spawn_manager:assign_unit_ownership(unit, owner_player)

	local target_node = Unit.node(owner_unit, "j_hips")
	local node_position = Unit.world_position(owner_unit, target_node)

	Unit.set_local_position(unit, 1, node_position)
	Unit.set_unit_visibility(self._unit, false)

	self._is_visible = false
	self._owner_unit_fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._game_session = game_object_data_or_game_session
	self._game_object_id = unit_spawn_parameter_or_game_object_id

	if is_server then
		local side_system = Managers.state.extension:system("side_system")

		self.side = side_system.side_by_unit[owner_unit]
		self.enemy_side_names = self.side:relation_side_names("enemy")
	end

	self._duration = extension_init_data.max_duration
	self._max_duration = self._duration
	self.is_expired = false
	self._active = true
	self._spawned_death_effects = false
end

CrypticPersonalForceFieldUnitExtension.destroy = function (self)
	local world = self._world
	local wwise_world = self._wwise_world
	local source_id = self._source_id
	local playing_id = self._playing_id
	local effect_id = self._effect_id

	if source_id then
		if playing_id and WwiseWorld.is_playing(wwise_world, playing_id) then
			WwiseWorld.stop_event(wwise_world, playing_id)
		end

		WwiseWorld.destroy_manual_source(wwise_world, source_id)

		self._source_id = nil
	end

	if effect_id and World.are_particles_playing(world, effect_id) then
		World.destroy_particles(world, effect_id)

		self._effect_id = nil
	end

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local unit = self._unit
	local owner = player_unit_spawn_manager:owner(unit)

	if owner then
		player_unit_spawn_manager:relinquish_unit_ownership(unit)
	end
end

CrypticPersonalForceFieldUnitExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "expired", false)
	GameSession.set_game_object_field(self._game_session, self._game_object_id, "remaining_duration", self._duration)
	GameSession.set_game_object_field(self._game_session, self._game_object_id, "max_duration", self._duration)
end

CrypticPersonalForceFieldUnitExtension.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._owner_first_person_extension = ScriptUnit.extension(self.owner_unit, "first_person_system")
end

CrypticPersonalForceFieldUnitExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local is_server = self._is_server

	if is_server then
		local duration = math.max(self._duration - dt, 0)

		self._duration = duration

		GameSession.set_game_object_field(game_session, game_object_id, "remaining_duration", duration)
	else
		self._duration = GameSession.game_object_field(game_session, game_object_id, "remaining_duration")
	end

	if not DEDICATED_SERVER then
		local is_expired = GameSession.game_object_field(game_session, game_object_id, "expired")

		if not self.is_expired and is_expired then
			self.is_expired = is_expired

			if not is_server then
				self:on_death(t)
			end
		elseif not self.is_expired then
			local spawn_animation_ended = self._max_duration - self._duration >= SPAWNING.real_shield_visible_time

			if not spawn_animation_ended and not self._effect_id then
				local target_node = Unit.node(self.owner_unit, "j_hips")
				local current_position = POSITION_LOOKUP[self._unit]
				local spawn_particle_effect = SPAWNING.particle_name

				self._effect_id = self._owner_unit_fx_extension:spawn_particles_local(spawn_particle_effect, current_position)

				World.link_particles(self._world, self._effect_id, self.owner_unit, target_node, Matrix4x4.identity(), "destroy")
			end

			local should_be_visible = spawn_animation_ended and not self._owner_first_person_extension:is_in_first_person_mode()

			if self._is_visible ~= should_be_visible then
				self._is_visible = should_be_visible

				Unit.set_unit_visibility(unit, should_be_visible)
			end
		end
	end

	if not self.is_expired and ALIVE[self.owner_unit] then
		local wwise_world = self._wwise_world
		local sfx_source_name = "hips"
		local sound_source_id = self._owner_unit_fx_extension:sound_source(sfx_source_name)
		local progress_remaining = 1 - math.clamp01(self._duration / self._max_duration)

		WwiseWorld.set_source_parameter(wwise_world, sound_source_id, WWISE_SHIELD_POWER_DURATION_VARIABLE_NAME, math.round(progress_remaining * 100))
		self._owner_unit_fx_extension:run_looping_sound("cryptic_force_shield_active", sfx_source_name, nil, fixed_frame)

		if self._duration <= DESPAWNING.spawn_time_before_expired and not self._spawned_death_effects then
			self:_trigger_death_effects()
		end
	end
end

CrypticPersonalForceFieldUnitExtension.update = function (self, unit, dt, t)
	if not self._active then
		return
	end

	local owner_unit = self.owner_unit
	local target_node = Unit.node(owner_unit, "j_hips")
	local node_position = Unit.world_position(owner_unit, target_node)

	Unit.set_local_position(unit, 1, node_position)

	if DEDICATED_SERVER then
		return
	end

	self:_update_effects(dt, t)
end

CrypticPersonalForceFieldUnitExtension._update_effects = function (self, dt, t)
	if self.is_expired then
		return
	end

	local time_left = self._duration
	local time_left_percentage = 1 - math.clamp01(time_left / self._max_duration)

	Unit.set_scalar_for_materials(self._unit, SHIELD_POWER_VARIABLE_NAME, time_left_percentage, true)

	local pulsing_animation_duration = PULSING.pulsing_animation_duration

	if time_left <= pulsing_animation_duration and not self._pulsing_started then
		self._pulsing_started = true

		Unit.set_scalar_for_materials(self._unit, PULSING.variable_names.pulse, 1, true)
	end

	if self._pulsing_started then
		local pulsing_time_left_percentage = 1 - math.clamp01(time_left / pulsing_animation_duration)

		Unit.set_scalar_for_materials(self._unit, PULSING.variable_names.redness, pulsing_time_left_percentage, true)
		Unit.set_scalar_for_materials(self._unit, PULSING.variable_names.pulse_intensity, pulsing_time_left_percentage, true)
	end
end

CrypticPersonalForceFieldUnitExtension.is_unit_colliding = function (self, unit_pos, unit_radius, handle_height)
	return
end

CrypticPersonalForceFieldUnitExtension.force_field_unit = function (self)
	return self._unit
end

CrypticPersonalForceFieldUnitExtension.remaining_duration = function (self)
	return self._duration
end

CrypticPersonalForceFieldUnitExtension.remaining_life = function (self)
	local max_duration = self._max_duration
	local duration = self._duration
	local health_percent = self._health_extension and self._health_extension:current_health_percent() or 1
	local duration_percent = duration / max_duration
	local remaining_life = duration_percent * health_percent

	return remaining_life
end

CrypticPersonalForceFieldUnitExtension.is_dead = function (self)
	return self._health_extension:is_dead()
end

CrypticPersonalForceFieldUnitExtension.is_sphere_shield = function (self)
	return true
end

CrypticPersonalForceFieldUnitExtension.reflected_direction = function (self, unit, direction)
	local shield_pos = POSITION_LOOKUP[unit]
	local unit_pos = POSITION_LOOKUP[self.owner_unit]
	local normal = Vector3.normalize(shield_pos - unit_pos)
	local reflected_direction = direction - 2 * normal * Vector3.dot(direction, normal)

	return direction
end

CrypticPersonalForceFieldUnitExtension.on_player_enter = function (self, unit, t)
	return
end

CrypticPersonalForceFieldUnitExtension.on_player_exit = function (self, unit, t)
	return
end

CrypticPersonalForceFieldUnitExtension.on_death = function (self, t)
	local unit = self._unit

	Unit.set_unit_visibility(unit, false, true)

	local actor = Unit.actor(unit, "g_sphere")

	if self._is_server then
		GameSession.set_game_object_field(self._game_session, self._game_object_id, "expired", true)
	end

	if not DEDICATED_SERVER then
		Unit.set_scalar_for_materials(self._unit, SHIELD_POWER_VARIABLE_NAME, 1, true)
		Unit.set_scalar_for_materials(self._unit, PULSING.variable_names.redness, 1, true)
		Unit.set_scalar_for_materials(self._unit, PULSING.variable_names.pulse_intensity, 1, true)
	end

	local destroy_after_time_override = DESPAWNING.lingering_time_after_shield_expire

	return destroy_after_time_override
end

CrypticPersonalForceFieldUnitExtension._trigger_death_effects = function (self)
	self._spawned_death_effects = true

	local world = self._world
	local effect_id = self._effect_id

	if effect_id and World.are_particles_playing(world, effect_id) then
		World.destroy_particles(world, effect_id)

		self._effect_id = nil
	end

	local owner_unit = self.owner_unit
	local current_position = POSITION_LOOKUP[self._unit]
	local despawn_particle_effect = DESPAWNING.particle_name

	if HEALTH_ALIVE[owner_unit] then
		self._effect_id = self._owner_unit_fx_extension:spawn_particles_local(despawn_particle_effect, current_position)

		local target_node = Unit.node(owner_unit, "j_hips")

		World.link_particles(world, self._effect_id, self.owner_unit, target_node, Matrix4x4.identity(), "destroy")
	else
		self._effect_id = World.create_particles(world, despawn_particle_effect, current_position)
	end
end

CrypticPersonalForceFieldUnitExtension.set_active = function (self)
	return
end

implements(CrypticPersonalForceFieldUnitExtension, ForceFieldExtensionInterface)

return CrypticPersonalForceFieldUnitExtension
