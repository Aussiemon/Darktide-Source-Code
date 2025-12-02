-- chunkname: @scripts/managers/player/player_unit_spawn_manager.lua

local BotSpawning = require("scripts/managers/bot/bot_spawning")
local Breeds = require("scripts/settings/breed/breeds")
local UnitSpawnerManager = require("scripts/foundation/managers/unit_spawner/unit_spawner_manager")
local DELETION_STATES = UnitSpawnerManager.DELETION_STATES
local PlayerUnitSpawnManager = class("PlayerUnitSpawnManager")
local CLIENT_RPCS = {
	"rpc_register_player_unit_ragdoll",
}

PlayerUnitSpawnManager.init = function (self, is_server, level_seed, has_navmesh, game_mode_name, network_event_delegate, soft_cap_out_of_bounds_units)
	self._is_server = is_server
	self._has_navmesh = has_navmesh
	self._unit_owners = {}
	self._players_with_unit = {}
	self._players_without_unit = {}
	self._players_to_spawn = {}
	self._num_players_to_spawn = 0
	self._seed = level_seed
	self._frozen_ragdolls = {}
	self._soft_cap_out_of_bounds_units = soft_cap_out_of_bounds_units
	self._queued_despawns = {}

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end

	if self._is_server then
		local settings = Managers.state.game_mode:settings()
		local bot_backfilling_allowed = settings.bot_backfilling_allowed

		self._queued_bots_n = 0

		if bot_backfilling_allowed then
			self:_register_bot_events()
			self:_validate_bot_backfill()
			self:_handle_initial_bot_spawning()
		end
	end
end

PlayerUnitSpawnManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	if self._is_server then
		local settings = Managers.state.game_mode:settings()

		if settings.bot_backfilling_allowed then
			self:_unregister_bot_events()
		end
	end
end

PlayerUnitSpawnManager.fixed_update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local num_players_to_spawn = 0
	local players_to_spawn = self._players_to_spawn
	local dead_players = self._players_without_unit
	local game_mode_manager = Managers.state.game_mode

	table.clear(players_to_spawn)

	for _, player in pairs(dead_players) do
		if game_mode_manager:can_spawn_player(player) then
			num_players_to_spawn = num_players_to_spawn + 1
			players_to_spawn[num_players_to_spawn] = player
		end
	end

	self._num_players_to_spawn = num_players_to_spawn
end

PlayerUnitSpawnManager.update = function (self, dt, t)
	self:_update_ragdolls(self._frozen_ragdolls, self._soft_cap_out_of_bounds_units)

	if self._is_server then
		self:_handle_bot_spawning()
	end
end

PlayerUnitSpawnManager.process_queued_despawns = function (self)
	local player_manager = Managers.player
	local queued_despawns = self._queued_despawns

	for unique_id, _ in pairs(queued_despawns) do
		local player = player_manager:player_from_unique_id(unique_id)

		self:despawn_player(player)

		queued_despawns[unique_id] = nil
	end
end

PlayerUnitSpawnManager._update_ragdolls = function (self, frozen_ragdolls, soft_cap_out_of_bounds_units)
	local ALIVE = ALIVE

	for player_unit, frozen in pairs(frozen_ragdolls) do
		local despawned = false

		if not ALIVE[player_unit] then
			frozen_ragdolls[player_unit] = nil
			despawned = true
		end

		local check_oob = not frozen and not despawned
		local is_oob = check_oob and soft_cap_out_of_bounds_units[player_unit]

		if is_oob then
			self:_freeze_ragdoll(player_unit, frozen_ragdolls)
		end
	end
end

PlayerUnitSpawnManager._freeze_ragdoll = function (self, player_unit, frozen_ragdolls)
	local num_actors = Unit.num_actors(player_unit)

	for actor_index = 1, num_actors do
		local actor = Unit.actor(player_unit, actor_index)
		local is_dynamic = Actor.is_dynamic(actor)
		local is_physical = is_dynamic and not Actor.is_kinematic(actor)

		if is_physical then
			Actor.put_to_sleep(actor)
		end
	end

	frozen_ragdolls[player_unit] = true

	Log.info("PlayerUnitSpawnManager", "freeze_ragdoll player_unit %q", player_unit)
