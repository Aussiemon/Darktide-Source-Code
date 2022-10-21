local Definitions = require("scripts/ui/views/talents_career_choice_view/talents_career_choice_view_definitions")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local InputUtils = require("scripts/managers/input/input_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewStyles = require("scripts/ui/views/talents_career_choice_view/talents_career_choice_view_styles")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local PlayerSpecialization = require("scripts/utilities/player_specialization/player_specialization")
local TextUtils = require("scripts/utilities/ui/text")
local MASK_MARGIN = ViewStyles.mask_margin
local BANNER_STATES = table.enum("idle", "greyed_out", "focused", "selected_show_talents", "selected_show_description")
local BANNER_STATE_STYLES = {
	[BANNER_STATES.idle] = ViewStyles.career_banner,
	[BANNER_STATES.greyed_out] = ViewStyles.career_banner_greyed_out,
	[BANNER_STATES.focused] = ViewStyles.career_banner_focused,
	[BANNER_STATES.selected_show_talents] = ViewStyles.career_banner_show_talents,
	[BANNER_STATES.selected_show_description] = ViewStyles.career_banner_show_description
}
local TalentsCareerChoiceView = class("TalentsCareerChoiceView", "BaseView")

TalentsCareerChoiceView.init = function (self, settings, context)
	self._context = context
	self._parent = context.parent

	if context then
		self._preview_player = context.player
	else
		self._preview_player = self:_player()
	end

	TalentsCareerChoiceView.super.init(self, Definitions, settings)

	self._pass_input = true
end

TalentsCareerChoiceView.on_enter = function (self)
	TalentsCareerChoiceView.super.on_enter(self)

	self._data_service = Managers.data_service.talents
	self._archetype = nil
	self._selected_banner_index = nil
	self._selected_details_type = "talents"
	self._running_animations = {}
	self._belated_banner_animations = {}

	self:_create_offscreen_renderer()
	self:_setup_archetype_data()

	local confirm_button = self._widgets_by_name.confirm_choice_button
	confirm_button.content.hotspot.pressed_callback = callback(self, "cb_confirm_choice_button_pressed")

	self:_on_navigation_input_changed()
end

TalentsCareerChoiceView.on_exit = function (self)
	TalentsCareerChoiceView.super.on_exit(self)
	self:_destroy_renderer()
end

TalentsCareerChoiceView.on_back_pressed = function (self)
	local back_pressed_handled = false
	local career_banners = self._career_banners

	for i = 1, #career_banners do
		local banner = career_banners[i]

		if banner.state == BANNER_STATES.selected_show_talents or banner.state == BANNER_STATES.selected_show_description then
			self:_set_banner_state(i, "focused")

			back_pressed_handled = true
		end
	end

	return back_pressed_handled
end

TalentsCareerChoiceView.set_can_exit = function (self, value, apply_next_frame)
	if not apply_next_frame and value ~= self._can_close then
		self._can_close = value

		if self._parent then
			self._parent:set_can_exit(value)
		end
	else
		self._next_frame_can_close = value
		self._can_close_frame_counter = 1
	end
end

TalentsCareerChoiceView.update = function (self, dt, t, input_service)
	local belated_banner_animations = self._belated_banner_animations

	for banner_index, animation_params in pairs(belated_banner_animations) do
		belated_banner_animations[banner_index] = nil

		self:_play_banner_animation(banner_index, animation_params)
	end

	local career_banners = self._career_banners or {}

	for i = 1, #career_banners do
		career_banners[i].grid:update(dt, t, input_service)
	end

	local confirm_button = self._widgets_by_name.confirm_choice_button
	confirm_button.content.hotspot.disabled = self._selected_banner_index == nil

	return TalentsCareerChoiceView.super.update(self, dt, t, input_service)
end

TalentsCareerChoiceView.draw = function (self, dt, t, input_service, ui_layer)
	self:_draw_grid_widgets(dt, t, input_service, ui_layer)
end

TalentsCareerChoiceView.cb_banner_button_pressed = function (self, banner_index)
	local career_banners = self._career_banners

	for i = 1, #career_banners do
		local banner = career_banners[i]
		local is_selected = i == banner_index

		if is_selected then
			if banner.is_selected and banner.state ~= BANNER_STATES.focused then
				if banner.state ~= BANNER_STATES.selected_show_talents or not banner.scrollbar.content.hotspot.is_hover then
					self:_set_banner_state(i, BANNER_STATES.focused)
				end
			elseif self._selected_details_type == "description" then
				self:_set_banner_state(i, BANNER_STATES.selected_show_description)
			else
				self:_set_banner_state(i, BANNER_STATES.selected_show_talents)
			end
		else
			self:_set_banner_state(i, BANNER_STATES.greyed_out)
		end
	end
end

TalentsCareerChoiceView.cb_confirm_choice_button_pressed = function (self)
	local selected_index = self._selected_banner_index
	local career_banner = self._career_banners[selected_index]
	local specialization_id = career_banner.specialization
	local archetype = self._archetype
	local archetype_specialization = archetype.specializations[specialization_id]
	local specialization_name = TextUtils.localize_to_title_case(archetype_specialization.title)
	local popup_params = {
		title_text = "loc_talents_choose_specialization_confirm_choice_popup_title",
		description_text = "loc_talents_choose_specialization_confirm_choice_popup_text",
		description_text_params = {
			archetype = Localize(archetype.archetype_name),
			specialization = specialization_name
		},
		options = {
			{
				text = "loc_talents_choose_specialization_confirm_choice_popup_yes",
				close_on_pressed = true,
				hotkey = "confirm_pressed",
				text_params = {
					specialization = specialization_name
				},
				callback = callback(self, "_handle_career_choice", specialization_id)
			},
			{
				text = "loc_talents_choose_specialization_confirm_choice_popup_no",
				template_type = "terminal_button_small",
				close_on_pressed = true,
				hotkey = "back"
			}
		}
	}

	Managers.event:trigger("event_show_ui_popup", popup_params)
end

TalentsCareerChoiceView._handle_input = function (self, input_service, dt, t)
	TalentsCareerChoiceView.super._handle_input(self, input_service, dt, t)

	local using_cursor_navigation = self._using_cursor_navigation
	local input_handled = false

	if input_service:get("back") then
		input_handled = self:on_back_pressed()
	end

	self._pass_input = not input_handled
	local career_banners = self._career_banners
	local focused_banner_index, selected_banner_index = nil

	for i = 1, #career_banners do
		local banner = career_banners[i]

		if using_cursor_navigation then
			if banner.is_selected then
				selected_banner_index = i

				if input_service:get("secondary_action_pressed") then
					local is_hovered = banner.banner_widget.content.hotspot.is_hover

					if is_hovered and banner.state == BANNER_STATES.selected_show_talents then
						self:_set_banner_state(i, BANNER_STATES.selected_show_description)
					elseif is_hovered and banner.state == BANNER_STATES.selected_show_description then
						self:_set_banner_state(i, BANNER_STATES.selected_show_talents)
					end
				elseif input_service:get("navigate_secondary_up_pressed") then
					self:_set_banner_state(i, BANNER_STATES.selected_show_talents)
				elseif input_service:get("navigate_secondary_down_pressed") then
					self:_set_banner_state(i, BANNER_STATES.selected_show_description)
				end
			elseif banner.banner_widget.content.hotspot.is_hover then
				focused_banner_index = i
			end
		elseif banner.is_selected and not selected_banner_index then
			selected_banner_index = i
			local current_state = banner.state

			if input_service:get("secondary_action_pressed") then
				if current_state ~= BANNER_STATES.focused then
					self:_set_banner_state(i, BANNER_STATES.focused)
				elseif self._selected_details_type == "description" then
					self:_set_banner_state(i, BANNER_STATES.selected_show_description)
				else
					self:_set_banner_state(i, BANNER_STATES.selected_show_talents)
				end
			elseif input_service:get("navigate_left_continuous") then
				repeat
					selected_banner_index = math.index_wrapper(i - 1, #career_banners)
				until not career_banners[selected_banner_index].disabled or selected_banner_index == i

				self:_set_banner_state(selected_banner_index, current_state)
			elseif input_service:get("navigate_right_continuous") then
				repeat
					selected_banner_index = math.index_wrapper(i + 1, #career_banners)
				until not career_banners[selected_banner_index].disabled or selected_banner_index == i

				self:_set_banner_state(selected_banner_index, current_state)
			elseif input_service:get("navigate_up_pressed") then
				self:_set_banner_state(i, BANNER_STATES.selected_show_talents)
			elseif input_service:get("navigate_down_pressed") then
				self:_set_banner_state(i, BANNER_STATES.selected_show_description)
			end
		end
	end

	for i = 1, #career_banners do
		if career_banners[i].disabled then
			self:_set_banner_state(i, BANNER_STATES.greyed_out)
		elseif not focused_banner_index and not selected_banner_index then
			self:_set_banner_state(i, BANNER_STATES.idle)
		elseif focused_banner_index and focused_banner_index == i then
			self:_set_banner_state(i, BANNER_STATES.focused)
		elseif not selected_banner_index or selected_banner_index ~= i then
			self:_set_banner_state(i, BANNER_STATES.greyed_out)
		end
	end

	self._selected_banner_index = selected_banner_index
end

local _on_navigation_input_changed_text_param = {}

TalentsCareerChoiceView._on_navigation_input_changed = function (self)
	TalentsCareerChoiceView.super._on_navigation_input_changed()

	local banners = self._career_banners
	local using_cursor_navigation = self:using_cursor_navigation()
	local widgets_by_name = self._widgets_by_name
	local confirmation_button_widget = widgets_by_name.confirm_choice_button
	local confirmation_button_content = confirmation_button_widget.content
	local confirm_choice_button_loc_key = confirmation_button_content.loc_key
	local show_details_hint_loc_key = "loc_talents_choose_specialization_show_details_button_hint"
	local hide_details_hint_loc_key = "loc_talents_choose_specialization_hide_details_button_hint"
	local show_description_hint_loc_key = "loc_talents_choose_specialization_show_description_button_hint"
	local show_talents_hint_loc_key = "loc_talents_choose_specialization_show_talents_button_hint"
	local text_param = _on_navigation_input_changed_text_param

	if using_cursor_navigation then
		confirmation_button_content.text = Localize(confirm_choice_button_loc_key)
		confirmation_button_content.hotspot.is_selected = false
		text_param.button_hint = ""
		local show_details_hint = Localize(show_details_hint_loc_key, true, text_param)
		local hide_details_hint = Localize(hide_details_hint_loc_key, true, text_param)
		text_param.button_hint = "[S]"
		local show_description_hint = Localize(show_description_hint_loc_key, true, text_param)
		text_param.button_hint = "[W]"
		local show_talents_hint = Localize(show_talents_hint_loc_key, true, text_param)

		for i, banner in pairs(banners) do
			if banner.state == BANNER_STATES.focused then
				banner.is_selected = false
			end

			local banner_widget = banner.banner_widget
			local content = banner_widget.content
			content.show_details_button_hint = show_details_hint
			content.hide_details_button_hint = hide_details_hint
			content.description_button_hint = show_description_hint
			content.information_button_hint = show_talents_hint
		end
	else
		confirmation_button_content.text = TextUtils.localize_with_button_hint("confirm_pressed", confirm_choice_button_loc_key)
		confirmation_button_content.hotspot.is_selected = true
		text_param.button_hint = ""
		local show_details_hint = Localize(show_details_hint_loc_key, true, text_param)
		local hide_details_hint = Localize(hide_details_hint_loc_key, true, text_param)
		text_param.button_hint = ""
		local show_description_hint = Localize(show_description_hint_loc_key, true, text_param)
		text_param.button_hint = ""
		local show_talents_hint = Localize(show_talents_hint_loc_key, true, text_param)
		local focused_index, state = nil

		for i = 1, #banners do
			local banner = banners[i]

			if banner.is_selected or not focused_index and banner.state == BANNER_STATES.focused then
				focused_index = i
				state = banner.state
			end

			local banner_widget = banner.banner_widget
			local content = banner_widget.content
			content.show_details_button_hint = show_details_hint
			content.hide_details_button_hint = hide_details_hint
			content.description_button_hint = show_description_hint
			content.information_button_hint = show_talents_hint
		end

		if not focused_index then
			for i, banner in pairs(banners) do
				if not banner.disabled then
					focused_index = i
					state = BANNER_STATES.focused

					break
				end
			end
		end

		self:_set_banner_state(focused_index, state)
	end
end

TalentsCareerChoiceView._draw_grid_widgets = function (self, dt, t, input_service, ui_layer)
	local offscreen_renderer = self._offscreen_renderer
	local render_settings = self._render_settings
	local career_banners = self._career_banners

	for i = 1, #career_banners do
		local banner = career_banners[i]

		if offscreen_renderer and banner.mask.alpha_multiplier > 0 then
			UIRenderer.begin_pass(offscreen_renderer, self._ui_scenegraph, input_service, dt, render_settings)

			local list_widgets = banner.details_widgets
			local grid = banner.grid

			for j = 1, #list_widgets do
				local widget = list_widgets[j]

				if grid:is_widget_visible(widget, MASK_MARGIN) then
					UIWidget.draw(widget, offscreen_renderer, ui_layer)
				end
			end

			UIRenderer.end_pass(offscreen_renderer)
		end

		TalentsCareerChoiceView.super.draw(self, dt, t, input_service)
	end
end

TalentsCareerChoiceView._handle_career_choice = function (self, specialization)
	local player = self._preview_player

	self._data_service:set_specialization(player, specialization)
	self:_play_sound(UISoundEvents.talents_choose_specialization)
end

TalentsCareerChoiceView._set_banner_state = function (self, banner_index, state)
	local banner = self._career_banners[banner_index]

	if state == banner.state then
		return
	end

	local banner_scrollbar_hotspot = banner.scrollbar.content.hotspot
	banner_scrollbar_hotspot.is_selected = false
	local animation_params = {
		banner_source_style = BANNER_STATE_STYLES[banner.state],
		banner_target_style = BANNER_STATE_STYLES[state]
	}

	if state == BANNER_STATES.selected_show_talents then
		banner.is_selected = true
		self._selected_details_type = "talents"
		banner_scrollbar_hotspot.is_selected = not self._using_cursor_navigation

		if banner.state == BANNER_STATES.selected_show_description then
			animation_params.sound = UISoundEvents.talents_specialization_details_switch
		else
			animation_params.sound = UISoundEvents.talents_specialization_details_show
		end
	elseif state == BANNER_STATES.selected_show_description then
		banner.is_selected = true
		self._selected_details_type = "description"

		if banner.state == BANNER_STATES.selected_show_talents then
			animation_params.sound = UISoundEvents.talents_specialization_details_switch
		else
			animation_params.sound = UISoundEvents.talents_specialization_details_show
		end
	elseif state == BANNER_STATES.focused then
		local using_cursor_navigation = self._using_cursor_navigation
		banner.is_selected = not using_cursor_navigation

		if banner.state == BANNER_STATES.selected_show_talents or banner.state == BANNER_STATES.selected_show_description then
			animation_params.sound = UISoundEvents.talents_specialization_details_hide
		else
			animation_params.sound = UISoundEvents.talents_specialization_hover
		end
	else
		banner.is_selected = false
	end

	self:_play_banner_animation(banner_index, animation_params)

	banner.state = state
end

TalentsCareerChoiceView._play_banner_animation = function (self, banner_index, animation_params)
	local running_animations = self._running_animations
	local banner_animation_id = running_animations[banner_index]

	if banner_animation_id and self:_is_animation_active(banner_animation_id) then
		self._belated_banner_animations[banner_index] = animation_params
	else
		local banner = self._career_banners[banner_index]
		running_animations[banner_index] = self:_start_animation("switch_state", banner, animation_params)
	end
end

TalentsCareerChoiceView._create_offscreen_renderer = function (self)
	local view_name = self.view_name
	local world_layer = 10
	local world_name = self.__class_name .. "_ui_offscreen_world"
	local world = Managers.ui:create_world(world_name, world_layer, nil, view_name)
	local viewport_name = self.__class_name .. "_offscreen_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	local viewport = Managers.ui:create_viewport(world, viewport_name, viewport_type, viewport_layer)
	local renderer_name = self.__class_name .. "offscreen_renderer"
	self._offscreen_renderer = Managers.ui:create_renderer(renderer_name, world)
	self._offscreen_world = {
		name = world_name,
		world = world,
		viewport = viewport,
		viewport_name = viewport_name,
		renderer_name = renderer_name
	}
end

TalentsCareerChoiceView._destroy_renderer = function (self)
	if self._offscreen_renderer then
		self._offscreen_renderer = nil
	end

	local world_data = self._offscreen_world

	if world_data then
		Managers.ui:destroy_renderer(world_data.renderer_name)
		ScriptWorld.destroy_viewport(world_data.world, world_data.viewport_name)
		Managers.ui:destroy_world(world_data.world)

		self._offscreen_world = nil
	end
end

TalentsCareerChoiceView._setup_archetype_data = function (self)
	local player = self._preview_player
	local player_profile = player:profile()
	local archetype = player_profile.archetype
	local archetype_talents = archetype.talents
	local archetype_specializations = archetype.specializations
	self._archetype = archetype
	local widget_name_prefix = self._definitions.widget_name_prefix
	local widgets_by_name = self._widgets_by_name
	local career_banners = {}

	for specialization_name, specialization in pairs(archetype_specializations) do
		local order = specialization.choice_order

		if order then
			local widget = widgets_by_name[widget_name_prefix .. order]
			local content = widget.content
			content.background = specialization.choice_banner
			content.background_blurred = specialization.choice_banner .. "_blurred"
			content.title = TextUtils.localize_to_upper(specialization.title)
			content.short_description = specialization.description_short and self:_localize(specialization.description_short) or "Unique Point 1, Unique Point 2, Unique Point 3"
			content.description = self:_localize(specialization.description)
			local disabled = specialization.disabled
			local hotspot = content.hotspot
			hotspot.disabled = disabled
			hotspot.pressed_callback = not disabled and callback(self, "cb_banner_button_pressed", order)
			local banner = {
				banner_widget = widget,
				specialization = specialization_name,
				state = BANNER_STATES.idle,
				disabled = disabled
			}
			local specialization_talents = archetype_talents[specialization_name]

			self:_setup_details_list(order, specialization_talents, specialization, banner)

			career_banners[order] = banner
		end
	end

	self._career_banners = career_banners
end

TalentsCareerChoiceView._setup_details_list = function (self, column, archetype_talents, specialization, banner)
	local talent_groups = specialization.talent_groups
	local list_name = "career_" .. column .. "_list"
	local grid_scenegraph_id = list_name .. "_content"
	local mask_scenegraph_id = list_name .. "_mask"
	local interaction_scenegraph_id = mask_scenegraph_id
	local list_style = ViewStyles.career_banner.talents_list
	local grid_direction = "down"
	local blueprints = self._definitions.blueprints
	local widgets = {}
	local alignment_widgets = {}
	local list_padding = list_style.list_padding
	local item_spacing = list_style.item_spacing
	local min_level = PlayerSpecialization.specialization_level_requirement()

	for j = 1, #talent_groups do
		local talent_group = talent_groups[j]

		if talent_group.required_level <= min_level and not talent_group.invisible_in_ui then
			local widget_name_prefix = list_name .. "_widget_" .. j .. "_"
			local talents_in_group = talent_group.talents

			for i = 1, #talents_in_group do
				local talent_name = talents_in_group[i]
				local talent_data = archetype_talents[talent_name]
				local label = self:_localize(talent_data.display_name)
				local description = self:_localize(talent_data.description)
				local icon = talent_data.icon or talent_data.large_icon
				local blueprint = icon and blueprints.list_entry_with_icon or blueprints.list_entry_no_icon
				local text_style = blueprint.style.description
				local text_options = UIFonts.get_font_options_by_style(text_style)
				local text_size = {
					text_style.size[1],
					1
				}
				local _, text_height = UIRenderer.text_size(self._ui_renderer, description, text_style.font_type, text_style.font_size, text_size, text_options)
				local widget_size = {
					list_style.size[1],
					math.max(text_style.offset[2] + text_height, blueprint.min_height)
				}
				local widget_definition = UIWidget.create_definition(blueprint.passes, grid_scenegraph_id, nil, widget_size, blueprint.style)
				local widget_name = widget_name_prefix .. i
				local new_widget = self:_create_widget(widget_name, widget_definition)
				local content = new_widget.content
				content.label = label
				content.description = description
				content.icon = icon
				widgets[#widgets + 1] = new_widget
				alignment_widgets[#alignment_widgets + 1] = i == 1 and list_padding or item_spacing
				alignment_widgets[#alignment_widgets + 1] = new_widget
			end
		end
	end

	alignment_widgets[#alignment_widgets + 1] = list_padding
	local grid_widget = UIWidgetGrid:new(widgets, alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction)
	local scrollbar_widget = self._widgets_by_name["career_" .. column .. "_scrollbar"]

	grid_widget:assign_scrollbar(scrollbar_widget, grid_scenegraph_id, interaction_scenegraph_id)

	scrollbar_widget.alpha_multiplier = 0
	local mask = self._widgets_by_name["career_" .. column .. "_mask"]
	mask.alpha_multiplier = 0
	banner.grid = grid_widget
	banner.details_widgets = widgets
	banner.mask = mask
	banner.scrollbar = scrollbar_widget
	banner.min_required_level = min_level
end

return TalentsCareerChoiceView
