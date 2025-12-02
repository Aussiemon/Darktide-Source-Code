-- chunkname: @scripts/utilities/dlc_utils.lua

local DLCSettings = require("scripts/settings/dlc/dlc_settings")
local Promise = require("scripts/foundation/utilities/promise")
local DLCUtils = {}

local function _also_grants_recursive(dlc_id, ids_out, backend_auth_method, found_map)
	found_map = found_map or {
		[dlc_id] = true,
	}

	local also_grants = DLCSettings.also_grants[dlc_id]

	for i = 1, #also_grants do
		repeat
			local other_dlc_id = also_grants[i]

			if found_map[other_dlc_id] then
				break
			end

			found_map[other_dlc_id] = true
			ids_out[#ids_out + 1] = DLCSettings.dlcs[other_dlc_id].ids[backend_auth_method].id

			_also_grants_recursive(other_dlc_id, ids_out, backend_auth_method, found_map)
		until true
	end

	return ids_out
end

DLCUtils.get_ids_for_auth_method = function (dlc_id, backend_auth_method)
	local dlc_settings = DLCSettings.dlcs[dlc_id]
	local platform_settings = dlc_settings.ids[backend_auth_method]
	local ids = {
		platform_settings.id,
	}

	if not DLCSettings.client_predicted_includes_platforms[backend_auth_method] then
		return ids
	end

	ids = _also_grants_recursive(dlc_id, ids, backend_auth_method)

	return ids
end

DLCUtils.is_archetype_available = function (archetype)
	local requires_dlc = archetype.requires_dlc

	if not requires_dlc then
		return Promise.resolved({
			available = true,
			archetype = archetype,
		})
	end

	local availability_promise = Promise:new(function (resolve, reject)
		Managers.dlc:is_owner_of(archetype.requires_dlc):next(function (ok)
			resolve({
				archetype = archetype,
				available = ok,
			})
		end):catch(function (err)
			reject({
				archetype = archetype,
				error = err,
			})
		end)
	end)

	return availability_promise
end

return DLCUtils
