local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Crafting = class("Crafting")

local function _send_crafting_operation(op)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/crafting"), {
		method = "POST",
		body = op
	}):next(function (data)
		data.body._links = nil

		return data.body
	end)
end

Crafting.get_crafting_costs = function (self)
	return Managers.backend:title_request(BackendUtilities.url_builder("/data/account/crafting/costs"):to_string()):next(function (data)
		return data.body.costs
	end)
end

Crafting.trait_sticker_book = function (self, trait_category_id)
	return BackendUtilities.make_account_title_request("account", BackendUtilities.url_builder("/traits/"):path(trait_category_id)):next(function (data)
		local body = data.body
		local sticker_book = {}
		local num_ranks = body.numRanks

		for trait_name, trait_bitmask in pairs(body.stickerBook) do
			local status = {}

			for i = 1, num_ranks do
				if bit.band(bit.rshift(trait_bitmask, i + 4), 1) == 1 then
					status[i] = bit.band(bit.rshift(trait_bitmask, i - 1), 1) == 1
				end
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

Crafting.replace_trait_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id)
	return _send_crafting_operation({
		traitType = "traits",
		op = "replaceTrait",
		gearId = gear_id,
		traitIndex = existing_trait_index - 1,
		traitId = new_trait_id
	})
end

Crafting.replace_perk_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id)
	return _send_crafting_operation({
		traitType = "perks",
		op = "replaceTrait",
		gearId = gear_id,
		traitIndex = existing_trait_index - 1,
		traitId = new_trait_id
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
