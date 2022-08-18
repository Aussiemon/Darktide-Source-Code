-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
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

StoreService.get_marks_store = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	if Managers.backend:authenticated() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 8-27, warpins: 1 ---
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 28-35, warpins: 1 ---
			store_promise = backend_interface.store:get_veteran_marks_store(time_since_launch, character_id)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 36-37, warpins: 1 ---
			if archetype_name == "zealot" then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 38-45, warpins: 1 ---
				store_promise = backend_interface.store:get_zealot_marks_store(time_since_launch, character_id)
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 46-47, warpins: 1 ---
				if archetype_name == "psyker" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 48-55, warpins: 1 ---
					store_promise = backend_interface.store:get_psyker_marks_store(time_since_launch, character_id)
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 56-57, warpins: 1 ---
					if archetype_name == "ogryn" then

						-- Decompilation error in this vicinity:
						--- BLOCK #0 58-64, warpins: 1 ---
						store_promise = backend_interface.store:get_ogryn_marks_store(time_since_launch, character_id)
						--- END OF BLOCK #0 ---



					end
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 65-73, warpins: 5 ---
		return store_promise:catch(function (error)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-7, warpins: 1 ---
			Log.error("StoreService", "Error fetching marks store: %s", error)

			return
			--- END OF BLOCK #0 ---



		end):next(function (store_catalogue)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-3, warpins: 1 ---
			local offers, current_rotation_end = nil

			if store_catalogue then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 4-5, warpins: 1 ---
				local store_data = store_catalogue.data
				offers = store_data.public_filtered
				--- END OF BLOCK #0 ---



			end

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 6-8, warpins: 2 ---
			return {
				offers = offers or {}
			}
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 10-11, warpins: 2 ---
			--- END OF BLOCK #2 ---



		end)
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 74-74, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

StoreService.get_marks_store_temporary = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-7, warpins: 1 ---
	if Managers.backend:authenticated() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 8-27, warpins: 1 ---
		local backend_interface = self._backend_interface
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		local archetype_name = player:archetype_name()
		local store_promise = nil
		local time_since_launch = Application.time_since_launch()

		if archetype_name == "veteran" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 28-35, warpins: 1 ---
			store_promise = backend_interface.store:get_veteran_marks_store(time_since_launch, character_id)
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 36-37, warpins: 1 ---
			if archetype_name == "zealot" then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 38-45, warpins: 1 ---
				store_promise = backend_interface.store:get_zealot_marks_store(time_since_launch, character_id)
				--- END OF BLOCK #0 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 46-47, warpins: 1 ---
				if archetype_name == "psyker" then

					-- Decompilation error in this vicinity:
					--- BLOCK #0 48-55, warpins: 1 ---
					store_promise = backend_interface.store:get_psyker_marks_store(time_since_launch, character_id)
					--- END OF BLOCK #0 ---



				else

					-- Decompilation error in this vicinity:
					--- BLOCK #0 56-57, warpins: 1 ---
					if archetype_name == "ogryn" then

						-- Decompilation error in this vicinity:
						--- BLOCK #0 58-64, warpins: 1 ---
						store_promise = backend_interface.store:get_ogryn_marks_store(time_since_launch, character_id)
						--- END OF BLOCK #0 ---



					end
					--- END OF BLOCK #0 ---



				end
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 65-73, warpins: 5 ---
		return store_promise:catch(function (error)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-7, warpins: 1 ---
			Log.error("StoreService", "Error fetching credits store: %s", error)

			return
			--- END OF BLOCK #0 ---



		end):next(function (store_catalogue)

			-- Decompilation error in this vicinity:
			--- BLOCK #0 1-3, warpins: 1 ---
			local offers, current_rotation_end = nil

			if store_catalogue then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 4-6, warpins: 1 ---
				local store_data = store_catalogue.data
				offers = store_data.personal
				current_rotation_end = store_data.currentRotationEnd
				--- END OF BLOCK #0 ---



			end

			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 7-9, warpins: 2 ---
			return {
				offers = offers or {},
				current_rotation_end = current_rotation_end
			}
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 11-13, warpins: 2 ---
			--- END OF BLOCK #2 ---



		end)
		--- END OF BLOCK #1 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 74-74, warpins: 2 ---
	return
	--- END OF BLOCK #1 ---



end

StoreService.purchase_item = function (self, offer)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local price = offer.price
	local amount = price.amount
	local wallet_type = amount.type
	local wallet_promise = nil

	if wallet_type == "credits" then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-26, warpins: 1 ---
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()
		wallet_promise = Managers.backend.interfaces.wallet:character_wallets(character_id)
		--- END OF BLOCK #0 ---



	else

		-- Decompilation error in this vicinity:
		--- BLOCK #0 27-34, warpins: 1 ---
		wallet_promise = Managers.backend.interfaces.wallet:account_wallets()
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 35-47, warpins: 2 ---
	return wallet_promise:next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-9, warpins: 1 ---
		local wallet = data:by_type(wallet_type)

		return offer:make_purchase(wallet)
		--- END OF BLOCK #0 ---



	end):next(function (result)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-6, warpins: 1 ---
		Log.info("StoreService", "purchase_item done")

		return result
		--- END OF BLOCK #0 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-10, warpins: 1 ---
		Log.error("StoreService", "Error purchase_item: %s", error)

		return Promise.rejected(error)
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #1 ---



end

StoreService.combined_wallets = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-23, warpins: 1 ---
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local promise = Managers.backend.interfaces.wallet:combined_wallets(character_id)

	return promise:catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-7, warpins: 1 ---
		Log.error("StoreService", "Failed to fetch player combined wallets %s", error)

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

StoreService.account_wallets = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-12, warpins: 1 ---
	local promise = Managers.backend.interfaces.wallet:account_wallets()

	return promise:catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-7, warpins: 1 ---
		Log.error("StoreService", "Failed to fetch player account wallets %s", error)

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

StoreService.character_wallets = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-13, warpins: 1 ---
	local promise = Managers.backend.interfaces.wallet:character_wallets(character_id)

	return promise:catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-7, warpins: 1 ---
		Log.error("StoreService", "Failed to fetch player character wallets %s", error)

		return
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

return StoreService
