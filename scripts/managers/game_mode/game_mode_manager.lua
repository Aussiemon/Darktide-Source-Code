local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local GameModeManagerTestify = GameParameters.testify and require("scripts/managers/game_mode/game_mode_manager_testify")
local GAME_MODES = {}

for name, settings in pairs(GameModeSettings) do
	local class_file_name = settings.class_file_name
	local class = require(class_file_name)
	GAME_MODES[name] = class
end

local CLIENT_RPCS = {
	"rpc_game_mode_end_conditions_met"
}
local GameModeManager = class("GameModeManager")

GameModeManager.init = function (self, game_mode_context, game_mode_name, gameplay_modifiers, network_event_delegate)
	self._is_server = game_mode_context.is_server
	local game_mode = GAME_MODES[game_mode_name]:new(game_mode_context, game_mode_name, network_event_delegate)

	assert_interface(game_mode, GameModeBase.INTERFACE)

	self._game_mode = game_mode
	self._end_conditions_met = false
	self._end_conditions_met_outcome = nil
	self._network_event_delegate = network_event_delegate
	self._gameplay_modifiers = {}
	self._physics_world = game_mode_context.physics_world

	if gameplay_modifiers then
		for i = 1, #gameplay_modifiers, 1 do
			self._gameplay_modifiers[gameplay_modifiers[i]] = true
		end
	end

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._num_raycasts = 0
	self._raycast_queue = {}
	self._async_raycast_handles = {}
	self._raycast_callback = callback(self, "_async_raycast_result_cb")
	self._num_physics_safe_callbacks = 0
	self._physics_safe_callbacks = {}
end

GameModeManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	self._game_mode:destroy()
end

GameModeManager.register_physics_safe_callback = function (self, cb)
	local index = self._num_physics_safe_callbacks + 1
	self._physics_safe_callbacks[index] = cb
	self._num_physics_safe_callbacks = index
end

GameModeManager._async_raycast_result_cb = function (self, id, hits, num_hits)
	local raycast_info = self._async_raycast_handles[id]

	raycast_info.cb(id, hits, num_hits, raycast_info)

	self._async_raycast_handles[id] = nil
end

GameModeManager.create_safe_raycast_object = function (self, ...)
	return PhysicsWorld.make_raycast(self._physics_world, self._raycast_callback, ...)
end

GameModeManager.add_safe_raycast = function (self, raycast_object, pos, dir, length, cb, ...)
	local num_raycasts = self._num_raycasts + 1
	self._raycast_queue[num_raycasts] = {
		raycast_object = raycast_object,
		pos = Vector3Box(pos),
		dir = Vector3Box(dir),
		length = length,
		cb = cb,
		...
	}
	self._num_raycasts = num_raycasts
end

GameModeManager._do_raycasts = function (self)
	local num_raycasts = self._num_raycasts

	if num_raycasts <= 0 then
		return
	end

	local raycast_queue = self._raycast_queue

	for i = 1, num_raycasts, 1 do
		local raycast_info = raycast_queue[i]
		local id = raycast_info.raycast_object:cast(raycast_info.pos:unbox(), raycast_info.dir:unbox(), raycast_info.length)
		self._async_raycast_handles[id] = raycast_info
	end

	table.clear(raycast_queue)

	self._num_raycasts = 0
end

GameModeManager._do_physics_callbacks = function (self)
	local num_callbacks = self._num_physics_safe_callbacks

	if num_callbacks > 0 then
		local safe_callbacks = self._physics_safe_callbacks

		for i = 1, num_callbacks, 1 do
			safe_callbacks[i]()
		end

		table.clear(safe_callbacks)

		self._num_physics_safe_callbacks = 0
	end
end

GameModeManager.game_mode_name = function (self)
	return self._game_mode:name()
end

GameModeManager.side_compositions = function (self)
	local game_mode_settings = self._game_mode:settings()
	local side_compositions = game_mode_settings.side_compositions

	return side_compositions
end

GameModeManager.default_player_side_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local default_player_side_name = game_mode_settings.default_player_side_name

	return default_player_side_name
end

GameModeManager.use_side_color = function (self)
	local game_mode_settings = self._game_mode:settings()
	local use_side_color = game_mode_settings.use_side_color

	return use_side_color
end

GameModeManager.force_third_person_mode = function (self)
	local game_mode_settings = self._game_mode:settings()
	local force_third_person_mode = game_mode_settings.force_third_person_mode

	return force_third_person_mode
end

GameModeManager.use_third_person_hub_camera = function (self)
	local game_mode_settings = self._game_mode:settings()
	local use_third_person_hub_camera = game_mode_settings.use_third_person_hub_camera

	return use_third_person_hub_camera
end

GameModeManager.use_hub_aim_extension = function (self)
	local game_mode_settings = self._game_mode:settings()
	local use_hub_aim_extension = game_mode_settings.use_hub_aim_extension

	return use_hub_aim_extension
end

