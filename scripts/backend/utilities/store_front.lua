-- chunkname: @scripts/backend/utilities/store_front.lua

local Offer = require("scripts/backend/utilities/offer")
local StoreFront = class("StoreFront")

StoreFront.init = function (self, data, account_id, character_id, wallet_owner, cache_key)
	self.data = data
	self.account_id = account_id
	self.character_id = character_id
	self.wallet_owner = wallet_owner

	for i, offer in ipairs(data.personal) do
		data.personal[i] = Offer:new(self, offer, true)
	end

	for i, offer in ipairs(data.public) do
		data.public[i] = Offer:new(self, offer, false)
	end
end

StoreFront.personal_offers = function (self)
	return self.data.personal
end

StoreFront.public_offers = function (self)
	return self.data.public_filtered
end

local function _filter_offers(now, offers)
	local size, filtered = 0, {}
	local index_by_entitlement_and_price = {}

	for _, offer in pairs(offers) do
		if offer:is_valid_at(now) then
			local entitlement_id = offer.entitlement.id
			local price_type = offer.price.amount.type

			index_by_entitlement_and_price[entitlement_id] = index_by_entitlement_and_price[entitlement_id] or {}

			local matching_index = index_by_entitlement_and_price[entitlement_id][price_type]

			if matching_index and offer.price.priority > matching_index[matching_index].price.priority then
				filtered[matching_index] = offer
			elseif not matching_index then
				size = size + 1
				filtered[size] = offer
				index_by_entitlement_and_price[entitlement_id][price_type] = size
			end
		end
	end

	return filtered
end

StoreFront.update_valid_offers = function (self, now)
	self.data.public_filtered = _filter_offers(now, self.data.public)
end

StoreFront.get_config = function (self, catalog)
	return Managers.backend:title_request(self.data._links.config.href):next(function (data)
		local config = data.body
		local layout_ref = catalog.layoutRef
		local layout_link

		if layout_ref then
			layout_link = "/store/storefront/layouts/" .. layout_ref
		elseif data.body._links.layout then
			layout_link = data.body._links.layout.href
		end

		if layout_link then
			return Managers.backend:title_request(layout_link):next(function (layout_data)
				config.layout = layout_data.body
				config._links = nil
				config.layout._links = nil

				return config
			end)
		else
			return config
		end
	end)
end

StoreFront.cache_until = function (self, catalogue_name)
	local valid_to = table.nested_get(self, "data", "catalog", "validTo")

	valid_to = valid_to and tonumber(valid_to)

	if catalogue_name == "personal" then
		return nil
	end

	local rotation_end = table.nested_get(self, "data", "currentRotationEnd")
	local rotation_end_numeric = rotation_end and tonumber(rotation_end)

	if rotation_end_numeric and (not valid_to or rotation_end_numeric < valid_to) then
		valid_to = rotation_end_numeric
	end

	for _, offer in pairs(self.data[catalogue_name]) do
		local offer_valid_to = table.nested_get(offer, "price", "validTo")

		offer_valid_to = offer_valid_to and tonumber(offer_valid_to)

		if offer_valid_to and (not valid_to or offer_valid_to < valid_to) then
			valid_to = offer_valid_to
		end
	end

	return valid_to
end

StoreFront.get_seconds_to_rotation_end = function (self, t)
	local data = self.data

	return (data.currentRotationEnd - Managers.backend:get_server_time(t)) / 1000
end

StoreFront.get_refund_cost = function (self, config, rerolls_this_week)
	local reroll_config = config.temporaryGoodsConfig.rerolls

	if rerolls_this_week >= reroll_config.rollLimit then
		return nil
	end

	local cost = {
		amount = reroll_config.cost.amount + reroll_config.costScalingFactor * (rerolls_this_week * reroll_config.cost.amount),
		type = reroll_config.cost.type
	}

	return cost
end

StoreFront.set_interaction_callback = function (self, interaction_callback)
	self._interaction_callback = interaction_callback
end

StoreFront._on_interaction = function (self, ...)
	local interaction_callback = self._interaction_callback

	if not interaction_callback then
		return
	end

	return interaction_callback(self, ...)
end

return StoreFront
