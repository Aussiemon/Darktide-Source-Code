-- chunkname: @scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view.lua

require("scripts/ui/views/item_grid_view_base/item_grid_view_base")

local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local Definitions = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_definitions")
local InventoryCosmeticsViewSettings = require("scripts/ui/views/inventory_cosmetics_view/inventory_cosmetics_view_settings")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local Personalities = require("scripts/settings/character/personalities")
local ProfileUtils = require("scripts/utilities/profile_utils")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local VoiceFxPresetSettings = require("scripts/settings/dialogue/voice_fx_preset_settings")
local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
local WIDGET_TYPE_BY_SLOT = {
	slot_animation_emote_1 = "ui_item",
	slot_animation_emote_2 = "ui_item",
	slot_animation_emote_3 = "ui_item",
	slot_animation_emote_4 = "ui_item",
	slot_animation_emote_5 = "ui_item",
	slot_animation_end_of_round = "gear_item",
	slot_character_title = "character_title_item",
	slot_gear_extra_cosmetic = "gear_item",
	slot_gear_head = "gear_item",
	slot_gear_lowerbody = "gear_item",
	slot_gear_upperbody = "gear_item",
	slot_insignia = "ui_item",
	slot_portrait_frame = "ui_item",
}
local PENANCE_TRACK_ID = "dec942ce-b6ba-439c-95e2-022c5d71394d"
local InventoryCosmeticsView = class("InventoryCosmeticsView", "ItemGridViewBase")

InventoryCosmeticsView.init = function (self, settings, context)
	self._preview_profile_equipped_items = context.preview_profile_equipped_items
	self._current_profile_equipped_items = context.current_profile_equipped_items or {}
	self._is_readonly = context and context.is_readonly
	self._sort_options = {}
	self._debug = context.debug
	self._hide_item_source_in_tooltip = true
	self._promise_container = PromiseContainer:new()
	context.preview_player = context.player or Managers.player:local_player(1)
	context.preview_loadout = self._preview_profile_equipped_items or context.preview_player.loadout
	context.character_id = "cosmetics_view_preview_character"

	InventoryCosmeticsView.super.init(self, Definitions, settings, context)

	if not self._debug then
		self._selected_slot = context.selected_slot
		self._initial_rotation = context.initial_rotation
		self._disable_rotation_input = context.disable_rotation_input
		self._animation_event_name_suffix = context.animation_event_name_suffix
		self._animation_event_variable_data = context.animation_event_variable_data
		self.item_type = context.item_type

		local is_gear = not not string.find(self._selected_slot.name, "slot_gear")

		self._camera_zoomed_in = true
		self._initialize_zoom = is_gear
	else
		self._selected_slot = {
			name = "slot_gear_upperbody",
		}
		self._initial_rotation = 0
	end

	self._zoom_level = 1
	self._zoom_speed = 0
	self._pass_input = false
	self._pass_draw = false
	self._parent = context and context.parent
	self._telemetry_id = table.nested_get(self, "_selected_slot", "name")
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

