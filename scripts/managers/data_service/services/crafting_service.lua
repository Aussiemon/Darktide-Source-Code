local Promise = require("scripts/foundation/utilities/promise")
local CraftingService = class("CraftingService")

CraftingService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

local function _invalidate_gear_cache(promise)
	return promise:next(function (result)
		Managers.data_service.gear:invalidate_gear_cache()

		return result
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.upgrade_weapon_rarity = function (self, gear_id)
	return self._backend_interface.crafting:upgrade_weapon_rarity(gear_id):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return results
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.upgrade_gadget_rarity = function (self, gear_id)
	return self._backend_interface.crafting:upgrade_gadget_rarity(gear_id):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return results
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.reroll_perk_in_item = function (self, gear_id, existing_perk_index, is_gadget)
	return self._backend_interface.crafting:reroll_perk_in_item(gear_id, existing_perk_index, is_gadget):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return results
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.replace_trait_in_weapon = function (self, gear_id, existing_trait_index, new_trait_id, new_trait_tier)
	return self._backend_interface.crafting:replace_trait_in_weapon(gear_id, existing_trait_index, new_trait_id, new_trait_tier):next(function (results)
		local items = results.items

		for i = 1, #items do
			local item = items[i]
			local gear = item.gear

			Managers.data_service.gear:on_gear_updated(gear_id, gear)
		end

		return results
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

CraftingService.extract_trait_from_weapon = function (self, gear_id, trait_index)
	return self._backend_interface.crafting:extract_trait_from_weapon(gear_id, trait_index):next(function (result)
		Managers.data_service.gear:on_gear_deleted(gear_id)

		return result
	end):catch(function (err)
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(err)
	end)
end

return CraftingService
