-- chunkname: @scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view.lua

local Definitions = require("scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local InventoryWeaponMarksViewSettings = require("scripts/ui/views/inventory_weapon_marks_view/inventory_weapon_marks_view_settings")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Mastery = require("scripts/utilities/mastery")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local ContentBlueprints = require("scripts/ui/views/masteries_overview_view/masteries_overview_view_blueprints")
local InventoryWeaponMarksView = class("InventoryWeaponMarksView", "ItemGridViewBase")
local trinket_slot_order = {
	"slot_trinket_1",
	"slot_trinket_2",
}
local remove_attachment_item_slot_path

function remove_attachment_item_slot_path(target_table, slot_id, item, link_item, optional_path)
	local unused_trinket_name = "content/items/weapons/player/trinkets/unused_trinket"
	local path = optional_path or nil

	for k, t in pairs(target_table) do
		if type(t) == "table" then
			if k == slot_id then
				t.item = "content/items/weapons/player/trinkets/empty_trinket"

				return
			else
				local previous_path = path

				path = path and path .. "." .. k or k

				local alternative_path, path_item = remove_attachment_item_slot_path(t, slot_id, item, link_item, path)

				if alternative_path then
					return
				else
					path = previous_path
				end
			end
		end
	end
end

InventoryWeaponMarksView.init = function (self, settings, context)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._parent = context.parent
	self._visibility_toggled_on = true
	self._preview_player = context.player or Managers.player:local_player(1)

	local selected_item = context.preview_item

	if selected_item then
		self._presentation_item = MasterItems.create_preview_item_instance(selected_item)
		self._equipped_item = table.clone_instance(self._presentation_item)

		for i = 1, #trinket_slot_order do
			local slot_id = trinket_slot_order[i]
			local link_item_to_slot = false

			remove_attachment_item_slot_path(self._presentation_item.__master_item, slot_id, nil, link_item_to_slot)
			remove_attachment_item_slot_path(self._presentation_item.__gear.masterDataInstance.overrides, slot_id, nil, link_item_to_slot)
		end

		self._presentation_item.__gear.masterDataInstance.slot_weapon_skin = nil
		self._presentation_item.__master_item.slot_weapon_skin = nil
	end

	self._sort_options = {}

	InventoryWeaponMarksView.super.init(self, Definitions, settings, context)

	self._grow_direction = "down"
	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._weapon_zoom_fraction = -0.45
	self._weapon_zoom_target = -0.45
	self._min_zoom = -0.45
	self._max_zoom = 4
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponMarksView._setup_forward_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 101
	local world_name = self._unique_id .. "_ui_forward_world"
	local view_name = self.view_name

	self._world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

	local viewport_name = self._unique_id .. "_ui_forward_world_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1

	self._viewport = ui_manager:create_viewport(self._world, viewport_name, viewport_type, viewport_layer)
	self._viewport_name = viewport_name

	local renderer_name = self._unique_id .. "_forward_renderer"

	self._ui_forward_renderer = ui_manager:create_renderer(renderer_name, self._world)

	local gui = self._ui_forward_renderer.gui
	local gui_retained = self._ui_forward_renderer.gui_retained
	local resource_renderer_name = self._unique_id
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"

	self._ui_resource_renderer = ui_manager:create_renderer(resource_renderer_name, self._world, true, gui, gui_retained, material_name)
end

InventoryWeaponMarksView._destroy_forward_gui = function (self)
	if self._ui_resource_renderer then
		local renderer_name = self._unique_id

		self._ui_resource_renderer = nil

		Managers.ui:destroy_renderer(renderer_name)
	end

	if self._ui_forward_renderer then
		self._ui_forward_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_forward_renderer")

		local world = self._world
		local viewport_name = self._viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._viewport_name = nil
		self._world = nil
	end
end

InventoryWeaponMarksView.on_exit = function (self)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	self:_destroy_forward_gui()

	if self._equipped_item and self._equipped_item ~= self._presentation_item then
		local gear_id = self._presentation_item.__original_gear_id
		local mark_id = self._equipped_item.name

		Managers.event:trigger("event_switch_mark", gear_id, mark_id, self._selected_item)
	end

	InventoryWeaponMarksView.super.on_exit(self)
end

InventoryWeaponMarksView.on_enter = function (self)
	InventoryWeaponMarksView.super.on_enter(self)

	self._render_settings.alpha_multiplier = 0

	self:_setup_forward_gui()

	self._background_widget = self:_create_widget("background", Definitions.background_widget)

	self:_setup_input_legend()

	if not self._on_enter_anim_id then
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)
	end

	if not self._presentation_item then
		return
	end

	self:_equip_weapon_mark()

	local grid_size = Definitions.grid_settings.grid_size

	self._content_blueprints = require("scripts/ui/view_content_blueprints/item_blueprints")(grid_size)

	self:_register_button_callbacks()
	self:_fetch_marks():next(function (marks)
		local layout = {}
		local mastery_id = self._mastery_id
		local pattern_data = UISettings.weapon_patterns[mastery_id]
		local mastery_name = pattern_data and pattern_data.display_name and Localize(pattern_data.display_name)

		self._widgets_by_name.display_name.content.text = mastery_name and Utf8.upper(Localize("loc_inventory_weapon_marks_title", true, {
			pattern_name = mastery_name,
		})) or ""

		for i = 1, #marks do
			local mark = marks[i]
			local preview_item

			if mark.item and mark.item.name == self._presentation_item.name then
				preview_item = self._presentation_item
				self._selected_index = i
			else
				preview_item = self:_generate_fake_mark_item(mark, marks)
			end

			local display_name = mark.display_name

			if not mark.unlocked then
				display_name = Localize("loc_inventory_mark_locked", true, {
					mastery_level = mark.level,
				})
			end

			if preview_item then
				layout[#layout + 1] = {
					widget_type = "weapon_mark",
					icon = mark.icon,
					level = mark.level,
					mark_name = display_name,
					is_unlocked = mark.unlocked,
					mastery_name = mastery_name,
					comparison_text = mark.comparison_text,
					preview_item = preview_item,
					equipped = preview_item.name == self._presentation_item.name,
				}
			end
		end

		self._item_grid:set_loading_state(false)
		self:present_grid_layout(layout)
	end)
