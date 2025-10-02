-- chunkname: @scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view.lua

require("scripts/ui/views/item_grid_view_base/item_grid_view_base")

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local Definitions = require("scripts/ui/views/inventory_weapon_cosmetics_view/inventory_weapon_cosmetics_view_definitions")
local InputDevice = require("scripts/managers/input/input_device")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local Promise = require("scripts/foundation/utilities/promise")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local Archetypes = require("scripts/settings/archetype/archetypes")
local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
local PENANCE_TRACK_ID = "dec942ce-b6ba-439c-95e2-022c5d71394d"
local trinket_slot_order = {
	"slot_trinket_1",
	"slot_trinket_2",
}
local find_link_attachment_item_slot_path

function find_link_attachment_item_slot_path(start_table, slot_id, trinket_item, link_item)
	local find_all_slot_paths

	function find_all_slot_paths(path_target_table, path_slot_id, path_item, path_link_item, found_path, found_item_name)
		if not path_target_table then
			return
		end

		local unused_trinket_name = "content/items/weapons/player/trinkets/unused_trinket"

		for k, t in pairs(path_target_table) do
			if type(t) == "table" then
				if k == path_slot_id then
					if not t.item or t.item ~= unused_trinket_name then
						found_path = true

						if path_link_item then
							t.item = path_item
						end

						found_item_name = found_item_name ~= nil and found_item_name or t.item
					end
				elseif not ItemSlotSettings[k] then
					found_path, found_item_name = find_all_slot_paths(t, path_slot_id, path_item, path_link_item, found_path, found_item_name)
				end
			end
		end

		return found_path, found_item_name
	end

	return find_all_slot_paths(start_table, slot_id, trinket_item, link_item)
end

local function generate_preview_item(item, item_type)
	return MasterItems.get_ui_item_instance(item)
end

local InventoryWeaponCosmeticsView = class("InventoryWeaponCosmeticsView", "ItemGridViewBase")

InventoryWeaponCosmeticsView.init = function (self, settings, context)
	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._parent = context.parent
	self._promise_container = PromiseContainer:new()
	self._visibility_toggled_on = true
	self._preview_player = context.player or Managers.player:local_player(1)
	self._selected_item = context.preview_item
	self._is_loading = false

	local selected_item = self._selected_item

	if selected_item then
		self._presentation_item = generate_preview_item(selected_item)

		local trinket_path, trinket_item

		for i = 1, #trinket_slot_order do
			local slot_id = trinket_slot_order[i]
			local link_item_to_slot = false

			trinket_path, trinket_item = find_link_attachment_item_slot_path(selected_item, slot_id, nil, link_item_to_slot)

			if trinket_item then
				break
			end
		end

		if trinket_item and trinket_item ~= "content/items/weapons/player/trinkets/empty_trinket" then
			self._selected_weapon_trinket_name = trinket_item
			self._equipped_weapon_trinket_name = trinket_item
			self._starting_weapon_trinket_name = trinket_item
		end

		self._selected_weapon_skin_name = selected_item.slot_weapon_skin

		if not self._selected_weapon_skin_name and selected_item.__gear and selected_item.__gear.masterDataInstance and selected_item.__gear.masterDataInstance.overrides then
			self._selected_weapon_skin_name = selected_item.__gear.masterDataInstance.overrides.slot_weapon_skin
		end

		if self._selected_weapon_skin_name == "" then
			self._selected_weapon_skin_name = nil
		end

		self._equipped_weapon_skin_name = self._selected_weapon_skin_name
		self._starting_weapon_skin_name = self._selected_weapon_skin_name
	end

	InventoryWeaponCosmeticsView.super.init(self, Definitions, settings, context)

	self._grow_direction = "down"
	self._always_visible_widget_names = Definitions.always_visible_widget_names
	self._weapon_zoom_fraction = -0.45
	self._weapon_zoom_target = -0.45
	self._min_zoom = -0.45
	self._max_zoom = 4
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

InventoryWeaponCosmeticsView.on_enter = function (self)
	InventoryWeaponCosmeticsView.super.on_enter(self)

	self._render_settings.alpha_multiplier = 0
	self._inventory_items = {}

	self:_setup_forward_gui()

	self._background_widget = self:_create_widget("background", Definitions.background_widget)

	if not self._selected_item then
		return
	end

	local grid_size = Definitions.grid_settings.grid_size

	self._content_blueprints = require("scripts/ui/view_content_blueprints/item_blueprints")(grid_size)

	self:_setup_input_legend()

	if not self._on_enter_anim_id then
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)
	end

	self._world_spawner = self._parent:world_spawner()

	if self._presentation_item then
		self:_setup_weapon_preview()
		self:_preview_item(self._presentation_item)
	end

	self:present_grid_layout({})
	self:_register_button_callbacks()
	self:_setup_menu_tabs()
	self:_load_layout()
	self:_register_event("event_force_refresh_inventory", "event_force_refresh_inventory")
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

InventoryWeaponCosmeticsView._stop_previewing = function (self)
	InventoryWeaponCosmeticsView.super._stop_previewing(self)
	self:_destroy_side_panel()

	if self._item_name_widget then
		self:_unregister_widget_name(self._item_name_widget.name)

		self._item_name_widget = nil
	end
end

InventoryWeaponCosmeticsView.on_exit = function (self)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	self:_destroy_forward_gui()
	self:_destroy_side_panel()
	self:_equip_items_on_server()
	InventoryWeaponCosmeticsView.super.on_exit(self)
