local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_definitions")
local InventoryWeaponCosmeticsViewSettings = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_settings")
local ItemGridViewBase = require("scripts/ui/views/item_grid_view_base/item_grid_view_base")
local ItemUtils = require("scripts/utilities/items")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local MasterItems = require("scripts/backend/master_items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local Promise = require("scripts/foundation/utilities/promise")
local trinket_slot_order = {
	"slot_trinket_1",
	"slot_trinket_2"
}
local find_link_attachment_item_slot_path = nil

function find_link_attachment_item_slot_path(target_table, slot_id, item, link_item, optional_path)
	local unused_trinket_name = "content/items/weapons/player/trinkets/unused_trinket"
	local path = optional_path or nil

	for k, t in pairs(target_table) do
		if type(t) == "table" then
			if k == slot_id then
				if not t.item or t.item ~= unused_trinket_name then
					path = path and path .. "." .. k or k

					if link_item then
						t.item = item
					end

					return path, t.item
				else
					return nil
				end
			else
				local previous_path = path
				path = path and path .. "." .. k or k
				local alternative_path, path_item = find_link_attachment_item_slot_path(t, slot_id, item, link_item, path)

				if alternative_path then
					return alternative_path, path_item
				else
					path = previous_path
				end
			end
		end
	end
end

local InventoryWeaponCosmeticsView = class("InventoryWeaponCosmeticsView", "ItemGridViewBase")

InventoryWeaponCosmeticsView.init = function (self, settings, context)
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._context = context
	self._visibility_toggled_on = true
	self._preview_player = context.player or Managers.player:local_player(1)
	self._selected_item = context.preview_item
	local selected_item = self._selected_item

	if selected_item then
		self._presentation_item = MasterItems.create_preview_item_instance(selected_item)
		local trinket_path, trinket_item = nil

		for i = 1, #trinket_slot_order do
			local slot_id = trinket_slot_order[i]
			local link_item_to_slot = false

			if selected_item.__gear.masterDataInstance.overrides then
				trinket_path, trinket_item = find_link_attachment_item_slot_path(selected_item.__gear.masterDataInstance.overrides, slot_id, nil, link_item_to_slot)
			end

			if not trinket_item then
				trinket_path, trinket_item = find_link_attachment_item_slot_path(selected_item.__master_item, slot_id, nil, link_item_to_slot)
			end

			if trinket_item then
				break
			end
		end

		if trinket_item and trinket_item and trinket_item ~= "content/items/weapons/player/trinkets/empty_trinket" then
			self._selected_weapon_trinket_name = trinket_item
			self._initial_weapon_trinket_name = trinket_item
		end

		self._selected_weapon_skin_name = selected_item.slot_weapon_skin

		if not self._selected_weapon_skin_name and selected_item.gear.masterDataInstance.overrides then
			self._selected_weapon_skin_name = selected_item.gear.masterDataInstance.overrides.slot_weapon_skin
		end

		self._initial_weapon_skin_name = self._selected_weapon_skin_name
	end

	InventoryWeaponCosmeticsView.super.init(self, Definitions, settings)

	self._grow_direction = "down"
	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._pass_input = false
	self._pass_draw = false
end

InventoryWeaponCosmeticsView._setup_forward_gui = function (self)
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

InventoryWeaponCosmeticsView._destroy_forward_gui = function (self)
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

InventoryWeaponCosmeticsView.on_exit = function (self)
	self:_destroy_forward_gui()
	InventoryWeaponCosmeticsView.super.on_exit(self)
end

InventoryWeaponCosmeticsView.on_enter = function (self)
	InventoryWeaponCosmeticsView.super.on_enter(self)
	self:_setup_forward_gui()

	self._background_widget = self:_create_widget("background", Definitions.background_widget)

	if not self._selected_item then
		return
	end

	local grid_size = Definitions.grid_settings.grid_size
	self._content_blueprints = require("scripts/ui/view_content_blueprints/item_blueprints")(grid_size)

	self:_setup_input_legend()

	local tabs_content = {}
	tabs_content[1] = {
		display_name = "loc_weapon_cosmetics_title_skins",
		slot_name = "slot_weapon_skin",
		item_type = "WEAPON_SKIN",
		icon = "content/ui/materials/icons/item_types/weapon_skins",
		filter_on_weapon_template = true,
		get_item_filters = function (slot_name, item_type)
			if item_type then
				local item_type_filter = {
					item_type
				}
			end

			return nil, item_type_filter
		end,
		setup_selected_item_function = function (real_item, selected_item)
			local selected_weapon_trinket_name = self._selected_weapon_trinket_name

			if selected_weapon_trinket_name and real_item and real_item.gear.masterDataInstance.id == selected_weapon_trinket_name then
				self._selected_weapon_trinket = real_item
			end
		end,
		get_empty_item = function (selected_item)
			local visual_item = nil

			if selected_item.gear then
				visual_item = MasterItems.create_preview_item_instance(selected_item)
			else
				visual_item = table.clone_instance(selected_item)
			end

			visual_item.empty_item = true
			visual_item.slot_weapon_skin = nil

			if visual_item.gear.masterDataInstance.overrides then
				visual_item.gear.masterDataInstance.overrides.slot_weapon_skin = nil
			end

			return visual_item
		end,
		generate_visual_item_function = function (real_item, selected_item)
			local visual_item = nil

			if real_item.gear then
				visual_item = MasterItems.create_preview_item_instance(selected_item)
			else
				visual_item = table.clone_instance(selected_item)
			end

			visual_item.gear_id = real_item.gear_id
			visual_item.slot_weapon_skin = real_item

			if visual_item.gear.masterDataInstance.overrides then
				visual_item.gear.masterDataInstance.overrides.slot_weapon_skin = real_item
			end

			return visual_item
		end,
		apply_on_preview = function (real_item, presentation_item)
			if presentation_item.__master_item then
				presentation_item.__master_item.slot_weapon_skin = nil
			end

			presentation_item.slot_weapon_skin = real_item
			self._selected_weapon_skin = real_item
			self._selected_weapon_skin_name = real_item and real_item.gear.masterDataInstance.id
		end
	}
	tabs_content[2] = {
		slot_name = "slot_trinket_1",
		display_name = "loc_weapon_cosmetics_title_trinkets",
		icon = "content/ui/materials/icons/item_types/weapon_trinkets",
		get_item_filters = function (slot_name, item_type)
			if slot_name then
				local slot_filter = {
					slot_name
				}
			end

			return slot_filter, nil
		end,
		setup_selected_item_function = function (real_item, selected_item)
			local selected_weapon_trinket_name = self._selected_weapon_trinket_name

			if selected_weapon_trinket_name and real_item and real_item.gear.masterDataInstance.id == selected_weapon_trinket_name then
				self._selected_weapon_trinket = real_item
			end
		end,
		get_empty_item = function (selected_item)
			local visual_item = nil

			if selected_item.gear then
				visual_item = MasterItems.create_preview_item_instance(selected_item)
			else
				visual_item = table.clone_instance(selected_item)
			end

			visual_item.empty_item = true

			for i = 1, #trinket_slot_order do
				local slot_id = trinket_slot_order[i]
				local link_item_to_slot = true

				if visual_item.__gear.masterDataInstance.overrides then
					find_link_attachment_item_slot_path(visual_item.__gear.masterDataInstance.overrides, slot_id, nil, link_item_to_slot)
				end

				if find_link_attachment_item_slot_path(visual_item.__master_item, slot_id, nil, link_item_to_slot) then
					break
				end
			end

			return visual_item
		end,
		generate_visual_item_function = function (real_item, selected_item)
			local optional_preivew_item = selected_item.__gear.masterDataInstance.id

			return ItemUtils.weapon_trinket_preview_item(real_item)
		end,
		apply_on_preview = function (real_item, presentation_item)
			local path = nil

			for i = 1, #trinket_slot_order do
				local slot_id = trinket_slot_order[i]
				path = find_link_attachment_item_slot_path(presentation_item.__master_item, slot_id, real_item)

				if path then
					local link_item_to_slot = true

					if presentation_item.__gear.masterDataInstance.overrides then
						find_link_attachment_item_slot_path(presentation_item.__gear.masterDataInstance.overrides, slot_id, real_item, link_item_to_slot)
					end

					find_link_attachment_item_slot_path(presentation_item.__master_item, slot_id, real_item, link_item_to_slot)

					break
				end
			end

			self._selected_weapon_trinket_name = real_item and real_item.gear.masterDataInstance.id
			self._selected_weapon_trinket = real_item
		end
	}

	self:_setup_menu_tabs(tabs_content)

	if self._presentation_item then
		self:_setup_weapon_preview()
		self:_preview_item(self._presentation_item)
		self._weapon_preview:center_align(0, {
			-0.2,
			-0.3,
			-0.2
		})
	end

	self:present_grid_layout({})
	self:_register_button_callbacks()
	self:cb_switch_tab(1)
end

InventoryWeaponCosmeticsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button
	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryWeaponCosmeticsView._update_equip_button_state = function (self)
	local button_disabled = true

	if self._selected_weapon_skin_name ~= self._initial_weapon_skin_name then
		button_disabled = false
	elseif self._selected_weapon_trinket_name ~= self._initial_weapon_trinket_name then
		button_disabled = false
	end

	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button
	equip_button.content.hotspot.disabled = button_disabled
end

InventoryWeaponCosmeticsView.present_grid_layout = function (self, layout, optional_on_present_callback)
	local grid_display_name = self._grid_display_name
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")
	local right_click_callback = callback(self, "cb_on_grid_entry_right_pressed")
	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local grid_settings = self._definitions.grid_settings
	local grid_size = grid_settings.grid_size
	local ContentBlueprints = generate_blueprints_function(grid_size)
	local spacing_entry = {
		widget_type = "dynamic_spacing",
		size = {
			grid_size[1],
			10
		}
	}

	table.insert(layout, 1, spacing_entry)
	table.insert(layout, #layout + 1, spacing_entry)

	local grow_direction = self._grow_direction or "down"

	self._item_grid:present_grid_layout(layout, ContentBlueprints, left_click_callback, right_click_callback, grid_display_name, grow_direction, optional_on_present_callback)
end

InventoryWeaponCosmeticsView._setup_weapon_stats = function (self)
	return
end

InventoryWeaponCosmeticsView._setup_sort_options = function (self)
	return
end

InventoryWeaponCosmeticsView._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 10
		local context = {
			ignore_blur = false,
			draw_background = false
		}
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, context)
	end
end

InventoryWeaponCosmeticsView._setup_menu_tabs = function (self, content)
	self._tabs_content = content
	local grid_size = Definitions.grid_settings.grid_size
	local id = "tab_menu"
	local layer = 10
	local tab_menu_settings = {
		fixed_button_size = true,
		horizontal_alignment = "left",
		button_spacing = 20,
		button_size = {
			grid_size[1] * 0.5 - 10,
			50
		}
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)
	self._tab_menu_element = tab_menu_element
	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)
	tab_menu_element:set_is_handling_navigation_input(true)

	local tab_button_template = table.clone(ButtonPassTemplates.tab_menu_button_icon)
	tab_button_template[1].style = {
		on_hover_sound = UISoundEvents.tab_secondary_button_hovered,
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed
	}
	local tab_ids = {}

	for i = 1, #content do
		local tab_content = content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)
		tab_ids[i] = tab_id
	end

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

