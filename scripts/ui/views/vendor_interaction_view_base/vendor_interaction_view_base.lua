-- chunkname: @scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base.lua

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base_definitions")
local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")
local TabbedMenuViewBase = require("scripts/ui/views/tabbed_menu_view_base")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Vo = require("scripts/utilities/vo")
local WalletSettings = require("scripts/settings/wallet_settings")
local TextUtilities = require("scripts/utilities/ui/text")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local VendorInteractionViewBaseTestify = GameParameters.testify and require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base_testify")
local VendorInteractionViewBase = class("VendorInteractionViewBase", "TabbedMenuViewBase")

VendorInteractionViewBase.init = function (self, definitions, settings, context)
	if context and context.wallet_type then
		self._wallet_type = context.wallet_type
	end

	if type(self._wallet_type) == "string" then
		self._wallet_type = {
			self._wallet_type,
		}
	end

	self._base_definitions = table.clone(Definitions)

	if definitions then
		table.merge_recursive(self._base_definitions, definitions)
	end

	self._option_button_settings = definitions.option_button_settings or {
		grow_vertically = true,
		spacing = 10,
		button_template = ButtonPassTemplates.list_button_with_background,
	}
	self._button_input_actions = {
		"navigate_down_continuous",
		"navigate_up_continuous",
	}

	local parent = context and context.parent

	self._parent = parent
	self._current_vo_event = nil
	self._current_vo_id = nil
	self._character_cooldowns = {}
	self._vo_unit = nil
	self._vo_callback = callback(self, "_cb_on_play_vo")

	VendorInteractionViewBase.super.init(self, self._base_definitions, settings, context)

	self._pass_draw = false
end

VendorInteractionViewBase.on_enter = function (self)
	VendorInteractionViewBase.super.on_enter(self)

	self._current_balance = {}

	if self._wallet_type then
		self:_update_wallets_presentation(nil)
		self:_update_wallets()
		self:_register_event("event_vendor_view_purchased_item")
	end

	self:_setup_tab_bar({
		tabs_params = {},
	})

	local button_options_definitions = self._base_definitions.button_options_definitions

	self:_setup_option_buttons(button_options_definitions)

	self._presenting_options = true
	self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

	local intro_texts = self._base_definitions.intro_texts

	self:_set_intro_texts(intro_texts)

	self._hide_option_buttons = self._base_definitions.hide_option_buttons

	local starting_option_index = self._base_definitions.starting_option_index

	if starting_option_index then
		local option = button_options_definitions[starting_option_index]

		if option then
			self:on_option_button_pressed(starting_option_index, option)
		end
	end

	if self._hide_option_buttons then
		local widgets_by_name = self._widgets_by_name

		widgets_by_name.title_text.visible = false
		widgets_by_name.description_text.visible = false
		widgets_by_name.button_divider.visible = false
	end
end

VendorInteractionViewBase._switch_tab = function (self, index)
	local additional_context = {
		wallet_type = self._wallet_type,
	}

	VendorInteractionViewBase.super._switch_tab(self, index, additional_context)
end

VendorInteractionViewBase.event_vendor_view_purchased_item = function (self)
	self:_update_wallets()
end

VendorInteractionViewBase._set_intro_texts = function (self, intro_texts)
	local widgets_by_name = self._widgets_by_name
	local title_text = intro_texts.title_text
	local unlocalized_title_text = intro_texts.unlocalized_title_text

	if title_text then
		widgets_by_name.title_text.content.text = Localize(title_text)
	end

	if unlocalized_title_text then
		widgets_by_name.title_text.content.text = unlocalized_title_text
	end

	local description_text = intro_texts.description_text
	local unlocalized_description_text = intro_texts.unlocalized_description_text

	if description_text then
		widgets_by_name.description_text.content.text = Localize(description_text)
	end

	if unlocalized_description_text then
		widgets_by_name.description_text.content.text = unlocalized_description_text
	end

	self:_update_text_height()
end

VendorInteractionViewBase._text_widget_size = function (self, widget_name, optional_id)
	optional_id = optional_id or "text"

	local widget = self._widgets_by_name[widget_name]
	local content = widget.content[optional_id]
	local style = widget.style[optional_id]
	local text_options = UIFonts.get_font_options_by_style(style)

	return self:_text_size(content, style.font_type, style.font_size, style.size, text_options)
end

VendorInteractionViewBase._update_text_height = function (self)
	local description_text_widget = self._widgets_by_name.description_text
	local scenegraph_id = description_text_widget.scenegraph_id
	local _, description_height = self:_text_widget_size("description_text")

	self:_set_scenegraph_size(scenegraph_id, nil, description_height + 30)

	local info_box_scenegraph = self._ui_scenegraph.info_box

	self:_set_scenegraph_position("info_box", nil, info_box_scenegraph.position[2] - description_height * 0.5)

	local _, title_height = self:_text_widget_size("title_text")

	self:_set_scenegraph_position("title_text", nil, -(title_height + 30))
end