end

InventoryWeaponCosmeticsView._equip_items_on_server = function (self)
	local selected_item = self._selected_item

	local function equip_weapon_skin_func()
		if self._equipped_weapon_skin_name ~= self._starting_weapon_skin_name then
			return Items.equip_weapon_skin(selected_item, self._equipped_weapon_skin)
		else
			return Promise:resolved()
		end
	end

	local function equip_trinket_func()
		if self._equipped_weapon_trinket_name ~= self._starting_weapon_trinket_name then
			return Items.equip_weapon_trinket(selected_item, self._equipped_weapon_trinket)
		else
			return Promise:resolved()
		end
	end

	local promises_func = {
		equip_weapon_skin_func,
		equip_trinket_func,
	}
	local run_equip_promise

	function run_equip_promise(promises_list, index, gears)
		local promise_func = promises_list[index]

		if promise_func then
			return promise_func():next(function (result)
				local gear = result and result.item

				if gear then
					gears[#gears + 1] = gear
				end

				local next_index = index + 1

				return run_equip_promise(promises_list, next_index, gears)
			end)
		else
			local modified_item = false
			local gear = gears[#gears]

			if gear then
				local gear_id = selected_item and selected_item.gear_id
				local item = MasterItems.get_item_instance(gear, gear_id)

				if item then
					Managers.ui:item_icon_updated(item)
					Managers.event:trigger("event_item_icon_updated", item)
					Managers.event:trigger("event_replace_list_item", item)
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
				end
			end
		end
	end

	run_equip_promise(promises_func, 1, {})
end

InventoryWeaponCosmeticsView.event_force_refresh_inventory = function (self)
	self._force_refresh = true
end

InventoryWeaponCosmeticsView._should_refresh = function (self, dt, t)
	local is_loading = self:get_loading_state()

	if is_loading then
		return false
	end

	local refresh_in_seconds = self._refresh_in_seconds

	refresh_in_seconds = refresh_in_seconds and math.max(refresh_in_seconds - dt, 0)
	self._refresh_in_seconds = refresh_in_seconds

	if refresh_in_seconds and refresh_in_seconds == 0 then
		return true
	end

	return false
end

InventoryWeaponCosmeticsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name
	local equip_button = widgets_by_name.equip_button

	equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryWeaponCosmeticsView._setup_weapon_stats = function (self)
	return
end

local function sort_function_generator(item_comparator)
	return function (a, b)
		if a.sort_group ~= b.sort_group then
			return a.sort_group < b.sort_group
		end

		if a.widget_type == "divider" and b.widget_type == "divider" then
			return false
		end

		return item_comparator(a, b)
	end
end

InventoryWeaponCosmeticsView._setup_sort_options = function (self, has_rarity)
	self._sort_options = {}

	if has_rarity then
		self._sort_options[#self._sort_options + 1] = {
			display_name = Localize("loc_inventory_item_grid_sort_title_format_high_low", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_rarity"),
			}),
			sort_function = sort_function_generator(Items.sort_comparator({
				"<",
				Items.compare_item_sort_order,
				">",
				Items.compare_item_rarity,
				"<",
				Items.compare_item_name,
			})),
		}
		self._sort_options[#self._sort_options + 1] = {
			display_name = Localize("loc_inventory_item_grid_sort_title_format_low_high", true, {
				sort_name = Localize("loc_inventory_item_grid_sort_title_rarity"),
			}),
			sort_function = sort_function_generator(Items.sort_comparator({
				"<",
				Items.compare_item_sort_order,
				"<",
				Items.compare_item_rarity,
				"<",
				Items.compare_item_name,
			})),
		}
	end

	self._sort_options[#self._sort_options + 1] = {
		display_name = Localize("loc_inventory_item_grid_sort_title_format_increasing_letters", true, {
			sort_name = Localize("loc_inventory_item_grid_sort_title_name"),
		}),
		sort_function = sort_function_generator(Items.sort_comparator({
			"<",
			Items.compare_item_sort_order,
			"<",
			Items.compare_item_name,
		})),
	}
	self._sort_options[#self._sort_options + 1] = {
		display_name = Localize("loc_inventory_item_grid_sort_title_format_decreasing_letters", true, {
			sort_name = Localize("loc_inventory_item_grid_sort_title_name"),
		}),
		sort_function = sort_function_generator(Items.sort_comparator({
			"<",
			Items.compare_item_sort_order,
			">",
			Items.compare_item_name,
		})),
	}

	local sort_callback = callback(self, "cb_on_sort_button_pressed")

	self._item_grid:setup_sort_button(self._sort_options, sort_callback)
end

InventoryWeaponCosmeticsView._setup_weapon_preview = function (self)
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
		self._weapon_preview:center_align(0, {
			-0.2,
			-0.3,
			-0.25,
		})
		self:_set_weapon_zoom(self._weapon_zoom_fraction)
	end
end

InventoryWeaponCosmeticsView._setup_menu_tabs = function (self)
	self._tabs_content = {
		{
			display_name = "loc_weapon_cosmetics_title_skins",
			filter_on_weapon_template = true,
			icon = "content/ui/materials/icons/item_types/weapon_skins",
			item_type = "WEAPON_SKIN",
			slot_name = "slot_weapon_skin",
			get_item_filters = function (slot_name, item_type)
				local item_type_filter = item_type and {
					item_type,
				}

				return nil, item_type_filter
			end,
			setup_selected_item_function = function (real_item, selected_item)
				local selected_weapon_trinket_name = self._selected_weapon_trinket_name

				if selected_weapon_trinket_name and real_item and real_item.name == selected_weapon_trinket_name then
					self._selected_weapon_trinket = real_item
				end
			end,
			get_empty_item = function (selected_item, slot_name, item_type)
				local visual_item = generate_preview_item(selected_item, item_type)

				visual_item.slot_weapon_skin = nil

				if visual_item.__gear and visual_item.__gear.masterDataInstance and visual_item.__gear.masterDataInstance.overrides then
					visual_item.__gear.masterDataInstance.overrides.slot_weapon_skin = nil
				end

				local found_path = false

				for i = 1, #trinket_slot_order do
					local equipped_trinket_name = self._equipped_weapon_trinket_name
					local slot_id = trinket_slot_order[i]
					local link_item_to_slot = true
					local item_name = not found_path and equipped_trinket_name
					local path = find_link_attachment_item_slot_path(visual_item, slot_id, item_name, link_item_to_slot)

					if path then
						found_path = true
					end
				end

				visual_item.rarity = -1
				visual_item.display_name = "loc_weapon_cosmetic_empty"
				visual_item.item_type = item_type
				visual_item.slots[1] = slot_name
				visual_item.empty_item = true
				visual_item.gear_id = math.uuid()

				return visual_item
			end,
			generate_visual_item_function = function (real_item, selected_item, item_type)
				local visual_item = generate_preview_item(selected_item, item_type)

				visual_item.rarity = real_item.rarity or -1
				visual_item.gear_id = real_item.gear_id
				visual_item.slot_weapon_skin = real_item

				if visual_item.__master_item then
					visual_item.__master_item.slot_weapon_skin = real_item
				end

				if visual_item.__gear and visual_item.__gear.masterDataInstance and visual_item.__gear.masterDataInstance.overrides then
					visual_item.__gear.masterDataInstance.overrides.slot_weapon_skin = real_item and real_item.name
				end

				local found_path = false

				for i = 1, #trinket_slot_order do
					local equipped_trinket_name = self._equipped_weapon_trinket_name
					local slot_id = trinket_slot_order[i]
					local link_item_to_slot = true
					local item_name = not found_path and self._equipped_weapon_trinket_name
					local path = find_link_attachment_item_slot_path(visual_item, slot_id, item_name, link_item_to_slot)

					if path then
						found_path = true
					end
				end

				visual_item.item_type = "WEAPON_SKIN"

				return visual_item
			end,
			apply_on_preview = function (real_item, presentation_item)
				if presentation_item.__master_item then
					presentation_item.__master_item.slot_weapon_skin = real_item and real_item.name
				end

				presentation_item.slot_weapon_skin = real_item

				if presentation_item.__gear and presentation_item.__gear.masterDataInstance and presentation_item.__gear.masterDataInstance.overrides then
					presentation_item.__gear.masterDataInstance.overrides.slot_weapon_skin = real_item and real_item.name
				end

				self._selected_weapon_skin = real_item
				self._selected_weapon_skin_name = real_item and real_item.name
			end,
		},
		{
			display_name = "loc_weapon_cosmetics_title_trinkets",
			icon = "content/ui/materials/icons/item_types/weapon_trinkets",
			item_type = "WEAPON_TRINKET",
			slot_name = "slot_trinket_1",
			get_item_filters = function (slot_name, item_type)
				local slot_filter = slot_name and {
					slot_name,
				}

				return slot_filter, nil
			end,
			setup_selected_item_function = function (real_item, selected_item)
				local selected_weapon_trinket_name = self._selected_weapon_trinket_name

				if selected_weapon_trinket_name and real_item and real_item.name == selected_weapon_trinket_name then
					self._selected_weapon_trinket = real_item
				end
			end,
			get_empty_item = function (selected_item, slot_name, item_type)
				local visual_item = generate_preview_item(selected_item, item_type)

				for i = 1, #trinket_slot_order do
					local slot_id = trinket_slot_order[i]
					local link_item_to_slot = true

					find_link_attachment_item_slot_path(visual_item, slot_id, nil, link_item_to_slot)
				end

				visual_item.rarity = -1
				visual_item.display_name = "loc_weapon_cosmetic_empty"
				visual_item.item_type = item_type
				visual_item.slots[1] = slot_name
				visual_item.empty_item = true
				visual_item.gear_id = math.uuid()

				return visual_item
			end,
			generate_visual_item_function = function (real_item, selected_item, item_type)
				local visual_item = generate_preview_item(real_item, item_type)

				visual_item = Items.weapon_trinket_preview_item(visual_item)
				visual_item.rarity = real_item.rarity or -1
				visual_item.item_type = "WEAPON_TRINKET"

				return visual_item
			end,
			apply_on_preview = function (real_item, presentation_item)
				local found_path = false

				for i = 1, #trinket_slot_order do
					local slot_id = trinket_slot_order[i]
					local link_item_to_slot = true
					local item_name = not found_path and real_item and real_item.name
					local path = find_link_attachment_item_slot_path(presentation_item, slot_id, item_name, link_item_to_slot)

					if path then
						found_path = true
					end
				end

				self._selected_weapon_trinket_name = real_item and real_item.name
				self._selected_weapon_trinket = real_item
			end,
		},
	}

	local grid_size = Definitions.grid_settings.grid_size
	local id = "tab_menu"
	local layer = 10
	local button_size = {
		80,
		80,
	}
	local button_spacing = 10
	local tab_menu_settings = {
		grow_vertically = true,
		vertical_alignment = "top",
		button_size = button_size,
		button_spacing = button_spacing,
		input_label_offset = {
			25,
			30,
		},
	}
	local tab_menu_element = self:_add_element(ViewElementTabMenu, id, layer, tab_menu_settings)

	self._tab_menu_element = tab_menu_element

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	tab_menu_element:set_input_actions(input_action_left, input_action_right)
	tab_menu_element:set_is_handling_navigation_input(true)

	local tab_button_template = table.clone(ButtonPassTemplates.item_category_sort_button)

	tab_button_template[1].style = {
		on_pressed_sound = UISoundEvents.tab_secondary_button_pressed,
	}

	local tab_ids = {}
	local tabs_content_size = #self._tabs_content

	for i = 1, tabs_content_size do
		local tab_content = self._tabs_content[i]
		local display_name = tab_content.display_name
		local display_icon = tab_content.icon
		local pressed_callback = callback(self, "cb_switch_tab", i)
		local tab_id = tab_menu_element:add_entry(display_name, pressed_callback, tab_button_template, display_icon)

		tab_ids[i] = tab_id
	end

	local total_height = button_size[2] * tabs_content_size + button_spacing * tabs_content_size

	self:_set_scenegraph_size("button_pivot_background", nil, total_height + 30)

	self._tab_ids = tab_ids

	self:_update_tab_bar_position()
end

InventoryWeaponCosmeticsView._update_tab_bar_position = function (self)
	if not self._tab_menu_element then
		return
	end

	local position = self:_scenegraph_world_position("button_pivot")

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

InventoryWeaponCosmeticsView._load_layout = function (self)
	self._inventory_items = {}

	self:_stop_previewing()
	self:set_loading_state(true)

	self._refresh_in_seconds = nil

	self._promise_container:cancel_on_destroy(self:_fetch_inventory_items()):next(function ()
		self:set_loading_state(false)
		self:_prepare_layout_data()

		if not self._selected_tab_index then
			self:cb_switch_tab(1)
		else
			local tab_content = self._tabs_content[self._selected_tab_index]
			local slot_name = tab_content.slot_name

			self:_show_layout_by_slot(slot_name)
		end
	end):catch(function ()
		self:set_loading_state(false)
	end)
end

InventoryWeaponCosmeticsView.set_loading_state = function (self, is_loading)
	InventoryWeaponCosmeticsView.super.set_loading_state(self, is_loading)

	self._is_loading = is_loading

	if self._tab_menu_element then
		self._tab_menu_element:disable_input(is_loading)

		local tab_entries = self._tab_menu_element:entries()

		for i = 1, #tab_entries do
			local tab_entry = tab_entries[i]
			local id = tab_entry.id

			self._tab_menu_element:set_tab_disabled(id, is_loading)
		end
	end
end

InventoryWeaponCosmeticsView._fetch_inventory_items = function (self)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()
	local selected_item = self._selected_item
	local promises = Promise.resolved({})
	local tabs_content = self._tabs_content

	for i = 1, #tabs_content do
		local tab_content = tabs_content[i]
		local slot_name = tab_content.slot_name
		local item_type = tab_content.item_type
		local get_empty_item_function = tab_content.get_empty_item
		local get_item_filters_function = tab_content.get_item_filters
		local generate_visual_item_function = tab_content.generate_visual_item_function
		local filter_on_weapon_template = tab_content.filter_on_weapon_template
		local slot_filter, item_type_filter

		if get_item_filters_function then
			slot_filter, item_type_filter = get_item_filters_function(slot_name, item_type)
		end

		local slot_promises = {}

		slot_promises[#slot_promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.gear:fetch_inventory(character_id, slot_filter, item_type_filter)):next(function (items)
			if self._destroyed then
				return
			end

			local items_data = {}

			if get_empty_item_function then
				items_data[#items_data + 1] = {
					empty_item = true,
				}
			end

			local equipped_item_name = self:equipped_item_name_in_slot(slot_name)

			for gear_id, item in pairs(items) do
				local item_name = item.name
				local item_equipped = equipped_item_name == item_name

				if item_equipped then
					if slot_name == "slot_weapon_skin" then
						self._equipped_weapon_skin = item
					else
						self._equipped_weapon_trinket = item
					end
				end

				self._inventory_items[#self._inventory_items + 1] = item

				local valid = true

				if filter_on_weapon_template then
					valid = self:_item_valid_by_current_pattern(item)
				end

				if valid then
					items_data[#items_data + 1] = {
						item = item,
					}
				end
			end

			return Promise.resolved(items_data)
		end)
		slot_promises[#slot_promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.store:get_credits_weapon_cosmetics_store()):next(function (data)
			local offers = data.offers

			return self:_parse_store_items(slot_name, offers, {})
		end)
		slot_promises[#slot_promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.penance_track:get_track(PENANCE_TRACK_ID)):next(function (data)
			local penance_track_items = {}
			local tiers = data and data.tiers

			if tiers then
				for i = 1, #tiers do
					local tier = tiers[i]
					local tier_rewards = tier.rewards

					if tier_rewards then
						for reward_name, reward in pairs(tier_rewards) do
							if reward.type == "item" then
								local reward_item = MasterItems.get_item(reward.id)

								if reward_item and self:_item_valid_by_current_pattern(reward_item) and table.find(reward_item.slots, slot_name) then
									local valid = true

									if valid then
										penance_track_items[#penance_track_items + 1] = {
											item = reward_item,
											label = Localize("loc_item_source_penance_track"),
										}
									end
								end
							end
						end
					end
				end
			end

			return Promise.resolved(penance_track_items)
		end)
		promises[i] = Promise.all(unpack(slot_promises)):next(function (items)
			return {
				items = items[1],
				store_items = items[2],
				penance_track_items = items[3],
			}
		end)
	end

	return self._promise_container:cancel_on_destroy(Promise.all(unpack(promises))):next(function (items_data)
		self._items_by_slot = {}

		for i = 1, #items_data do
			local tab_content = tabs_content[i]
			local slot_name = tab_content.slot_name

			self._items_by_slot[slot_name] = items_data[i]
		end
	end):catch(function (items_data)
		self._refresh_in_seconds = 5
		self._items_by_slot = {}

		for i = 1, #items_data do
			local tab_content = tabs_content[i]
			local slot_name = tab_content.slot_name

			self._items_by_slot[slot_name] = items_data[i]
		end
	end)
end

InventoryWeaponCosmeticsView._parse_store_items = function (self, selected_slot_name, offers, items)
	for i = 1, #offers do
		local offer = offers[i]
		local id = offer.description and offer.description.id

		if id and id ~= "n/a" then
			local item = MasterItems.get_item(id)

			if item and self:_item_valid_by_current_pattern(item) and table.find(item.slots, selected_slot_name) then
				local valid = true

				if valid then
					items[#items + 1] = {
						item = item,
						offer = offer,
					}
				end
			end
		end

		local bundle_info = offer.bundleInfo

		if bundle_info then
			self:_parse_store_items(selected_slot_name, bundle_info, items)
		end
	end

	return items
end

InventoryWeaponCosmeticsView._requested_index_on_present = function (self)
	local grid_widgets = self._item_grid:widgets()
	local selected_gear_id = self._selected_gear_id
	local selected_tab_index = self._selected_tab_index
	local tab_content = selected_tab_index and self._tabs_content[selected_tab_index]
	local slot_name = tab_content and tab_content.slot_name
	local equipped_item = self:equipped_item_name_in_slot(slot_name)
	local new_selection_index = 1

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]

		if widget then
			local content = widget.content
			local element = content.element

			if element then
				local item = element.real_item or element.item

				if item and item.name == equipped_item then
					new_selection_index = i

					break
				end
			end
		end
	end

	self._selected_gear_id = nil

	return new_selection_index
end

InventoryWeaponCosmeticsView._item_valid_by_current_pattern = function (self, item)
	if item.slots and string.find(item.slots[1], "slot_trinket") then
		return true
	end

	local selected_item_weapon_template = self._selected_item and self._selected_item.weapon_template
	local weapon_template_restriction = item.weapon_template_restriction

	return weapon_template_restriction and table.contains(weapon_template_restriction, selected_item_weapon_template)
end

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
		return self._equipped_weapon_trinket_name
	elseif slot_name == "slot_weapon_skin" then
		return self._equipped_weapon_skin_name
	end

	return nil
end

InventoryWeaponCosmeticsView._equip_weapon_cosmetics = function (self)
	local previewed_element = self._previewed_element

	if previewed_element then
		local selected_item = self._selected_item
		local item_type

		if self._selected_tab_index == 1 and self._equipped_weapon_skin_name ~= self._selected_weapon_skin_name then
			item_type = "skin"
		elseif self._selected_tab_index == 2 and self._equipped_weapon_trinket_name ~= self._selected_weapon_trinket_name then
			item_type = "trinket"
		end

		if item_type == "skin" then
			self._equipped_weapon_skin_name = self._selected_weapon_skin_name
			self._equipped_weapon_skin = self._selected_weapon_skin
		else
			self._equipped_weapon_trinket_name = self._selected_weapon_trinket_name
			self._equipped_weapon_trinket = self._selected_weapon_trinket
		end
	end
end

InventoryWeaponCosmeticsView.cb_on_equip_pressed = function (self)
	local current_status = self._equip_button_status

	if current_status == "equip" then
		self:_equip_weapon_cosmetics()
	end
end

InventoryWeaponCosmeticsView._cb_on_close_pressed = function (self)
	Managers.ui:close_view("inventory_weapon_cosmetics_view")
end

InventoryWeaponCosmeticsView._update_equip_button_status = function (self)
	local previewed_item = self._previewed_item
	local previewed_element = self._previewed_element
	local target_status

	if not self._tabs_content or not previewed_item or self._is_loading then
		target_status = "locked"
	else
		local is_disabled = true
		local has_items = self._offer_items_layout and #self._offer_items_layout > 0

		if self._selected_tab_index == 1 and has_items and self._selected_weapon_skin_name ~= self._equipped_weapon_skin_name or self._selected_tab_index == 2 and has_items and self._selected_weapon_trinket_name ~= self._equipped_weapon_trinket_name then
			is_disabled = false
		end

		local is_locked = previewed_element and not not previewed_element.locked
		local is_equipped = false

		if is_disabled then
			local selected_tab_index = self._selected_tab_index
			local content = self._tabs_content[selected_tab_index]
			local selected_slot_name = content.slot_name
			local equipped_item_name = selected_slot_name and self:equipped_item_name_in_slot(selected_slot_name)

			if previewed_item.empty_item and (not equipped_item_name or equipped_item_name == "") then
				is_equipped = true
			else
				local item_name = previewed_item.name or previewed_item.__gear and previewed_item.__gear.masterDataInstance.id

				is_equipped = item_name == equipped_item_name
			end
		end

		target_status = is_equipped and "equipped" or is_disabled and "disabled" or is_locked and "locked" or "equip"
	end

	local current_equip_button_status = self._equip_button_status

	if target_status ~= current_equip_button_status then
		local button = self._widgets_by_name.equip_button
		local button_content = button.content

		button_content.hotspot.disabled = target_status == "disabled" or target_status == "equipped" or target_status == "locked"
		button_content.visible = target_status ~= "locked"

		local loc_key = target_status == "equipped" and "loc_weapon_inventory_equipped_button" or "loc_weapon_inventory_equip_button"

		button_content.original_text = Utf8.upper(Localize(loc_key))
		self._equip_button_status = target_status
	end

	return target_status
end

InventoryWeaponCosmeticsView._destroy_side_panel = function (self)
	local side_panel_widgets = self._side_panel_widgets
	local side_panel_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_count do
		local widget = side_panel_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._side_panel_widgets = nil
end

InventoryWeaponCosmeticsView._preview_element = function (self, element)
	self:_stop_previewing()

	local selected_tab_index = self._selected_tab_index
	local content = self._tabs_content[selected_tab_index]
	local apply_on_preview = content.apply_on_preview
	local presentation_item = self._presentation_item
	local item = element.item
	local real_item = element.real_item

	self._previewed_item = real_item or item
	self._previewed_element = element

	apply_on_preview(real_item, presentation_item)
	self:_preview_item(presentation_item)

	local item_size = {
		700,
		60,
	}
	local ui_renderer = self._ui_default_renderer
	local scenegraph_id = "item_name_pivot"
	local widget_type = "item_name"
	local Blueprints = generate_blueprints_function(item_size)
	local template = Blueprints[widget_type]
	local config = {
		horizontal_alignment = "right",
		ignore_negative_rarity = true,
		vertical_alignment = "bottom",
		size = item_size,
		real_item = real_item,
		item = item,
	}
	local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
	local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
	local optional_style = template.style_function and template.style_function(self, config, size) or template.style
	local player = self._preview_player
	local profile = player:profile()
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)
	local widget

	if widget_definition then
		local name = "item_name"

		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, config, nil, nil, ui_renderer, profile)
		end

		self._item_name_widget = widget
	end

	local is_locked = element.locked
	local should_display_button = self:_update_equip_button_status() ~= "locked"

	self:_set_preview_widgets_visibility(false, should_display_button)

	local y_offset = not should_display_button and 80 or 0

	widget.offset[2] = widget.offset[2] + y_offset

	self:_setup_side_panel(real_item, is_locked, 0, y_offset)
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

	self:_update_weapon_preview_viewport()
