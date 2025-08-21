-- chunkname: @scripts/ui/views/dlc_purchase_view/dlc_purchase_view.lua

local DLCPurchaseViewDefinitions = require("scripts/ui/views/dlc_purchase_view/dlc_purchase_view_definitions")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local DLCPurchaseView = class("DLCPurchaseView", "BaseView")

DLCPurchaseView.init = function (self, settings, context)
	self._context = context or {}
	self._outside_cb_on_store_view_finished = context.on_flow_finished_callback
	self._dlc_settings = self._context.dlc_settings

	DLCPurchaseView.super.init(self, DLCPurchaseViewDefinitions, settings, context)

	self._pass_draw = false
	self._can_exit = true
end

DLCPurchaseView.on_enter = function (self)
	self._telemetry_id = self._dlc_settings.dlc_id

	DLCPurchaseView.super.on_enter(self)

	self._account_items = {}
	self._url_textures = {}

	self:_setup_input_legend()

	self._widgets_by_name.dlc_name_title.content.text = Localize(self._dlc_settings.loc_name_generic)
	self._widgets_by_name.standard_dlc_button.content.sub_title = Localize("loc_term_glossary_dlc")
	self._widgets_by_name.deluxe_dlc_button.content.sub_title = Localize("loc_term_glossary_dlc")
	self._widgets_by_name.standard_dlc_button.content.title = Localize(self._dlc_settings.standard.loc_name)
	self._widgets_by_name.deluxe_dlc_button.content.title = Localize(self._dlc_settings.deluxe.loc_name)
	self._widgets_by_name.standard_dlc_button.style.texture.material_values.main_texture = self._dlc_settings.standard.image
	self._widgets_by_name.deluxe_dlc_button.style.texture.material_values.main_texture = self._dlc_settings.deluxe.image
	self._dlc_buttons_ordered = {
		self._widgets_by_name.standard_dlc_button,
		self._widgets_by_name.deluxe_dlc_button,
	}

	self:_register_button_callbacks()
	self:_on_input_direction(0)
end

DLCPurchaseView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 20)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, function ()
			return legend_input.visibility_function(self)
		end, on_pressed_callback, legend_input.alignment)
	end
end

DLCPurchaseView._register_button_callbacks = function (self)
	local backend_auth_method = Backend:get_auth_method()

	self._widgets_by_name.standard_dlc_button.content.hotspot.pressed_callback = callback(self, "_on_store_button_pressed", self._dlc_settings.standard.ids[backend_auth_method].id, "standard")
	self._widgets_by_name.deluxe_dlc_button.content.hotspot.pressed_callback = callback(self, "_on_store_button_pressed", self._dlc_settings.deluxe.ids[backend_auth_method].id, "deluxe")
end

DLCPurchaseView._on_store_button_pressed = function (self, product_id, button_key)
	self._widgets_by_name.loading.content.visible = true

	Managers.telemetry_events:dlc_purchase_button_clicked(self._telemetry_id, button_key)
	Managers.dlc:open_to_store(product_id, callback(self, "_cb_on_flow_finished"))
end

DLCPurchaseView._cb_on_flow_finished = function (self, is_success)
	self._widgets_by_name.loading.content.visible = false

	if not is_success then
		return
	end

	self:_cb_on_back_pressed()

	if self._outside_cb_on_store_view_finished then
		self._outside_cb_on_store_view_finished(is_success)
	end
end

DLCPurchaseView.can_exit = function (self)
	return self._can_exit
end

DLCPurchaseView.on_exit = function (self)
	DLCPurchaseView.super.on_exit(self)
end

DLCPurchaseView.update = function (self, dt, t, input_service)
	return DLCPurchaseView.super.update(self, dt, t, input_service)
end

DLCPurchaseView._cb_on_back_pressed = function (self)
	local view_name = self.view_name

	Managers.ui:close_view(view_name)
	self:_play_sound(UISoundEvents.default_menu_exit)
end

DLCPurchaseView._cb_on_confirm_pressed = function (self)
	local selected_button = self._dlc_buttons_ordered[self:_get_selected_button_index()]

	if selected_button.content.hotspot.is_selected then
		selected_button.content.hotspot.pressed_callback()
	end
end

DLCPurchaseView._on_input_direction = function (self, input_direction)
	local dlc_buttons_ordered = self._dlc_buttons_ordered
	local dlc_button_len = #dlc_buttons_ordered
	local selected_index = self:_get_selected_button_index() - 1

	selected_index = (selected_index + input_direction + dlc_button_len) % dlc_button_len + 1

	self:_set_selected_button_index(selected_index)
end

DLCPurchaseView._get_selected_button_index = function (self)
	local dlc_buttons_ordered = self._dlc_buttons_ordered
	local selected_index = 1

	for i, v in ipairs(dlc_buttons_ordered) do
		if dlc_buttons_ordered[i].content.hotspot.is_selected then
			selected_index = i
		end
	end

	return selected_index
end

DLCPurchaseView._set_selected_button_index = function (self, index)
	local dlc_buttons_ordered = self._dlc_buttons_ordered

	for i, v in ipairs(dlc_buttons_ordered) do
		dlc_buttons_ordered[i].content.hotspot.is_selected = i == index
		dlc_buttons_ordered[i].content.hotspot.is_focused = i == index
	end
end

DLCPurchaseView._handle_input = function (self, input_service, dt, t)
	DLCPurchaseView.super._handle_input(self, input_service, dt, t)

	if self._using_cursor_navigation then
		self:_set_selected_button_index(-1)

		return
	end

	local input_direction = 0

	if input_service:get("navigate_left_continuous") or input_service:get("navigate_primary_left_pressed") then
		input_direction = -1
	elseif input_service:get("navigate_right_continuous") or input_service:get("navigate_primary_right_pressed") then
		input_direction = 1
	end

	if input_direction ~= 0 then
		self:_on_input_direction(input_direction)
	end
end

return DLCPurchaseView
