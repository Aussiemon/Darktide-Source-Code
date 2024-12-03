-- chunkname: @scripts/ui/constant_elements/elements/havoc/constant_element_havoc_status.lua

local ConstantElementHavocStatus = class("ConstantElementHavocStatus")

ConstantElementHavocStatus.init = function (self, parent, draw_layer, start_scale)
	self._notifications_allowed = false
	self._havoc_status = nil
	self._notification_id = nil

	Managers.event:register(self, "event_havoc_status_refreshed", "_event_havoc_status_refreshed")
end

ConstantElementHavocStatus._event_havoc_status_refreshed = function (self, status)
	self._havoc_status = status

	self:_update_notification()
end

ConstantElementHavocStatus.set_visible = function (self, visible, optional_visibility_parameters)
	self._notifications_allowed = visible

	self:_update_notification()
end

ConstantElementHavocStatus._update_notification = function (self)
	local should_show_locked_notification = self._notifications_allowed and self._havoc_status == "havoc_locked"

	if should_show_locked_notification and not self._notification_id then
		local message = Localize("loc_notification_havoc_prohibited")

		Managers.event:trigger("event_add_notification_message", "havoc_status", message, function (id)
			self._notification_id = id
		end)
	elseif not should_show_locked_notification and self._notification_id then
		Managers.event:trigger("event_remove_notification", self._notification_id)

		self._notification_id = nil
	end
end

ConstantElementHavocStatus.should_update = function (self)
	return false
end

ConstantElementHavocStatus.should_draw = function (self)
	return false
end

ConstantElementHavocStatus.destroy = function (self)
	Managers.event:unregister(self, "event_havoc_status_refreshed")

	if self._notification_id then
		Managers.event:trigger("event_remove_notification", self._notification_id)

		self._notification_id = nil
	end
end

return ConstantElementHavocStatus