end

InventoryWeaponCosmeticsView._update_weapon_preview_viewport = function (self)
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

InventoryWeaponCosmeticsView._cb_on_ui_visibility_toggled = function (self, id)
	self._visibility_toggled_on = not self._visibility_toggled_on

	local display_name = self._visibility_toggled_on and "loc_menu_toggle_ui_visibility_off" or "loc_menu_toggle_ui_visibility_on"

	self._input_legend_element:set_display_name(id, display_name)
end

InventoryWeaponCosmeticsView._handle_input = function (self, input_service, dt, t)
	local scroll_axis = input_service:get("scroll_axis")
	local in_scroll_area = self._item_grid and self._item_grid._grid and self._item_grid._grid._scrollbar_widget and self._item_grid._grid._scrollbar_widget.content.in_scroll_area

	if input_service:get("confirm_pressed") then
		self:cb_on_equip_pressed()
	elseif scroll_axis and not in_scroll_area then
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
end

InventoryWeaponCosmeticsView.update = function (self, dt, t, input_service)
	if self:_should_refresh(dt, t) then
		self:_load_layout()
	end

	self:_update_equip_button_status()

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

	local previous_alpha_multiplier = render_settings.alpha_multiplier

	render_settings.alpha_multiplier = self.animated_alpha_multiplier or 0

	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
	UIWidget.draw(self._background_widget, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_forward_renderer)

	local item_name_widget = self._item_name_widget

	if item_name_widget then
		UIWidget.draw(item_name_widget, ui_forward_renderer)
	end

	local side_panel_widgets = self._side_panel_widgets
	local side_panel_widget_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_widget_count do
		local widget = side_panel_widgets[i]

		UIWidget.draw(widget, ui_forward_renderer)
	end

	UIRenderer.end_pass(ui_forward_renderer)
	self:_draw_elements(dt, t, ui_forward_renderer, render_settings, input_service)
	self:_draw_render_target()

	render_settings.alpha_multiplier = previous_alpha_multiplier
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
		height,
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