GameModeManager.hud_settings = function (self)
	local game_mode_settings = self._game_mode:settings()
	local hud_settings = game_mode_settings.hud_settings

	return hud_settings
end

GameModeManager.hotkey_settings = function (self)
	local game_mode_settings = self._game_mode:settings()
	local hotkeys_settings = game_mode_settings.hotkeys

	return hotkeys_settings
end

GameModeManager.settings = function (self)
	return self._game_mode:settings()
end

GameModeManager.specializations_disabled = function (self)
	local game_mode_settings = self._game_mode:settings()

	return game_mode_settings.specializations_disabled or false
end

GameModeManager.presence_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local presence_name = game_mode_settings.presence_name

	return presence_name
end

GameModeManager.is_prologue = function (self)
	local game_mode_settings = self._game_mode:settings()
	local is_prologue = game_mode_settings.is_prologue

	return is_prologue
end

GameModeManager.is_locked_reserve_ammo = function (self)
	return self._gameplay_modifiers.ammo_locked
end

GameModeManager.default_wielded_slot_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local default_wielded_slot_name = game_mode_settings.default_wielded_slot_name or PlayerCharacterConstants.default_wielded_slot_name

	return default_wielded_slot_name
end

GameModeManager.starting_character_state_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local starting_character_state_name = game_mode_settings.starting_character_state_name

	return starting_character_state_name
end

GameModeManager.default_player_orientation = function (self)
	local game_mode_settings = self._game_mode:settings()
	local default_player_orientation = game_mode_settings.default_player_orientation

	return default_player_orientation
end

GameModeManager.use_foot_ik = function (self)
	local game_mode_settings = self._game_mode:settings()
	local use_foot_ik = not not game_mode_settings.use_foot_ik

	return use_foot_ik
end

GameModeManager.disable_hologram = function (self)
	local game_mode_settings = self._game_mode:settings()
	local disable_hologram = not not game_mode_settings.disable_hologram

	return disable_hologram
end

GameModeManager.is_vaulting_allowed = function (self)
	local game_mode_settings = self._game_mode:settings()

	return game_mode_settings.vaulting_allowed
end

GameModeManager.on_player_unit_spawn = function (self, player, is_respawn)
	if self._gameplay_modifiers.unkillable then
		local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

		health_extension:set_unkillable(true)
	end

	if self._gameplay_modifiers.invulnerable then
		local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

		health_extension:set_invulnerable(true)
	end

	self._game_mode:on_player_unit_spawn(player, is_respawn)
end

GameModeManager.on_player_unit_despawn = function (self, player)
	self._game_mode:on_player_unit_despawn(player)
end

GameModeManager.can_spawn_player = function (self, player)
	return self._game_mode:can_spawn_player(player)
end

GameModeManager.player_time_until_spawn = function (self, player)
	return self._game_mode:player_time_until_spawn(player)
end

GameModeManager.cleanup_game_mode_units = function (self)
	self._game_mode:cleanup_game_mode_units()
end

GameModeManager.should_spawn_dead = function (self, player)
	return self._game_mode:should_spawn_dead(player)
end

GameModeManager.update = function (self, dt, t)
	if self._is_server then
		local game_mode = self._game_mode

		game_mode:server_update(dt, t)

		if not self._end_conditions_met then
			local end_conditions_met, outcome = game_mode:evaluate_end_conditions()

			if end_conditions_met then
				self:_set_end_conditions_met(outcome)
			end
		end

		if GameParameters.testify then
			Testify:poll_requests_through_handler(GameModeManagerTestify, self)
		end
	end

	self:_do_raycasts()
	self:_do_physics_callbacks()
end

GameModeManager._set_end_conditions_met = function (self, outcome)
	self._end_conditions_met = true
	self._end_conditions_met_outcome = outcome

	if self._is_server then
		local session_id = (Managers.mission_server and Managers.mission_server._session_id) or nil

		Managers.mechanism:trigger_event("game_mode_end", outcome, session_id)

		local outcome_id = NetworkLookup.game_mode_outcomes[outcome]

		Managers.state.game_session:send_rpc_clients("rpc_game_mode_end_conditions_met", outcome_id)
	end
end

GameModeManager.rpc_game_mode_end_conditions_met = function (self, channel_id, outcome_id)
	local outcome = NetworkLookup.game_mode_outcomes[outcome_id]

	self:_set_end_conditions_met(outcome)
end

GameModeManager.complete_game_mode = function (self)
	if self._is_server then
		self._game_mode:complete()
	end
end

GameModeManager.fail_game_mode = function (self)
	if self._is_server then
		self._game_mode:fail()
	end
end

GameModeManager.end_conditions_met = function (self)
	return self._end_conditions_met
end

GameModeManager.end_conditions_met_outcome = function (self)
	return self._end_conditions_met_outcome
end

GameModeManager.has_met_end_conditions = function (self)
	return self._end_conditions_met, self._end_conditions_met_outcome
end

GameModeManager.hot_join_sync = function (self, sender, channel)
	self._game_mode:hot_join_sync(sender, channel)
end

return GameModeManager
