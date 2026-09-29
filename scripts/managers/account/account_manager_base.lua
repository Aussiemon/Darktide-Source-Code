-- chunkname: @scripts/managers/account/account_manager_base.lua

local AccountManagerBase = class("AccountManagerBase")
local Promise = require("scripts/foundation/utilities/promise")

AccountManagerBase.init = function (self)
	return
end

AccountManagerBase.destroy = function (self)
	return
end

AccountManagerBase.reset = function (self)
	return
end

AccountManagerBase.update = function (self, dt, t)
	return
end

AccountManagerBase.wanted_transition = function (self)
	return
end

AccountManagerBase.do_re_signin = function (self)
	return false
end

AccountManagerBase.signin_profile = function (self, signin_callback, optional_input_device)
	signin_callback()
end

AccountManagerBase.user_detached = function (self)
	return false
end

AccountManagerBase.leaving_game = function (self)
	return false
end

AccountManagerBase.user_id = function (self)
	return nil
end

AccountManagerBase.platform_user_id = function (self)
	return nil
end

AccountManagerBase.user_display_name = function (self)
	return "n/a"
end

AccountManagerBase.is_guest = function (self)
	return false
end

AccountManagerBase.signin_state = function (self)
	return ""
end

AccountManagerBase.get_privilege = function (self)
	return
end

AccountManagerBase.show_profile_picker = function (self)
	return
end

AccountManagerBase.get_friends = function (self)
	return
end

AccountManagerBase.friends_list_has_changes = function (self)
	return
end

AccountManagerBase.refresh_communication_restrictions = function (self)
	return
end

AccountManagerBase.is_muted = function (self)
	return false
end

AccountManagerBase.is_blocked = function (self)
	return false
end

AccountManagerBase.fetch_crossplay_restrictions = function (self)
	return
end

AccountManagerBase.set_crossplay_restriction = function (self)
	return
end

AccountManagerBase.has_crossplay_restriction = function (self)
	return false
end

AccountManagerBase.verify_user_restriction = function (self)
	return
end

AccountManagerBase.verify_user_restriction_batched = function (self)
	return
end

AccountManagerBase.user_has_restriction = function (self)
	return false
end

AccountManagerBase.user_restriction_verified = function (self)
	return true
end

AccountManagerBase.verify_connection = function (self)
	return true
end

AccountManagerBase.communication_restriction_iteration = function (self)
	return nil
end

AccountManagerBase.return_to_title_screen = function (self)
	return
end

AccountManagerBase.region_has_restriction = function (self, restriction)
	return false
end

AccountManagerBase.open_to_store = function (self, app_id)
	return Promise.resolved({
		success = false
	})
end

AccountManagerBase.is_owner_of = function (self, app_id)
	return Promise.resolved({
		success = false
	})
end

return AccountManagerBase
