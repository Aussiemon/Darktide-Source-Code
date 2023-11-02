local Definitions = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_definitions")
local PopupStyle = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_styles")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local SocialConstants = require("scripts/managers/data_service/services/social/social_constants")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local ViewElementPlayerSocialPopupContentList = require("scripts/ui/view_elements/view_element_player_social_popup/view_element_player_social_popup_content_list")
local social_service = Managers.data_service.social
local OnlineStatus = SocialConstants.OnlineStatus
local ViewElementPlayerSocialPopup = class("ViewElementPlayerSocialPopup", "ViewElementBase")

ViewElementPlayerSocialPopup.init = function (self, parent, draw_layer, start_scale)
	ViewElementPlayerSocialPopup.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._ui_renderer = parent._ui_renderer
	self._menu_widgets = {}
	self._alignment_widgets = {}
	self._menu_item_widget_definitions = {}
	self._navigation_blocked = true
	self._start_height = 0
	self._menu_height = 0

	self:_register_event("event_player_profile_updated", "event_player_profile_updated")
end

ViewElementPlayerSocialPopup.event_player_profile_updated = function (self, peer_id, player_id, updated_profile)
	local player_header = self._widgets_by_name.player_header
	local content = player_header.content
	local player_info = self._player_info
	local profile = player_info:profile()

	if profile == updated_profile then
		self:_update_portrait()
	end
end

ViewElementPlayerSocialPopup._update_portrait = function (self)
	local player_header = self._widgets_by_name.player_header
	local content = player_header.content
	local player_info = self._player_info

	if content.frame_load_id then
		Managers.ui:unload_item_icon(content.frame_load_id)

		content.frame_load_id = nil
	end

	if content.portrait_load_id then
		Managers.ui:unload_profile_portrait(content.portrait_load_id)

		content.portrait_load_id = nil
	end

	local profile = player_info.profile and player_info:profile()

	if profile then
		local loadout = profile and profile.loadout
		local frame_item = loadout and loadout.slot_portrait_frame

		if frame_item then
			local cb = callback(self, "_cb_set_player_frame", player_header)
			local unload_cb = callback(self, "_cb_unset_player_frame", player_header, self._ui_renderer)
			content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb, nil, nil, nil, unload_cb)
		end

		local profile_icon_loaded_callback = callback(self, "_cb_set_player_icon", player_header)
		local profile_icon_unloaded_callback = callback(self, "_cb_unset_player_icon", player_header, self._ui_renderer)
		content.portrait_load_id = Managers.ui:load_profile_portrait(profile, profile_icon_loaded_callback, nil, profile_icon_unloaded_callback)
	end
end

ViewElementPlayerSocialPopup.close = function (self, on_done_callback)
	if not self._is_closing then
		self._is_closing = true

		self:_start_fade_animation("close", on_done_callback)
	end
end

ViewElementPlayerSocialPopup.set_close_popup_request_callback = function (self, callback)
	self._request_close_popup = callback
end

ViewElementPlayerSocialPopup.cb_set_player_info = function (self, player_info)
	self:set_player_info(self._parent, player_info)
end

ViewElementPlayerSocialPopup.set_player_info = function (self, parent, player_info)
	if self._player_info then
		local menu_items, num_menu_items = ViewElementPlayerSocialPopupContentList.from_player_info(self._parent, player_info)

		self:_start_fade_animation("fade_out_widgets", callback(self, "_transition_to_new_player_info", parent, player_info, menu_items, num_menu_items))
	else
		local menu_items, num_menu_items = ViewElementPlayerSocialPopupContentList.from_player_info(self._parent, player_info)

		self:_set_player_info(parent, player_info, menu_items, num_menu_items)
	end
end

ViewElementPlayerSocialPopup.setup_find_player = function (self, parent, player_info)
	local menu_items, num_menu_items = ViewElementPlayerSocialPopupContentList.find_player_menu_items(self._parent)
	local show_friend_code = true

	self:_set_player_info(parent, player_info, menu_items, num_menu_items, show_friend_code)
	self:_start_fade_animation("open")
end

