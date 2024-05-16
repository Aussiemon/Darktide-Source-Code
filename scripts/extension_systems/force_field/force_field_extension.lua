-- chunkname: @scripts/extension_systems/force_field/force_field_extension.lua

local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local ForceFieldExtension = class("ForceFieldExtension")
local special_rules = SpecialRulesSetting.special_rules
local talent_settings = TalentSettings.psyker_3.combat_ability
local SOUND_EVENTS_WALL = {
	start = "wwise/events/player/play_ability_psyker_protectorate_shield",
	stop = "wwise/events/player/stop_ability_psyker_protectorate_shield",
}
local SOUND_EVENTS_SPHERE = {
	start = "wwise/events/player/play_ability_psyker_shield_dome",
	stop = "wwise/events/player/stop_ability_psyker_shield_dome",
}
local PARTICLES_WALL = {
	start = "content/fx/particles/abilities/protectorate_forward_shield_init",
	stop = "content/fx/particles/abilities/protectorate_forward_shield_fade",
}
local PARTICLES_SPHERE = {
	start = "content/fx/particles/abilities/protectorate_sphere_shield_init",
	stop = "content/fx/particles/abilities/protectorate_sphere_shield_fade",
}
local DEFAULT_UNIT_RADIUS = 1
local SPHERE_UNIT_RADIUS = 6
local DEFAULT_HEIGHT = 3.5

ForceFieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, unit_spawn_parameter_or_game_object_id)
	self._unit = unit

	local world = extension_init_context.world
	local wwise_world = extension_init_context.wwise_world

	self._world = world
	self._wwise_world = wwise_world

	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self.owner_unit = extension_init_data.owner_unit

	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local owner_player = player_unit_spawn_manager:owner(self.owner_unit)

	if owner_player then
		player_unit_spawn_manager:assign_unit_ownership(unit, owner_player)
	end

	self._game_session = game_object_data_or_game_session
	self._game_object_id = unit_spawn_parameter_or_game_object_id

	local rotation = Unit.local_rotation(unit, 1)
	local position = Unit.local_position(unit, 1)

	self._rotation = QuaternionBox(rotation)
	self._position = Vector3Box(position)

	if is_server then
		local side_system = Managers.state.extension:system("side_system")

		self.side = side_system.side_by_unit[self.owner_unit]
		self.enemy_side_names = self.side:relation_side_names("enemy")
	end

	local width = 7
	local forward = Quaternion.forward(rotation)
	local rotation_left = Quaternion.from_euler_angles_xyz(0, 0, 90)
	local left = Quaternion.rotate(rotation_left, forward) * width / 2
	local p1 = Vector3Box(position + forward * 0.5)
	local p2 = Vector3Box(position + left * 0.3 + forward * 0.45)
	local p3 = Vector3Box(position + left * 0.6 + forward * 0.3)
	local p4 = Vector3Box(position + left * 0.9)
	local p5 = Vector3Box(position - left * 0.3 + forward * 0.45)
	local p6 = Vector3Box(position - left * 0.6 + forward * 0.3)
	local p7 = Vector3Box(position - left * 0.9)

	self._points = {
		p1,
		p2,
		p3,
		p4,
		p5,
		p6,
		p7,
	}

	local owner_unit = self.owner_unit

	self.buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self.talent_extension = ScriptUnit.extension(owner_unit, "talent_system")

	local sphere_shield = self.talent_extension:has_special_rule(special_rules.psyker_sphere_shield)

	self._sphere_shield = sphere_shield

	local duration = talent_settings.duration
	local sphere_duration = talent_settings.sphere_duration

	self._duration = self._sphere_shield and sphere_duration or duration
	self._max_duration = self._duration

	local start_sound_event = sphere_shield and SOUND_EVENTS_SPHERE.start or SOUND_EVENTS_WALL.start
	local source_id = WwiseWorld.make_manual_source(wwise_world, position + Vector3.up() * 1.5, rotation)

	self._playing_id, self._source_id = WwiseWorld.trigger_resource_event(wwise_world, start_sound_event, source_id)

	local start_particle_effect = sphere_shield and PARTICLES_SPHERE.start or PARTICLES_WALL.start

	self._effect_id = World.create_particles(world, start_particle_effect, position, rotation)
	self._players_inside = {}
	self.is_expired = false
	self.buff_affected_units = {}
	self._in_sheild_buff_template_name = nil
	self._leaving_shield_buff_template_name = nil
	self._end_shield_buff_template_name = nil

	if is_server then
		local talent_extension = ScriptUnit.has_extension(owner_unit, "talent_system")
		local has_special_rule = talent_extension and talent_extension:has_special_rule(special_rules.psyker_boost_allies_in_sphere)

		if has_special_rule and sphere_shield then
			self._in_sheild_buff_template_name = "psyker_boost_allies_in_sphere_buff"
			self._leaving_shield_buff_template_name = nil
			self._end_shield_buff_template_name = "psyker_boost_allies_in_sphere_end_buff"
		end
	end
