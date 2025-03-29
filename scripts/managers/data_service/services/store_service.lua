-- chunkname: @scripts/managers/data_service/services/store_service.lua

local DataServiceBackendCache = require("scripts/managers/data_service/data_service_backend_cache")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local StoreNames = require("scripts/settings/backend/store_names")
local StoreService = class("StoreService")

local function _get_local_player()
	local local_player_id = 1

	return Managers.player:local_player(local_player_id)
end

local function _current_character_id()
	local player = _get_local_player()

	return player:character_id()
end

local function _backend_time()
	local current_time = Managers.time:time("main")
	local backend_time = Managers.backend:get_server_time(current_time)

	return backend_time
end

StoreService.max_cache_time = 3600000
StoreService.FEATURE_KEY = "premium_store_featured"
StoreService.GET_PREMIUM_STORE_TIMEOUT = 60

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
		aquilas = GameParameters.wallet_cap_aquilas,
	}
	self._current_store_id = nil
	self._store_cache = {}
	self._wallet_caps_backend_updated = false
	self._block_aquila_acquisition = false
	self._get_premium_store_last_call_time = nil
end

StoreService.update_wallet_caps = function (self)
	if not Managers.backend:authenticated() then
		return
	end

	local backend_interface = self._backend_interface

	return backend_interface.wallet:get_currency_configuration():next(function (data)
		if not data then
			return
		end

		local wallet_caps = self._wallet_caps

		for i = 1, #data do
			local currency = data[i]
			local currency_name = currency.name
			local currency_cap = currency.cap

			if wallet_caps[currency_name] and currency_cap then
				wallet_caps[currency_name] = currency_cap
			end
		end

		self._wallet_caps_backend_updated = true
	end)
end

StoreService.verify_wallet_caps = function (self)
	local wallet_caps_promise

	if not self._wallet_caps_backend_updated then
		wallet_caps_promise = self:update_wallet_caps()
	end

	wallet_caps_promise = wallet_caps_promise or Promise.resolved()

	return wallet_caps_promise
end

StoreService.reset = function (self)
	local wallet_cache = self._wallets_cache

	if wallet_cache then
		wallet_cache:reset()
	end

	self._current_store_id = nil
	self._store_cache = {}
end

StoreService._get_store = function (self, function_name)
	if not Managers.backend:authenticated() then
		return
	end

	local store_interace = self._backend_interface.store

	if not store_interace[function_name] then
		Log.error("StoreService", "Attempting fetch undefined store '%s'", function_name)

		return
	end

	local character_id = _current_character_id()
	local time_since_launch = Application.time_since_launch()

	return store_interace[function_name](store_interace, time_since_launch, character_id):catch(function (error)
		Log.error("StoreService", "Error fetching '%s': %s", function_name, error)

		return error
	end)
end

StoreService._get_cached_store = function (self, cache_key, logging_function)
	logging_function = logging_function or Log.info

	local cache = self._store_cache
	local cache_data = cache[cache_key]

	if not cache_data then
		logging_function("StoreService", "No cache for '%s'.", cache_key)

		return
	end

	local cache_promise = cache_data.promise

	if cache_promise:is_pending() then
		logging_function("StoreService", "Use pending promise for '%s'.", cache_key)

		return cache_promise
	end

	if not cache_promise:is_fulfilled() then
		logging_function("StoreService", "Clearing cache for '%s'. Reason, not resolved.", cache_key)

		cache[cache_key] = nil

		return
	end

	local backend_time = _backend_time()
	local cached_at = cache_data.cached_at
	local cache_to = cached_at and cached_at + StoreService.max_cache_time

	if cache_to == nil or cache_to < backend_time then
		logging_function("StoreService", "Clearing cache for '%s'. Reason, passed max cache: '%s' < '%s'.", cache_key, cache_to, backend_time)

		cache[cache_key] = nil

		return
	end

	local valid_to = cache_data.valid_to

	if valid_to == nil or valid_to < backend_time then
		logging_function("StoreService", "Clearing cache for '%s'. Reason, no longer valid: '%s' < '%s'.", cache_key, valid_to, backend_time)

		cache[cache_key] = nil

		return
	end

	logging_function("StoreService", "Use resolved promise for '%s'. '%s' / '%s' >= '%s'.", cache_key, valid_to, cache_to, backend_time)

	return cache_promise
end

