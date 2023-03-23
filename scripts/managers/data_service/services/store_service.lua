local DataServiceBackendCache = require("scripts/managers/data_service/data_service_backend_cache")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PlayerSpecializationUtil = require("scripts/utilities/player_specialization/player_specialization")
local Promise = require("scripts/foundation/utilities/promise")
local StoreService = class("StoreService")

StoreService.init = function (self, backend_interface)
	self._backend_interface = backend_interface

	if GameParameters.enable_wallets_cache then
		self._wallets_cache = DataServiceBackendCache:new("WalletsCache")
	end

	self._wallet_caps = {
		credits = GameParameters.wallet_cap_credits,
		marks = GameParameters.wallet_cap_marks,
		plasteel = GameParameters.wallet_cap_plasteel,
		diamantine = GameParameters.wallet_cap_diamantine,
		aquilas = GameParameters.wallet_cap_aquilas
	}
end

StoreService.reset = function (self)
	if self._wallets_cache then
		self._wallets_cache:reset()
	end
end

StoreService.get_credits_store = function (self, ignore_event_trigger)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_credits_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_credits_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_credits_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_credits_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching credits store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.personal
				current_rotation_end = store_data.currentRotationEnd
			end

			if not ignore_event_trigger then
				local event_manager = Managers.event

				if event_manager then
					event_manager:trigger("event_credits_store_fetched")
				end
			end

			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
		end)
	end
end

StoreService.get_credits_goods_store = function (self, ignore_event_trigger)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_credits_goods_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_credits_goods_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_credits_goods_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_credits_goods_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching credits store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.public
				current_rotation_end = store_data.currentRotationEnd
			end

			if not ignore_event_trigger then
				local event_manager = Managers.event

				if event_manager then
					event_manager:trigger("event_credits_store_fetched")
				end
			end

			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
		end)
	end
end

StoreService.get_credits_cosmetics_store = function (self)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_credits_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_credits_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_credits_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_credits_cosmetics_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching credits cosmetics store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.personal
				current_rotation_end = store_data.currentRotationEnd
			end

			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
		end)
	end
end

StoreService.get_credits_weapon_cosmetics_store = function (self)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_credits_weapon_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_credits_weapon_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_credits_weapon_cosmetics_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_credits_weapon_cosmetics_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching credits cosmetics store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.public
				current_rotation_end = store_data.currentRotationEnd
			end

			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
		end)
	end
end

StoreService.get_marks_store = function (self)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_marks_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_marks_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_marks_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_marks_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching marks store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.public_filtered
			end

			return {
				offers = offers or {}
			}
		end)
	end
end

StoreService.get_marks_store_temporary = function (self)
	if Managers.backend:authenticated() then
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then
			store_promise = backend_interface.store:get_veteran_marks_store(time_since_launch, character_id)
		elseif archetype_name == "zealot" then
			store_promise = backend_interface.store:get_zealot_marks_store(time_since_launch, character_id)
		elseif archetype_name == "psyker" then
			store_promise = backend_interface.store:get_psyker_marks_store(time_since_launch, character_id)
		elseif archetype_name == "ogryn" then
			store_promise = backend_interface.store:get_ogryn_marks_store(time_since_launch, character_id)
		end

		return store_promise:catch(function (error)
			Log.error("StoreService", "Error fetching credits store: %s", error)
		end):next(function (store_catalogue)
			local offers, current_rotation_end = nil

			if store_catalogue then
				local store_data = store_catalogue.data
				offers = store_data.personal
				current_rotation_end = store_data.currentRotationEnd
			end

			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
		end)
	end
end

local function _purchased_item_to_gear(item)
	local gear = table.clone(item)
	local gear_id = gear.uuid
	gear.overrides = nil
	gear.id = nil
	gear.uuid = nil
	gear.gear_id = nil

	return gear_id, gear
end

