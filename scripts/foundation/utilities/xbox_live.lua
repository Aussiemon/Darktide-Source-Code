local Promise = require("scripts/foundation/utilities/promise")
local NO_XBOX_LIVE = "loc_xbox_live_not_available"
local MISSING_XUSER = "loc_xbox_live_missing_user"
local XboxLive = {
	available = function ()
		return Application.xbox_live and Application.xbox_live() == true and not DevParameters.debug_disable_xbox_live
	end
}

XboxLive.user_id = function ()
	local p = Promise:new()

	if XboxLive.available() then
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

XboxLive.user_info = function ()
	return XboxLive.user_id():next(function (user_id)
		return XUser.user_info(user_id)
	end)
end

XboxLive.get_user_profiles = function (xuids)
	return XboxLive.user_id():next(function (user_id)
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

XboxLive.get_user_presence_data = function (xuids)
	return XboxLive.user_id():next(function (user_id)
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

XboxLive.get_avoid_list = function ()
	return XboxLive.user_id():next(function (user_id)
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

XboxLive.get_mute_list = function ()
	return XboxLive.user_id():next(function (user_id)
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

XboxLive.get_activity = function (xuid_string_array)
	XboxLive.user_id():next(function (user_id)
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

XboxLive.set_activity = function (party_id, num_other_members)
	local num_members = num_other_members + 1

	Log.info("XboxLive", "Setting activity... party_id %s, num_members %s", party_id, num_members)
	XboxLive.user_id():next(function (user_id)
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

XboxLive.delete_activity = function ()
	Log.info("XboxLive", "Deleting activity...")
	XboxLive.user_id():next(function (user_id)
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

XboxLive.batch_check_permission = function (permissions, xuids, anonymous_user_types)
	return XboxLive.user_id():next(function (user_id)
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

XboxLive.update_recent_player_teammate = function (xuid)
	XboxLive.user_id():next(function (user_id)
		XboxLiveMPA.update_recent_players(user_id, xuid, XblMultiplayerActivityEncounterType.ENCOUNTER_TYPE_TEAMMATE)
	end):catch(function (error)
		Log.warning("XboxLive", "Failed updating recent player: %s", table.tostring(error))
	end)
end

XboxLive.show_player_profile_card = function (xuid)
	XboxLive.user_id():next(function (user_id)
		local async_block = XAsyncBlock.new_block()

		XGameUI.show_player_profile_card(user_id, async_block, xuid)

		return Managers.xasync:wrap(async_block, XAsyncBlock.release_block)
	end):catch(function (error)
		Log.warning("XboxLive", "Failed showing player profile card: %s", table.tostring(error))
	end)
end

return XboxLive