StoreService._get_archetype_store_catalogue = function (self, store_by_archetype, catalogue_name, event_name, archetype_name)
	if not archetype_name then
		local player = _get_local_player()

		archetype_name = player:archetype_name()
	end

	local function_name = store_by_archetype[archetype_name]
	local store_promise = self:_get_store(function_name)

	store_promise = store_promise or Promise.rejected()

	local full_promise = store_promise:next(function (store_front)
		local offers, current_rotation_end

		if store_front then
			local store_data = store_front.data

			if store_data then
				offers = store_data[catalogue_name]
				current_rotation_end = store_data.currentRotationEnd
			end
		end

		local event_manager = Managers.event

		if event_name and event_manager then
			event_manager:trigger(event_name)
		end

		return {
			offers = offers or {},
			current_rotation_end = current_rotation_end,
		}
	end)

	return full_promise:next(function (t)
		return t and table.clone_instance(t)
	end)
end

StoreService.get_credits_store = function (self, ignore_event_trigger)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.credit, "personal", ignore_event_trigger ~= true and "event_credits_store_fetched" or nil, nil)
end

StoreService.get_credits_goods_store = function (self, ignore_event_trigger)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.credit_goods, "public", ignore_event_trigger ~= true and "event_credits_store_fetched" or nil, nil)
end

StoreService.get_credits_cosmetics_store = function (self, archetype_name)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.credit_cosmetics, "public", nil, archetype_name)
end

StoreService.get_credits_weapon_cosmetics_store = function (self, archetype_name)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.credit_weapon_cosmetics, "public", nil, archetype_name)
end

StoreService.get_marks_store = function (self)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.mark, "public_filtered", nil, nil)
end

StoreService.get_marks_store_temporary = function (self)
	return self:_get_archetype_store_catalogue(StoreNames.by_archetype.mark, "personal", nil, nil)
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

