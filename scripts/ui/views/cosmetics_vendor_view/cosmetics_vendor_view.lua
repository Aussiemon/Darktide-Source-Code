require("scripts/ui/views/vendor_view_base/vendor_view_base")

local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local CosmeticsVendorViewSettings = require("scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_settings")
local Definitions = require("scripts/ui/views/cosmetics_vendor_view/cosmetics_vendor_view_definitions")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local Promise = require("scripts/foundation/utilities/promise")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UISettings = require("scripts/settings/ui/ui_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local ScriptCamera = require("scripts/foundation/utilities/script_camera")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local Breeds = require("scripts/settings/breed/breeds")
local Archetypes = require("scripts/settings/archetype/archetypes")
local ViewElementTabMenu = require("scripts/ui/view_elements/view_element_tab_menu/view_element_tab_menu")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local CosmeticsVendorView = class("CosmeticsVendorView", "VendorViewBase")

CosmeticsVendorView.init = function (self, settings, context)
	local parent = context and context.parent
	self._parent = parent
	self._optional_store_service = context and context.optional_store_service
	self._disable_equipped_status = true

	CosmeticsVendorView.super.init(self, Definitions, settings, context)
end

CosmeticsVendorView.on_enter = function (self)
	CosmeticsVendorView.super.on_enter(self)

	self._render_settings.alpha_multiplier = 0
	local context = self._context
	local option_button_definitions = context.option_button_definitions

	if option_button_definitions then
		self:_setup_option_buttons(option_button_definitions)
	end

	self._item_grid:update_dividers("content/ui/materials/frames/cosmetics_vendor/details_upper_cosmetic", {
		654,
		80
	}, {
		0,
		-55,
		20
	}, "content/ui/materials/frames/cosmetics_vendor/details_lower_cosmetic", {
		470,
		50
	}, {
		0,
		13,
		20
	})
	self:_setup_background_world()
	self._item_grid:set_sort_button_offset(0, 40)
end

CosmeticsVendorView._set_preview_widgets_visibility = function (self, visible)
	CosmeticsVendorView.super._set_preview_widgets_visibility(self, visible)

	local widgets_by_name = self._widgets_by_name
	widgets_by_name.item_restrictions.content.visible = visible
	local set_item_parts_representation_widgets = self._set_item_parts_representation_widgets

	if set_item_parts_representation_widgets then
		for i = 1, #set_item_parts_representation_widgets do
			local widget = set_item_parts_representation_widgets[i]
			widget.content.visible = visible
		end
	end
end

CosmeticsVendorView._reset_mannequin = function (self)
	if self._mannequin_loadout then
		for key, value in pairs(self._mannequin_loadout) do
			if self._default_mannequin_loadout[key] ~= self._mannequin_loadout[key] then
				self._mannequin_loadout[key] = self._default_mannequin_loadout[key]
			end
		end

		local profile = self._store_presentation_profile
		local archetype = profile and profile.archetype
		local breed_name = profile and archetype.breed or ""
		local gender_name = profile and profile.gender or ""
		local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed_name]
		local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

		if required_gender_item_names_per_slot then
			local required_items = required_gender_item_names_per_slot

			if required_items then
				for required_item_slot_name, slot_item_name in pairs(required_items) do
					local item_definition = MasterItems.get_item(slot_item_name)

					if item_definition then
						local slot_item = table.clone(item_definition)
						self._mannequin_loadout[required_item_slot_name] = slot_item
					end
				end
			end
		end
	end
end

CosmeticsVendorView._stop_previewing = function (self)
	CosmeticsVendorView.super._stop_previewing(self)
	self:_reset_set_item_parts_representation()
	self:_reset_mannequin()

	if self._gear_loadout and self._default_gear_loadout then
		table.clear(self._gear_loadout)

		for key, value in pairs(self._default_gear_loadout) do
			self._gear_loadout[key] = value
		end
	end

	if self._item_name_widget then
		self:_unregister_widget_name(self._item_name_widget.name)

		self._item_name_widget = nil
	end

	self._widgets_by_name.owned_info_text.content.visible = false
	self._widgets_by_name.purchase_button.content.visible = false
	self._widgets_by_name.no_class_info_text.content.visible = false
end

CosmeticsVendorView._preview_element = function (self, element)
	CosmeticsVendorView.super._preview_element(self, element)
	self:_set_element_purchase_info(element)
end

