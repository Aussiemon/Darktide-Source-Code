local Breeds = require("scripts/settings/breed/breeds")
local Definitions = require("scripts/ui/views/store_item_detail_view/store_item_detail_view_definitions")
local StoreItemDetailViewSettings = require("scripts/ui/views/store_item_detail_view/store_item_detail_view_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local MasterItems = require("scripts/backend/master_items")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWidget = require("scripts/managers/ui/ui_widget")
local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
local Archetypes = require("scripts/settings/archetype/archetypes")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local WalletSettings = require("scripts/settings/wallet_settings")
local Promise = require("scripts/foundation/utilities/promise")
local Text = require("scripts/utilities/ui/text")
local ItemUtils = require("scripts/utilities/items")
local UISettings = require("scripts/settings/ui/ui_settings")
local ContentBlueprints = require("scripts/ui/views/store_view/store_view_content_blueprints")
local TextUtils = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local StoreItemDetailView = class("StoreItemDetailView", "BaseView")

StoreItemDetailView.init = function (self, settings, context)
	self._context = context
	local class_name = self.__class_name
	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")

	self.super.init(self, Definitions, settings)

	self._pass_draw = false
	self._wallet_type = {
		"aquilas"
	}
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()
	local player = self:_player()
	local profile = player:profile()
	self._profile = profile
end

StoreItemDetailView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 102
	local world_name = self._unique_id .. "_ui_offscreen_world"
	local parent = self
	local view_name = parent.view_name
	self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = self._unique_id .. "_ui_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen"
	local viewport_layer = 1
	self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer)
	self._offscreen_viewport_name = viewport_name
	self._ui_offscreen_renderer = ui_manager:create_renderer(self._unique_id .. "_ui_offscreen_renderer", self._offscreen_world)
	local world_layer = 103
	local world_name = self._unique_id .. "_ui_description_offscreen_world"
	self._description_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = self._unique_id .. "_ui_description_offscreen_world_viewport"
	local viewport_type = "overlay_offscreen_2"
	local viewport_layer = 1
	self._description_viewport = ui_manager:create_viewport(self._description_world, viewport_name, viewport_type, viewport_layer)
	self._description_viewport_name = viewport_name
	self._ui_description_offscreen_renderer = ui_manager:create_renderer(self._unique_id .. "_ui_description_offscreen_renderer", self._description_world)
end

StoreItemDetailView._destroy_offscreen_gui = function (self)
	if self._ui_offscreen_renderer then
		self._ui_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_ui_offscreen_renderer")

		local world = self._offscreen_world
		local viewport_name = self._offscreen_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._offscreen_viewport_name = nil
		self._offscreen_world = nil
	end

	if self._ui_description_offscreen_renderer then
		self._ui_description_offscreen_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_ui_description_offscreen_renderer")

		local world = self._description_world
		local viewport_name = self._description_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._description_viewport_name = nil
		self._description_world = nil
	end
end

StoreItemDetailView._setup_forward_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local world_layer = 101
	local world_name = self._unique_id .. "_ui_forward_world"
	local view_name = self.view_name
	self._forward_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)
	local viewport_name = self._unique_id .. "_ui_forward_world_viewport"
	local viewport_type = "default_with_alpha"
	local viewport_layer = 1
	self._forward_viewport = ui_manager:create_viewport(self._forward_world, viewport_name, viewport_type, viewport_layer)
	self._forward_viewport_name = viewport_name
	local renderer_name = self._unique_id .. "_forward_renderer"
	self._ui_forward_renderer = ui_manager:create_renderer(renderer_name, self._forward_world)
	local gui = self._ui_forward_renderer.gui
	local gui_retained = self._ui_forward_renderer.gui_retained
	local resource_renderer_name = self._unique_id
	local material_name = "content/ui/materials/render_target_masks/ui_render_target_straight_blur"
	self._ui_resource_renderer = ui_manager:create_renderer(resource_renderer_name, self._forward_world, true, gui, gui_retained, material_name)
end

StoreItemDetailView._destroy_forward_gui = function (self)
	if self._ui_resource_renderer then
		local renderer_name = self._unique_id
		self._ui_resource_renderer = nil

		Managers.ui:destroy_renderer(renderer_name)
	end

	if self._ui_forward_renderer then
		self._ui_forward_renderer = nil

		Managers.ui:destroy_renderer(self._unique_id .. "_forward_renderer")

		local world = self._forward_world
		local viewport_name = self._forward_viewport_name

		ScriptWorld.destroy_viewport(world, viewport_name)
		Managers.ui:destroy_world(world)

		self._forward_viewport_name = nil
		self._forward_world = nil
	end
end

StoreItemDetailView.on_enter = function (self)
	self.super.on_enter(self)

	local context = self._context
	local offer = context.store_item.offer
	self._selected_offer = offer
	local grid_size = {
		500,
		500
	}
	self._content_blueprints = generate_blueprints_function(grid_size)
	self._current_balance = {}
	self._wallet_by_type = {}
	local offer_type = offer.description.type
	local items_to_present = {}

	if offer_type == "bundle" then
		items_to_present = self:_extract_bundle(offer)
	elseif offer_type == "skin_set" then
		items_to_present = {
			self:_extract_skin_set(offer)
		}
	else
		local item, visual_item = self:_extract_item(offer.description)
		items_to_present = {
			{
				item = visual_item,
				gearId = offer.description.gearId,
				visual_item = item
			}
		}
	end

	self._items = items_to_present

	self:_create_loading_widget()
	self:_destroy_aquilas_presentation()
	self:_setup_input_legend()
	self:_setup_offscreen_gui()
	self:_setup_background_world()
	self:_setup_forward_gui()
	self:_setup_callbacks()

	local remaining_time = context.parent:_set_expire_time(self._selected_offer)

	if remaining_time then
		self._widgets_by_name.timer_widget.content.timer_text = remaining_time
		self._should_expire = true
	end

	self._widgets_by_name.purchase_button.content.visible = false
	self._widgets_by_name.background.content.owned = true

	self:_update_wallets_presentation(nil)
	self:_update_wallets():next(function ()
		self:_setup_item_presentation(self._selected_offer)
	end)
end

StoreItemDetailView._create_loading_widget = function (self)
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true)
			}
		},
		{
			value = "content/ui/materials/loading/loading_icon",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = {
					256,
					256
				},
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "loading")
	self._loading_widget = self:_create_widget("loading", widget_definition)
end

StoreItemDetailView._setup_callbacks = function (self)
	self._widgets_by_name.purchase_button.content.hotspot.pressed_callback = callback(self, "cb_on_purchase_pressed")
end