end

ForceFieldExtension.destroy = function (self)
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

ForceFieldExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "expired", false)
end

ForceFieldExtension.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.extension(unit, "health_system")
end

ForceFieldExtension.fixed_update = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id

	if self._is_server then
		local duration = math.max(self._duration - dt, 0)

		self._duration = duration

		GameSession.set_game_object_field(game_session, game_object_id, "remaining_duration", duration)
	else
		self._duration = GameSession.game_object_field(game_session, game_object_id, "remaining_duration")

		local is_expired = GameSession.game_object_field(game_session, game_object_id, "expired")

		if not self.is_expired and is_expired then
			self.is_expired = is_expired

			self:on_death(t)
		end
	end
end

ForceFieldExtension.update = function (self, unit, dt, t)
	self:_update_effects(dt, t)
end

ForceFieldExtension._update_effects = function (self, dt, t)
	if self.is_expired then
		return
	end

	local variable = self:remaining_life()

	WwiseWorld.set_source_parameter(self._wwise_world, self._source_id, "player_ability_health", variable)

	local variable_name = self._sphere_shield and "psyker_sphere_shield_life" or "psyker_flat_shield_life"

	Unit.set_scalar_for_materials(self._unit, variable_name, variable, true)
end

ForceFieldExtension.is_unit_colliding = function (self, unit_pos, unit_radius, handle_height)
	if not unit_pos then
		return false
	end

	if not self._sphere_shield then
		if handle_height then
			local position = self._position:unbox()
			local height_diff = unit_pos.z - position.z

			if height_diff > 0 and height_diff < DEFAULT_HEIGHT then
				unit_pos.z = position.z
			end
		end

		unit_radius = unit_radius or DEFAULT_UNIT_RADIUS

		local distance_sq, last_distance_sq
		local radius_sq = unit_radius * unit_radius
		local points = self._points

		distance_sq = Vector3.distance_squared(unit_pos, points[4]:unbox())

		if distance_sq < radius_sq then
			return true
		end

		last_distance_sq = distance_sq
		distance_sq = Vector3.distance_squared(unit_pos, points[3]:unbox())

		if last_distance_sq < distance_sq then
			return false
		elseif distance_sq < radius_sq then
			return true
		end

		distance_sq = Vector3.distance_squared(unit_pos, points[7]:unbox())

		if distance_sq < radius_sq then
			return true
		end

		last_distance_sq = distance_sq
		distance_sq = Vector3.distance_squared(unit_pos, points[6]:unbox())

		if last_distance_sq < distance_sq then
			return false
		elseif distance_sq < radius_sq then
			return true
		end

		distance_sq = Vector3.distance_squared(unit_pos, points[5]:unbox())

		if distance_sq < radius_sq then
			return true
		end

		distance_sq = Vector3.distance_squared(unit_pos, points[2]:unbox())

		if distance_sq < radius_sq then
			return true
		end

		distance_sq = Vector3.distance_squared(unit_pos, points[1]:unbox())

		if distance_sq < radius_sq then
			return true
		end
	else
		local radius = SPHERE_UNIT_RADIUS
		local position = self._position:unbox()
		local distance_squared = Vector3.distance_squared(position, unit_pos)
		local compare_radius = radius + unit_radius
		local compare_radius_squared = compare_radius * compare_radius
		local is_within_sphere = distance_squared < compare_radius_squared

		return is_within_sphere
	end

	return false
end

ForceFieldExtension.force_field_unit = function (self)
	return self._unit
end

ForceFieldExtension.remaining_duration = function (self)
	return self._duration
end

