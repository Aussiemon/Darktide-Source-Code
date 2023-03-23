local CraftingSettings = require("scripts/settings/item/crafting_settings")
local DataServiceBackendCache = require("scripts/managers/data_service/data_service_backend_cache")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local TRAIT_STICKER_BOOK_ENUM = CraftingSettings.trait_sticker_book_enum
local CraftingService = class("CraftingService")

CraftingService.init = function (self, backend_interface)
	self._backend_interface = backend_interface

	if GameParameters.enable_trait_sticker_book_cache then
		self._trait_sticker_book_cache = DataServiceBackendCache:new("TraitStickerBookCache")
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

		Managers.data_service.store:on_crafting_done(costs)

		return results
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

		Managers.data_service.store:on_crafting_done(costs)

		return results
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

		Managers.data_service.store:on_crafting_done(costs)

		return results
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

		Managers.data_service.store:on_crafting_done(costs)

		return results
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.extract_trait_from_weapon = function (self, gear_id, trait_index, costs)
	return self._backend_interface.crafting:extract_trait_from_weapon(gear_id, trait_index):next(function (result)
		Managers.data_service.gear:on_gear_deleted(gear_id)
		Managers.data_service.store:on_crafting_done(costs)
		self:_on_trait_extracted(result.traits)

		return result
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()
		Managers.data_service.store:invalidate_wallets_cache()

		if self._trait_sticker_book_cache then
			self._trait_sticker_book_cache:invalidate()
		end

		return Promise.rejected(err)
	end)
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

	return Managers.data_service.gear:fetch_gear():next(function (gear_list)
		local found_trait_categories = {}

		for gear_id, gear in pairs(gear_list) do
			local item = MasterItems.get_item_instance(gear, gear_id)

			if item.item_type == "WEAPON_MELEE" or item.item_type == "WEAPON_RANGED" then
				local trait_category_id = ItemUtils.trait_category(item)
				found_trait_categories[trait_category_id] = true
			end
		end

		local cache_promises = {}

		for trait_category_id, _ in pairs(found_trait_categories) do
			cache_promises[#cache_promises + 1] = cache:get_data(trait_category_id, function ()
				return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
			end)
		end

		return Promise.all(unpack(cache_promises))
	end)
end

CraftingService._on_trait_extracted = function (self, extracted_traits)
	local cache = self._trait_sticker_book_cache

	if not cache or cache:is_empty() then
		return
	end

	for i = 1, #extracted_traits do
		local trait = extracted_traits[i]
		local trait_category = ItemUtils.trait_category(trait)
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
		local trait_category_id = ItemUtils.trait_category(item)

		if trait_category_id then
			cache:get_data(trait_category_id, function ()
				return self._backend_interface.crafting:trait_sticker_book(trait_category_id)
			end)
		end
	end
end

return CraftingService
