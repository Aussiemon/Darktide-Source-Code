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
				"slot_trinket_1"
			}
		end
	end

	visual_item = visual_item or item

	return item, visual_item
end

Offer.extract_items = function (offer)
	local offer_type = offer.description.type
	local items = {}

	if offer_type == "bundle" then
		local bundle_info = offer.bundleInfo

		for i = 1, #bundle_info do
			local bundle_offer = bundle_info[i]
			local real_item, item = _extract_item(bundle_offer.description)

			items[#items + 1] = {
				real_item = real_item,
				gearId = bundle_offer.description.gearId,
				item = item,
				offer = bundle_offer
			}
		end
	else
		local real_item, item = _extract_item(offer.description)

		items[#items + 1] = {
			real_item = real_item,
			gearId = offer.description.gearId,
			item = item,
			offer = offer
		}
	end

	return items
end

return Offer