StoreService._decorate_item_purchase_promise = function (self, purchase_promise)
	return purchase_promise:next(function (result)
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

StoreService.purchase_item = function (self, offer)
	local price = offer.price
	local amount = price.amount
	local wallet_type = amount.type
	local wallet_promise

	if wallet_type == "credits" or wallet_type == "marks" then
		wallet_promise = self:combined_wallets()
	else
		wallet_promise = self:account_wallets()
	end

	local purchase_promise = wallet_promise:next(function (data)
		local wallet = data:by_type(wallet_type)

		return offer:make_purchase(wallet)
	end)

	return self:_decorate_item_purchase_promise(purchase_promise)
end

StoreService.purchase_item_with_wallet = function (self, offer, wallet)
	local purchase_promise = offer:make_purchase(wallet)

	return self:_decorate_item_purchase_promise(purchase_promise)
end

StoreService.purchase_currency = function (self, offer)
	return offer:make_purchase():next(function (backend_result)
		local currency_type = offer.value.type
		local currency_amount = offer.value.amount

		if backend_result and backend_result.body.state == "failed" or currency_type == nil or currency_amount == nil then
			self:invalidate_wallets_cache()

			return backend_result
		else
			return self:verify_wallet_caps():next(function ()
				self:_change_cached_wallet_balance(currency_type, currency_amount, true, "purchase_currency")

				return backend_result
			end)
		end
	end):catch(function (err)
		Log.error("StoreService", "Error purchase_currency: %s", table.tostring(err))
		self:invalidate_wallets_cache()

		return Promise.rejected(err)
	end)
end

local function _find_wallet_in_array(array, wallet_type)
	local array_size = array and #array or 0

	for i = 1, array_size do
		local wallet = array[i]

		if wallet.balance.type == wallet_type then
			return wallet
		end
	end
end

local function _get_wallet_by_type(self, wallet_type)
	local wallets = self.wallets

	return _find_wallet_in_array(wallets, wallet_type)
end

StoreService._decorate_wallets = function (self, wallets)
	local decorated_wallets = {
		wallets = wallets,
		by_type = _get_wallet_by_type,
	}

	return decorated_wallets
end

StoreService.combined_wallets = function (self)
	return Promise.all(self:character_wallets(true), self:account_wallets(true)):next(function (result)
		local character_wallets = result[1]
		local account_wallets = result[2]
		local wallets = {}

		for i = 1, #account_wallets do
			wallets[#wallets + 1] = account_wallets[i]
		end

		for i = 1, #character_wallets do
			wallets[#wallets + 1] = character_wallets[i]
		end

		return self:_decorate_wallets(wallets)
	end)
end

StoreService._get_wallet = function (self, skip_decoration, cache_name, promise_function)
	local wallets_promise
	local wallets_cache = self._wallets_cache

	if wallets_cache then
		wallets_promise = wallets_cache:get_data(cache_name, promise_function)
	else
		wallets_promise = promise_function()
	end

	if not skip_decoration then
		wallets_promise = wallets_promise:next(function (wallets)
			return self:_decorate_wallets(wallets)
		end)
	end

	return wallets_promise
end

StoreService.account_wallets = function (self, skip_decoration)
	return self:_get_wallet(skip_decoration, "__account", function ()
		return self._backend_interface.wallet:account_wallets()
	end)
end

StoreService.character_wallets = function (self, skip_decoration)
	local character_id = _current_character_id()

	return self:_get_wallet(skip_decoration, character_id, function ()
		return self._backend_interface.wallet:character_wallets(character_id)
	end)
end

StoreService.invalidate_wallets_cache = function (self)
	local wallets_cache = self._wallets_cache

	if not wallets_cache then
		return
	end

	wallets_cache:invalidate()
end

StoreService._find_cached_wallet_by_type = function (self, wallet_type)
	local wallets_cache = self._wallets_cache

	if not wallets_cache or wallets_cache:is_empty() then
		return nil
	end

	local wallet = _find_wallet_in_array(wallets_cache:cached_data_by_key("__account"), wallet_type)
	local character_id = _current_character_id()

	wallet = wallet or _find_wallet_in_array(wallets_cache:cached_data_by_key(character_id), wallet_type)

	return wallet
end

StoreService._change_cached_wallet_balance = function (self, wallet_type, change_amount, increment_transaction_id, log_prefix)
	local cached_wallet = self:_find_cached_wallet_by_type(wallet_type)

	if not cached_wallet then
		return
	end

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

StoreService.on_gear_deleted = function (self, backend_result)
	local rewards = backend_result and backend_result.rewards

	if not rewards then
		return Promise.resolved(backend_result)
	end

	return self:verify_wallet_caps():next(function ()
		for i = 1, #rewards do
			local reward = rewards[i]
			local reward_type = reward.type
			local reward_amount = reward.amount

			self:_change_cached_wallet_balance(reward_type, reward_amount, true, "on_gear_deleted")

			return backend_result
		end
	end)
end

StoreService.on_character_operation = function (self, operation_cost)
	local cost_type = operation_cost.type
	local cost_amount = operation_cost.amount

	return self:verify_wallet_caps():next(function ()
		self:_change_cached_wallet_balance(cost_type, -cost_amount, true, "on_character_operation")
	end)
end

StoreService.on_contract_task_rerolled = function (self, reroll_cost)
	local cost_type = reroll_cost.type
	local cost_amount = reroll_cost.amount

	Managers.event:trigger("reroll_contracts")

	return self:verify_wallet_caps():next(function ()
		self:_change_cached_wallet_balance(cost_type, -cost_amount, true, "on_contract_task_rerolled")
	end)
end

StoreService.on_event_tier_completed = function (self, backend_result)
	local rewards = backend_result and backend_result.rewards

	if not rewards then
		return Promise.resolved()
	end

	return self:verify_wallet_caps():next(function ()
		for i = 1, #rewards do
			local reward = rewards[i]

			if reward.type == "currency" then
				local currency, amount = reward.currency, reward.amount

				self:_change_cached_wallet_balance(currency, amount, false, "on_event_tier_completed")
			end
		end
	end)
end

StoreService.on_contract_completed = function (self, backend_result)
	local reward = backend_result and backend_result.reward

	if not reward then
		return Promise.resolved()
	end

	local reward_type = reward.type
	local reward_amount = reward.amount

	return self:verify_wallet_caps():next(function ()
		self:_change_cached_wallet_balance(reward_type, reward_amount, true, "on_contract_completed")
	end)
end

StoreService.on_crafting_done = function (self, costs)
	if not costs then
		return Promise.resolved()
	end

	return self:verify_wallet_caps():next(function ()
		for i = 1, #costs do
			local cost = costs[i]
			local cost_type = cost.type
			local cost_amount = cost.amount

			if cost_amount ~= 0 then
				self:_change_cached_wallet_balance(cost_type, -cost_amount, true, "on_crafting_done")
			end
		end
	end)
end

StoreService.can_purchase_aquilas = function (self)
	return self._block_aquila_acquisition
end

StoreService._character_premium_store_key = function (self, archetype_name)
	if not archetype_name then
		local player = _get_local_player()

		archetype_name = player:archetype_name()
	end

	local storefront_key = StoreNames.by_archetype.premium[archetype_name]

	return storefront_key
end

StoreService.has_character_premium_store = function (self, archetype_name)
	return self:_character_premium_store_key(archetype_name) ~= nil
end

StoreService.get_character_premium_store = function (self, archetype_name)
	local storefront_key = self:_character_premium_store_key(archetype_name)

	return self:get_premium_store(storefront_key)
end

StoreService.get_premium_store = function (self, storefront_key)
	if storefront_key == "hard_currency_store" then
		return Managers.backend.interfaces.external_payment:get_options():next(function (data)
			self._block_aquila_acquisition = false

			return data
		end):catch(function (error)
			Log.error("StoreService", "Failed to fetch external payment options %s", error)

			if error.error and error.error == "empty_store" and Managers.backend.interfaces.external_payment.show_empty_store_error then
				return Managers.backend.interfaces.external_payment:show_empty_store_error():next(function ()
					self._block_aquila_acquisition = true

					return Promise.rejected({
						error = error.error,
					})
				end)
			end

			local show_error = error and (not type(error) == "table" and {
				error = error,
			} or error) or {}

			self._block_aquila_acquisition = false

			return Promise.rejected(show_error)
		end)
	end

	local cache_key = storefront_key
	local cached_promise = self:_get_cached_store(cache_key)

	if cached_promise then
		return cached_promise:next(function (t)
			return t and table.clone_instance(t)
		end)
	end

	local store_cache = self._store_cache

	store_cache[cache_key] = {}

	if StoreService:is_featured_store(storefront_key) then
		self._current_store_id = nil
	end

	local time_since_launch = Application.time_since_launch()

	store_cache[cache_key].promise = Managers.backend.interfaces.store:get_premium_storefront(storefront_key, time_since_launch):next(function (store_catalogue)
		local id, offers, current_rotation_end, layout_config, catalog_validity, bundle_rules

		if store_catalogue then
			local store_data = store_catalogue.data

			current_rotation_end = store_data and store_data.currentRotationEnd
			offers = store_catalogue.public_filtered
			layout_config = store_catalogue.layout_config
			catalog_validity = store_catalogue.catalog
			bundle_rules = store_catalogue.bundle_rules
			id = store_catalogue.id
		end

		local store_front = store_catalogue.storefront

		store_front:set_interaction_callback(callback(self, "invalidate_store_cache", cache_key))

		store_cache[cache_key].valid_to = store_front:cache_until("public_filtered")
		store_cache[cache_key].cached_at = _backend_time()

		if StoreService:is_featured_store(storefront_key) then
			self._current_store_id = id
		end

		return {
			id = id,
			offers = offers or {},
			layout_config = layout_config or {},
			current_rotation_end = current_rotation_end,
			catalog_validity = catalog_validity,
			bundle_rules = bundle_rules,
		}
	end):catch(function (error)
		Log.error("StoreService", "Failed to fetch premium storefront %s %s", storefront_key, error)

		return Promise.rejected(error)
	end)

	return store_cache[cache_key].promise:next(function (t)
		return t and table.clone_instance(t)
	end):catch(function (error)
		return Promise.rejected(error)
	end)
end

StoreService.is_featured_store = function (self, key)
	return key == StoreService.FEATURE_KEY
end

local function nop()
	return
end

StoreService.has_new_feature_store = function (self)
	if not self:_get_cached_store(StoreService.FEATURE_KEY, nop) then
		local time_since_launch = Application.time_since_launch()

		if self._get_premium_store_last_call_time then
			local time_since_last_call = time_since_launch - self._get_premium_store_last_call_time

			if time_since_last_call < StoreService.GET_PREMIUM_STORE_TIMEOUT then
				return
			end
		end

		self._get_premium_store_last_call_time = time_since_launch

		self:get_premium_store(StoreService.FEATURE_KEY)
	end

	local current_store_id = self._current_store_id
	local saved_store_id = Managers.save:account_data().last_seen_store_id

	return current_store_id and current_store_id ~= saved_store_id
end

StoreService.invalidate_store_cache = function (self, cache_key, store_front, reason, offer)
	if offer and not offer:is_personal() then
		return
	end

	self._store_cache[cache_key] = nil
end

return StoreService
