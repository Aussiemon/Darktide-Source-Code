-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
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
	Managers.presence:set_presence("main_menu")
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

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-8, warpins: 1 ---
	local main_menu_loader = self._main_menu_loader
	local backend_answered = self._backend_answered
	local profiles_data = self._profiles_data

	if not main_menu_loader:is_loading_done() or not backend_answered then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-12, warpins: 2 ---
		return false
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 13-16, warpins: 2 ---
	if self._next_state == StateMainMenu then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 17-18, warpins: 1 ---
		if profiles_data then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 19-27, warpins: 1 ---
			local next_state_params = self._next_state_params
			next_state_params.main_menu_loader = main_menu_loader
			next_state_params.profiles = profiles_data.profiles
			next_state_params.selected_profile = profiles_data.selected_profile
			next_state_params.has_created_first_character = true
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 28-31, warpins: 1 ---
			self._next_state = StateError
			self._next_state_params = {}
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 32-35, warpins: 3 ---
	local unload_main_menu_loader = self._next_state ~= StateMainMenu

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 39-40, warpins: 2 ---
	if unload_main_menu_loader then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 41-43, warpins: 1 ---
		main_menu_loader:delete()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 44-51, warpins: 2 ---
	self._backend_answered = nil
	self._main_menu_loader = nil
	self._profiles_data = nil

	return true
	--- END OF BLOCK #4 ---



end

StateExitToMainMenu.update = function (self, main_dt, main_t)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-19, warpins: 1 ---
	local context = self._creation_context

	context.network_receive_function(main_dt)
	Managers.player:state_update(main_dt, main_t)

	local next_state, next_state_params = Managers.mechanism:wanted_transition()

	if next_state == StateExitToMainMenu then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 20-24, warpins: 1 ---
		self._next_state = StateMainMenu
		self._next_state_params = {}
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 25-26, warpins: 1 ---
		if next_state then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 27-28, warpins: 1 ---
			self._next_state = next_state
			self._next_state_params = next_state_params
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 29-35, warpins: 3 ---
	context.network_transmit_function()

	local loading_done = self:_update_loading()

	if loading_done then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 36-38, warpins: 1 ---
		return self._next_state, self._next_state_params
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 39-39, warpins: 2 ---
	return
	--- END OF BLOCK #2 ---



end

StateExitToMainMenu.on_exit = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	Managers.player:on_game_state_exit(self)

	return
	--- END OF BLOCK #0 ---



end

return StateExitToMainMenu
