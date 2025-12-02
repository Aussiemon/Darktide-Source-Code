-- chunkname: @scripts/backend/mastery.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local MasterItems = require("scripts/backend/master_items")
local MasteryUtils = require("scripts/utilities/mastery")
local Promise = require("scripts/foundation/utilities/promise")
local UISettings = require("scripts/settings/ui/ui_settings")
local Mastery = class("Mastery")

Mastery.purchase_trait = function (self, traitCatId, traitPath, tier)
	local encoded_trait_name = string.gsub(traitPath, "/", "%%2F")

	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/account/"):path("traits/"):path(traitCatId):path("/"):path(encoded_trait_name):path("/tiers/"):path(tier)
		local options = {
			method = "PUT",
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

Mastery.switch_mark = function (self, gear_id, mark_id)
	return Managers.backend:authenticate():next(function (account)
		local account_id = account.sub
		local builder = BackendUtilities.url_builder():path("/data/"):path(account_id):path("/account"):path("/gear/"):path(gear_id)
		local options = {
			method = "PATCH",
			body = {
				mdi = mark_id,
			},
		}

		return Managers.backend:title_request(builder:to_string(), options)
	end)
end

return Mastery
