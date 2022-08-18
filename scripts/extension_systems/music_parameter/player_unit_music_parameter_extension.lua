local HordeSettings = require("scripts/settings/horde/horde_settings")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local PlayerUnitMusicParameterExtension = class("PlayerUnitMusicParameterExtension")
local HORDE_TYPES = HordeSettings.horde_types

PlayerUnitMusicParameterExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit
	self._horde_manager = Managers.state.horde
	self._game_session_manager = Managers.state.game_session
	self._player_manager = Managers.player
	self._pacing_manager = Managers.state.pacing
	self._side_system = Managers.state.extension:system("side_system")
	self._vector_horde_near = false
	self._ambush_horde_near = false
	self._last_man_standing = false
	self._boss_near = false
	self._health_percent = 0
	self._intensity_percent = 0
	self._locked_in_melee = false
	self._update_horde_near_time = 0
	self._horde_update_interval = 1
	local is_server = extension_init_context.is_server

	if not is_server then
		self._game_object_id = nil_or_game_object_id
		self._game_session = game_object_data_or_game_session
	end

	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._attack_intensity_extension = ScriptUnit.extension(unit, "attack_intensity_system")
end

PlayerUnitMusicParameterExtension.destroy = function (self)
	GameSession.destroy_game_object(self._game_session, self._music_parameters_game_object_id)
end

PlayerUnitMusicParameterExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_object_id = game_object_id
	self._game_session = game_session
	local go_data_table = {
		last_man_standing = false,
		locked_in_melee = false,
		boss_near = false,
		ambush_horde_near = false,
		vector_horde_near = false,
		intensity_percent = 0,
		game_object_type = NetworkLookup.game_object_types.music_parameters,
		unit_game_object_id = game_object_id
	}
	self._music_parameters_game_object_id = GameSession.create_game_object(game_session, "music_parameters", go_data_table)
end

local boss_trigger_distance_sq = WwiseGameSyncSettings.boss_trigger_distance * WwiseGameSyncSettings.boss_trigger_distance

PlayerUnitMusicParameterExtension._check_is_boss_near = function (self, alive_monsters, alive_witches_lookup)
	local player_position = POSITION_LOOKUP[self._unit]

	for i = 1, alive_monsters.size, 1 do
		local monster_unit = alive_monsters[i]
		local distance_sq = Vector3.distance_squared(player_position, POSITION_LOOKUP[monster_unit])

		if not alive_witches_lookup[monster_unit] and distance_sq <= boss_trigger_distance_sq then
			return true
		end
	end

	return false
end

PlayerUnitMusicParameterExtension._update_boss_near = function (self, unit)
	local boss_near = self._boss_near
	local side = self._side_system.side_by_unit[unit]
	local alive_monsters = side:alive_units_by_tag("enemy", "monster")

	if boss_near then
		local alive_witches = side:alive_units_by_tag("enemy", "witch")
		local num_alive_monsters = alive_monsters.size
		local num_alive_witches = alive_witches.size
		boss_near = num_alive_witches < num_alive_monsters
	else
		local alive_witches_lookup = side.units_by_relation_tag_lookup.enemy.witch
		boss_near = self:_check_is_boss_near(alive_monsters, alive_witches_lookup)
	end

	if boss_near ~= self._boss_near then
		GameSession.set_game_object_field(self._game_session, self._music_parameters_game_object_id, "boss_near", boss_near)

		self._boss_near = boss_near
	end
end

PlayerUnitMusicParameterExtension._shortest_horde_distance = function (self, positions)
	local shortest_distance = math.huge
	local player_position = POSITION_LOOKUP[self._unit]

	for i = 1, #positions, 1 do
		local horde_position = positions[i]
		local distance = Vector3.distance_squared(player_position, horde_position)

		if distance < shortest_distance then
			shortest_distance = distance
		end
	end

	return math.sqrt(shortest_distance)
end