InventoryCosmeticsView._load_layout = function (self, selected_slot)
	self._inventory_items = {}

	self:_stop_previewing()
	self:set_loading_state(true)

	self._refresh_in_seconds = nil

	self._promise_container:cancel_on_destroy(self:_fetch_inventory_items(selected_slot)):next(function ()
		self:set_loading_state(false)

		local selected_slot_name = selected_slot.name
		local spawn_player = selected_slot_name ~= "slot_insignia" and selected_slot_name ~= "slot_portrait_frame"

		self._spawn_player = spawn_player

		local has_rarity, has_locked = false, false
		local cosmetics_layout = self._cosmetic_layout

		for i = 1, #cosmetics_layout do
			local layout = cosmetics_layout[i]

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

		local sort_options = {}

		self._sort_options = sort_options

		if has_rarity then
			sort_options[#sort_options + 1] = {
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
			sort_options[#sort_options + 1] = {
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

		sort_options[#sort_options + 1] = {
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
		sort_options[#sort_options + 1] = {
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

		self:_setup_sort_options()
		self:_start_show_layout()
	end):catch(function ()
		self:set_loading_state(false)
	end)
end

InventoryCosmeticsView.event_force_refresh_inventory = function (self)
	self._force_refresh = true
end

InventoryCosmeticsView.on_enter = function (self)
	InventoryCosmeticsView.super.on_enter(self)

	local selected_slot = self._selected_slot

	if selected_slot then
		self:_load_layout(selected_slot)
	end

	self:_register_button_callbacks()
	self:_setup_input_legend()
	self:_register_event("event_force_refresh_inventory", "event_force_refresh_inventory")
	self:_setup_background_world()
end

InventoryCosmeticsView._setup_input_legend = function (self)
	self._input_legend_element = self:_add_element(ViewElementInputLegend, "input_legend", 10)

	local legend_inputs = self._definitions.legend_inputs

	for i = 1, #legend_inputs do
		local legend_input = legend_inputs[i]
		local on_pressed_callback = legend_input.on_pressed_callback and callback(self, legend_input.on_pressed_callback)

		self._input_legend_element:add_entry(legend_input.display_name, legend_input.input_action, legend_input.visibility_function, on_pressed_callback, legend_input.alignment)
	end
end

InventoryCosmeticsView._set_preview_widgets_visibility = function (self, visible, allow_equip_button)
	InventoryCosmeticsView.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.equip_button.content.visible = allow_equip_button or visible
end

InventoryCosmeticsView._stop_previewing = function (self)
	InventoryCosmeticsView.super._stop_previewing(self)
	self:_destroy_side_panel()

	if self._item_name_widget then
		self:_unregister_widget_name(self._item_name_widget.name)

		self._item_name_widget = nil
	end

	if self._player_panel then
		self:_remove_element("player_panel")

		self._player_panel = nil
	end

	if self._spawned_prop_item_slot then
		local presentation_profile = self._presentation_profile
		local presentation_loadout = presentation_profile.loadout

		presentation_loadout[self._spawned_prop_item_slot] = nil
		self._spawned_prop_item_slot = nil
	end
end

InventoryCosmeticsView._spawn_profile = function (self, profile, initial_rotation, disable_rotation_input)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()

	self._profile_spawner = UIProfileSpawner:new("InventoryCosmeticsView", world, camera, unit_spawner)

	if disable_rotation_input then
		self._profile_spawner:disable_rotation_input()
	end

	local camera_position = ScriptCamera.position(camera)
	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	if initial_rotation then
		local character_initial_rotation = Quaternion.axis_angle(Vector3(0, 0, 1), initial_rotation)

		spawn_rotation = Quaternion.multiply(character_initial_rotation, spawn_rotation)
	end

	camera_position.z = 0

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	self._spawned_profile = profile
end

local ANIMATION_SLOTS_MAP = {
	slot_animation_emote_1 = true,
	slot_animation_emote_2 = true,
	slot_animation_emote_3 = true,
	slot_animation_emote_4 = true,
	slot_animation_emote_5 = true,
	slot_animation_end_of_round = true,
}

InventoryCosmeticsView._destroy_side_panel = function (self)
	local side_panel_widgets = self._side_panel_widgets
	local side_panel_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_count do
		local widget = side_panel_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._side_panel_widgets = nil
end

InventoryCosmeticsView._setup_side_panel = function (self, item, is_locked, dx, dy)
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

InventoryCosmeticsView._preview_element = function (self, element)
	self:_stop_previewing()

	local item = element.item
	local item_display_name = item and item.display_name or ""

	if string.match(item_display_name, "unarmed") then
		return
	end

	self._previewed_item = item
	self._previewed_element = element

	if not item then
		return
	end

	self._last_seen_item_name = item.name

	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot and selected_slot.name
	local presentation_profile = self._presentation_profile
	local presentation_loadout = presentation_profile.loadout

	presentation_loadout[selected_slot_name] = item

	local animation_slot = ANIMATION_SLOTS_MAP[selected_slot_name]

	if animation_slot then
		local item_state_machine = item.state_machine
		local item_animation_event = item.animation_event
		local item_face_animation_event = item.face_animation_event
		local animation_event_name_suffix = self._animation_event_name_suffix
		local animation_event = item_animation_event

		if animation_event_name_suffix then
			animation_event = animation_event .. animation_event_name_suffix
		end

		self._profile_spawner:assign_state_machine(item_state_machine, animation_event, item_face_animation_event)

		local animation_event_variable_data = self._animation_event_variable_data

		if animation_event_variable_data then
			local index = animation_event_variable_data.index
			local value = animation_event_variable_data.value

			self._profile_spawner:assign_animation_variable(index, value)
		end

		local prop_item_key = item.prop_item
		local prop_item = prop_item_key and prop_item_key ~= "" and MasterItems.get_item(prop_item_key)

		if prop_item then
			local prop_item_slot = prop_item.slots[1]

			presentation_loadout[prop_item_slot] = prop_item

			self._profile_spawner:wield_slot(prop_item_slot)

			self._spawned_prop_item_slot = prop_item_slot
		end
	end

	if selected_slot_name == "slot_portrait_frame" or selected_slot_name == "slot_insignia" then
		InventoryCosmeticsView.super._preview_element(self, element)
	end

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
	local should_display_button = self:_update_equip_button_status() ~= "disabled"

	self:_set_preview_widgets_visibility(false, should_display_button)

	local y_offset = not should_display_button and 80 or 0

	widget.offset[2] = widget.offset[2] + y_offset

	self:_setup_side_panel(item, is_locked, 0, y_offset)
end

InventoryCosmeticsView._update_player_panel_position = function (self)
	if not self._player_panel then
		return
	end

	local position = self:_scenegraph_world_position("player_panel_pivot")

	self._player_panel:set_pivot_offset(position[1], position[2])
end

InventoryCosmeticsView._register_button_callbacks = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.equip_button.content.hotspot.pressed_callback = callback(self, "cb_on_equip_pressed")
end

InventoryCosmeticsView._trigger_zoom_logic = function (self, optional_slot_name, optional_time)
	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name
	local func_ptr = math.easeCubic

	self:_set_camera_item_slot_focus(selected_slot_name, optional_time or 0, func_ptr, self._zoom_level)
end

local function _filter_locked_elements(element)
	return not element.locked or element.widget_type == "divider"
end

InventoryCosmeticsView._filtered_layout = function (self)
	local filtered_layout = self._cosmetic_layout

	if self._show_locked_cosmetics == false then
		filtered_layout = table.filtered_array(filtered_layout, _filter_locked_elements)
	end

	return filtered_layout
end

InventoryCosmeticsView._requested_index_on_present = function (self)
	local requested_index
	local last_seen_item_name = self._last_seen_item_name

	if not requested_index and last_seen_item_name then
		requested_index = self:index_by_item_name(last_seen_item_name)
	end

	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name
	local equipped_item = self:equipped_item_in_slot(selected_slot_name)

	if not requested_index and equipped_item then
		requested_index = self:item_grid_index(equipped_item)
	end

	return requested_index
end

InventoryCosmeticsView._start_show_layout = function (self)
	self._offer_items_layout = self:_filtered_layout()

	local selected_slot = self._selected_slot
	local slot_display_name = selected_slot and selected_slot.display_name

	self:_present_layout_by_slot_filter(nil, nil, slot_display_name)
end

InventoryCosmeticsView.cb_on_equip_pressed = function (self)
	local selected_slot = self._selected_slot

	if not selected_slot then
		return
	end

	local previewed_item = self._previewed_item

	if not previewed_item then
		return
	end

	local current_status = self._equip_button_status

	if current_status == "equip" then
		local selected_slot_name = selected_slot.name

		self:_equip_item(selected_slot_name, previewed_item)
	elseif current_status == "purchase" then
		self:cb_on_purchase_pressed()
	end
end

InventoryCosmeticsView.on_exit = function (self)
	if self._world_spawner then
		self._world_spawner:set_camera_blur(0, 0)
	end

	self._promise_container:delete()

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	self:_play_sound(UISoundEvents.default_menu_exit)
	self:_destroy_side_panel()
	InventoryCosmeticsView.super.on_exit(self)
end

InventoryCosmeticsView._verify_items = function (self, source_items, owned_gear)
	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name
	local verified_items = {}
	local owned_gear_by_master_id = {}

	if owned_gear then
		for gear_id, item in pairs(owned_gear) do
			local item_name = item.name

			owned_gear_by_master_id[item_name] = item
		end
	end

	for item_name, item in pairs(source_items) do
		local slots = item.slots

		if slots then
			for i = 1, #slots do
				local slot_name = slots[i]

				if selected_slot_name == slot_name then
					if owned_gear_by_master_id[item_name] then
						verified_items[item_name] = owned_gear_by_master_id[item_name]

						break
					end

					if item.always_owned then
						verified_items[item_name] = item
					end

					break
				end
			end
		end
	end

	return verified_items
end

InventoryCosmeticsView._parse_store_items = function (self, selected_slot_name, offers, items)
	for i = 1, #offers do
		local offer = offers[i]
		local id = offer.description and offer.description.id

		if id and id ~= "n/a" then
			local item = MasterItems.get_item(id)

			if item and self:_item_valid_by_current_profile(item) and table.find(item.slots, selected_slot_name) then
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

InventoryCosmeticsView._fetch_inventory_items = function (self, selected_slot)
	local local_player_id = 1
	local player = Managers.player:local_player(local_player_id)
	local character_id = player:character_id()

	if self._debug then
		self._cosmetic_layout = {}

		return Promise.resolved()
	end

	local selected_slot_name = selected_slot.name
	local filter = {
		selected_slot_name,
	}
	local promises = {}

	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.gear:fetch_inventory(character_id, filter)):next(function (items)
		local item_definitions = MasterItems.get_cached()

		items = self:_verify_items(item_definitions, items)

		local items_array = {}

		for gear_id, item in pairs(items) do
			items_array[#items_array + 1] = item
		end

		self._inventory_items = items_array

		local valid_items = {}

		for i = 1, #items_array do
			local item = items_array[i]

			if self:_item_valid_by_current_profile(item) then
				local slots = item.slots

				if slots then
					local valid = true

					if valid then
						valid_items[#valid_items + 1] = item
					end
				end
			end
		end

		return valid_items
	end)
	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.store:get_credits_cosmetics_store()):next(function (data)
		local offers = data.offers

		return self:_parse_store_items(selected_slot_name, offers, {})
	end)
	promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.penance_track:get_track(PENANCE_TRACK_ID)):next(function (data)
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

							if reward_item and self:_item_valid_by_current_profile(reward_item) and table.find(reward_item.slots, selected_slot_name) then
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

		return penance_track_items
	end)

	local has_premium_store = Managers.data_service.store:has_character_premium_store()

	if has_premium_store then
		promises[#promises + 1] = self._promise_container:cancel_on_destroy(Managers.data_service.store:get_character_premium_store()):next(function (data)
			local offers = data.offers
			local catalog_validity = data.catalog_validity
			local valid_to = catalog_validity and catalog_validity.valid_to

			self._premium_rotation_ends_at = valid_to

			return self:_parse_store_items(selected_slot_name, offers, {})
		end)
	else
		promises[#promises + 1] = Promise.resolved({})
	end

	return self._promise_container:cancel_on_destroy(Promise.all(unpack(promises))):next(function (data)
		self._cosmetic_layout = self:_prepare_cosmetic_layout_data(data)
	end):catch(function (data)
		self._refresh_in_seconds = 5
		self._cosmetic_layout = self:_prepare_cosmetic_layout_data(data)
	end)
end

InventoryCosmeticsView._achievement_items = function (self, selected_slot_name)
	local achievement_items = {}
	local achievements = Managers.achievements:achievement_definitions()

	for _, achievement in pairs(achievements) do
		local reward_items = AchievementUIHelper.get_all_reward_items(achievement)

		for i = 1, #reward_items do
			local reward_item = reward_items[i].reward_item

			if reward_item and reward_item.slots and self:_item_valid_by_current_profile(reward_item) and table.find(reward_item.slots, selected_slot_name) then
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

	for i = 1, #entry_array do
		local entry = entry_array[i]
		local item = is_item and entry or entry.item
		local name = item.name

		if name then
			_items_by_name[name] = entry
		end
	end

	return _items_by_name
end

InventoryCosmeticsView._prepare_cosmetic_layout_data = function (self, result)
	local inventory_items, store_items, penance_track_items, premium_items = unpack(result)
	local layout_count, layout = 0, {}
	local selected_slot = self._selected_slot
	local selected_slot_name = selected_slot.name
	local achievement_items = self:_achievement_items(selected_slot_name)
	local player = self._preview_player
	local profile = player:profile()
	local remove_new_marker_callback = self._parent and callback(self._parent, "remove_new_item_mark")
	local locked_achievement_items_by_name = items_by_name(achievement_items, false)
	local locked_store_items_by_name = items_by_name(store_items, false)
	local locked_penance_track_items_by_name = items_by_name(penance_track_items, false)
	local locked_premium_items_by_name = items_by_name(premium_items, false)

	for i = 1, #inventory_items do
		local inventory_item = inventory_items[i]
		local item_name = inventory_item.name
		local found_achievement = locked_achievement_items_by_name[item_name]

		locked_achievement_items_by_name[item_name] = nil

		local found_penance_track = locked_penance_track_items_by_name[item_name]

		locked_penance_track_items_by_name[item_name] = nil

		local found_store = locked_store_items_by_name[item_name]

		locked_store_items_by_name[item_name] = nil
		locked_premium_items_by_name[item_name] = nil

		local gear_id = inventory_item.gear_id
		local is_new = self._context and self._context.new_items_gear_ids and self._context.new_items_gear_ids[gear_id]

		layout_count = layout_count + 1
		layout[layout_count] = {
			sort_group = 1,
			item = inventory_item,
			slot = selected_slot,
			widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name],
			achievement = found_achievement,
			penance_track = found_penance_track,
			store = found_store,
			new_item_marker = is_new,
			remove_new_marker_callback = remove_new_marker_callback,
			profile = profile,
		}
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
		layout_count = layout_count + 1
		layout[layout_count] = {
			locked = true,
			sort_group = 5,
			item = achievement_item.item,
			slot = selected_slot,
			widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name],
			achievement = achievement_item,
		}
	end

	for _, penance_track_item in pairs(locked_penance_track_items_by_name) do
		layout_count = layout_count + 1
		layout[layout_count] = {
			locked = true,
			sort_group = 5,
			item = penance_track_item.item,
			slot = selected_slot,
			widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name],
			penance_track = penance_track_item,
		}
	end

	for _, store_item in pairs(locked_store_items_by_name) do
		layout_count = layout_count + 1
		layout[layout_count] = {
			locked = true,
			sort_group = 5,
			item = store_item.item,
			slot = selected_slot,
			widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name],
			store = store_item.item,
		}
	end

	local has_locked_premium_item = next(locked_premium_items_by_name) ~= nil

	if has_locked_premium_item then
		layout_count = layout_count + 1
		layout[layout_count] = {
			sort_group = 2,
			widget_type = "divider",
		}
	end

	for _, premium_item in pairs(locked_premium_items_by_name) do
		layout_count = layout_count + 1
		layout[layout_count] = {
			locked = true,
			sort_group = 3,
			item = premium_item.item,
			slot = selected_slot,
			widget_type = WIDGET_TYPE_BY_SLOT[selected_slot_name],
			store = premium_item.item,
			premium_offer = premium_item.offer,
		}
	end

	return layout