local function _filter_locked_elements(element)
	return not element.locked or element.widget_type == "divider"
end

InventoryWeaponCosmeticsView._filtered_layout = function (self, slot_name)
	local filtered_layout = self._layout_by_slot_name[slot_name]

	if self._show_locked_cosmetics == false then
		filtered_layout = table.filtered_array(filtered_layout, _filter_locked_elements)
	end

	return filtered_layout
end

InventoryWeaponCosmeticsView.cb_switch_tab = function (self, index)
	if index ~= self._selected_tab_index then
		if self._selected_tab_index then
			local presentation_item = self._presentation_item
			local real_item

			if self._selected_tab_index == 1 then
				real_item = self._equipped_weapon_skin
			else
				real_item = self._equipped_weapon_trinket
			end

			self._tabs_content[self._selected_tab_index].apply_on_preview(real_item, presentation_item)
			self:_preview_item(presentation_item)
		end

		self._selected_tab_index = index

		self._tab_menu_element:set_selected_index(index)

		local content = self._tabs_content[index]
		local slot_name = content.slot_name
		local item_type = content.item_type
		local generate_visual_item_function = content.generate_visual_item_function

		self._grid_display_name = content.display_name

		if not self._using_cursor_navigation then
			self:_play_sound(UISoundEvents.tab_secondary_button_pressed)
		end

		self:_show_layout_by_slot(slot_name)
	end
