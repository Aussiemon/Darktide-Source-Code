-- chunkname: @scripts/backend/utilities/offer.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Offer = class("Offer")

Offer.init = function (self, store_front, offer, is_personal)
	table.merge(self, offer)

	self._is_personal = is_personal
	self._store_front = store_front
	self.description.gear_id = self.description.gearId

	local bundle_info = self.bundleInfo
	local bundle_size = bundle_info and #bundle_info or 0

	for i = 1, bundle_size do
		local bundle_offer = bundle_info[i]
		local offer_id = bundle_offer.price and bundle_offer.price.id

		if offer_id then
			bundle_offer.offerId = offer_id
			bundle_info[i] = Offer:new(store_front, bundle_offer, is_personal)
		end
	end
end

Offer.is_personal = function (self)
	return self._is_personal
end

Offer.seconds_remaining = function (self, now)
	local price = self.price

	return price.validTo and (tonumber(price.validTo) - now) / 1000 or 0
end

Offer.is_valid_at = function (self, now)
	local price = self.price

	return (price.validFrom == nil or now > tonumber(price.validFrom)) and (price.validTo == nil or now < tonumber(price.validTo))
end

Offer.reject = function (self)
	self._store_front:_on_interaction("reject", self)

	local store_front = self._store_front
	local builder = BackendUtilities.url_builder():path("/store/storefront/"):path(store_front.data.name):path("/offers/"):path(self.offerId):query("accountId", store_front.account_id):query("characterId", store_front.character_id)

	return Managers.backend:title_request(builder:to_string(), {
		method = "DELETE",
	})
end

Offer.make_purchase = function (self, wallet)
	self._store_front:_on_interaction("purchase", self)

	local offer_id, price_id
	local is_personal = self._is_personal

	if is_personal then
		offer_id = self.offerId
	else
		price_id = self.price.id
	end

	local store_front = self._store_front
	local purchase_request = {
		storeName = store_front.data.name,
		catalogId = store_front.data.catalog.id,
		priceId = price_id,
		offerId = offer_id,
		characterId = store_front.character_id,
		latestTransactionId = wallet.lastTransactionId,
		ownedSkus = self.owned_skus,
	}
	local builder = BackendUtilities.url_builder():path("/store/"):path(store_front.account_id):path("/wallets/"):path(wallet.owner or store_front.wallet_owner):path("/purchases")

	return Managers.backend:title_request(builder:to_string(), {
		method = "POST",
		body = purchase_request,
	}):next(function (purchase_result)
		wallet.balance.amount = wallet.balance.amount - purchase_result.body.amount.amount
		wallet.lastTransactionId = (wallet.lastTransactionId or 0) + 1

		local result = purchase_result.body
		local items = result.items

		for i = 1, #items do
			items[i].gear_id = items[i].gearId
			items[i].gearId = nil
		end

		return result
	end)
end

return Offer
