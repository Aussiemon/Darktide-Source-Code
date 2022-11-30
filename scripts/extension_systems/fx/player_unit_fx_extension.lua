local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local LineEffects = require("scripts/settings/effects/line_effects")
local PlayerCharacterLoopingParticleAliases = require("scripts/settings/particles/player_character_looping_particle_aliases")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerUnitFxExtension = class("PlayerUnitFxExtension")
local VFX_RING_BUFFER_SIZE = 128
local ALIGNED_VFX_RING_BUFFER_SIZE = 64
local MOVING_SFX_RING_BUFFER_SIZE = 64
local CLIENT_RPCS = {
	"rpc_play_looping_player_sound",
	"rpc_stop_looping_player_sound",
	"rpc_set_source_parameter",
	"rpc_play_player_sound",
	"rpc_play_player_sound_with_position",
	"rpc_play_exclusive_player_sound",
	"rpc_play_server_controlled_player_sound",
	"rpc_spawn_exclusive_particle",
	"rpc_spawn_looping_player_particles",
	"rpc_spawn_player_particles",
	"rpc_destroy_player_particles",
	"rpc_stop_player_particles",
	"rpc_spawn_player_particles_with_variable",
	"rpc_stop_looping_particles",
	"rpc_spawn_player_fx_line",
	"rpc_player_trigger_wwise_event_synced"
}
local _closest_point_on_line = nil

PlayerUnitFxExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local world = extension_init_context.world
	self._world = world
	self._wwise_world = extension_init_context.wwise_world
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	local is_local_unit = extension_init_data.is_local_unit
	self._player = extension_init_data.player
	self._is_local_unit = is_local_unit
	self._unit = unit
	self._breed = extension_init_data.breed
	self._player_particle_group_id = extension_init_data.player_particle_group_id
	self._dialogue_extension = nil

	if self._player.peer_id then
		self._peer_id = self._player:peer_id()
	end

	local aligned_vfx_buffer = Script.new_array(ALIGNED_VFX_RING_BUFFER_SIZE)

	for i = 1, ALIGNED_VFX_RING_BUFFER_SIZE do
		aligned_vfx_buffer[i] = {
			end_position = Vector3Box()
		}
	end

	self._aligned_vfx = {
		size = 0,
		buffer = aligned_vfx_buffer
	}
	local moving_sfx_buffer = Script.new_array(MOVING_SFX_RING_BUFFER_SIZE)

	for i = 1, MOVING_SFX_RING_BUFFER_SIZE do
		moving_sfx_buffer[i] = {
			position = Vector3Box(),
			direction = Vector3Box()
		}
	end

	self._moving_sfx = {
		size = 0,
		buffer = moving_sfx_buffer
	}
	self._looping_vfx = Script.new_array(VFX_RING_BUFFER_SIZE)
	self._next_vfx_index = 1
	self._num_vfx_ids = 0
	self._wwise_source_node_cache = {}
	self._sources = {}
	self._vfx_spawners = {}
	self._specials_targeting_me = {}
	self._player_particles = {}

	if not is_server then
		self._game_object_id = nil_or_game_object_id
		local network_event_delegate = extension_init_context.network_event_delegate

		network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end

	local base_unit_sound_sources = extension_init_data.breed.base_unit_sound_sources
	local temp = {
		unit
	}

	for source_name, node_name in pairs(base_unit_sound_sources) do
		self:register_sound_source(source_name, unit, temp, node_name)
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._scanning_component = unit_data_extension:read_component("scanning")

	if is_local_unit then
		self._character_interacting_state_component = unit_data_extension:read_component("interacting_character_state")
	end

	local num_looping_sounds = table.size(PlayerCharacterLoopingSoundAliases)
	local looping_sounds = Script.new_map(num_looping_sounds)
	local looping_sounds_components = nil

	if is_local_unit or is_server then
		looping_sounds_components = Script.new_map(num_looping_sounds)
		self._looping_sounds_components = looping_sounds_components
	end

	for alias_name, config in pairs(PlayerCharacterLoopingSoundAliases) do
		if not config.exclude_from_unit_data_components then
			looping_sounds[alias_name] = {
				is_playing = false,
				source_name = "n/a"
			}

			if is_local_unit or is_server then
				local component_name = PlayerUnitData.looping_sound_component_name(alias_name)
				local component = unit_data_extension:write_component(component_name)
				component.is_playing = false

				if not config.is_2d then
					component.source_name = "n/a"
				end

				looping_sounds_components[alias_name] = component
			end
		end
	end

	self._looping_sounds = looping_sounds
	local num_looping_particles = table.size(PlayerCharacterLoopingParticleAliases)
	local looping_particles = Script.new_map(num_looping_particles)
	self._looping_particles = looping_particles
	local looping_particles_components = nil

	if is_local_unit or is_server then
		looping_particles_components = Script.new_map(num_looping_particles)
		self._looping_particles_components = looping_particles_components
	end

	for alias_name, config in pairs(PlayerCharacterLoopingParticleAliases) do
		if not config.exclude_from_unit_data_components then
			looping_particles[alias_name] = {
				is_playing = false,
				spawner_name = "n/a",
				external_properties = {}
			}

			if is_local_unit or is_server then
				local component = unit_data_extension:write_component(alias_name)
				component.is_playing = false

				if not config.screen_space then
					component.spawner_name = "n/a"
				end

				local external_properties = config.external_properties

				if external_properties then
					for property_name, _ in pairs(external_properties) do
						component[property_name] = "n/a"
					end
				end

				looping_particles_components[alias_name] = component
			end
		end
	end
end

PlayerUnitFxExtension.game_object_initialized = function (self, session, id)
	self._game_object_id = id
end

PlayerUnitFxExtension.extensions_ready = function (self, world, unit)
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._looping_particles_variables_context = {
		health_extension = ScriptUnit.extension(unit, "health_system"),
		toughness_extension = ScriptUnit.extension(unit, "toughness_system"),
		action_module_charge_component = unit_data_extension:read_component("action_module_charge"),
		specialization_resource_component = unit_data_extension:read_component("specialization_resource")
	}
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()
	self._is_in_first_person_mode = is_in_first_person_mode
	self._first_person_extension = first_person_extension
	local base_unit_fx_sources = self._breed.base_unit_fx_sources or {}
	local first_person_unit = first_person_extension:first_person_unit()
	local should_add_3p_node = true
	local parent_unit = is_in_first_person_mode and first_person_unit or unit

	for spawner_name, node_name in pairs(base_unit_fx_sources) do
		self:register_vfx_spawner(spawner_name, parent_unit, nil, node_name, should_add_3p_node)
	end

	self._dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")

	self:_update_first_person_mode_all_sources(is_in_first_person_mode)
end

PlayerUnitFxExtension._create_particles_wrapper = function (self, world, particle_name, position, rotation, scale)
	return World.create_particles(world, particle_name, position, rotation, scale, self._player_particle_group_id)
end

PlayerUnitFxExtension.hot_join_sync = function (self, unit, peer, channel_id)
	local looping_sounds = self._looping_sounds
	local game_object_id = self._game_object_id
	local looping_sound_aliases_lookup = NetworkLookup.player_character_looping_sound_aliases
	local fx_sources_lookup = NetworkLookup.player_character_fx_sources

	for alias_name, data in pairs(looping_sounds) do
		if data.is_playing then
			local source_name_or_nil = data.source_name
			local sound_alias_id = looping_sound_aliases_lookup[alias_name]
			local source_id_or_nil = source_name_or_nil and fx_sources_lookup[source_name_or_nil]

			RPC.rpc_play_looping_player_sound(channel_id, game_object_id, sound_alias_id, source_id_or_nil)
		end
	end

	local looping_particles = self._looping_particles
	local particle_name_lookup = NetworkLookup.player_character_particles
	local looping_particle_alias_lookup = NetworkLookup.player_character_looping_particle_aliases

	for alias_name, data in pairs(looping_particles) do
		if data.is_playing then
			local spawner_name_or_nil = data.spawner_name
			local particle_name = data.particle_name
			local link = true

			RPC.rpc_spawn_looping_player_particles(channel_id, game_object_id, looping_particle_alias_lookup[alias_name], particle_name_lookup[particle_name], spawner_name_or_nil and fx_sources_lookup[spawner_name_or_nil], link)
		end
	end
end

PlayerUnitFxExtension.destroy = function (self, unit)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))
	end

	local looping_particles = self._looping_particles

	for looping_particles_alias, data in pairs(looping_particles) do
		if data.is_playing then
			local should_fade_kill = false

			self:_stop_looping_particles(looping_particles_alias, should_fade_kill)
			Log.info("PlayerUnitFxExtension", "STOPPING LOOPING PARTICLES IN DESTROY %q", looping_particles_alias)
		end
	end

	local looping_sounds = self._looping_sounds

	for looping_sounds_alias, data in pairs(looping_sounds) do
		if data.is_playing then
			local force_stop = true

			self:_stop_looping_wwise_event(looping_sounds_alias, force_stop)
			Log.info("PlayerUnitFxExtension", "STOPPING LOOPING SOUNDS IN DESTROY %q", looping_sounds_alias)
		end
	end

	for sound_source, _ in pairs(self._sources) do
		self:_unregister_sound_source(sound_source)
		Log.info("PlayerUnitFxExtension", "UNREGISTERING SOUND SOURCE IN DESTROY %q", sound_source)
	end

	for spawner, _ in pairs(self._vfx_spawners) do
		self:unregister_vfx_spawner(spawner)
		Log.info("PlayerUnitFxExtension", "UNREGISTERING VFX SPAWNER IN DESTROY %q", spawner)
	end

	local moving_sfx = self._moving_sfx

	for i = 1, MOVING_SFX_RING_BUFFER_SIZE do
		local data = moving_sfx[i]

		if data then
			local wwise_world = self._wwise_world
			local source_id = data.source_id
			local playing_id = data.playing_id

			WwiseWorld.stop_event(wwise_world, playing_id)
			WwiseWorld.destroy_manual_source(wwise_world, source_id)

			moving_sfx[i] = nil
		end
	end

	World.destroy_particle_group(self._world, self._player_particle_group_id)
