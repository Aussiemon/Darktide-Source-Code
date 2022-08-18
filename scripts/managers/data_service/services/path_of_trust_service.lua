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
		self._last_finished_scene = value and tonumber(value) or #path_config + 1
	end):catch(function (_)
		self._last_finished_scene = #path_config + 1
	end)
end

PathOfTrustService.get_scene_name = function (self)
	local next_scene = self._last_finished_scene + 1
	local has_next_scene = path_config[next_scene] ~= nil

	if not has_next_scene then
		return "none"
	end

	local next_scene_unlocked = path_config[next_scene].level <= _get_player_level()

	if not next_scene_unlocked then
		return "none"
	end

	return path_config[next_scene].name
end

PathOfTrustService.complete_scene = function (self)
	if self:get_scene_name() == "none" then
		return false
	end

	local next_scene = self._last_finished_scene + 1

	self._backend_interface.characters:set_last_seen_path_of_trust(_get_character_id(), next_scene):catch(function (error)
		Log.error("Path of Trust Service", "complete_scene failed to write last finished scene to backend: %s", table.tostring(error, 3))
	end)

	self._last_finished_scene = next_scene

	return true
end

return PathOfTrustService
