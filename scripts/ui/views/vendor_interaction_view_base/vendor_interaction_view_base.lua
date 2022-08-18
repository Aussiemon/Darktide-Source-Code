local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base_definitions")
local TabbedMenuViewBase = require("scripts/ui/views/tabbed_menu_view_base")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WalletSettings = require("scripts/settings/wallet_settings")
local VendorInteractionViewBase = class("VendorInteractionViewBase", "TabbedMenuViewBase")

VendorInteractionViewBase.init = function (self, definitions, settings, context)
	if context and context.wallet_type then
		self._wallet_type = context.wallet_type
	end

	if type(self._wallet_type) == "string" then
		self._wallet_type = {
			self._wallet_type
		}
	end

	self._base_definitions = table.clone(Definitions)

	if definitions then
		table.merge_recursive(self._base_definitions, definitions)
	end

	VendorInteractionViewBase.super.init(self, self._base_definitions, settings, context)

	self._pass_draw = false
end

VendorInteractionViewBase.on_enter = function (self)
	VendorInteractionViewBase.super.on_enter(self)

	self._current_balance = {}

	self:_update_wallets_presentation(nil)
	self:_update_wallets()
	self:_register_event("event_vendor_view_purchased_item")
	self:_setup_tab_bar({
		tabs_params = {}
	})

	local button_options_definitions = self._base_definitions.button_options_definitions

	self:_setup_option_buttons(button_options_definitions)

	self._presenting_options = true
	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)
	local intro_texts = self._base_definitions.intro_texts

	self:_set_intro_texts(intro_texts)
end

VendorInteractionViewBase._switch_tab = function (self, index)
	local additional_context = {
		wallet_type = self._wallet_type
	}

	VendorInteractionViewBase.super._switch_tab(self, index, additional_context)
end

VendorInteractionViewBase.event_vendor_view_purchased_item = function (self)
	self:_update_wallets()
end

VendorInteractionViewBase._set_intro_texts = function (self, intro_texts)
	local widgets_by_name = self._widgets_by_name
	local title_text = intro_texts.title_text

	if title_text then
		widgets_by_name.title_text.content.text = Localize(title_text)
	end

	local description_text = intro_texts.description_text

	if description_text then
		widgets_by_name.description_text.content.text = Localize(description_text)
	end

	self:_update_description_height()
end

VendorInteractionViewBase._update_description_height = function (self)
	local description_text_widget = self._widgets_by_name.description_text
	local scenegraph_id = description_text_widget.scenegraph_id
	local text = description_text_widget.content.text
	local style = description_text_widget.style
	local text_style = style.text
	local text_size = text_style.size
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local _, text_height = self:_text_size(text, text_style.font_type, text_style.font_size, text_size, text_options)

	self:_set_scenegraph_size(scenegraph_id, nil, text_height + 30)
end

VendorInteractionViewBase._on_navigation_input_changed = function (self)
	local is_mouse = self._using_cursor_navigation
	local button_widgets = self._button_widgets
	local focused_index = nil
	local num_buttons = button_widgets and #button_widgets or 0

	if is_mouse then
		for i = 1, num_buttons do
			local button = button_widgets[i]
			button.content.hotspot.is_focused = false
		end
	elseif num_buttons > 0 then
		button_widgets[1].content.hotspot.is_focused = true
	end
end

VendorInteractionViewBase._handle_input = function (self, input_service)
	local is_mouse = self._using_cursor_navigation
	local button_widgets = self._button_widgets
	local focused_index = nil
	local num_buttons = button_widgets and #button_widgets or 0

	if not is_mouse then
		for i = 1, num_buttons do
			local button = button_widgets[i]

			if button.content.hotspot.is_focused then
				focused_index = i

				break
			end
		end

		if num_buttons > 0 then
			local next_index = nil

			if input_service:get("navigate_down_continuous") and focused_index < num_buttons then
				next_index = focused_index + 1
			elseif input_service:get("navigate_up_continuous") and focused_index > 1 then
				next_index = focused_index - 1
			end

			if next_index then
				button_widgets[next_index].content.hotspot.is_focused = true
				button_widgets[focused_index].content.hotspot.is_focused = false
			end
		end
	end
