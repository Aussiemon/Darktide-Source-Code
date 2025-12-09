-- chunkname: @scripts/managers/data_service/services/talents_service.lua

local TalentLayoutParser = require("scripts/ui/views/talent_builder_view/utilities/talent_layout_parser")
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
		connection_manager:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
	end

	return extra_data
end

local function _set_talents_backend_response_fail(result)
	local errors = result and result.body and result.body.errors

	Log.error("Talents", "couldn't set selected talents in backend")

	if errors then
		Log.error("Talents", "Message: %s", table.tostring(errors, 5))
	end
end

TalentsService.set_talents_v2 = function (self, player, talent_info, specialization_talent_info)
	if talent_info then
		talent_info.packed_talents = TalentLayoutParser.pack_backend_data(talent_info.layout, talent_info.node_tiers)
	end

	if specialization_talent_info then
		specialization_talent_info.packed_talents = TalentLayoutParser.pack_backend_data(specialization_talent_info.layout, specialization_talent_info.node_tiers)
	end

	local character_id = player:character_id()
	local backend = self._backend_interface.characters
	local promise = backend:set_talents_v2(character_id, talent_info, specialization_talent_info)

	promise:next(callback(_set_backend_response_success, player), _set_talents_backend_response_fail):catch(function (err)
		_set_talents_backend_response_fail(err)
	end)

	return promise
end

TalentsService.load_icons_for_profile = function (self, profile, reference_name, callback, prioritize)
	local archetype = profile.archetype
	local load_ids = {}
	local proxy_cb, num_done = nil, 0

	if callback then
		function proxy_cb(...)
			num_done = num_done + 1

			if num_done >= #load_ids then
				callback(...)
			end
		end
	end

	local talents_package_path = archetype.talents_package_path

	load_ids[#load_ids + 1] = Managers.package:load(talents_package_path, reference_name, proxy_cb, prioritize)

	local specialization_talent_package_path = archetype.specialization_talent_package_path

	if specialization_talent_package_path then
		load_ids[#load_ids + 1] = Managers.package:load(specialization_talent_package_path, reference_name, proxy_cb, prioritize)
	end

	return load_ids
end

TalentsService.release_icons = function (self, load_ids)
	if load_ids then
		for i = 1, #load_ids do
			Managers.package:release(load_ids[i])
		end
	end
end

return TalentsService
