﻿-- chunkname: @scripts/foundation/utilities/xbox_live_utils.lua

local Promise = require("scripts/foundation/utilities/promise")
local FGRLLimits = require("scripts/foundation/utilities/fgrl_limits")
local NO_XBOX_LIVE = "loc_xbox_live_not_available"
local MISSING_XUSER = "loc_xbox_live_missing_user"
local HRESULT_NO_CHANGE = -2145844944

local function _handle_error(error_data)
	if error_data.error_handled then
		return Promise.rejected(error_data)
	end

	local header = error_data.header and error_data.header .. ": " or ""

	if error_data.message then
		Log.error("XboxLive", header .. "%s", error_data.message)
	elseif error_data.error_code then
		Log.error("XboxLive", header .. "0x%x", tostring(error_data.error_code))
	else
		Log.error("XboxLive", header .. "%s", table.tostring(error_data))
	end

	error_data.error_handled = true

	return Promise.rejected(error_data)
end

local XboxLiveUtils = {}

XboxLiveUtils.available = function ()
	local connection_verified = Managers.account and Managers.account:verify_connection()
	local is_available = connection_verified and Application.xbox_live and Application.xbox_live() == true and not DevParameters.debug_disable_xbox_live

	if is_available then
		return Promise.resolved()
	else
		return Promise.rejected({
			header = "XboxLiveUtils.available()",
			message = Localize(NO_XBOX_LIVE),
		})
	end
end

XboxLiveUtils.user_id = function ()
	return XboxLiveUtils.available():next(function ()
		local user_id = Managers.account:user_id()

		if user_id then
			return Promise.resolved(user_id)
		else
			return Promise.rejected({
				header = "XboxLiveUtils.user_id()",
				message = Localize(MISSING_XUSER),
			})
		end
	end):catch(_handle_error)
end

XboxLiveUtils.user_info = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		return XUser.user_info(user_id)
	end):catch(function (error_data)
		error_data.header = "XboxLiveUtils.user_info()"

		return _handle_error(error_data)
	end)
end

XboxLiveUtils.get_user_profiles = function (xuids)
	return XboxLiveUtils.user_id():next(function (user_id)
		local profiles_async, error_code, error_message = XboxLiveProfile.get_user_profiles(user_id, xuids)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveProfile.get_user_profiles",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveProfile.get_user_profiles",
				message = error_message,
			})
		end

		return Managers.xasync:wrap(profiles_async)
	end):next(function (async_block)
		local profiles, error_code = XboxLiveProfile.get_user_profiles_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveProfile.get_user_profiles_result",
				error_code = error_code,
			})
		end

		return profiles
	end):catch(_handle_error)
end

XboxLiveUtils.get_user_presence_data = function (xuids)
	return XboxLiveUtils.user_id():next(function (user_id)
		local profiles_async, error_code, error_message = XSocial.get_user_presence_data(user_id, xuids)

		if error_code then
			return Promise.rejected({
				header = "XSocial.get_user_presence_data",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XSocial.get_user_presence_data",
				message = error_message,
			})
		end

		return Managers.xasync:wrap(profiles_async)
	end):next(function (async_block)
		local user_states, error_code = XSocial.get_user_presence_data_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XSocial.get_user_presence_data_result",
				error_code = error_code,
			})
		end

		return user_states
	end):catch(_handle_error)
end

XboxLiveUtils.get_block_list = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local avoid_list_async, error_code, error_message = XboxLivePrivacy.get_avoid_list(user_id)

		if error_code then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_avoid_list",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_avoid_list",
				message = error_message,
			})
		end

		return Managers.xasync:wrap(avoid_list_async)
	end):next(function (async_block)
		local avoid_list, error_code = XboxLivePrivacy.get_avoid_list_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_avoid_list_result",
				error_code = error_code,
			})
		end

		return avoid_list
	end):catch(_handle_error)
end

XboxLiveUtils.get_mute_list = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local mute_list_async, error_code, error_message = XboxLivePrivacy.get_mute_list(user_id)

		if error_code then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_mute_list",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_mute_list",
				message = error_message,
			})
		end

		return Managers.xasync:wrap(mute_list_async)
	end):next(function (async_block)
		local mute_list, error_code = XboxLivePrivacy.get_mute_list_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XboxLivePrivacy.get_mute_list_result",
				error_code = error_code,
			})
		end

		return mute_list
	end):catch(_handle_error)
end

XboxLiveUtils.get_activity = function (xuid_string_array)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error_code, error_message = XboxLiveMPA.get_activity(user_id, xuid_string_array)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveMPA.get_activity",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveMPA.get_activity",
				message = error_message,
			})
		else
			return Managers.xasync:wrap(async_block)
		end
	end):next(function (async_block)
		local result, error_code = XboxLiveMPA.get_activity_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveMPA.get_activity_result",
				error_code = error_code,
			})
		else
			table.dump(result, "RESULT", 2)
		end
	end):catch(_handle_error)
end

