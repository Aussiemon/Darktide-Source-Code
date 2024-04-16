local Breeds = require("scripts/settings/breed/breeds")
local Definitions = require("scripts/ui/views/player_character_options_view/player_character_options_view_definitions")
local PlayerCharacterOptionsViewSettings = require("scripts/ui/views/player_character_options_view/player_character_options_view_settings")
local ProfileUtils = require("scripts/utilities/profile_utils")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local OnlineStatus = SocialConstants.OnlineStatus
local PlayerCharacterOptionsView = class("PlayerCharacterOptionsView", "BaseView")

PlayerCharacterOptionsView.init = function (self, settings, context)
	self._context = context
	self._inspected_player = context and context.player or self:_player()
	self._peer_id = self._inspected_player:peer_id()
	self._local_player_id = self._inspected_player:local_player_id()
	local account_id = context and context.account_id or self._inspected_player:account_id()
	self._account_id = account_id
	self._player_info = Managers.data_service.social:get_player_info_by_account_id(account_id)

	self:_generate_player_icon()

	self._content_alpha_multiplier = 0
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	PlayerCharacterOptionsView.super.init(self, Definitions, settings, context)

	self._allow_close_hotkey = true
end

PlayerCharacterOptionsView.trigger_on_exit_animation = function (self)
	if not self._window_close_anim_id then
		self._window_close_anim_id = self:_start_animation("on_exit", self._widgets_by_name, self)
	end
end

PlayerCharacterOptionsView.on_exit_animation_done = function (self)
	return self._window_close_anim_id and self:_is_animation_completed(self._window_close_anim_id)
end

PlayerCharacterOptionsView.on_enter = function (self)
	PlayerCharacterOptionsView.super.on_enter(self)
	self:_setup_buttons_interactions()

	local player = self._inspected_player
	local profile = player and player:profile()
	local player_name = player and player:name()
	local current_level = profile and profile.current_level

	self:_set_player_name(player_name, current_level)

	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	self._widgets_by_name.class_badge.style.badge.material_values.badge = PlayerCharacterOptionsViewSettings.archetype_badge_texture_by_name[archetype_name]
	local archetype = profile and profile.archetype
	local string_symbol = archetype and archetype.string_symbol
	local character_archetype_title = string_symbol .. " " .. ProfileUtils.character_archetype_title(profile, true)

	self:_set_class_name(character_archetype_title)

	local scenegraph_definition = self._definitions.scenegraph_definition
	local player_title = ProfileUtils.character_title(profile)

	if player_title and player_title ~= "" then
		self._widgets_by_name.character_title.content.text = player_title
	else
		local character_title_pos = scenegraph_definition.character_title.position
		local class_name_pos = scenegraph_definition.class_name.position

		self:_set_scenegraph_position("class_name", class_name_pos[1], character_title_pos[2], class_name_pos[3])
	end

	self._window_open_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)

	if not self._using_cursor_navigation then
		self:_set_selected_gamepad_navigation_index(1)
	end
end

PlayerCharacterOptionsView._set_player_name = function (self, name, current_level)
	local widget = self._widgets_by_name.player_name
	local text = name

	if current_level then
		text = text .. " - " .. current_level .. " "
	end

	widget.content.text = text
end

PlayerCharacterOptionsView._set_class_name = function (self, name)
	local widget = self._widgets_by_name.class_name
	local text = name
	widget.content.text = text
end

PlayerCharacterOptionsView._generate_player_icon = function (self)
	local slot_name = "inspect_pose"
	local load_cb = callback(self, "_cb_set_player_icon")
	local player = self._inspected_player
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local breed_name = profile_archetype and profile_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local portrait_state_machine = breed_settings.portrait_state_machine
	local animation_event_by_archetype = PlayerCharacterOptionsViewSettings.animation_event_by_archetype
	local animation_event = animation_event_by_archetype[archetype_name]
	local image_size = PlayerCharacterOptionsViewSettings.image_size
	local size_multiplier = 2
	local render_context = {
		camera_focus_slot_name = slot_name,
		state_machine = portrait_state_machine,
		animation_event = animation_event,
		size = {
			image_size[1] * size_multiplier,
			image_size[2] * size_multiplier
		}
	}
	self._player_icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, render_context)
end

PlayerCharacterOptionsView._cb_set_player_icon = function (self, grid_index, rows, columns, render_target)
	self._cached_player_icon_material_values = nil

	if self._entered then
		local widget = self._widgets_by_name.window_image
		local material_values = widget.style.texture.material_values
		material_values.use_placeholder_texture = 0
		material_values.use_render_target = 1
		material_values.rows = rows
		material_values.columns = columns
		material_values.grid_index = grid_index - 1
		material_values.render_target = render_target
		widget.content.use_placeholder_texture = material_values.use_placeholder_texture
		widget.content.alpha_fraction = 0
	else
		self._cached_player_icon_material_values = {
			grid_index = grid_index,
			rows = rows,
			columns = columns,
			render_target = render_target
		}
	end
end

PlayerCharacterOptionsView.on_exit = function (self)
	PlayerCharacterOptionsView.super.on_exit(self)

	if self._player_icon_load_id then
		Managers.ui:unload_profile_portrait(self._player_icon_load_id)

		self._player_icon_load_id = nil
	end
end

PlayerCharacterOptionsView.draw = function (self, dt, t, input_service, layer)
	local content_alpha_multiplier = self._content_alpha_multiplier

	return PlayerCharacterOptionsView.super.draw(self, dt, t, input_service, layer)