CosmeticsVendorView._set_element_purchase_info = function (self, element)
	local previewed_item = self._previewed_item

	if not previewed_item then
		self._widgets_by_name.owned_info_text.content.visible = false
		self._widgets_by_name.purchase_button.content.visible = false
		self._widgets_by_name.no_class_info_text.content.visible = false

		return
	end

	local is_owned = element.offer.state == "owned" or self:is_item_owned(previewed_item.gear_id)
	local is_archetype_valid = false

	if self._player_available_archetypes then
		for arcehtype_name, _ in pairs(self._player_available_archetypes) do
			if self:item_valid_by_profile_archetype(arcehtype_name, previewed_item) then
				is_archetype_valid = true

				break
			end
		end
	else
		is_archetype_valid = true
	end

	self._widgets_by_name.owned_info_text.content.visible = false
	self._widgets_by_name.purchase_button.content.visible = false
	self._widgets_by_name.no_class_info_text.content.visible = false

	if not is_archetype_valid and not is_owned then
		self._widgets_by_name.no_class_info_text.content.visible = true
	elseif is_owned then
		self._widgets_by_name.owned_info_text.content.visible = true
	else
		self._widgets_by_name.purchase_button.content.visible = true
	end
end

CosmeticsVendorView._preview_item = function (self, element)
	CosmeticsVendorView.super._preview_item(self, element)

	local previewed_item = self._previewed_item
	local item_type = previewed_item and previewed_item.item_type

	if item_type == "GEAR_UPPERBODY" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_HEAD" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "END_OF_ROUND" then
		local slots = previewed_item.slots
		local slot_name = slots and slots[1]

		if slot_name then
			self._mannequin_loadout[slot_name] = previewed_item

			if self._gear_loadout then
				self._gear_loadout[slot_name] = self._previewed_item
			end
		end

		self._previewed_gear_item_slot_name = slot_name
	elseif item_type == "SET" then
		local set_items = previewed_item.items

		for i = 1, #set_items do
			local set_item = set_items[i]
			local first_slot_name = set_item.slots and set_item.slots[1]

			if first_slot_name then
				self._mannequin_loadout[first_slot_name] = set_item

				if self._gear_loadout then
					self._gear_loadout[first_slot_name] = set_item
				end
			end
		end

		self:_setup_set_item_parts_representation(set_items)
	end

	local restrictions_text, present_restrictions_text = nil

	if item_type == "WEAPON_SKIN" then
		restrictions_text, present_restrictions_text = ItemUtils.weapon_skin_requirement_text(previewed_item)
	elseif item_type == "GEAR_UPPERBODY" or item_type == "GEAR_EXTRA_COSMETIC" or item_type == "GEAR_HEAD" or item_type == "GEAR_LOWERBODY" then
		restrictions_text, present_restrictions_text = ItemUtils.class_requirement_text(previewed_item)
	elseif item_type == "SET" then
		restrictions_text, present_restrictions_text = ItemUtils.set_item_class_requirement_text(previewed_item)
	end

	self:_setup_item_texts(previewed_item, present_restrictions_text and restrictions_text)
end

