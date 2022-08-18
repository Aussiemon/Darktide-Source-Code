local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PlayerSpecializationUtil = require("scripts/utilities/player_specialization/player_specialization")
local TalentsService = class("TalentsService")

TalentsService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

local function _set_backend_response_success(player, extra_data)
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()
	local connection_manager = Managers.connection

	if connection_manager:is_host() then
		local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

		profile_synchronizer_host:profile_changed(peer_id, local_player_id)
	elseif connection_manager:is_client() then
		Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
	end

	return extra_data
end

local function _set_talents_backend_response_fail(error)
	Log.error("Talents", "couldn't set selected talents in backend")
end

TalentsService.set_talents = function (self, player, talent_names)
	local character_id = player:character_id()
	local profile = player:profile()

	PlayerSpecializationUtil.filter_nonselectable_talents(profile.archetype, profile.specialization, profile.current_level, talent_names)

	local talent_array = PlayerSpecializationUtil.talent_set_to_array(talent_names, {})
	local backend = self._backend_interface.characters
	local promise = backend:set_talents(character_id, talent_array)

	promise:next(callback(_set_backend_response_success, player, talent_names), _set_talents_backend_response_fail):catch(function (err)
		Log.error("Talents", "couldn't set selected talents in backend")
	end)

	return promise
end

local function _set_specialization_backend_response_fail(error)
	Log.error("Talents", "couldn't set selected talents in backend")
end

TalentsService.set_specialization = function (self, player, specialization)
	local backend = self._backend_interface.characters
	local character_id = player:character_id()
	local characters_promise = backend:set_specialization(character_id, specialization)

	characters_promise:next(callback(_set_backend_response_success, player, specialization), _set_specialization_backend_response_fail)
end

return TalentsService