StoreItemDetailView._is_owned = function (self, items)
	local total_count = 0
	local owned_count = 0
	local owned_items = {}

	for i = 1, #items do
		local item = items[i]

		if item.skin_set then
			local set_count = #item.items
			total_count = total_count + set_count

			for i = 1, set_count do
				local item = item.items[i]
				local is_owned = self._context.parent:is_item_owned(item.gearId)

				if is_owned then
					owned_count = owned_count + 1
				end
			end
		else
			total_count = total_count + 1
			local is_owned = self._context.parent:is_item_owned(item.gearId)

			if is_owned then
				owned_count = owned_count + 1
			end

			if is_owned then
				owned_items[#owned_items + 1] = item
			end
		end
	end

	return total_count == owned_count, owned_items
end

StoreItemDetailView._setup_item_presentation = function (self, offer)
	local description_text = nil

	if #self._items == 1 then
		local entry = self._items[1]
		entry.offer = offer
		local items = {}
		local total_count = 0
		local owned_count = 0
		local element = nil

		if entry.skin_set then
			element = {
				item = entry.skin_set,
				slot = {
					name = "slot_set"
				}
			}
			total_count = #entry.items

			for i = 1, total_count do
				local item = entry.items[i]

				if entry.item then
					if self._context.parent:is_item_owned(item.gearId) then
						owned_count = owned_count + 1
					end

					items[#items + 1] = item.item
				end
			end

			description_text = Localize(entry.skin_set.description)
		else
			total_count = 1
			items[1] = entry.item

			if entry.item then
				element = {
					item = entry.item,
					slot = {
						name = entry.item.slots and entry.item.slots[1]
					},
					visual_item = entry.visual_item
				}

				if self._context.parent:is_item_owned(entry.gearId) then
					owned_count = owned_count + 1
				end
			end

			description_text = Localize(entry.visual_item.description)
		end

		if items[1] then
			element.item_index = 1
			element.total_count = total_count
			element.owned_count = owned_count
			element.entry = entry
			local profile = self:_get_generic_profile_from_item(items[1])

			for i = 1, #items do
				local item = items[i]

				if item.slots then
					profile.loadout[item.slots[1]] = item
				end
			end

			element.dummy_profile = profile

			self:_present_single_item(element)
			self:_show_single_item(entry)

			self._widgets_by_name.item_title.content.visible = false
			self._widgets_by_name.item_title_background.content.visible = false
		end
	else
		self:_setup_item_grid()

		local num_items_text = Localize("loc_premium_store_num_items", true, {
			count = #self._grid_widgets
		})
		self._widgets_by_name.grid_title.content.text = self._grid_widgets and #self._grid_widgets > 1 and num_items_text or ""

		if self._selected_widget then
			local index = self._selected_widget.content.element.item_index

			self._grid:select_grid_index(index, nil, true, true)
		elseif self._grid_widgets[1] then
			local widget = self._grid_widgets[1]
			local element = widget.content.element

			self:cb_on_item_pressed(widget, element)
		end

		self._widgets_by_name.title.content.text = offer.sku.name or ""
		local item_type = Utf8.upper(offer.description.type)
		local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
		local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"
		self._widgets_by_name.title.content.sub_text = item_type_display_name_localized
		description_text = offer.sku.description
	end

	local title_style = self._widgets_by_name.title.style.text
	local sub_title_style = self._widgets_by_name.title.style.sub_text
	local title_options = UIFonts.get_font_options_by_style(title_style)
	local sub_title_options = UIFonts.get_font_options_by_style(sub_title_style)
	local max_width = self._ui_scenegraph.title.size[1]
	local title_width, title_height = self:_text_size(self._widgets_by_name.title.content.text, title_style.font_type, title_style.font_size, {
		max_width,
		math.huge
	}, title_options)
	local sub_title_width, sub_title_height = self:_text_size(self._widgets_by_name.title.content.sub_text, sub_title_style.font_type, sub_title_style.font_size, {
		max_width,
		math.huge
	}, sub_title_options)
	local sub_title_margin = 10
	sub_title_style.offset[2] = sub_title_margin + title_height
	local title_total_size = sub_title_style.offset[2] + sub_title_height
	local title_scenegraph_position = self._ui_scenegraph.title.position
	local margin = 30
	local max_height = self._grid_widgets and 300 or 630
	local grid_height = max_height - (title_scenegraph_position[2] + title_total_size + margin)

	self:_set_scenegraph_size("title", nil, title_total_size)
	self:_set_scenegraph_position("description_grid", nil, title_scenegraph_position[2] + title_total_size + margin)
	self:_set_scenegraph_size("description_grid", nil, grid_height)
	self:_set_scenegraph_size("description_mask", nil, grid_height + 20)
	self:_set_scenegraph_size("description_scrollbar", nil, grid_height)
	self:_setup_description_grid(description_text)
end

StoreItemDetailView._update_weapon_actions_position = function (self)
	if not self._weapon_actions then
		return
	end

	local position = self:_scenegraph_world_position("weapon_actions_pivot")

	self._weapon_actions:set_pivot_offset(position[1], position[2])
end

StoreItemDetailView._setup_description_grid = function (self, content)
	if not content then
		return
	end

	self:_destroy_description_grid()

	local widgets = {}
	local alignment_widgets = {}
	local scenegraph_id = "description_content_pivot"
	local description_text_font_style = table.clone(UIFontSettings.terminal_header_3)
	description_text_font_style.text_horizontal_alignment = "left"
	description_text_font_style.text_vertical_alignment = "top"
	description_text_font_style.font_size = 24
	local pass_template = {
		{
			value_id = "text",
			style_id = "text",
			pass_type = "text",
			value = content,
			style = description_text_font_style
		}
	}
	local max_width = self._ui_scenegraph.description_grid.size[1]
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, {
		max_width,
		0
	})
	local widget = self:_create_widget("description_widget", widget_definition)
	local text_options = UIFonts.get_font_options_by_style(widget.style.text)
	local text_width, text_height = self:_text_size(content, description_text_font_style.font_type, description_text_font_style.font_size, {
		max_width,
		math.huge
	}, text_options)
	widget.content.size[2] = text_height
	widgets[#widgets + 1] = widget
	alignment_widgets[#alignment_widgets + 1] = widget
	self._description_grid_widgets = widgets
	self._description_grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "description_grid"
	local grid_pivot_scenegraph_id = "description_content_pivot"
	local grid_spacing = {
		0,
		0
	}
	local grid_direction = "down"
	local use_is_focused_for_navigation = true
	local grid = UIWidgetGrid:new(self._description_grid_widgets, self._description_grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation)
	self._description_grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "description_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)
	grid:set_scrollbar_progress(0)
	grid:set_scroll_step_length(100)

	self._description_scroll = grid:can_scroll()
end

StoreItemDetailView._setup_item_grid = function (self)
	self:_destroy_grid()

	local widgets = {}
	local alignment_widgets = {}

	for index, entry in ipairs(self._items) do
		local widget_suffix = "entry_" .. tostring(index)
		local scenegraph_id = "grid_content_pivot"
		local total_count = 0
		local owned_count = 0
		local items = {}
		local element = {}

		if entry.skin_set then
			element = {
				item = entry.skin_set,
				slot = {
					name = "slot_set"
				}
			}
			total_count = #entry.items

			for i = 1, total_count do
				if entry.items[i].item then
					if self._context.parent:is_item_owned(entry.items[i].gearId) then
						owned_count = owned_count + 1
					end

					items[#items + 1] = entry.items[i].visual_item
				end
			end
		else
			total_count = 1
			items[1] = entry.item

			if entry.item then
				element = {
					item = entry.item,
					slot = {
						name = entry.item.slots[1]
					},
					visual_item = entry.visual_item
				}

				if self._context.parent:is_item_owned(entry.gearId) then
					owned_count = owned_count + 1
				end
			end
		end

		if items[1] then
			element.item_index = index
			element.total_count = total_count
			element.owned_count = owned_count
			element.entry = entry
			element.offer = entry.offer
			local widget_type = "gear_item"

			if element.slot.name == "slot_primary" or element.slot.name == "slot_secondary" then
				widget_type = "item_icon"
			elseif entry.skin_set then
				widget_type = "gear_item"
			end

			local ui_renderer = self._ui_renderer
			local widget = nil
			local template = self._content_blueprints[widget_type]
			local size = template.size_function and template.size_function(self, element) or template.size
			local pass_template_function = template.pass_template_function
			local pass_template = pass_template_function and pass_template_function(self, element) or template.pass_template
			local optional_style = template.style
			local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

			if widget_definition then
				local name = "widget_" .. widget_suffix
				widget = self:_create_widget(name, widget_definition)
				widget.type = widget_type
				local init = template.init

				if init then
					init(self, widget, element, "cb_on_item_pressed", nil, ui_renderer)
				end
			end

			if widget.style.style_id_1 then
				widget.style.style_id_1.on_pressed_sound = UISoundEvents.default_click
			end

			local profile = self:_get_generic_profile_from_item(items[1])

			for i = 1, #items do
				local item = items[i]
				profile.loadout[item.slots[1]] = item
			end

			element.dummy_profile = profile

			if widget then
				widgets[#widgets + 1] = widget
				alignment_widgets[#alignment_widgets + 1] = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size = {
						128,
						128
					},
					name = widget.name
				}
			else
				widgets[#widgets + 1] = nil
				alignment_widgets[#alignment_widgets + 1] = {
					size = size
				}
			end
		end
	end

	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets
	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = {
		10,
		10
	}
	local grid_direction = "down"
	local use_is_focused_for_navigation = true
	local grid = UIWidgetGrid:new(self._grid_widgets, self._grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation)
	self._grid = grid
	local widgets_by_name = self._widgets_by_name
	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)

	local initial_scroll = self._current_scrollbar_progress or 0

	grid:set_scroll_step_length(100)
	grid:set_scrollbar_progress(initial_scroll)

	self._current_scrollbar_progress = nil
end

StoreItemDetailView.set_expire_time = function (self, time, widget)
	local timer_text = time and Text.format_time_span_long_form_localized(time) or ""
	widget.content.text = timer_text
end

StoreItemDetailView.cb_on_item_pressed = function (self, widget, element)
	if self._selected_widget ~= widget then
		local index = self._grid:index_by_widget(widget)

		self._grid:select_grid_index(index, nil, true, true)
		self:_destroy_weapon()
		self:_destroy_profile()

		self._selected_widget = widget

		self:_present_single_item(element)
	end
end

StoreItemDetailView._present_single_item = function (self, element)
	local title = ""
	local sub_type = nil

	if self._items[element.item_index].skin_set then
		local items = {}

		for i = 1, #self._items[element.item_index].items do
			items[#items + 1] = self._items[element.item_index].items[i].item
		end

		self:_spawn_profile(element.dummy_profile, items)

		title = self._items[element.item_index].skin_set.display_name and Localize(self._items[element.item_index].skin_set.display_name) or ""
		sub_type = self._items[element.item_index].skin_set.item_type
		self._is_dummy_showing = true
		self._is_weapon_showing = false
	elseif element.visual_item.item_type == "WEAPON_RANGED" or element.visual_item.item_type == "WEAPON_MELEE" or element.visual_item.item_type == "WEAPON_SKIN" or element.visual_item.item_type == "WEAPON_TRINKET" then
		self:_set_camera_focus(element.dummy_profile.breed)
		self:_setup_weapon_preview()
		self:_present_weapon(element.item)

		title = element.visual_item.display_name and element.visual_item.item_type and Localize(element.visual_item.display_name) or ""
		sub_type = element.visual_item.item_type
		self._is_dummy_showing = false
		self._is_weapon_showing = true
	else
		self:_spawn_profile(element.dummy_profile, self._items[element.item_index].item)

		title = element.visual_item.display_name and element.visual_item.item_type and Localize(element.visual_item.display_name) or ""
		sub_type = element.visual_item.item_type
		self._is_dummy_showing = true
		self._is_weapon_showing = false
	end

	self._widgets_by_name.item_title.content.text = title
	local item_type = sub_type and Utf8.upper(sub_type) or ""
	local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
	local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"
	self._widgets_by_name.item_title.content.sub_text = item_type_display_name_localized
	self._widgets_by_name.item_title.content.owned = element.owned_count == element.total_count
	local title_style = self._widgets_by_name.item_title.style.text
	local sub_title_style = self._widgets_by_name.item_title.style.sub_text
	local title_options = UIFonts.get_font_options_by_style(title_style)
	local sub_title_options = UIFonts.get_font_options_by_style(sub_title_style)
	local max_width = self._ui_scenegraph.item_title.size[1]
	local title_width, title_height = self:_text_size(self._widgets_by_name.item_title.content.text, title_style.font_type, title_style.font_size, {
		max_width,
		math.huge
	}, title_options)
	local sub_title_width, sub_title_height = self:_text_size(self._widgets_by_name.item_title.content.sub_text, sub_title_style.font_type, sub_title_style.font_size, {
		max_width,
		math.huge
	}, sub_title_options)
	local sub_title_margin = 10
	sub_title_style.offset[2] = sub_title_margin + title_height
	local margin_compensation = 5

	self:_set_scenegraph_size("item_title_background", nil, sub_title_height + sub_title_style.offset[2] + margin_compensation)
	self:_set_scenegraph_size("item_title", nil, sub_title_height + sub_title_style.offset[2] + margin_compensation)

	local restrictions_text, present_text = nil

	if element.visual_item.item_type == "WEAPON_SKIN" then
		restrictions_text, present_text = ItemUtils.weapon_skin_requirement_text(element.visual_item)
	elseif element.visual_item.item_type == "GEAR_UPPERBODY" or element.visual_item.item_type == "GEAR_EXTRA_COSMETIC" or element.visual_item.item_type == "GEAR_HEAD" or element.visual_item.item_type == "GEAR_LOWERBODY" then
		restrictions_text, present_text = ItemUtils.class_requirement_text(element.visual_item)
	end

	if present_text then
		self._widgets_by_name.item_restrictions.content.text = restrictions_text
		local restriction_title_style = self._widgets_by_name.item_restrictions.style.title
		local restriction_text_style = self._widgets_by_name.item_restrictions.style.text
		local restriction_title_options = UIFonts.get_font_options_by_style(restriction_title_style)
		local restriction_text_options = UIFonts.get_font_options_by_style(restriction_text_style)
		local restriction_title_width, restriction_title_height = self:_text_size(self._widgets_by_name.item_restrictions.content.title, restriction_title_style.font_type, restriction_title_style.font_size, {
			max_width,
			math.huge
		}, restriction_title_options)
		local restriction_text_width, title_restriction_text_height = self:_text_size(self._widgets_by_name.item_restrictions.content.text, restriction_text_style.font_type, restriction_text_style.font_size, {
			max_width,
			math.huge
		}, restriction_text_options)
		local text_height = restriction_title_height + title_restriction_text_height + sub_title_margin

		self:_set_scenegraph_size("item_restrictions_background", nil, text_height + margin_compensation * 2)
		self:_set_scenegraph_size("item_restrictions", nil, text_height)

		self._widgets_by_name.item_restrictions.style.text.offset[2] = restriction_title_height + sub_title_margin
		self._widgets_by_name.item_restrictions.content.visible = true
	else
		self._widgets_by_name.item_restrictions.content.visible = false
	end
end

StoreItemDetailView._destroy_grid = function (self)
	if self._grid then
		for i = 1, #self._grid_widgets do
			local widget = self._grid_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._grid = nil
		self._grid_widgets = nil
		self._grid_alignment_widgets = nil
	end
end

StoreItemDetailView._destroy_description_grid = function (self)
	if self._description_grid then
		for i = 1, #self._description_grid_widgets do
			local widget = self._description_grid_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._description_grid = nil
		self._description_grid_widgets = nil
		self._description_grid_alignment_widgets = nil
	end
end

StoreItemDetailView._extract_bundle = function (self, store_item)
	local items = {}

	for i = 1, #store_item.bundleInfo do
		local bundle_item = store_item.bundleInfo[i]

		if bundle_item.description.type == "skin_set" then
			items[#items + 1] = self:_extract_skin_set(bundle_item)
		else
			local item, visual_item = self:_extract_item(bundle_item.description)
			local item_info = table.clone(bundle_item)

			if item_info.price then
				item_info.price.type = "aquilas"
			end

			items[#items + 1] = {
				item = visual_item,
				gearId = bundle_item.description.gearId,
				visual_item = item,
				offer = item_info
			}
		end
	end

	return items
end

StoreItemDetailView._extract_skin_set = function (self, store_item)
	local items = {}
	local parts = store_item.description.contents.parts

	if parts then
		for slot_name, set_item in pairs(parts) do
			local item, visual_item = self:_extract_item(set_item)
			items[#items + 1] = {
				item = visual_item,
				gearId = set_item.gearId,
				visual_item = item
			}
		end
	end

	local item, visual_item = self:_extract_item(store_item.description)

	return {
		skin_set = visual_item,
		items = items
	}
end

StoreItemDetailView._extract_item = function (self, description)
	local modified_desciption = table.clone(description)
	modified_desciption.gear_id = description.gearId
	local item = MasterItems.get_store_item_instance(modified_desciption)

	if not item then
		return
	end

	local visual_item = nil
	local item_type = item.item_type

	if item_type == "WEAPON_SKIN" then
		visual_item = ItemUtils.weapon_skin_preview_item(item)
	elseif item_type == "WEAPON_TRINKET" then
		visual_item = ItemUtils.weapon_trinket_preview_item(item)

		if visual_item and not visual_item.slots then
			visual_item.slots = {
				"slot_trinket_1"
			}
		end
	end

	visual_item = visual_item or item

	return item, visual_item
end

StoreItemDetailView._get_generic_profile_from_item = function (self, item)
	local item_gender, item_breed, item_archetype, dummy_profile = nil
	local profile = self._profile

	if profile then
		if item.genders and not table.is_empty(item.genders) then
			for i = 1, #item.genders do
				local gender = item.genders[i]

				if gender == profile.gender then
					item_gender = profile.gender

					break
				end
			end
		else
			item_gender = profile.gender
		end

		if item.breeds and not table.is_empty(item.breeds) then
			for i = 1, #item.breeds do
				local breed = item.breeds[i]

				if breed == profile.breed then
					item_breed = profile.breed

					break
				end
			end
		else
			item_breed = profile.breed
		end

		if item.archetypes and not table.is_empty(item.archetypes) then
			for i = 1, #item.archetypes do
				local archetype = item.archetypes[i]

				if archetype == profile.archetype.name then
					item_archetype = profile.archetype

					break
				end
			end
		else
			item_archetype = profile.archetype
		end
	end

	local compatible_profile = item_gender and item_breed and item_archetype

	if compatible_profile then
		dummy_profile = table.clone_instance(profile)
	else
		local breed = item_breed or item.breeds and item.breeds[1] or "human"
		local archetype = item_archetype or item.archetypes and item.archetypes[1] and Archetypes[item.archetypes[1]] or breed == "ogryn" and Archetypes.ogryn or Archetypes.veteran
		local gender = breed ~= "ogryn" and (item_gender or item.genders and item.genders[1]) or "male"
		dummy_profile = {
			loadout = {},
			archetype = archetype,
			breed = breed,
			gender = gender
		}
	end

	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[dummy_profile.breed]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[dummy_profile.gender]

	if required_gender_item_names_per_slot then
		local required_items = required_gender_item_names_per_slot

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)
					dummy_profile.loadout[slot_name] = slot_item
				end
			end
		end
	end

	return dummy_profile
end

StoreItemDetailView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)
	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

StoreItemDetailView._setup_background_world = function (self)
	local breeds = {
		"human",
		"ogryn"
	}
	self._item_camera_by_slot_id = {}
	self._camera_units = {}

	for i = 1, #breeds do
		local breed_name = breeds[i]
		local camera_event_id = "event_register_inventory_default_camera_" .. breed_name

		self[camera_event_id] = function (self, camera_unit)
			self._camera_units[breed_name] = camera_unit
			local camera_position = Unit.world_position(camera_unit, 1)
			local camera_rotation = Unit.world_rotation(camera_unit, 1)
			local boxed_camera_start_position = Vector3Box(camera_position)
			local boxed_camera_start_rotation = QuaternionBox(camera_rotation)
			local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)
			local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
			local default_camera_world_rotation_x, default_camera_world_rotation_y, default_camera_world_rotation_z = Quaternion.to_euler_angles_xyz(default_camera_world_rotation)
			self._item_camera_by_slot_id[breed_name].default = {
				position = {
					x = default_camera_world_position.x,
					y = default_camera_world_position.y,
					z = default_camera_world_position.z
				},
				rotation = {
					x = default_camera_world_rotation_x,
					y = default_camera_world_rotation_y,
					z = default_camera_world_rotation_z
				}
			}

			if i == #breeds then
				local viewport_name = StoreItemDetailViewSettings.viewport_name
				local viewport_type = StoreItemDetailViewSettings.viewport_type
				local viewport_layer = StoreItemDetailViewSettings.viewport_layer
				local shading_environment = StoreItemDetailViewSettings.shading_environment

				self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
			end

			self:_unregister_event(camera_event_id)
		end

		self:_register_event(camera_event_id)

		self._item_camera_by_slot_id[breed_name] = {}

		for slot_name, slot in pairs(ItemSlotSettings) do
			if slot.slot_type == "gear" then
				local item_camera_event_id = "event_register_inventory_item_camera_" .. breed_name .. "_" .. slot_name

				self[item_camera_event_id] = function (self, camera_unit)
					self._item_camera_by_slot_id[breed_name][slot_name] = camera_unit

					self:_unregister_event(item_camera_event_id)
				end

				self:_register_event(item_camera_event_id)
			end
		end
	end

	self:_register_event("event_register_character_spawn_point")

	local world_name = StoreItemDetailViewSettings.world_name
	local world_layer = StoreItemDetailViewSettings.world_layer
	local world_timer_name = StoreItemDetailViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = StoreItemDetailViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
	self:_update_viewport_resolution()
end

StoreItemDetailView.on_resolution_modified = function (self)
	self.super.on_resolution_modified(self)

	if self._world_spawner then
		self:_update_viewport_resolution()
	end
end

StoreItemDetailView._update_viewport_resolution = function (self)
	self:_force_update_scenegraph()

	local scale = self._render_scale
	local scenegraph = self._ui_scenegraph
	local id = "screen"
	local x_scale, y_scale, w_scale, h_scale = UIScenegraph.get_scenegraph_id_screen_scale(scenegraph, id, scale)

	self._world_spawner:set_viewport_size(w_scale, h_scale)
	self._world_spawner:set_viewport_position(x_scale, y_scale)
end

StoreItemDetailView.event_register_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

StoreItemDetailView._set_camera_focus = function (self, breed_name, slot_name, time, func_ptr)
	local world_spawner = self._world_spawner
	local default_camera = self._camera_units[breed_name]

	world_spawner:change_camera_unit(default_camera)

	local slot_camera = slot_name and self._item_camera_by_slot_id[breed_name][slot_name]
	local camera_world_position, camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = nil

	if slot_camera then
		camera_world_position = Unit.world_position(slot_camera, 1)
		local camera_world_rotation = Unit.world_rotation(slot_camera, 1)
		camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = Quaternion.to_euler_angles_xyz(camera_world_rotation)
	else
		camera_world_position = self._item_camera_by_slot_id[breed_name].default.position
		camera_world_rotation_x = self._item_camera_by_slot_id[breed_name].default.rotation.x
		camera_world_rotation_y = self._item_camera_by_slot_id[breed_name].default.rotation.y
		camera_world_rotation_z = self._item_camera_by_slot_id[breed_name].default.rotation.z
	end

	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)

	world_spawner:set_camera_position_axis_offset("x", camera_world_position.x - default_camera_world_position.x, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("y", camera_world_position.y - default_camera_world_position.y, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("z", camera_world_position.z - default_camera_world_position.z, time, func_ptr)

	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local default_camera_world_rotation_x, default_camera_world_rotation_y, default_camera_world_rotation_z = Quaternion.to_euler_angles_xyz(default_camera_world_rotation)

	world_spawner:set_camera_rotation_axis_offset("x", camera_world_rotation_x - default_camera_world_rotation_x, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("y", camera_world_rotation_y - default_camera_world_rotation_y, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("z", camera_world_rotation_z - default_camera_world_rotation_z, time, func_ptr)
end

StoreItemDetailView.on_exit = function (self)
	self:_destroy_profile()

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_destroy_offscreen_gui()
	self:_destroy_forward_gui()

	if self._store_promise then
		self._store_promise:cancel()
	end

	if self._purchase_promise then
		self._purchase_promise:cancel()
	end

	if self._wallet_promise then
		self._wallet_promise:cancel()
	end

	self.super.on_exit(self)
end

StoreItemDetailView._handle_input = function (self, input_service)
	if not self._using_cursor_navigation then
		if self._aquilas_showing then
			local new_selection_index = nil

			if input_service:get("navigate_left_continuous") then
				new_selection_index = self._selected_aquila_index > 1 and self._selected_aquila_index - 1 or 1
			elseif input_service:get("navigate_right_continuous") then
				new_selection_index = self._selected_aquila_index < #self._aquilas_widgets and self._selected_aquila_index + 1 or #self._aquilas_widgets
			end

			if new_selection_index then
				self:_select_aquila_widget_by_index(new_selection_index)

				self._selected_aquila_index = new_selection_index
			end
		elseif self._description_scroll and input_service:get("navigate_secondary_right_held") then
			local length_scrolled = self._description_grid:length_scrolled()
			local value = self._description_grid:scroll_progress_by_length(length_scrolled + 2)

			self._description_grid:set_scrollbar_progress(value)
		elseif self._description_scroll and input_service:get("navigate_secondary_left_held") then
			local length_scrolled = self._description_grid:length_scrolled()
			local value = self._description_grid:scroll_progress_by_length(length_scrolled - 2)

			self._description_grid:set_scrollbar_progress(value)
		elseif self._widgets_by_name.purchase_button.content.visible == true and not self._widgets_by_name.purchase_button.content.hotspot.disabled and input_service:get("confirm_pressed") then
			self:cb_on_purchase_pressed()
		end
	end
end

StoreItemDetailView._on_navigation_input_changed = function (self)
	if not self._using_cursor_navigation then
		if self._aquilas_showing then
			if not self._selected_aquila_index then
				self._selected_aquila_index = 1
			end

			self:_select_aquila_widget_by_index(self._selected_aquila_index)
		end
	elseif self._aquilas_showing then
		self._selected_aquila_index = nil

		self:_select_aquila_widget_by_index()
	end
end

StoreItemDetailView.update = function (self, dt, t, input_service)
	if self._store_promise or self._purchase_promise or self._wallet_promise then
		input_service = input_service:null_service()
		self._show_loading = true
	elseif self._show_loading then
		self._show_loading = false
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._grid then
		self._grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)

		local current_scrollbar_progress = self._grid:scrollbar_progress()

		if self._current_scrollbar_progress ~= current_scrollbar_progress then
			self._current_scrollbar_progress = current_scrollbar_progress

			self:_update_grid_widgets_visibility()
		end

		if self._selected_grid_index ~= self._grid:selected_grid_index() then
			self._selected_grid_index = self._grid:selected_grid_index()

			if self._selected_grid_index and self._grid_widgets[self._selected_grid_index] then
				self._grid_widgets[self._selected_grid_index].content.hotspot.pressed_callback()
			end
		end
	end

	if self._description_grid then
		self._description_grid:update(dt, t, input_service)
	end

	if self._should_expire then
		local widget = self._widgets_by_name.timer_widget
		local offer = self._context.store_item.offer
		local time_remaining = self._context.parent:_set_expire_time(offer)

		if not time_remaining then
			self._widgets_by_name.purchase_button.content.hotspot.disabled = true

			if self._popup_id then
				Managers.event:trigger("event_remove_ui_popup", self._popup_id)
			end

			local view_name = self.view_name

			Managers.ui:close_view(view_name)

			self._should_expire = false
		else
			widget.content.text = time_remaining
		end
	end

	return self.super.update(self, dt, t, input_service)
end

StoreItemDetailView._update_grid_widgets = function (self, dt, t, input_service)
	local widgets = self._grid_widgets

	if widgets then
		local handle_input = false

		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = self._content_blueprints[widget_type]
			local update = template and template.update
			local content = widget.content
			local grid = self._grid
			local visible = grid:is_widget_visible(widget)
			content.visible = visible

			if update then
				update(self, widget, input_service, dt, t)
			end
		end
	end
end

StoreItemDetailView._update_grid_widgets_visibility = function (self)
	local widgets = self._grid_widgets

	if widgets then
		local num_widgets = #widgets
		local ui_renderer = self._ui_offscreen_renderer

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = self._content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if not visible and template.unload_icon then
					template.unload_icon(self, widget, element, ui_renderer)
				end
			end
		end

		for i = 1, num_widgets do
			local widget = widgets[i]
			local widget_type = widget.type
			local template = self._content_blueprints[widget_type]

			if template then
				local content = widget.content
				local element = content.element
				local visible = content.visible

				if visible and template.load_icon then
					template.load_icon(self, widget, element, ui_renderer, element.dummy_profile)
				end
			end
		end
	end
end

StoreItemDetailView._reset_camera_placement = function (self)
	local animation_duration = 0.01
	local world_spawner = self._world_spawner

	world_spawner:set_camera_position_axis_offset("x", 0.5, animation_duration, math.easeOutCubic)
	world_spawner:set_camera_position_axis_offset("y", 0, animation_duration, math.easeOutCubic)
	world_spawner:set_camera_position_axis_offset("z", 0, animation_duration, math.easeOutCubic)
	world_spawner:set_camera_rotation_axis_offset("x", 0, animation_duration, math.easeOutCubic)
	world_spawner:set_camera_rotation_axis_offset("y", 0, animation_duration, math.easeOutCubic)
	world_spawner:set_camera_rotation_axis_offset("z", 0, animation_duration, math.easeOutCubic)
end

StoreItemDetailView._spawn_profile = function (self, profile, items)
	self:_destroy_profile()

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	self._profile_spawner = UIProfileSpawner:new("StoreItemDetailView", world, camera, unit_spawner)
	local ignored_slots = StoreItemDetailViewSettings.ignored_slots

	for i = 1, #ignored_slots do
		local slot_name = ignored_slots[i]

		self._profile_spawner:ignore_slot(slot_name)
	end

	local camera_position = ScriptCamera.position(camera)
	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)
	camera_position.z = 0
	local selected_archetype = profile.archetype
	local archetype_name = selected_archetype.name
	local breed_name = selected_archetype and selected_archetype.breed or profile.breed
	local breed_settings = Breeds[breed_name]
	local inventory_state_machine = breed_settings.inventory_state_machine

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation, nil, inventory_state_machine)

	local slot_name = nil

	if items and #items == 0 and type(items) == "table" then
		slot_name = items.slots and items.slots[1]
	end

	self:_set_camera_focus(breed_name, slot_name)

	self._spawned_profile = profile
end

StoreItemDetailView.cb_on_close_pressed = function (self)
	if self._aquilas_showing then
		self:_update_wallets()
		self:_destroy_aquilas_presentation()
		self:_show_elements()

		if self._selected_widget then
			self:_present_single_item(self._selected_widget.content.element)
		else
			self:_setup_item_presentation(self._selected_offer)
		end

		if self._detailed_item then
			self:_open_item_details()
		end

		self._aquilas_showing = false
	elseif self._detailed_item then
		self:_close_item_details()
	else
		local view_name = self.view_name

		Managers.ui:close_view(view_name)
	end

	self:_play_sound(UISoundEvents.default_menu_exit)
end

StoreItemDetailView.cb_on_details_pressed = function (self)
	self:_open_item_details()
end

StoreItemDetailView._destroy_set_widgets = function (self)
	if self._set_widgets then
		for i = 1, #self._set_widgets do
			local widget = self._set_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._set_widgets = nil
	end
end

StoreItemDetailView._hide_elements = function (self)
	self:_hide_item_offer()

	self._widgets_by_name.grid_title.content.visible = false
	self._widgets_by_name.title.content.visible = false
	self._widgets_by_name.title.content.visible = false
	self._widgets_by_name.background.content.visible = false
	self._widgets_by_name.grid_scrollbar.content.visible = false
	self._widgets_by_name.description_scrollbar.content.visible = false
	self._widgets_by_name.item_restrictions.content.visible = false
	self._widgets_by_name.timer_widget.content.visible = false

	self:_destroy_weapon()
	self:_destroy_profile()
end

StoreItemDetailView._show_elements = function (self)
	self:_show_item_offer()

	self._widgets_by_name.grid_title.content.visible = true
	self._widgets_by_name.title.content.visible = true
	self._widgets_by_name.title.content.visible = true
	self._widgets_by_name.background.content.visible = true
	self._widgets_by_name.grid_scrollbar.content.visible = true
	self._widgets_by_name.item_restrictions.content.visible = true
	self._widgets_by_name.timer_widget.content.visible = true
end

StoreItemDetailView._hide_item_offer = function (self)
	self:_destroy_grid()
	self:_destroy_description_grid()
	self:_destroy_price_presentation()

	self._widgets_by_name.item_title.content.visible = false
	self._widgets_by_name.item_title_background.content.visible = false
	self._widgets_by_name.purchase_button.content.visible = false
	self._widgets_by_name.price_text.content.visible = false
	self._widgets_by_name.owned_info_text.content.visible = false
end

StoreItemDetailView._show_item_offer = function (self)
	self._selected_offer = self._context.store_item.offer
	self._widgets_by_name.item_title.content.visible = true
	self._widgets_by_name.item_title_background.content.visible = true
	self._widgets_by_name.grid_title.content.visible = true

	self:_setup_item_presentation(self._selected_offer)
	self:_update_purchase_button(self._selected_offer)
end

StoreItemDetailView._open_item_details = function (self)
	self._detailed_item = true

	self:_hide_item_offer()

	local entry = self._selected_widget.content.element.entry

	self:_show_single_item(entry)
end

StoreItemDetailView._show_single_item = function (self, entry)
	self._selected_item_index = self._selected_widget and self._selected_widget.content.element.item_index or nil
	local description_text = nil

	if entry.skin_set then
		self._widgets_by_name.grid_title.content.text = Localize("loc_premium_store_set_includes_title")
		local count = 0
		local margin_bottom = 20
		local offset = 0
		local widget_height = 50
		local widgets = {}

		for i = 1, #entry.items do
			local set_item = entry.items[i]
			local item = set_item.item
			local widget_definition = Definitions.set_detail_definition
			local name = "set_item_" .. i
			local widget = self:_create_widget(name, widget_definition)
			widget.offset = {
				0,
				offset,
				1
			}
			widget.style.texture.material_values.texture_map = ItemUtils.type_texture(item)
			widget.content.text = ItemUtils.type_display_name(item)
			offset = margin_bottom + offset + widget_height
			widget.content.owned = self._context.parent:is_item_owned(set_item.gearId)
			widgets[#widgets + 1] = widget
		end

		self._set_widgets = widgets
		self._widgets_by_name.title.content.text = Localize(entry.skin_set.display_name)
		local item_type = Utf8.upper(entry.skin_set.item_type)
		local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
		local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"
		self._widgets_by_name.title.content.sub_text = item_type_display_name_localized
		description_text = Localize(entry.skin_set.description)
	else
		self._widgets_by_name.grid_title.content.visible = false
		self._widgets_by_name.title.content.text = Localize(entry.visual_item.display_name)
		local item_type = entry.visual_item.item_type and Utf8.upper(entry.visual_item.item_type) or ""
		local item_type_localization_key = UISettings.item_type_localization_lookup[item_type]
		local item_type_display_name_localized = item_type_localization_key and Localize(item_type_localization_key) or "<undefined item_type>"
		self._widgets_by_name.title.content.sub_text = item_type_display_name_localized
		description_text = Localize(entry.visual_item.description)
	end

	local title_style = self._widgets_by_name.title.style.text
	local sub_title_style = self._widgets_by_name.title.style.sub_text
	local title_options = UIFonts.get_font_options_by_style(title_style)
	local sub_title_options = UIFonts.get_font_options_by_style(sub_title_style)
	local max_width = self._ui_scenegraph.title.size[1]
	local title_width, title_height = self:_text_size(self._widgets_by_name.title.content.text, title_style.font_type, title_style.font_size, {
		max_width,
		math.huge
	}, title_options)
	local sub_title_width, sub_title_height = self:_text_size(self._widgets_by_name.title.content.sub_text, sub_title_style.font_type, sub_title_style.font_size, {
		max_width,
		math.huge
	}, sub_title_options)
	title_style.size = {
		max_width,
		title_height
	}
	local sub_title_margin = 10
	sub_title_style.offset[2] = sub_title_margin + title_height
	local title_total_size = sub_title_style.offset[2] + sub_title_height
	local title_scenegraph_position = self._ui_scenegraph.title.position
	local margin = 20
	local max_height = self._grid_widgets and 300 or 630
	local grid_height = max_height - (title_scenegraph_position[2] + title_total_size + margin)

	self:_set_scenegraph_size("title", nil, title_total_size)
	self:_set_scenegraph_position("description_grid", nil, title_scenegraph_position[2] + title_total_size + margin)
	self:_set_scenegraph_size("description_grid", nil, grid_height)
	self:_set_scenegraph_size("description_mask", nil, grid_height + 20)
	self:_set_scenegraph_size("description_scrollbar", nil, grid_height)
	self:_setup_description_grid(description_text)

	self._selected_offer = entry.offer

	self:_update_purchase_button(self._selected_offer)
end

StoreItemDetailView._close_item_details = function (self)
	self._detailed_item = false
	self._selected_item_index = nil

	self:_destroy_set_widgets()
	self:_show_item_offer()
end

StoreItemDetailView.draw = function (self, dt, t, input_service, layer)
	if self._show_loading then
		input_service = input_service:null_service()
	end

	local render_scale = self._render_scale
	local render_settings = self._render_settings
	local ui_forward_renderer = self._ui_forward_renderer
	local ui_renderer = self._ui_renderer
	render_settings.start_layer = layer
	render_settings.scale = render_scale
	render_settings.inverse_scale = render_scale and 1 / render_scale
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_forward_renderer)

	local wallet_widgets = self._wallet_widgets

	if wallet_widgets then
		for i = 1, #wallet_widgets do
			local widget = wallet_widgets[i]

			UIWidget.draw(widget, ui_forward_renderer)
		end
	end

	local price_widgets = self._price_widgets

	if price_widgets then
		for i = 1, #price_widgets do
			local widget = price_widgets[i]

			UIWidget.draw(widget, ui_forward_renderer)
		end
	end

	local set_widgets = self._set_widgets

	if set_widgets then
		for i = 1, #set_widgets do
			local widget = set_widgets[i]

			UIWidget.draw(widget, ui_forward_renderer)
		end
	end

	local aquilas_widgets = self._aquilas_widgets

	if self._aquilas_widgets then
		for i = 1, #aquilas_widgets do
			local widget = aquilas_widgets[i]

			UIWidget.draw(widget, ui_forward_renderer)
		end
	end

	if self._show_loading and self._loading_widget then
		UIWidget.draw(self._loading_widget, ui_forward_renderer)
	end

	UIRenderer.end_pass(ui_forward_renderer)
	self:_draw_grid(dt, t, input_service)
	self:_draw_description_grid(dt, t, input_service)

	if self._weapon_preview then
		self._weapon_preview:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	if self._input_legend_element then
		self._input_legend_element:draw(dt, t, ui_forward_renderer, render_settings, input_service)
	end

	self:_draw_render_target()
end

StoreItemDetailView._draw_render_target = function (self)
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

StoreItemDetailView._draw_grid = function (self, dt, t, input_service)
	local grid = self._grid

	if not grid then
		return
	end

	local interaction_widget = self._widgets_by_name.grid_background
	local is_grid_hovered = not self._using_cursor_navigation or interaction_widget.content.hotspot.is_hover or false
	local widgets = self._grid_widgets
	local render_settings = self._render_settings
	local ui_renderer = self._ui_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		if grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)

			local hotspot = widget.content.hotspot

			if hotspot then
				hotspot.force_disabled = not is_grid_hovered
			end
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

StoreItemDetailView._draw_description_grid = function (self, dt, t, input_service)
	local description_grid = self._description_grid

	if not description_grid then
		return
	end

	local widgets = self._description_grid_widgets
	local render_settings = self._render_settings
	local ui_renderer = self._ui_description_offscreen_renderer
	local ui_scenegraph = self._ui_scenegraph

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	for i = 1, #widgets do
		local widget = widgets[i]

		if description_grid:is_widget_visible(widget) then
			UIWidget.draw(widget, ui_renderer)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

StoreItemDetailView._setup_weapon_preview = function (self)
	if not self._weapon_preview then
		local reference_name = "weapon_preview"
		local layer = 1
		self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, {
			draw_background = false
		})

		self:_update_weapon_preview_viewport()
	end
end

StoreItemDetailView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local width_scale = 1
		local height_scale = 1
		local x_scale = 0
		local y_scale = 0

		weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
		weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

		local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

		weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)
	end