CosmeticsVendorView._setup_set_item_parts_representation = function (self, items)
	local item_type_material_lookup = UISettings.item_type_material_lookup
	local widget_definition = UIWidget.create_definition({
		{
			value_id = "icon",
			style_id = "icon",
			pass_type = "texture",
			style = {
				color = Color.text_default(255, true)
			}
		},
		{
			style_id = "text",
			value_id = "text",
			pass_type = "text",
			value = "",
			style = {
				vertical_alignment = "center",
				font_size = 28,
				horizontal_alignment = "center",
				font_type = "proxima_nova_bold",
				text_vertical_alignment = "center",
				text_horizontal_alignment = "center",
				text_color = Color.terminal_text_body(255, true),
				offset = {
					20,
					20,
					1
				}
			},
			visibility_function = function (content)
				return content.owned
			end
		}
	}, "set_item_parts_representation")
	local set_item_parts_representation_widgets = {}

	if items then
		for i = 1, #items do
			local item = items[i]
			local gear_id = item.gear_id
			local item_type = item.item_type
			local icon = item_type_material_lookup[item_type]
			local owned = self:is_item_owned(gear_id)
			local widget = self:_create_widget("item_part_" .. i, widget_definition)
			local content = widget.content
			content.icon = icon
			content.owned = owned
			local offset = widget.offset
			offset[1] = (i - 1) * 70
			set_item_parts_representation_widgets[#set_item_parts_representation_widgets + 1] = widget
		end
	end

	self._set_item_parts_representation_widgets = set_item_parts_representation_widgets
end

CosmeticsVendorView._reset_set_item_parts_representation = function (self)
	local set_item_parts_representation_widgets = self._set_item_parts_representation_widgets

	if set_item_parts_representation_widgets then
		local ui_renderer = self._ui_default_renderer

		for i = 1, #set_item_parts_representation_widgets do
			local widget = set_item_parts_representation_widgets[i]
			local widget_name = widget.name

			self:_unregister_widget_name(widget_name)
			UIWidget.destroy(ui_renderer, widget)
		end

		table.clear(set_item_parts_representation_widgets)
	end
end

CosmeticsVendorView._setup_item_texts = function (self, item, restrictions_text)
	if not item then
		self:_setup_item_restrictions_text(restrictions_text)

		return
	end

	local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
	local item_size = {
		700,
		60
	}
	local ui_renderer = self._ui_default_renderer
	local scenegraph_id = "item_name_pivot"
	local widget_type = "item_name"
	local ContentBlueprints = generate_blueprints_function(item_size)
	local template = ContentBlueprints[widget_type]
	local config = {
		vertical_alignment = "bottom",
		horizontal_alignment = "right",
		size = item_size,
		item = item
	}
	local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
	local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
	local optional_style = template.style_function and template.style_function(self, config, size) or template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)
	local widget = nil

	if widget_definition then
		local name = "item_name"
		widget = self:_create_widget(name, widget_definition)
		widget.type = widget_type
		local init = template.init

		if init then
			init(self, widget, config, nil, nil, ui_renderer)
		end

		self._item_name_widget = widget
	end

	self:_setup_item_restrictions_text(restrictions_text)
end

CosmeticsVendorView._setup_item_restrictions_text = function (self, restrictions_text)
	local margin_compensation = 5
	local sub_title_margin = 10
	local max_width = 500
	local widgets_by_name = self._widgets_by_name
	local item_restrictions_widget = widgets_by_name.item_restrictions
	local item_restrictions_content = item_restrictions_widget.content
	local item_restrictions_style = item_restrictions_widget.style

	if restrictions_text then
		item_restrictions_content.text = restrictions_text
		local restriction_title_style = item_restrictions_style.title
		local restriction_text_style = item_restrictions_style.text
		local restriction_title_options = UIFonts.get_font_options_by_style(restriction_title_style)
		local restriction_text_options = UIFonts.get_font_options_by_style(restriction_text_style)
		local restriction_title_width, restriction_title_height = self:_text_size(item_restrictions_content.title, restriction_title_style.font_type, restriction_title_style.font_size, {
			max_width,
			math.huge
		}, restriction_title_options)
		local restriction_text_width, title_restriction_text_height = self:_text_size(item_restrictions_content.text, restriction_text_style.font_type, restriction_text_style.font_size, {
			max_width,
			math.huge
		}, restriction_text_options)
		local text_height = restriction_title_height + title_restriction_text_height + sub_title_margin

		self:_set_scenegraph_size("item_restrictions_background", nil, text_height + margin_compensation * 2)
		self:_set_scenegraph_size("item_restrictions", nil, text_height)

		item_restrictions_style.text.offset[2] = restriction_title_height + sub_title_margin
		item_restrictions_content.visible = true
	else
		item_restrictions_content.visible = false
	end
end

CosmeticsVendorView.on_exit = function (self)
	if self._on_enter_anim_id then
		self:_stop_animation(self._on_enter_anim_id)

		self._on_enter_anim_id = nil
	end

	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	CosmeticsVendorView.super.on_exit(self)

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end
end

