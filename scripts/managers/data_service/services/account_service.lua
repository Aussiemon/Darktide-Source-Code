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
local AchievementData = require("scripts/managers/achievements/achievement_data")
local AchievementUITypes = require("scripts/settings/achievements/achievement_ui_types")
local BackendError = require("scripts/managers/error/errors/backend_error")
local GameVersionError = require("scripts/managers/error/errors/game_version_error")
local MasterItems = require("scripts/backend/master_items")
local PlayerManager = require("scripts/foundation/managers/player/player_manager")
local Promise = require("scripts/foundation/utilities/promise")
local SignInError = require("scripts/managers/error/errors/sign_in_error")
local AccountService = class("AccountService")

AccountService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._get_achievements_promise = Promise.resolved()
end

local function _init_network_client(account_id)
	local connection_manager = Managers.connection

	if connection_manager.platform == "wan_client" and not connection_manager:is_initialized() then
		connection_manager:initialize_wan_client(account_id)
	end
end

AccountService.signin = function (self)
	return Managers.backend:authenticate():next(function (auth_data)
		local account_id = auth_data.sub

		_init_network_client(account_id)

		local status_promise = Managers.backend.interfaces.version_check:status()
		local settings_promise = Managers.backend.interfaces.game_settings:resolve_backend_game_settings()
		local items_promise = MasterItems.refresh()
		local auth_data_promise = Promise.resolved(auth_data)
		local immaterium_connection_info = Managers.backend.interfaces.immaterium:fetch_connection_info()
		local sync_achievement_rewards_promise = Managers.achievements:sync_achievement_data(account_id)

		return Promise.all(status_promise, settings_promise, items_promise, auth_data_promise, immaterium_connection_info, sync_achievement_rewards_promise)
	end):next(function (results)
		local status, _, _, auth_data, immaterium_connection_info = unpack(results)

		if status then
			local profiles_promise = Managers.data_service.profiles:fetch_all_profiles()
			local has_created_first_character_promise = self:_has_created_first_character()
			local auth_data_promise = Promise.resolved(auth_data)
			local immaterium_connect_promise = Managers.grpc:connect_to_immaterium(immaterium_connection_info)

			return Promise.all(profiles_promise, has_created_first_character_promise, auth_data_promise, immaterium_connect_promise)
		else
			return Promise.rejected({
				description = "VERSION_ERROR"
			})
		end
	end):next(function (results)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-5, warpins: 1 ---
		local profile_data, has_created_first_character, auth_data, immaterium_connect_error = unpack(results)

		if immaterium_connect_error then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 6-9, warpins: 1 ---
			return Promise.rejected({
				description = "IMMATERIUM_CONNECT_ERROR"
			})
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 10-20, warpins: 2 ---
		return Promise.resolved({
			profiles = profile_data.profiles,
			selected_profile = profile_data.selected_profile,
			has_created_first_character = has_created_first_character,
			account_id = auth_data.sub
		})
		--- END OF BLOCK #1 ---



	end):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-3, warpins: 1 ---
		if error.description == "VERSION_ERROR" then

			-- Decompilation error in this vicinity:
			--- BLOCK #0 4-14, warpins: 1 ---
			Managers.error:report_error(GameVersionError:new(error))
			--- END OF BLOCK #0 ---



		else

			-- Decompilation error in this vicinity:
			--- BLOCK #0 15-24, warpins: 1 ---
			Managers.error:report_error(SignInError:new(error))
			--- END OF BLOCK #0 ---



		end

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 25-25, warpins: 2 ---
		return
		--- END OF BLOCK #1 ---



	end)
end

AccountService._has_created_first_character = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-12, warpins: 1 ---
	return Managers.backend.interfaces.account:get_has_created_first_character():next(function (value)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-2, warpins: 1 ---
		return value == true or value == "true"
		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 8-8, warpins: 2 ---
		--- END OF BLOCK #1 ---



	end)
	--- END OF BLOCK #0 ---



end

AccountService.set_has_created_first_character = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-13, warpins: 1 ---
	return Managers.backend.interfaces.account:set_has_created_first_character("true"):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-14, warpins: 1 ---
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