ViewElementPlayerSocialPopup._search_for_player = function (self, fatshark_id)
	local widgets = self._widgets_by_name
	local player_plaque = widgets.player_plaque

	self._parent:_unload_widget_portrait(player_plaque)

	player_plaque.content.player_info = nil
	player_plaque.content.player_info_updated = true

	Managers.data_service.social:get_player_info_by_fatshark_id(fatshark_id):next(function (player_info)
		if not player_info then
			return nil
		end

		local presence_myself = Managers.presence:presence_entry_myself()
		local my_platform = presence_myself:platform()
		local other_platform = player_info:platform()

		if my_platform ~= other_platform and (presence_myself:cross_play_disabled() or player_info:cross_play_disabled()) then
			return nil
		end

		return player_info
	end):next(function (player_info)
		if player_info then
			player_plaque.content.player_info = player_info
			player_plaque.content.player_info_updated = true
			local profile = player_info.profile and player_info:profile()

			if profile then
				self._parent:_load_widget_portrait(player_plaque, profile, self._ui_renderer)
			end

			player_plaque.content.search_status_text = ""
		else
			player_plaque.content.search_status_text = Localize("loc_social_menu_find_player_failed")
		end

		local fatshark_id_entry = widgets.fatshark_id_entry
		local hotspot = fatshark_id_entry.content.hotspot
		hotspot.use_is_focused = true
		hotspot.disabled = false
		self._searching_for_player = false
	end):catch(function ()
		player_plaque.content.search_status_text = Localize("loc_social_menu_find_player_failed")
		local fatshark_id_entry = widgets.fatshark_id_entry
		local hotspot = fatshark_id_entry.content.hotspot
		hotspot.use_is_focused = true
		hotspot.disabled = false
		self._searching_for_player = false
	end)

	self._searching_for_player = true
	self._searched_fatshark_id = fatshark_id
end

ViewElementPlayerSocialPopup.previously_searched_fatshark_id = function (self)
	return self._searched_fatshark_id
end

ViewElementPlayerSocialPopup.on_navigation_input_changed = function (self, using_cursor_navigation)
	self._using_cursor_navigation = using_cursor_navigation
	local menu_grid = self._menu_grid

	if not using_cursor_navigation then
		local current_selected_grid_index = menu_grid:selected_grid_index()

		if not current_selected_grid_index or not menu_grid:widget_by_index(current_selected_grid_index) then
			menu_grid:select_first_index(true)
		end
	elseif menu_grid:selected_grid_index() then
		menu_grid:select_grid_index(nil, nil, nil, true)
	end
end

ViewElementPlayerSocialPopup.on_resolution_modified = function (self, scale)
	ViewElementPlayerSocialPopup.super.on_resolution_modified(self, scale)

	local menu_grid = self._menu_grid

	if menu_grid then
		menu_grid:on_resolution_modified(scale)
	end
end

ViewElementPlayerSocialPopup.update = function (self, dt, t, input_service)
	local menu_grid = self._menu_grid

	if self._navigation_blocked then
		if not input_service:get("left_hold") and not input_service:get("confirm_hold") then
			self._navigation_blocked = false
		else
			input_service = input_service:null_service()
		end
	end

	if menu_grid then
		menu_grid:update(dt, t, input_service)
	end

	local widgets_by_name = self._widgets_by_name
	local player_header = widgets_by_name.player_header
	local player_header_hovered = player_header.content.hotspot.is_hover
	local header_style = player_header.style
	local fatshark_id_style = header_style.user_fatshark_id

	if player_header_hovered then
		if input_service:get("left_hold") then
			fatshark_id_style.text_color = fatshark_id_style.disabled_color
			fatshark_id_style.font_size = 25
		else
			fatshark_id_style.text_color = fatshark_id_style.hover_color
			fatshark_id_style.font_size = 26
		end
	else
		fatshark_id_style.text_color = fatshark_id_style.default_color
		fatshark_id_style.font_size = 26
	end

	if input_service:get("left_pressed") then
		if not widgets_by_name.background.content.hotspot.is_hover then
			self._request_close_popup()
		end

		local fatshark_id = self._user_fatshark_id

		if player_header_hovered and fatshark_id then
			Clipboard.put(fatshark_id)
		end
	end

	if self._searching_for_player then
		local widgets = self._widgets_by_name
		local player_plaque = widgets.player_plaque
		local remainder = math.ceil(t * 10) % 12
		local suffix = remainder <= 1 and "." or remainder <= 6 and ".." or remainder <= 11 and "..."
		player_plaque.content.search_status_text = Localize("loc_social_menu_find_player_searching") .. suffix
	end

	ViewElementPlayerSocialPopup.super.update(self, dt, t, input_service)
