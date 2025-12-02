-- chunkname: @scripts/utilities/offer.lua

local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Offer = {}

local function _extract_item(description)
	local modified_desciption = table.clone(description)

	modified_desciption.gear_id = description.gearId

	local item = MasterItems.get_store_item_instance(modified_desciption)

	if not item then
		return
	end

	local visual_item
	local item_type = item.item_type

	if item_type == "WEAPON_SKIN" then
		visual_item = Items.weapon_skin_preview_item(item)
	elseif item_type == "WEAPON_TRINKET" then
		visual_item = Items.weapon_trinket_preview_item(item)

		if visual_item and not visual_item.slots then
			visual_item.slots = {
				"slot_trinket_1",
			}
		end
	end

	visual_item = visual_item or item

	return item, visual_item
end

Offer.extract_items = function (offer, follow_nested)
	local offer_type = offer.description.type
	local items = {}

	if offer_type ~= "bundle" then
		local real_item, item = _extract_item(offer.description)

		items[#items + 1] = {
			real_item = real_item,
			gearId = offer.description.gearId,
			item = item,
			offer = offer,
		}

		return items
	end

	local bundle_info = offer.bundleInfo

	for i = 1, #bundle_info do
		local bundle_offer = bundle_info[i]

		if bundle_offer.description.type ~= "bundle" then
			local real_item, item = _extract_item(bundle_offer.description)

			items[#items + 1] = {
				real_item = real_item,
				gearId = bundle_offer.description.gearId,
				item = item,
				offer = bundle_offer,
			}
		elseif follow_nested then
			items = table.append(items, Offer.extract_items(bundle_offer, follow_nested))
		else
			items[#items + 1] = {
				gearId = bundle_offer.description.gearId,
				offer = bundle_offer,
			}
		end
	end

	return items
end

Offer.find_media_url = function (offer, predicate)
	local media_array = offer.media
	local media_array_count = media_array and #media_array or 0

	for i = 1, media_array_count do
		local media = media_array[i]

		if predicate(media) then
			return media.url
		end
	end

	return nil
end

return Offer
