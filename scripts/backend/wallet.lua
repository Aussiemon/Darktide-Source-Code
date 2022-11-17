local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local Wallet = class("Wallet")

Wallet.get_currency_configuration = function (self)
	return Managers.backend:title_request("/store/currencies", {
		method = "GET"
	}):next(function (data)
		return data.body
	end)
end

Wallet._decorate_wallets = function (self, wallets)
	local wallets = {
		wallets = wallets,
		by_type = function (self, wallet_type)
			for _, v in ipairs(self.wallets) do
				if v.balance.type == wallet_type then
					return v
				end
			end

			return nil
		end
	}

	return wallets
end

Wallet.combined_wallets = function (self, character_id)
	return Promise.all(BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder():path(character_id):path("/wallets")), BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder():path("wallets"))):next(function (result)
		local character_wallet_data = result[1]
		local account_wallet_data = result[2]
		local character_wallet = character_wallet_data.body.wallets
		local account_wallet = account_wallet_data.body.wallets
		local wallets = {}

		for i = 1, #character_wallet do
			wallets[#wallets + 1] = character_wallet[i]
		end

		for i = 1, #account_wallet do
			wallets[#wallets + 1] = account_wallet[i]
		end

		return self:_decorate_wallets(wallets)
	end)
end

Wallet.character_wallets = function (self, character_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder():path(character_id):path("/wallets")):next(function (data)
		local wallets = data.body.wallets

		return self:_decorate_wallets(wallets)
	end)
end

Wallet.account_wallets = function (self)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder():path("wallets")):next(function (data)
		local wallets = data.body.wallets

		return self:_decorate_wallets(wallets)
	end)
end

return Wallet