CosmeticsVendorView._initialize_background_profile = function (self, optional_archetype_name)
	if self._profile_spawner then
		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local profile = nil
	local player = self:_player()
	local player_profile = player and player:profile()

	if optional_archetype_name then
		local archetype = Archetypes[optional_archetype_name]
		local breed_name = archetype.breed
		local breed = Breeds[breed_name]
		local genders = breed.genders
		local player_gender = player_profile and player_profile.gender
		local gender_index = math.random(1, table.size(genders))
		local gender_name = genders[gender_index]

		if player_gender and table.find(genders, player_gender) then
			gender_name = player_gender
		end

		local loadout = {}
		profile = {
			loadout = loadout,
			archetype = archetype,
			gender = gender_name,
			breed = breed_name
		}
		local slot_items_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name][gender_name]

		for slot_name, item_path in pairs(slot_items_per_slot) do
			loadout[slot_name] = item_path
		end
	else
		profile = player_profile
	end

	self._preview_profile = profile
	self._mannequin_loadout = self:_generate_mannequin_loadout(self._preview_profile)
	self._default_mannequin_loadout = table.clone_instance(self._mannequin_loadout)
	self._mannequin_profile = table.clone_instance(self._preview_profile)
	self._mannequin_profile.loadout = self._mannequin_loadout

	if player_profile and player_profile.archetype.name == self._preview_profile.archetype.name then
		local gear_profile = table.clone_instance(player_profile)
		self._default_gear_loadout = table.clone_instance(gear_profile.loadout)
		self._gear_loadout = table.clone_instance(gear_profile.loadout)
		gear_profile.loadout = self._gear_loadout
		gear_profile.character_id = "cosmetics_view_character"
		self._gear_profile = gear_profile
		self.can_preview_with_gear = true
	else
		self.can_preview_with_gear = false
	end

	self._store_presentation_profile = self._mannequin_profile
	self._spawned_profile = nil
end

CosmeticsVendorView.cb_on_preview_with_gear_toggled = function (self, id, input_pressed, instant)
	self._previewed_with_gear = not self._previewed_with_gear
	self._store_presentation_profile = self._previewed_with_gear and self._gear_profile or self._mannequin_profile
	self._spawn_player = true
	self._keep_current_rotation = true

	self:_play_sound(UISoundEvents.cosmetics_vendor_show_with_gear)
end

CosmeticsVendorView._cb_on_purchase_pressed = function (self)
	local purchase_disabled = self._widgets_by_name.purchase_button.content.hotspot.disabled
	local purchase_not_visible = self._widgets_by_name.purchase_button.content.visible == false

	if purchase_disabled or purchase_not_visible then
		return
	end

	CosmeticsVendorView.super._cb_on_purchase_pressed(self)
end

CosmeticsVendorView.present_items = function (self, optional_context)
	local optional_archetype_name = nil

	if optional_context then
		local archetype_name = optional_context.archetype_name
		optional_archetype_name = archetype_name
	end

	self:_clear_list()
	self:_initialize_background_profile(optional_archetype_name)

	local presentation_profile = self._store_presentation_profile
	self._active_archetype_name = presentation_profile.archetype.name
	local ignore_focus_on_offer = true
	local promises = {
		self:_update_wallets(),
		self:_fetch_store_items(ignore_focus_on_offer, optional_context)
	}

	if not self._player_available_archetypes then
		promises[#promises + 1] = Managers.data_service.profiles:fetch_all_profiles()
	end

	Promise.all(unpack(promises)):next(function (data)
		local wallet, store_items, profiles_data = unpack(data)

		if profiles_data then
			self._player_available_archetypes = {}

			for i = 1, #profiles_data.profiles do
				local profile = profiles_data.profiles[i]
				local archetype_name = profile.archetype.name
				self._player_available_archetypes[archetype_name] = true
			end
		end
	end)

	if not self._on_enter_anim_id then
		self._on_enter_anim_id = self:_start_animation("on_enter", self._widgets_by_name, self)
	end

	local context = self._context
	local optional_camera_breed_name = context and context.optional_camera_breed_name
	local breed_name = presentation_profile.breed
	local default_camera_settings = self._breeds_default_camera_settings[optional_camera_breed_name or breed_name]

	self:_set_initial_viewport_camera_position(default_camera_settings)
end

CosmeticsVendorView._fetch_store_items = function (self, ignore_focus_on_offer, optional_context)
	return CosmeticsVendorView.super._fetch_store_items(self, ignore_focus_on_offer):next(function (data)
		if not self._spawned_profile then
			local context = self._context
			self._spawn_player = context and context.spawn_player
			self._initial_rotation = nil
		end

		local options_tab_bar = self._options_tab_bar

		if options_tab_bar then
			local selected_index = optional_context and optional_context.option_index or self._selected_option_button_index or 1
			local options_entries = options_tab_bar:entries()
			local first_option_entry = options_entries[selected_index]
			local widget = first_option_entry.widget
			local content = widget.content
			local pressed_callback = content.hotspot.pressed_callback
			local options = self._context.option_button_definitions

			pressed_callback(selected_index, options)
		end

		return data
	end)
end

CosmeticsVendorView._set_initial_viewport_camera_position = function (self, default_camera_settings)
	local world_spawner = self._world_spawner
	local camera_unit = default_camera_settings.camera_unit
	local default_camera_position_boxed = default_camera_settings.original_position_boxed
	local default_camera_rotation_boxed = default_camera_settings.original_rotation_boxed

	world_spawner:change_camera_unit(camera_unit)

	local camera_world_position = default_camera_position_boxed:unbox()
	local camera_world_rotation = default_camera_rotation_boxed:unbox()

	world_spawner:set_camera_position(camera_world_position)
	world_spawner:set_camera_rotation(camera_world_rotation)
	world_spawner:reset_camera_rotation_axis_offset()
	world_spawner:reset_camera_position_axis_offset()

	self._next_zoom_instant = true
end

CosmeticsVendorView._setup_viewport_camera = function (self, camera_unit)
	if not self._world_spawner then
		self._pending_viewport_camera_unit = camera_unit

		return
	end

	local context = self._context
	local level_settings = context and context.spawn_player and CosmeticsVendorViewSettings.gear_level_settings or CosmeticsVendorViewSettings.weapon_level_settings
	local viewport_name = level_settings.viewport_name
	local viewport_type = level_settings.viewport_type
	local viewport_layer = level_settings.viewport_layer
	local shading_environment = level_settings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)

	self._camera_zoomed_in = false

	self:_trigger_zoom_logic(true)