end

PlayerUnitFxExtension.destroy_particle_group = function (self)
	World.destroy_particle_group(self._world, self._player_particle_group_id)
end

PlayerUnitFxExtension.update = function (self, unit, dt, t)
	local first_person_extension = self._first_person_extension
	local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

	if self._is_in_first_person_mode ~= is_in_first_person_mode then
		self._is_in_first_person_mode = is_in_first_person_mode

		self:_update_first_person_mode_all_sources(is_in_first_person_mode)
		self:_update_first_person_mode_looping_particles(is_in_first_person_mode)

		local base_unit_fx_sources = self._breed.base_unit_fx_sources or {}
		local first_person_unit = first_person_extension:first_person_unit()
		local parent_unit = is_in_first_person_mode and first_person_unit or unit

		for spawner_name, node_name in pairs(base_unit_fx_sources) do
			self:move_vfx_spawner(spawner_name, parent_unit, nil, node_name)
		end
	end

	self:_update_moving_sfx(dt, t)
	self:_update_looping_particle_variables(dt, t)
	self:_update_targeted_by_special()
end

PlayerUnitFxExtension.post_update = function (self, unit, dt, t)
	self:_update_aligned_vfx()
end

PlayerUnitFxExtension._update_first_person_mode_all_sources = function (self, first_person_mode)
	local wwise_world = self._wwise_world
	local sources = self._sources
	local WwiseWorld_set_source_parameter = WwiseWorld.set_source_parameter
	local parameter_value = first_person_mode and 1 or 0

	for source_name, source in pairs(sources) do
		WwiseWorld_set_source_parameter(wwise_world, source, "first_person_mode", parameter_value)
	end
end

PlayerUnitFxExtension._update_first_person_mode_looping_particles = function (self, first_person_mode)
	local world = self._world
	local looping_particles = self._looping_particles

	for alias, data in pairs(looping_particles) do
		if data.is_playing then
			local particle_config = PlayerCharacterLoopingParticleAliases[alias]

			if particle_config.screen_space then
				if first_person_mode then
					local particle_name = data.particle_name
					data.id = self:_create_particles_wrapper(world, particle_name, Vector3(0, 0, 1))
				else
					local id = data.id

					World.destroy_particles(world, id)

					data.id = nil
				end
			end
		end
	end
end

PlayerUnitFxExtension._update_first_person_mode = function (self, source_name, first_person_mode)
	local sound_source = self._sources[source_name]
	local wwise_world = self._wwise_world
	local parameter_value = first_person_mode and 1 or 0

	WwiseWorld.set_source_parameter(wwise_world, sound_source, "first_person_mode", parameter_value)
end

PlayerUnitFxExtension._update_targeted_by_special = function (self)
	local specials_targeting_me = self._specials_targeting_me
	local game_session = Managers.state.game_session:game_session()
	local self_unit = self._unit

	for special_unit, _ in pairs(specials_targeting_me) do
		if not HEALTH_ALIVE[special_unit] then
			self:set_targeted_by_special(special_unit, false)

			break
		end

		local game_object_id = Managers.state.unit_spawner:game_object_id(special_unit)
		local target_unit_id = GameSession.game_object_field(game_session, game_object_id, "target_unit_id")

		if target_unit_id ~= NetworkConstants.invalid_game_object_id then
			local target_unit = Managers.state.unit_spawner:unit(target_unit_id)

			if target_unit ~= self_unit then
				self:set_targeted_by_special(special_unit, false)

				break
			end
		end
	end
end

PlayerUnitFxExtension._update_aligned_vfx = function (self)
	local aligned_vfx = self._aligned_vfx
	local size = aligned_vfx.size

	if size <= 0 then
		return
	end

	local world = self._world
	local vfx_spawners = self._vfx_spawners
	local buffer = aligned_vfx.buffer
	local index = 1

	while size >= index do
		local data = buffer[index]
		local particle_id = data.particle_id
		local variable_index = data.variable_index
		local width = data.width
		local spawner_name = data.spawner_name
		local end_position = data.end_position:unbox()
		local vfx_spawner = vfx_spawners[spawner_name]

		if vfx_spawner and World.are_particles_playing(world, particle_id) then
			local unit = vfx_spawner.unit
			local node = vfx_spawner.node
			local spawner_pose = Unit.world_pose(unit, node)
			local spawner_position = Matrix4x4.translation(spawner_pose)
			local line = end_position - spawner_position
			local direction = Vector3.normalize(line)
			local rotation = Quaternion.look(direction)

			World.move_particles(world, particle_id, spawner_position, rotation)

			local line_length = Vector3.length(line)

			World.set_particles_variable(world, particle_id, variable_index, Vector3(width, line_length, line_length))

			index = index + 1
		else
			buffer[index].particle_id = buffer[size].particle_id
			buffer[index].variable_index = buffer[size].variable_index
			buffer[index].width = buffer[size].width
			buffer[index].spawner_name = buffer[size].spawner_name

			buffer[index].end_position:store(buffer[size].end_position:unbox())

			size = size - 1
		end
	end

	aligned_vfx.size = size
end

PlayerUnitFxExtension._update_moving_sfx = function (self, dt, t)
	local moving_sfx = self._moving_sfx
	local size = moving_sfx.size

	if size <= 0 then
		return
	end

	local wwise_world = self._wwise_world
	local buffer = moving_sfx.buffer
	local index = 1

	while size >= index do
		local data = buffer[index]
		local source_id = data.source_id
		local playing_id = data.playing_id
		local speed = data.speed
		local distance = data.distance
		local range = data.range
		local wwise_stop_event = data.wwise_stop_event
		local position = data.position:unbox()
		local direction = data.direction:unbox()
		local distance_this_frame = speed * dt
		local travelled_distance = distance + distance_this_frame
		local new_position = position + direction * distance_this_frame
		local remove = false

		if not source_id or range <= travelled_distance then
			remove = true
		elseif not WwiseWorld.has_source(wwise_world, source_id) then
			Log.warning("FxExtension", "Removing moving sound as the source_id has been deleted from some other place.")

			remove = true
		end

		if remove then
			if playing_id then
				WwiseWorld.stop_event(self._wwise_world, playing_id)

				data.playing_id = nil
			end

			if source_id then
				if wwise_stop_event then
					WwiseWorld.trigger_resource_event(wwise_world, wwise_stop_event, source_id)
				end

				WwiseWorld.destroy_manual_source(wwise_world, source_id)

				data.source_id = nil
			end

			buffer[index].playing_id = buffer[size].playing_id
			buffer[index].source_id = buffer[size].source_id
			buffer[index].speed = buffer[size].speed
			buffer[index].distance = buffer[size].distance
			buffer[index].range = buffer[size].range
			buffer[index].wwise_stop_event = buffer[size].wwise_stop_event

			buffer[index].position:store(buffer[size].position:unbox())
			buffer[index].direction:store(buffer[size].direction:unbox())

			size = size - 1
		else
			data.position:store(new_position)

			data.distance = travelled_distance

			WwiseWorld.set_source_position(wwise_world, source_id, new_position)

			index = index + 1
		end
	end

	moving_sfx.size = size
end

local World_set_particles_material_scalar = World.set_particles_material_scalar
local World_set_particles_variable = World.set_particles_variable

PlayerUnitFxExtension._update_looping_particle_variables = function (self, dt, t)
	local world = self._world
	local looping_particle_variables_context = self._looping_particles_variables_context

	for alias, data in pairs(self._looping_particles) do
		local particle_config = PlayerCharacterLoopingParticleAliases[alias]
		local variables = particle_config.variables
		local id = data.id

		if variables and id then
			local num_variables = #variables

			for i = 1, num_variables do
				local variable_config = variables[i]
				local variable_name = variable_config.variable_name
				local variable_type = variable_config.variable_type

				if variable_type == "material_scalar" then
					local scalar = variable_config.func(looping_particle_variables_context)
					local cloud_name = variable_config.cloud_name

					World_set_particles_material_scalar(world, id, cloud_name, variable_name, scalar)
				elseif variable_type == "particle_variable" then
					local x, y, z = variable_config.func(looping_particle_variables_context)
					local particle_name = data.particle_name
					local variable_id = World.find_particles_variable(world, particle_name, variable_name)

					World_set_particles_variable(world, id, variable_id, Vector3(x, y, z))
				elseif variable_type == "emit_rate_multiplier" then
					local multiplier, cloud = variable_config.func(looping_particle_variables_context)

					World.set_particles_emit_rate_multiplier(world, id, multiplier, cloud)
				end
			end
		end
	end
end

local server_correction_external_properties = {}

