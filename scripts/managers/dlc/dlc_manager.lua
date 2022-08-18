DLCDurable = require("scripts/managers/dlc/dlc_durable")
DLCSettings = require("scripts/managers/dlc/dlc_settings")
local DLCManager = class("DLCManager")
local DEBUG = true

local function dprint(...)
	if DEBUG then
		print("[DLCManager]", string.format(...))
	end
end

DLCManager.init = function (self)
	self._state = "none"
	self._durable_dlcs = {}
	self._popup_ids = {}
end

DLCManager.initialize = function (self)
	if IS_XBS then
		if not rawget(_G, "XboxDLC") then
			return
		end

		XboxDLC.enumerate_dlcs()

		self._state = "idle"
	end

	table.clear(self._durable_dlcs)

	local durable_dlc_settings = DLCSettings.durable_dlcs

	for i = 1, #durable_dlc_settings, 1 do
		local durable_dlc_data = durable_dlc_settings[i]
		local name = durable_dlc_data.name
		self._durable_dlcs[name] = DLCDurable:new(durable_dlc_data)
	end
end

DLCManager.is_dlc_unlocked = function (self, dlc_name)
	local durable_dlc = self._durable_dlcs[dlc_name]

	if durable_dlc then
		return durable_dlc:has_license()
	end

	return false
end

DLCManager.update = function (self, dt, t)
	if IS_XBS and not rawget(_G, "XboxDLC") then
		return
	end

	if table.is_empty(self._popup_ids) then
		DLCStates[self._state](self, dt, t)
	end
end

DLCManager.trigger_new_dlc_popup = function (self, dlc)
	local package_details = dlc:package_details()
	local context = {
		title_text = "loc_popup_header_new_dlc_installed",
		description_text = "loc_dlc_installed",
		description_text_params = {
			dlc_name = package_details.display_name,
			dlc_description = package_details.description
		},
		options = {
			{
				text = "loc_popup_unavailable_view_button_confirm",
				close_on_pressed = true,
				callback = callback(self, "_cb_popup_closed")
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_ids[#self._popup_ids + 1] = id
	end)
end

DLCManager._cb_popup_closed = function (self, popup_id)
	local index = table.find(self._popup_ids, popup_id)

	table.remove(self._popup_ids, index)
end

DLCManager._change_state = function (self, state_name)
	fassert(DLCStates[state_name], "[DLCManager] There is no state called %q", state_name)
	dprint("Leaving state: %q", self._state)

	self._state = state_name

	dprint("Entering state: %q", self._state)
end

DLCStates = DLCStates or {}

DLCStates.none = function ()
	return
end

DLCStates.idle = function (dlc_manager, dt, t)
	local dlc_status = XboxDLC.state()

	if dlc_status == XboxDLCState.PACKAGE_INSTALLED then
		dlc_manager:_change_state("check_durable_licenses")
	end
end

DLCStates.check_durable_licenses = function (dlc_manager, dt, t)
	if XboxDLC.is_refreshing() then
		return
	end

	local dlcs = dlc_manager._durable_dlcs

	for name, dlc in pairs(dlcs) do
		dlc:refresh_data()
	end

	dlc_manager:_change_state("handle_status_changes")
end

DLCStates.handle_status_changes = function (dlc_manager, dt, t)
	local dlcs = dlc_manager._durable_dlcs

	for name, dlc in pairs(dlcs) do
		if dlc:license_status_changed() and dlc:has_license() then
			dlc_manager:trigger_new_dlc_popup(dlc)
		end
	end

	dlc_manager:_change_state("query_dlcs")
end

DLCStates.query_dlcs = function (dlc_manager, dt, t)
	dlc_manager:_change_state("idle")
end

return DLCManager