end

StoreItemDetailView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale = nil
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

StoreItemDetailView._destroy_weapon_preview = function (self)
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

StoreItemDetailView._present_weapon = function (self, item)
	local disable_auto_spin = true

	self._weapon_preview:present_item(item, disable_auto_spin)
	self._weapon_preview:center_align(0, {
		-0.5,
		-2,
		-0.2
	})
	self._weapon_preview:set_force_allow_rotation(true)
end

StoreItemDetailView._destroy_weapon = function (self)
	self:_destroy_weapon_preview()
end

StoreItemDetailView._destroy_profile = function (self)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end
end

StoreItemDetailView._destroy_price_presentation = function (self)
	if self._price_widgets then
		for i = 1, #self._price_widgets do
			local widget = self._price_widgets[i]

			self:_unregister_widget_name(widget.name)
		end

		self._price_widgets = nil
	end
end

StoreItemDetailView._update_price_presentation = function (self, offer)
	local total_width = 0
	local price_widget = self._widgets_by_name.price_text
	local price = offer.price and offer.price.amount

	if not price then
		return
	end

	local content = price_widget.content
	local style = price_widget.style
	local texture_width = price_widget.style.price_icon.size[1]
	local icon_margin = 10
	local discount_margin = 15
	self._widgets_by_name.price_text.content.element = offer

	if offer.discount then
		style.discount_price.material = "content/ui/materials/font_gradients/slug_font_gradient_sale"
		content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", TextUtils.format_currency(offer.discount))
		style.discount_price.offset[1] = texture_width + icon_margin
	end

	content.price = offer.owned and string.format("%s ", Localize("loc_item_owned")) or price.formattedPrice and price.formattedPrice or TextUtils.format_currency(price.amount)
	local discount_width, _ = self:_text_size(content.discount_price, style.discount_price.font_type, style.discount_price.font_size)
	local text_width, _ = self:_text_size(content.price, style.price.font_type, style.price.font_size)
	price_widget.style.price.offset[1] = texture_width + icon_margin + total_width

	if discount_width > 0 then
		price_widget.style.price.offset[1] = price_widget.style.price.offset[1] + discount_margin + discount_width
	end

	total_width = price_widget.style.price.offset[1] + text_width

	self:_set_scenegraph_size("price_text", total_width, nil)

	local wallet_settings = WalletSettings.aquilas
	local font_gradient_material = wallet_settings.font_gradient_material
	local icon_texture_small = wallet_settings.icon_texture_small
	style.price.material = not offer.owned and font_gradient_material
	style.price.text_color = offer.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
	content.price_icon = icon_texture_small
	local discount_banner_widget = self._widgets_by_name.promo
	local discount_content = discount_banner_widget.content

	if offer.discount_percent and not offer.owned then
		discount_content.discount_banner = true
		local index = 1
		local value_to_string = tostring(offer.discount_percent)
		local num_digits = #value_to_string

		for i = num_digits, 1, -1 do
			local string_digit = string.sub(value_to_string, i - 1, 1)

			if string_digit and string_digit ~= "" then
				local pass_name = string.format("discount_percent_%d", index)
				local show_pass_name = string.format("show_%s", pass_name)
				discount_content[show_pass_name] = true
				discount_content[pass_name] = string.format("content/ui/materials/frames/premium_store/sale_banner_number_%s", string_digit)
			end

			index = index + 1
		end
	end

	self._widgets_by_name.promo.content.visible = not offer.owned