PlayerUnitFxExtension.server_correction_occurred = function (self, unit, from_frame, to_frame, simulated_components)
	local visual_loadout_extension = self._visual_loadout_extension
	local looping_sounds = self._looping_sounds
	local looping_sounds_components = self._looping_sounds_components

	for alias_name, data in pairs(looping_sounds) do
		local event_alias = data.event_alias
		local resolved = false
		local event_name = nil

		if event_alias then
			resolved, event_name = visual_loadout_extension:resolve_gear_sound(event_alias)
		end

		local sound_config = PlayerCharacterLoopingSoundAliases[alias_name]
		local is_2d = sound_config.is_2d
		local component = looping_sounds_components[alias_name]
		local should_be_playing = component.is_playing
		local locally_is_playing = data.is_playing
		local source_name_or_nil = nil
		local current_source_name = data.source_name

		if not is_2d then
			source_name_or_nil = component.source_name
		end

		local different_sources = source_name_or_nil ~= current_source_name

		if should_be_playing ~= locally_is_playing or different_sources or data.event_name ~= event_name then
			if locally_is_playing then
				self:_stop_looping_wwise_event(alias_name)
			end

			if should_be_playing then
				self:_trigger_looping_wwise_event(alias_name, source_name_or_nil)
			end
		end
	end

	local looping_particles = self._looping_particles
	local looping_particles_components = self._looping_particles_components

	for alias_name, data in pairs(looping_particles) do
		table.clear(server_correction_external_properties)

		local looping_particle_component = looping_particles_components[alias_name]
		local particle_config = PlayerCharacterLoopingParticleAliases[alias_name]
		local external_properties = particle_config.external_properties
		local different_external_properties = false

		if external_properties then
			local saved_external_properties = data.external_properties

			for property_name, _ in pairs(external_properties) do
				local property_value = looping_particle_component[property_name]
				local saved_property_value = saved_external_properties[property_name]
				property_value = property_value ~= "n/a" and property_value or nil
				different_external_properties = different_external_properties or property_value ~= saved_property_value
				server_correction_external_properties[property_name] = property_value
			end
		end

		local screen_space = particle_config.screen_space
		local should_be_playing = looping_particle_component.is_playing
		local locally_is_playing = data.is_playing
		local spawner_name_or_nil = nil
		local current_spawner_name = data.spawner_name

		if not screen_space then
			spawner_name_or_nil = looping_particle_component.spawner_name
		end

		local different_spawners = spawner_name_or_nil ~= current_spawner_name
		local should_correct = should_be_playing ~= locally_is_playing or different_spawners or different_external_properties

		if should_correct then
			if locally_is_playing then
				local should_fade_kill = false

				self:_stop_looping_particles(alias_name, should_fade_kill)
			end

			if should_be_playing then
				local position_offset, rotation_offset, scale, link = nil

				if spawner_name_or_nil ~= nil then
					link = true
				end

				self:_spawn_looping_particles(alias_name, spawner_name_or_nil, server_correction_external_properties, link, position_offset, rotation_offset, scale)
			end
		end
	end
end

local function _register_sound_source(wwise_source_node_cache, unit, node_name, wwise_world, source_name)
	if not wwise_source_node_cache[unit] then
		wwise_source_node_cache[unit] = {}
	end

	local unit_cache = wwise_source_node_cache[unit]

	if not unit_cache[node_name] then
		local node = node_name == "root" and 1 or Unit.node(unit, node_name)
		local source = WwiseWorld.make_manual_source(wwise_world, unit, node)
		unit_cache[node_name] = {
			num_registered_sources = 0,
			source = source
		}
	end

	local cache = unit_cache[node_name]
	cache.num_registered_sources = cache.num_registered_sources + 1
	local source_name_to_node_cache_lookup = {
		unit = unit,
		node_name = node_name
	}
	wwise_source_node_cache[source_name] = source_name_to_node_cache_lookup

	return cache.source
end

local function _register_sound_source_from_attachments(wwise_source_node_cache, parent_unit, attachments, node_name, wwise_world, source_name)
	local num_attachments = #attachments

	for i = 1, num_attachments do
		local unit = attachments[i]

		if Unit.has_node(unit, node_name) then
			local source = _register_sound_source(wwise_source_node_cache, unit, node_name, wwise_world, source_name)

			return source
		end
	end

	if Unit.has_node(parent_unit, node_name) then
		local source = _register_sound_source(wwise_source_node_cache, parent_unit, node_name, wwise_world, source_name)

		if source then
			return source
		end
	end

	local fallback_source = _register_sound_source(wwise_source_node_cache, parent_unit, "root", wwise_world, source_name)

	return fallback_source
end

PlayerUnitFxExtension.register_sound_source = function (self, source_name, parent_unit, attachments, node_name)
	local sources = self._sources

	self:_register_sound_source(sources, source_name, parent_unit, attachments, node_name)

	local first_person_extension = self._first_person_extension

	if first_person_extension then
		local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

		self:_update_first_person_mode(source_name, is_in_first_person_mode)
	end
end

PlayerUnitFxExtension._register_sound_source = function (self, sources, source_name, parent_unit, attachments, node_name)
	local wwise_source_node_cache = self._wwise_source_node_cache
	local wwise_world = self._wwise_world

	if attachments then
		local source = _register_sound_source_from_attachments(wwise_source_node_cache, parent_unit, attachments, node_name, wwise_world, source_name)
		sources[source_name] = source
	else
		local source = _register_sound_source(wwise_source_node_cache, parent_unit, "root", wwise_world, source_name)
		sources[source_name] = source
	end
end

local temp_playing_looping_sounds = {}

PlayerUnitFxExtension.move_sound_source = function (self, source_name, parent_unit, attachments, node_name)
	local sources = self._sources

	table.clear(temp_playing_looping_sounds)

	local looping_sounds = self._looping_sounds

	for sound_alias, data in pairs(looping_sounds) do
		if data.is_playing and data.source_name == source_name then
			temp_playing_looping_sounds[sound_alias] = true

			self:_stop_looping_wwise_event(sound_alias)
		end
	end

	self:_unregister_sound_source(source_name)
	self:_register_sound_source(sources, source_name, parent_unit, attachments, node_name)

	for sound_alias, _ in pairs(temp_playing_looping_sounds) do
		self:_trigger_looping_wwise_event(sound_alias, source_name)
	end
end

PlayerUnitFxExtension.sound_source = function (self, source_name)
	local sound_source = self._sources[source_name]

	return sound_source
end

PlayerUnitFxExtension.vfx_spawner = function (self, spawner_name)
	local vfx_spawner = self._vfx_spawners[spawner_name]

	return vfx_spawner
end

PlayerUnitFxExtension.vfx_spawner_unit_and_node = function (self, spawner_name)
	local vfx_spawner = self._vfx_spawners[spawner_name]
	local unit_3p = vfx_spawner.node_3p and self._unit or vfx_spawner.unit
	local node_3p = vfx_spawner.node_3p or vfx_spawner.node

	return vfx_spawner.unit, vfx_spawner.node, unit_3p, node_3p
end

PlayerUnitFxExtension.sfx_spawner_unit_and_node = function (self, spawner_name)
	local source_cache = self._wwise_source_node_cache[spawner_name]

	return source_cache.unit, source_cache.node
end

PlayerUnitFxExtension.vfx_spawner_pose = function (self, spawner_name)
	local vfx_spawner = self._vfx_spawners[spawner_name]
	local unit = vfx_spawner.unit
	local node = vfx_spawner.node

	return Unit.world_pose(unit, node)
end

PlayerUnitFxExtension.unregister_sound_source = function (self, source_name)
	local sources = self._sources
	local source = sources[source_name]

	self:_unregister_sound_source(source_name)

	sources[source_name] = nil
end

PlayerUnitFxExtension._unregister_sound_source = function (self, source_name)
	local wwise_source_node_cache = self._wwise_source_node_cache
	local wwise_world = self._wwise_world
	local source_name_to_node_cache_lookup = wwise_source_node_cache[source_name]
	local looping_sounds = self._looping_sounds

	for looping_sound_alias, data in pairs(looping_sounds) do
		if data.is_playing and data.source_name == source_name then
			Log.warning("PlayerUnitFxExtension", "Stopping looping sound %q due to unregistering of sound_source %q. Should clean this up properly before unregistering.", looping_sound_alias, source_name)

			local force_stop = true

			self:_stop_looping_wwise_event(looping_sound_alias, force_stop)
		end
	end

	local unit = source_name_to_node_cache_lookup.unit
	local node_name = source_name_to_node_cache_lookup.node_name
	wwise_source_node_cache[source_name] = nil
	local unit_cache = wwise_source_node_cache[unit]
	local cache = unit_cache[node_name]
	local num_registered_sources = cache.num_registered_sources - 1

	if num_registered_sources == 0 then
		local source = cache.source

		WwiseWorld.destroy_manual_source(wwise_world, source)

		unit_cache[node_name] = nil

		if table.is_empty(unit_cache) then
			wwise_source_node_cache[unit] = nil
		end
	else
		cache.num_registered_sources = num_registered_sources
	end
end

local CHARACTER_STATE_TO_WWISE_STATE = {
	consumed = "consumed",
	warp_grabbed = "warp_grabbed",
	knocked_down = "knocked_down",
	ledge_hanging = "hanging",
	catapulted = "catapulted",
	dead = "dead",
	netted = "netted",
	minigame = "auspex_scanner",
	mutant_charged = "mutant_charged",
	pounced = "pounced"
}
local CHARACTER_STATUS_TO_WWISE_STATE = {
	last_wound = "last_wound"
}
local DEFAULT_WWISE_PLAYER_STATE = "none"

PlayerUnitFxExtension.wwise_player_state = function (self)
	local character_state_component = self._character_state_component
	local character_state_name = character_state_component.state_name
	local wwise_player_state = CHARACTER_STATE_TO_WWISE_STATE[character_state_name]

	if self._is_local_unit and character_state_name == "interacting" then
		local character_interacting_state_component = self._character_interacting_state_component
		local interaction_template_name = character_interacting_state_component.interaction_template
		local interaction_template = InteractionTemplates[interaction_template_name]
		wwise_player_state = interaction_template.wwise_player_state or wwise_player_state
	end

	local scanning_component = self._scanning_component

	if self._is_local_unit and scanning_component.is_active then
		wwise_player_state = "auspex_scanner"
	end

	local num_wounds = self._health_extension:num_wounds()
	local last_wound = num_wounds == 1

	if not wwise_player_state and last_wound then
		wwise_player_state = CHARACTER_STATUS_TO_WWISE_STATE.last_wound
	end

	return wwise_player_state or DEFAULT_WWISE_PLAYER_STATE