end

PlayerUnitSpawnManager.players_to_spawn = function (self)
	return self._players_to_spawn
end

PlayerUnitSpawnManager.has_players_waiting_to_spawn = function (self)
	return self._num_players_to_spawn > 0
end

PlayerUnitSpawnManager.num_players_to_spawn = function (self)
	return self._num_players_to_spawn
end

local alive_players = {}

PlayerUnitSpawnManager.alive_players = function (self)
	table.clear(alive_players)

	local players_with_unit = self._players_with_unit

	for _, player in pairs(players_with_unit) do
		alive_players[#alive_players + 1] = player
	end

	return alive_players
end

PlayerUnitSpawnManager.spawn_player = function (self, player, position, rotation, parent, force_spawn, optional_side_name, breed_name_optional, character_state_optional, is_respawn, optional_damage, optional_permanent_damage)
	local game_mode_manager = Managers.state.game_mode

	if not is_respawn and game_mode_manager:should_spawn_dead(player) then
		local unique_id = player:unique_id()

		self._players_without_unit[unique_id] = player

		return
	end

	local can_spawn = game_mode_manager:can_spawn_player(player)

	if can_spawn or force_spawn then
		local mutator_respawn_modifier = Managers.state.mutator:mutator("mutator_respawn_modifier")

		if mutator_respawn_modifier and mutator_respawn_modifier:is_active() then
			character_state_optional = mutator_respawn_modifier:respawn_state()
		end

		local player_unit = self:_spawn(player, position, rotation, parent, optional_side_name, breed_name_optional, character_state_optional, optional_damage, optional_permanent_damage)

		game_mode_manager:on_player_unit_spawn(player, player_unit, is_respawn)
	end
end

PlayerUnitSpawnManager._spawn = function (self, player, position, rotation, parent, optional_side_name, breed_name_optional, character_state_optional, optional_damage, optional_permanent_damage)
	local side_system = Managers.state.extension:system("side_system")
	local side_name = optional_side_name or side_system:get_default_player_side_name()
	local spawn_side = side_system:get_side_from_name(side_name)
	local spawn_side_id = spawn_side.side_id
	local breed_name = breed_name_optional or player:breed_name()
	local breed = Breeds[breed_name]
	local seed = self._seed
	local unit_template_name = Managers.state.game_mode:player_unit_template_name()
	local player_unit = Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, rotation, nil, player, breed, spawn_side_id, character_state_optional, player.input_handler, seed, optional_damage, optional_permanent_damage)

	if not player.remote then
		local pitch = Quaternion.pitch(rotation)
		local yaw = Quaternion.yaw(rotation)

		player:set_orientation(yaw, pitch, 0)
	end

	local is_on_movable_platform = false

	if parent then
		local platform_extension = ScriptUnit.has_extension(parent, "moveable_platform_system")

		if platform_extension then
			platform_extension:add_passenger(player_unit, true)

			is_on_movable_platform = true
		else
			local locomotion_extension = ScriptUnit.extension(player_unit, "locomotion_system")

			locomotion_extension:set_parent_unit(player_unit)
		end
	end

	Managers.state.out_of_bounds:register_soft_oob_unit(player_unit, self, "_on_player_soft_oob")
	Managers.event:trigger("player_unit_spawned", player)
	Managers.stats:record_private("hook_player_spawned", player, player:profile())

	return player_unit
end

PlayerUnitSpawnManager.despawn_player_safe = function (self, player)
	if Managers.state.unit_spawner:deletion_state() == DELETION_STATES.during_extension_update then
		self._queued_despawns[player:unique_id()] = true
	else
		self:despawn_player(player)
	end
end

PlayerUnitSpawnManager.despawn_player = function (self, player)
	local game_mode_manager = Managers.state.game_mode

	game_mode_manager:on_player_unit_despawn(player)
	self:_despawn(player)
end