end

ViewElementPlayerSocialPopup.draw = function (self, dt, t, ui_renderer, parent_render_settings, input_service)
	local render_settings = self._render_settings

	if not render_settings then
		render_settings = table.clone(parent_render_settings)
		render_settings.alpha_multiplier = 1
		self._render_settings = render_settings
	end

	if self._navigation_blocked then
		input_service = input_service:null_service()
	end

	ViewElementPlayerSocialPopup.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ViewElementPlayerSocialPopup._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementPlayerSocialPopup.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local menu_widgets = self._menu_widgets

	for i = 1, #menu_widgets do
		local widget = menu_widgets[i]

		UIWidget.draw(widget, ui_renderer)

		local template_type = widget.content.template_type

		if template_type then
			local template = self._definitions.blueprints[template_type]

			if template and template.update then
				template.update(self, widget)
			end
		end
	end
end

ViewElementPlayerSocialPopup._transition_to_new_player_info = function (self, parent, player_info, menu_items, num_menu_items)
	self:_set_player_info(parent, player_info, menu_items, num_menu_items, false)
	self:on_navigation_input_changed(self._using_cursor_navigation)
end

local _player_header_params = {}

ViewElementPlayerSocialPopup._set_player_info = function (self, parent, player_info, menu_items, num_menu_items, show_friend_code)
	local player_header = self._widgets_by_name.player_header
	local header_content = player_header.content
	local header_style = player_header.style

	if header_content.frame_load_id then
		Managers.ui:unload_item_icon(header_content.frame_load_id)

		header_content.frame_load_id = nil
	end

	if header_content.portrait_load_id then
		Managers.ui:unload_profile_portrait(header_content.portrait_load_id)

		header_content.portrait_load_id = nil
	end

	self._player_info = player_info
	local player_display_name, user_display_name = nil
	local character_name = player_info:character_name()

	if character_name and #character_name > 0 then
		local character_level = player_info:character_level()
		local player_header_params = _player_header_params
		player_header_params.character_name = character_name
		player_header_params.character_level = character_level
		player_display_name = Localize("loc_social_menu_character_name_format", true, _player_header_params)

		if not player_info:is_myself() and (IS_XBS or IS_GDK) and player_info:platform() == "xbox" then
			local xuid = player_info:platform_user_id()
			local platform_profile = parent:get_platform_profile(xuid)
			user_display_name = platform_profile and platform_profile.gamertag or player_info:user_display_name() or "N/A"
		else
			user_display_name = player_info:user_display_name()
		end
	else
		if not player_info:is_myself() and (IS_XBS or IS_GDK) and player_info:platform() == "xbox" then
			local xuid = player_info:platform_user_id()
			local platform_profile = parent:get_platform_profile(xuid)
			player_display_name = platform_profile and platform_profile.gamertag or player_info:user_display_name() or "N/A"
		else
			player_display_name = player_info:user_display_name()
		end

		user_display_name = ""
	end

	header_content.player_display_name = player_display_name
	header_content.user_display_name = user_display_name
	local player_display_name_style = header_style.player_display_name
	local player_display_name_font_type = player_display_name_style.font_type
	local player_display_name_font_size = player_display_name_style.font_size
	local user_display_name_style = header_style.user_display_name
	local user_display_name_font_type = user_display_name_style.font_type
	local user_display_name_font_size = user_display_name_style.font_size
	local ui_renderer = self._ui_renderer
	local ui_renderer_text_size = UIRenderer.text_size
	local player_display_name_width = ui_renderer_text_size(ui_renderer, player_display_name, player_display_name_font_type, player_display_name_font_size)
	local user_display_name_width = ui_renderer_text_size(ui_renderer, user_display_name, user_display_name_font_type, user_display_name_font_size)
	local extra_text_padding = PopupStyle.extra_text_padding
	local text_width = math.max(player_display_name_width, user_display_name_width) + extra_text_padding
	local header_width = self:_scenegraph_size("player_info_header")
	local info_area_width = self:_scenegraph_size("player_info_area")

	if header_width < text_width then
		self:_set_scenegraph_size("player_info_header", math.min(text_width, info_area_width))

		while info_area_width < player_display_name_width + extra_text_padding and player_display_name_font_size > 6 do
			player_display_name_font_size = player_display_name_font_size - 1
			player_display_name_width = ui_renderer_text_size(ui_renderer, player_display_name, player_display_name_font_type, player_display_name_font_size)
		end

		player_display_name_style.font_size = player_display_name_font_size

		while info_area_width < user_display_name_width + extra_text_padding and user_display_name_font_size > 6 do
			user_display_name_font_size = user_display_name_font_size - 1
			user_display_name_width = ui_renderer_text_size(ui_renderer, user_display_name, user_display_name_font_type, user_display_name_font_size)
		end

		user_display_name_style.font_size = user_display_name_font_size
	end

	local online_status = player_info:online_status()
	local user_activity = nil

	if player_info:is_blocked() then
		user_activity = Localize("loc_social_menu_player_blocked")
	elseif online_status == OnlineStatus.online then
		local activity_loc_string = player_info:player_activity_loc_string()
		local activity_param = {
			activity = Localize(activity_loc_string)
		}
		user_activity = Localize("loc_social_menu_in_activity", true, activity_param)
	elseif online_status == OnlineStatus.platform_online then
		local platform_param = {
			activity = social_service:platform_display_name()
		}
		user_activity = Localize("loc_social_menu_player_online_status_platform_online", false, platform_param)
	else
		user_activity = Localize("loc_social_menu_player_online_status_offline")
	end

	header_content.user_activity = user_activity
	local profile = player_info.profile and player_info:profile()

	if profile then
		local loadout = profile and profile.loadout
		local frame_item = loadout and loadout.slot_portrait_frame

		if frame_item then
			local cb = callback(self, "_cb_set_player_frame", player_header)
			local unload_cb = callback(self, "_cb_unset_player_frame", player_header, self._ui_renderer)
			header_content.frame_load_id = Managers.ui:load_item_icon(frame_item, cb, nil, nil, nil, unload_cb)
		end

		local profile_icon_loaded_callback = callback(self, "_cb_set_player_icon", player_header)
		local profile_icon_unloaded_callback = callback(self, "_cb_unset_player_icon", player_header, self._ui_renderer)
		header_content.portrait_load_id = Managers.ui:load_profile_portrait(profile, profile_icon_loaded_callback, nil, profile_icon_unloaded_callback)
	end

	if show_friend_code then
		header_content.user_fatshark_id = Localize("loc_social_menu_find_player_fetch_id")

		Managers.data_service.social:get_fatshark_id():next(function (fatshark_id)
			header_content.user_fatshark_id = Localize("loc_social_menu_find_player_player_id_title") .. " " .. fatshark_id
			self._user_fatshark_id = fatshark_id
		end)
	else
		header_content.user_fatshark_id = ""
		self._user_fatshark_id = nil
	end

	self:_setup_menu_items(menu_items, num_menu_items)
	self:_start_fade_animation("open")