XboxLiveUtils.set_activity = function (connection_string, party_id, num_other_members, join_restriction)
	local num_members = num_other_members + 1

	Log.info("XboxLive", "Setting activity... connection_string: %s, party_id %s, num_members %s", connection_string, party_id, num_members)
	XboxLiveUtils.user_id():next(function (user_id)
		local group_id = party_id

		join_restriction = join_restriction or XblMultiplayerActivityJoinRestriction.JOIN_RESTRICTION_PUBLIC

		local max_num_members = 4
		local allow_cross_platform_join = true
		local async_block, error_code, error_message = XboxLiveMPA.set_activity(user_id, connection_string, group_id, join_restriction, num_members, max_num_members, allow_cross_platform_join)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveMPA.set_activity",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveMPA.set_activity",
				message = error_message,
			})
		else
			return Managers.xasync:wrap(async_block)
		end
	end):next(function (_)
		Log.info("XboxLive", "Success setting activity")
	end):catch(_handle_error)
end

XboxLiveUtils.delete_activity = function ()
	Log.info("XboxLive", "Deleting activity...")
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error_code, error_message = XboxLiveMPA.delete_activity(user_id)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveMPA.delete_activity",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveMPA.delete_activity",
				message = error_message,
			})
		else
			return Managers.xasync:wrap(async_block)
		end
	end):next(function (_)
		Log.info("XboxLive", "Success deleting activity")
	end):catch(_handle_error)
end

XboxLiveUtils.batch_check_permission = function (permissions, xuids, anonymous_user_types)
	return XboxLiveUtils.user_id():next(function (user_id)
		local batch_check_permission_async, error_code, error_message = XboxLivePrivacy.batch_check_permission(user_id, permissions, xuids, anonymous_user_types)

		if error_code then
			return Promise.rejected({
				header = "XboxLivePrivacy.batch_check_permission",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLivePrivacy.batch_check_permission",
				message = error_message,
			})
		end

		return Managers.xasync:wrap(batch_check_permission_async):next(function (async_block)
			local result, error_code = XboxLivePrivacy.batch_check_permission_result(async_block)

			if error_code then
				return Promise.rejected({
					header = "XboxLivePrivacy.batch_check_permission_result",
					error_code = error_code,
				})
			end

			return result
		end)
	end):catch(_handle_error)
end

XboxLiveUtils.update_recent_player_teammate = function (xuid)
	return XboxLiveUtils.user_id():next(function (user_id)
		local _, _, error_message = XboxLiveMPA.update_recent_players(user_id, xuid, XblMultiplayerActivityEncounterType.ENCOUNTER_TYPE_TEAMMATE)

		if error_message then
			return Promise.rejected({
				header = "XboxLiveMPA.update_recent_players",
				message = error_message,
			})
		end
	end):catch(function (error_data)
		error_data.header = "XboxLiveUtils.update_recent_player_teammate"

		return _handle_error(error_data)
	end)
end

XboxLiveUtils.show_player_profile_card = function (xuid)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block = XGameUI.new_block()

		XGameUI.show_player_profile_card(user_id, async_block, xuid)

		return Managers.xasync:wrap(async_block)
	end):catch(function (error_data)
		error_data.header = "XboxLiveUtils.show_player_profile_card"

		return _handle_error(error_data)
	end)
end

XboxLiveUtils.update_achievement = function (achievement_id, progress)
	XboxLiveUtils.user_id():next(function (user_id)
		local async_block, error_code, error_message = XboxLiveAchievement.update_achievement(user_id, achievement_id, progress)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveAchievement.update_achievement",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveAchievement.update_achievement",
				message = error_message,
			})
		else
			return Managers.xasync:wrap(async_block)
		end
	end):next(function ()
		Log.debug("XboxLive", "Update achievement success.")
	end):catch(_handle_error)
end

XboxLiveUtils.get_all_achievements = function ()
	return XboxLiveUtils.user_id():next(function (user_id)
		local achievements_async, error_code, error_message = XboxLiveAchievement.get_achievement_async(user_id, XboxLiveAchievement.ACHIEVEMENT_TYPE_ALL, false, XboxLiveAchievement.ACHIEVEMENT_ORDER_BY_DEFAULT_ORDER, 0, 37)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveAchievement.get_achievement_async",
				error_code = error_code,
			})
		elseif error_message then
			return Promise.rejected({
				header = "XboxLiveAchievement.get_achievement_async",
				message = error_message,
			})
		else
			return Managers.xasync:wrap(achievements_async)
		end
	end):next(function (async_block)
		local achievement_result, error_code = XboxLiveAchievement.get_achievement_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "XboxLiveAchievement.get_achievement_result",
				error_code = error_code,
			})
		else
			local achievement_count, achievements, error_code = XboxLiveAchievement.result_get_achievements(achievement_result)

			if error_code then
				return Promise.rejected({
					header = "XboxLiveAchievement.result_get_achievements",
					error_code = error_code,
				})
			else
				achievements = achievements or {}

				Log.debug("XboxLive", "Achievements %s : %s", achievement_count, table.tostring(achievements, 99))

				return achievements
			end
		end
	end):catch(_handle_error)