end

InventoryCosmeticsView._calc_text_size = function (self, widget, text_and_style_id)
	local text = widget.content[text_and_style_id]
	local text_style = widget.style[text_and_style_id]
	local text_options = UIFonts.get_font_options_by_style(text_style)
	local size = text_style.size or widget.content.size or {
		self:_scenegraph_size(widget.scenegraph_id),
	}

	return UIRenderer.text_size(self._ui_renderer, text, text_style.font_type, text_style.font_size, size, text_options)
end

InventoryCosmeticsView.is_item_owned = function (self, target_gear_id)
	local inventory_items = self._inventory_items

	for _, item in ipairs(inventory_items) do
		local gear_id = item.gear_id

		if gear_id == target_gear_id then
			return true
		end
	end

	return false
end

InventoryCosmeticsView._get_item_from_inventory = function (self, wanted_item)
	local inventory_items = self._inventory_items
	local wanted_item_gear_id = wanted_item.gear_id
	local wanted_item_name = wanted_item.name

	for _, item in ipairs(inventory_items) do
		local gear_id = item.gear_id
		local item_name = item.name

		if wanted_item_gear_id then
			if gear_id and gear_id == wanted_item_gear_id then
				return item
			end
		elseif wanted_item_name and wanted_item_name == item_name then
			return item
		end
	end

	return wanted_item