end

ViewElementPlayerSocialPopup._cb_set_player_icon = function (self, widget, grid_index, rows, columns, render_target)
	local portrait_style = widget.style.portrait
	widget.content.portrait = "content/ui/materials/base/ui_portrait_frame_base"
	local material_values = portrait_style.material_values
	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
	material_values.texture_icon = render_target
end

ViewElementPlayerSocialPopup._cb_unset_player_icon = function (self, widget, ui_renderer)
	local previously_visible = widget.content.visible

	UIWidget.set_visible(widget, ui_renderer, false)

	local material_values = widget.style.portrait.material_values
	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.portrait = "content/ui/materials/base/ui_portrait_frame_base_no_render"

	if previously_visible then
		UIWidget.set_visible(widget, ui_renderer, true)
	end
end

ViewElementPlayerSocialPopup._cb_set_player_frame = function (self, widget, item)
	local icon = item.icon
	local portrait_style = widget.style.portrait
	portrait_style.material_values.portrait_frame_texture = icon
end

ViewElementPlayerSocialPopup._cb_unset_player_frame = function (self, widget, ui_renderer)
	local previously_visible = widget.content.visible

	UIWidget.set_visible(widget, ui_renderer, false)

	local widget_style = widget.style
	local material_values = widget_style.portrait.material_values
	material_values.portrait_frame_texture = "content/ui/textures/nameplates/portrait_frames/default"

	if previously_visible then
		UIWidget.set_visible(widget, ui_renderer, true)
	end
