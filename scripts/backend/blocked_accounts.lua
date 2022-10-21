local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BlockedAccounts = class("BlockedAccounts")

BlockedAccounts.init = function (self)
	self._temp_block_list = {}
end

BlockedAccounts.add = function (self, account_id)
	return Promise.delay(2):next(function ()
		self._temp_block_list[account_id] = true
	end)
end

BlockedAccounts.remove = function (self, account_id)
	return Promise.delay(2):next(function ()
		self._temp_block_list[account_id] = nil
	end)
end

BlockedAccounts.fetch = function (self)
	return Promise.delay(2):next(function ()
		return table.clone(self._temp_block_list)
	end)
end

return BlockedAccounts