end

InventoryCosmeticsView._item_valid_by_current_profile = function (self, item)
	local player = self._preview_player
	local profile = player:profile()
	local archetype = profile.archetype
	local lore = profile.lore
	local backstory = lore.backstory
	local crime = backstory.crime
	local archetype_name = archetype.name
	local breed_name = archetype.breed
	local breed_valid = not item.breeds or table.contains(item.breeds, breed_name)
	local crime_valid = not item.crimes or table.contains(item.crimes, crime)
	local no_crimes = item.crimes == nil or table.is_empty(item.crimes)
	local archetype_valid = not item.archetypes or table.contains(item.archetypes, archetype_name)

	if archetype_valid and breed_valid and (no_crimes or crime_valid) then
		return true
	end

	return false
end

InventoryCosmeticsView._on_double_click = function (self, widget, element)
	return self:cb_on_equip_pressed()
end

InventoryCosmeticsView._equip_item = function (self, slot_name, item)
	if self._equip_button_status ~= "equip" then
		return
	end

	local equipped_slot_item = self:equipped_item_in_slot(slot_name)

	if not equipped_slot_item or equipped_slot_item.gear_id ~= item.gear_id then
		self._has_equipped_item = true

		if item then
			local item_type = item.item_type
			local ITEM_TYPES = UISettings.ITEM_TYPES

			if item_type == ITEM_TYPES.GEAR_LOWERBODY or item_type == ITEM_TYPES.GEAR_UPPERBODY then
				self:_play_sound(UISoundEvents.apparel_equip)
			elseif item_type == ITEM_TYPES.GEAR_HEAD or item_type == ITEM_TYPES.EMOTE or item_type == ITEM_TYPES.END_OF_ROUND or item_type == ITEM_TYPES.GEAR_EXTRA_COSMETIC then
				self:_play_sound(UISoundEvents.apparel_equip_small)
			elseif item_type == ITEM_TYPES.PORTRAIT_FRAME or item_type == ITEM_TYPES.CHARACTER_INSIGNIA then
				self:_play_sound(UISoundEvents.apparel_equip_frame)
			elseif item_type == ITEM_TYPES.CHARACTER_TITLE then
				self:_play_sound(UISoundEvents.title_equip)
			else
				self:_play_sound(UISoundEvents.apparel_equip)
			end
		end

		local item_gear_id = item and item.gear_id
		local active_profile_preset_id = ProfileUtils.get_active_profile_preset_id()

		if active_profile_preset_id then
			ProfileUtils.save_item_id_for_profile_preset(active_profile_preset_id, slot_name, item_gear_id)
		end

		Managers.telemetry_events:equip_item(slot_name, item)
		Managers.event:trigger("event_inventory_view_equip_item", slot_name, item)
	end