end

PlayerUnitFxExtension.trigger_wwise_event = function (self, event_name, append_husk_to_event_name, ...)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local wwise_event_name = nil

	if append_husk_to_event_name and self:should_play_husk_effect() then
		wwise_event_name = event_name .. "_husk"
	else
		wwise_event_name = event_name
	end

	return WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, ...)
end

PlayerUnitFxExtension.trigger_wwise_events_local_and_husk = function (self, local_event_name, husk_event_name, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)
	if self._unit_data_extension.is_resimulating then
		return
	end

	optional_occlusion = not not optional_occlusion
	local optional_unit_id = nil
	local is_level_unit = false

	if optional_unit then
		is_level_unit, optional_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(optional_unit)
	end

	local optional_parameter_name_id = optional_parameter_name and NetworkLookup.sound_parameters[optional_parameter_name]
	local optional_switch_name_id = optional_switch_name and NetworkLookup.sound_switches[optional_switch_name]
	local optional_switch_value_id = optional_switch_value and NetworkLookup.sound_switch_values[optional_switch_value]
	local append_husk_to_event_name = false

	if self._is_local_unit then
		self:_trigger_wwise_event_synced(local_event_name, append_husk_to_event_name, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)
	else
		Managers.state.game_session:send_rpc_client("rpc_player_trigger_wwise_event_synced", self._player:peer_id(), self._game_object_id, NetworkLookup.player_character_sounds[local_event_name], append_husk_to_event_name, optional_occlusion, optional_unit_id, is_level_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name_id, optional_parameter_value, optional_switch_name_id, optional_switch_value_id)
	end

	Managers.state.game_session:send_rpc_clients_except("rpc_player_trigger_wwise_event_synced", self._player:channel_id(), self._game_object_id, NetworkLookup.player_character_sounds[husk_event_name], append_husk_to_event_name, optional_occlusion, optional_unit_id, is_level_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name_id, optional_parameter_value, optional_switch_name_id, optional_switch_value_id)
end

PlayerUnitFxExtension.trigger_wwise_event_synced = function (self, event_name, append_husk_to_event_name, is_predicted, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)
	if self._unit_data_extension.is_resimulating then
		return
	end

	optional_occlusion = not not optional_occlusion

	self:_trigger_wwise_event_synced(event_name, append_husk_to_event_name, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)

	if self._is_server then
		local optional_unit_id = nil
		local is_level_unit = false

		if optional_unit then
			is_level_unit, optional_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(optional_unit)
		end

		local optional_parameter_name_id = optional_parameter_name and NetworkLookup.sound_parameters[optional_parameter_name]
		local optional_switch_name_id = optional_switch_name and NetworkLookup.sound_switches[optional_switch_name]
		local optional_switch_value_id = optional_switch_value and NetworkLookup.sound_switch_values[optional_switch_value]

		if is_predicted and not self._is_local_unit then
			Managers.state.game_session:send_rpc_clients_except("rpc_player_trigger_wwise_event_synced", self._player:channel_id(), self._game_object_id, NetworkLookup.player_character_sounds[event_name], append_husk_to_event_name, optional_occlusion, optional_unit_id, is_level_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name_id, optional_parameter_value, optional_switch_name_id, optional_switch_value_id)
		else
			Managers.state.game_session:send_rpc_clients("rpc_player_trigger_wwise_event_synced", self._game_object_id, NetworkLookup.player_character_sounds[event_name], append_husk_to_event_name, optional_occlusion, optional_unit_id, is_level_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name_id, optional_parameter_value, optional_switch_name_id, optional_switch_value_id)
		end
	end
end

PlayerUnitFxExtension._trigger_wwise_event_synced = function (self, event_name, append_husk_to_event_name, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)
	local wwise_world = self._wwise_world
	local source_id = nil

	if optional_unit then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_unit, optional_node_index)
	elseif optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position, optional_rotation)
	end

	if optional_parameter_name then
		WwiseWorld.set_source_parameter(wwise_world, source_id, optional_parameter_name, optional_parameter_value)
	end

	if optional_switch_name then
		WwiseWorld.set_switch(wwise_world, optional_switch_name, optional_switch_value, source_id)
	end

	if optional_occlusion then
		self:trigger_wwise_event(event_name, append_husk_to_event_name, optional_occlusion, source_id)
	else
		self:trigger_wwise_event(event_name, append_husk_to_event_name, source_id)
	end
end

PlayerUnitFxExtension.trigger_wwise_event_server_controlled = function (self, event_name, append_husk_to_event_name, optional_position, optional_parameter_name, optional_parameter_value)
	Managers.state.game_session:send_rpc_clients("rpc_play_server_controlled_player_sound", self._game_object_id, NetworkLookup.player_character_sounds[event_name], append_husk_to_event_name, optional_position, optional_parameter_name and NetworkLookup.sound_parameters[optional_parameter_name] or nil, optional_parameter_value)

	return self:_trigger_wwise_event_server_controlled(event_name, append_husk_to_event_name, optional_position, optional_parameter_name, optional_parameter_value)
end

PlayerUnitFxExtension._trigger_wwise_event_server_controlled = function (self, event_name, append_husk_to_event_name, optional_position, optional_parameter_name, optional_parameter_value)
	local wwise_world = self._wwise_world
	local source_id = nil

	if optional_position then
		source_id = WwiseWorld.make_auto_source(wwise_world, optional_position)
	end

	if optional_parameter_name and source_id and optional_position then
		WwiseWorld.set_source_parameter(wwise_world, source_id, optional_parameter_name, optional_parameter_value)
	end

	return self:trigger_wwise_event(event_name, append_husk_to_event_name, source_id)
end

PlayerUnitFxExtension.spawn_unit_fx_line = function (self, line_effect, is_critical_strike, source_name, end_position, link, orphaned_policy, scale, append_husk_to_event_name)
	self:_spawn_unit_fx_line(line_effect, is_critical_strike, source_name, end_position, link, orphaned_policy, scale, append_husk_to_event_name)

	if self._is_server then
		local channel_id = self._player:channel_id()
		local game_object_id = self._game_object_id

		Managers.state.game_session:send_rpc_clients_except("rpc_spawn_player_fx_line", channel_id, game_object_id, NetworkLookup.line_effects[line_effect.name], is_critical_strike, NetworkLookup.player_character_fx_sources[source_name], end_position, link, scale or Vector3(1, 1, 1), not not append_husk_to_event_name)
	end
end

local MAX_EMITTERS = 100

