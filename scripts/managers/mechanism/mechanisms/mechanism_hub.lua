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
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local Missions = require("scripts/settings/mission/mission_templates")
local Promise = require("scripts/foundation/utilities/promise")
local StateGameplay = require("scripts/game_states/game/state_gameplay")
local StateLoading = require("scripts/game_states/game/state_loading")
local MechanismHub = class("MechanismHub", "MechanismBase")

MechanismHub.init = function (self, ...)
	MechanismHub.super.init(self, ...)

	local mission_name = "hub_ship"
	self._hub_mission_name = mission_name
	self._hub_level_name = Missions[mission_name].level
	self._hub_circumstance_name = "default"
	self._hub_config_request = false
	self._fetching_client_data = false
	self._last_auto_joined_game_session_id = nil
end

MechanismHub.sync_data = function (self)
	return
end

MechanismHub.client_exit_gameplay = function (self)
	self:_set_state("client_exit_gameplay")
end

MechanismHub.all_players_ready = function (self)
	return
end

local function _fetch_client_data()
	return Promise.all(Managers.data_service.path_of_trust:refresh())
end

MechanismHub.wanted_transition = function (self)
	local state = self._state

	if state == "init" then
		if DEDICATED_SERVER then
			self:_set_state("request_hub_config")

			return false, StateLoading, {}
		end

		if not self._fetching_client_data then
			if Managers.backend:authenticated() then
				self._client_data_promise = _fetch_client_data()

				self._client_data_promise:next(function ()
					self._client_data_promise = nil

					self:_set_state("request_hub_config")
				end):catch(function ()
					self._client_data_promise = nil

					self:_set_state("request_hub_config")
				end)
			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 38-41, warpins: 1 ---
				self:_set_state("request_hub_config")
				--- END OF BLOCK #0 ---



			end

			self._fetching_client_data = true

			return false, StateLoading, {}
		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 50-53, warpins: 1 ---
			return false
			--- END OF BLOCK #0 ---



		end
	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 54-55, warpins: 1 ---
		if state == "request_hub_config" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 56-58, warpins: 1 ---
			if not DEDICATED_SERVER or (GameParameters.circumstance and GameParameters.circumstance ~= "default") then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 67-76, warpins: 2 ---
				self._hub_circumstance_name = GameParameters.circumstance

				self:_set_state("init_hub")

				return false
				--- END OF BLOCK #0 ---



			end

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 77-79, warpins: 3 ---
			if not self._hub_config_request then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 80-86, warpins: 1 ---
				if Managers.backend:authenticated() then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 87-102, warpins: 1 ---
					Managers.backend.interfaces.hub_session:get_hub_config():next(function (config)

						-- Decompilation error in this vicinity:
						--- BLOCK #0 1-16, warpins: 1 ---
						Log.info("MechanismHub", "Loaded circumstance_name " .. config.circumstanceName)

						self._hub_circumstance_name = config.circumstanceName

						self:_set_state("init_hub")

						return
						--- END OF BLOCK #0 ---



					end):catch(function (error)

						-- Decompilation error in this vicinity:
						--- BLOCK #0 1-20, warpins: 1 ---
						Log.error("MechanismHub", "Could not load hub_config from backend, falling back to default circumstance_name, error=" .. table.tostring(error, 3))

						self._hub_circumstance_name = "default"

						self:_set_state("init_hub")

						return
						--- END OF BLOCK #0 ---



					end)
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 103-113, warpins: 1 ---
					Log.error("MechanismHub", "Could not load hub_config from backend, not authenticated, falling back to default circumstance_name")

					self._hub_circumstance_name = "default"

					self:_set_state("init_hub")
					--- END OF BLOCK #0 ---



				end

				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 114-115, warpins: 2 ---
				self._hub_config_request = true
				--- END OF BLOCK #1 ---



			end

			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 116-119, warpins: 2 ---
			return false
			--- END OF BLOCK #2 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 120-121, warpins: 1 ---
			if state == "init_hub" then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 122-162, warpins: 1 ---
				self:_set_state("in_hub")

				local challenge = DevParameters.challenge
				local resistance = DevParameters.resistance
				local side_mission = GameParameters.side_mission

				Log.info("MechanismHub", "Using dev parameters for challenge and resistance (%s/%s)", challenge, resistance)

				local mechanism_data = {}
				mechanism_data.challenge = challenge
				mechanism_data.resistance = resistance
				mechanism_data.circumstance_name = self._hub_circumstance_name
				mechanism_data.side_mission = side_mission

				return false, StateLoading, {
					level = self._hub_level_name,
					mission_name = self._hub_mission_name,
					circumstance_name = self._hub_circumstance_name,
					side_mission = side_mission,
					next_state = StateGameplay,
					next_state_params = {
						mechanism_data = mechanism_data
					}
				}
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 163-164, warpins: 1 ---
				if state == "in_hub" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 165-168, warpins: 1 ---
					if Managers.party_immaterium and Managers.party_immaterium:game_session_in_progress() then

						-- Decompilation error in this vicinity:
						--- BLOCK #0 176-183, warpins: 1 ---
						local game_session_id = Managers.party_immaterium:current_game_session_id()

						if self._last_auto_joined_game_session_id ~= game_session_id then

							-- Decompilation error in this vicinity:
							--- BLOCK #0 184-188, warpins: 1 ---
							self._last_auto_joined_game_session_id = game_session_id

							self:_retry_join()
							--- END OF BLOCK #0 ---



						else

							-- Decompilation error in this vicinity:
							--- BLOCK #0 189-191, warpins: 1 ---
							if not self._retry_popup_id then

								-- Decompilation error in this vicinity:
								--- BLOCK #0 192-194, warpins: 1 ---
								self:_show_retry_popup()
								--- END OF BLOCK #0 ---



							end
							--- END OF BLOCK #0 ---



						end

						--- END OF BLOCK #0 ---

						FLOW; TARGET BLOCK #1



						-- Decompilation error in this vicinity:
						--- BLOCK #1 195-197, warpins: 3 ---
						return false
						--- END OF BLOCK #1 ---



					end

					--- END OF BLOCK #0 ---

					FLOW; TARGET BLOCK #1



					-- Decompilation error in this vicinity:
					--- BLOCK #1 198-201, warpins: 3 ---
					return false
					--- END OF BLOCK #1 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 202-203, warpins: 1 ---
					if state == "joining_party_game_session" then

						-- Decompilation error in this vicinity:
						--- BLOCK #0 204-209, warpins: 1 ---
						if self._joining_party_game_session:is_dead() then

							-- Decompilation error in this vicinity:
							--- BLOCK #0 210-215, warpins: 1 ---
							self:_set_state("in_hub")

							self._joining_party_game_session = nil
							--- END OF BLOCK #0 ---



						end

						--- END OF BLOCK #0 ---

						FLOW; TARGET BLOCK #1



						-- Decompilation error in this vicinity:
						--- BLOCK #1 216-219, warpins: 2 ---
						return false
						--- END OF BLOCK #1 ---



					else

						-- Decompilation error in this vicinity:
						--- BLOCK #0 220-221, warpins: 1 ---
						if state == "client_exit_gameplay" then

							-- Decompilation error in this vicinity:
							--- BLOCK #0 222-231, warpins: 1 ---
							self:_set_state("client_wait_for_server")

							return false, StateLoading, {}
							--- END OF BLOCK #0 ---



						else

							-- Decompilation error in this vicinity:
							--- BLOCK #0 232-233, warpins: 1 ---
							if state == "client_wait_for_server" then

								-- Decompilation error in this vicinity:
								--- BLOCK #0 234-236, warpins: 1 ---
								return false
								--- END OF BLOCK #0 ---



							end
							--- END OF BLOCK #0 ---



						end
						--- END OF BLOCK #0 ---



					end
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end
end