end

InventoryWeaponMarksView._setup_item_grid = function (self, optional_grid_settings)
	if not self._presentation_item then
		return
	end

	InventoryWeaponMarksView.super._setup_item_grid(self, optional_grid_settings)
	self._item_grid:set_visibility(false)
end

InventoryWeaponMarksView._generate_fake_mark_item = function (self, mark, marks)
	local generate_item = MasterItems.create_preview_item_instance(self._presentation_item)
	local mark_item = mark.item

	if not mark_item then
		return
	end

	if not mark_item then
		return generate_item
	end

	local generate_weapon_template = WeaponTemplate.weapon_template_from_item(generate_item)
	local generate_compairing_stats = generate_weapon_template.base_stats
	local weapon_template = WeaponTemplate.weapon_template_from_item(mark_item)
	local compairing_stats = weapon_template.base_stats
	local stat_order = {}

	if generate_item.base_stats then
		for i = 1, #generate_item.base_stats do
			local stat = generate_item.base_stats[i]
			local stat_data = generate_compairing_stats[stat.name]
			local stat_name = stat_data and stat_data.display_name

			if stat_name then
				stat_order[stat_name] = i
			end
		end
	end

	local compairing_stats_array = {}
	local missing_matches = {}
	local index = 0

	for key, stat in pairs(compairing_stats) do
		index = index + 1

		local stat_value = stat.value or 0
		local stat_name = stat.display_name
		local order = stat_order[stat_name]

		compairing_stats_array[index] = {
			display_name = stat_name,
			name = key,
			key = order,
			index = index,
		}

		if order then
			stat_order[stat_name] = nil
		else
			missing_matches[#missing_matches + 1] = compairing_stats_array[index]
		end
	end

	for i = 1, #missing_matches do
		local missing_match = missing_matches[i]

		for name, order in pairs(stat_order) do
			missing_match.key = order
			stat_order[name] = nil

			break
		end
	end

	local function sort_function(a, b)
		local a_key = a.key
		local b_key = b.key

		if a_key and b_key then
			return a_key < b_key
		else
			return a.name < b.name
		end
	end

	table.sort(compairing_stats_array, sort_function)
	table.merge_recursive(generate_item, mark_item)

	if compairing_stats_array then
		for index, stat_data in pairs(compairing_stats_array) do
			if generate_item.base_stats then
				generate_item.base_stats[index].name = stat_data.name
			end
		end
	end

	return generate_item
end

InventoryWeaponMarksView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button

	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryWeaponMarksView._update_equip_button_state = function (self)
	local disable_button = self._selected_widget and not self._selected_widget.content.is_unlocked

	if not disable_button and self._selected_item and self._equipped_item then
		disable_button = self._selected_item.name == self._equipped_item.name
	end

	local button = self._widgets_by_name.equip_button
	local button_content = button.content

	button_content.hotspot.disabled = not not disable_button
	button_content.text = Utf8.upper(disable_button and Localize("loc_weapon_inventory_equipped_button") or Localize("loc_weapon_inventory_equip_button"))
end

InventoryWeaponMarksView.present_grid_layout = function (self, layout)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local grid_settings = self._definitions.grid_settings
	local grid_size = grid_settings.grid_size
	local used_layout = table.clone_instance(layout)
	local mark_size = ContentBlueprints.weapon_mark and ContentBlueprints.weapon_mark.size or {
		0,
		0,
	}
	local spacing = grid_settings.grid_spacing
	local top_padding = grid_settings.grid_spacing
	local new_grid_height = grid_size[2]

	if #used_layout > 0 then
		new_grid_height = #used_layout * mark_size[2] + (#used_layout - 1) * spacing[2] + 50
	end

	local new_mask_height = new_grid_height + 40

	self._item_grid:update_grid_height(new_grid_height, new_mask_height)

	local spacing_entry = {
		widget_type = "spacing_vertical",
	}

	table.insert(used_layout, 1, spacing_entry)
	table.insert(used_layout, #layout + 1, spacing_entry)

	local grow_direction = "down"

	local function on_present_callback()
		self._weapon_stats:present_item(self._presentation_item)
		self:_setup_weapon_preview()
		self:_preview_item(self._presentation_item)

		local index = self._selected_index or 1
		local selected_widget = self._item_grid:widget_by_index(index)

		if selected_widget then
			local element = self._item_grid:element_by_index(index)

			self:cb_on_grid_entry_left_pressed(selected_widget, element)
		end

		self._widgets_by_name.equip_button.content.visible = true
	end

	self._item_grid:present_grid_layout(layout, ContentBlueprints, left_click_callback, nil, grid_display_name, grow_direction, on_present_callback)
	self._item_grid:set_visibility(true)
end

InventoryWeaponMarksView.cb_on_grid_entry_left_pressed = function (self, widget, element)
	local item = element.preview_item

	if item and item ~= self._selected_item then
		self._weapon_stats:present_item(item)
		self:_setup_weapon_preview()
		self:_preview_item(item)

		local comparison_text = element.comparison_text

		if comparison_text then
			self._widgets_by_name.description_text.content.text = comparison_text
		else
			self._widgets_by_name.description_text.content.text = ""
		end

		if widget then
			self._selected_item = item
			self._selected_widget = widget
		else
			self._selected_item = nil
			self._selected_widget = nil
		end

		local widget_index = self._item_grid:widget_index(widget) or 1

		self._selected_index = widget_index

		self._item_grid:select_grid_index(widget_index)
	end
end

InventoryWeaponMarksView._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 10
		local context = {
			draw_background = true,
			ignore_blur = true,
		}

		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, context)

		local allow_rotation = true

		self._weapon_preview:set_force_allow_rotation(allow_rotation)
		self:_set_weapon_zoom(self._weapon_zoom_fraction)
		self._weapon_preview:center_align(0, {
			0,
			0,
			-0.1,
		})
	end
end

InventoryWeaponMarksView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponMarksView._fetch_marks = function (self)
	local pattern_name = self._presentation_item.parent_pattern

	return Managers.data_service.mastery:get_mastery_by_pattern(pattern_name):next(function (mastery_data)
		self._mastery_id = mastery_data.mastery_id

		local mark_milestones = Mastery.get_all_mastery_marks(mastery_data)

		return mark_milestones
	end)
end

InventoryWeaponMarksView._equip_weapon_mark = function (self)
	if self._equipped_item and self._selected_item and self._equipped_item.name ~= self._selected_item.name and self._selected_widget.content.is_unlocked then
		self._equipped_item = self._selected_item or self._presentation_item

		local widgets = self._item_grid:widgets()

		for i = 1, #widgets do
			local widget = widgets[i]

			if widget.content.equipped ~= nil then
				widget.content.equipped = false
			end
		end

		if self._selected_widget then
			self._selected_widget.content.equipped = true
		end
	end
end

InventoryWeaponMarksView.cb_on_equip_pressed = function (self)
	self:_equip_weapon_mark()
end

InventoryWeaponMarksView._cb_on_close_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_marks_view")
end

InventoryWeaponMarksView._preview_element = function (self, element)
	local selected_tab_index = self._selected_tab_index
	local content = self._tabs_content[selected_tab_index]
	local apply_on_preview = content.apply_on_preview
	local presentation_item = self._presentation_item
	local item = element.item
	local real_item = element.real_item

	self._previewed_item = item
	self._previewed_element = element

	apply_on_preview(real_item, presentation_item)
	self:_preview_item(presentation_item)
end

InventoryWeaponMarksView._preview_item = function (self, item)
	local slots = item.slots or {}
	local item_name = item.name
	local gear_id = item.gear_id or item_name

	if self._weapon_preview then
		local disable_auto_spin = false

		self._weapon_preview:present_item(item, disable_auto_spin)
	end

	local visible = true

	self:_set_preview_widgets_visibility(visible)
end

InventoryWeaponMarksView.on_back_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_marks_view")
end

InventoryWeaponMarksView._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction

	self:_update_weapon_preview_viewport()
end

InventoryWeaponMarksView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local weapon_zoom_fraction = self._weapon_zoom_fraction or 1
		local use_custom_zoom = true
		local optional_node_name = "p_zoom"
		local optional_pos
		local min_zoom = self._min_zoom
		local max_zoom = self._max_zoom

		weapon_preview:set_weapon_zoom(weapon_zoom_fraction, use_custom_zoom, optional_node_name, optional_pos, min_zoom, max_zoom)
	end
end

InventoryWeaponMarksView._handle_input = function (self, input_service, dt, t)
	local using_cursor = self._using_cursor_navigation

	if input_service:get("confirm_pressed") then
		self:cb_on_equip_pressed()
	elseif not using_cursor then
		local scroll_axis = input_service:get("scroll_axis")

		if scroll_axis then
			local scroll = scroll_axis[2]
			local scroll_speed = 0.25

			if InputDevice.gamepad_active then
				scroll = math.abs(scroll) > math.abs(scroll_axis[1]) and scroll or 0
				scroll_speed = 0.1
			end

			self._weapon_zoom_target = math.clamp(self._weapon_zoom_target + scroll * scroll_speed, self._min_zoom, self._max_zoom)

			if math.abs(self._weapon_zoom_target - self._weapon_zoom_fraction) > 0.01 then
				local weapon_zoom_fraction = math.lerp(self._weapon_zoom_fraction, self._weapon_zoom_target, dt * 2)

				self:_set_weapon_zoom(weapon_zoom_fraction)
			end
		end

		local current_index = self._item_grid:selected_grid_index()

		if current_index ~= self._selected_index then
			local widget = self._item_grid:widget_by_index(current_index)
			local config = widget and widget.content.element

			if widget and config then
				self:cb_on_grid_entry_left_pressed(widget, config)
			end
		end
	end
end

InventoryWeaponMarksView.update = function (self, dt, t, input_service)
	self:_update_equip_button_state()

	return InventoryWeaponMarksView.super.update(self, dt, t, input_service)
end

InventoryWeaponMarksView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_default_renderer = self._ui_default_renderer
	local ui_forward_renderer = self._ui_forward_renderer
	local ui_renderer = self._ui_renderer

	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale

	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self.animated_alpha_multiplier or 0

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._background_widget, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_forward_renderer)
	UIRenderer.end_pass(ui_forward_renderer)
	self:_draw_elements(dt, t, ui_forward_renderer, render_settings, input_service)
	self:_draw_render_target()

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

