-- chunkname: @scripts/managers/data_service/services/account_service.lua

local BackendError = require("scripts/managers/error/errors/backend_error")
local BanError = require("scripts/managers/error/errors/ban_error")
local ErrorCodes = require("scripts/managers/error/error_codes")
local GameVersionError = require("scripts/managers/error/errors/game_version_error")
local InitializeWanError = require("scripts/managers/error/errors/initialize_wan_error")
local MasterItems = require("scripts/backend/master_items")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local Promise = require("scripts/foundation/utilities/promise")
local ServiceUnavailableError = require("scripts/managers/error/errors/service_unavailable_error")
local SignInError = require("scripts/managers/error/errors/sign_in_error")
local PsPlusError = require("scripts/managers/error/errors/ps_plus_error")
local PSNRestrictions = require("scripts/managers/account/psn_restrictions")
local AccountService = class("AccountService")

AccountService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._get_achievements_promise = Promise.resolved()
	self._has_completed_onboarding = nil
end

local function _init_network_client(account_id)
	local connection_manager = Managers.connection

	if connection_manager.platform == "wan_client" then
		if connection_manager:is_initialized() then
			connection_manager:destroy_wan_client()
		end

		return connection_manager:initialize_wan_client(account_id)
	else
		return true
	end
end

local function _resolve_backend_game_settings()
	return Managers.backend.interfaces.game_settings:resolve_backend_game_settings():next(function ()
		ErrorCodes.apply_backend_game_settings()

		return nil
	end)
end