VendorInteractionViewBase._on_navigation_input_changed = function (self)
	local is_mouse = self._using_cursor_navigation
	local button_widgets = self._button_widgets
	local focused_index
	local num_buttons = button_widgets and #button_widgets or 0

	if is_mouse then
		for i = 1, num_buttons do
			local button = button_widgets[i]

			button.content.hotspot.is_selected = false
		end
	elseif num_buttons > 0 then
		button_widgets[1].content.hotspot.is_selected = true
	end
end

VendorInteractionViewBase._handle_input = function (self, input_service)
	local tab_bar_menu = self._elements.tab_bar
	local can_navigate = self._can_navigate

	if tab_bar_menu then
		tab_bar_menu:set_is_handling_navigation_input(can_navigate)
	end

	input_service = self._presenting_options and input_service or input_service:null_service()

	local is_mouse = self._using_cursor_navigation
	local button_widgets = self._button_widgets
	local focused_index
	local num_buttons = button_widgets and #button_widgets or 0

	if not is_mouse then
		for i = 1, num_buttons do
			local button = button_widgets[i]

			if button.content.hotspot.is_selected then
				focused_index = i

				break
			end
		end

		local button_input_actions = self._button_input_actions

		if num_buttons > 0 then
			local next_index

			if input_service:get(button_input_actions[1]) and focused_index < num_buttons then
				next_index = focused_index + 1
			elseif input_service:get(button_input_actions[2]) and focused_index > 1 then
				next_index = focused_index - 1
			end

			if next_index then
				button_widgets[next_index].content.hotspot.is_selected = true
				button_widgets[focused_index].content.hotspot.is_selected = false
			end
		end
	end
end