end

StoreItemDetailView._update_wallets_presentation = function (self, wallets_data)
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
			self._wallet_by_type[wallet_type] = wallet
			local balance = wallet and wallet.balance
			amount = balance and balance.amount or 0
		end

		local text = TextUtils.format_currency(amount)
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

	self:_update_purchase_button(self._selected_offer)
end

StoreItemDetailView._update_purchase_button = function (self, offer)
	local price_widget = self._widgets_by_name.price_text
	local items = self._selected_item_index and {
		self._items[self._selected_item_index]
	} or self._items
	local is_owned, owned_items = self:_is_owned(items)
	local store_offer = self._context.store_item.offer
	local offer_type = offer.description.type

	if offer_type == "bundle" then
		local owned_skus = {}

		for i = 1, #owned_items do
			local owned_item = owned_items[i]
			local sku = owned_item.offer and owned_item.offer.sku and owned_item.offer.sku.id

			if sku then
				owned_skus[#owned_skus + 1] = sku
			end
		end

		self._owned_items = owned_items
		store_offer.owned_skus = not table.is_empty(owned_skus) and owned_skus or nil
	end

	self._widgets_by_name.background.content.force_show_price = self._should_expire
	self._widgets_by_name.purchase_button.content.visible = not is_owned
	self._widgets_by_name.background.content.owned = is_owned
	price_widget.content.visible = not is_owned
	self._widgets_by_name.owned_info_text.content.visible = is_owned

	if not offer.price then
		price_widget.content.visible = false
		self._widgets_by_name.background.content.owned = true
		self._widgets_by_name.purchase_button.content.visible = false

		return
	end

	if not is_owned then
		self:_update_price_presentation(offer)

		local can_afford = self:_can_afford(offer)
		local purchase_button_text = can_afford and Localize("loc_premium_store_purchase_item") or Localize("loc_premium_store_purchase_credits")
		purchase_button_text = Utf8.upper(purchase_button_text)
		self._widgets_by_name.purchase_button.content.text = purchase_button_text
	end
end

StoreItemDetailView._update_wallets = function (self)
	local store_service = Managers.data_service.store
	local promise = store_service:combined_wallets()

	promise:next(function (wallets_data)
		if self._destroyed or not self._wallet_promise then
			return
		end

		self:_update_wallets_presentation(wallets_data)

		self._wallet_promise = nil
	end):catch(function (error)
		self._wallet_promise = nil
	end)

	self._wallet_promise = promise

	return promise
end

StoreItemDetailView._can_afford = function (self, store_item)
	local can_afford = true
	local cost = store_item.price.amount.amount
	local currency = store_item.price.amount.type
	can_afford = cost <= self._current_balance[currency]

	return can_afford
end

StoreItemDetailView.cb_on_purchase_pressed = function (self)
	local offer = self._selected_offer
	local selected_item_index = self._selected_item_index or #self._items == 1 and 1 or nil
	local wallet_type = offer.price.amount.type
	local context = nil
	local can_afford = self:_can_afford(offer)
	local item_name = nil

	if selected_item_index then
		item_name = Localize(self._items[selected_item_index].visual_item.display_name)
	else
		item_name = offer.sku.name
	end

	local item_cost = offer.price.amount.amount
	local current_balance = self._current_balance[wallet_type]
	local new_balance = current_balance - item_cost

	if can_afford then
		self._widgets_by_name.purchase_button.content.visible = false
		self._widgets_by_name.background.content.owned = true
		self._widgets_by_name.background.content.force_show_price = true
		context = {
			title_text = "loc_premium_store_confirm_purchase_title",
			description_text = "loc_premium_store_confirm_purchase_description",
			description_text_params = {
				item_name = item_name,
				item_cost = item_cost,
				current_balance = current_balance,
				new_balance = new_balance
			},
			options = {
				{
					text = "loc_popup_button_confirm",
					close_on_pressed = true,
					callback = callback(function ()
						self._purchase_promise = offer:make_purchase(self._wallet_by_type[wallet_type]):next(function (data)
							if self._destroyed or not self._purchase_promise then
								return
							end

							self._purchase_promise = nil

							self:_play_sound(UISoundEvents.aquilas_vendor_on_purchase)

							local items_not_owned = {}

							if self._owned_items and not table.is_empty(self._owned_items) then
								for i = 1, #self._items do
									local item = self._items[i]
									local found = false

									for j = 1, #self._owned_items do
										local owned_item = self._owned_items[j]

										if owned_item == item then
											found = true

											break
										end
									end

									if found == false then
										items_not_owned[#items_not_owned + 1] = item
									end
								end
							else
								items_not_owned = self._items
							end

							if self._detailed_item and self._selected_item_index then
								local item = self._items[self._selected_item_index].visual_item

								Managers.event:trigger("event_add_notification_message", "item_granted", item)
							elseif #items_not_owned >= 3 then
								local message = Localize("loc_premium_store_notification_success_bundle", true, {
									item = offer.sku.name
								})

								Managers.event:trigger("event_add_notification_message", "default", message)
							else
								for i = 1, #items_not_owned do
									local item = items_not_owned[i]

									if item.skin_set then
										local message = Localize("loc_premium_store_notification_success_set", true, {
											item = item.skin_set.display_name
										})

										Managers.event:trigger("event_add_notification_message", "default", message)
									else
										local visual_item = item.visual_item

										Managers.event:trigger("event_add_notification_message", "item_granted", visual_item)
									end
								end
							end

							self._context.parent:play_vo_events(StoreItemDetailViewSettings.vo_event_vendor_purchase, "purser_a", nil, 1.4)
							Promise.all(self._context.parent:_update_store_page(), self:_update_wallets()):next(function (data)
								if self._detailed_item and self._selected_item_index then
									self:_close_item_details()
								else
									local view_name = self.view_name

									Managers.ui:close_view(view_name)
								end
							end):catch(function (error)
								self:_update_purchase_button(self._selected_offer)

								if self._detailed_item and self._selected_item_index then
									self:_close_item_details()
								else
									local view_name = self.view_name

									Managers.ui:close_view(view_name)
								end
							end)
						end):catch(function (data)
							self._widgets_by_name.purchase_button.content.hotspot.disabled = false
							local notification_string = Localize("loc_premium_store_notification_fail")

							Managers.event:trigger("event_add_notification_message", "alert", {
								text = notification_string
							})

							self._popup_id = nil
							self._purchase_promise = nil

							self:_update_purchase_button(self._selected_offer)
						end)
					end)
				},
				{
					text = "loc_popup_button_cancel",
					template_type = "terminal_button_small",
					close_on_pressed = true,
					hotkey = "back",
					callback = callback(function ()
						self._widgets_by_name.purchase_button.content.hotspot.disabled = false
						self._popup_id = nil

						self:_update_purchase_button(self._selected_offer)
					end)
				}
			}
		}

		Managers.event:trigger("event_show_ui_popup", context, function (id)
			self._popup_id = id
		end)
	else
		self:_hide_elements()
		self:_create_aquilas_presentation()

		self._aquilas_showing = true
	end
end

StoreItemDetailView._create_aquilas_presentation = function (self)
	self:_destroy_aquilas_presentation()

	local scenegraph_id = "grid_aquilas_content"
	local widgets = {}
	local template = ContentBlueprints.aquila_button
	local spacing = {
		20,
		10
	}
	local size = {
		260,
		400
	}
	local pass_template = template.pass_template
	local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
	local offset = 0
	local store_service = Managers.data_service.store
	self._store_promise = store_service:get_premium_store("hard_currency_store"):next(function (data)
		if self._destroyed or not self._store_promise then
			return
		end

		self._store_promise = nil
		local available_aquilas = data.offers
		local platform = nil
		local authenticate_method = Managers.backend:get_auth_method()

		if authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM then
			platform = "steam"
		elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and PLATFORM == "win32" then
			platform = "microsoft"
		elseif authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true then
			platform = "microsoft"
		else
			platform = "steam"
		end

		local cost = self._selected_offer.price.amount.amount
		local currency = self._selected_offer.price.amount.type
		local money_required = cost - self._current_balance[currency]
		local i = 1

		for offerIdx = 1, #available_aquilas do
			local offer = available_aquilas[offerIdx]
			local element = {}

			if offer[platform] then
				local values = offer[platform]

				if values and values.priceCents and values.currency then
					element.formattedPrice = string.format("%.2f %s", values.priceCents / 100, values.currency)
				else
					element.formattedPrice = offer.price.amount.formattedPrice
				end

				element.title = offer.value.amount
				local description = ""
				local bonus_aquila = offer.bonus or UISettings.bonus_aquila_values[offerIdx] or 0

				if bonus_aquila and bonus_aquila > 0 then
					local aquilas = offer.value.amount
					local aquila_minus_bonus = aquilas - bonus_aquila
					description = string.format("%d  \n + %d  bonus", aquila_minus_bonus, bonus_aquila)
				end

				element.description = description
				element.texture_map = string.format("content/ui/textures/icons/offer_cards/premium_currency_%02d", i)
				element.offer = offer
				element.description = description
				element.offer = offer
				local amount = element.offer.value.amount

				if money_required <= amount then
					local name = "currency_widget_" .. i
					local widget = self:_create_widget(name, widget_definition)
					widget.type = "aquila_button"
					widget.offset = {
						offset,
						0,
						0
					}
					offset = offset + size[1] + spacing[1]
					local init = template.init

					if init then
						init(self, widget, element, "cb_on_aquila_pressed")
					end

					widgets[#widgets + 1] = widget
					i = i + 1
				end
			end
		end

		local total_width = offset - spacing[1]

		self:_set_scenegraph_size(scenegraph_id, total_width, size[2])

		self._aquilas_widgets = widgets

		if not self._using_cursor_navigation then
			self._selected_aquila_index = 1

			self:_select_aquila_widget_by_index(self._selected_aquila_index)
		end

		self._widgets_by_name.aquilas_required.content.visible = true
		local item_name = nil

		if self._detailed_item or #self._items == 1 then
			local selected_item_index = self._selected_item_index or 1
			item_name = Localize(self._items[selected_item_index].visual_item.display_name)
		else
			item_name = self._context.store_item.offer.sku.name
		end

		self._widgets_by_name.aquilas_required.content.price = string.format("%s ", Localize("loc_premium_store_required_credits", true, {
			offer = item_name,
			value = money_required
		}))
	end):catch(function (error)
		self._store_promise = nil
	end)
end

StoreItemDetailView.cb_on_aquila_pressed = function (self, widget, element)
	self._purchase_promise = element.offer:make_purchase():next(function (data)
		if self._destroyed or not self._purchase_promise then
			return
		end

		self._purchase_promise = nil

		if data and data.body.state == "failed" then
			return
		end

		local currency = element.offer.value.type
		local amount = element.offer.value.amount

		self:_play_sound(UISoundEvents.aquilas_vendor_purchase_aquilas)
		Managers.event:trigger("event_add_notification_message", "currency", {
			currency = currency,
			amount = amount
		})
		self:cb_on_close_pressed()
	end):catch(function (error)
		local notification_string = Localize("loc_premium_store_notification_fail")

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = notification_string
		})

		self._purchase_promise = nil
	end)
end

StoreItemDetailView._destroy_aquilas_presentation = function (self)
	if self._aquilas_widgets then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
		end

		self._aquilas_widgets = nil
	end

	self._widgets_by_name.aquilas_required.content.visible = false
end

StoreItemDetailView._select_aquila_widget_by_index = function (self, index)
	if not self._aquilas_widgets then
		return
	end

	for i = 1, #self._aquilas_widgets do
		local widget = self._aquilas_widgets[i]
		widget.content.hotspot.is_focused = i == index
	end
end

return StoreItemDetailView