end

InventoryCosmeticsView.equipped_item_in_slot = function (self, slot_name)
	local current_loadout = self._current_profile_equipped_items
	local slot_item = current_loadout[slot_name]
	local item = slot_item and self:_get_item_from_inventory(slot_item)

	return item
end

InventoryCosmeticsView._clear_widgets = function (self, widgets)
	if widgets then
		for i = 1, #widgets do
			local widget = widgets[i]
			local widget_name = widget.name

			if self:has_widget(widget_name) then
				self:_unregister_widget_name(widget_name)
			end
		end

		table.clear(widgets)
	end
end

InventoryCosmeticsView._handle_input = function (self, input_service)
	if input_service:get("confirm_pressed") then
		self:cb_on_equip_pressed()
	end
end

InventoryCosmeticsView._handle_back_pressed = function (self)
	local view_name = "inventory_cosmetics_view"

	Managers.ui:close_view(view_name)
end

InventoryCosmeticsView._update_equip_button_status = function (self)
	local previewed_item = self._previewed_item
	local previewed_element = self._previewed_element
	local is_disabled = not previewed_item
	local is_locked = previewed_element and not not previewed_element.locked
	local is_premium = previewed_element and previewed_element.premium_offer ~= nil
	local is_equipped = false

	if not is_disabled then
		local selected_slot = self._selected_slot
		local selected_slot_name = selected_slot and selected_slot.name
		local equipped_item = selected_slot_name and self:equipped_item_in_slot(selected_slot_name)

		is_equipped = equipped_item and equipped_item.gear_id == previewed_item.gear_id
	end

	local target_status

	target_status = is_equipped and "equipped" or is_premium and "purchase" or (is_disabled or is_locked) and "disabled" or "equip"

	local current_equip_button_status = self._equip_button_status

	if target_status ~= current_equip_button_status then
		local button = self._widgets_by_name.equip_button
		local button_content = button.content

		button_content.hotspot.disabled = target_status == "disabled" or target_status == "equipped"
		button_content.visible = target_status ~= "disabled"

		local loc_key = target_status == "equipped" and "loc_weapon_inventory_equipped_button" or target_status == "purchase" and "loc_premium_store_purchase_item" or "loc_weapon_inventory_equip_button"

		button_content.original_text = Utf8.upper(Localize(loc_key))
		self._equip_button_status = target_status
	end

	return target_status
