-- chunkname: @scripts/managers/data_service/services/crafting_service.lua

local CraftingSettings = require("scripts/settings/item/crafting_settings")
local DataServiceBackendCache = require("scripts/managers/data_service/data_service_backend_cache")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local UISettings = require("scripts/settings/ui/ui_settings")
local TRAIT_STICKER_BOOK_ENUM = CraftingSettings.trait_sticker_book_enum
local CraftingService = class("CraftingService")

local function get_all_trait_category_ids()
	local trait_categories = {}

	for id, data in pairs(UISettings.weapon_patterns) do
		if data.marks and data.marks[1] then
			local item = MasterItems.get_item(data.marks[1].item)
			local trait_category = item and Items.trait_category(item)

			if trait_category then
				trait_categories[trait_category] = true
			end
		end
	end

	return trait_categories
end

CraftingService.init = function (self, backend_interface)
	self._backend_interface = backend_interface

	if GameParameters.enable_trait_sticker_book_cache then
		self._trait_sticker_book_cache = DataServiceBackendCache:new("TraitStickerBookCache")
	end
end

CraftingService.reset_sticker_book = function (self)
	if self._trait_sticker_book_cache then
		self._trait_sticker_book_cache:reset()

		return self:warm_trait_sticker_book_cache()
	else
		return Promise:resolved()
	end
end

CraftingService.reset = function (self)
	if self._trait_sticker_book_cache then
		self._trait_sticker_book_cache:reset()
	end
end

CraftingService.upgrade_weapon_rarity = function (self, gear_id, costs)
	return self._backend_interface.crafting:upgrade_weapon_rarity(gear_id):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.upgrade_gadget_rarity = function (self, gear_id, costs)
	return self._backend_interface.crafting:upgrade_gadget_rarity(gear_id):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.reroll_perk_in_item = function (self, gear_id, existing_perk_index, is_gadget, costs)
	return self._backend_interface.crafting:reroll_perk_in_item(gear_id, existing_perk_index, is_gadget):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.replace_trait_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id, new_trait_tier, costs)
	return self._backend_interface.crafting:replace_trait_in_weapon(gear_id, existing_trait_index, new_trait_id, new_trait_tier):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.replace_perk_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id, costs, new_trait_tier)
	return self._backend_interface.crafting:replace_perk_in_weapon(gear_id, existing_trait_index, new_trait_id, new_trait_tier):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.extract_trait_from_weapon = function (self, gear_id, trait_index, costs)
	return self._backend_interface.crafting:extract_trait_from_weapon(gear_id, trait_index):next(function (result)
		Managers.data_service.gear:on_gear_deleted(gear_id)

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			self:_on_trait_extracted(result.traits)

			return result
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		if self._trait_sticker_book_cache then
			self._trait_sticker_book_cache:invalidate()
		end

		return Promise.rejected(err)
	end)
end

CraftingService.cached_trait_sticker_book = function (self, trait_category_id)
	if self._trait_sticker_book_cache then
		return self._trait_sticker_book_cache:cached_data_by_key(trait_category_id) or {}
	end

	return {}
end

CraftingService.trait_sticker_book = function (self, trait_category_id)
	if self._trait_sticker_book_cache then
		return self._trait_sticker_book_cache:get_data(trait_category_id, function ()
			return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
		end)
	else
		return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
	end
end

CraftingService.warm_trait_sticker_book_cache = function (self)
	local cache = self._trait_sticker_book_cache

	if not cache then
		return Promise.resolved()
	end

	return self._backend_interface.crafting:all_trait_sticker_book():next(function (data)
		for trait_category_id, trait_data in pairs(data) do
			cache:get_data(trait_category_id, function ()
				return Promise.resolved(trait_data)
			end)
		end
	end)
end