PlayerUnitSpawnManager._despawn = function (self, player)
	if player:unit_is_alive() then
		local player_unit = player.player_unit
		local unit_spawner_manager = Managers.state.unit_spawner

		Managers.state.out_of_bounds:unregister_soft_oob_unit(player_unit, self)
		unit_spawner_manager:mark_for_deletion(player_unit)
		Managers.event:trigger("player_unit_despawned", player)
	end
end

PlayerUnitSpawnManager.assign_unit_ownership = function (self, unit, player, is_player_unit)
	self._unit_owners[unit] = player
	player.owned_units[unit] = unit

	if is_player_unit then
		player.player_unit = unit

		local unique_id = player:unique_id()

		self._players_with_unit[unique_id] = player
		self._players_without_unit[unique_id] = nil

		Managers.event:trigger("assign_player_unit_ownership", player, unit)
	end
end

PlayerUnitSpawnManager.relinquish_unit_ownership = function (self, unit)
	local player = self._unit_owners[unit]

	if unit == player.player_unit then
		player.player_unit = nil

		local unique_id = player:unique_id()

		self._players_with_unit[unique_id] = nil
		self._players_without_unit[unique_id] = player
	end

	self._unit_owners[unit] = nil
	player.owned_units[unit] = nil
end

PlayerUnitSpawnManager.remove_owner = function (self, units)
	for unit, _ in pairs(units) do
		self._unit_owners[unit] = nil
	end
end

PlayerUnitSpawnManager.owner = function (self, unit)
	return self._unit_owners[unit]
end

PlayerUnitSpawnManager.is_player_unit = function (self, unit)
	local owner = self._unit_owners[unit]

	if owner and owner.player_unit == unit then
		return true
	end

	return false
end

PlayerUnitSpawnManager.clear_player_unit = function (self, unique_id)
	self._players_without_unit[unique_id] = nil
end

PlayerUnitSpawnManager.register_player_unit_ragdoll = function (self, player_unit)
	Log.info("PlayerUnitSpawnManager", "Registering player_unit %q", player_unit)

	local owner = self._unit_owners[player_unit]
	local frozen_ragdolls = self._frozen_ragdolls

	if self._soft_cap_out_of_bounds_units[player_unit] then
		self:_freeze_ragdoll(player_unit, frozen_ragdolls)
	else
		Log.info("PlayerUnitSpawnManager", "Was not oob initially.")

		frozen_ragdolls[player_unit] = false
	end

	if self._is_server then
		local channel_id = owner:channel_id()
		local go_id = Managers.state.unit_spawner:game_object_id(player_unit)

		Managers.state.game_session:send_rpc_clients_except("rpc_register_player_unit_ragdoll", channel_id, go_id)
	end
end

PlayerUnitSpawnManager.is_tracking_player_ragdoll = function (self, player_unit)
	return self._frozen_ragdolls[player_unit] ~= nil
end

PlayerUnitSpawnManager.rpc_register_player_unit_ragdoll = function (self, sender, game_object_id)
	local player_unit = Managers.state.unit_spawner:unit(game_object_id)

	self:register_player_unit_ragdoll(player_unit)
end

PlayerUnitSpawnManager._on_player_soft_oob = function (self, unit)
	Log.info("PlayerUnitSpawnManager", "Despawning player that was out of bounds [%q].", unit)

	local unit_owner = self._unit_owners[unit]

	if not unit_owner then
		Managers.state.out_of_bounds:unregister_soft_oob_unit(unit, self)
		Managers.state.unit_spawner:mark_for_deletion(unit)
	else
		self:despawn_player_safe(unit_owner)
	end
end

PlayerUnitSpawnManager._register_bot_events = function (self)
	Managers.event:register(self, "host_game_session_manager_player_joined", "_on_client_joined")
	Managers.event:register(self, "multiplayer_session_client_disconnected", "_on_client_left")
end

PlayerUnitSpawnManager._unregister_bot_events = function (self)
	Managers.event:unregister(self, "host_game_session_manager_player_joined")
	Managers.event:unregister(self, "multiplayer_session_client_disconnected")
end

