local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {}
local Account = class("Account")

Account.init = function (self)
	return
end

Account.get_boon_inventory = function (self)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("boons")):next(function (data)
		return data.body
	end)
end

Account.set_has_created_first_character = function (self, value)
	return self:set_data("core", {
		has_created_first_character = value
	})
end

Account.get_has_created_first_character = function (self)
	return self:get_data("core", "has_created_first_character")
end

Account.set_has_completed_onboarding = function (self, value)
	return self:set_data("core", {
		has_completed_onboarding = value
	})
end

Account.get_has_completed_onboarding = function (self)
	return self:get_data("core", "has_completed_onboarding")
end

Account.set_selected_character = function (self, character_id)
	return self:set_data("core", {
		selected_character = character_id
	})
end

Account.get_selected_character = function (self)
	return self:get_data("core", "selected_character")
end

Account.set_data = function (self, section, data)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/data/"):path(section), {
		method = "PUT",
		body = {
			data = data
		}
	}):next(function (data)
		return nil
	end)
end

Account.get_data = function (self, section, part)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/data/"):path(section)):next(function (data)
		if part then
			if #data.body.data > 0 then
				return data.body.data[1].value[part]
			else
				return nil
			end
		else
			return data
		end
	end)
end

implements(Account, Interface)

return Account