InventoryWeaponCosmeticsView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("grid_tab_panel")

	self._tab_menu_element:set_pivot_offset(position[1], position[2])
end

InventoryWeaponCosmeticsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 40)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryWeaponCosmeticsView._fetch_inventory_items = function (self, slot_name, item_type, get_item_filters_function, get_empty_item_function, generate_visual_item_function, filter_on_weapon_template)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local slot_filter, item_type_filter = nil

	if get_item_filters_function then
		slot_filter, item_type_filter = get_item_filters_function(slot_name, item_type)
	end

	local selected_item = self._selected_item

	Managers.data_service.gear:fetch_inventory(character_id, slot_filter, item_type_filter):next(function (items)
		if self._destroyed then
			return
		end

		local items_array = {}

		for gear_id, item in pairs(items) do
			items_array[#items_array + 1] = item
		end

		self._inventory_items = items_array
		local selected_item_weapon_template = selected_item.weapon_template
		local layout = {}

		if get_empty_item_function then
			local empty_item = get_empty_item_function(selected_item)
			layout[#layout + 1] = {
				widget_type = "item_icon",
				item = empty_item,
				slot_name = slot_name
			}
		end

		for i = 1, #items_array do
			local item = items_array[i]
			local valid = true

			if filter_on_weapon_template then
				local weapon_template_restriction = item.weapon_template_restriction
				valid = weapon_template_restriction and table.contains(weapon_template_restriction, selected_item_weapon_template) and true or false
			end

			if valid then
				local visual_item = generate_visual_item_function(item, selected_item)
				layout[#layout + 1] = {
					widget_type = "item_icon",
					item = visual_item,
					real_item = item,
					slot_name = slot_name
				}
			end
		end

		self._offer_items_layout = layout
		local start_index = #layout > 0 and 1
		local on_present_callback = callback(self, "_select_starting_item_by_slot_name", slot_name, start_index)

		self:present_grid_layout(layout, on_present_callback)
	end)
end

InventoryWeaponCosmeticsView._select_starting_item_by_slot_name = function (self, slot_name, optional_start_index)
	local start_index = optional_start_index
	local starting_item_name = start_index and self:selected_item_name_in_slot(slot_name)

	if starting_item_name then
		local grid_widgets = self:grid_widgets()

		if grid_widgets then
			for i = 1, #grid_widgets do
				local widget = grid_widgets[i]
				local content = widget.content
				local element = content.element
				local element_item = element.real_item or element.item

				if element_item and element_item.gear.masterDataInstance.id == starting_item_name then
					start_index = i

					break
				end
			end
		end

		if start_index then
			local element = self:element_by_index(start_index)
			local element_item = element and element.item

			self:focus_on_item(element_item)
		end
	elseif start_index then
		local instant_scroll = true
		local scrollbar_animation_progress = 0

		self:focus_grid_index(start_index, scrollbar_animation_progress, instant_scroll)
	end
end

InventoryWeaponCosmeticsView._item_valid_by_current_profile = function (self, item)
	local player = self._preview_player
	local profile = player:profile()
	local archetype = profile.archetype
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid then
		return true
	end

	return false
end

InventoryWeaponCosmeticsView.equipped_item_in_slot = nil

InventoryWeaponCosmeticsView.selected_item_name_in_slot = function (self, slot_name)
	if slot_name == "slot_trinket_1" then
		return self._selected_weapon_trinket_name
	elseif slot_name == "slot_weapon_skin" then
		return self._selected_weapon_skin_name
	end

	return nil
end

InventoryWeaponCosmeticsView.equipped_item_name_in_slot = function (self, slot_name)
	if slot_name == "slot_trinket_1" then
		return self._initial_weapon_trinket_name
	elseif slot_name == "slot_weapon_skin" then
		return self._initial_weapon_skin_name
	end

	return nil
end

InventoryWeaponCosmeticsView.cb_on_equip_pressed = function (self)
	local previewed_element = self._previewed_element

	if previewed_element then
		local selected_item = self._selected_item
		local update_icon = false
		local promise = Promise:new()

		promise:next(function ()
			if self._selected_weapon_skin_name ~= self._initial_weapon_skin_name then
				update_icon = true

				return ItemUtils.equip_weapon_skin(selected_item, self._selected_weapon_skin)
			end

			return Promise.resolved()
		end):next(function (result)
			if self._selected_weapon_trinket_name ~= self._initial_weapon_trinket_name then
				update_icon = true

				return ItemUtils.equip_weapon_trinket(selected_item, self._selected_weapon_trinket)
			end

			return Promise.resolved(result)
		end):next(function (result)
			local gear = result and result.gear
			local item = nil

			Managers.ui:item_icon_updated(self._selected_item)
			Managers.event:trigger("event_item_icon_updated", self._selected_item)

			self._selected_weapon_skin = nil
			self._selected_weapon_skin_name = nil
			self._selected_weapon_trinket_name = nil
			self._selected_weapon_trinket = nil

			return Promise.resolved(item)
		end):next(function (item)
			Log.debug("InventoryWeaponCosmeticsView", "Items equipped in loadout slots")

			local peer_id = Network.peer_id()
			local local_player_id = 1
			local is_server = Managers.state.game_session and Managers.state.game_session:is_server()

			if is_server then
				local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

				profile_synchronizer_host:profile_changed(peer_id, local_player_id)
			else
				Managers.connection:send_rpc_server("rpc_notify_profile_changed", peer_id, local_player_id)
			end
		end):catch(function (errors)
			Log.error("InventoryWeaponCosmeticsView", "Failed equipping items in loadout slots", errors)
		end)
		promise:resolve()
	end

	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView._cb_on_close_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView._preview_element = function (self, element)
	local selected_tab_index = self._selected_tab_index
	local content = self._tabs_content[selected_tab_index]
	local apply_on_preview = content.apply_on_preview
	local presentation_item = self._presentation_item
	local selected_item = self._selected_item
	local item = element.item
	local real_item = element.real_item
	self._previewed_item = item
	self._previewed_element = element

	apply_on_preview(real_item, presentation_item)
	self:_preview_item(presentation_item)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.sub_display_name.content.text = ItemUtils.display_name(item)
	widgets_by_name.display_name.content.text = real_item and ItemUtils.display_name(real_item) or Localize("loc_weapon_cosmetic_empty")
end

InventoryWeaponCosmeticsView._preview_item = function (self, item)
	local item_display_name = item.display_name
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

InventoryWeaponCosmeticsView.on_back_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView._set_weapon_zoom = function (self, fraction)
	self._weapon_zoom_fraction = fraction
end

InventoryWeaponCosmeticsView._cb_on_ui_visibility_toggled = function (self, id)
	self._visibility_toggled_on = not self._visibility_toggled_on
	local display_name = self._visibility_toggled_on and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

	self._input_legend_element:set_display_name(id, display_name)
end

InventoryWeaponCosmeticsView._handle_input = function (self, input_service)
	local scroll_axis = input_service:get("scroll_axis")

	if scroll_axis then
		local scroll = scroll_axis[2]

		if scroll_axis ~= 0 then
			local weapon_zoom_fraction = (self._weapon_zoom_fraction or 1) + scroll * 0.01
		end
	end
end

InventoryWeaponCosmeticsView.update = function (self, dt, t, input_service)
	self:_update_equip_button_state()

	return InventoryWeaponCosmeticsView.super.update(self, dt, t, input_service)
end

InventoryWeaponCosmeticsView.draw = function (self, dt, t, input_service, layer)
	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_default_renderer = self._ui_default_renderer
	local ui_forward_renderer = self._ui_forward_renderer
	local ui_renderer = self._ui_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._background_widget, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	self:_draw_elements(dt, t, ui_default_renderer, render_settings, input_service)
	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_forward_renderer)
	UIRenderer.end_pass(ui_forward_renderer)
	self:_draw_render_target()
