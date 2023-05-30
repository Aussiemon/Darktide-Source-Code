local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Wallet = class("Wallet")

Wallet.get_currency_configuration = function (self)
	return Managers.backend:title_request("/store/currencies", {
		method = "GET"
	}):next(function (data)
		return data.body.currencies
	end)
end

Wallet.character_wallets = function (self, character_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder():path(character_id):path("/wallets")):next(function (data)
		local wallets = data.body.wallets

		return wallets
	end)
end

Wallet.account_wallets = function (self)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder():path("wallets")):next(function (data)
		local wallets = data.body.wallets

		return wallets
	end)
end

return Wallet