end

local _padding_item = {
	size = PopupStyle.menu_padding
}

ViewElementPlayerSocialPopup._setup_menu_items = function (self, menu_items, num_menu_items)
	local widget_alignments = self._alignment_widgets

	table.clear_array(widget_alignments, #widget_alignments)

	local menu_widgets = self._menu_widgets
	local num_menu_widgets = #menu_widgets

	for i = 1, num_menu_widgets do
		self:_unregister_widget_name(menu_widgets[i].name)

		menu_widgets[i] = nil
	end

	for i = 1, num_menu_items do
		local menu_item = menu_items[i]
		local widget = self:_create_menu_widget(menu_item)
		menu_widgets[#menu_widgets + 1] = widget
		widget_alignments[#widget_alignments + 1] = widget
	end

	self._menu_widgets = menu_widgets
	self._alignment_widgets = widget_alignments
	local grid_scenegraph_id = "menu_area"
	local grid_direction = "down"
	local grid_spacing = PopupStyle.menu_item_spacing
	local menu_grid = UIWidgetGrid:new(menu_widgets, widget_alignments, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, true)

	menu_grid:set_render_scale(self._render_scale)

	self._menu_grid = menu_grid
	self._start_height = self._menu_height or 0
	self._menu_height = menu_grid:length()
end

ViewElementPlayerSocialPopup._create_menu_widget = function (self, menu_item_settings)
	local widget_definitions = self._menu_item_widget_definitions
	local blueprints = self._definitions.blueprints
	local blueprint_name = menu_item_settings.blueprint
	local widget_blueprint = blueprints[blueprint_name]
	local widget_definition = widget_definitions[blueprint_name]

	if not widget_definition then
		local scenegraph_id = "menu_area"
		widget_definition = UIWidget.create_definition(widget_blueprint.pass_template, scenegraph_id, nil, widget_blueprint.size, widget_blueprint.style)
		widget_definitions[blueprint_name] = widget_definition
	end

	local widget = self:_create_widget(menu_item_settings.label, widget_definition)

	if widget_blueprint.init then
		local ui_renderer = self._ui_renderer

		widget_blueprint.init(self, widget, menu_item_settings, nil, ui_renderer)
	end

	widget.content.template_type = blueprint_name
	widget.alpha_multiplier = 0

	return widget
end

local _animation_parameters = {}

ViewElementPlayerSocialPopup._start_fade_animation = function (self, name, on_done_callback)
	local animation_parameters = _animation_parameters
	animation_parameters.start_height = self._start_height
	animation_parameters.popup_content_height = self._menu_height

	self:_start_animation(name, nil, animation_parameters, on_done_callback)
end

ViewElementPlayerSocialPopup._cb_on_animation_done = function (self, on_done_callback)
	self._animation_playing = nil

	if on_done_callback then
		on_done_callback()
	end
end

ViewElementPlayerSocialPopup.destroy = function (self, ui_renderer)
	local widget = self._widgets_by_name.player_header

	if widget.content.frame_load_id then
		Managers.ui:unload_item_icon(widget.content.frame_load_id)

		widget.content.frame_load_id = nil
	end

	if widget.content.portrait_load_id then
		Managers.ui:unload_profile_portrait(widget.content.portrait_load_id)

		widget.content.portrait_load_id = nil
	end

	local virtual_keyboard_widget = self._widgets_by_name.fatshark_id_entry
	local virtual_keyboard_content = virtual_keyboard_widget and virtual_keyboard_widget.content

	if virtual_keyboard_content and virtual_keyboard_content.x_async_block then
		XAsyncBlock.cancel(virtual_keyboard_content.x_async_block)
	end

	ViewElementPlayerSocialPopup.super.destroy(self, ui_renderer)
end

return ViewElementPlayerSocialPopup