end

VendorInteractionViewBase._handle_back_pressed = function (self)
	local active_view_instance = self._active_view_instance
	local handled_by_active_view_instance = active_view_instance and active_view_instance.on_back_pressed and active_view_instance:on_back_pressed()

	if not handled_by_active_view_instance then
		if self._presenting_options then
			local view_name = self.view_name

			Managers.ui:close_view(view_name)
		else
			self:_close_active_view()
			self:_setup_tab_bar({
				tabs_params = {}
			})

			self._next_view = nil

			if self._on_option_enter_anim_id and self:_is_animation_active(self._on_option_enter_anim_id) then
				self:_complete_animation(self._on_option_enter_anim_id)
			end

			self._on_option_enter_anim_id = nil

			if not self._on_option_exit_anim_id then
				local widgets_by_name = self._widgets_by_name
				local widget_list = {
					widgets_by_name.title_text,
					widgets_by_name.description_text,
					widgets_by_name.button_divider,
					widgets_by_name.title_text
				}
				local button_widgets = self._button_widgets

				if button_widgets then
					for i = 1, #button_widgets do
						widget_list[#widget_list + 1] = button_widgets[i]
					end
				end

				self._on_option_exit_anim_id = self:_start_animation("on_option_exit", widget_list, self)
			end

			self._presenting_options = true
		end
	end
end

VendorInteractionViewBase._setup_option_buttons = function (self, options)
	local button_definition = UIWidget.create_definition(table.clone(ButtonPassTemplates.list_button_with_background), "button_pivot")
	local button_widgets = {}
	local spacing = 10
	local button_height = 50

	for i = 1, #options do
		local option = options[i]
		local widget = self:_create_widget("option_button_" .. i, button_definition)
		widget.content.hotspot.pressed_callback = callback(self, "on_option_button_pressed", i, option)
		local display_name = option.display_name
		widget.content.text = Localize(display_name)
		widget.offset[2] = (i - 1) * (button_height + spacing)
		button_widgets[#button_widgets + 1] = widget
	end

	self._button_widgets = button_widgets
end

VendorInteractionViewBase.on_option_button_pressed = function (self, index, option)
	local option_callback = option.callback

	if option_callback then
		option_callback(self)
	end

	if self._on_enter_anim_id and self:_is_animation_active(self._on_enter_anim_id) then
		self:_complete_animation(self._on_enter_anim_id)
	end

	self._on_enter_anim_id = nil

	if self._on_option_exit_anim_id and self:_is_animation_active(self._on_option_exit_anim_id) then
		self:_complete_animation(self._on_option_exit_anim_id)
	end

	self._on_option_exit_anim_id = nil

	if not self._on_option_enter_anim_id then
		local widgets_by_name = self._widgets_by_name
		local widget_list = {
			widgets_by_name.title_text,
			widgets_by_name.description_text,
			widgets_by_name.button_divider,
			widgets_by_name.title_text
		}
		local button_widgets = self._button_widgets

		if button_widgets then
			for i = 1, #button_widgets do
				widget_list[#widget_list + 1] = button_widgets[i]
			end
		end

		self._on_option_enter_anim_id = self:_start_animation("on_option_enter", widget_list, self)
		self._presenting_options = false
	end
end

VendorInteractionViewBase.on_exit = function (self)
	if self._wallet_promise then
		self._wallet_promise:cancel()

		self._wallet_promise = nil
	end

	VendorInteractionViewBase.super.on_exit(self)
end

VendorInteractionViewBase.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_renderer = self._ui_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph
	local situational_input_service = self._presenting_options and input_service or input_service:null_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, situational_input_service, dt, render_settings)
	self:_draw_widgets(dt, t, situational_input_service, ui_renderer, render_settings)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_renderer, render_settings, input_service)
end

VendorInteractionViewBase._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local render_settings_alpha_multiplier = render_settings.alpha_multiplier
	render_settings.alpha_multiplier = self._alpha_multiplier or 0

	VendorInteractionViewBase.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local button_widgets = self._button_widgets

	if button_widgets then
		local num_widgets = #button_widgets

		for i = 1, num_widgets do
			local widget = button_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end

	local wallet_widgets = self._wallet_widgets

	if wallet_widgets then
		for i = 1, #wallet_widgets do
			local widget = wallet_widgets[i]

			UIWidget.draw(widget, self._ui_renderer)
		end
	end

	render_settings.alpha_multiplier = render_settings_alpha_multiplier
end

VendorInteractionViewBase.update = function (self, dt, t, input_service)
	local input_legend = self:_element("input_legend")

	if input_legend then
		local text = self._presenting_options and "loc_view_close" or "loc_view_back"
		local entry_id = "entry_0"

		input_legend:set_display_name(entry_id, text, nil)
	end

	return VendorInteractionViewBase.super.update(self, dt, t, input_service)
end

VendorInteractionViewBase._update_wallets = function (self)
	local store_service = Managers.data_service.store
	local promise = store_service:combined_wallets()

	promise:next(function (wallets_data)
		self:_update_wallets_presentation(wallets_data)

		self._wallet_promise = nil
	end)

	self._wallet_promise = promise
end

VendorInteractionViewBase._update_wallets_presentation = function (self, wallets_data)
	local corner_right = self._widgets_by_name.corner_top_right

	if not corner_right.content.original_size then
		local corner_width, corner_height = self:_scenegraph_size("corner_top_right")
		corner_right.content.original_size = {
			corner_width,
			corner_height
		}
	end

	if self._wallet_widgets then
		for i = 1, #self._wallet_widgets do
			local widget = self._wallet_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._wallet_widgets = nil
	end

	local total_width = 0
	local widgets = {}
	local wallet_definition = Definitions.wallet_definitions

	for i = 1, #self._wallet_type do
		local wallet_type = self._wallet_type[i]
		local wallet_settings = WalletSettings[wallet_type]
		local font_gradient_material = wallet_settings.font_gradient_material
		local icon_texture_small = wallet_settings.icon_texture_small
		local widget = self:_create_widget("wallet_" .. i, wallet_definition)
		widget.style.text.material = font_gradient_material
		widget.content.texture = icon_texture_small
		local amount = 0

		if wallets_data then
			local wallet = wallets_data:by_type(wallet_type)
			local balance = wallet and wallet.balance
			amount = balance and balance.amount or 0
		end

		local text = tostring(amount)
		self._current_balance[wallet_type] = amount
		widget.content.text = text
		local style = widget.style
		local text_style = style.text
		local text_width, _ = self:_text_size(text, text_style.font_type, text_style.font_size)
		local texture_width = widget.style.texture.size[1]
		local text_offset = widget.style.text.original_offset
		local texture_offset = widget.style.texture.original_offset
		local text_margin = 5
		local price_margin = i < #self._wallet_type and 30 or 0
		widget.style.texture.offset[1] = texture_offset[1] + total_width
		widget.style.text.offset[1] = text_offset[1] + text_margin + total_width
		total_width = total_width + text_width + texture_width + text_margin + price_margin
		widgets[#widgets + 1] = widget
	end

	local corner_width = corner_right.content.original_size[1]
	local corner_texture_size_minus_wallet = 100
	local total_corner_width = total_width + corner_width - corner_texture_size_minus_wallet

	self:_set_scenegraph_size("wallet_pivot", total_width, nil)
	self:_set_scenegraph_size("corner_top_right", total_corner_width, nil)

	self._wallet_widgets = widgets
end

VendorInteractionViewBase.set_camera_position_axis_offset = function (self, axis, value, animation_duration, func_ptr)
	if self._world_spawner then
		self._world_spawner:set_camera_position_axis_offset(axis, value, animation_duration, func_ptr)
	end
end

return VendorInteractionViewBase