end

XboxLiveUtils.title_storage_download = function (blob_path, blob_type, storage_type, buffer_size)
	return XboxLiveUtils.user_id():next(function (user_id)
		local has_user_context = XboxLive.has_user_context(user_id)

		if has_user_context then
			return user_id
		else
			local async_result, error_code, error_message = XboxLive.create_user_context(user_id)

			if error_code then
				return Promise.rejected({
					header = "XboxLive.create_user_context",
					error_code = error_code,
				})
			elseif error_message then
				return Promise.rejected({
					header = "XboxLive.create_user_context",
					message = error_message,
				})
			else
				return Managers.xasync:wrap(async_result):next(function ()
					return user_id
				end)
			end
		end
	end):next(function (user_id)
		local async_result, error_code = TitleStorage.blob_download_async(user_id, blob_path, blob_type, storage_type, buffer_size)

		if error_code then
			return Promise.rejected({
				header = "TitleStorage.blob_download_async",
				error_code = error_code,
			})
		else
			return Managers.xasync:wrap(async_result)
		end
	end):next(function (async_block)
		local download_result, download_size, error_code = TitleStorage.get_blob_download_result(async_block)

		if error_code then
			return Promise.rejected({
				header = "TitleStorage.get_blob_download_result",
				error_code = error_code,
			})
		else
			return download_result
		end
	end):catch(_handle_error)
end

XboxLiveUtils.get_entitlements = function ()
	return XboxLiveUtils.available():next(function (user_id)
		local result_by_id = {}
		local result, async_job, async_job_next_page, error_code, error_message

		async_job, error_code, error_message = XStore.query_entitlements_async({
			"consumable",
			"unmanaged",
		})

		if not async_job then
			if error_message then
				return Promise.rejected({
					header = "XStore.query_entitlements_async",
					message = error_message,
				})
			else
				return Promise.rejected({
					header = "XStore.query_entitlements_async",
					message = string.format("query_entitlements_async returned error_code=0x%x", error_code),
				})
			end
		end

		return Promise.until_value_is_true(function ()
			local current_job = async_job_next_page or async_job

			if XAsyncBlock.status(current_job) == HRESULT.E_PENDING then
				return false
			end

			if async_job_next_page then
				result, async_job_next_page, error_code = XStore.products_query_next_page_result(async_job_next_page)
			else
				result, async_job_next_page, error_code = XStore.query_entitlements_async_result(async_job)
			end

			if error_code then
				if result ~= nil then
					Log.error("XboxLive", string.format("Failed to fetch next page to entitlements, error_code=0x%x", error_code))
				else
					Log.error("XboxLive", string.format("Failed to fetch entitlements, error_code=0x%x", error_code))
				end

				return {
					success = false,
					code = error_code,
				}
			end

			if result ~= nil and error_code == nil then
				for _, v in ipairs(result) do
					result_by_id[v.storeId] = v
				end

				if async_job_next_page then
					return false
				end

				return {
					success = true,
					data = result_by_id,
				}
			end

			return false
		end)
	end):catch(_handle_error)
end

XboxLiveUtils.get_associated_products = function ()
	return XboxLiveUtils.available():next(function (user_id)
		local result_by_id = {}
		local result, async_job, async_job_next_page, error_code, error_message

		async_job, error_code, error_message = XStore.query_associated_products_async({
			"consumable",
			"unmanaged",
		})

		if not async_job then
			if error_message then
				return Promise.rejected({
					header = "XStore.query_associated_products_async",
					message = error_message,
				})
			else
				return Promise.rejected({
					header = "XStore.query_associated_products_async",
					message = string.format("query_associated_products_async returned error_code=0x%x", error_code),
				})
			end
		end

		return Promise.until_value_is_true(function ()
			local current_job = async_job_next_page or async_job

			if XAsyncBlock.status(current_job) == HRESULT.E_PENDING then
				return false
			end

			if async_job_next_page then
				result, async_job_next_page, error_code = XStore.products_query_next_page_result(async_job_next_page)
			else
				result, async_job_next_page, error_code = XStore.query_associated_products_async_result(async_job)
			end

			if error_code then
				if result ~= nil then
					Log.error("XboxLive", string.format("Failed to fetch next page to associated products, error_code=0x%x", error_code))
				else
					Log.error("XboxLive", string.format("Failed to fetch associated products, error_code=0x%x", error_code))
				end

				return {
					success = false,
					code = error_code,
				}
			end

			if result ~= nil and error_code == nil then
				for _, v in ipairs(result) do
					result_by_id[v.storeId] = v
				end

				if async_job_next_page then
					return false
				end

				return {
					success = true,
					data = result_by_id,
				}
			end

			return false
		end)
	end):catch(_handle_error)
end

return XboxLiveUtils