VendorInteractionViewBase.disable_view_worlds = function (self, view)
	local active_view_instance = self._active_view_instance

	if active_view_instance then
		return active_view_instance.world_spawner and active_view_instance:world_spawner() ~= nil
	end

	return false
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
				tabs_params = {},
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
					widgets_by_name.title_text,
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
	local option_button_settings = self._option_button_settings
	local scenegraph_id = "button_pivot"
	local button_definition = UIWidget.create_definition(table.clone(option_button_settings.button_template), scenegraph_id)
	local button_widgets = {}
	local definitions = self._definitions
	local default_scenegraph_definition = definitions.scenegraph_definition
	local button_scenegraph_definition = default_scenegraph_definition[scenegraph_id]
	local grow_vertically = option_button_settings.grow_vertically
	local spacing = option_button_settings.spacing or 10
	local button_width = button_scenegraph_definition.size[1]
	local button_height = button_scenegraph_definition.size[2]

	for i = 1, #options do
		local option = options[i]
		local widget = self:_create_widget("option_button_" .. i, button_definition)
		local content = widget.content
		local hotspot = content.hotspot

		hotspot.pressed_callback = callback(self, "on_option_button_pressed", i, option)
		hotspot.disabled = option.disabled

		local display_name = option.display_name
		local unlocalized_name = option.unlocalized_name

		content.text = unlocalized_name and not display_name and unlocalized_name or Localize(display_name)
		content.icon = option.icon

		if grow_vertically then
			widget.offset[2] = (i - 1) * (button_height + spacing)
		else
			widget.offset[1] = (i - 1) * (button_width + spacing)
		end

		button_widgets[#button_widgets + 1] = widget
	end

	self._button_widgets = button_widgets
end

VendorInteractionViewBase.on_option_button_pressed = function (self, index, option)
	local option_callback = option.callback

	if option_callback then
		local result = option_callback(self)

		if result == "cannot_enter_view" then
			return
		end
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
			widgets_by_name.title_text,
		}
		local button_widgets = self._button_widgets

		if button_widgets then
			for i = 1, #button_widgets do
				widget_list[#widget_list + 1] = button_widgets[i]
			end
		end

		local anim_name = option.blur_background and "on_option_enter_blurred" or "on_option_enter"

		self._on_option_enter_anim_id = self:_start_animation(anim_name, widget_list, self)
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

	if button_widgets and not self._hide_option_buttons then
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

			UIWidget.draw(widget, ui_renderer)
		end
	end

	render_settings.alpha_multiplier = render_settings_alpha_multiplier
end

VendorInteractionViewBase.update = function (self, dt, t, input_service)
	if GameParameters.testify then
		Testify:poll_requests_through_handler(VendorInteractionViewBaseTestify, self)
	end

	local input_legend = self:_element("input_legend")

	if input_legend then
		local text = self._presenting_options and "loc_view_close" or "loc_view_back"
		local entry_id = "entry_0"

		input_legend:set_display_name(entry_id, text, nil)
	end

	self:_update_vo(dt, t)

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

	self._wallets_data = wallets_data

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

		local text = TextUtilities.format_currency(amount)

		self._current_balance[wallet_type] = amount
		widget.content.text = text

		local style = widget.style
		local text_style = style.text
		local text_width, _ = self:_text_size(text, text_style.font_type, text_style.font_size)
		local texture_width = widget.style.texture.size[1]
		local text_offset = widget.style.text.original_offset
		local texture_offset = widget.style.texture.original_offset
		local text_margin = 0
		local price_margin = i < #self._wallet_type and 5 or 0

		if i == 1 then
			total_width = texture_offset[1]
		end

		widget.style.texture.offset[1] = -total_width
		total_width = total_width + texture_width
		widget.style.text.offset[1] = -total_width
		total_width = total_width + text_width + texture_width * 0.5 + text_margin + price_margin
		widgets[#widgets + 1] = widget
	end

	self:_set_scenegraph_size("wallet_pivot", total_width, nil)
	self:_set_wallet_background_width(total_width)

	self._wallet_widgets = widgets
end

VendorInteractionViewBase._set_wallet_background_width = function (self, total_width)
	local corner_right = self._widgets_by_name.corner_top_right

	if corner_right and not corner_right.content.original_size then
		local corner_width, corner_height = self:_scenegraph_size("corner_top_right")

		corner_right.content.original_size = {
			corner_width,
			corner_height,
		}
	end

	local corner_width = corner_right and corner_right.content.original_size[1] or 0
	local corner_texture_size_minus_wallet = 100
	local total_corner_width = total_width + corner_width - corner_texture_size_minus_wallet

	self:_set_scenegraph_size("corner_top_right", total_corner_width, nil)
end

VendorInteractionViewBase.set_camera_position_axis_offset = function (self, axis, value, animation_duration, func_ptr)
	if self._world_spawner then
		self._world_spawner:set_camera_position_axis_offset(axis, value, animation_duration, func_ptr)
	end
end

VendorInteractionViewBase._update_vo = function (self, dt, t)
	local queued_vo_event_request = self._queued_vo_event_request
	local character_cooldowns = self._character_cooldowns

	for voice, cooldown in pairs(character_cooldowns) do
		character_cooldowns[voice] = cooldown - dt

		if cooldown < 0 then
			character_cooldowns[voice] = nil
		end
	end

	if queued_vo_event_request then
		local delay = queued_vo_event_request.delay

		if delay <= 0 then
			local events = queued_vo_event_request.events
			local voice_profile = queued_vo_event_request.voice_profile
			local character_cooldown = character_cooldowns[voice_profile]

			if not character_cooldown then
				local optional_route_key = queued_vo_event_request.optional_route_key
				local is_opinion_vo = queued_vo_event_request.is_opinion_vo
				local world_spawner = self._world_spawner
				local dialogue_system = world_spawner and self:dialogue_system()

				if dialogue_system then
					self:play_vo_events(events, voice_profile, optional_route_key, nil, is_opinion_vo)

					character_cooldowns[voice_profile] = DialogueSettings.store_npc_cooldown_time

					local reply = queued_vo_event_request.reply

					if reply then
						self._queued_vo_event_request = reply
						self._queued_vo_event_request.reply = nil
					else
						self._queued_vo_event_request = nil
					end
				else
					self._queued_vo_event_request = nil
				end
			else
				self._queued_vo_event_request = nil
			end
		else
			queued_vo_event_request.delay = delay - dt
		end
	end

	local current_vo_id = self._current_vo_id

	if not current_vo_id then
		return
	end

	local unit = self._vo_unit

	if unit then
		local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
		local is_playing = dialogue_extension:is_playing(current_vo_id)

		if not is_playing then
			self._current_vo_id = nil
			self._current_vo_event = nil
		end
	end
end

VendorInteractionViewBase.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueExtension")

	return dialogue_system
end

VendorInteractionViewBase.cb_switch_tab = function (self, index)
	TabbedMenuViewBase.cb_switch_tab(self, index)

	if not self._using_cursor_navigation then
		self:_play_sound(UISoundEvents.tab_button_pressed)
	end
end

VendorInteractionViewBase._cb_on_play_vo = function (self, id, event_name)
	self._current_vo_event = event_name
	self._current_vo_id = id
end

VendorInteractionViewBase.play_vo_events = function (self, events, voice_profile, optional_route_key, optional_delay, is_opinion_vo)
	local dialogue_system = self:dialogue_system()

	if optional_delay then
		local play_table = {
			events = events,
			voice_profile = voice_profile,
			optional_route_key = optional_route_key,
			delay = optional_delay,
			is_opinion_vo = is_opinion_vo,
		}
		local queued_vo_event_request = self._queued_vo_event_request

		if queued_vo_event_request then
			if queued_vo_event_request.voice_profile ~= play_table.voice_profile then
				queued_vo_event_request.reply = play_table
			end
		else
			self._queued_vo_event_request = play_table
		end
	else
		local wwise_route_key = optional_route_key or 40
		local callback = self._vo_callback
		local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback, nil, is_opinion_vo)

		self._vo_unit = vo_unit
	end
end

VendorInteractionViewBase.base_definitions = function (self)
	return self._base_definitions
end

VendorInteractionViewBase.can_afford = function (self, amount, type)
	return amount <= (self._current_balance[type] or 0)
end

VendorInteractionViewBase.get_balance = function (self, type)
	return self._current_balance[type]
end

return VendorInteractionViewBase
