local InputDevice = require("scripts/managers/input/input_device")
local XboxPrivileges = require("scripts/managers/account/xbox_privileges")
local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local render_settings = require("scripts/settings/options/render_settings")
local AccountManagerXboxLive = class("AccountManagerXboxLive")
local SIGNIN_STATES = {
	loading_save = "loc_signin_load_save",
	idle = "",
	signin_profile = "loc_signin_acquiring_user_profile",
	fetching_privileges = "loc_signin_fetch_privileges",
	querying_storage = "loc_signin_query_storage",
	acquiring_storage = "loc_signin_acquire_storage",
	deleting_save = "loc_signin_delete_save"
}

AccountManagerXboxLive.init = function (self)
	self._popup_id = nil
	self._signin_state = SIGNIN_STATES.idle
	self._xbox_privileges = XboxPrivileges:new()
end

AccountManagerXboxLive.reset = function (self)
	self._signin_callback = nil
	self._popup_id = nil
	self._leave_game = nil
	self._signin_state = SIGNIN_STATES.idle
	self._wanted_state = nil
	self._wanted_state_params = nil

	if not self._do_re_signin then
		self._is_guest = nil
		self._xuid = nil
		self._user_id = nil
		self._gamertag = nil
		self._active_controller = nil
		self._do_re_signin = nil
	end

	Managers.save:release_storage()
end

AccountManagerXboxLive.wanted_transition = function (self)
	return self._wanted_state, self._wanted_state_params
end

AccountManagerXboxLive.do_re_signin = function (self)
	return self._do_re_signin
end

AccountManagerXboxLive.destroy = function (self)
	return
end

AccountManagerXboxLive.user_detached = function (self)
	return self._popup_id or self._leave_game
end

AccountManagerXboxLive.leaving_game = function (self)
	return self._leave_game
end

AccountManagerXboxLive.user_id = function (self)
	return not self._popup_id and self._user_id
end

AccountManagerXboxLive.is_guest = function (self)
	return self._is_guest
end

AccountManagerXboxLive.gamertag = function (self)
	return self._gamertag
end

AccountManagerXboxLive.signin_state = function (self)
	return self._signin_state
end

AccountManagerXboxLive.get_privilege = function (self, privilege)
	return self._xbox_privileges:has_privilege(privilege)
end

AccountManagerXboxLive.update = function (self, dt, t)
	if not self._user_id then
		return
	end

	self:_handle_user_changes(dt, t)
end

AccountManagerXboxLive.show_profile_picker = function (self)
	local success_cb = callback(self, "_cb_profile_selected")
	local async_task = XUser.add_user_async(XUserAddOptions.None)

	Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb)
end

AccountManagerXboxLive.signin_profile = function (self, signin_callback, optional_input_device)
	if self._do_re_signin then
		self._do_re_signin = nil

		self._xbox_privileges:fetch_all_privileges(self._user_id, callback(self, "_cb_privileges_updated"))

		self._signin_state = SIGNIN_STATES.fetching_privileges
	else
		local success_cb = callback(self, "_cb_user_signed_in", optional_input_device)
		local fail_cb = callback(self, "_show_fatal_error", "loc_popup_header_error", "loc_user_signin_failed_desc")
		local async_task = nil
		local users = XUser.users()

		if #users > 1 then
			async_task = XUser.add_user_async(XUserAddOptions.None)
		else
			async_task = XUser.add_user_async(XUserAddOptions.AddDefaultUserAllowingUI)
		end

		Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)

		self._signin_state = SIGNIN_STATES.signin_profile
	end

	self._signin_callback = signin_callback
end

AccountManagerXboxLive._cb_user_signed_in = function (self, optional_input_device, async_block)
	self._do_re_signin = nil
	local user_id = XUser.get_user_result(async_block)
	local user_info = XUser.user_info(user_id)
	self._is_guest = user_info.guest
	self._xuid = user_info.xuid
	self._user_id = user_id
	self._gamertag = XUser.get_gamertag(user_id)

	self:_set_active_device(optional_input_device)
	self._xbox_privileges:fetch_all_privileges(self._user_id, callback(self, "_cb_privileges_updated"))

	self._signin_state = SIGNIN_STATES.fetching_privileges
end

AccountManagerXboxLive._cb_profile_selected = function (self, async_task)
	local user_id = XUser.get_user_result(async_task)
	local user_info = XUser.user_info(user_id)
	local xuid = user_info.xuid
	local gamertag = XUser.get_gamertag(user_id)

	if self._xuid ~= xuid then
		self._gamertag = gamertag
		self._user_id = user_id
		self._xuid = xuid
		self._do_re_signin = true

		self:_return_to_title_screen()
	end
end

AccountManagerXboxLive._set_active_device = function (self, optional_input_device)
	if not optional_input_device then
		return
	end

	local device_type = optional_input_device.type()
	local device_id = optional_input_device.device_id()
	InputDevice.default_device_id[device_type] = device_id
	self._active_controller = optional_input_device