AccountService.signin = function (self)
	return Managers.backend:authenticate():next(function (auth_data)
		local account_id = auth_data.sub

		if not _init_network_client(account_id) then
			return Promise.rejected({
				description = "INITIALIZE_WAN_ERROR",
			})
		end

		local store_account_verified = true

		if IS_XBS or IS_GDK then
			store_account_verified = Managers.account:verify_gdk_store_account(nil, true)
		end

		if store_account_verified then
			Log.debug("AccountService", "Store account update")
			Managers.backend.interfaces.external_payment:update_account_store_status():next(function ()
				return Managers.backend.interfaces.external_payment:reconcile_pending_txns()
			end):catch(function (error)
				Log.exception("AccountService", "Failed setting up platform commerce: %s", table.tostring(error, 10))
			end)
		else
			Log.warning("AccountService", "Store account mismatch detected")
		end

		local migrations_promise = Managers.backend.interfaces.account:check_and_run_migrations(account_id)
		local status_promise = Managers.backend.interfaces.version_check:status()
		local settings_promise = _resolve_backend_game_settings()
		local items_promise = MasterItems.refresh()
		local auth_data_promise = Promise.resolved(auth_data)
		local immaterium_connection_info = Managers.backend.interfaces.immaterium:fetch_connection_info()
		local crafting_costs_promise = Managers.backend.interfaces.crafting:refresh_all_costs()
		local havoc_settings_promise = Managers.backend.interfaces.havoc:refresh_settings()

		return migrations_promise:next(function (data)
			local migration_data_promise = Promise.resolved(data)
			local promises = {
				status_promise,
				settings_promise,
				items_promise,
				auth_data_promise,
				immaterium_connection_info,
				crafting_costs_promise,
				migration_data_promise,
				havoc_settings_promise,
			}

			return Promise.all(unpack(promises))
		end)
	end):next(function (results)
		local status, _, _, auth_data, immaterium_connection_info, _, migration_data = unpack(results, 1, 8)

		if status then
			local profiles_promise = Managers.data_service.profiles:fetch_all_profiles()
			local has_created_first_character_promise = self:_has_created_first_character()
			local has_completed_onboarding_promise = Managers.backend.interfaces.account:get_has_completed_onboarding()
			local auth_data_promise = Promise.resolved(auth_data)
			local migration_data_promise = Promise.resolved(migration_data)
			local immaterium_connect_promise = Managers.grpc:connect_to_immaterium(immaterium_connection_info)

			Managers.data_service.crafting:warm_trait_sticker_book_cache()

			return Promise.all(profiles_promise, has_created_first_character_promise, has_completed_onboarding_promise, auth_data_promise, immaterium_connect_promise, migration_data_promise)
		else
			return Promise.rejected({
				description = "VERSION_ERROR",
			})
		end
	end):next(function (results)
		local profile_data, has_created_first_character, has_completed_onboarding, auth_data, immaterium_connect_error, migration_data = unpack(results, 1, 6)

		if immaterium_connect_error then
			return Promise.rejected({
				description = "IMMATERIUM_CONNECT_ERROR",
			})
		end

		self._has_completed_onboarding = has_completed_onboarding == true or has_completed_onboarding == "true"

		return Promise.resolved({
			profiles = profile_data.profiles,
			selected_profile = profile_data.selected_profile,
			has_created_first_character = has_created_first_character,
			account_id = auth_data.sub,
			vivox_token = auth_data.vivox_token,
			gear = profile_data.gear,
			migration_data = migration_data,
		})
	end):next(function (results)
		local result_promise = Promise.resolved(results)
		local premium_promise = IS_PLAYSTATION and PSNRestrictions:verify_premium() or Promise.resolved()

		return Promise.all(premium_promise, result_promise)
	end):next(function (results)
		local _, data = unpack(results, 1, 2)

		if IS_PLAYSTATION then
			Managers.account:set_premium_verified(true)
		end

		return Promise.resolved(data)
	end):catch(function (error_data)
		if error_data.description == "VERSION_ERROR" then
			Managers.error:report_error(GameVersionError:new(error_data))
		elseif error_data.description == "INITIALIZE_WAN_ERROR" then
			Managers.error:report_error(InitializeWanError:new(error_data))
		else
			local is_valid_json = error_data.description and string.find(error_data.description, "\":\"") ~= nil
			local decoded_json_data = is_valid_json and cjson.decode(error_data.description)

			if error_data.code == 503 then
				Managers.error:report_error(ServiceUnavailableError:new(error_data))
			elseif error_data.code == 403 and decoded_json_data and decoded_json_data.banned and (decoded_json_data.banned.frozen == true or decoded_json_data.banned.reason ~= nil) then
				Managers.error:report_error(BanError:new(decoded_json_data))
			elseif IS_PLAYSTATION then
				local error, _ = unpack(error_data, 1, 2)

				if error and error.header == PSNRestrictions:verify_premium_header() then
					Managers.error:report_error(PsPlusError:new(error))
				else
					Managers.error:report_error(SignInError:new(error_data))
				end
			else
				Managers.error:report_error(SignInError:new(error_data))
			end
		end
	end)
end

AccountService._has_created_first_character = function (self)
	return Managers.backend.interfaces.account:get_has_created_first_character():next(function (value)
		return value == true or value == "true"
	end)
end

AccountService.set_has_created_first_character = function (self)
	return Managers.backend.interfaces.account:set_has_created_first_character("true"):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

AccountService.set_selected_character_id = function (self, character_id)
	return Managers.backend.interfaces.account:set_selected_character(character_id):next(function ()
		Managers.telemetry_events:character_selected(character_id)
	end):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

AccountService.has_completed_onboarding = function (self)
	return self._has_completed_onboarding
end

AccountService.set_has_completed_onboarding = function (self)
	if self._has_completed_onboarding then
		return
	end

	self._has_completed_onboarding = true

	return Managers.backend.interfaces.account:set_has_completed_onboarding("true"):catch(function (error)
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
	end)
end

AccountService.has_migrated_commendation_score = function (self)
	if self._cached_has_migrated_commendation_score then
		return Promise.resolved(self._cached_has_migrated_commendation_score):next(function (value)
			return value
		end)
	end

	return Managers.backend.interfaces.account:get_has_migrated_commendation_score():next(function (value)
		if value == true then
			self._cached_has_migrated_commendation_score = true
		end

		return value == true or value == "true"
	end)
end

return AccountService
