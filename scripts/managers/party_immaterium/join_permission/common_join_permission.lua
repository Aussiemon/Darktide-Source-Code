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
local Promise = require("scripts/foundation/utilities/promise")
local PrivilegesManager = require("scripts/managers/privileges/privileges_manager")
local CommonJoinPermission = {
	test_play_mutliplayer_permission = function (account_id, platform, platform_user_id, context_suffix)
		local privileges_manager = PrivilegesManager:new()
		local blocked_check = Managers.data_service.social:is_account_blocked(account_id):catch(function (error)
			Log.error("CommonJoinPermission", "could not check if player was blocked, error=" .. table.tostring(error, 4))

			return Promise.resolved()
		end):next(function (is_blocked)
			if is_blocked then
				return Promise.rejected("BLOCKED" .. context_suffix)
			else
				return Promise.resolved()
			end
		end)
		local cross_play_check = nil

		if platform ~= Managers.presence:presence_entry_myself():platform() then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 31-39, warpins: 1 ---
			cross_play_check = privileges_manager:cross_play():catch(function (error)

				-- Decompilation error in this vicinity:
				--- BLOCK #0 1-3, warpins: 1 ---
				if error.message == "OK" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 4-10, warpins: 1 ---
					return Promise.rejected("CROSS_PLAY_DISABLED" .. context_suffix)
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 11-24, warpins: 1 ---
					Log.error("CommonJoinPermission", "unkown privileges error for cross-play " .. table.tostring(error, 3))

					return Promise.resolved()
					--- END OF BLOCK #0 ---



				end

				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 25-25, warpins: 2 ---
				return
				--- END OF BLOCK #1 ---



			end)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 40-43, warpins: 1 ---
			cross_play_check = Promise.resolved()
			--- END OF BLOCK #0 ---



		end

		return Promise.all(blocked_check, cross_play_check):next(function (results)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-4, warpins: 1 ---
			return Promise.resolved("OK")
			--- END OF BLOCK #0 ---



		end):catch(function (errors)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-4, warpins: 1 ---
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 5-12, warpins: 0 ---
			for i = 1, #errors, 1 do

				-- Decompilation error in this vicinity:
				--- BLOCK #0 5-7, warpins: 2 ---
				if errors[i] then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 8-11, warpins: 1 ---
					return Promise.rejected(errors[i])
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 12-12, warpins: 2 ---
				--- END OF BLOCK #1 ---



			end

			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 13-13, warpins: 1 ---
			return
			--- END OF BLOCK #2 ---



		end)
	end
}

return CommonJoinPermission