MechanismHub._retry_join = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._state == "in_hub" and Managers.party_immaterium:game_session_in_progress() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 11-20, warpins: 1 ---
		self._joining_party_game_session = Managers.party_immaterium:join_game_session()

		self:_set_state("joining_party_game_session")
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 21-21, warpins: 3 ---
	return
	--- END OF BLOCK #1 ---



end

MechanismHub._show_retry_popup = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-21, warpins: 1 ---
	local context = {
		title_text = "loc_popup_header_reconnect_to_session",
		description_text = "loc_popup_description_reconnect_to_session"
	}
	context.options = {
		{
			text = "loc_popup_reconnect_to_session_reconnect_button",
			close_on_pressed = true,
			hotkey = "confirm_pressed",
			callback = function ()

				-- Decompilation error in this vicinity:
				--- BLOCK #0 1-8, warpins: 1 ---
				self._retry_popup_id = nil

				self:_retry_join()

				return
				--- END OF BLOCK #0 ---



			end
		},
		{
			text = "loc_popup_reconnect_to_session_leave_button",
			close_on_pressed = true,
			hotkey = "back",
			callback = function ()

				-- Decompilation error in this vicinity:
				--- BLOCK #0 1-9, warpins: 1 ---
				self._retry_popup_id = nil

				Managers.party_immaterium:leave_party()

				return
				--- END OF BLOCK #0 ---



			end
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		self._retry_popup_id = id

		return
		--- END OF BLOCK #0 ---



	end)

	return
	--- END OF BLOCK #0 ---



end

MechanismHub.is_allowed_to_reserve_slots = function (self, peer_ids)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return true
	--- END OF BLOCK #0 ---



end

MechanismHub.peers_reserved_slots = function (self, peer_ids)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MechanismHub.peer_freed_slot = function (self, peer_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

MechanismHub.destroy = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	if self._client_data_promise and self._client_data_promise:is_pending() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 10-15, warpins: 1 ---
		self._client_data_promise:cancel()

		self._client_data_promise = nil
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 16-18, warpins: 3 ---
	self._joining_party_game_session = nil

	return
	--- END OF BLOCK #1 ---



end

implements(MechanismHub, MechanismBase.INTERFACE)

return MechanismHub