end

InventoryWeaponCosmeticsView._show_layout_by_slot = function (self, slot_name)
	local filtered_layout = self._weapon_cosmetic_layouts_by_slot[slot_name] or {}

	if self._show_locked_cosmetics == false then
		filtered_layout = table.filtered_array(filtered_layout, _filter_locked_elements)
	end

	local has_rarity, has_locked = false, false

	for i = 1, #filtered_layout do
		local layout = filtered_layout[i]

		if layout.item and layout.item.rarity then
			has_rarity = true
		end

		if layout.locked then
			has_locked = true
		end

		if has_rarity and has_locked then
			break
		end
	end

	if has_locked then
		self._show_locked_cosmetics = true

		if self._parent and self._parent.show_locked_cosmetics ~= nil then
			self._show_locked_cosmetics = self._parent.show_locked_cosmetics
		end
	end

	self:_setup_sort_options(has_rarity)

	self._offer_items_layout = filtered_layout or {}

	self:_present_layout_by_slot_filter()
end

InventoryWeaponCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryWeaponCosmeticsView.super.on_resolution_modified(self, scale)
	self:_update_tab_bar_position()
end

InventoryWeaponCosmeticsView._achievement_items = function (self, selected_slot_name)
	local achievement_items = {}
	local achievements = Managers.achievements:achievement_definitions()

	for _, achievement in pairs(achievements) do
		local reward_items = AchievementUIHelper.get_all_reward_items(achievement)

		for i = 1, #reward_items do
			local reward_item = reward_items[i].reward_item

			if reward_item and reward_item.slots and self:_item_valid_by_current_pattern(reward_item) and table.find(reward_item.slots, selected_slot_name) then
				local description_text

				if achievement.type == "meta" then
					local sub_penances_count = table.size(achievement.achievements)

					description_text = Localize("loc_inventory_cosmetic_item_acquisition_penance_description_multiple_requirement", true, {
						penance_amount = sub_penances_count,
					})
				else
					description_text = AchievementUIHelper.localized_description(achievement)
				end

				local is_visible_before_unlock = not achievement.flags.hide_missing
				local valid = true

				if valid and is_visible_before_unlock then
					achievement_items[#achievement_items + 1] = {
						item = reward_item,
						label = AchievementUIHelper.localized_title(achievement),
						description = description_text,
					}
				end
			end
		end
	end

	return achievement_items