PlayerUnitFxExtension._spawn_unit_fx_line = function (self, line_effect, is_critical_strike, spawner_name, end_position, link, orphaned_policy, scale, append_husk_to_event_name)
	if DEDICATED_SERVER then
		return
	end

	local spawner = self._vfx_spawners[spawner_name]
	local spawner_unit = spawner.unit
	local spawner_node = spawner.node
	local spawner_pose = Unit.world_pose(spawner_unit, spawner_node)
	local spawner_position = Matrix4x4.translation(spawner_pose)
	local effect_name = line_effect.vfx
	local critical_effect_name = line_effect.vfx_crit
	local width = line_effect.vfx_width
	local wwise_event = line_effect.sfx
	local moving_wwise_config = line_effect.moving_sfx
	local keep_aligned = line_effect.keep_aligned
	local emitters = line_effect.emitters
	local critical_emitters = line_effect.emitters_crit
	local line = end_position - spawner_position
	local line_length = Vector3.length(line)
	local line_direction = Vector3.normalize(line)
	local line_rotation = Quaternion.look(line_direction)
	local effect_to_use = is_critical_strike and critical_effect_name or effect_name

	if effect_to_use then
		local line_pose = Matrix4x4.from_quaternion_position(line_rotation, spawner_position)
		local delta_pose = Matrix4x4.multiply(line_pose, Matrix4x4.inverse(spawner_pose))
		local position_offset = link and Matrix4x4.translation(delta_pose)
		local rotation_offset = Matrix4x4.rotation(delta_pose)
		local particle_id = self:_spawn_unit_particles(effect_to_use, spawner_name, link, orphaned_policy, position_offset, rotation_offset, scale)
		local variable_index = World.find_particles_variable(self._world, effect_to_use, "hit_distance")

		World.set_particles_variable(self._world, particle_id, variable_index, Vector3(width, line_length, line_length))

		if keep_aligned then
			local aligned_vfx = self._aligned_vfx
			local buffer = aligned_vfx.buffer
			local size = aligned_vfx.size
			local data = nil

			if ALIGNED_VFX_RING_BUFFER_SIZE < size + 1 then
				data = buffer[1]
				aligned_vfx.size = size
				local world = self._world
				local old_particle_id = data.particle_id

				if old_particle_id and World.are_particles_playing(world, old_particle_id) then
					World.stop_spawning_particles(world, old_particle_id)

					data.particle_id = nil
				end
			else
				data = buffer[size + 1]
				aligned_vfx.size = size + 1
			end

			data.particle_id = particle_id
			data.variable_index = variable_index
			data.width = width
			data.spawner_name = spawner_name

			data.end_position:store(end_position)
		end
	end

	if emitters then
		local emitter_effect_name = emitters.vfx.default
		local start_emitter_effect_name = emitters.vfx.start or emitter_effect_name
		local interval = emitters.interval
		local distance = interval.distance
		local increase = interval.increase
		local emitter_distance = 0
		local num_emitters = 0
		local spawn_emitters = true

		while spawn_emitters do
			local new_emitter_distance = emitter_distance + distance * math.pow(1 + increase, num_emitters)

			if line_length < new_emitter_distance + 1 or MAX_EMITTERS <= num_emitters then
				spawn_emitters = false
			else
				local spawn_pos = spawner_position + line_direction * new_emitter_distance
				local chosen_effect_name = num_emitters == 0 and start_emitter_effect_name or emitter_effect_name

				self:_create_particles_wrapper(self._world, chosen_effect_name, spawn_pos, line_rotation)

				emitter_distance = new_emitter_distance
				num_emitters = num_emitters + 1
			end
		end
	end

	if critical_emitters and is_critical_strike then
		local emitter_effect_name = critical_emitters.vfx.default
		local start_emitter_effect_name = critical_emitters.vfx.start or emitter_effect_name
		local interval = critical_emitters.interval
		local distance = interval.distance
		local increase = interval.increase
		local emitter_distance = 0
		local num_critical_emitters = 0
		local spawn_critical_emitters = true

		while spawn_critical_emitters do
			local new_emitter_distance = emitter_distance + distance * math.pow(1 + increase, num_critical_emitters)

			if line_length < new_emitter_distance + 1 or MAX_EMITTERS <= num_critical_emitters then
				spawn_critical_emitters = false
			else
				local line_rotation = Quaternion.look(line_direction)
				local spawn_pos = spawner_position + line_direction * new_emitter_distance
				local chosen_effect_name = num_critical_emitters == 0 and start_emitter_effect_name or emitter_effect_name

				self:_create_particles_wrapper(self._world, chosen_effect_name, spawn_pos, line_rotation)

				emitter_distance = new_emitter_distance
				num_critical_emitters = num_critical_emitters + 1
			end
		end
	end

	if wwise_event then
		self:_trigger_wwise_event_on_line(wwise_event, spawner_position, end_position, append_husk_to_event_name)
	end

	if moving_wwise_config then
		local moving_sfx = self._moving_sfx
		local buffer = moving_sfx.buffer
		local size = moving_sfx.size
		local data = nil

		if MOVING_SFX_RING_BUFFER_SIZE < size + 1 then
			data = buffer[1]
			moving_sfx.size = size
			local wwise_world = self._wwise_world
			local old_source_id = data.source_id
			local old_playing_id = data.playing_id

			WwiseWorld.stop_event(self._wwise_world, old_playing_id)

			data.playing_id = nil

			if old_source_id then
				WwiseWorld.destroy_manual_source(wwise_world, old_source_id)

				data.source_id = nil
			end
		else
			data = buffer[size + 1]
			moving_sfx.size = size + 1
		end

		local sound_alias = moving_wwise_config.event_alias
		local early_stop_sound_alias = moving_wwise_config.early_stop_event_alias
		local distance_offset = moving_wwise_config.distance_offset
		local duration = moving_wwise_config.duration
		local total_distance = distance_offset * 2
		local speed = total_distance / duration
		local resolved, start_event_name, start_has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias)
		local sound_position = nil
		local unit = self._unit
		local player = Managers.player:local_player(1)

		if player then
			local camera_position = Managers.state.camera:camera_position(player.viewport_name)
			sound_position = _closest_point_on_line(camera_position, spawner_position, end_position)
		else
			sound_position = POSITION_LOOKUP[unit]
		end

		local distance_to_source = Vector3.distance(spawner_position, sound_position)

		if distance_to_source < distance_offset then
			sound_position = spawner_position + line_direction * distance_offset
		end

		sound_position = sound_position - line_direction * distance_offset
		local distance_to_end = Vector3.distance(end_position, sound_position)
		local exceeds_total_distance = distance_to_end < total_distance

		if exceeds_total_distance then
			total_distance = distance_to_end
		end

		local manual_source_id, playing_id, _ = nil

		if resolved then
			if start_has_husk_events and self:should_play_husk_effect() then
				start_event_name = start_event_name .. "_husk"
			end

			local rotation = Quaternion.look(end_position - spawner_position)
			manual_source_id = WwiseWorld.make_manual_source(self._wwise_world, sound_position, rotation)
			playing_id, _ = WwiseWorld.trigger_resource_event(self._wwise_world, start_event_name, manual_source_id)
		end

		local wwise_stop_event = nil

		if exceeds_total_distance and early_stop_sound_alias then
			local stop_resolved, stop_event_name, stop_has_husk_events = self._visual_loadout_extension:resolve_gear_sound(early_stop_sound_alias)

			if stop_resolved then
				if stop_has_husk_events and self:should_play_husk_effect() then
					stop_event_name = stop_event_name .. "_husk"
				end

				wwise_stop_event = stop_event_name
			end
		end

		data.source_id = manual_source_id
		data.playing_id = playing_id
		data.speed = speed
		data.distance = 0
		data.range = total_distance
		data.wwise_stop_event = wwise_stop_event

		data.position:store(sound_position)
		data.direction:store(line_direction)
	end
end

PlayerUnitFxExtension._trigger_wwise_event_on_line = function (self, event_name, start_position, end_position, append_husk_to_event_name)
	local sound_position = nil
	local player = Managers.player:local_player(1)

	if player then
		local camera_position = Managers.state.camera:camera_position(player.viewport_name)
		sound_position = _closest_point_on_line(camera_position, start_position, end_position)
	else
		sound_position = POSITION_LOOKUP[self._unit]
	end

	local rotation = Quaternion.look(end_position - start_position)

	return self:trigger_wwise_event(event_name, append_husk_to_event_name, sound_position, rotation)
end

PlayerUnitFxExtension.should_play_husk_effect = function (self)
	return (not self._is_local_unit or not self._player:is_human_controlled()) and not self._is_in_first_person_mode
end

PlayerUnitFxExtension.set_targeted_by_special = function (self, special_unit, targeted)
	local specials_targeting_me = self._specials_targeting_me

	if targeted and not specials_targeting_me[special_unit] then
		specials_targeting_me[special_unit] = true

		WwiseWorld.set_global_parameter(self._wwise_world, "targeted_by_special_global", 1)
	elseif not targeted and specials_targeting_me[special_unit] then
		specials_targeting_me[special_unit] = nil

		WwiseWorld.set_global_parameter(self._wwise_world, "targeted_by_special_global", 0)
	end
end

PlayerUnitFxExtension.spawn_gear_particle_effect_with_source = function (self, particle_alias, external_properties, source_name, link, orphaned_policy, position_offset, rotation_offset, scale)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local vfx_spawner = self._vfx_spawners[source_name]
	local resolved, particle_name = self._visual_loadout_extension:resolve_gear_particle(particle_alias, external_properties)

	if not resolved then
		return
	end

	return self:spawn_unit_particles(particle_name, source_name, link, orphaned_policy, position_offset, rotation_offset, scale)
end

PlayerUnitFxExtension.trigger_gear_wwise_event = function (self, sound_alias, external_properties, ...)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, external_properties)

	if resolved then
		return self:trigger_wwise_event(event_name, has_husk_events, ...)
	end
end

PlayerUnitFxExtension.trigger_gear_wwise_event_with_source = function (self, sound_alias, external_properties, source_name, sync_to_clients, include_client)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, external_properties)

	if resolved then
		local source = self._sources[source_name]

		if sync_to_clients and self._is_server then
			local channel_id = self._player:channel_id()
			local game_object_id = self._game_object_id
			local event_id = NetworkLookup.player_character_sounds[event_name]
			local source_id = NetworkLookup.player_character_fx_sources[source_name]

			if include_client then
				Managers.state.game_session:send_rpc_clients("rpc_play_player_sound", game_object_id, event_id, source_id, not not has_husk_events)
			else
				Managers.state.game_session:send_rpc_clients_except("rpc_play_player_sound", channel_id, game_object_id, event_id, source_id, not not has_husk_events)
			end
		end

		return self:trigger_wwise_event(event_name, has_husk_events, source)
	end
end

PlayerUnitFxExtension.trigger_gear_wwise_event_with_position = function (self, sound_alias, external_properties, sound_position, sync_to_clients, include_client)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, external_properties)

	if resolved then
		if sync_to_clients and self._is_server then
			local channel_id = self._player:channel_id()
			local game_object_id = self._game_object_id
			local event_id = NetworkLookup.player_character_sounds[event_name]

			if include_client then
				Managers.state.game_session:send_rpc_clients("rpc_play_player_sound_with_position", game_object_id, event_id, sound_position, not not has_husk_events)
			else
				Managers.state.game_session:send_rpc_clients_except("rpc_play_player_sound_with_position", channel_id, game_object_id, event_id, sound_position, not not has_husk_events)
			end
		end

		return self:trigger_wwise_event(event_name, has_husk_events, sound_position)
	end
end

PlayerUnitFxExtension.trigger_voice_wwise_event_with_source = function (self, event_name, source_name, append_husk_to_event_name, include_client)
	self._dialogue_extension:set_voice_data()

	return self:trigger_wwise_event_with_source(event_name, source_name, append_husk_to_event_name, include_client)
end

PlayerUnitFxExtension.trigger_wwise_event_with_source = function (self, event_name, source_name, append_husk_to_event_name, include_client)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local source = self._sources[source_name]
	local wwise_event_name = self:_resolve_wwise_event(event_name, append_husk_to_event_name)
	local id = WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, source)

	if self._is_server then
		local channel_id = self._player:channel_id()
		local game_object_id = self._game_object_id
		local sound_id = NetworkLookup.player_character_sounds[event_name]
		local source_id = NetworkLookup.player_character_fx_sources[source_name]

		if include_client then
			Managers.state.game_session:send_rpc_clients("rpc_play_player_sound", game_object_id, sound_id, source_id, not not append_husk_to_event_name)
		else
			Managers.state.game_session:send_rpc_clients_except("rpc_play_player_sound", channel_id, game_object_id, sound_id, source_id, not not append_husk_to_event_name)
		end
	end

	return id
end

PlayerUnitFxExtension.trigger_wwise_event_non_synced = function (self, dialogue_extension, event_name, source_name, append_husk_to_event_name)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local source = self._sources[source_name]
	local wwise_event_name = self:_resolve_wwise_event(event_name, append_husk_to_event_name)
	local id = dialogue_extension:trigger_voice(wwise_event_name, source)

	return id
