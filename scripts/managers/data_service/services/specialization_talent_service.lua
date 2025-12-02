-- chunkname: @scripts/managers/data_service/services/specialization_talent_service.lua

local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
local SpecializationTalentsService = class("SpecializationTalentsService")

SpecializationTalentsService.init = function (self, backend_interface)
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
		connection_manager:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
	end

	return extra_data
end

local function _set_specialization_talents_backend_response_fail(result)
	local errors = result and result.body and result.body.errors

	Log.error("SpecializationTalents", "couldn't set selected specialization_talents in backend")

	if errors then
		Log.error("SpecializationTalents", "Message: %s", table.tostring(errors, 5))
	end
end

SpecializationTalentsService.set_specialization_talents = function (self, player, layout, node_tiers)
	local character_id = player:character_id()
	local specialization_talents = TalentLayoutParser.pack_backend_data(layout, node_tiers)
	local backend = self._backend_interface.characters
	local promise = backend:set_specialization_talents(character_id, specialization_talents)

	promise:next(callback(_set_backend_response_success, player), _set_specialization_talents_backend_response_fail):catch(function (err)
		_set_specialization_talents_backend_response_fail(err)
	end)

	return promise
end

SpecializationTalentsService.load_icons_for_profile = function (self, profile, reference_name, callback, prioritize)
	local archetype = profile.archetype
	local specialization_talent_package_path = archetype.specialization_talent_package_path

	if specialization_talent_package_path then
		local load_id = Managers.package:load(specialization_talent_package_path, reference_name, callback, prioritize)

		return load_id
	end

	return nil
end

SpecializationTalentsService.release_icons = function (self, load_id)
	if load_id then
		Managers.package:release(load_id)
	end
end

return SpecializationTalentsService
