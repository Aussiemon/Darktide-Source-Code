-- chunkname: @scripts/game_states/game/state_exit_to_main_menu.lua

local MainMenuLoader = require("scripts/loading/loaders/main_menu_loader")
local StateMainMenu = require("scripts/game_states/game/state_main_menu")
local StateError = require("scripts/game_states/game/state_error")
local StateExitToMainMenu = class("StateExitToMainMenu")

StateExitToMainMenu.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	self._next_state = StateMainMenu
	self._next_state_params = {}
	self._backend_answered = nil
	self._profile_data = nil

	local player_game_state_mapping = {}
	local game_state_context = {}

	Managers.player:on_game_state_enter(self, player_game_state_mapping, game_state_context)
	self:_start_loading()
end

StateExitToMainMenu._start_loading = function (self)
	local main_menu_loader = MainMenuLoader:new()

	main_menu_loader:start_loading()

	self._main_menu_loader = main_menu_loader

	Managers.data_service.profiles:fetch_all_profiles():next(function (profile_data)
		self._backend_answered = true
		self._profiles_data = profile_data
	end):catch(function (error)
		self._backend_answered = true
	end)
end

StateExitToMainMenu._update_loading = function (self)
	local main_menu_loader = self._main_menu_loader
	local backend_answered = self._backend_answered
	local profiles_data = self._profiles_data
	local main_menu_loader_done = main_menu_loader:is_loading_done()

	if not main_menu_loader_done then
		-- Nothing
	end

	if not backend_answered then
		-- Nothing
	end

	if not main_menu_loader_done or not backend_answered then
		return false
	end

	if self._next_state == StateMainMenu then
		if profiles_data then
			local next_state_params = self._next_state_params

			next_state_params.main_menu_loader = main_menu_loader
			next_state_params.profiles = profiles_data.profiles
			next_state_params.gear = profiles_data.gear
			next_state_params.selected_profile = profiles_data.selected_profile
			next_state_params.has_created_first_character = true
		else
			self._next_state = StateError
			self._next_state_params = {}
		end
	end

	local unload_main_menu_loader = self._next_state ~= StateMainMenu

	if unload_main_menu_loader then
		main_menu_loader:delete()
	end

	self._backend_answered = nil
	self._main_menu_loader = nil
	self._profiles_data = nil

	return true
end

StateExitToMainMenu.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	Managers.player:state_update(main_dt, main_t)

	local next_state, next_state_params = Managers.mechanism:wanted_transition()

	if next_state == StateExitToMainMenu then
		self._next_state = StateMainMenu
		self._next_state_params = {}
	elseif next_state then
		self._next_state = next_state
		self._next_state_params = next_state_params
	end

	context.network_transmit_function()

	local loading_done = self:_update_loading()

	if loading_done then
		return self._next_state, self._next_state_params
	end
end

StateExitToMainMenu.on_exit = function (self)
	Managers.player:on_game_state_exit(self)
end

return StateExitToMainMenu