end

AccountManagerXboxLive._cb_privileges_updated = function (self)
	if self._xbox_privileges:has_error() then
		self:_show_fatal_error("loc_popup_header_error", "loc_privilege_fetch_fail_desc")

		return
	end

	if not self._xbox_privileges:has_privilege(XUserPrivilege.Multiplayer) then
		self:_show_fatal_error("loc_popup_header_error", "loc_multiplayer_privilege_fail_desc")

		return
	end

	Managers.save:acquire_storage(self._user_id, callback(self, "_cb_storage_acquired"))

	self._signin_state = SIGNIN_STATES.acquiring_storage
end

AccountManagerXboxLive._cb_storage_acquired = function (self, success)
	if not success then
		self:_show_fatal_error("loc_popup_header_error", "loc_acquire_storage_failed_desc")

		return
	end

	Managers.save:query_storage_containers(callback(self, "_cb_query_storage_results"))

	self._signin_state = SIGNIN_STATES.querying_storage
end

AccountManagerXboxLive._cb_query_storage_results = function (self, success, data)
	if not success then
		self:_show_fatal_error("loc_popup_header_error", "loc_query_storage_failed_desc")

		return
	end

	if self:_save_exists(data) then
		Managers.save:load(callback(self, "_cb_save_loaded"))

		self._signin_state = SIGNIN_STATES.loading_save
	else
		self:_finalize_signin()
	end
end

AccountManagerXboxLive._cb_save_loaded = function (self, success)
	if not success then
		self:_show_fatal_error("loc_popup_header_error", "loc_load_save_failed_desc")

		return
	end

	self:_finalize_signin()
end

AccountManagerXboxLive._cb_storage_deleted = function (self, success)
	if not success then
		self:_show_fatal_error("loc_popup_header_error", "loc_delete_save_failed_desc")

		return
	end

	self:_finalize_signin()
end

AccountManagerXboxLive._finalize_signin = function (self)
	if BUILD ~= "release" then
		ParameterResolver.resolve_dev_parameters()
	end

	local settings = render_settings.settings

	self:_apply_render_settings(settings)
	self._signin_callback()

	self._signin_callback = nil
	self._signin_state = SIGNIN_STATES.idle
end

AccountManagerXboxLive._apply_render_settings = function (self, settings)
	for _, setting in ipairs(settings) do
		if setting.pages then
			for i = 1, #setting.pages, 1 do
				local page_setting = setting.pages[i].entries

				self:_apply_render_settings(page_setting)
			end
		end

		local valid = not setting.validation_function or setting:validation_function()

		if valid then
			local apply_on_startup = setting.apply_on_startup

			if apply_on_startup then
				local get_function = setting.get_function

				if get_function then
					local value = get_function(setting)

					if value ~= nil then
						local on_activated = setting.on_activated

						if on_activated then
							on_activated(value, setting)
						end
					end
				end
			end
		end
	end
end

AccountManagerXboxLive._save_exists = function (self, data)
	local container_info = data.container_info

	if not container_info then
		return false
	end

	local save_container_name = Managers.save:save_container_name()

	for i = 1, #container_info, 1 do
		local container = container_info[i]

		if container.name == save_container_name then
			return true
		end
	end
end

AccountManagerXboxLive._handle_user_changes = function (self, dt, t)
	if self:_work_in_progress() then
		return
	end

	local local_user_changed, user_state_changed, user_privileges_changed, user_device_association_changed = XUser.user_info_changed()

	if local_user_changed then
		print("################## local_user_changed")
		self:_handle_local_user_change()
	elseif user_state_changed then
		print("################## user_state_changed")
		self:_handle_user_state_change()
	elseif user_privileges_changed then
		print("################## user_privileges_changed")
		self:_handle_privilege_change()
	elseif user_device_association_changed then
		print("################## user_device_association_changed")
		self:_handle_user_device_association_change()
	end
end

AccountManagerXboxLive._work_in_progress = function (self)
	return self._popup_id or self._do_re_signin or self._leave_game or Managers.xasync:in_progress()
end

AccountManagerXboxLive._handle_local_user_change = function (self)
	local profile_active = self:_update_active_profile()

	if not profile_active then
		self:_handle_user_device_association_change()
	end
end

AccountManagerXboxLive._update_active_profile = function (self)
	local profile_active = false
	local user = self:_find_user()

	if user then
		self._is_guest = user.guest
		self._user_id = user.id
		local state = XUser.get_state(user.id)
		profile_active = state ~= XUserState.SignedOut
	end

	return profile_active
end

AccountManagerXboxLive._find_user = function (self)
	local users = XUser.users()

	for i = 1, #users, 1 do
		local user = users[i]

		if user.xuid == self._xuid then
			return user
		end
	end
end

