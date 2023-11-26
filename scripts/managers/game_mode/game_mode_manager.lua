-- chunkname: @scripts/managers/game_mode/game_mode_manager.lua

local GameModeBase = require("scripts/managers/game_mode/game_modes/game_mode_base")
local GameModeManagerTestify = GameParameters.testify and require("scripts/managers/game_mode/game_mode_manager_testify")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
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
		for i = 1, #gameplay_modifiers do
			self._gameplay_modifiers[gameplay_modifiers[i]] = true
		end
	end

	if not self._is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	self._num_raycasts_this_frame = 0
	self._raycast_queue_head = 0
	self._raycast_queue_tail = 0
	self._raycast_queue = Script.new_map(64)
	self._raycast_data = Script.new_array(4)
	self._async_raycast_handles = {}
	self._raycast_callback = callback(self, "_async_raycast_result_cb")
	self._num_physics_safe_callbacks = 0
	self._physics_safe_callbacks = {}
	self._run_single_threaded_physics = false
	self._wants_single_threaded_physics = {}
end

GameModeManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	self._game_mode:destroy()
end

GameModeManager.set_wants_single_threaded_physics = function (self, single_threaded, reason)
	Log.info("GameModeManager", "set_wants_single_threaded_physics single_threaded %s, reason: %s ", tostring(single_threaded), tostring(reason))

	self._wants_single_threaded_physics[reason] = single_threaded and single_threaded or nil
end

GameModeManager._set_single_threaded_physics = function (self, single_threaded)
	self._run_single_threaded_physics = single_threaded
end

GameModeManager.wants_single_threaded_physics = function (self)
	return next(self._wants_single_threaded_physics) ~= nil
end

GameModeManager.run_single_threaded_physics = function (self)
	return self._run_single_threaded_physics
end

GameModeManager.register_physics_safe_callback = function (self, cb)
	local index = self._num_physics_safe_callbacks + 1

	self._physics_safe_callbacks[index] = cb
	self._num_physics_safe_callbacks = index
end

GameModeManager._async_raycast_result_cb = function (self, id, hits, num_hits)
	local queue = self._raycast_queue
	local index = self._async_raycast_handles[id]
	local cb = queue[index - 1]
	local num_args = queue[index - 2]
	local data_buffer = self._raycast_data

	queue[index - 1] = nil
	queue[index - 2] = nil
	index = index - 2

	for ii = 1, num_args do
		local jj = index - ii

		data_buffer[ii] = queue[jj]
		queue[jj] = nil
	end

	cb(id, hits, num_hits, data_buffer)
	table.clear(data_buffer)

	self._async_raycast_handles[id] = nil
end

GameModeManager.create_safe_raycast_object = function (self, ...)
	return PhysicsWorld.make_raycast(self._physics_world, self._raycast_callback, ...)
end

GameModeManager.add_safe_raycast = function (self, raycast_object, pos, dir, length, cb, ...)
	local queue = self._raycast_queue
	local tail = self._raycast_queue_tail
	local num_args = select("#", ...)

	queue[tail - 1] = raycast_object
	queue[tail - 2], queue[tail - 3], queue[tail - 4] = Vector3.to_elements(pos)
	queue[tail - 5], queue[tail - 6], queue[tail - 7] = Vector3.to_elements(dir)
	queue[tail - 8] = length
	queue[tail - 9] = cb
	queue[tail - 10] = num_args
	tail = tail - 10

	for ii = 1, num_args do
		queue[tail - ii] = select(ii, ...)
	end

	self._raycast_queue_tail = tail - num_args
	self._num_raycasts_this_frame = self._num_raycasts_this_frame + 1
end

