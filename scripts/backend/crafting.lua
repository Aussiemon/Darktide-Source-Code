local CraftingSettings = require("scripts/settings/item/crafting_settings")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local TRAIT_STICKER_BOOK_ENUM = CraftingSettings.trait_sticker_book_enum
local Crafting = class("Crafting")

local function _send_crafting_operation(request_body)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/crafting"), {
		method = "POST",
		body = request_body
	}):next(function (data)
		data.body._links = nil
		local body = data.body
		local items = body.items

		for i, item in pairs(items) do
			items[i] = MasterItems.get_item_instance(item, item.uuid)
		end

		local traits = body.traits

		for i, trait in pairs(traits) do
			traits[i] = MasterItems.get_item_instance(trait, trait.uuid)
		end

		return data.body
	end)
end

Crafting.refresh_crafting_costs = function (self)
	return Managers.backend:title_request(BackendUtilities.url_builder("/data/account/crafting/costs"):to_string()):next(function (data)
		local weapon_crafting_costs = data.body.costs.weapon
		local gadget_crafting_costs = data.body.costs.gadget
		self._crafting_costs = {
			weapon = weapon_crafting_costs,
			gadget = gadget_crafting_costs
		}

		return self._crafting_costs
	end)
end

Crafting.get_item_crafting_metadata = function (self, master_id)
	return Managers.backend:title_request(BackendUtilities.url_builder("/data/crafting/items/"):path(Http.url_encode(master_id)):path("/meta"):to_string()):next(function (data)
		return data.body
	end)
end

Crafting.crafting_costs = function (self)
	return self._crafting_costs
end

Crafting.trait_sticker_book = function (self, trait_category_id)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/traits/"):path(trait_category_id)):next(function (data)
		local body = data.body
		local sticker_book = {}
		local num_ranks = body.numRanks

		for trait_name, trait_bitmask in pairs(body.stickerBook) do
			local status = {}

			for i = 1, num_ranks do
				local value = nil

				if bit.band(bit.rshift(trait_bitmask, i + 3), 1) == 0 then
					value = TRAIT_STICKER_BOOK_ENUM.invalid
				elseif bit.band(bit.rshift(trait_bitmask, i - 1), 1) == 1 then
					value = TRAIT_STICKER_BOOK_ENUM.seen
				else
					value = TRAIT_STICKER_BOOK_ENUM.unseen
				end

				status[i] = value
			end

			sticker_book[trait_name] = status
		end

		return sticker_book
	end)
end

Crafting.upgrade_weapon_rarity = function (self, gear_id)
	return _send_crafting_operation({
		op = "upgradeWeaponRarity",
		gearId = gear_id
	})
end

Crafting.upgrade_gadget_rarity = function (self, gear_id)
	return _send_crafting_operation({
		op = "upgradeGadgetRarity",
		gearId = gear_id
	})
end

Crafting.extract_trait_from_weapon = function (self, gear_id, trait_index)
	return _send_crafting_operation({
		traitType = "traits",
		op = "extractTrait",
		gearId = gear_id,
		traitIndex = trait_index - 1
	})
end

Crafting.extract_perk_from_weapon = function (self, gear_id, trait_index)
	return _send_crafting_operation({
		traitType = "perks",
		op = "extractTrait",
		gearId = gear_id,
		traitIndex = trait_index - 1
	})
end

Crafting.replace_trait_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id, new_trait_tier)
	return _send_crafting_operation({
		traitType = "traits",
		op = "replaceTrait",
		gearId = gear_id,
		traitIndex = existing_trait_index - 1,
		traitId = new_trait_id,
		traitTier = new_trait_tier
	})
end

Crafting.replace_perk_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id, new_trait_tier)
	return _send_crafting_operation({
		traitType = "perks",
		op = "replaceTrait",
		gearId = gear_id,
		traitIndex = existing_trait_index - 1,
		traitId = new_trait_id,
		traitTier = new_trait_tier
	})
end

Crafting.reroll_perk_in_item = function (self, gear_id, existing_perk_index, is_gadget)
	return _send_crafting_operation({
		op = "rerollPerk",
		gearId = gear_id,
		perkIndex = existing_perk_index - 1,
		itemType = is_gadget and "gadget" or "weapon"
	})
end

Crafting.fuse_traits = function (self, character_id, trait_ids)
	return _send_crafting_operation({
		op = "fuseTraits",
		traitIds = trait_ids,
		characterId = character_id
	})
end

return Crafting