InventoryWeaponMarksView._draw_render_target = function (self)
	local ui_forward_renderer = self._ui_forward_renderer
	local gui = ui_forward_renderer.gui
	local color = Color(255, 255, 255, 255)
	local ui_resource_renderer = self._ui_resource_renderer
	local material = ui_resource_renderer.render_target_material
	local scale = self._render_scale or 1
	local width, height = self:_scenegraph_size("canvas")
	local position = self:_scenegraph_world_position("canvas")
	local size = {
		width,
		height,
	}
	local gui_position = Vector3(position[1] * scale, position[2] * scale, position[3] or 0)
	local gui_size = Vector3(size[1] * scale, size[2] * scale, size[3] or 0)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size, color)
end

InventoryWeaponMarksView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local always_visible_widget_names = self._always_visible_widget_names
	local alpha_multiplier = render_settings and render_settings.alpha_multiplier
	local widgets = self._widgets
	local num_widgets = #widgets

	for i = 1, num_widgets do
		local widget = widgets[i]
		local widget_name = widget.name

		UIWidget.draw(widget, ui_renderer)
	end
end

InventoryWeaponMarksView.on_resolution_modified = function (self, scale)
	InventoryWeaponMarksView.super.on_resolution_modified(self, scale)
	self:_update_tab_bar_position()
end

return InventoryWeaponMarksView
