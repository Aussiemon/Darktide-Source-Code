require("scripts/ui/views/vendor_view_base/vendor_view_base")

local Definitions = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_definitions")
local CreditsVendorViewSettings = require("scripts/ui/views/credits_vendor_view/credits_vendor_view_settings")
local Promise = require("scripts/foundation/utilities/promise")
local ItemUtils = require("scripts/utilities/items")
local CreditsVendorView = class("CreditsVendorView", "VendorViewBase")

CreditsVendorView.init = function (self, settings, context)
	local parent = context and context.parent
	self._parent = parent
	self._optional_store_service = context and context.optional_store_service

	CreditsVendorView.super.init(self, Definitions, settings, context)
end

CreditsVendorView._get_store = function (self)
	local store_service = Managers.data_service.store
	local store_promise = nil
	local optional_store_service = self._optional_store_service

	if optional_store_service and store_service[optional_store_service] then
		store_promise = store_service[optional_store_service](store_service)
	else
		store_promise = store_service:get_credits_store()
	end

	if not store_promise then
		return
	end

	return store_promise:next(function (data)
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()

		return Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
			local offers = data.offers

			for i = 1, #offers do
				local offer = offers[i]
				local offer_id = offer.offerId
				local sku = offer.sku
				local category = sku.category

				if category == "item_instance" and offer.state == "active" then
					local item = offer.description

					if self:_does_item_exist_in_list(items, item) then
						offer.state = "owned"
					end
				end
			end

			return Promise.resolved(data)
		end)
	end)
end

CreditsVendorView._purchase_item = function (self, offer)
	local store_service = Managers.data_service.store
	local promise = store_service:purchase_item(offer)

	promise:next(function (result)
		self._purchase_promise = nil
		offer.state = "owned"

		self:_on_purchase_complete(result.items)
	end):catch(function (error)
		self:_fetch_store_items()

		self._purchase_promise = nil
	end)

	self._purchase_promise = promise
end

CreditsVendorView._does_item_exist_in_list = function (self, items, item)
	for gear_id, _ in pairs(items) do
		if gear_id == item.gear_id then
			return true
		end
	end

	return false
end

CreditsVendorView._on_purchase_complete = function (self, items)
	CreditsVendorView.super._on_purchase_complete(self, items)
	self._parent:play_vo_events(CreditsVendorViewSettings.vo_event_vendor_purchase, "credit_store_servitor_b", nil, 1.4)
end

CreditsVendorView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CreditsVendorView
