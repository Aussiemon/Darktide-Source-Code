local FixedFrame = require("scripts/utilities/fixed_frame")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local PlayerSpecializationUtil = require("scripts/utilities/player_specialization/player_specialization")
local Promise = require("scripts/foundation/utilities/promise")
local StoreService = class("StoreService")

StoreService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
end

StoreService.get_credits_store = function (self)
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

StoreService.purchase_item = function (self, offer)
	local price = offer.price
	local amount = price.amount
	local wallet_type = amount.type
	local wallet_promise = nil

	if wallet_type == "credits" or wallet_type == "marks" then
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		wallet_promise = Managers.backend.interfaces.wallet:character_wallets(character_id)
	else
		wallet_promise = Managers.backend.interfaces.wallet:account_wallets()
	end

	return wallet_promise:next(function (data)
		local wallet = data:by_type(wallet_type)

		return offer:make_purchase(wallet)
	end):next(function (result)
		Log.info("StoreService", "purchase_item done")

		return result
	end):catch(function (error)
		Log.error("StoreService", "Error purchase_item: %s", error)

		return Promise.rejected(error)
	end)
end

StoreService.combined_wallets = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local promise = Managers.backend.interfaces.wallet:combined_wallets(character_id)

	return promise:catch(function (error)
		Log.error("StoreService", "Failed to fetch player combined wallets %s", error)
	end)
end

StoreService.account_wallets = function (self)
	local promise = Managers.backend.interfaces.wallet:account_wallets()

	return promise:catch(function (error)
		Log.error("StoreService", "Failed to fetch player account wallets %s", error)
	end)
end

StoreService.character_wallets = function (self, character_id)
	local promise = Managers.backend.interfaces.wallet:character_wallets(character_id)

	return promise:catch(function (error)
		Log.error("StoreService", "Failed to fetch player character wallets %s", error)
	end)
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
