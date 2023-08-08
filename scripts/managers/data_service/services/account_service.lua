local AchievementData = require("scripts/managers/achievements/achievement_data")
local AchievementStats = require("scripts/managers/stats/groups/achievement_stats")
local AchievementUITypes = require("scripts/settings/achievements/achievement_ui_types")
local BackendError = require("scripts/managers/error/errors/backend_error")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local GameVersionError = require("scripts/managers/error/errors/game_version_error")
local MasterItems = require("scripts/backend/master_items")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local Promise = require("scripts/foundation/utilities/promise")
local ServiceUnavailableError = require("scripts/managers/error/errors/service_unavailable_error")
local SignInError = require("scripts/managers/error/errors/sign_in_error")
local XboxLiveUtilities = require("scripts/foundation/utilities/xbox_live")
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

		connection_manager:initialize_wan_client(account_id)
	end
end

AccountService.signin = function (self)
	return Managers.backend:authenticate():next(function (auth_data)
		local account_id = auth_data.sub

		_init_network_client(account_id)

		local store_account_verified = Managers.account:verify_gdk_store_account(nil, true)

		if store_account_verified then
			Log.debug("AccountService", "Store account update")
			Managers.backend.interfaces.external_payment:update_account_store_status():next(function ()
				return Managers.backend.interfaces.external_payment:reconcile_pending_txns()
			end):catch(function (error)
				Log.error("AccountService", "Failed setting up platform commerce: %s", table.tostring(error, 10))
			end)
		else
			Log.warning("AccountService", "Store account mismatch detected")
		end

		local migrations_promise = Managers.backend.interfaces.account:check_and_run_migrations(account_id)
		local status_promise = Managers.backend.interfaces.version_check:status()
		local settings_promise = Managers.backend.interfaces.game_settings:resolve_backend_game_settings()
		local items_promise = MasterItems.refresh()
		local auth_data_promise = Promise.resolved(auth_data)
		local immaterium_connection_info = Managers.backend.interfaces.immaterium:fetch_connection_info()
		local sync_achievement_rewards_promise = Managers.achievements:sync_achievement_data(account_id)
		local crafting_costs_promise = Managers.backend.interfaces.crafting:refresh_crafting_costs()

		return migrations_promise:next(function (data)
			local migration_data_promise = Promise.resolved(data)

			return Promise.all(status_promise, settings_promise, items_promise, auth_data_promise, immaterium_connection_info, sync_achievement_rewards_promise, crafting_costs_promise, migration_data_promise)
		end)
	end):next(function (results)
		local status, _, _, auth_data, immaterium_connection_info, _, _, migration_data = unpack(results, 1, 8)

		if status then
			local profiles_promise = Managers.data_service.profiles:fetch_all_profiles()
			local has_created_first_character_promise = self:_has_created_first_character()
			local has_completed_onboarding_promise = Managers.backend.interfaces.account:get_has_completed_onboarding()
			local auth_data_promise = Promise.resolved(auth_data)
			local migration_data_promise = Promise.resolved(migration_data)
			local immaterium_connect_promise = Managers.grpc:connect_to_immaterium(immaterium_connection_info)

			return Promise.all(profiles_promise, has_created_first_character_promise, has_completed_onboarding_promise, auth_data_promise, immaterium_connect_promise, migration_data_promise)
		else
			return Promise.rejected({
				description = "VERSION_ERROR"
			})
		end
	end):next(function (results)
		local profile_data, has_created_first_character, has_completed_onboarding, auth_data, immaterium_connect_error, migration_data = unpack(results, 1, 6)

		if immaterium_connect_error then
			return Promise.rejected({
				description = "IMMATERIUM_CONNECT_ERROR"
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
			migration_data = migration_data
		})
	end):catch(function (error_data)
		if error_data.description == "VERSION_ERROR" then
			Managers.error:report_error(GameVersionError:new(error_data))
		elseif error_data.code == 503 then
			Managers.error:report_error(ServiceUnavailableError:new(error_data))
		else
			Managers.error:report_error(SignInError:new(error_data))
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
	return Managers.backend.interfaces.account:set_selected_character(character_id):catch(function (error)
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

AccountService.pull_achievement_data = function (self, optional_account_id, optional_achievement_definitions)
	local achievement_definitions = optional_achievement_definitions or Managers.achievements:get_achievement_definitions()
	local achievement_data_promise = Managers.backend.interfaces.commendations:get_commendations(optional_account_id, false, true):next(function (data)
		local achievement_data = AchievementData()

		for _, stat in ipairs(data.stats) do
			achievement_data.stats[stat.stat] = stat.value
		end

		for i = 1, #data.commendations do
			local achievement = data.commendations[i]
			local achievement_id = achievement.id
			local is_achievement = achievement_definitions._lookup[achievement_id] ~= nil
			local is_complete = achievement.complete

			if is_achievement and is_complete then
				achievement_data.completed[achievement_id] = is_complete and (achievement.at or true) or nil
			else
				Log.warning("AccountService", "Received unknown achievement %s from the backend.", achievement_id)
			end
		end

		return achievement_data
	end)

	return achievement_data_promise
end

local function _should_include_achievement(achievement_definition, achievement_data)
	local is_visible = achievement_definition:is_visible(achievement_data)
	local is_feat_of_strength = achievement_definition:ui_type() == AchievementUITypes.feat_of_strength

	return not is_feat_of_strength or is_visible
end

local function _ui_achievement(index, achievement_definition, achievement_data)
	return {
		id = achievement_definition:id(),
		type = achievement_definition:ui_type(),
		sort_index = index,
		category = achievement_definition:category(),
		icon = achievement_definition:icon(),
		label = achievement_definition:label(),
		description = achievement_definition:description(),
		progress_current = achievement_definition:get_progress(achievement_data),
		progress_goal = achievement_definition:get_target(achievement_data),
		completed = achievement_definition:is_completed(achievement_data),
		completed_time = achievement_definition:completed_time(achievement_data),
		hidden = not achievement_definition:is_visible(achievement_data),
		related_commendation_ids = achievement_definition:get_related_achievements(),
		rewards = achievement_definition:get_rewards(),
		score = achievement_definition:score()
	}
end

AccountService.get_achievements = function (self)
	local get_achievements_promise = self._get_achievements_promise

	if get_achievements_promise:is_pending() then
		return get_achievements_promise
	end

	get_achievements_promise = self:pull_achievement_data():next(function (achievement_data)
		local achievement_definitions = Managers.achievements:get_achievement_definitions()
		local ui_achievements = {}

		for index = 1, #achievement_definitions do
			local achievement_definition = achievement_definitions[index]

			if _should_include_achievement(achievement_definition, achievement_data) then
				local achievement_id = achievement_definition:id()
				ui_achievements[achievement_id] = _ui_achievement(index, achievement_definition, achievement_data)
			end
		end

		return ui_achievements
	end)
	self._get_achievements_promise = get_achievements_promise

	return get_achievements_promise
end

AccountService.unlock_achievement = function (self, achievement_id)
	local achievement = Managers.achievements:achievement_definition_from_id(achievement_id)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local account_id = player:account_id()
	local update = Managers.backend.interfaces.commendations:create_update(account_id, {}, {
		{
			stat = "none",
			complete = true,
			id = achievement_id
		}
	})

	return Managers.backend.interfaces.commendations:bulk_update_commendations({
		update
	})
end

AccountService.read_stat = function (self, achievement_data, stat_id, ...)
	local stat_definition = AchievementStats.definitions[stat_id]

	return stat_definition:get_value(achievement_data.stats, ...)
end

return AccountService