end

CosmeticsVendorView._get_store = function (self)
	local active_archetype_name = self._active_archetype_name
	local store_service = Managers.data_service.store
	local store_promise = nil
	local optional_store_service = self._optional_store_service

	if optional_store_service and store_service[optional_store_service] then
		store_promise = store_service[optional_store_service](store_service, active_archetype_name)
	else
		store_promise = store_service:get_credits_cosmetics_store(active_archetype_name)
	end

	if not store_promise then
		return
	end

	return store_promise:next(function (data)
		local local_player_id = 1
		local player = Managers.player:local_player(local_player_id)
		local character_id = player:character_id()

		return Managers.data_service.gear:fetch_inventory(character_id):next(function (items)
			local offers = data.offers

			for i = 1, #offers do
				local offer = offers[i]
				local offer_id = offer.offerId
				local sku = offer.sku
				local category = sku.category

				if category == "item_instance" then
					if offer.state == "active" then
						local item = offer.description

						if self:_does_item_exist_in_list(items, item) then
							offer.state = "owned"
						end
					end
				elseif category == "bundle" then
					local owned_count = 0
					local total_count = 0
					local bundled = offer.description.contents.bundled

					for k = 1, #bundled do
						local info = bundled[k]
						local gear_id = info.description.gearId

						if self:is_item_owned(gear_id) then
							owned_count = owned_count + 1
						end

						total_count = total_count + 1
					end

					if total_count == owned_count then
						offer.state = "owned"
					end
				end
			end

			return Promise.resolved(data)
		end)
	end)
end

CosmeticsVendorView._purchase_item = function (self, offer)
	local store_service = Managers.data_service.store
	local promise = store_service:purchase_item(offer)

	promise:next(function (result)
		local widgets_by_name = self._widgets_by_name
		local purchase_sound = widgets_by_name.purchase_button.content.purchase_sound

		if purchase_sound then
			self:_play_sound(purchase_sound)
		end

		self._purchase_promise = nil

		self:_on_purchase_complete(result.items)
		self:_update_bundle_offers_owned_skus()

		local previewed_item = self._previewed_item

		if previewed_item then
			local set_items = previewed_item.items

			if set_items then
				self:_reset_set_item_parts_representation()
				self:_setup_set_item_parts_representation(set_items)
			end
		end

		local item_index = self:item_grid_index(self._previewed_item)
		local element = self:element_by_index(item_index)

		self:_set_element_purchase_info(element)
	end):catch(function (error)
		self._purchase_promise = nil

		self:present_items({
			archetype_name = self._active_archetype_name,
			option_index = self._selected_option_button_index
		})
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_notification_acqusition_failed")
		}, nil, UISoundEvents.notification_join_party_failed)
	end)

	self._purchase_promise = promise
end

CosmeticsVendorView._does_item_exist_in_list = function (self, items, item)
	for gear_id, _ in pairs(items) do
		if gear_id == item.gear_id then
			return true
		end
	end

	return false
end

