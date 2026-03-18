-- chunkname: @scripts/backend/expedition.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Expedition = class("Expedition")

Expedition.reset = function (self, reset_type)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/expedition/reset/"):path(reset_type)

		return Managers.backend:title_request(builder:to_string(), {
			method = "DELETE",
		})
	end)
end

Expedition.settings_by_template = function (self, template_name, optional_node_id, optional_settings_version)
	local builder = BackendUtilities.url_builder():path("/data/expedition/settings/"):path(template_name):query("nodeId", optional_node_id):query("version", optional_settings_version)

	return Managers.backend:title_request(builder:to_string(), {
		method = "GET",
	}):next(function (data)
		return data.body
	end):catch(function (error)
		Log.error("Expedition", "Failed to fetch expedition settings for template '%s': %s", template_name, tostring(error))

		return nil
	end)
end

return Expedition