PlayerUnitMusicParameterExtension._update_horde_near = function (self, t)
	if self._update_horde_near_time <= t then
		local ambush_horde_positions = self._horde_manager:horde_positions(HORDE_TYPES.ambush_horde)
		local ambush_horde_near = self:_shortest_horde_distance(ambush_horde_positions) <= WwiseGameSyncSettings.ambush_horde_trigger_distance
		local vector_horde_positions = self._horde_manager:horde_positions(HORDE_TYPES.far_vector_horde)
		local vector_horde_near = self:_shortest_horde_distance(vector_horde_positions) <= WwiseGameSyncSettings.vector_horde_trigger_distance
		local game_session = self._game_session
		local game_object_id = self._music_parameters_game_object_id

		GameSession.set_game_object_field(game_session, game_object_id, "vector_horde_near", vector_horde_near)
		GameSession.set_game_object_field(game_session, game_object_id, "ambush_horde_near", ambush_horde_near)

		self._vector_horde_near = vector_horde_near
		self._ambush_horde_near = ambush_horde_near
		self._update_horde_near_time = t + self._horde_update_interval
	end
end

PlayerUnitMusicParameterExtension._update_last_man_standing = function (self)
	local game_session_manager = self._game_session_manager
	local player_manager = self._player_manager
	local game_session = self._game_session
	local game_object_id = self._music_parameters_game_object_id
	local num_players = player_manager:num_players()
	local last_man_standing = nil

	if num_players == 1 then
		last_man_standing = false
	else
		local players = player_manager:players()
		local alive_players = 0
		local connected_players = 0

		for _, player in pairs(players) do
			local peer_id = player:peer_id()
			local is_connected = game_session_manager:connected_to_client(peer_id)

			if is_connected then
				connected_players = connected_players + 1
				local player_unit = player.player_unit

				if HEALTH_ALIVE[player_unit] then
					local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
					local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
					local hogtied = character_state_component and PlayerUnitStatus.is_hogtied(character_state_component)

					if not hogtied then
						alive_players = alive_players + 1
					end
				end
			end
		end

		last_man_standing = connected_players > 1 and alive_players == 1
	end

	GameSession.set_game_object_field(game_session, game_object_id, "last_man_standing", last_man_standing)

	self._last_man_standing = last_man_standing
end

PlayerUnitMusicParameterExtension.fixed_update = function (self, unit, dt, t)
	local game_session = self._game_session
	local game_object_id = self._music_parameters_game_object_id
	local attack_intensity_extension = self._attack_intensity_extension

	Profiler.start("near_boss")
	self:_update_boss_near(unit)
	Profiler.stop("near_boss")
	Profiler.start("near_horde")
	self:_update_horde_near(t)
	Profiler.stop("near_horde")
	Profiler.start("last_man")
	self:_update_last_man_standing()
	Profiler.stop("last_man")

	local health_percent = self._health_extension:current_health_percent()
	local intensity_percent = attack_intensity_extension:total_intensity_percent()
	local locked_in_melee = attack_intensity_extension:locked_in_melee()
	self._health_percent = health_percent
	self._intensity_percent = intensity_percent
	self._locked_in_melee = locked_in_melee

	GameSession.set_game_object_field(game_session, game_object_id, "intensity_percent", intensity_percent)
	GameSession.set_game_object_field(game_session, game_object_id, "locked_in_melee", locked_in_melee)

	local num_aggroed_minions = self._pacing_manager:num_aggroed_minions()
	self._num_aggroed_minions = num_aggroed_minions

	GameSession.set_game_object_field(game_session, game_object_id, "num_aggroed_minions", num_aggroed_minions)
end

PlayerUnitMusicParameterExtension.vector_horde_near = function (self)
	return self._vector_horde_near
end

PlayerUnitMusicParameterExtension.ambush_horde_near = function (self)
	return self._ambush_horde_near
end

PlayerUnitMusicParameterExtension.last_man_standing = function (self)
	return self._last_man_standing
end

PlayerUnitMusicParameterExtension.boss_near = function (self)
	return self._boss_near
end

PlayerUnitMusicParameterExtension.health_percent = function (self)
	return self._health_percent
end

PlayerUnitMusicParameterExtension.intensity_percent = function (self)
	return self._intensity_percent
end

PlayerUnitMusicParameterExtension.locked_in_melee = function (self)
	return self._locked_in_melee
end

PlayerUnitMusicParameterExtension.num_aggroed_minions = function (self)
	return self._num_aggroed_minions
end

return PlayerUnitMusicParameterExtension