CosmeticsVendorView._on_purchase_complete = function (self, items)
	CosmeticsVendorView.super._on_purchase_complete(self, items)

	local parent = self._parent

	if parent then
		parent:play_vo_events(CosmeticsVendorViewSettings.vo_event_vendor_purchase, "reject_npc_a", nil, 1.4)
		parent:play_vo_events(CosmeticsVendorViewSettings.vo_event_vendor_purchase, "reject_npc_servitor_a", nil, 0)
	end
end

CosmeticsVendorView.dialogue_system = function (self)
	local parent = self._parent

	if parent then
		return parent.dialogue_system and parent:dialogue_system()
	end
end

CosmeticsVendorView.update = function (self, dt, t, input_service)
	if self._spawn_player and self._spawn_point_unit and self._breeds_default_camera_settings then
		local profile = self._store_presentation_profile
		local initial_rotation = self._initial_rotation
		local disable_rotation_input = self._disable_rotation_input
		local keep_current_rotation = self._keep_current_rotation

		self:_spawn_profile(profile, initial_rotation, disable_rotation_input, keep_current_rotation)

		self._keep_current_rotation = nil
		self._spawn_player = false
	end

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	return CosmeticsVendorView.super.update(self, dt, t, input_service)
end

CosmeticsVendorView.on_resolution_modified = function (self, scale)
	CosmeticsVendorView.super.on_resolution_modified(self, scale)
	self:_update_options_tab_bar_position()
end

CosmeticsVendorView._spawn_profile = function (self, profile, initial_rotation, disable_rotation_input, keep_current_rotation)
	local current_rotation_angle = nil

	if self._profile_spawner then
		if keep_current_rotation then
			current_rotation_angle = self._profile_spawner:rotation_angle()

			if initial_rotation then
				current_rotation_angle = current_rotation_angle and current_rotation_angle - initial_rotation
			end
		end

		self._profile_spawner:destroy()

		self._profile_spawner = nil
	end

	local world = self._world_spawner:world()
	local camera = self._world_spawner:camera()
	local unit_spawner = self._world_spawner:unit_spawner()
	self._profile_spawner = UIProfileSpawner:new("CosmeticsVendorView", world, camera, unit_spawner)

	if initial_rotation then
		local ignore_direct_application = true

		self._profile_spawner:set_character_default_rotation(initial_rotation, ignore_direct_application)

		local instant = true

		self._profile_spawner:set_character_rotation(initial_rotation, instant)
	end

	if current_rotation_angle or initial_rotation then
		local instant = true

		self._profile_spawner:set_character_rotation((initial_rotation or 0) + (current_rotation_angle or 0), instant)
	end

	if disable_rotation_input then
		self._profile_spawner:disable_rotation_input()
	end

	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	self._spawned_profile = profile
end

CosmeticsVendorView.draw = function (self, dt, t, input_service, layer)
	local render_settings = self._render_settings
	local previous_alpha_multiplier = render_settings.alpha_multiplier
	render_settings.alpha_multiplier = self.animated_alpha_multiplier or 0
	local ui_scenegraph = self._ui_scenegraph
	local ui_renderer = self._ui_default_renderer

	if self._item_name_widget then
		UIRenderer.begin_pass(ui_renderer, ui_scenegraph, input_service, dt, render_settings)
		UIWidget.draw(self._item_name_widget, ui_renderer)
		UIRenderer.end_pass(ui_renderer)
	end

	CosmeticsVendorView.super.draw(self, dt, t, input_service, layer)

	render_settings.alpha_multiplier = previous_alpha_multiplier
end

CosmeticsVendorView._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	CosmeticsVendorView.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local set_item_parts_representation_widgets = self._set_item_parts_representation_widgets

	if set_item_parts_representation_widgets then
		local num_widgets = #set_item_parts_representation_widgets

		for i = 1, num_widgets do
			local widget = set_item_parts_representation_widgets[i]

			UIWidget.draw(widget, ui_renderer)
		end
	end
end

CosmeticsVendorView._setup_option_buttons = function (self, options)
	local button_size = {
		80,
		80
	}
	local button_spacing = 10
	local settings = {
		vertical_alignment = "top",
		grow_vertically = true,
		button_size = button_size,
		button_spacing = button_spacing,
		input_label_offset = {
			25,
			30
		}
	}
	local options_tab_bar = self:_add_element(ViewElementTabMenu, "options_tab_bar", 10, settings)
	local item_category_sort_button = ButtonPassTemplates.item_category_sort_button

	for i = 1, #options do
		local option = options[i]
		local pressed_callback = callback(self, "on_option_button_pressed", i, option)
		local display_name = option.display_name

		options_tab_bar:add_entry(display_name, pressed_callback, item_category_sort_button, option.icon)
	end

	local input_action_left = "navigate_secondary_left_pressed"
	local input_action_right = "navigate_secondary_right_pressed"

	options_tab_bar:set_input_actions(input_action_left, input_action_right)
	options_tab_bar:set_is_handling_navigation_input(true)

	self._options_tab_bar = options_tab_bar

	self:on_option_button_pressed(1, options[1], true)

	local total_height = button_size[2] * #options + button_spacing * #options

	self:_set_scenegraph_size("button_pivot_background", nil, total_height + 30)
	self:_update_options_tab_bar_position()
