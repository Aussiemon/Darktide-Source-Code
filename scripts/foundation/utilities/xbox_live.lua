local Promise = require("scripts/foundation/utilities/promise")
local NO_XBOX_LIVE = "loc_xbox_live_not_available"
local MISSING_XUSER = "loc_xbox_live_missing_user"
local HRESULT_NO_CHANGE = -2145844944
local XboxLiveUtils = {
	available = function ()
		return Application.xbox_live and Application.xbox_live() == true and not DevParameters.debug_disable_xbox_live
	end
}

XboxLiveUtils.user_id = function ()
	local p = Promise:new()

	if XboxLiveUtils.available() then
		local user_id = Managers.account:user_id()

		if user_id then
			p:resolve(user_id)
		else
			p:reject({
				message = Localize(MISSING_XUSER)
			})
		end
	else
		p:reject({
			message = Localize(NO_XBOX_LIVE)
		})
	end

	return p
end

XboxLiveUtils.user_info = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		return XUser.user_info(user_id)
	end)
end

XboxLiveUtils.get_user_profiles = function (xuids)
	return XboxLiveUtils.user_id():next(function (user_id)
		local profiles_async, error = XboxLiveProfile.get_user_profiles(user_id, xuids)

		if error then
			return Promise.rejected({
				error
			})
		end

		return Managers.xasync:wrap(profiles_async, XboxLiveProfile.release_block)
	end):next(function (async_block)
		local profiles, error = XboxLiveProfile.get_user_profiles_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		end

		return profiles
	end)
end

XboxLiveUtils.get_user_presence_data = function (xuids)
	return XboxLiveUtils.user_id():next(function (user_id)
		local profiles_async, error = XSocial.get_user_presence_data(user_id, xuids)

		if error then
			return Promise.rejected({
				error
			})
		end

		return Managers.xasync:wrap(profiles_async, XSocial.release_block)
	end):next(function (async_block)
		local user_states, error = XSocial.get_user_presence_data_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		end

		return user_states
	end)
end

XboxLiveUtils.get_block_list = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local avoid_list_async, error = XboxLivePrivacy.get_avoid_list(user_id)

		if error then
			return Promise.rejected({
				error
			})
		end

		return Managers.xasync:wrap(avoid_list_async, XboxLivePrivacy.release_block)
	end):next(function (async_block)
		local avoid_list, error = XboxLivePrivacy.get_avoid_list_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		end

		return avoid_list
	end)
end

XboxLiveUtils.get_mute_list = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local mute_list_async, error = XboxLivePrivacy.get_mute_list(user_id)

		if error then
			return Promise.rejected({
				error
			})
		end

		return Managers.xasync:wrap(mute_list_async, XboxLivePrivacy.release_block)
	end):next(function (async_block)
		local mute_list, error = XboxLivePrivacy.get_mute_list_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		end

		return mute_list
	end)
end

XboxLiveUtils.get_activity = function (xuid_string_array)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error = XboxLiveMPA.get_activity(user_id, xuid_string_array)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_block, XboxLiveMPA.release_block)
		end
	end):next(function (async_block)
		local result, error = XboxLiveMPA.get_activity_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		else
			table.dump(result, "RESULT", 2)
		end
	end):catch(function (error)
		Log.warning("XboxLive", "Failed getting activity: %s", table.tostring(error))
	end)
end

XboxLiveUtils.set_activity = function (party_id, num_other_members)
	local num_members = num_other_members + 1

	Log.info("XboxLive", "Setting activity... party_id %s, num_members %s", party_id, num_members)
	XboxLiveUtils.user_id():next(function (user_id)
		local group_id = party_id
		local join_restrictions = XblMultiplayerActivityJoinRestriction.JOIN_RESTRICTION_PUBLIC
		local max_num_members = 4
		local allow_cross_platform_join = true
		local async_block, error = XboxLiveMPA.set_activity(user_id, party_id, group_id, join_restrictions, num_members, max_num_members, allow_cross_platform_join)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_block, XboxLiveMPA.release_block)
		end
	end):next(function (_)
		Log.info("XboxLive", "Success setting activity")
	end):catch(function (error)
		Log.warning("XboxLive", "Failed setting activity: %s", table.tostring(error))
	end)
end

XboxLiveUtils.delete_activity = function ()
	Log.info("XboxLive", "Deleting activity...")
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error = XboxLiveMPA.delete_activity(user_id)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_block, XboxLiveMPA.release_block)
		end
	end):next(function (_)
		Log.info("XboxLive", "Success deleting activity")
	end):catch(function (error)
		Log.warning("XboxLive", "Failed deleting activity: %s", table.tostring(error))
	end)
end

XboxLiveUtils.batch_check_permission = function (permissions, xuids, anonymous_user_types)
	return XboxLiveUtils.user_id():next(function (user_id)
		local batch_check_permission_async, error = XboxLivePrivacy.batch_check_permission(user_id, permissions, xuids, anonymous_user_types)

		if error then
			return Promise.rejected({
				error
			})
		end

		return Managers.xasync:wrap(batch_check_permission_async, XboxLivePrivacy.release_block):next(function (async_block)
			local result, error = XboxLivePrivacy.batch_check_permission_result(async_block)

			if error then
				return Promise.rejected({
					error
				})
			end

			return result
		end)
	end)
end