end

InventoryWeaponCosmeticsView._draw_render_target = function (self)
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
		height
	}
	local gui_position = Vector3(position[1] * scale, position[2] * scale, position[3] or 0)
	local gui_size = Vector3(size[1] * scale, size[2] * scale, size[3] or 0)

	Gui.bitmap(gui, material, "render_pass", "to_screen", gui_position, gui_size, color)
end

InventoryWeaponCosmeticsView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
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

InventoryWeaponCosmeticsView.cb_switch_tab = function (self, index)
	if index ~= self._selected_tab_index then
		self._selected_tab_index = index

		self._tab_menu_element:set_selected_index(index)

		local content = self._tabs_content[index]
		local slot_name = content.slot_name
		local item_type = content.item_type
		local get_empty_item = content.get_empty_item
		local get_item_filters = content.get_item_filters
		local generate_visual_item_function = content.generate_visual_item_function
		local filter_on_weapon_template = content.filter_on_weapon_template
		self._grid_display_name = content.display_name

		self:_fetch_inventory_items(slot_name, item_type, get_item_filters, get_empty_item, generate_visual_item_function, filter_on_weapon_template)
	end
end

InventoryWeaponCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryWeaponCosmeticsView.super.on_resolution_modified(self, scale)
	self:_update_tab_bar_position()
end

return InventoryWeaponCosmeticsView
