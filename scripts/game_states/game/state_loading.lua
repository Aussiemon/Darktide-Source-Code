-- chunkname: @scripts/game_states/game/state_loading.lua

local LoadingStateData = require("scripts/ui/loading_state_data")
local LoadMissionError = require("scripts/managers/error/errors/load_mission_error")
local Missions = require("scripts/settings/mission/mission_templates")

local function _info(...)
	Log.info("StateLoading", ...)
end

local StateLoading = class("StateLoading")
local STATES = table.enum("waiting_for_network", "waiting_for_despawn", "loading")
local LOADING_STATES = table.enum("loading_global_packages", "loading_mission")

StateLoading.init = function (self)
	self._creation_context = nil
	self._state = nil
	self._loading_state = nil
	self._failed_clients = nil
	self._needs_load_level = false
	self._level_name = nil
	self._mission_name = nil
	self._circumstance_name = nil
	self._side_mission = nil
	self._next_state = nil
	self._next_state_params = nil
end

StateLoading.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context

	Managers.connection:network_event_delegate():clean_session_events()
	self:_setup_loading_data(params)
	Managers.event:trigger("event_loading_started")

	self._wait_for_despawn = params.wait_for_despawn

	if Managers.multiplayer_session:is_ready() then
		if self._wait_for_despawn then
			self._state = STATES.waiting_for_despawn

			Log.info("StateLoading", "waiting_for_despawn")
		else
			self._state = STATES.loading

			self:_start_loading()
		end
	else
		self._state = STATES.waiting_for_network
	end

	self._failed_clients = {}

	local player_game_state_mapping = {}
	local game_state_context = {
		mission_name = params.mission_name,
		mission_giver_vo = params.mission_giver_vo or "none",
	}

	Managers.player:on_game_state_enter(self, player_game_state_mapping, game_state_context)
	Managers.event:register(self, "on_pre_suspend", "_on_pre_suspend")
end

StateLoading._start_loading_mission = function (self)
	_info("[_start_loading] needs_load_level(%s), mission_name(%s), circumstance_name(%s), side_mission(%s)", self._needs_load_level, self._mission_name, self._circumstance_name, self._side_mission)

	if self._needs_load_level then
		Managers.loading:load_mission(self._mission_name, self._level_name, self._circumstance_name)
		Managers.event:trigger("event_loading_resources_started", self._mission_name)
	else
		Managers.loading:no_level_needed()
	end
end

StateLoading._start_loading = function (self)
	if self:_global_packages_loaded() then
		self:_start_loading_mission()

		self._loading_state = LOADING_STATES.loading_mission
	else
		self:_load_global_packages()

		self._loading_state = LOADING_STATES.loading_global_packages
	end
end

StateLoading._setup_loading_data = function (self, params)
	if LEVEL_EDITOR_TEST then
		self._level_name = params.level
	end

	self._mission_name = params.mission_name
	self._circumstance_name = params.circumstance_name
	self._side_mission = params.side_mission
	self._needs_load_level = params.next_state and params.next_state.NEEDS_MISSION_LEVEL
	self._mission_giver_vo = params.mission_giver_vo or "none"
	self._next_state = params.next_state
	self._next_state_params = params.next_state_params
end

StateLoading._reset_player_game_state = function (self, mission_name, mission_giver_vo)
	Managers.player:on_game_state_exit(self)

	local player_game_state_mapping = {}
	local game_state_context = {
		mission_name = mission_name,
		mission_giver_vo = mission_giver_vo or "none",
	}

	Managers.player:on_game_state_enter(self, player_game_state_mapping, game_state_context)
	Log.info("StateLoading", "Resetting player game state. New game_state_context: %s", table.tostring(game_state_context))
end

StateLoading.on_exit = function (self)
	Managers.localization:reset_cache()
	Managers.player:on_game_state_exit(self)
	Managers.event:unregister(self, "on_pre_suspend")
end

StateLoading._reset_state_loading = function (self, params)
	if self._needs_load_level then
		Managers.loading:stop_load_mission()
	end

	self:_setup_loading_data(params)
	self:_start_loading()

	local mission_name = params.mission_name

	self:_reset_player_game_state(mission_name, params.mission_giver_vo)
end