ForceFieldExtension.remaining_life = function (self)
	local max_duration = self._max_duration
	local duration = self._duration
	local health_percent = self._health_extension and self._health_extension:current_health_percent() or 1
	local duration_percent = duration / max_duration
	local remaining_life = duration_percent * health_percent

	return remaining_life
end

ForceFieldExtension.is_dead = function (self)
	return self._health_extension:is_dead()
end

ForceFieldExtension.is_sphere_shield = function (self)
	return self._sphere_shield
end

ForceFieldExtension.reflected_direction = function (self, unit, direction)
	local normal

	if not self._sphere_shield then
		local rotation = self._rotation:unbox()
		local forward = Quaternion.forward(rotation)
		local dot = Vector3.dot(forward, direction)
		local is_behind = dot > 0

		if is_behind then
			normal = -forward
		else
			normal = forward
		end
	else
		local shield_pos = self._position:unbox()
		local unit_pos = POSITION_LOOKUP[unit]

		normal = Vector3.normalize(shield_pos - unit_pos)
	end

	local reflected_direction = direction - 2 * normal * Vector3.dot(direction, normal)

	return reflected_direction
end

ForceFieldExtension.on_player_enter = function (self, unit, t)
	if not self._is_server then
		return
	end

	local unit_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not unit_buff_extension then
		return
	end

	local buff_affected_units = self.buff_affected_units
	local in_sheild_buff_template_name = self._in_sheild_buff_template_name

	if in_sheild_buff_template_name then
		local _, local_index, component_index = unit_buff_extension:add_externally_controlled_buff(in_sheild_buff_template_name, t, "owner_unit", self._unit)

		buff_affected_units[unit] = {
			local_index = local_index,
			component_index = component_index,
		}
	end

	self._players_inside[unit] = true
end

ForceFieldExtension.on_player_exit = function (self, unit, t)
	if not self._is_server then
		return
	end

	local unit_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not unit_buff_extension then
		return
	end

	local buff_affected_units = self.buff_affected_units
	local buff_indices = buff_affected_units[unit]

	if buff_indices then
		local local_index = buff_indices.local_index
		local component_index = buff_indices.component_index

		unit_buff_extension:remove_externally_controlled_buff(local_index, component_index)

		buff_affected_units[unit] = nil
	end

	local leaving_shield_buff_template_name = self._leaving_shield_buff_template_name

	if leaving_shield_buff_template_name then
		unit_buff_extension:add_internally_controlled_buff(leaving_shield_buff_template_name, t, "owner_unit", self._unit)
	end

	self._players_inside[unit] = nil
end

ForceFieldExtension.on_death = function (self, t)
	self:_trigger_death_effects()

	local unit = self._unit

	Unit.set_unit_visibility(unit, false, true)
	Unit.destroy_actor(unit, Unit.actor(unit, self._sphere_shield and "g_shield" or "g_wall"))

	if self._is_server then
		self._health_extension:send_stat_data()
		GameSession.set_game_object_field(self._game_session, self._game_object_id, "expired", true)

		local end_buff_name = self._end_shield_buff_template_name

		if not end_buff_name then
			return
		end

		for player_unit, _ in pairs(self._players_inside) do
			local unit_buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

			if unit_buff_extension then
				unit_buff_extension:add_internally_controlled_buff(end_buff_name, t, "owner_unit", self.owner_unit)
			end
		end
	end
end

ForceFieldExtension._trigger_death_effects = function (self)
	local world = self._world
	local wwise_world = self._wwise_world
	local source_id = self._source_id
	local effect_id = self._effect_id
	local sphere_shield = self._sphere_shield
	local stop_sound_event = sphere_shield and SOUND_EVENTS_SPHERE.stop or SOUND_EVENTS_WALL.stop

	WwiseWorld.trigger_resource_event(wwise_world, stop_sound_event, source_id)
	WwiseWorld.destroy_manual_source(wwise_world, source_id)

	self._source_id = nil

	local stop_particle_effect = sphere_shield and PARTICLES_SPHERE.stop or PARTICLES_WALL.stop

	if effect_id and World.are_particles_playing(world, effect_id) then
		World.destroy_particles(world, effect_id)
	end

	self._effect_id = World.create_particles(world, stop_particle_effect, self._position:unbox(), self._rotation:unbox())
end

return ForceFieldExtension