end

PlayerCharacterOptionsView._draw_widgets = function (self, dt, t, input_service, ui_renderer)
	return PlayerCharacterOptionsView.super._draw_widgets(self, dt, t, input_service, ui_renderer)
end

PlayerCharacterOptionsView.update = function (self, dt, t, input_service, layer)
	if self._inspected_player then
		local player_info = self._player_info
		local is_online = true
		local peer_id = self._peer_id
		local local_player_id = self._local_player_id

		if not is_online or not Managers.player:player(peer_id, local_player_id) then
			if Managers.ui:view_active("inventory_background_view") then
				Managers.ui:close_view("inventory_background_view")
			end

			self._inspected_player = nil

			Managers.ui:close_view("player_character_options_view")

			return
		end
	end

	if self._cached_player_icon_material_values then
		self:_cb_set_player_icon(self._cached_player_icon_material_values.grid_index, self._cached_player_icon_material_values.rows, self._cached_player_icon_material_values.columns, self._cached_player_icon_material_values.render_target)
	end

	self:_update_invite_button_status()

	if self._window_open_anim_id and self:_is_animation_completed(self._window_open_anim_id) then
		self:_stop_animation(self._window_open_anim_id)

		self._window_open_anim_id = nil
	end

	return PlayerCharacterOptionsView.super.update(self, dt, t, input_service, layer)
end

PlayerCharacterOptionsView._update_invite_button_status = function (self)
	local can_invite = false
	local cannot_invite_reason = nil
	local player_info = self._player_info

	if player_info then
		can_invite, cannot_invite_reason = Managers.data_service.social:can_invite_to_party(player_info)
	end

	local widget = self._widgets_by_name.invite_button
	widget.content.hotspot.disabled = not can_invite
end

PlayerCharacterOptionsView._on_invite_pressed = function (self)
	self:_play_sound(UISoundEvents.social_menu_send_invite)

	local player_info = self._player_info

	Managers.data_service.social:send_party_invite(player_info)
end

PlayerCharacterOptionsView._setup_buttons_interactions = function (self)
	local widgets_by_name = self._widgets_by_name
	widgets_by_name.inspect_button.content.hotspot.pressed_callback = callback(self, "_on_inspect_pressed")
	widgets_by_name.invite_button.content.hotspot.pressed_callback = callback(self, "_on_invite_pressed")
	widgets_by_name.close_button.content.hotspot.pressed_callback = callback(self, "_on_close_pressed")
	self._button_gamepad_navigation_list = {
		widgets_by_name.inspect_button,
		widgets_by_name.invite_button,
		widgets_by_name.close_button
	}
end

PlayerCharacterOptionsView._on_inspect_pressed = function (self)
	Managers.ui:open_view("inventory_background_view", nil, nil, nil, nil, {
		is_readonly = true,
		player = self._inspected_player
	})
end

PlayerCharacterOptionsView._on_close_pressed = function (self)
	self:_play_sound(UISoundEvents.system_popup_exit)
	Managers.ui:close_view(self.view_name)
end

PlayerCharacterOptionsView._get_animation_widgets = function (self)
	local window_image_widget = self._widgets_by_name.window_image
	local widgets = {
		[window_image_widget.name] = window_image_widget
	}
	local slide_page_circles = self._slide_page_circles

	if slide_page_circles then
		for i = 1, #slide_page_circles do
			widgets[#widgets + 1] = slide_page_circles[i]
		end
	end

	return widgets
end

PlayerCharacterOptionsView._on_navigation_input_changed = function (self)
	PlayerCharacterOptionsView.super._on_navigation_input_changed(self)

	if self._using_cursor_navigation then
		if self._selected_gamepad_navigation_index then
			self:_set_selected_gamepad_navigation_index(nil)
		end
	elseif not self._selected_gamepad_navigation_index then
		self:_set_selected_gamepad_navigation_index(1)
	end
end

PlayerCharacterOptionsView._set_selected_gamepad_navigation_index = function (self, index)
	self._selected_gamepad_navigation_index = index
	local button_gamepad_navigation_list = self._button_gamepad_navigation_list

	for i = 1, #button_gamepad_navigation_list do
		local widget = button_gamepad_navigation_list[i]
		widget.content.hotspot.is_selected = i == index
	end
end

PlayerCharacterOptionsView._handle_button_gamepad_navigation = function (self, input_service)
	local selected_gamepad_navigation_index = self._selected_gamepad_navigation_index

	if not selected_gamepad_navigation_index then
		return
	end

	local button_gamepad_navigation_list = self._button_gamepad_navigation_list
	local new_index = nil

	if input_service:get("navigate_up_continuous") then
		new_index = math.max(selected_gamepad_navigation_index - 1, 1)
	elseif input_service:get("navigate_down_continuous") then
		new_index = math.min(selected_gamepad_navigation_index + 1, #button_gamepad_navigation_list)
	end

	if new_index and new_index ~= selected_gamepad_navigation_index then
		self:_set_selected_gamepad_navigation_index(new_index)
		self:_play_sound(UISoundEvents.default_mouse_hover)
	end
end

PlayerCharacterOptionsView._handle_input = function (self, input_service, dt, t)
	if not self._window_open_anim_id and not self._window_close_anim_id then
		self:_handle_button_gamepad_navigation(input_service)
	end
end

return PlayerCharacterOptionsView
