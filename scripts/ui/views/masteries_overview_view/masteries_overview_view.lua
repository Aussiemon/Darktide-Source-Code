-- chunkname: @scripts/ui/views/masteries_overview_view/masteries_overview_view.lua

local MasteriesOverviewViewDefinitions = require("scripts/ui/views/masteries_overview_view/masteries_overview_view_definitions")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/masteries_overview_view/masteries_overview_view_blueprints")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local Promise = require("scripts/foundation/utilities/promise")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local ViewElementGrid = require("scripts/ui/view_elements/view_element_grid/view_element_grid")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local WeaponUnlockSettings = require("scripts/settings/weapon_unlock_settings")
local FALLBACK_TEXTURE = "core/fallback_resources/missing_texture"
local MasteriesOverviewView = class("MasteriesOverviewView", "BaseView")

MasteriesOverviewView.init = function (self, settings, context)
	MasteriesOverviewView.super.init(self, MasteriesOverviewViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self._allow_close_hotkey = true
	self._mastery_milestones = {}
	self._mastery_traits = context.changeable_context and context.changeable_context.mastery_traits or {}
	self._mastery_marks = {}
	self._parent = context and context.parent

	local camera_settings = context.changeable_context.camera_settings

	if camera_settings then
		self:_set_camera_focus(camera_settings)
	end
end

MasteriesOverviewView._on_view_load_complete = function (self, loaded)
	MasteriesOverviewView.super._on_view_load_complete(self, loaded)
end

MasteriesOverviewView.on_enter = function (self)
	MasteriesOverviewView.super.on_enter(self)
	self:_register_event("event_mastery_updated", "_update_mastery_data")
	self:_register_event("event_mastery_traits_update", "_update_mastery_presentation")
	self:_setup_patterns_grid()
	self:_set_button_callbacks()
end

MasteriesOverviewView._reset_mastery_data_by_id = function (self, id)
	local mastery = id and self._masteries[id]

	if mastery then
		local traits = self._mastery_traits[id]

		mastery.points_available = 0
		mastery.start_exp = 0
		mastery.points_total = 0
		mastery.mastery_level = 0
		mastery.claimed_level = -1
		mastery.current_xp = 0
		mastery.points_used = 0
		mastery.end_exp = Mastery.get_xp_for_next_level(mastery)

		for i = 1, #traits do
			local trait = traits

			if trait.status == "seen" then
				trait.status = "unseen"
			end
		end
	end
end

MasteriesOverviewView._update_mastery_data = function (self, mastery_id)
	if self._setup_complete then
		local masteries_data = self._parent.masteries_data
		local parent_mastery_data = masteries_data[mastery_id]
		local mastery_data = self._masteries and self._masteries[mastery_id]

		if parent_mastery_data and mastery_data then
			local mastery_level = parent_mastery_data.mastery_level or 0
			local claimed_level = parent_mastery_data.claimed_level or -1
			local mastery_xp = parent_mastery_data.current_xp or 0
			local mastery_start_exp = parent_mastery_data.start_xp or 0
			local mastery_end_exp = parent_mastery_data.end_xp or 0

			mastery_data.mastery_level = mastery_level
			mastery_data.claimed_level = claimed_level
			mastery_data.current_xp = mastery_xp
			mastery_data.start_exp = mastery_start_exp
			mastery_data.end_exp = mastery_end_exp

			local trait_cat_id = Mastery.get_pattern_id_to_category_id(mastery_id)

			Managers.data_service.crafting:get_trait_sticker_book_by_id(trait_cat_id):next(function (data)
				if self._destroyed then
					return
				end

				local valid_traits = {}

				for name, trait_data in pairs(data) do
					if MasterItems.get_item(name) then
						valid_traits[#valid_traits + 1] = {
							trait_status = trait_data,
							trait_name = name,
						}
					end
				end

				table.sort(valid_traits, function (a, b)
					return a.trait_name < b.trait_name
				end)

				self._mastery_traits[mastery_id] = valid_traits

				local points_spent = Mastery.get_spent_points(valid_traits)
				local points_total = Mastery.get_all_unlocked_points(mastery_data)
				local points_available = Mastery.get_available_points(mastery_data, valid_traits)

				mastery_data.points_available = points_available
				mastery_data.points_used = points_spent
				mastery_data.points_total = points_total
				mastery_data.syncing = parent_mastery_data.syncing

				for i = 1, #self._masteries_layout do
					local layout = self._masteries_layout[i]

					if layout.mastery_id == mastery_id then
						layout.mastery_level = mastery_level
						layout.claimed_level = claimed_level
						layout.show_alert = points_available > 0

						break
					end
				end

				self:_update_mastery_presentation(mastery_id)
				Managers.event:trigger("event_mastery_overview_updated", mastery_id)
			end):catch(function ()
				if self._destroyed then
					return
				end

				self._masteries[mastery_id].syncing = parent_mastery_data.syncing

				self:_update_mastery_presentation(mastery_id)
				Managers.event:trigger("event_mastery_overview_updated", mastery_id)
			end)
		end
	end
end

MasteriesOverviewView._level_up_mastery = function (self, id)
	local mastery = id and self._masteries[id]

	if mastery then
		mastery.mastery_level = mastery.mastery_level + 1
		mastery.claimed_level = mastery.claimed_level + 1
		mastery.points_total = Mastery.get_all_unlocked_points(mastery)
		mastery.points_available = mastery.points_total - mastery.points_used

		local start_exp, end_exp = Mastery.get_start_and_end_xp_by_level(mastery)

		mastery.start_exp = start_exp
		mastery.end_exp = end_exp
		mastery.current_xp = start_exp
	end
end

MasteriesOverviewView._level_up_max_mastery = function (self, id)
	local mastery = id and self._masteries[id]

	if mastery then
		mastery.mastery_level = Mastery.get_mastery_max_level(mastery)
		mastery.claimed_level = mastery.mastery_level - 1
		mastery.points_total = Mastery.get_all_unlocked_points(mastery)
		mastery.points_available = mastery.points_total - mastery.points_used

		local start_exp, end_exp = Mastery.get_start_and_end_xp_by_level(mastery)

		mastery.start_exp = start_exp
		mastery.end_exp = end_exp
		mastery.current_xp = start_exp
	end
end

MasteriesOverviewView._update_mastery_presentation = function (self, optional_mastery_id)
	local grid_widgets = self._patterns_grid:widgets()

	for i = 1, #self._masteries_layout do
		local layout = self._masteries_layout[i]
		local id = layout.mastery_id

		if not optional_mastery_id or optional_mastery_id and optional_mastery_id == id then
			local mastery_data = self._masteries[id]

			if mastery_data then
				layout.mastery_level = mastery_data.mastery_level
				layout.expertise_level = Mastery.get_current_expertise_cap(mastery_data)
				layout.claimed_level = mastery_data.claimed_level
				layout.show_alert = mastery_data.points_available > 0

				for ii = 1, #grid_widgets do
					local widget = grid_widgets[ii]

					if widget.content.element and widget.content.element.mastery_id == mastery_data.mastery_id then
						widget.content.mastery_level = string.format(" %d", layout.mastery_level)
						widget.content.expertise_level = string.format(" %d", layout.expertise_level)
						widget.content.show_alert = layout.show_alert

						break
					end
				end
			end

			if optional_mastery_id then
				break
			end
		end
	end
end

MasteriesOverviewView._set_camera_focus = function (self, camera_settings)
	for i = 1, #camera_settings do
		Managers.event:trigger(unpack(camera_settings[i]))
	end
end

MasteriesOverviewView._set_button_callbacks = function (self)
	self._widgets_by_name.mastery_button.content.hotspot.pressed_callback = function ()
		local marks = UISettings.weapon_patterns[self._selected_pattern].marks
		local mark = marks[1]
		local master_item = mark.item and MasterItems.get_item(mark.item)
		local trait_category = Items.trait_category(master_item)
		local tabs_content = self._patterns_tabs_content
		local tab_index = self._patterns_tab_menu_element:selected_index()
		local tab_content = tabs_content[tab_index]
		local slot_type = tab_content.slot_types[1]

		Managers.ui:open_view("mastery_view", nil, nil, nil, nil, {
			mastery = self._masteries[self._selected_pattern],
			traits = self._mastery_traits[self._selected_pattern],
			milestones = self._mastery_milestones[self._selected_pattern],
			slot_type = slot_type,
			traits_id = trait_category,
			parent = self,
		})
	end
end

MasteriesOverviewView._setup_layout_entries = function (self)
	local layout = {}
	local weapon_patterns = UISettings.weapon_patterns
	local player = self:_player()
	local profile = player:profile()
	local profile_archetype = profile.archetype
	local archetype_name = profile_archetype.name
	local archetype_weapon_unlocks = WeaponUnlockSettings[archetype_name]
	local masteries_data = self._parent.masteries_data
	local masteries = {}

	for id, data in pairs(weapon_patterns) do
		repeat
			local mastery_data = masteries_data[id]
			local display_name = Localize(data.display_name)
			local master_item_name = mastery_data and Mastery.get_default_mark_for_mastery(mastery_data)
			local master_item = master_item_name and MasterItems.get_item(master_item_name)

			if master_item and mastery_data then
				local marks = Mastery.get_all_mastery_marks(mastery_data)
				local has_mark_unlocks = marks and #marks > 0
				local first_mark_item = has_mark_unlocks and marks[1].item
				local hud_icon = first_mark_item and first_mark_item.hud_icon or master_item.hud_icon

				hud_icon = hud_icon or "content/ui/materials/icons/weapons/hud/combat_blade_01"

				local allowed_archetypes = master_item.archetypes

				if not table.contains(allowed_archetypes, archetype_name) then
					break
				end

				local weapon_level_requirement

				for weapon_level, weapon_list in ipairs(archetype_weapon_unlocks) do
					if table.contains(weapon_list, master_item_name) then
						weapon_level_requirement = weapon_level

						break
					end
				end

				if weapon_level_requirement == nil then
					weapon_level_requirement = 1
				end

				local mastery_level = mastery_data.mastery_level or 0
				local claimed_level = mastery_data.claimed_level or -1
				local mastery_xp = mastery_data.current_xp or 0
				local mastery_start_exp = mastery_data.start_xp or 0
				local mastery_end_exp = mastery_data.end_xp or 0
				local mastery_max_level = Mastery.get_mastery_max_level(mastery_data)
				local expertise_level = Mastery.get_current_expertise_cap(mastery_data)
				local traits = self._mastery_traits[id]
				local points_spent = Mastery.get_spent_points(traits)
				local points_total = Mastery.get_all_unlocked_points(mastery_data)
				local points_available = Mastery.get_available_points(mastery_data, traits)

				layout[#layout + 1] = {
					widget_type = "weapon_pattern",
					icon = hud_icon,
					display_name = display_name,
					weapon_level_requirement = weapon_level_requirement,
					slot = master_item.slots[1],
					mastery_id = id,
					mastery_level = mastery_level,
					expertise_level = expertise_level,
					claimed_level = claimed_level,
					mastery_max_level = mastery_max_level,
					show_alert = points_available > 0,
				}
				masteries[id] = {
					display_name = display_name,
					mastery_level = mastery_level,
					claimed_level = claimed_level,
					mastery_max_level = mastery_max_level,
					current_xp = mastery_xp,
					icon = hud_icon,
					milestones = mastery_data.milestones,
					start_exp = mastery_start_exp,
					end_exp = mastery_end_exp,
					is_unlocked = weapon_level_requirement <= self:character_level(),
					mastery_id = id,
					points_total = points_total,
					points_used = points_spent,
					points_available = points_available,
					syncing = mastery_data.syncing,
				}
			end
		until true
	end

	self._masteries = masteries

	table.sort(layout, function (a, b)
		local a_level = a.weapon_level_requirement
		local b_level = b.weapon_level_requirement
		local a_name = a.display_name
		local b_name = b.display_name

		if a_level < b_level then
			return false
		elseif b_level < a_level then
			return true
		else
			return a_name < b_name
		end
	end)

	self._masteries_layout = layout

	return Promise.resolved(layout)
end

MasteriesOverviewView._setup_patterns_grid = function (self)
	local total_height = 0
	local widgets_by_name = self._widgets_by_name
	local title_text_widget = widgets_by_name.title_text

	if title_text_widget then
		local ui_renderer = self._ui_renderer
		local content = title_text_widget.content
		local style = title_text_widget.style
		local text_style = style.text
		local text_options = UIFonts.get_font_options_by_style(text_style)
		local _, height = UIRenderer.text_size(ui_renderer, content.text, text_style.font_type, text_style.font_size, text_style.size, text_options)

		height = height + 10

		self:_set_scenegraph_size("title_text", nil, height)

		local height_offset = 120

		self:_set_scenegraph_position("title_text", nil, height_offset)

		total_height = total_height + height + height_offset
	end

	local grid_settings = self._definitions.patterns_grid_settings
	local reference_name = "patterns_grid"

	if self._patterns_grid then
		self._patterns_grid = nil

		self:_remove_element(reference_name)
	end

	local layer = 10

	self._patterns_grid = self:_add_element(ViewElementGrid, reference_name, layer, grid_settings)

	self:_update_patterns_grid_position()
	self:_setup_layout_entries():next(function (layout)
		if self._destroyed then
			return
		end

		self._patterns_grid:set_loading_state(false)

		self._widgets_by_name.patterns_grid_panels.content.visible = true

		self:_update_patterns_grid_position()

		local tab_content_array = self._definitions.patterns_category_tabs_content

		self:_setup_menu_tabs(tab_content_array)
		self:_switch_tab(1)
	end)
end

MasteriesOverviewView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local widget_index = self._patterns_grid:widget_index(widget) or 1

	if not self._using_cursor_navigation then
		local scrollbar_animation_progress = self._patterns_grid:get_scrollbar_percentage_by_index(widget_index)

		self._patterns_grid:select_grid_index(widget_index, scrollbar_animation_progress, true)
	else
		self._patterns_grid:select_grid_index(widget_index)
	end

	local mastery_id = element.mastery_id

	self._selected_pattern = mastery_id
	self._selected_pattern_index = widget_index

	self:_present_mastery(mastery_id)
end

MasteriesOverviewView._update_patterns_grid_position = function (self)
	if not self._patterns_grid then
		return
	end

	local position = self:_scenegraph_world_position("patterns_grid_pivot")

	self._patterns_grid:set_pivot_offset(position[1], position[2])
end

MasteriesOverviewView._setup_menu_tabs = function (self, content)
	local tab_menu_settings = self._definitions.patterns_tab_menu_settings
	local id = "patterns_tab_menu"
	local layer = tab_menu_settings.layer or 20
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)

	self._patterns_tab_menu_element = tab_menu_element

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)
	tab_menu_element:set_is_handling_navigation_input(true)

	local tab_button_template = table.clone(tab_menu_settings.button_template or ButtonPassTemplates.item_category_sort_button)

	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
	}

	for i = 1, #tab_button_template do
		tab_button_template[i].style.offset = tab_menu_settings.button_offset
	end

	tab_button_template[7].style.size = tab_menu_settings.icon_size

	local tab_ids = {}

	for i = 1, #content do
		local tab_content = content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)

		tab_ids[i] = tab_id
	end

	tab_menu_element:set_is_handling_navigation_input(true)

	self._patterns_tabs_content = content
	self._patterns_tabs_ids = tab_ids

	self:_update_patterns_tab_bar_position()