end

InventoryCosmeticsView.cb_on_close_pressed = function (self)
	self:_handle_back_pressed()
end

InventoryCosmeticsView.profile_preset_handling_input = function (self)
	local view_name = "inventory_background_view"
	local ui_manager = Managers.ui

	if ui_manager:view_active(view_name) then
		local view_instance = ui_manager:view_instance(view_name)

		return view_instance:profile_preset_handling_input()
	end
end

InventoryCosmeticsView.draw = function (self, dt, t, input_service, layer)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	if self._filter_triggered then
		self._item_grid:disable_input(false)
	end

	local ui_scenegraph = self._ui_scenegraph
	local ui_renderer = self._ui_default_renderer
	local render_settings = self._render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)

	local item_name_widget = self._item_name_widget

	if item_name_widget then
		UIWidget.draw(item_name_widget, ui_renderer)
	end

	local side_panel_widgets = self._side_panel_widgets
	local side_panel_widget_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_widget_count do
		local widget = side_panel_widgets[i]

		UIWidget.draw(widget, ui_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
	InventoryCosmeticsView.super.draw(self, dt, t, input_service, layer)
end

InventoryCosmeticsView._update_zoom_logic = function (self, dt, input_service)
	local scroll_axis = input_service:get("scroll_axis")
	local scroll_delta = scroll_axis and scroll_axis[2] or 0
	local item_grid_hovered = self._item_grid and self._item_grid:hovered()

	if item_grid_hovered then
		scroll_delta = 0
	end

	local zoom_speed, zoom_level = self._zoom_speed, self._zoom_level

	zoom_speed = scroll_delta * zoom_speed < 0 and 0 or zoom_speed + scroll_delta / 20

	if math.abs(zoom_speed) < 0.01 then
		zoom_speed = 0
	end

	zoom_level = math.clamp(zoom_level + zoom_speed * 18 * dt, 0, 1)
	zoom_speed = zoom_speed * math.pow(0.006, dt)

	if zoom_level == 0 or zoom_level == 1 then
		zoom_speed = 0
	end

	local has_changed = zoom_level ~= self._zoom_level

	self._zoom_level, self._zoom_speed = zoom_level, zoom_speed

	if has_changed then
		self:_trigger_zoom_logic()
	end
end

InventoryCosmeticsView._should_refresh = function (self, dt, t)
	local is_loading = self:get_loading_state()

	if is_loading then
		return false
	end

	local server_time = Managers.backend:get_server_time(t)
	local premium_rotation_ends_at = self._premium_rotation_ends_at

	if premium_rotation_ends_at and premium_rotation_ends_at < server_time then
		return true
	end

	if self._force_refresh then
		self._force_refresh = false

		return true
	end

	local refresh_in_seconds = self._refresh_in_seconds

	refresh_in_seconds = refresh_in_seconds and math.max(refresh_in_seconds - dt, 0)
	self._refresh_in_seconds = refresh_in_seconds

	if refresh_in_seconds and refresh_in_seconds == 0 then
		return true
	end

	return false
end

InventoryCosmeticsView.update = function (self, dt, t, input_service)
	if self:profile_preset_handling_input() then
		input_service = input_service:null_service()
	end

	if self:_should_refresh(dt, t) then
		local selected_slot = self._selected_slot

		self:_load_layout(selected_slot)
	end

	if self._spawn_player then
		if not self._player_spawned and self._spawn_point_unit and self._default_camera_unit then
			local profile = self._presentation_profile
			local initial_rotation = self._initial_rotation
			local disable_rotation_input = self._disable_rotation_input

			self:_spawn_profile(profile, initial_rotation, disable_rotation_input)

			self._player_spawned = true
			self._spawn_player = false

			local selected_slot = self._selected_slot
			local selected_slot_name = selected_slot and selected_slot.name

			self:_trigger_zoom_logic(selected_slot_name)
		end

		if self._player_spawned and not self._initialize_zoom then
			self._initialize_zoom = false
		end
	end

	self:_update_vo(dt, t)
	self:_update_zoom_logic(dt, input_service)
	self:_update_equip_button_status()

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return InventoryCosmeticsView.super.update(self, dt, t, input_service)
end

InventoryCosmeticsView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

InventoryCosmeticsView.on_resolution_modified = function (self, scale)
	InventoryCosmeticsView.super.on_resolution_modified(self, scale)
end

InventoryCosmeticsView._setup_background_world = function (self)
	local player = self._preview_player
	local player_profile = player:profile()
	local archetype = player_profile.archetype
	local breed_name = archetype.breed
	local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

	self[default_camera_event_id] = function (instance, camera_unit)
		if instance._context then
			instance._context.camera_unit = camera_unit
		end

		instance._default_camera_unit = camera_unit

		local viewport_name = InventoryCosmeticsViewSettings.viewport_name
		local viewport_type = InventoryCosmeticsViewSettings.viewport_type
		local viewport_layer = InventoryCosmeticsViewSettings.viewport_layer
		local shading_environment = InventoryCosmeticsViewSettings.shading_environment

		instance._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
		instance:_unregister_event(default_camera_event_id)
	end

	self:_register_event(default_camera_event_id)

	self._item_camera_by_slot_id = {}

	for slot_name, slot in pairs(ItemSlotSettings) do
		if slot.slot_type == "gear" then
			local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

			self[item_camera_event_id] = function (instance, camera_unit)
				instance._item_camera_by_slot_id[slot_name] = camera_unit

				instance:_unregister_event(item_camera_event_id)
			end

			self:_register_event(item_camera_event_id)
		end
	end

	self:_register_event("event_register_cosmetics_preview_character_spawn_point")

	local world_name = InventoryCosmeticsViewSettings.world_name
	local world_layer = InventoryCosmeticsViewSettings.world_layer
	local world_timer_name = InventoryCosmeticsViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = InventoryCosmeticsViewSettings.level_name

	self._world_spawner:spawn_level(level_name)
end

InventoryCosmeticsView.world_spawner = function (self)
	return self._world_spawner
end

InventoryCosmeticsView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

InventoryCosmeticsView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

InventoryCosmeticsView._set_camera_item_slot_focus = function (self, slot_name, time, func_ptr, zoom_level)
	local world_spawner = self._world_spawner
	local slot_camera = self._item_camera_by_slot_id[slot_name] or self._default_camera_unit

	world_spawner:interpolate_to_camera(slot_camera, zoom_level, time, func_ptr)
end

InventoryCosmeticsView._can_preview_voice = function (self)
	local voice_fx_key = table.nested_get(self, "_previewed_item", "voice_fx_preset")
	local has_voice_fx = voice_fx_key and voice_fx_key ~= "voice_fx_rtpc_none"

	return has_voice_fx
end

InventoryCosmeticsView._stop_current_voice = function (self)
	local ui_world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(ui_world)

	if not wwise_world then
		return
	end

	local current_event = self._sound_event_id

	if not current_event then
		return
	end

	if not WwiseWorld.is_playing(wwise_world, current_event) then
		return
	end

	WwiseWorld.stop_event(wwise_world, current_event)

	self._sound_event_id = nil
end

InventoryCosmeticsView.cb_preview_voice = function (self)
	local voice_fx_preset_key = table.nested_get(self, "_previewed_item", "voice_fx_preset")
	local voice_fx_preset_rtcp = VoiceFxPresetSettings[voice_fx_preset_key]

	if not voice_fx_preset_key then
		return
	end

	local personality_key = table.nested_get(self, "_preview_player", "_profile", "lore", "backstory", "personality")
	local personality_settings = Personalities[personality_key]
	local sound_event = personality_settings and personality_settings.preview_sound_event

	if not sound_event then
		return
	end

	local ui_world = Managers.ui:world()
	local wwise_world = Managers.world:wwise_world(ui_world)

	if not wwise_world then
		return
	end

	self:_stop_current_voice()

	local source = WwiseWorld.make_auto_source(wwise_world, Vector3.zero())

	WwiseWorld.set_source_parameter(wwise_world, source, "voice_fx_preset", voice_fx_preset_rtcp)

	self._sound_event_id = WwiseWorld.trigger_resource_event(wwise_world, sound_event, source)
end

InventoryCosmeticsView.cb_on_camera_zoom_toggled = function (self)
	self._zoom_level = self._zoom_level > 0.5 and 0 or 1
	self._zoom_speed = 0

	self:_trigger_zoom_logic(nil, 0.5)
end

InventoryCosmeticsView.cb_on_purchase_pressed = function (self)
	local element = self._previewed_element
	local premium_offer = element and element.premium_offer

	if not premium_offer then
		return
	end

	Managers.ui:open_view("store_item_detail_view", nil, nil, nil, nil, {
		store_item = {
			offer = premium_offer,
		},
		parent = self,
	})
end

InventoryCosmeticsView._update_vo = function (self, dt, t)
	if self._hub_interaction then
		local queued_vo_event_request = self._queued_vo_event_request

		if queued_vo_event_request then
			local delay = queued_vo_event_request.delay

			if delay <= 0 then
				local events = queued_vo_event_request.events
				local voice_profile = queued_vo_event_request.voice_profile
				local optional_route_key = queued_vo_event_request.optional_route_key
				local is_opinion_vo = queued_vo_event_request.is_opinion_vo
				local world_spawner = self._world_spawner
				local dialogue_system = world_spawner and self:dialogue_system()

				if dialogue_system then
					self:play_vo_events(events, voice_profile, optional_route_key, nil, is_opinion_vo)

					self._queued_vo_event_request = nil
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
		local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
		local is_playing = dialogue_extension:is_playing(current_vo_id)

		if not is_playing then
			self._current_vo_id = nil
			self._current_vo_event = nil
		end
	end
end

InventoryCosmeticsView.dialogue_system = function (self)
	local world_spawner = self._world_spawner
	local world = world_spawner and world_spawner:world()
	local extension_manager = world and Managers.ui:world_extension_manager(world)
	local dialogue_system = extension_manager and extension_manager:system_by_extension("DialogueExtension")

	return dialogue_system
end

InventoryCosmeticsView._cb_on_play_vo = function (self, id, event_name)
	self._current_vo_event = event_name
	self._current_vo_id = id
end

InventoryCosmeticsView.play_vo_events = function (self, events, voice_profile, optional_route_key, optional_delay, is_opinion_vo)
	local dialogue_system = self:dialogue_system()

	if optional_delay then
		self._queued_vo_event_request = {
			events = events,
			voice_profile = voice_profile,
			optional_route_key = optional_route_key,
			delay = optional_delay,
			is_opinion_vo = is_opinion_vo,
		}
	else
		local wwise_route_key = optional_route_key or 40
		local callback = self._vo_callback
		local vo_unit = Vo.play_local_vo_events(dialogue_system, events, voice_profile, wwise_route_key, callback, nil, is_opinion_vo)

		self._vo_unit = vo_unit
	end
end

return InventoryCosmeticsView
