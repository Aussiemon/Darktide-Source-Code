-- chunkname: @scripts/ui/views/account_profile_popup_view/account_profile_popup_view.lua

local Definitions = require("scripts/ui/views/account_profile_popup_view/account_profile_popup_view_definitions")
local AccountProfilePopupView = class("AccountProfilePopupView", "BaseView")

AccountProfilePopupView.init = function (self, settings, context)
	self._context = context

	AccountProfilePopupView.super.init(self, Definitions, settings, context)

	self._pass_input = false
	self._parent = context and context.parent

	if self._parent then
		self._parent:cb_set_active_popup_instance(self)
	end
end

AccountProfilePopupView.on_enter = function (self)
	AccountProfilePopupView.super.on_enter(self)
	self:_populate_popup(self._context)
	self:_start_animation("open_view")
end

AccountProfilePopupView.on_exit = function (self)
	AccountProfilePopupView.super.on_exit(self)
end

AccountProfilePopupView.close_view = function (self)
	if not self._is_closing then
		self._is_closing = true

		local view_name = self.view_name

		local function on_done_callback()
			Managers.ui:close_view(view_name)
		end

		self:_start_animation("close_view", nil, nil, on_done_callback)
	end
end

AccountProfilePopupView._handle_input = function (self, input_service, dt, t)
	if input_service:get("left_pressed") then
		if not self._widgets_by_name.background.content.hotspot.is_hover then
			self:close_view()
		end
	elseif input_service:get("back") then
		self:close_view()
	end
end

AccountProfilePopupView._start_fade_animation = function (self, name, on_done_callback)
	local animation_parameters = {
		start_height = self._start_height,
		popup_area_height = self._menu_height
	}

	self:_start_animation(name, nil, animation_parameters, on_done_callback)
end

AccountProfilePopupView._populate_popup = function (self, context)
	local widgets_by_name = self._widgets_by_name
	local icon_widget = widgets_by_name.icon

	if context.icon then
		icon_widget.content.icon = context.icon
	else
		icon_widget.content.visible = false
	end

	local headline_widget = widgets_by_name.headline

	headline_widget.content.text = self:_localize(context.headline)
end

return AccountProfilePopupView