end

MasteriesOverviewView._switch_tab = function (self, index)
	local tabs_content = self._patterns_tabs_content
	local tab_content = tabs_content[index]
	local slot_types = tab_content.slot_types
	local display_name

	self._selected_pattern_index = nil

	self:_present_layout_by_slot_filter(slot_types, nil, display_name)

	local tab_menu_element = self._patterns_tab_menu_element

	if tab_menu_element and index ~= tab_menu_element:selected_index() then
		tab_menu_element:set_selected_index(index)

		self._widgets_by_name.patterns_grid_panels.content.display_name = tab_content.display_name
	end
end

MasteriesOverviewView._present_layout_by_slot_filter = function (self, slot_filter, item_type_filter, optional_display_name, optional_callback)
	local layout = self._masteries_layout

	if layout then
		local filtered_layout = {}

		for i = #layout, 1, -1 do
			local entry = layout[i]
			local slot = entry.slot

			if slot_filter and not table.is_empty(slot_filter) and slot and table.find(slot_filter, slot) then
				filtered_layout[#filtered_layout + 1] = entry
			end
		end

		self._filtered_masteries_layout = filtered_layout
		self._grid_display_name = optional_display_name

		local on_present_callback = callback(self, "_cb_on_present", optional_callback)
		local grid_display_name = self._grid_display_name
		local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
		local grid_settings = self._definitions.patterns_grid_settings
		local grid_size = grid_settings.grid_size
		local spacing_entry = {
			widget_type = "spacing_vertical",
		}

		table.insert(filtered_layout, 1, spacing_entry)
		table.insert(filtered_layout, #filtered_layout + 1, spacing_entry)

		local grow_direction = "down"

		self._patterns_grid:present_grid_layout(filtered_layout, ContentBlueprints, left_click_callback, nil, grid_display_name, grow_direction, on_present_callback, nil)
	end
end

MasteriesOverviewView._update_patterns_tab_bar_position = function (self)
	if not self._patterns_tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("patterns_grid_tab_panel")

	self._patterns_tab_menu_element:set_pivot_offset(position[1], position[2])
end

MasteriesOverviewView._cb_on_present = function (self, optional_callback)
	local grid_widgets = self._patterns_grid:widgets()
	local selection_index = self._selected_pattern_index or self._patterns_grid:selected_grid_index() or self._patterns_grid:first_interactable_grid_index()
	local selected_widget = grid_widgets[selection_index]

	if selected_widget then
		selected_widget.content.hotspot.pressed_callback()
	end

	if optional_callback then
		optional_callback()
	end

	self._setup_complete = true
end

MasteriesOverviewView._handle_input = function (self, input_service, dt, t)
	local using_cursor = self._using_cursor_navigation

	if not using_cursor then
		if input_service:get("confirm_pressed") then
			if self._widgets_by_name.mastery_button.content.visible and not self._widgets_by_name.mastery_button.content.hotspot.disabled then
				self._widgets_by_name.mastery_button.content.hotspot.pressed_callback()
			end
		elseif self._patterns_grid then
			local selected_index = self._patterns_grid:selected_grid_index()

			if self._selected_pattern_index ~= selected_index then
				self._selected_pattern_index = selected_index

				local widgets = self._patterns_grid:widgets()
				local widget = widgets[selected_index]
				local element = widget.content.element
				local mastery_id = element.mastery_id

				self._selected_pattern = mastery_id

				self:_present_mastery(mastery_id)
			end
		end
	end
end

MasteriesOverviewView._on_navigation_input_changed = function (self)
	return
end

MasteriesOverviewView.draw = function (self, dt, t, input_service, layer)
	MasteriesOverviewView.super.draw(self, dt, t, input_service, layer)
end

MasteriesOverviewView.on_resolution_modified = function (self, scale)
	MasteriesOverviewView.super.on_resolution_modified(self, scale)
	self:_update_patterns_grid_position()
	self:_update_patterns_tab_bar_position()

	if self._selected_pattern then
		self:_present_mastery(self._selected_pattern)
	end
end

MasteriesOverviewView.update = function (self, dt, t, input_service)
	return MasteriesOverviewView.super.update(self, dt, t, input_service)
end

MasteriesOverviewView.on_exit = function (self)
	MasteriesOverviewView.super.on_exit(self)
end

MasteriesOverviewView._fetch_mastery_data = function (self, mastery_id)
	local milestones_data = self:_get_milestones_data(mastery_id)
	local blessing_data = self:_get_traits_data(mastery_id)
	local marks_data = self:_get_marks_data(mastery_id)

	return Promise.all(milestones_data, blessing_data, marks_data):next(function (data)
		if self._destroyed then
			return
		end

		self._mastery_milestones[mastery_id] = table.clone(data[1])
		self._mastery_traits[mastery_id] = table.clone(data[2])
		self._mastery_marks[mastery_id] = table.clone(data[3])

		return Promise.resolved()
	end):catch(function (error)
		return Promise.rejected()
	end)
end

MasteriesOverviewView._mastery_data_available = function (self, mastery_id)
	return self._mastery_milestones[mastery_id] and self._mastery_traits[mastery_id] and self._mastery_marks[mastery_id]
end

MasteriesOverviewView._present_mastery = function (self, mastery_id)
	local fetch_promise

	if not self:_mastery_data_available(mastery_id) then
		fetch_promise = self:_fetch_mastery_data(mastery_id)
	else
		fetch_promise = Promise.resolved()
	end

	return fetch_promise:next(function ()
		if self._destroyed then
			return
		end

		local widgets_by_name = self._widgets_by_name
		local mastery_level_widget = widgets_by_name.mastery_level
		local expertise_level_widget = widgets_by_name.expertise_level
		local mastery_info_widget = widgets_by_name.mastery_info
		local pattern_info_widget = widgets_by_name.pattern_info
		local mastery_button_widget = widgets_by_name.mastery_button
		local mastery_data = self._masteries[mastery_id]
		local milestones = self._mastery_milestones[mastery_id]
		local traits = self._mastery_traits[mastery_id]
		local marks = self._mastery_marks[mastery_id]
		local claimed_level = mastery_data.claimed_level
		local mastery_level = mastery_data.mastery_level

		mastery_button_widget.content.visible = true
		mastery_button_widget.content.hotspot.disabled = not mastery_data.is_unlocked

		local mastery_display_name = mastery_data.display_name
		local mastery_max_level = mastery_data.mastery_max_level
		local mastery_icon = marks and marks[1] and marks[1].icon
		local mastery_start_exp = mastery_data.start_exp
		local mastery_end_exp = mastery_data.end_exp
		local mastery_current_xp = mastery_data.current_xp
		local is_max_level = mastery_max_level <= mastery_level
		local mastery_end_exp_text = mastery_end_exp - mastery_start_exp
		local mastery_current_xp_text = is_max_level and mastery_end_exp_text or mastery_current_xp - mastery_start_exp
		local mastery_next_level = math.min(mastery_level + 1, mastery_max_level)

		mastery_info_widget.content.weapon_panel = nil

		if self._patterns_tab_menu_element then
			local tabs_content = self._patterns_tabs_content
			local tab_index = self._patterns_tab_menu_element:selected_index()
			local tab_content = tabs_content[tab_index]
			local slot_types = tab_content.slot_types

			mastery_info_widget.content.weapon_panel = slot_types[1]
		end

		self:_set_pattern_icon(mastery_id, is_max_level)

		pattern_info_widget.content.pattern_name = mastery_display_name

		local font_size = self._render_settings.scale * 30
		local current_expertise = Mastery.get_current_expertise_cap(mastery_data)
		local max_expertise = Mastery.get_max_expertise_cap(mastery_data)
		local remaining_expertise_to_max = max_expertise - current_expertise

		expertise_level_widget.content.info = string.format("{#size(" .. font_size * 2 .. ")} %d{#reset()} / %d", current_expertise, max_expertise)
		mastery_level_widget.content.info = string.format("{#size(" .. font_size * 2 .. ")} %d{#reset()}", mastery_level)
		mastery_level_widget.content.mastery_level_next = string.format(" %d", mastery_next_level)
		mastery_level_widget.content.description = Localize("loc_mastery_exp_current_next", true, {
			current = mastery_current_xp_text,
			next = mastery_end_exp_text,
		})

		local max_bar_width = mastery_level_widget.style.experience_bar_background.size[1]
		local bar_progress = (is_max_level or mastery_start_exp == mastery_end_exp) and 1 or math.ilerp(mastery_start_exp, mastery_end_exp, mastery_current_xp)
		local bar_width = bar_progress * max_bar_width

		mastery_level_widget.style.experience_bar.size[1] = bar_width

		local mastery_info_width, mastery_info_height = self:_scenegraph_size("mastery_level")
		local size_addition_removed_value = 80

		mastery_info_widget.content.visible = true
		mastery_level_widget.content.visible = true
		expertise_level_widget.content.visible = true
		pattern_info_widget.content.vislble = true
	end)
end

MasteriesOverviewView._get_next_milestone = function (mastery_data)
	local claimed_level = mastery_data.claimed_level or -1
	local max_level = Mastery.get_mastery_max_level(mastery_data)

	if mastery_data.claimed_level == max_level - 1 then
		return
	end

	local next_milestone_index = claimed_level + 2

	return mastery_data.milestones[next_milestone_index]
end

MasteriesOverviewView._get_milestones_data = function (self, mastery_id)
	if not mastery_id then
		return
	end

	local milestones_data = {}
	local mastery_data = self._masteries[mastery_id]
	local milestones = mastery_data.milestones
	local pattern_data = UISettings.weapon_patterns[mastery_id]
	local pattern_marks = pattern_data.marks
	local claimed_level = mastery_data.claimed_level or -1

	for i = 1, #milestones do
		local milestone = milestones[i]
		local unlocked_level = milestone.level and milestone.level - 1 or 0
		local milestones_ui_data = Mastery.get_milestone_ui_data(milestone)
		local start_claim, end_claim = Mastery.get_levels_to_claim(mastery_data)

		for f = 1, #milestones_ui_data do
			local milestone_ui_data = milestones_ui_data[f]

			milestones_data[#milestones_data + 1] = {
				icon = milestone_ui_data.icon,
				level = milestone.level,
				display_name = milestone_ui_data.display_name,
				unlocked = unlocked_level <= claimed_level,
				can_unlock = start_claim <= end_claim and unlocked_level == start_claim,
				text = milestone_ui_data.text,
				icon_size = milestone_ui_data.icon_size,
				icon_color = milestone_ui_data.icon_color,
				icon_material_values = milestone_ui_data.icon_material_values,
				type = milestone_ui_data.type,
			}
		end
	end

	table.sort(milestones_data, function (a, b)
		local a_level = a.level or 0
		local b_level = b.level or 0

		return a_level < b_level
	end)

	return Promise.resolved(milestones_data)
end

MasteriesOverviewView._get_marks_data = function (self, mastery_id)
	if not mastery_id then
		return
	end

	local mastery_data = self._masteries[mastery_id]
	local marks_data = Mastery.get_all_mastery_marks(mastery_data)

	return Promise.resolved(marks_data)
end

MasteriesOverviewView._get_traits_data = function (self, mastery_id)
	if not mastery_id then
		return
	end

	if self._mastery_traits[mastery_id] then
		return Promise.resolved(self._mastery_traits[mastery_id])
	else
		return Managers.data_service.mastery:get_traits_data_by_mastery_id(mastery_id)
	end
end

MasteriesOverviewView._set_pattern_icon = function (self, mastery_id, is_max_level)
	local ui_setting_pattern_data = UISettings.weapon_patterns[mastery_id]
	local pattern_icon_material_values = self._widgets_by_name.mastery_info.style.pattern_icon.material_values
	local lerp_t = is_max_level and 1 or 0

	pattern_icon_material_values.weapon_texture_complete = ui_setting_pattern_data and ui_setting_pattern_data.overview_icon_texture_complete or FALLBACK_TEXTURE
	pattern_icon_material_values.weapon_texture_incomplete = ui_setting_pattern_data and ui_setting_pattern_data.overview_icon_texture or FALLBACK_TEXTURE
	pattern_icon_material_values.weapon_texture_mask = ui_setting_pattern_data and ui_setting_pattern_data.overview_icon_texture_mask or FALLBACK_TEXTURE
	pattern_icon_material_values.lerp_t = lerp_t
end

return MasteriesOverviewView