PlayerUnitSpawnManager._validate_bot_backfill = function (self)
	local available_slots = self:_num_available_bot_slots()

	if available_slots < 0 then
		for ii = 0, available_slots + 1, -1 do
			if self._queued_bots_n > 0 then
				self._queued_bots_n = self._queued_bots_n - 1
			else
				BotSpawning.despawn_best_bot()
			end
		end
	elseif available_slots > 0 then
		self._queued_bots_n = self._queued_bots_n + available_slots
	end
end

PlayerUnitSpawnManager._on_client_joined = function (self, peer_id)
	local players_at_peer = Managers.player:players_at_peer(peer_id)
	local num_players_joining = table.size(players_at_peer)
	local available_slots = self:_num_available_bot_slots()
	local bots_to_remove = math.min(num_players_joining, -available_slots)

	for i = 1, bots_to_remove do
		if self._queued_bots_n > 0 then
			self._queued_bots_n = self._queued_bots_n - 1
		else
			BotSpawning.despawn_best_bot()
		end
	end
end

PlayerUnitSpawnManager._on_client_left = function (self, removed_players_data)
	if not Managers.bot then
		return
	end

	local available_slots = self:_num_available_bot_slots()
	local num_players_leaving = #removed_players_data
	local bots_to_add = math.min(available_slots, num_players_leaving)

	self._queued_bots_n = self._queued_bots_n + bots_to_add
end

PlayerUnitSpawnManager._num_available_bot_slots = function (self)
	local settings = Managers.state.game_mode:settings()
	local bot_backfilling_allowed = settings.bot_backfilling_allowed
	local max_players = GameParameters.max_players
	local num_players = Managers.player:num_ready_human_players()
	local bot_synchronizer_host = Managers.bot:synchronizer_host()
	local max_bots = bot_backfilling_allowed and settings.max_bots or 0
	local num_bots = bot_synchronizer_host:num_bots() + self._queued_bots_n
	local desired_bot_count = max_players - num_players

	desired_bot_count = math.clamp(desired_bot_count, 0, max_bots)

	return desired_bot_count - num_bots
end

PlayerUnitSpawnManager.remove_all_bots = function (self)
	local bot_manager = Managers.bot
	local bot_synchronizer_host = bot_manager:synchronizer_host()

	if bot_synchronizer_host then
		local bot_ids = bot_synchronizer_host:active_bot_ids()

		for local_player_id, _ in pairs(bot_ids) do
			bot_synchronizer_host:remove_bot(local_player_id)
		end
	end
end

PlayerUnitSpawnManager._handle_initial_bot_spawning = function (self)
	local initial_bot_id_table = {
		1,
		2,
		3,
		4,
		5,
		6,
	}

	table.shuffle(initial_bot_id_table)

	while self._queued_bots_n > 0 do
		local bot_id = initial_bot_id_table[1]
		local bot_config_identifier = BotSpawning.get_bot_config_identifier()
		local profile_name = bot_config_identifier .. "_bot_" .. bot_id

		BotSpawning.spawn_bot_character(profile_name)
		table.remove(initial_bot_id_table, 1)

		self._queued_bots_n = self._queued_bots_n - 1
	end
end

local BOT_PROFILE_NAME_TABLE = {}

PlayerUnitSpawnManager._handle_bot_spawning = function (self)
	if self._queued_bots_n > 0 then
		local bot_config_identifier = BotSpawning.get_bot_config_identifier()

		table.clear(BOT_PROFILE_NAME_TABLE)

		for i = 1, 6 do
			BOT_PROFILE_NAME_TABLE[i] = bot_config_identifier .. "_bot_" .. i
		end

		table.shuffle(BOT_PROFILE_NAME_TABLE)

		local players = Managers.player:players()

		for _, player in pairs(players) do
			if not player:is_human_controlled() then
				local profile = player:profile()
				local key = table.find(BOT_PROFILE_NAME_TABLE, profile.identifier)

				if key then
					table.remove(BOT_PROFILE_NAME_TABLE, key)
				end
			end
		end

		local profile_name = BOT_PROFILE_NAME_TABLE[1]

		BotSpawning.spawn_bot_character(profile_name)

		self._queued_bots_n = self._queued_bots_n - 1
	end
end

return PlayerUnitSpawnManager