XboxLiveUtils.update_recent_player_teammate = function (xuid)
	XboxLiveUtils.user_id():next(function (user_id)
		XboxLiveMPA.update_recent_players(user_id, xuid, XblMultiplayerActivityEncounterType.ENCOUNTER_TYPE_TEAMMATE)
	end):catch(function (error)
		Log.warning("XboxLive", "Failed updating recent player: %s", table.tostring(error))
	end)
end

XboxLiveUtils.show_player_profile_card = function (xuid)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block = XAsyncBlock.new_block()

		XGameUI.show_player_profile_card(user_id, async_block, xuid)

		return Managers.xasync:wrap(async_block, XAsyncBlock.release_block)
	end):next(function (async_block)
		local h_result = XGameUI.show_player_profile_card_results(async_block)

		if h_result == HRESULT.S_OK then
			Managers.account:refresh_communcation_restrictions()
		end
	end):catch(function (error)
		Log.warning("XboxLive", "Failed showing player profile card: %s", table.tostring(error))
	end)
end

XboxLiveUtils.update_achievement = function (achievement_id, progress)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error = XboxLiveAchievement.update_achievement(user_id, achievement_id, progress)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_block, XboxLiveAchievement.release_async_block)
		end
	end):next(function ()
		Log.debug("XboxLive", "Update achievement success.")
	end):catch(function (error)
		if error[1] ~= HRESULT_NO_CHANGE then
			Log.warning("XboxLive", "Failed updating achievement: '%s'.", table.tostring(error))
		end
	end)
end

XboxLiveUtils.get_all_achievements = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local achievements_async, error = XboxLiveAchievement.get_achievement_async(user_id, XboxLiveAchievement.ACHIEVEMENT_TYPE_ALL, false, XboxLiveAchievement.ACHIEVEMENT_ORDER_BY_DEFAULT_ORDER, 0, 37)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(achievements_async, XboxLiveAchievement.release_async_block)
		end
	end):next(function (async_block)
		local achievement_result, error = XboxLiveAchievement.get_achievement_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		else
			local achievement_count, achievements, error = XboxLiveAchievement.result_get_achievements(achievement_result)

			if error then
				return Promise.rejected({
					error
				})
			else
				achievements = achievements or {}

				Log.debug("XboxLive", "Achievements %s : %s", achievement_count, table.tostring(achievements, 99))

				return achievements
			end
		end
	end):catch(function (error)
		Log.warning("XboxLive", "Failed getting achievements: '%s'.", table.tostring(error))
	end)
end

XboxLiveUtils.title_storage_download = function (blob_path, blob_type, storage_type, buffer_size)
	return XboxLiveUtils.user_id():next(function (user_id)
		local async_result, error = XboxLive.create_user_context(user_id)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_result, XboxLive.release_async_block_create_live_context_async):next(function ()
				return user_id
			end)
		end
	end):next(function (user_id)
		local async_result, error = TitleStorage.blob_download_async(user_id, blob_path, blob_type, storage_type, buffer_size)

		if error then
			return Promise.rejected({
				error
			})
		else
			return Managers.xasync:wrap(async_result, TitleStorage.release_async_block)
		end
	end):catch(function (error)
		Log.warning("XboxLiveUtils", "blob_download_async failure : 0x%x .", error[1])

		return Promise.rejected(error)
	end):next(function (async_block)
		local download_result, download_size, error = TitleStorage.get_blob_download_result(async_block)

		if error then
			return Promise.rejected({
				error
			})
		else
			return download_result
		end
	end):catch(function (error)
		Log.warning("XboxLiveUtils", "get_blob_download_result failure : 0x%x .", error[1])

		return Promise.rejected(error)
	end)
end

XboxLiveUtils.get_entitlements = function ()
	local async_job, error_code = XStore.query_entitlements_async({
		"consumable",
		"unmanaged"
	})

	if not async_job then
		return Promise.rejected({
			message = string.format("query_entitlements_async returned error_code=0x%x", error_code)
		})
	end

	return Promise.until_value_is_true(function ()
		local result, async_job, error_code = XStore.query_entitlements_async_result(async_job)

		if error_code then
			Log.error("XboxLive", string.format("Failed to fetch entitlements, error_code=0x%x", error_code))

			return {
				success = false,
				code = error_code
			}
		end

		if result ~= nil and error_code == nil then
			local result_by_id = {}

			for _, v in ipairs(result) do
				result_by_id[v.storeId] = v
			end

			return {
				success = true,
				data = result_by_id
			}
		end

		return false
	end)
end

XboxLiveUtils.get_associated_products = function ()
	local async_job, error_code = XStore.query_associated_products_async({
		"consumable",
		"unmanaged"
	})

	if not async_job then
		return Promise.rejected({
			message = string.format("query_associated_products_async returned error_code=0x%x", error_code)
		})
	end

	return Promise.until_value_is_true(function ()
		local result, async_job, error_code = XStore.query_associated_products_async_result(async_job)

		if error_code then
			Log.error("XboxLive", string.format("Failed to fetch associated products, error_code=0x%x", error_code))

			return {
				success = false,
				code = error_code
			}
		end

		if result ~= nil and error_code == nil then
			local result_by_id = {}

			for _, v in ipairs(result) do
				result_by_id[v.storeId] = v
			end

			return {
				success = true,
				data = result_by_id
			}
		end

		return false
	end)
end

return XboxLiveUtils