end

PlayerUnitFxExtension._resolve_wwise_event = function (self, event_name, append_husk_to_event_name)
	local wwise_event_name = nil

	if append_husk_to_event_name and self:should_play_husk_effect() then
		wwise_event_name = event_name .. "_husk"
	else
		wwise_event_name = event_name
	end

	return wwise_event_name
end

PlayerUnitFxExtension.set_source_parameter = function (self, parameter_name, parameter_value, source_name)
	local source = self._sources[source_name]

	WwiseWorld.set_source_parameter(self._wwise_world, source, parameter_name, parameter_value)

	if self._is_server then
		local channel_id = self._player:channel_id()
		local game_object_id = self._game_object_id
		local source_id = NetworkLookup.player_character_fx_sources[source_name]
		local parameter_id = NetworkLookup.sound_parameters[parameter_name]

		Managers.state.game_session:send_rpc_clients_except("rpc_set_source_parameter", channel_id, game_object_id, source_id, parameter_id, parameter_value)
	end
end

PlayerUnitFxExtension.trigger_exclusive_wwise_event = function (self, event_name, optional_position, optional_except_sender, optional_parameter_name, optional_parameter_value)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local is_camera_follow_target = self._first_person_extension:is_camera_follow_target()

	if is_camera_follow_target then
		local _, source_id = nil

		if optional_position then
			_, source_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, optional_position)
		else
			_, source_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name)
		end

		if optional_parameter_name and optional_parameter_value then
			WwiseWorld.set_source_parameter(self._wwise_world, source_id, optional_parameter_name, optional_parameter_value)
		end
	end

	local is_server = self._is_server

	if is_server then
		local game_object_id = self._game_object_id
		local sound_id = NetworkLookup.player_character_sounds[event_name]
		local parameter_id = optional_parameter_name and NetworkLookup.sound_parameters[optional_parameter_name]

		if optional_except_sender then
			local channel_id = self._player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_play_exclusive_player_sound", channel_id, game_object_id, sound_id, optional_position, parameter_id, optional_parameter_value)
		else
			Managers.state.game_session:send_rpc_clients("rpc_play_exclusive_player_sound", game_object_id, sound_id, optional_position, parameter_id, optional_parameter_value)
		end
	end
end

PlayerUnitFxExtension.trigger_exclusive_gear_wwise_event = function (self, sound_alias, external_properties, optional_position, optional_except_sender, optional_parameter_name, optional_parameter_value)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	local resolved, event_name, _ = self._visual_loadout_extension:resolve_gear_sound(sound_alias, external_properties)

	if not resolved then
		return
	end

	self:trigger_exclusive_wwise_event(event_name, optional_position, optional_except_sender, optional_parameter_name, optional_parameter_value)
end

PlayerUnitFxExtension.spawn_exclusive_particle = function (self, particle_name, position, rotation, scale)
	local is_resim = self._unit_data_extension.is_resimulating

	if is_resim then
		return
	end

	position = position or Vector3.zero()
	rotation = rotation or Quaternion.identity()
	scale = scale or Vector3(1, 1, 1)
	local is_camera_follow_target = self._first_person_extension:is_camera_follow_target()

	if is_camera_follow_target then
		self:_create_particles_wrapper(self._world, particle_name, position, rotation, scale)
	end

	local is_server = self._is_server

	if is_server then
		local game_object_id = self._game_object_id
		local particle_id = NetworkLookup.player_character_particles[particle_name]

		Managers.state.game_session:send_rpc_clients("rpc_spawn_exclusive_particle", game_object_id, particle_id, position, rotation, scale)
	end
end

PlayerUnitFxExtension.trigger_looping_wwise_event = function (self, sound_alias, optional_source_name)
	local is_server = self._is_server
	local is_local = self._is_local_unit
	local config = PlayerCharacterLoopingSoundAliases[sound_alias]
	local trigger_event = true

	if config.is_exclusive then
		trigger_event = self._first_person_extension:is_camera_follow_target()
	end

	if trigger_event then
		self:_trigger_looping_wwise_event(sound_alias, optional_source_name)
	end

	local component = self._looping_sounds_components[sound_alias]
	component.is_playing = true

	if not config.is_2d then
		component.source_name = optional_source_name
	end

	if is_server then
		local channel_id = self._player:channel_id()
		local game_object_id = self._game_object_id
		local sound_alias_id = NetworkLookup.player_character_looping_sound_aliases[sound_alias]
		local source_id = optional_source_name and NetworkLookup.player_character_fx_sources[optional_source_name]

		Managers.state.game_session:send_rpc_clients_except("rpc_play_looping_player_sound", channel_id, game_object_id, sound_alias_id, source_id)
	end
end

PlayerUnitFxExtension._trigger_looping_wwise_event = function (self, sound_alias, optional_source_name)
	local data = self._looping_sounds[sound_alias]
	local sound_config = PlayerCharacterLoopingSoundAliases[sound_alias]
	local has_husk_events = not not sound_config.has_husk_events
	local is_2d = sound_config.is_2d

	if is_2d then
		-- Nothing
	end

	local is_husk = self:should_play_husk_effect()

	if not is_husk or has_husk_events then
		local start_config = sound_config.start
		local event_alias = start_config.event_alias
		local resolved, event_name = self._visual_loadout_extension:resolve_gear_sound(event_alias)
		local event_id = nil

		if resolved then
			local wwise_event_name = is_husk and has_husk_events and event_name .. "_husk" or event_name

			if is_2d then
				event_id = WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name)
			else
				local source = self._sources[optional_source_name]
				event_id = WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, source)
			end

			data.event_name = event_name
			data.event_alias = event_alias
			data.id = event_id
		end
	end

	local stop_config = sound_config.stop
	local stop_event_alias = stop_config.event_alias

	if stop_event_alias and (not is_husk or has_husk_events) then
		local resolved, stop_event_name = self._visual_loadout_extension:resolve_gear_sound(stop_event_alias)

		if resolved then
			data.stop_event_name = stop_event_name
		end
	end

	data.source_name = optional_source_name
	data.is_husk = is_husk
	data.is_playing = true
end

PlayerUnitFxExtension.stop_looping_wwise_event = function (self, sound_alias)
	local is_server = self._is_server
	local is_local = self._is_local_unit
	local config = PlayerCharacterLoopingSoundAliases[sound_alias]
	local trigger_event = true

	if config.is_exclusive then
		trigger_event = self._first_person_extension:is_camera_follow_target()
	end

	if trigger_event then
		self:_stop_looping_wwise_event(sound_alias)
	end

	local component = self._looping_sounds_components[sound_alias]
	component.is_playing = false

	if not config.is_2d then
		component.source_name = "n/a"
	end

	if is_server then
		local channel_id = self._player:channel_id()
		local game_object_id = self._game_object_id
		local sound_alias_id = NetworkLookup.player_character_looping_sound_aliases[sound_alias]

		Managers.state.game_session:send_rpc_clients_except("rpc_stop_looping_player_sound", channel_id, game_object_id, sound_alias_id)
	end
end

PlayerUnitFxExtension._stop_looping_wwise_event = function (self, sound_alias, force_stop)
	local data = self._looping_sounds[sound_alias]
	local config = PlayerCharacterLoopingSoundAliases[sound_alias]
	local is_husk = data.is_husk
	local stop_event_name = data.stop_event_name
	local event_id = data.id

	if stop_event_name and not force_stop then
		local wwise_event_name = is_husk and stop_event_name .. "_husk" or stop_event_name

		if config.is_2d then
			WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name)
		else
			local source_name = data.source_name
			local source = self._sources[source_name]

			WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, source)
		end
	elseif event_id then
		WwiseWorld.stop_event(self._wwise_world, event_id)
	end

	data.source_name = nil
	data.stop_event_name = nil
	data.event_name = nil
	data.event_alias = nil
	data.id = nil
	data.is_husk = nil
	data.is_playing = false
end

PlayerUnitFxExtension.is_looping_wwise_event_playing = function (self, looping_sound_alias)
	local component = self._looping_sounds_components[looping_sound_alias]

	return component and component.is_playing
end

local function _register_vfx_spawner_from_attachments(parent_unit, attachments, node_name, spawner_name)
	local num_attachments = #attachments

	for i = 1, num_attachments do
		local unit = attachments[i]

		if Unit.has_node(unit, node_name) then
			local node = Unit.node(unit, node_name)
			local spawner = {
				unit = unit,
				node = node
			}

			return spawner
		end
	end

	if Unit.has_node(parent_unit, node_name) then
		local node = Unit.node(parent_unit, node_name)
		local spawner = {
			unit = parent_unit,
			node = node
		}

		return spawner
	end

	local fallback_spawner = {
		node = 1,
		unit = parent_unit
	}

	return fallback_spawner
end

PlayerUnitFxExtension.register_vfx_spawner = function (self, spawner_name, parent_unit, attachments, node_name, should_add_3p_node)
	local spawners = self._vfx_spawners

	self:_register_vfx_spawner(spawners, spawner_name, parent_unit, attachments, node_name, should_add_3p_node)
end

PlayerUnitFxExtension._register_vfx_spawner = function (self, spawners, spawner_name, parent_unit, attachments, node_name, should_add_3p_node)
	if attachments then
		local spawner = _register_vfx_spawner_from_attachments(parent_unit, attachments, node_name, spawner_name)
		spawners[spawner_name] = spawner
	else
		if Unit.has_node(parent_unit, node_name) then
			local node = Unit.node(parent_unit, node_name)
			spawners[spawner_name] = {
				unit = parent_unit,
				node = node
			}
		else
			spawners[spawner_name] = {
				node = 1,
				unit = parent_unit
			}
		end

		if should_add_3p_node then
			local unit_3p = self._unit

			if Unit.has_node(unit_3p, node_name) then
				local node = Unit.node(unit_3p, node_name)
				local spawner = spawners[spawner_name]
				spawner.node_3p = node
			else
				local spawner = spawners[spawner_name]
				spawner.node_3p = 1
			end
		end
	end