end

CosmeticsVendorView._update_options_tab_bar_position = function (self)
	if not self._options_tab_bar then
		return
	end

	local position = self:_scenegraph_world_position("button_pivot")

	self._options_tab_bar:set_pivot_offset(position[1], position[2])
end

CosmeticsVendorView.on_option_button_pressed = function (self, index, option, force_selection)
	if index == self._selected_option_button_index and not force_selection then
		return
	end

	self._selected_option_button_index = index
	local slot_names = option.slot_names
	local slot_name = option.slot_name or slot_names and slot_names[1]
	local item_types = option.item_types

	self._options_tab_bar:set_selected_index(index)

	local instant_zoom = self._next_zoom_instant or self._selected_slot == nil
	self._next_zoom_instant = nil
	self._selected_slot = ItemSlotSettings[slot_name]

	self:_trigger_zoom_logic(instant_zoom, slot_name)

	local display_name = option.display_name

	self:_present_layout_by_slot_filter(slot_names, item_types)
	self:_set_layout_display_name(display_name)

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		local initial_rotation = nil

		if slot_name == "slot_gear_extra_cosmetic" then
			initial_rotation = math.pi
		else
			initial_rotation = 0
		end

		self._initial_rotation = initial_rotation

		profile_spawner:set_character_default_rotation(initial_rotation or 0)
	end
end

CosmeticsVendorView._set_layout_display_name = function (self, display_name)
	local widgets_by_name = self._widgets_by_name
	local widget = widgets_by_name.title_text
	widget.content.text = display_name and Localize(display_name) or "n/a"
end

CosmeticsVendorView._setup_background_world = function (self)
	local context = self._context
	local level_settings = context and context.spawn_player and CosmeticsVendorViewSettings.gear_level_settings or CosmeticsVendorViewSettings.weapon_level_settings
	self._breeds_item_camera_by_slot_id = {}
	self._breeds_default_camera_settings = {}
	local starting_camera_unit = nil

	for breed_name, settings in pairs(Breeds) do
		if settings.breed_type == "player" then
			local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

			self[default_camera_event_id] = function (instance, camera_unit)
				if instance._context then
					instance._context.camera_unit = camera_unit
				end

				local camera_position = Unit.world_position(camera_unit, 1)
				local camera_rotation = Unit.world_rotation(camera_unit, 1)
				instance._breeds_default_camera_settings[breed_name] = {
					camera_unit = camera_unit,
					original_position_boxed = Vector3Box(camera_position),
					original_rotation_boxed = QuaternionBox(camera_rotation)
				}

				instance:_unregister_event(default_camera_event_id)

				if not starting_camera_unit then
					starting_camera_unit = camera_unit
				end
			end

			self:_register_event(default_camera_event_id)

			for slot_name, slot in pairs(ItemSlotSettings) do
				if slot.slot_type == "gear" then
					local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

					self[item_camera_event_id] = function (instance, camera_unit)
						if not instance._breeds_item_camera_by_slot_id[breed_name] then
							instance._breeds_item_camera_by_slot_id[breed_name] = {}
						end

						instance._breeds_item_camera_by_slot_id[breed_name][slot_name] = camera_unit

						instance:_unregister_event(item_camera_event_id)
					end

					self:_register_event(item_camera_event_id)
				end
			end
		end
	end

	self:_register_event("event_register_cosmetics_preview_character_spawn_point")

	local world_name = level_settings.world_name
	local world_layer = level_settings.world_layer
	local world_timer_name = CosmeticsVendorViewSettings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)
	local level_name = level_settings.level_name

	self._world_spawner:spawn_level(level_name)
	self:_setup_viewport_camera(starting_camera_unit)
end

CosmeticsVendorView.world_spawner = function (self)
	return self._world_spawner
end

CosmeticsVendorView.spawn_point_unit = function (self)
	return self._spawn_point_unit