end

local function items_by_name(entry_array, is_item)
	local _items_by_name = {}

	if entry_array then
		for i = 1, #entry_array do
			local entry = entry_array[i]
			local item = is_item and entry or entry.item
			local name = item and item.name

			if name then
				_items_by_name[name] = entry
			end
		end
	end

	return _items_by_name
end

InventoryWeaponCosmeticsView._prepare_layout_data = function (self)
	local tabs_content = self._tabs_content
	local items_by_slot = self._items_by_slot
	local layout_by_slot = {}

	for i = 1, #tabs_content do
		local tab_content = tabs_content[i]
		local slot_name = tab_content.slot_name
		local item_type = tab_content.item_type
		local items = items_by_slot[slot_name]
		local generate_visual_item_function = tab_content.generate_visual_item_function
		local get_empty_item_function = tab_content.get_empty_item
		local layout_count, layout = 0, {}
		local inventory_items = items and items.items
		local penance_track_items = items and items.penance_track_items
		local store_items = items and items.store_items
		local selected_slot = ItemSlotSettings[slot_name]
		local achievement_items = self:_achievement_items(slot_name)
		local player = self._preview_player
		local profile = player:profile()
		local remove_new_marker_callback = self._parent and callback(self._parent, "remove_new_item_mark")
		local locked_achievement_items_by_name = items_by_name(achievement_items, false)
		local locked_store_items_by_name = items_by_name(store_items, false)
		local locked_penance_track_items_by_name = items_by_name(penance_track_items, false)

		if inventory_items then
			for i = 1, #inventory_items do
				local inventory_item = inventory_items[i]
				local is_empty = inventory_item.empty_item
				local item

				if is_empty then
					item = get_empty_item_function(self._selected_item, slot_name, item_type)
				else
					item = inventory_item.item
				end

				if item then
					local item_name = item.name
					local found_achievement = locked_achievement_items_by_name[item_name]

					locked_achievement_items_by_name[item_name] = nil

					local found_store = locked_store_items_by_name[item_name]

					locked_store_items_by_name[item_name] = nil

					local found_penance_track = locked_penance_track_items_by_name[item_name]

					locked_penance_track_items_by_name[item_name] = nil

					local gear_id = item.gear_id
					local is_new = self._context and self._context.new_items_gear_ids and self._context.new_items_gear_ids[gear_id]
					local visual_item = is_empty and item or generate_visual_item_function(item, self._selected_item, item_type)
					local real_item = not is_empty and item or nil

					layout_count = layout_count + 1
					layout[layout_count] = {
						widget_type = "item_icon",
						is_empty = is_empty,
						item = visual_item,
						real_item = real_item,
						slot = selected_slot,
						achievement = found_achievement,
						penance_track = found_penance_track,
						store = found_store,
						new_item_marker = is_new,
						remove_new_marker_callback = remove_new_marker_callback,
						profile = profile,
						sort_group = is_empty and 0 or 1,
						render_size = {
							256,
							128,
						},
					}
				end
			end
		end

		local has_locked_achievement_item = next(locked_achievement_items_by_name) ~= nil
		local has_locked_penance_track_item = next(locked_penance_track_items_by_name) ~= nil
		local has_locked_store_item = next(locked_store_items_by_name) ~= nil

		if has_locked_achievement_item or has_locked_store_item or has_locked_penance_track_item then
			layout_count = layout_count + 1
			layout[layout_count] = {
				sort_group = 4,
				widget_type = "divider",
			}
		end

		for _, achievement_item in pairs(locked_achievement_items_by_name) do
			local item = achievement_item.item

			if item then
				local visual_item = generate_visual_item_function(achievement_item.item, self._selected_item, item_type)

				layout_count = layout_count + 1
				layout[layout_count] = {
					locked = true,
					sort_group = 5,
					widget_type = "item_icon",
					item = visual_item,
					real_item = achievement_item.item,
					slot = selected_slot,
					achievement = achievement_item,
					render_size = {
						256,
						128,
					},
				}
			end
		end

		for _, penance_track_item in pairs(locked_penance_track_items_by_name) do
			local item = penance_track_item.item

			if item then
				local visual_item = generate_visual_item_function(penance_track_item.item, self._selected_item, item_type)

				layout_count = layout_count + 1
				layout[layout_count] = {
					locked = true,
					sort_group = 5,
					widget_type = "item_icon",
					item = visual_item,
					real_item = penance_track_item.item,
					slot = selected_slot,
					penance_track = penance_track_item,
					render_size = {
						256,
						128,
					},
				}
			end
		end

		for _, store_item in pairs(locked_store_items_by_name) do
			local item = store_item.item

			if item then
				local visual_item = generate_visual_item_function(store_item.item, self._selected_item, item_type)

				layout_count = layout_count + 1
				layout[layout_count] = {
					locked = true,
					sort_group = 5,
					widget_type = "item_icon",
					item = visual_item,
					real_item = store_item.item,
					slot = selected_slot,
					store = store_item.item,
					render_size = {
						256,
						128,
					},
				}
			end
		end

		layout_by_slot[slot_name] = layout
	end

	self._weapon_cosmetic_layouts_by_slot = layout_by_slot
