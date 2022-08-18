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

ViewElementPlayerSocialPopup.set_player_info = function (self, player_info, portrait_data)
	if self._player_info then
		self:_start_fade_animation("fade_out_widgets", callback(self, "_set_player_info", player_info))
	else
		local menu_items, num_menu_items = ViewElementPlayerSocialPopupContentList.from_player_info(self._parent, player_info)

		self:_set_player_info(player_info, portrait_data, menu_items, num_menu_items)
	end
end

ViewElementPlayerSocialPopup.on_navigation_input_changed = function (self, using_cursor_navigation)
	self._using_cursor_navigation = using_cursor_navigation
	local menu_grid = self._menu_grid

	if not using_cursor_navigation then
		menu_grid:select_first_index(true)
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

	if input_service:get("left_pressed") and not self._widgets_by_name.background.content.hotspot.is_hover then
		self._request_close_popup()
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

	for i = 1, #menu_widgets, 1 do
		local widget = menu_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end
end

local _player_header_params = {}

ViewElementPlayerSocialPopup._set_player_info = function (self, player_info, portrait_data, menu_items, num_menu_items)
	self._player_info = player_info
	local player_header = self._widgets_by_name.player_header
	local header_content = player_header.content
	local header_style = player_header.style
	local player_display_name, user_display_name = nil
	local character_name = player_info:character_name()

	if character_name and #character_name > 0 then
		local character_level = player_info:character_level()
		local player_header_params = _player_header_params
		player_header_params.character_name = character_name
		player_header_params.character_level = character_level
		player_display_name = Localize("loc_social_menu_character_name_format", true, _player_header_params)
		user_display_name = player_info:user_display_name()
	else
		player_display_name = player_info:user_display_name()
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

	if portrait_data then
		local portrait_style = header_style.portrait
		portrait_style.material_values = portrait_data
	end

	self:_setup_menu_items(menu_items, num_menu_items)
	self:_start_fade_animation("open")
end

local _padding_item = {
	size = PopupStyle.menu_padding
}

ViewElementPlayerSocialPopup._setup_menu_items = function (self, menu_items, num_menu_items)
	local widget_alignments = self._alignment_widgets

	table.clear_array(widget_alignments, #widget_alignments)

	local menu_widgets = self._menu_widgets
	local num_menu_widgets = #menu_widgets

	for i = 1, num_menu_widgets, 1 do
		self:_unregister_widget_name(menu_widgets[i].name)

		menu_widgets[i] = nil
	end

	for i = 1, num_menu_items, 1 do
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
		widget_blueprint.init(self, widget, menu_item_settings)
	end

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

return ViewElementPlayerSocialPopup