end

CosmeticsVendorView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

CosmeticsVendorView._set_camera_item_slot_focus = function (self, breed_name, slot_name, time, func_ptr)
	local world_spawner = self._world_spawner
	local breeds_item_camera_by_slot_id = self._breeds_item_camera_by_slot_id
	local breed_item_camera_by_slot_id = breeds_item_camera_by_slot_id[breed_name]
	local slot_camera = breed_item_camera_by_slot_id and breed_item_camera_by_slot_id[slot_name]
	local camera_world_position = Unit.world_position(slot_camera, 1)
	local camera_world_rotation = Unit.world_rotation(slot_camera, 1)
	local boxed_camera_start_position = world_spawner:boxed_camera_start_position()
	local default_camera_world_position = Vector3.from_array(boxed_camera_start_position)

	world_spawner:set_camera_position_axis_offset("x", camera_world_position.x - default_camera_world_position.x, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("y", camera_world_position.y - default_camera_world_position.y, time, func_ptr)
	world_spawner:set_camera_position_axis_offset("z", camera_world_position.z - default_camera_world_position.z, time, func_ptr)

	local boxed_camera_start_rotation = world_spawner:boxed_camera_start_rotation()
	local default_camera_world_rotation = boxed_camera_start_rotation:unbox()
	local default_camera_world_rotation_x, default_camera_world_rotation_y, default_camera_world_rotation_z = Quaternion.to_euler_angles_xyz(default_camera_world_rotation)
	local camera_world_rotation_x, camera_world_rotation_y, camera_world_rotation_z = Quaternion.to_euler_angles_xyz(camera_world_rotation)

	world_spawner:set_camera_rotation_axis_offset("x", camera_world_rotation_x - default_camera_world_rotation_x, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("y", camera_world_rotation_y - default_camera_world_rotation_y, time, func_ptr)
	world_spawner:set_camera_rotation_axis_offset("z", camera_world_rotation_z - default_camera_world_rotation_z, time, func_ptr)
end

CosmeticsVendorView._set_camera_node_focus = function (self, node_name, time, func_ptr)
	if node_name then
		local profile_spawner = self._profile_spawner
		local world_spawner = self._world_spawner
		local base_world_position = profile_spawner:node_world_position(1)
		local node_world_position = profile_spawner:node_world_position(node_name)
		local target_position = node_world_position - base_world_position

		world_spawner:set_camera_position_axis_offset("x", target_position.x, time, func_ptr)
		world_spawner:set_camera_position_axis_offset("y", target_position.y, time, func_ptr)
		world_spawner:set_camera_position_axis_offset("z", target_position.z, time, func_ptr)
	end
end

CosmeticsVendorView._set_camera_position_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_position_axis_offset(axis, value, animation_time, func_ptr)
end

CosmeticsVendorView._set_camera_rotation_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_rotation_axis_offset(axis, value, animation_time, func_ptr)
end

CosmeticsVendorView.cb_on_camera_zoom_toggled = function (self, id, input_pressed, instant)
	self._camera_zoomed_in = not self._camera_zoomed_in

	if self._camera_zoomed_in then
		self:_play_sound(UISoundEvents.apparel_zoom_in)
	else
		self:_play_sound(UISoundEvents.apparel_zoom_out)
	end

	self:_trigger_zoom_logic(instant)
end

CosmeticsVendorView._can_zoom = function (self)
	return self._profile_spawner and not self._disable_zoom
end

CosmeticsVendorView._trigger_zoom_logic = function (self, instant, optional_slot_name)
	local world_spawner = self._world_spawner

	if not world_spawner then
		return
	end

	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name

	if not selected_slot_name then
		return
	end

	local func_ptr = math.easeCubic
	local duration = instant and 0 or 1
	local profile = self._store_presentation_profile
	local archetype = profile and profile.archetype
	local breed_name = profile and archetype.breed or ""

	if self._camera_zoomed_in then
		self:_set_camera_item_slot_focus(breed_name, selected_slot_name, duration, func_ptr)
	else
		world_spawner:set_camera_position_axis_offset("x", 0, duration, func_ptr)
		world_spawner:set_camera_position_axis_offset("y", 0, duration, func_ptr)
		world_spawner:set_camera_position_axis_offset("z", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("x", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("y", 0, duration, func_ptr)
		world_spawner:set_camera_rotation_axis_offset("z", 0, duration, func_ptr)
	end
end

return CosmeticsVendorView