end

InventoryWeaponCosmeticsView._setup_side_panel = function (self, item, is_locked, dx, dy)
	self:_destroy_side_panel()

	if not item then
		return
	end

	local y_offset = 0
	local scenegraph_id = "side_panel_area"
	local max_width = self._ui_scenegraph[scenegraph_id].size[1]
	local widgets = {}

	self._side_panel_widgets = widgets

	local function _add_text_widget(pass_template, text)
		local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, {
			max_width,
			0,
		})
		local widget = self:_create_widget(string.format("side_panel_widget_%d", #widgets), widget_definition)

		widget.content.text = text
		widget.offset[2] = y_offset

		local widget_text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(widget.style.text)
		local _, text_height = self:_text_size(text, widget_text_style.font_type, widget_text_style.font_size, {
			max_width,
			math.huge,
		}, text_options)

		y_offset = y_offset + text_height
		widget.content.size[2] = text_height
		widgets[#widgets + 1] = widget
	end

	local function _add_spacing(height)
		y_offset = y_offset + height
	end

	local properties_text = Items.item_property_text(item, true)
	local unlock_title, unlock_description = Items.obtained_display_name(item)

	if unlock_title and is_locked then
		unlock_title = string.format("%s %s", "", unlock_title)
	end

	local any_text = properties_text or unlock_title or unlock_description
	local should_display_side_panel = any_text

	if not should_display_side_panel then
		return
	end

	if properties_text then
		if #widgets > 0 then
			_add_spacing(24)
		end

		_add_text_widget(Definitions.small_header_text_pass, Utf8.upper(Localize("loc_item_property_header")))
		_add_spacing(8)
		_add_text_widget(Definitions.small_body_text_pass, properties_text)
	end

	if unlock_title or unlock_description then
		if #widgets > 0 then
			_add_spacing(24)
		end

		_add_text_widget(Definitions.big_header_text_pass, Utf8.upper(Localize("loc_item_source_obtained_title")))
		_add_spacing(12)

		if unlock_title then
			_add_text_widget(Definitions.big_body_text_pass, unlock_title)
		end

		if unlock_title and unlock_description then
			_add_spacing(8)
		end

		if unlock_description then
			_add_text_widget(Definitions.big_details_text_pass, unlock_description)
		end
	end

	for i = 1, #widgets do
		local widget_offset = widgets[i].offset

		widget_offset[1] = dx
		widget_offset[2] = dy + widget_offset[2] - y_offset
	end
end

InventoryWeaponCosmeticsView.is_item_owned = function (self, target_gear_id)
	local inventory_items = self._inventory_items

	for _, item in ipairs(inventory_items) do
		local gear_id = item.gear_id

		if gear_id == target_gear_id then
			return true
		end
	end

	return false
end

return InventoryWeaponCosmeticsView
