-- chunkname: @scripts/backend/store.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local StoreFront = require("scripts/backend/utilities/store_front")
local Store = class("Store")

Store.get_veteran_credits_goods_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_bespoke_weapons_veteran", character_id, character_id)
end

Store.get_zealot_credits_goods_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_bespoke_weapons_zealot", character_id, character_id)
end

Store.get_psyker_credits_goods_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_bespoke_weapons_psyker", character_id, character_id)
end

Store.get_ogryn_credits_goods_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_store_bespoke_weapons_ogryn", character_id, character_id)
end

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
	return self:_get_storefront(t, "credits_cosmetics_store_veteran", character_id, character_id, false)
end

Store.get_zealot_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_zealot", character_id, character_id, false)
end

Store.get_psyker_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_psyker", character_id, character_id, false)
end

Store.get_ogryn_credits_cosmetics_store = function (self, t, character_id)
	return self:_get_storefront(t, "credits_cosmetics_store_ogryn", character_id, character_id, false)
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
		local catalog = store.data.catalog

		return Promise.all(store:get_config(catalog), Managers.backend.interfaces.wallet:get_currency_configuration()):next(function (data)
			local config, currencies = unpack(data)
			local bundle_rules

			for i = 1, #currencies do
				local currency = currencies[i]

				if currency.name == "aquilas" then
					bundle_rules = currency.bundleRules
				end
			end

			local catalog_valid_from = catalog and catalog.validFrom
			local catalog_valid_to = catalog and catalog.validTo

			return Promise.resolved({
				id = catalog and catalog.id,
				wallet_owner = store.wallet_owner,
				public_filtered = store.data.public_filtered,
				layout_config = config,
				decorate_offer = store._decorate_offer,
				is_personal = store.is_personal,
				storefront = store,
				catalog = {
					valid_from = catalog_valid_from and tonumber(catalog_valid_from),
					valid_to = catalog_valid_to and tonumber(catalog_valid_to),
				},
				bundle_rules = bundle_rules,
			})
		end)
	end)
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