StoreService.purchase_item = function (self, offer)
	local price = offer.price
	local amount = price.amount
	local wallet_type = amount.type
	local wallet_promise = nil

	if wallet_type == "credits" or wallet_type == "marks" then
		wallet_promise = self:character_wallets()
	else
		wallet_promise = self:account_wallets()
	end

	return wallet_promise:next(function (data)
		local wallet = data:by_type(wallet_type)

		return offer:make_purchase(wallet)
	end):next(function (result)
		Log.info("StoreService", "purchase_item done")

		local items = result.items

		for i = 1, #items do
			local gear_id, gear = _purchased_item_to_gear(items[i])

			Managers.data_service.gear:on_gear_created(gear_id, gear)
			Managers.data_service.crafting:on_gear_created(gear_id, gear)
		end

		return result
	end):catch(function (error)
		Log.error("StoreService", "Error purchase_item: %s", error)
		self:invalidate_wallets_cache()
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(error)
	end)
end

StoreService.purchase_item_with_wallet = function (self, offer, wallet)
	return offer:make_purchase(wallet):next(function (result)
		Log.info("StoreService", "purchase_item done")

		local items = result.items

		for i = 1, #items do
			local gear_id, gear = _purchased_item_to_gear(items[i])

			Managers.data_service.gear:on_gear_created(gear_id, gear)
			Managers.data_service.crafting:on_gear_created(gear_id, gear)
		end

		return result
	end):catch(function (error)
		Log.error("StoreService", "Error purchase_item: %s", error)
		self:invalidate_wallets_cache()
		Managers.data_service.gear:invalidate_gear_cache()

		return Promise.rejected(error)
	end)
end