end

local temp_playing_looping_particles = {}
local temp_external_properties = {}

PlayerUnitFxExtension.move_vfx_spawner = function (self, spawner_name, parent_unit, attachments, node_name)
	local spawners = self._vfx_spawners

	table.clear(temp_playing_looping_particles)
	table.clear(temp_external_properties)

	local looping_particles = self._looping_particles

	for particle_alias, data in pairs(looping_particles) do
		if data.is_playing and data.spawner_name == spawner_name then
			temp_playing_looping_particles[particle_alias] = true
			temp_external_properties[particle_alias] = data.external_properties
			local should_fade_kill = false

			self:_stop_looping_particles(particle_alias, should_fade_kill)
		end
	end

	self:_register_vfx_spawner(spawners, spawner_name, parent_unit, attachments, node_name)

	local link = true
	local position_offset, rotation_offset, scale = nil

	for particle_alias, _ in pairs(temp_playing_looping_particles) do
		local external_properties_or_nil = temp_external_properties[particle_alias]

		self:_spawn_looping_particles(particle_alias, spawner_name, external_properties_or_nil, link, position_offset, rotation_offset, scale)
	end
end

PlayerUnitFxExtension.unregister_vfx_spawner = function (self, spawner_name)
	self._vfx_spawners[spawner_name] = nil
end

PlayerUnitFxExtension.stop_looping_wwise_events_for_source_on_mispredict = function (self, source_name)
	local looping_sounds = self._looping_sounds

	for alias_name, data in pairs(looping_sounds) do
		if data.source_name == source_name then
			self:_stop_looping_wwise_event(alias_name)
		end
	end
end

PlayerUnitFxExtension.spawn_looping_particles = function (self, looping_particle_alias, optional_spawner_name, external_properties)
	local is_server = self._is_server
	local is_local = self._is_local_unit
	local link = true
	local position_offset, rotation_offset, scale = nil

	self:_spawn_looping_particles(looping_particle_alias, optional_spawner_name, external_properties, link, position_offset, rotation_offset, scale)

	local component = self._looping_particles_components[looping_particle_alias]
	component.is_playing = true

	if optional_spawner_name then
		component.spawner_name = optional_spawner_name
	end

	local particle_config = PlayerCharacterLoopingParticleAliases[looping_particle_alias]
	local external_properties_config = particle_config.external_properties

	if external_properties_config then
		for property_name, _ in pairs(external_properties_config) do
			component[property_name] = external_properties[property_name] or "n/a"
		end
	end

	if self._is_server then
		local data = self._looping_particles[looping_particle_alias]
		local looping_particle_alias_id = NetworkLookup.player_character_looping_particle_aliases[looping_particle_alias]
		local particle_name = data.particle_name
		local particle_id = NetworkLookup.player_character_particles[particle_name]
		local except = self._player:channel_id()

		Managers.state.game_session:send_rpc_clients_except("rpc_spawn_looping_player_particles", except, self._game_object_id, looping_particle_alias_id, particle_id, optional_spawner_name and NetworkLookup.player_character_fx_sources[optional_spawner_name] or nil, link)
	end
end

PlayerUnitFxExtension._spawn_looping_particles = function (self, looping_particle_alias, optional_spawner_name, external_properties, link, position_offset, rotation_offset, scale)
	local data = self._looping_particles[looping_particle_alias]
	local particle_config = PlayerCharacterLoopingParticleAliases[looping_particle_alias]
	local particle_alias = particle_config.particle_alias
	local screen_space = particle_config.screen_space

	if screen_space then
		-- Nothing
	end

	local resolved, particle_name = self._visual_loadout_extension:resolve_gear_particle(particle_alias, external_properties)

	if not resolved then
		return
	end

	local particle_id = nil

	if screen_space then
		if self._is_in_first_person_mode then
			particle_id = self:_create_particles_wrapper(self._, particle_name, Vector3(0, 0, 1))
		end
	else
		local orphaned_policy = "unlink"
		particle_id = self:_spawn_unit_particles(particle_name, optional_spawner_name, link, orphaned_policy, position_offset, rotation_offset, scale)
	end

	data.id = particle_id
	data.is_playing = true
	data.spawner_name = optional_spawner_name
	data.particle_name = particle_name
	local external_properties_config = particle_config.external_properties

	if external_properties_config then
		local saved_external_properties = data.external_properties

		for property_name, _ in pairs(external_properties_config) do
			saved_external_properties[property_name] = external_properties[property_name]
		end
	end
end

PlayerUnitFxExtension.stop_looping_particles = function (self, looping_particle_alias, should_fade_kill)
	local is_server = self._is_server
	local is_local = self._is_local_unit

	self:_stop_looping_particles(looping_particle_alias, should_fade_kill)

	local component = self._looping_particles_components[looping_particle_alias]
	component.is_playing = false
	local particle_config = PlayerCharacterLoopingParticleAliases[looping_particle_alias]

	if not particle_config.screen_space then
		component.spawner_name = "n/a"
	end

	local external_properties_config = particle_config.external_properties

	if external_properties_config then
		for property_name, _ in pairs(external_properties_config) do
			component[property_name] = "n/a"
		end
	end

	if self._is_server then
		local except = self._player:channel_id()

		Managers.state.game_session:send_rpc_clients_except("rpc_stop_looping_particles", except, self._game_object_id, NetworkLookup.player_character_looping_particle_aliases[looping_particle_alias], should_fade_kill)
	end
end

PlayerUnitFxExtension._stop_looping_particles = function (self, looping_particle_alias, should_fade_kill)
	local data = self._looping_particles[looping_particle_alias]
	local id = data.id

	if id then
		if should_fade_kill then
			World.stop_spawning_particles(self._world, id)
		else
			World.destroy_particles(self._world, id)
		end
	end

	data.id = nil
	data.is_playing = false
	data.spawner_name = "n/a"
	data.particle_name = nil
end

PlayerUnitFxExtension.is_looping_particles_playing = function (self, looping_particle_alias)
	local component = self._looping_particles_components[looping_particle_alias]

	return component and component.is_playing
end

PlayerUnitFxExtension.spawn_particles = function (self, particle_name, position, rotation, scale, optional_variable_name, optional_variable_value)
	local world = self._world
	local is_resim = self._unit_data_extension.is_resimulating

	if not is_resim then
		local particle_id = self:_create_particles_wrapper(world, particle_name, position, rotation, scale)

		if self._is_server then
			if optional_variable_name then
				local variable_index = World.find_particles_variable(world, particle_name, optional_variable_name)

				World.set_particles_variable(world, particle_id, variable_index, optional_variable_value)
				Managers.state.game_session:send_rpc_clients("rpc_spawn_player_particles_with_variable", self._game_object_id, NetworkLookup.player_character_particles[particle_name], NetworkLookup.player_character_fx_sources["n/a"], false, position, rotation or Quaternion.identity(), scale or Vector3(1, 1, 1), NetworkLookup.player_character_particle_variable_names[optional_variable_name], optional_variable_value)
			else
				Managers.state.game_session:send_rpc_clients("rpc_spawn_player_particles", self._game_object_id, NetworkLookup.player_character_particles[particle_name], NetworkLookup.player_character_fx_sources["n/a"], false, position, rotation or Quaternion.identity(), scale or Vector3(1, 1, 1), particle_id)
			end
		end

		return particle_id
	end
end

PlayerUnitFxExtension.spawn_unit_particles = function (self, particle_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset, scale, all_clients)
	local is_resim = self._unit_data_extension.is_resimulating

	if not is_resim then
		local particle_id = self:_spawn_unit_particles(particle_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset, scale)

		if self._is_server then
			if not all_clients then
				Managers.state.game_session:send_rpc_clients_except("rpc_spawn_player_particles", self._player:channel_id(), self._game_object_id, NetworkLookup.player_character_particles[particle_name], NetworkLookup.player_character_fx_sources[spawner_name], link, position_offset or Vector3.zero(), rotation_offset or Quaternion.identity(), scale or Vector3(1, 1, 1), particle_id)
			else
				Managers.state.game_session:send_rpc_clients("rpc_spawn_player_particles", self._game_object_id, NetworkLookup.player_character_particles[particle_name], NetworkLookup.player_character_fx_sources[spawner_name], link, position_offset or Vector3.zero(), rotation_offset or Quaternion.identity(), scale or Vector3(1, 1, 1), particle_id)
			end
		end

		return particle_id
	end
end

PlayerUnitFxExtension._spawn_unit_particles = function (self, particle_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset, scale, test)
	local world = self._world
	local pose = Matrix4x4.identity()

	if position_offset then
		Matrix4x4.set_translation(pose, position_offset)
	end

	if rotation_offset then
		Matrix4x4.set_rotation(pose, rotation_offset)
	end

	if scale then
		Matrix4x4.set_scale(pose, scale)
	end

	local spawner = self._vfx_spawners[spawner_name]
	local unit = self._unit
	local is_first_person = self._is_in_first_person_mode
	local node_unit, node = nil

	if is_first_person or not spawner.node_3p then
		node_unit = spawner.unit
		node = spawner.node
	else
		node = spawner.node_3p
		node_unit = unit
	end

	local particle_id = nil

	if link then
		particle_id = self:_create_particles_wrapper(world, particle_name, Vector3.zero())

		World.link_particles(world, particle_id, node_unit, node, pose, orphaned_policy)
	else
		local spawner_pose = Unit.world_pose(node_unit, node)
		local spawn_pose = Matrix4x4.multiply(pose, spawner_pose)
		particle_id = self:_create_particles_wrapper(world, particle_name, Matrix4x4.translation(spawn_pose), Matrix4x4.rotation(spawn_pose), Matrix4x4.scale(spawn_pose))
	end

	if is_first_person then
		World.set_particles_use_custom_fov(world, particle_id, true)
	end

	return particle_id
