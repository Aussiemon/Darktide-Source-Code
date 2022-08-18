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
local MechanismBase = require("scripts/managers/mechanism/mechanisms/mechanism_base")
local StateExitToMainMenu = require("scripts/game_states/game/state_exit_to_main_menu")
local StateLoading = require("scripts/game_states/game/state_loading")
local Promise = require("scripts/foundation/utilities/promise")
local MechanismLeftSession = class("MechanismLeftSession", "MechanismBase")
local TIMEOUT = 10

MechanismLeftSession.init = function (self, ...)
	MechanismLeftSession.super.init(self, ...)

	local reason = self._context.left_session_reason

	fassert(reason, "left_session_reason missing in mechanism context")
	Log.info("MechanismLeftSession", "Entered with reason %s", reason)

	self._leave_party_promise = Promise.resolved()

	if reason == "exit_to_main_menu" then
		self._next_state = StateExitToMainMenu
	elseif reason == "leave_mission" then
		self:_leave_party()
	elseif reason == "lost_connection" then
		self._next_state = StateExitToMainMenu
	end

	if not DEDICATED_SERVER and self._context.session_was_booting then
		self._next_state = StateExitToMainMenu
	end
end

MechanismLeftSession._leave_party = function (self)
	self._leave_party_promise = Managers.party_immaterium:leave_party()
end

MechanismLeftSession.sync_data = function (self)
	ferror("Somebody joined you while in left session mechanism. This means you are hosting while in the left session mechanism.")
end

MechanismLeftSession.ready_for_game_score = function (self, peer_id, success)
	return
end

MechanismLeftSession.wanted_transition = function (self)
	if self._left_session_done then
		return false
	end

	if self._next_state then
		self._left_session_done = true

		return false, self._next_state, {}
	end

	if self._timeout_at then
		local t = Managers.time:time("main")

		if self._timeout_at < t then
			self._left_session_done = true

			return false, StateExitToMainMenu, {}
		end
	end

	local state = self._state

	if state == "init" then
		if GameParameters.prod_like_backend then
			self._leave_party_promise:next(function ()
				self._leave_party_done = true
			end):catch(function (error)
				self._leave_party_done = true
			end)
			self:_set_state("wait_for_session")

			local t = Managers.time:time("main")
			self._timeout_at = t + TIMEOUT

			return false, StateLoading, {}
		end
	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 68-69, warpins: 1 ---
		if state == "search_for_session" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 70-76, warpins: 1 ---
			local next_state, context = Managers.multiplayer_session:find_available_session()

			if next_state then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 77-84, warpins: 1 ---
				self._left_session_done = true

				return false, next_state, context
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 85-86, warpins: 1 ---
			if state == "wait_for_session" and self._leave_party_done then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 90-96, warpins: 1 ---
				local next_state, context = Managers.multiplayer_session:find_available_session()

				if next_state then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 97-103, warpins: 1 ---
					self._left_session_done = true

					return false, next_state, context
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end
		--- END OF BLOCK #0 ---



	end

	return false
end

MechanismLeftSession.is_allowed_to_reserve_slots = function (self, peer_ids)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	return false
	--- END OF BLOCK #0 ---



end

MechanismLeftSession.peers_reserved_slots = function (self, peer_ids)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-4, warpins: 1 ---
	ferror("Someone is connecting while we are leaving session. Problem?")

	return
	--- END OF BLOCK #0 ---



end

MechanismLeftSession.peer_freed_slot = function (self, peer_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-1, warpins: 1 ---
	return
	--- END OF BLOCK #0 ---



end

implements(MechanismLeftSession, MechanismBase.INTERFACE)

return MechanismLeftSession