GameModeManager._do_raycasts = function (self)
	local num_raycasts = self._num_raycasts_this_frame

	if num_raycasts <= 0 then
		return
	end

	local queue = self._raycast_queue
	local head = self._raycast_queue_head

	for _ = 1, num_raycasts do
		local raycast_object = queue[head - 1]
		local raycast_pos = Vector3(queue[head - 2], queue[head - 3], queue[head - 4])
		local raycast_dir = Vector3(queue[head - 5], queue[head - 6], queue[head - 7])
		local length = queue[head - 8]
		local id = raycast_object:cast(raycast_pos, raycast_dir, length)

		self._async_raycast_handles[id] = head - 8

		for ii = head - 1, head - 8, -1 do
			queue[ii] = nil
		end

		head = head - 10 - queue[head - 10]
	end

	self._raycast_queue_head = head
	self._num_raycasts_this_frame = 0
end

GameModeManager._do_physics_callbacks = function (self)
	local num_callbacks = self._num_physics_safe_callbacks

	if num_callbacks > 0 then
		local safe_callbacks = self._physics_safe_callbacks

		for ii = 1, num_callbacks do
			safe_callbacks[ii]()
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

	return not not game_mode_settings.specializations_disabled
end

GameModeManager.presence_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local presence_name = game_mode_settings.presence_name

	return presence_name
end

GameModeManager.is_prologue = function (self)
	local game_mode_settings = self._game_mode:settings()
	local is_prologue = not not game_mode_settings.is_prologue

	return is_prologue
end

GameModeManager.is_social_hub = function (self)
	local game_mode_settings = self._game_mode:settings()

	return not not game_mode_settings.is_social_hub
end

GameModeManager.infinite_ammo_reserve = function (self)
	return self._gameplay_modifiers.infinite_ammo_reserve
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

GameModeManager.on_player_unit_spawn = function (self, player, player_unit, is_respawn)
	if self._gameplay_modifiers.unkillable then
		local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

		health_extension:set_unkillable(true)
	end

	if self._gameplay_modifiers.invulnerable then
		local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

		health_extension:set_invulnerable(true)
	end

	self._game_mode:on_player_unit_spawn(player, player_unit, is_respawn)
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

GameModeManager.game_mode_ready = function (self)
	local game_mode = self._game_mode

	if game_mode.game_mode_ready then
		local game_mode_ready = game_mode:game_mode_ready()

		return game_mode_ready
	end

	return true
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
	else
		self._game_mode:client_update(dt, t)
	end

	self:_do_raycasts()
	self:_do_physics_callbacks()
end

GameModeManager._set_end_conditions_met = function (self, outcome)
	self._end_conditions_met = true
	self._end_conditions_met_outcome = outcome

	if self._is_server then
		local session_id = Managers.mission_server and Managers.mission_server._session_id or nil

		Managers.mechanism:trigger_event("game_mode_end", outcome, session_id)

		local outcome_id = NetworkLookup.game_mode_outcomes[outcome]

		Managers.state.game_session:send_rpc_clients("rpc_game_mode_end_conditions_met", outcome_id)
	end
end

GameModeManager.rpc_game_mode_end_conditions_met = function (self, channel_id, outcome_id)
	local outcome = NetworkLookup.game_mode_outcomes[outcome_id]

	self:_set_end_conditions_met(outcome)
end

GameModeManager.complete_game_mode = function (self, triggered_from_flow)
	if self._is_server then
		self._game_mode:complete(triggered_from_flow)
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

GameModeManager.game_mode_state = function (self)
	return self._game_mode:state()
end

GameModeManager.mission_outro_played = function (self)
	local game_mode = self._game_mode
	local state = self._game_mode:state()

	if state == "done" then
		return true
	end

	if state == "outro_cinematic" and not Managers.state.cinematic:active() then
		return true
	end

	if game_mode.mission_outro_played then
		return true
	end
end

GameModeManager.set_init_scenario = function (self, scenario_alias, scenario_name)
	local game_mode = self._game_mode

	if game_mode.set_init_scenario then
		game_mode:set_init_scenario(scenario_alias, scenario_name)
	end
end

GameModeManager.player_unit_template_name = function (self)
	local game_mode_settings = self._game_mode:settings()
	local template_name = game_mode_settings.player_unit_template_name_override or "player_character"

	return template_name
end

return GameModeManager
