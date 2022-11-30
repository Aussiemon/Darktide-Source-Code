local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local StoreFront = class("StoreFront")

StoreFront.personal_offers = function (self)
	return self.data.personal
end

StoreFront.public_offers = function (self)
	return self.data.public_filtered
end

StoreFront._find_matching_entitlement_and_currency = function (self, offer_list, offer)
	for i, v in ipairs(offer_list) do
		if v.entitlement.id == offer.entitlement.id and v.price.amount.type == offer.price.amount.type then
			return i, v
		end
	end

	return nil, nil
end

StoreFront.update_valid_offers = function (self, now)
	self.data.public_filtered = {}

	for _, v in ipairs(self.data.public) do
		if v:is_valid_at(now) then
			local index, matching = self:_find_matching_entitlement_and_currency(self.data.public_filtered, v)

			if not matching then
				table.insert(self.data.public_filtered, v)
			elseif matching.price.priority < v.price.priority then
				self.data.public_filtered[index] = v
			end
		end

		self:_decorate_offer(v, false)
	end
end

StoreFront.init = function (self, data, account_id, character_id, wallet_owner)
	self.data = data
	self.account_id = account_id
	self.character_id = character_id
	self.wallet_owner = wallet_owner

	for _, v in ipairs(data.personal) do
		self:_decorate_offer(v, true)
	end

	for _, v in ipairs(data.public) do
		self:_decorate_offer(v, false)
	end
end

StoreFront._decorate_offer = function (self, offer, is_personal)
	local store_front = self
	offer.description.gear_id = offer.description.gearId

	offer.is_personal = function (self)
		return is_personal
	end

	offer.seconds_remaining = function (self, now)
		return self.price.validTo and (tonumber(self.price.validTo) - now) / 1000 or 0
	end

	offer.is_valid_at = function (self, now)
		return (self.price.validFrom == nil or tonumber(self.price.validFrom) < now) and (self.price.validTo == nil or now < tonumber(self.price.validTo))
	end

	offer.reject = function (self)
		local builder = BackendUtilities.url_builder():path("/store/storefront/"):path(store_front.data.name):path("/offers/"):path(self.offerId):query("accountId", store_front.account_id):query("characterId", store_front.character_id)

		return Managers.backend:title_request(builder:to_string(), {
			method = "DELETE"
		})
	end

	offer.make_purchase = function (self, wallet)
		local offer_id, price_id = nil

		if is_personal then
			offer_id = offer.offerId
		else
			price_id = offer.price.id
		end

		local purchase_request = {
			storeName = store_front.data.name,
			catalogId = store_front.data.catalog.id,
			priceId = price_id,
			offerId = offer_id,
			characterId = store_front.character_id,
			latestTransactionId = wallet.lastTransactionId,
			ownedSkus = offer.owned_skus
		}
		local builder = BackendUtilities.url_builder():path("/store/"):path(store_front.account_id):path("/wallets/"):path(store_front.wallet_owner):path("/purchases")

		return Managers.backend:title_request(builder:to_string(), {
			method = "POST",
			body = purchase_request
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
end

StoreFront.get_config = function (self)
	return Managers.backend:title_request(self.data._links.config.href):next(function (data)
		local config = data.body

		if data.body._links.layout then
			return Managers.backend:title_request(data.body._links.layout.href):next(function (data)
				config.layout = data.body
				config._links = nil
				config.layout._links = nil

				return config
			end)
		else
			return config
		end
	end)
end

StoreFront.get_seconds_to_rotation_end = function (self, t)
	return (self.data.currentRotationEnd - Managers.backend:get_server_time(t)) / 1000
end

StoreFront.get_refund_cost = function (self, config, rerolls_this_week)
	local reroll_config = config.temporaryGoodsConfig.rerolls

	if reroll_config.rollLimit <= rerolls_this_week then
		return nil
	end

	local cost = {
		amount = reroll_config.cost.amount + reroll_config.costScalingFactor * rerolls_this_week * reroll_config.cost.amount,
		type = reroll_config.cost.type
	}

	return cost
end

local Store = class("Store")

Store.get_veteran_credits_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_veteran", character_id, character_id, true)
end

Store.get_zealot_credits_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_zealot", character_id, character_id, true)
end

Store.get_psyker_credits_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_psyker", character_id, character_id, true)
end

Store.get_ogryn_credits_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_ogryn", character_id, character_id, true)
end

Store.get_veteran_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_veteran", character_id, character_id, true)
end

Store.get_zealot_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_zealot", character_id, character_id, true)
end

Store.get_psyker_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_psyker", character_id, character_id, true)
end

Store.get_ogryn_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_ogryn", character_id, character_id, true)
end

Store.get_veteran_credits_weapon_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_weapon_cosmetics_store_veteran", character_id, character_id, false)
end

Store.get_zealot_credits_weapon_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_weapon_cosmetics_store_zealot", character_id, character_id, false)
end

Store.get_psyker_credits_weapon_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_weapon_cosmetics_store_psyker", character_id, character_id, false)
end

Store.get_ogryn_credits_weapon_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_weapon_cosmetics_store_ogryn", character_id, character_id, false)
end

Store.get_veteran_marks_store = function (self, t, character_id)
	return self:_get_storefront(t, "marks_store_veteran", character_id, character_id, true)
end

Store.get_zealot_marks_store = function (self, t, character_id)
	return self:_get_storefront(t, "marks_store_zealot", character_id, character_id, true)
end

Store.get_psyker_marks_store = function (self, t, character_id)
	return self:_get_storefront(t, "marks_store_psyker", character_id, character_id, true)
end

Store.get_ogryn_marks_store = function (self, t, character_id)
	return self:_get_storefront(t, "marks_store_ogryn", character_id, character_id, true)
end

Store.get_premium_storefront = function (self, storefront, t)
	return self:_get_storefront(t, storefront, nil):next(function (store)
		return store:get_config():next(function (config)
			return Promise.resolved({
				wallet_owner = store.wallet_owner,
				public_filtered = store.data.public_filtered,
				layout_config = config,
				decorate_offer = store._decorate_offer,
				is_personal = store.is_personal,
				storefront = store
			})
		end)
	end)
end

Store.get_premium_store = function (self, t)
	return self:_get_storefront(t, "premium_store", nil)
end

Store.get_debug_store = function (self, t, character_id)
	return self:_get_storefront(t, "debug_store", character_id, character_id)
end

Store._get_storefront = function (self, t, store_name, wallet_owner, character_id, include_personal_offers)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/store/storefront/"):path(store_name):query("accountId", account.sub)

		if character_id then
			builder:query("characterId", character_id)

			if include_personal_offers then
				builder:query("personal", include_personal_offers)
			end
		end

		return Managers.backend:title_request(builder:to_string()):next(function (data)
			data.accountId = account.sub
			local storefront = StoreFront:new(data.body, data.accountId, character_id, wallet_owner or data.accountId)

			storefront:update_valid_offers(Managers.backend:get_server_time(t))

			return storefront
		end)
	end)
end

return Store
