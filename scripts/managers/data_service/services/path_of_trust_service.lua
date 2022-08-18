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
local path_config = require("scripts/settings/story/path_of_trust_requirements")
local Promise = require("scripts/foundation/utilities/promise")
local PathOfTrustService = class("PathOfTrustService")

local function _get_player_level()
	local player_id = 1
	local player = Managers.player:local_player(player_id)
	local player_profile = player:profile()

	return player_profile.current_level
end

local function _get_character_id()
	local player_id = 1
	local player = Managers.player:local_player(player_id)
	local player_profile = player:profile()

	return player_profile.character_id
end

PathOfTrustService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._last_finished_scene = 0
end

PathOfTrustService.refresh = function (self)
	local character_id = _get_character_id()
	local is_placeholder_character = type(character_id) == "number"

	if is_placeholder_character then
		self._last_finished_scene = #path_config + 1

		return Promise.resolved()
	end

	return self._backend_interface.characters:get_last_seen_path_of_trust(character_id):next(function (value)
		self._last_finished_scene = (value and tonumber(value)) or #path_config + 1
	end):catch(function (_)
		self._last_finished_scene = #path_config + 1
	end)
end

PathOfTrustService.get_scene_name = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local next_scene = self._last_finished_scene + 1
	local has_next_scene = path_config[next_scene] ~= nil

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 10-11, warpins: 2 ---
	if not has_next_scene then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 12-13, warpins: 1 ---
		return "none"
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 14-20, warpins: 2 ---
	local next_scene_unlocked = path_config[next_scene].level <= _get_player_level()

	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 24-25, warpins: 2 ---
	if not next_scene_unlocked then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 26-27, warpins: 1 ---
		return "none"
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 28-31, warpins: 2 ---
	return path_config[next_scene].name
	--- END OF BLOCK #4 ---



end

PathOfTrustService.complete_scene = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	if self:get_scene_name() == "none" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 6-7, warpins: 1 ---
		return false
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-25, warpins: 1 ---
	local next_scene = self._last_finished_scene + 1

	self._backend_interface.characters:set_last_seen_path_of_trust(_get_character_id(), next_scene):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-11, warpins: 1 ---
		Log.error("Path of Trust Service", "complete_scene failed to write last finished scene to backend: %s", table.tostring(error, 3))

		return
		--- END OF BLOCK #0 ---



	end)

	self._last_finished_scene = next_scene

	return true
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 26-26, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

return PathOfTrustService