StoreService.purchase_currency = function (self, offer)
	return offer:make_purchase():next(function (backend_result)
		local currency_type = offer.value.type
		local currency_amount = offer.value.amount

		if backend_result and backend_result.body.state == "failed" or currency_type == nil or currency_amount == nil then
			self:invalidate_wallets_cache()

			return backend_result
		else
			self:_change_cached_wallet_balance(currency_type, currency_amount, false, "purchase_currency")

			return backend_result
		end
	end):catch(function (err)
		Log.error("StoreService", "Error purchase_currency: %s", table.tostring(err))
		self:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

StoreService._decorate_wallets = function (self, wallets)
	local wallets = {
		wallets = wallets,
		by_type = function (self, wallet_type)
			for _, v in ipairs(self.wallets) do
				if v.balance.type == wallet_type then
					return v
				end
			end

			return nil
		end
	}

	return wallets
end

StoreService.combined_wallets = function (self)
	return Promise.all(self:character_wallets(true), self:account_wallets(true)):next(function (result)
		local character_wallets = result[1]
		local account_wallets = result[2]
		local wallets = {}

		for i = 1, #character_wallets do
			wallets[#wallets + 1] = character_wallets[i]
		end

		for i = 1, #account_wallets do
			wallets[#wallets + 1] = account_wallets[i]
		end

		return self:_decorate_wallets(wallets)
	end)
end

StoreService.account_wallets = function (self, skip_decoration)
	local wallets_promise = nil

	if self._wallets_cache then
		wallets_promise = self._wallets_cache:get_data("__account", function ()
			return self._backend_interface.wallet:account_wallets()
		end)
	else
		wallets_promise = self._backend_interface.wallet:account_wallets()
	end

	if skip_decoration then
		return wallets_promise
	else
		return wallets_promise:next(function (wallets)
			return self:_decorate_wallets(wallets)
		end)
	end
end

local function _current_character_id()
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	return character_id
end

StoreService.character_wallets = function (self, skip_decoration)
	local character_id = _current_character_id()
	local wallets_promise = nil

	if self._wallets_cache then
		wallets_promise = self._wallets_cache:get_data(character_id, function ()
			return self._backend_interface.wallet:character_wallets(character_id)
		end)
	else
		wallets_promise = self._backend_interface.wallet:character_wallets(character_id)
	end

	if skip_decoration then
		return wallets_promise
	else
		return wallets_promise:next(function (wallets)
			return self:_decorate_wallets(wallets)
		end)
	end
end

StoreService.invalidate_wallets_cache = function (self)
	if self._wallets_cache then
		self._wallets_cache:invalidate()
	end
end

StoreService._find_cached_wallet_by_type = function (self, wallet_type)
	local wallets_cache = self._wallets_cache

	if not wallets_cache or wallets_cache:is_empty() then
		return nil
	end

	local account_wallets = wallets_cache:cached_data_by_key("__account")

	if account_wallets then
		for i = 1, #account_wallets do
			local wallet = account_wallets[i]

			if wallet.balance.type == wallet_type then
				return wallet
			end
		end
	end

	local character_id = _current_character_id()
	local character_wallets = wallets_cache:cached_data_by_key(character_id)

	if character_wallets then
		for i = 1, #character_wallets do
			local wallet = character_wallets[i]

			if wallet.balance.type == wallet_type then
				return wallet
			end
		end
	end
end

StoreService._change_cached_wallet_balance = function (self, wallet_type, change_amount, increment_transaction_id, log_prefix)
	local cached_wallet = self:_find_cached_wallet_by_type(wallet_type)

	if cached_wallet then
		local old_amount = cached_wallet.balance.amount
		local new_amount = old_amount + change_amount
		local cap = self._wallet_caps[wallet_type] or math.huge
		local capped = false

		if cap < new_amount then
			new_amount = cap
			capped = true
		end

		cached_wallet.balance.amount = new_amount

		if increment_transaction_id then
			cached_wallet.lastTransactionId = (cached_wallet.lastTransactionId or 0) + 1
		end
	end
end

StoreService.on_gear_deleted = function (self, backend_result)
	local rewards = backend_result and backend_result.rewards

	if rewards then
		for i = 1, #rewards do
			local reward = rewards[i]
			local reward_type = reward.type
			local reward_amount = reward.amount

			self:_change_cached_wallet_balance(reward_type, reward_amount, true, "on_gear_deleted")
		end
	end
end

StoreService.on_contract_task_rerolled = function (self, reroll_cost)
	local cost_type = reroll_cost.type
	local cost_amount = reroll_cost.amount

	self:_change_cached_wallet_balance(cost_type, -cost_amount, true, "on_contract_task_rerolled")
end

StoreService.on_contract_completed = function (self, backend_result)
	local reward = backend_result and backend_result.reward

	if reward then
		local reward_type = reward.type
		local reward_amount = reward.amount

		self:_change_cached_wallet_balance(reward_type, reward_amount, true, "on_contract_completed")
	end
end

StoreService.on_crafting_done = function (self, costs)
	if costs then
		for i = 1, #costs do
			local cost = costs[i]
			local cost_type = cost.type
			local cost_amount = cost.amount

			if cost_amount ~= 0 then
				self:_change_cached_wallet_balance(cost_type, -cost_amount, true, "on_crafting_done")
			end
		end
	end
end

StoreService.get_premium_store = function (self, storefront_key)
	if storefront_key == "hard_currency_store" then
		return Managers.backend.interfaces.external_payment:get_options():catch(function (error)
			Log.error("StoreService", "Failed to fetch external payment options %s", error)
		end)
	end

	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local time_since_launch = Application.time_since_launch()
	local promise = Managers.backend.interfaces.store:get_premium_storefront(storefront_key, time_since_launch, character_id)

	return promise:catch(function (error)
		Log.error("StoreService", "Failed to fetch premium storefront %s %s", storefront_key, error)
	end):next(function (store_catalogue)
		local offers, current_rotation_end, layout_config, decorate_offer, catalog_validity = nil

		if store_catalogue then
			local store_data = store_catalogue.data
			offers = store_catalogue.public_filtered
			layout_config = store_catalogue.layout_config
			current_rotation_end = store_data and store_data.currentRotationEnd
			decorate_offer = store_catalogue.decorate_offer
			catalog_validity = store_catalogue.catalog
		end

		return {
			offers = offers or {},
			layout_config = layout_config or {},
			current_rotation_end = current_rotation_end,
			decorate_offer = decorate_offer and function (self, test, is_personal)
				decorate_offer(store_catalogue.storefront, test, is_personal)
			end or nil,
			catalog_validity = catalog_validity
		}
	end)
end

return StoreService