AccountService.set_selected_character_id = function (self, character_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-13, warpins: 1 ---
	return Managers.backend.interfaces.account:set_selected_character(character_id):catch(function (error)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-14, warpins: 1 ---
		Managers.error:report_error(BackendError:new(error))

		return Promise.rejected({})
		--- END OF BLOCK #0 ---



	end)
	--- END OF BLOCK #0 ---



end

AccountService.pull_achievement_data = function (self, optional_account_id, optional_achievement_definitions)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-2, warpins: 1 ---
	local achievement_definitions = optional_achievement_definitions or Managers.achievements:get_achievement_definitions()
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-23, warpins: 2 ---
	local achievement_data_promise = Managers.backend.interfaces.commendations:get_commendations(optional_account_id, false, true):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-6, warpins: 1 ---
		local achievement_data = AchievementData()

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 7-12, warpins: 0 ---
		for _, stat in ipairs(data.stats) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 7-10, warpins: 1 ---
			achievement_data.stats[stat.stat] = stat.value
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 11-12, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 13-17, warpins: 1 ---
		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 18-51, warpins: 0 ---
		for i = 1, #data.commendations, 1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 18-25, warpins: 2 ---
			local achievement = data.commendations[i]
			local achievement_id = achievement.id
			local is_achievement = achievement_definitions._lookup[achievement_id] ~= nil
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 29-31, warpins: 2 ---
			local is_complete = achievement.complete

			if is_achievement and is_complete then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 34-36, warpins: 1 ---
				achievement_data.completed[achievement_id] = (is_complete and (achievement.at or true)) or nil
				--- END OF BLOCK #0 ---

				FLOW; TARGET BLOCK #1



				-- Decompilation error in this vicinity:
				--- BLOCK #1 43-44, warpins: 3 ---
				--- END OF BLOCK #1 ---



			else

				-- Decompilation error in this vicinity:
				--- BLOCK #0 45-50, warpins: 2 ---
				Log.warning("AccountService", "Received unknown achievement %s from the backend.", achievement_id)
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #1 ---

			FLOW; TARGET BLOCK #2



			-- Decompilation error in this vicinity:
			--- BLOCK #2 51-51, warpins: 2 ---
			--- END OF BLOCK #2 ---



		end

		--- END OF BLOCK #3 ---

		FLOW; TARGET BLOCK #4



		-- Decompilation error in this vicinity:
		--- BLOCK #4 52-52, warpins: 1 ---
		return achievement_data
		--- END OF BLOCK #4 ---



	end)

	return achievement_data_promise
	--- END OF BLOCK #1 ---



end

local function _should_include_achievement(achievement_definition, achievement_data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-11, warpins: 1 ---
	local is_visible = achievement_definition:is_visible(achievement_data)
	local is_feat_of_strength = achievement_definition:ui_type() == AchievementUITypes.feat_of_strength

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 15-16, warpins: 2 ---
	return not is_feat_of_strength or is_visible
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 22-22, warpins: 3 ---
	--- END OF BLOCK #2 ---



end

local function _ui_achievement(index, achievement_definition, achievement_data)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-69, warpins: 1 ---
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
		score = achievement_definition:score(),
		platform_achievement = achievement_definition:is_platform()
	}
	--- END OF BLOCK #0 ---



end

AccountService.get_achievements = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	local get_achievements_promise = self._get_achievements_promise

	if get_achievements_promise:is_pending() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 7-7, warpins: 1 ---
		return get_achievements_promise
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 8-18, warpins: 1 ---
	get_achievements_promise = self:pull_achievement_data():next(function (achievement_data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-10, warpins: 1 ---
		local achievement_definitions = Managers.achievements:get_achievement_definitions()
		local ui_achievements = {}

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 11-27, warpins: 0 ---
		for index = 1, #achievement_definitions, 1 do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 11-17, warpins: 2 ---
			local achievement_definition = achievement_definitions[index]

			if _should_include_achievement(achievement_definition, achievement_data) then

				-- Decompilation error in this vicinity:
				--- BLOCK #0 18-26, warpins: 1 ---
				local achievement_id = achievement_definition:id()
				ui_achievements[achievement_id] = _ui_achievement(index, achievement_definition, achievement_data)
				--- END OF BLOCK #0 ---



			end
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 27-27, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 28-28, warpins: 1 ---
		return ui_achievements
		--- END OF BLOCK #2 ---



	end)
	self._get_achievements_promise = get_achievements_promise

	return get_achievements_promise
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 19-19, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

AccountService.unlock_achievement = function (self, achievement_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-19, warpins: 1 ---
	local achievement_definitions = Managers.achievements:get_achievement_definitions()
	local achievement = achievement_definitions.achievement_from_id(achievement_id)

	fassert(achievement, "There is no achievement with id '%s'.", achievement_id)
	fassert(achievement:get_triggers() == nil, "Achievement with id '%s' has a proper trigger and can't be unlocked directly.", achievement_id)

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
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 23-57, warpins: 2 ---
	--- END OF BLOCK #1 ---



end

return AccountService