AccountManagerXboxLive._handle_user_state_change = function (self)
	local user = self:_find_user()

	if user then
		local state = XUser.get_state(user.id)

		if state == XUserState.SignedIn then
			print("### XUserState.SignedIn ###")
		elseif state == XUserState.SignedOut then
			print("### XUserState.SignedOut ###")
			self:_show_signed_out_error()
		elseif state == XUserState.SigningOut then
			print("### XUserState.SigningOut ###")
		end
	end
end

AccountManagerXboxLive._handle_privilege_change = function (self)
	self._xbox_privileges:update_privileges(self._user_id)

	if not self._xbox_privileges:has_privilege(XUserPrivilege.Multiplayer) then
		self:_show_fatal_error("loc_popup_header_error", "loc_signed_in_multiplayer_privilege_fail_desc")
	end
end

AccountManagerXboxLive._handle_user_device_association_change = function (self)
	if self._popup_id then
		return
	end

	if self._active_controller then
		if not self._active_controller.active() then
			self:_show_disconnect_error()
		else
			local success_cb = callback(self, "_cb_from_device_async")
			local fail_cb = callback(self, "_show_disconnect_error")
			local async_task = XUser.from_device_async(self._active_controller.device_pointer())

			Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)
		end
	else
		self:_show_disconnect_error()
	end
end

AccountManagerXboxLive._cb_from_device_async = function (self, async_task)
	local user_id = XUser.from_device_result(async_task)
	local user_info = (user_id and XUser.user_info(user_id)) or nil

	if not user_info or user_info.xuid ~= self._xuid then
		self:_show_disconnect_error()
	else
		self._user_id = user_id
	end
end

AccountManagerXboxLive._show_disconnect_error = function (self)
	local device_type = self._active_controller.type()
	InputDevice.default_device_id[device_type] = nil
	local context = {
		title_text = "loc_popup_header_controller_disconnect_error",
		description_text = "loc_popup_desc_signed_out_error",
		description_text_params = {
			gamertag = self._gamertag
		},
		options = {
			{
				text = "loc_retry",
				close_on_pressed = true,
				callback = callback(self, "_cb_verify_profile")
			},
			{
				text = "loc_select_profile",
				close_on_pressed = true,
				callback = callback(self, "_cb_open_profile_picker")
			},
			{
				text = "loc_exit_to_main_menu_display_name",
				close_on_pressed = true,
				callback = callback(self, "_return_to_title_screen")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_id = id
	end)
end

AccountManagerXboxLive._show_signed_out_error = function (self)
	local device_type = self._active_controller.type()
	InputDevice.default_device_id[device_type] = nil
	local context = {
		title_text = "loc_popup_header_signed_out_error",
		description_text = "loc_popup_desc_signed_out_error",
		description_text_params = {
			gamertag = self._gamertag
		},
		options = {
			{
				text = "loc_retry",
				close_on_pressed = true,
				callback = callback(self, "_cb_verify_profile")
			},
			{
				text = "loc_select_profile",
				close_on_pressed = true,
				callback = callback(self, "_cb_open_profile_picker")
			},
			{
				text = "loc_exit_to_main_menu_display_name",
				close_on_pressed = true,
				callback = callback(self, "_return_to_title_screen")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_id = id
	end)
end

AccountManagerXboxLive._show_fatal_error = function (self, title_text, description_text)
	local context = {
		title_text = title_text,
		description_text = description_text,
		options = {
			{
				text = "loc_popup_button_close",
				close_on_pressed = true,
				callback = callback(self, "_return_to_title_screen")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_id = id
	end)
end

AccountManagerXboxLive._cb_verify_profile = function (self)
	self._popup_id = nil
	local input_device = InputDevice.last_pressed_device

	if input_device and input_device:type() == "xbox_controller" then
		self._active_controller = input_device:raw_device()
	end

	self:_set_active_device(self._active_controller)

	local profile_active = self:_update_active_profile()

	if profile_active then
		self:_handle_user_device_association_change()
	else
		self:_show_signed_out_error()
	end
end

AccountManagerXboxLive._cb_open_profile_picker = function (self)
	local success_cb = callback(self, "_cb_verify_profile_selection")
	local fail_cb = callback(self, "_cb_verify_profile")
	local async_task = XUser.add_user_async(XUserAddOptions.None)

	Managers.xasync:wrap(async_task, XUser.release_async_block):next(success_cb, fail_cb)
end

AccountManagerXboxLive._cb_verify_profile_selection = function (self, async_task)
	local user_id = XUser.get_user_result(async_task)
	local user_info = XUser.user_info(user_id)
	local xuid = user_info.xuid
	local gamertag = XUser.get_gamertag(user_id)

	if self._xuid ~= xuid then
		self:_show_disconnect_error()
	else
		self._user_id = user_id

		self:_cb_verify_profile()
	end
end

AccountManagerXboxLive._return_to_title_screen = function (self)
	self._popup_id = nil
	self._leave_game = true
	self._wanted_state = CLASSES.StateError
	self._wanted_state_params = {}

	Managers.backend:logout()
end

return AccountManagerXboxLive