StateLoading.update = function (self, main_dt, main_t)
	Managers.event:trigger("event_set_waiting_state", LoadingStateData.WAIT_REASON.read_disk)

	local context = self._creation_context

	context.network_receive_function(main_dt)
	Managers.player:state_update(main_dt, main_t)
	self:_detect_load_fail()

	if not DEDICATED_SERVER then
		local error_state, error_state_params = Managers.error:wanted_transition()

		if error_state then
			Managers.loading:cleanup()

			return error_state, error_state_params
		elseif IS_XBS or IS_GDK or IS_PLAYSTATION then
			local error_state, error_state_params = Managers.account:wanted_transition()

			if error_state then
				Managers.loading:cleanup()

				return error_state, error_state_params
			end
		end
	end

	local new_state, params

	if self._state == STATES.waiting_for_network then
		if Managers.multiplayer_session:is_ready() then
			if self._wait_for_despawn then
				self._state = STATES.waiting_for_despawn

				Log.info("StateLoading", "waiting_for_despawn")
			else
				self._state = STATES.loading

				self:_start_loading()
			end
		elseif Managers.multiplayer_session:is_stranded() then
			new_state, params = Managers.multiplayer_session:error_transition()

			Log.info("StateLoading", "### is_stranded ###")

			if new_state == StateLoading then
				self:_reset_state_loading(params)

				new_state = nil
				params = nil
			end
		end
	elseif self._state == STATES.waiting_for_despawn then
		local despawning = Managers.world_level_despawn:despawning()
		local despawn_done = not despawning

		if despawn_done then
			self._state = STATES.loading

			self:_start_loading()
			Log.info("StateLoading", "despawn_done")
		else
			Log.info("StateLoading", "waiting for despawn")
		end
	elseif self._state == STATES.loading then
		new_state, params = Managers.mechanism:wanted_transition()

		if new_state == StateLoading then
			self:_reset_state_loading(params)

			new_state = nil
			params = nil
		elseif new_state then
			if self._needs_load_level then
				Managers.loading:stop_load_mission()
			end

			self._level_name = nil
			self._mission_name = params.mission_name
			self._needs_load_level = new_state.NEEDS_MISSION_LEVEL
			self._next_state = new_state
			self._next_state_params = params

			self:_start_loading()

			new_state = nil
			params = nil
		elseif self._next_state then
			local load_done

			load_done, params = self:_update_loading(main_dt)

			if load_done then
				new_state = self._next_state
			end
		end
	else
		ferror("Invalid state %q", self._state)
	end

	context.network_transmit_function()

	return new_state, params
end

StateLoading._detect_load_fail = function (self)
	local loading_manager = Managers.loading

	if loading_manager:is_host() then
		local failed_clients = self._failed_clients

		table.clear(failed_clients)
		loading_manager:failed_clients(failed_clients)

		for i = 1, #failed_clients do
			Managers.connection:disconnect(failed_clients[i])
		end
	elseif loading_manager:is_client() and loading_manager:failed() then
		local mission_name = loading_manager:mission()

		Managers.error:report_error(LoadMissionError:new(mission_name))
	end
end

StateLoading._load_global_packages = function (self)
	if not GLOBAL_RESOURCES.loaded then
		local package_manager = Managers.package

		for i = 1, #GLOBAL_RESOURCES do
			local package_name = GLOBAL_RESOURCES[i]

			if not package_manager:is_loading(package_name) and not package_manager:has_loaded(package_name) then
				package_manager:load(package_name, "global", nil, true)
			end
		end
	end
end

StateLoading._global_packages_loaded = function (self)
	if GLOBAL_RESOURCES.loaded then
		return true
	end

	local package_manager = Managers.package

	for i = 1, #GLOBAL_RESOURCES do
		local package_name = GLOBAL_RESOURCES[i]

		if not package_manager:has_loaded(package_name) then
			return false
		end
	end

	GLOBAL_RESOURCES.loaded = true

	return GLOBAL_RESOURCES.loaded
end

StateLoading._update_loading = function (self)
	if self._loading_state == LOADING_STATES.loading_global_packages and self:_global_packages_loaded() then
		self:_start_loading_mission()

		self._loading_state = LOADING_STATES.loading_mission
	end

	if self._loading_state == LOADING_STATES.loading_mission then
		local loading_manager = Managers.loading

		if self:_global_packages_loaded() and loading_manager:load_finished() then
			local is_host = loading_manager:is_host()
			local parameters = {}

			parameters.level_name = self:_current_level()
			parameters.mission_name = self._mission_name
			parameters.is_host = is_host
			parameters.spawn_group_id = loading_manager:spawn_group_id()

			if self._needs_load_level then
				local world, level, themes, world_name = loading_manager:take_ownership_of_level()

				parameters.world = world
				parameters.level = level
				parameters.themes = themes
				parameters.world_name = world_name
			end

			if self._next_state_params then
				table.merge(parameters, self._next_state_params)
			end

			return true, parameters
		end
	end
end

StateLoading._current_level = function (self)
	if LEVEL_EDITOR_TEST then
		return self._level_name
	elseif self._mission_name then
		local mission_name = self._mission_name

		return Missions[mission_name].level
	end
end

StateLoading._on_pre_suspend = function (self)
	Managers.loading:cleanup()
end

return StateLoading