end

PlayerUnitFxExtension.destroy_player_particles = function (self, particle_id)
	World.destroy_particles(self._world, particle_id)

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_destroy_player_particles", self._game_object_id, particle_id)
	end
end

PlayerUnitFxExtension.stop_player_particles = function (self, particle_id)
	World.stop_spawning_particles(self._world, particle_id)

	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_stop_player_particles", self._game_object_id, particle_id)
	end
end

PlayerUnitFxExtension.rpc_play_player_sound = function (self, channel_id, game_object_id, event_id, source_id, append_husk_to_event_name)
	local event_name = NetworkLookup.player_character_sounds[event_id]
	local source_name = NetworkLookup.player_character_fx_sources[source_id]
	local source = self._sources[source_name]

	if not source then
		return
	end

	if append_husk_to_event_name and self:should_play_husk_effect() then
		event_name = event_name .. "_husk"
	end

	WwiseWorld.trigger_resource_event(self._wwise_world, event_name, source)
end

PlayerUnitFxExtension.rpc_play_player_sound_with_position = function (self, channel_id, game_object_id, event_id, sound_position, append_husk_to_event_name)
	local event_name = NetworkLookup.player_character_sounds[event_id]

	if append_husk_to_event_name and self:should_play_husk_effect() then
		event_name = event_name .. "_husk"
	end

	WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sound_position)
end

PlayerUnitFxExtension.rpc_player_trigger_wwise_event_synced = function (self, channel_id, game_object_id, event_name_id, append_husk_to_event_name, optional_occlusion, optional_unit_id, is_level_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name_id, optional_parameter_value, optional_switch_name_id, optional_switch_value_id)
	local event_name = NetworkLookup.player_character_sounds[event_name_id]
	local optional_switch_name = optional_switch_name_id and NetworkLookup.sound_switches[optional_switch_name_id]
	local optional_switch_value = optional_switch_value_id and NetworkLookup.sound_switch_values[optional_switch_value_id]
	local optional_parameter_name = optional_parameter_name_id and NetworkLookup.sound_parameters[optional_parameter_name_id]
	local optional_unit = nil

	if optional_unit_id then
		optional_unit = Managers.state.unit_spawner:unit(optional_unit_id, is_level_unit)
	end

	self:_trigger_wwise_event_synced(event_name, append_husk_to_event_name, optional_occlusion, optional_unit, optional_node_index, optional_position, optional_rotation, optional_parameter_name, optional_parameter_value, optional_switch_name, optional_switch_value)
end

PlayerUnitFxExtension.rpc_play_server_controlled_player_sound = function (self, channel_id, game_object_id, event_id, append_husk_to_event_name, optional_position, optional_parameter_name_id, optional_parameter_value)
	local event_name = NetworkLookup.player_character_sounds[event_id]
	local optional_parameter_name = optional_parameter_name_id and NetworkLookup.sound_parameters[optional_parameter_name_id] or nil

	self:_trigger_wwise_event_server_controlled(event_name, append_husk_to_event_name, optional_position, optional_parameter_name, optional_parameter_value)
end

PlayerUnitFxExtension.rpc_set_source_parameter = function (self, channel_id, game_object_id, source_id, parameter_id, parameter_value)
	local parameter_name = NetworkLookup.sound_parameters[parameter_id]
	local source_name = NetworkLookup.player_character_fx_sources[source_id]
	local source = self._sources[source_name]

	WwiseWorld.set_source_parameter(self._wwise_world, source, parameter_name, parameter_value)
end

PlayerUnitFxExtension.rpc_play_exclusive_player_sound = function (self, channel_id, game_object_id, event_id, optional_position)
	local event_name = NetworkLookup.player_character_sounds[event_id]

	self:trigger_exclusive_wwise_event(event_name, optional_position)
end

PlayerUnitFxExtension.rpc_spawn_exclusive_particle = function (self, channel_id, game_object_id, particle_id, position, rotation, scale)
	local particle_name = NetworkLookup.player_character_particles[particle_id]

	self:spawn_exclusive_particle(particle_name, position, rotation, scale)
end

PlayerUnitFxExtension.rpc_play_looping_player_sound = function (self, channel_id, game_object_id, sound_alias_id, optional_source_id)
	local sound_alias = NetworkLookup.player_character_looping_sound_aliases[sound_alias_id]
	local source_name = optional_source_id and NetworkLookup.player_character_fx_sources[optional_source_id]

	self:_trigger_looping_wwise_event(sound_alias, source_name)
end

PlayerUnitFxExtension.rpc_stop_looping_player_sound = function (self, channel_id, game_object_id, sound_alias_id)
	local sound_alias = NetworkLookup.player_character_looping_sound_aliases[sound_alias_id]
	local data = self._looping_sounds[sound_alias]

	if not data.is_playing then
		Log.exception("PlayerUnitFxExtension", "Got RPC to stop looping event that isn't playing. %q", sound_alias)

		return
	end

	self:_stop_looping_wwise_event(sound_alias)
end

PlayerUnitFxExtension.rpc_spawn_player_particles = function (self, channel_id, game_object_id, particle_name_id, particle_spawner_id, link, position_offset, rotation_offset, scale, particle_id)
	local particle_name = NetworkLookup.player_character_particles[particle_name_id]
	local spawner_name = NetworkLookup.player_character_fx_sources[particle_spawner_id]
	local id = nil

	if spawner_name == "n/a" then
		id = self:_create_particles_wrapper(self._world, particle_name, position_offset, rotation_offset, scale)
	else
		id = self:_spawn_unit_particles(particle_name, spawner_name, link, "unlink", position_offset, rotation_offset, scale)
	end

	self._player_particles[particle_id] = id
end

PlayerUnitFxExtension.rpc_destroy_player_particles = function (self, channel_id, game_object_id, key_id)
	local particle_id = self._player_particles[key_id]

	if particle_id then
		self:destroy_player_particles(particle_id)
	end
end

PlayerUnitFxExtension.rpc_stop_player_particles = function (self, channel_id, game_object_id, key_id)
	local particle_id = self._player_particles[key_id]

	if particle_id then
		self:stop_player_particles(particle_id)
	end
end

PlayerUnitFxExtension.rpc_spawn_player_particles_with_variable = function (self, channel_id, game_object_id, particle_name_id, particle_spawner_id, link, position_offset, rotation_offset, scale, variable_name_id, variable_value)
	local particle_name = NetworkLookup.player_character_particles[particle_name_id]
	local spawner_name = NetworkLookup.player_character_fx_sources[particle_spawner_id]
	local world = self._world
	local particle_id = nil

	if spawner_name == "n/a" then
		particle_id = self:_create_particles_wrapper(world, particle_name, position_offset, rotation_offset, scale)
	else
		particle_id = self:_spawn_unit_particles(particle_name, spawner_name, link, "unlink", position_offset, rotation_offset, scale)
	end

	local variable_name = NetworkLookup.player_character_particle_variable_names[variable_name_id]
	local variable_index = World.find_particles_variable(world, particle_name, variable_name)

	World.set_particles_variable(world, particle_id, variable_index, variable_value)
end

PlayerUnitFxExtension.rpc_spawn_looping_player_particles = function (self, channel_id, game_object_id, looping_particle_alias_id, particle_name_id, optional_particle_spawner_id, link)
	local looping_particle_alias = NetworkLookup.player_character_looping_particle_aliases[looping_particle_alias_id]
	local particle_name = NetworkLookup.player_character_particles[particle_name_id]
	local optional_spawner_name = optional_particle_spawner_id and NetworkLookup.player_character_fx_sources[optional_particle_spawner_id]
	local particle_config = PlayerCharacterLoopingParticleAliases[looping_particle_alias]
	local particle_id = nil

	if particle_config.screen_space then
		if self._is_in_first_person_mode then
			particle_id = self:_create_particles_wrapper(self._world, particle_name, Vector3(0, 0, 1))
		end
	else
		particle_id = self:_spawn_unit_particles(particle_name, optional_spawner_name, link, "unlink")
	end

	local data = self._looping_particles[looping_particle_alias]
	data.id = particle_id
	data.is_playing = true
	data.spawner_name = optional_spawner_name
	data.particle_name = particle_name
end

PlayerUnitFxExtension.rpc_stop_looping_particles = function (self, channel_id, game_object_id, looping_particle_alias_id, should_fade_kill)
	local looping_particle_alias = NetworkLookup.player_character_looping_particle_aliases[looping_particle_alias_id]
	local data = self._looping_particles[looping_particle_alias]
	local id = data.id

	if id then
		if should_fade_kill then
			World.stop_spawning_particles(self._world, id)
		else
			World.destroy_particles(self._world, id)
		end
	end

	data.id = nil
	data.is_playing = false
	data.spawner_name = nil
	data.particle_name = nil
end

PlayerUnitFxExtension.rpc_spawn_player_fx_line = function (self, channel_id, game_object_id, line_effect_id, is_critical_strike, source_id, end_position, link, scale, append_husk_to_event_name)
	local line_effect_name = NetworkLookup.line_effects[line_effect_id]
	local line_effect = LineEffects[line_effect_name]
	local source_name = NetworkLookup.player_character_fx_sources[source_id]
	local orphaned_policy = "stop"

	self:_spawn_unit_fx_line(line_effect, is_critical_strike, source_name, end_position, link, orphaned_policy, scale, append_husk_to_event_name)
end

function _closest_point_on_line(player_position, start_position, end_position)
	local closest_point = Geometry.closest_point_on_line(player_position, start_position, end_position)

	return closest_point
end

return PlayerUnitFxExtension