CraftingService._on_trait_extracted = function (self, extracted_traits)
	local cache = self._trait_sticker_book_cache

	if not cache or cache:is_empty() then
		return
	end

	for i = 1, #extracted_traits do
		local trait = extracted_traits[i]
		local trait_category = Items.trait_category(trait)
		local trait_name = trait.name
		local trait_rarity = trait.rarity
		local cached_category_traits = cache:cached_data_by_key(trait_category)

		if cached_category_traits then
			local cached_trait = cached_category_traits[trait_name]

			if cached_trait and cached_trait[trait_rarity] == TRAIT_STICKER_BOOK_ENUM.unseen then
				cached_trait[trait_rarity] = TRAIT_STICKER_BOOK_ENUM.seen
			end
		end
	end
end

CraftingService.on_gear_created = function (self, gear_id, gear)
	local cache = self._trait_sticker_book_cache

	if not cache then
		return
	end

	local item = MasterItems.get_item_instance(gear, gear_id)

	if item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" then
		local trait_category_id = Items.trait_category(item)

		if trait_category_id then
			cache:get_data(trait_category_id, function ()
				return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
			end)
		end
	end
end

CraftingService.get_item_crafting_metadata = function (self, gear_id)
	return self._backend_interface.crafting:get_item_crafting_metadata(gear_id):next(function (result)
		return result
	end):catch(function (err)
		return Promise.rejected(err)
	end)
end

CraftingService.add_weapon_expertise = function (self, gear_id, added_expertise, costs)
	return self._backend_interface.crafting:add_weapon_expertise(gear_id, added_expertise):next(function (results)
		local item = results.items[1]
		local gear = item.gear

		Managers.data_service.gear:on_gear_updated(gear_id, gear)

		return Managers.data_service.store:on_crafting_done(costs):next(function ()
			return results
		end)
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.extract_weapon_mastery = function (self, mastery_id, gear_ids)
	local max_operations = 40
	local track_id = Managers.data_service.mastery:get_track_id(mastery_id)
	local num_batches = gear_ids and math.floor(#gear_ids / max_operations + 1) or 0
	local gear_batches = {}

	if num_batches > 0 then
		for i = 1, num_batches do
			gear_batches[i] = {}

			local start_batch = (i - 1) * max_operations + 1
			local end_batch = i < num_batches and start_batch + max_operations or #gear_ids

			for ii = start_batch, end_batch do
				local gear_id = gear_ids[ii]

				gear_batches[i][#gear_batches[i] + 1] = gear_id
			end
		end
	end

	return self:_extract_weapon_mastery_batches(track_id, gear_batches, {
		amount = 0,
		gear_ids = {}
	})
end

CraftingService._extract_weapon_mastery_batches = function (self, track_id, gear_batches, result)
	if gear_batches[1] then
		local gear_ids = gear_batches[1]

		return self._backend_interface.crafting:extract_weapon_mastery(track_id, gear_ids):next(function (data)
			local amount = data and data.details and data.details.amounts and data.details.amounts[track_id] or 0

			for i = 1, #gear_ids do
				local gear_id = gear_ids[i]

				result.gear_ids[#result.gear_ids + 1] = gear_id

				Managers.data_service.gear:on_gear_deleted(gear_id)
			end

			result.amount = result.amount + amount

			table.remove(gear_batches, 1)

			return self:_extract_weapon_mastery_batches(track_id, gear_batches, result)
		end):catch(function (data)
			table.remove(gear_batches, 1)

			return self:_extract_weapon_mastery_batches(track_id, gear_batches, result)
		end)
	else
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.resolved(result)
	end
end

CraftingService.get_traits_mastery_costs = function (self)
	return Managers.backend.interfaces.crafting:traits_mastery_costs()
end

CraftingService.get_sacrifice_mastery_costs = function (self)
	return Managers.backend.interfaces.crafting:sacrifice_mastery_costs()
end

CraftingService.get_trait_sticker_book_by_id = function (self, trait_category_id)
	return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
end

return CraftingService
