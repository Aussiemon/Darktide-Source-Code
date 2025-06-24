-- chunkname: @scripts/ui/views/store_item_detail_view/store_item_detail_view.lua

local generate_blueprints_function = require("scripts/ui/view_content_blueprints/item_blueprints")
local Archetypes = require("scripts/settings/archetype/archetypes")
local Breeds = require("scripts/settings/breed/breeds")
local ButtonPassTemplates = require("scripts/ui/pass_templates/button_pass_templates")
local ContentBlueprints = require("scripts/ui/views/store_view/store_view_content_blueprints")
local Definitions = require("scripts/ui/views/store_item_detail_view/store_item_detail_view_definitions")
local Items = require("scripts/utilities/items")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local MasterItems = require("scripts/backend/master_items")
local Offer = require("scripts/utilities/offer")
local Personalities = require("scripts/settings/character/personalities")
local Promise = require("scripts/foundation/utilities/promise")
local PromiseContainer = require("scripts/utilities/ui/promise_container")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local StoreItemDetailViewSettings = require("scripts/ui/views/store_item_detail_view/store_item_detail_view_settings")
local Text = require("scripts/utilities/ui/text")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIProfileSpawner = require("scripts/managers/ui/ui_profile_spawner")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UISettings = require("scripts/settings/ui/ui_settings")
local UISoundEvents = require("scripts/settings/ui/ui_sound_events")
local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWidgetGrid = require("scripts/ui/widget_logic/ui_widget_grid")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local ViewElementInputLegend = require("scripts/ui/view_elements/view_element_input_legend/view_element_input_legend")
local ViewElementInventoryWeaponPreview = require("scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview")
local ViewElementWallet = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet")
local VoiceFxPresetSettings = require("scripts/settings/dialogue/voice_fx_preset_settings")
local WalletSettings = require("scripts/settings/wallet_settings")
local StoreItemDetailView = class("StoreItemDetailView", "BaseView")

StoreItemDetailView.init = function (self, settings, context)
	self._context = context

	local class_name = self.__class_name

	self._unique_id = class_name .. "_" .. string.gsub(tostring(self), "table: ", "")
	self._telemetry_id = table.nested_get(context, "store_item", "offer", "sku", "id")

	StoreItemDetailView.super.init(self, Definitions, settings)

	self._pass_draw = false
	self._wallet_type = {
		"aquilas",
	}
	self._using_cursor_navigation = Managers.ui:using_cursor_navigation()

	local player = self:_player()

	self._profile = player:profile()
	self._aquilas_showing = false
	self._url_textures = {}
	self._zoom_speed, self._zoom_level, self._zoom_delay = 0, 1, 0
	self._has_purchased_item = false

	if IS_PLAYSTATION then
		self._ps_store_icon_showing = false
	end

	self._promise_container = PromiseContainer:new()
end

StoreItemDetailView._setup_offscreen_gui = function (self)
	local ui_manager = Managers.ui
	local timer_name = "ui"
	local parent = self
	local view_name = parent.view_name

	do
		local world_layer = 102
		local world_name = self._unique_id .. "_ui_offscreen_world"

		self._offscreen_world = ui_manager:create_world(world_name, world_layer, timer_name, view_name)

		local viewport_name = self._unique_id .. "_ui_offscreen_world_viewport"
		local viewport_type = "overlay_offscreen"
		local viewport_layer = 1

		self._offscreen_viewport = ui_manager:create_viewport(self._offscreen_world, viewport_name, viewport_type, viewport_layer)
		self._offscreen_viewport_name = viewport_name
		self._ui_offscreen_renderer = ui_manager:create_renderer(self._unique_id .. "_ui_offscreen_renderer", self._offscreen_world)
	end

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
	StoreItemDetailView.super.on_enter(self)

	local context = self._context
	local store_item = context.store_item

	self._store_item = store_item

	local offer = store_item.offer

	self._store_offer_is_bundle = offer.bundleInfo
	self._content_blueprints = generate_blueprints_function(StoreItemDetailViewSettings.grid_size)
	self._wallet_element = self:_add_element(ViewElementWallet, "wallet_element", 100)

	self:_update_element_position("wallet_element_pivot", self._wallet_element, true)
	self._wallet_element:_generate_currencies(self._wallet_type, {
		nil,
		30,
	})

	self._items = Offer.extract_items(offer)

	self:_create_loading_widget()
	self:_destroy_aquilas_presentation()
	self:_setup_input_legend()
	self:_setup_offscreen_gui()
	self:_setup_background_world()
	self:_setup_forward_gui()
	self:_setup_callbacks()

	self._widgets_by_name.purchase_item_button.content.visible = false
	self._bundle_image = nil

	local imageURL
	local media_array = offer.media
	local media_array_count = media_array and #media_array or 0

	for i = 1, media_array_count do
		local media = media_array[i]

		if media.mediaSize == "large" then
			imageURL = media.url

			break
		end
	end

	if imageURL then
		local url_textures = self._url_textures

		url_textures[#url_textures + 1] = imageURL

		Managers.url_loader:load_texture(imageURL):next(function (data)
			self._bundle_image = data

			self:_setup_item_presentation()
		end):catch(function (error)
			self:_setup_item_presentation()
		end)
	else
		self:_setup_item_presentation()
	end
end

StoreItemDetailView._create_loading_widget = function (self)
	local widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				color = Color.black(127.5, true),
			},
		},
		{
			pass_type = "texture",
			value = "content/ui/materials/loading/loading_icon",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				size = {
					256,
					256,
				},
				offset = {
					0,
					0,
					1,
				},
			},
		},
	}, "loading")

	self._loading_widget = self:_create_widget("loading", widget_definition)
end

StoreItemDetailView._setup_callbacks = function (self)
	self._widgets_by_name.purchase_item_button.content.hotspot.pressed_callback = callback(self, "cb_on_purchase_pressed", "item")
end

StoreItemDetailView._is_owned = function (self, items)
	local owned_count = 0
	local owned_items = {}
	local total_count = #items

	for i = 1, total_count do
		local item = items[i]
		local is_owned = self:_is_item_owned(item)

		if is_owned then
			owned_count = owned_count + 1
			owned_items[owned_count] = item
		end
	end

	return total_count == owned_count, owned_items
end

StoreItemDetailView._is_item_owned = function (self, item)
	return self._context.parent:is_item_owned(item.gearId)
end

StoreItemDetailView._generate_element_from_item = function (self, entry)
	local real_item = entry.real_item
	local item = entry.item

	return {
		slot = {
			name = real_item.slots and real_item.slots[1],
		},
		item = real_item,
		visual_item = item,
	}
end

StoreItemDetailView._setup_item_presentation = function (self)
	local offer = self._store_item.offer
	local items = self._items

	if #items == 1 then
		local entry = items[1]

		entry.offer = offer

		local item = entry.item

		if item then
			local element = self:_generate_element_from_item(entry)

			element.item_index = 1
			element.total_count = 1
			element.owned_count = self:_is_item_owned(entry) and 1 or 0
			element.entry = entry
			element.offer = offer
			self._selected_element = element

			local profile = self:_generic_profile_from_item(item)
			local slots = item.slots

			if slots then
				profile.loadout[slots[1]] = item
			end

			element.dummy_profile = profile

			local title_text = Items.display_name(element.item)
			local item_type = Items.type_display_name(element.item)

			self:_setup_details(title_text, item_type)
			self:_setup_description_grid(element.item)
			self:_present_current_element()
		end
	else
		local title_text = offer.sku.name or ""
		local item_type_lookup = offer.description.type
		local item_type_display_name_localized = Items.type_display_name({
			item_type = item_type_lookup,
		})

		self:_setup_details(title_text, item_type_display_name_localized)
		self:_setup_item_grid()
	end

	self:_update_wallets()

	local grid = self._grid

	if grid and self._selected_element then
		local item_index = self._selected_element.item_index

		if item_index then
			grid:select_grid_index(item_index)
		else
			grid:select_grid_index(nil, nil, nil, true)

			self._details_widget.content.hotspot.is_selected = true
		end
	elseif grid then
		self:cb_on_bundle_pressed()
	end
end

StoreItemDetailView._setup_details = function (self, title, type)
	if self._store_offer_is_bundle then
		self:_setup_bundle_button()
	else
		self:_setup_item_price()
	end

	self._widgets_by_name.title.content.text = title
	self._widgets_by_name.title.content.sub_text = type

	local title_style = self._widgets_by_name.title.style.text
	local sub_title_style = self._widgets_by_name.title.style.sub_text
	local title_options = UIFonts.get_font_options_by_style(title_style)
	local sub_title_options = UIFonts.get_font_options_by_style(sub_title_style)
	local max_width = self._ui_scenegraph.title.size[1]
	local _, title_height = self:_text_size(self._widgets_by_name.title.content.text, title_style.font_type, title_style.font_size, {
		max_width,
		math.huge,
	}, title_options)
	local _, sub_title_height = self:_text_size(self._widgets_by_name.title.content.sub_text, sub_title_style.font_type, sub_title_style.font_size, {
		max_width,
		math.huge,
	}, sub_title_options)
	local sub_title_margin = 10

	sub_title_style.offset[2] = sub_title_margin + title_height

	local title_total_size = sub_title_style.offset[2] + sub_title_height + self._widgets_by_name.title.style.divider.size[2] + sub_title_margin
	local title_scenegraph_position = self._ui_scenegraph.title.position
	local margin = 15
	local max_height = self._ui_scenegraph.left_side.size[2] - 40
	local grid_height = max_height - (title_scenegraph_position[2] + title_total_size + margin)

	self:_set_scenegraph_size("title", nil, title_total_size)
	self:_set_scenegraph_position("details_pivot", nil, title_scenegraph_position[2] + title_total_size + margin)

	local details_widget_height = self._details_widget.content.size[2]

	grid_height = grid_height - details_widget_height - margin

	local start_description_position = title_scenegraph_position[2] + title_total_size + margin + details_widget_height + margin

	self:_set_scenegraph_position("grid_divider", nil, start_description_position)
	self:_set_scenegraph_position("description_grid", nil, start_description_position + self._ui_scenegraph.grid_divider.size[2])

	local mask_added_height = 10

	self:_set_scenegraph_size("description_grid", nil, grid_height)
	self:_set_scenegraph_size("description_mask", nil, grid_height + mask_added_height)
	self:_set_scenegraph_size("description_scrollbar", nil, grid_height)

	local grid_title_height = math.abs(self._widgets_by_name.grid_title.style.text.offset[2])
	local scrollbar_removed_height = 30

	self:_set_scenegraph_position("grid_background", nil, start_description_position + self._ui_scenegraph.grid_divider.size[2] + grid_title_height)
	self:_set_scenegraph_size("grid_background", nil, grid_height - grid_title_height)
	self:_set_scenegraph_size("grid_mask", nil, grid_height - grid_title_height + mask_added_height)
	self:_set_scenegraph_size("grid_scrollbar", nil, grid_height - grid_title_height - scrollbar_removed_height)
end

StoreItemDetailView._setup_item_price = function (self)
	self:_destroy_details()

	local is_owned, _ = self:_is_owned(self._items)
	local offer = self._store_item.offer

	if is_owned then
		local owned_item_text_style = table.clone(UIFontSettings.body)

		owned_item_text_style.text_horizontal_alignment = "center"
		owned_item_text_style.text_vertical_alignment = "center"
		owned_item_text_style.horizontal_alignment = "center"
		owned_item_text_style.vertical_alignment = "center"
		owned_item_text_style.offset = {
			0,
			0,
			2,
		}
		owned_item_text_style.text_color = Color.terminal_text_header(255, true)

		local owned_pass = {
			{
				pass_type = "text",
				style_id = "text",
				value_id = "text",
				style = owned_item_text_style,
				value = string.format("%s ", Localize("loc_premium_store_owned_note")),
			},
		}
		local owned_definition = UIWidget.create_definition(owned_pass, "details_pivot")
		local owned_widget = self:_create_widget("detail_widget", owned_definition)
		local content = owned_widget.content
		local style = owned_widget.style
		local text_options = UIFonts.get_font_options_by_style(style.text)
		local text_width, text_height = self:_text_size(owned_widget.content.text, style.text.font_type, style.text.font_size, {
			1920,
			1080,
		}, text_options)
		local extra_width = 10

		content.size = {
			text_width + extra_width,
			text_height,
		}
		self._details_widget = owned_widget

		self:_set_scenegraph_size("details_pivot", text_width + extra_width, text_height)
	else
		local price_pass = Definitions.price_text_definition
		local price_definition = UIWidget.create_definition(price_pass, "details_pivot", nil, {
			560,
			80,
		})
		local price_widget = self:_create_widget("detail_widget", price_definition)
		local price_data = offer.price.amount
		local type = price_data.type
		local price = price_data.amount
		local price_text = Text.format_currency(price)
		local wallet_settings = WalletSettings[type]
		local content = price_widget.content
		local style = price_widget.style

		content.price_text = price_text
		content.texture = wallet_settings.icon_texture_small
		style.price_text.material = wallet_settings.font_gradient_material

		local text_options = UIFonts.get_font_options_by_style(style.price_text)
		local text_width, text_height = self:_text_size(price_text, style.price_text.font_type, style.price_text.font_size, {
			1920,
			1080,
		}, text_options)
		local margin = 5
		local total_width = text_width + margin + style.texture.size[1]

		content.size = {
			total_width,
			text_height,
		}
		self._details_widget = price_widget

		self:_set_scenegraph_size("details_pivot", total_width, text_height)
	end
end

StoreItemDetailView._setup_bundle_button = function (self)
	self:_destroy_details()

	local bundle_pass = Definitions.bundle_button_definition
	local size = {
		542,
		160,
	}
	local bundle_definition = UIWidget.create_definition(bundle_pass, "details_pivot", nil, size)
	local bundle_widget = self:_create_widget("detail_widget", bundle_definition)
	local content = bundle_widget.content
	local style = bundle_widget.style

	content.hotspot.pressed_callback = function ()
		self:cb_on_bundle_pressed()
	end

	local icon_style = style.icon

	icon_style.material_values.texture_map = self._bundle_image and self._bundle_image.texture

	local image_size = {
		1720,
		1580,
	}
	local image_ratio = image_size[2] / image_size[1]
	local bundle_image_height = image_ratio * size[1]
	local top_padding_to_trim = 240
	local image_uv_height = size[2] / bundle_image_height
	local uv_trim_top = top_padding_to_trim / image_size[2]

	icon_style.uvs[1][2] = uv_trim_top
	icon_style.uvs[2][2] = image_uv_height + uv_trim_top

	local offer = self._store_item.offer
	local price_data = offer.price.amount
	local type = price_data.type
	local price = price_data.amount
	local price_text = Text.format_currency(price)

	content.has_price_tag = true
	content.price_text = price_text

	local wallet_settings = WalletSettings[type]

	content.wallet_icon = wallet_settings.icon_texture_small

	local price_text_style = style.price_text

	price_text_style.material = wallet_settings.font_gradient_material

	local is_owned, owned_items = self:_is_owned(self._items)
	local owned_count = owned_items and #owned_items or 0
	local total_count = #self._items

	if owned_count and total_count and total_count > 0 then
		content.owned = is_owned and "" or nil
	end

	if offer.discount then
		style.discount_price.text_color = Color.terminal_text_body(255, true)
		content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", Text.format_currency(offer.discount))
	else
		content.discount_price = ""
	end

	local icon_margin = 0
	local discount_margin = 10
	local texture_width = style.wallet_icon.size[1]
	local price_style_options = UIFonts.get_font_options_by_style(price_text_style)
	local text_width, _ = self:_text_size(content.price_text, price_text_style.font_type, price_text_style.font_size, {
		1920,
		1080,
	}, price_style_options)

	price_text_style.offset[1] = -texture_width - icon_margin
	style.discount_price.offset[1] = price_text_style.offset[1] - text_width - discount_margin

	local localized_text = Localize("loc_premium_store_bundle_button_title")

	content.title = string.format(localized_text, offer.sku.name)

	local acquire_text = Localize("loc_premium_store_bundle_button_subtitle")

	content.description = not is_owned and string.format(acquire_text, total_count) or ""

	local localized_string = Localize("loc_premium_store_bundle_items_owned")

	content.owned_items = owned_count > 0 and owned_count < #offer.bundleInfo and string.format(localized_string, owned_count, #offer.bundleInfo) or ""

	local title_style = style.title
	local title_max_width = (title_style.size and title_style.size[1] or size[1]) + (title_style.size_addition and title_style.size_addition[1] or 0)
	local description_max_width = (style.description.size and style.description.size[1] or size[1]) + (style.description.size_addition and style.description.size_addition[1] or 0)
	local title_style_options = UIFonts.get_font_options_by_style(title_style)
	local _, title_height = self:_text_size(content.title, title_style.font_type, title_style.font_size, {
		title_max_width,
		1080,
	}, title_style_options)
	local description_style_options = UIFonts.get_font_options_by_style(style.description)
	local _, description_height = self:_text_size(content.description, style.description.font_type, style.description.font_size, {
		description_max_width,
		1080,
	}, description_style_options)
	local description_margin = 5
	local total_size = title_height + description_margin + description_height

	title_style.offset[2] = -(total_size * 0.5) + title_height * 0.5 - style.price_background.size[2] * 0.5
	style.description.offset[2] = title_style.offset[2] + title_height * 0.5 + description_margin + description_height * 0.5
	content.size = size
	self._details_widget = bundle_widget
	self._widgets_by_name.grid_divider.content.visible = true
end

StoreItemDetailView._check_details_can_afford = function (self)
	local details_widget = self._details_widget
	local price_style = details_widget and details_widget.style.price_text

	if price_style then
		local price_amount = self._store_item.offer.price.amount
		local cost = price_amount.amount
		local currency = price_amount.type
		local can_afford = self:can_afford(cost, currency)
		local wallet_settings = WalletSettings[currency]

		price_style.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
	end
end

StoreItemDetailView._setup_description_grid = function (self, item)
	self:_destroy_description_grid()

	local description_text = Localize(item.description)
	local properties_text = Items.item_property_text(item, true)
	local restriction_text, present_restrictions = Items.restriction_text(item)

	if not present_restrictions then
		restriction_text = nil
	end

	local any_text = description_text or properties_text or restriction_text

	if not any_text then
		return
	end

	local widgets = {}
	local alignment_widgets = {}
	local scenegraph_id = "description_content_pivot"
	local max_width = self._ui_scenegraph.description_grid.size[1]

	local function _add_text_widget(pass_template, text)
		local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, {
			max_width,
			0,
		})
		local widget = self:_create_widget(string.format("description_grid_widget_%d", #widgets), widget_definition)

		widget.content.text = text

		local widget_text_style = widget.style.text
		local text_options = UIFonts.get_font_options_by_style(widget.style.text)
		local _, text_height = self:_text_size(text, widget_text_style.font_type, widget_text_style.font_size, {
			max_width,
			math.huge,
		}, text_options)

		widget.content.size[2] = text_height
		widgets[#widgets + 1] = widget
		alignment_widgets[#alignment_widgets + 1] = widget
	end

	local function _add_spacing(height)
		widgets[#widgets + 1] = nil
		alignment_widgets[#alignment_widgets + 1] = {
			size = {
				max_width,
				height,
			},
		}
	end

	local desired_spacing = 50

	if description_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.text_description_pass_template, description_text)

		desired_spacing = 80
	end

	if properties_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.item_sub_title_pass, Utf8.upper(Localize("loc_item_property_header")))
		_add_spacing(10)
		_add_text_widget(Definitions.item_text_pass, properties_text)

		desired_spacing = 50
	end

	if restriction_text then
		if #widgets > 0 then
			_add_spacing(desired_spacing)
		end

		_add_text_widget(Definitions.item_sub_title_pass, Utf8.upper(Localize("loc_item_equippable_on_header")))
		_add_spacing(10)
		_add_text_widget(Definitions.item_text_pass, restriction_text)
	end

	if #widgets > 0 then
		_add_spacing(10)
	end

	self._description_grid_widgets = widgets
	self._description_grid_alignment_widgets = alignment_widgets

	local grid_scenegraph_id = "description_grid"
	local grid_pivot_scenegraph_id = "description_content_pivot"
	local grid_spacing = {
		0,
		0,
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
	local items = self._items

	for index = 1, #items do
		local entry = items[index]
		local item = entry.item

		if item then
			local widget_suffix = "entry_" .. tostring(index)
			local scenegraph_id = "grid_content_pivot"
			local element = self:_generate_element_from_item(entry)
			local is_owned = self:_is_item_owned(entry)

			element.item_index = index
			element.total_count = 1
			element.owned_count = is_owned and 1 or 0
			element.entry = entry
			element.offer = entry.offer

			local widget_type = "gear_item"
			local ui_renderer = self._ui_renderer
			local widget
			local template = self._content_blueprints[widget_type]
			local size = template.size_function and template.size_function(self, element, ui_renderer) or template.size
			local pass_template_function = template.pass_template_function
			local pass_template = pass_template_function and pass_template_function(self, element, ui_renderer) or template.pass_template
			local optional_style_function = template.style_function
			local optional_style = optional_style_function and optional_style_function(self, element, size) or template.style
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

			local profile = self:_generic_profile_from_item(item)

			profile.loadout[item.slots[1]] = item
			element.dummy_profile = profile

			if widget then
				widgets[#widgets + 1] = widget
				alignment_widgets[#alignment_widgets + 1] = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					size = size,
					name = widget.name,
				}
			else
				widgets[#widgets + 1] = nil
				alignment_widgets[#alignment_widgets + 1] = {
					size = size,
				}
			end
		end
	end

	local num_items_text = string.format(Localize("loc_premium_store_items_in_collection"), #items)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.grid_title.content.text = num_items_text
	self._grid_widgets = widgets
	self._grid_alignment_widgets = alignment_widgets

	local grid_scenegraph_id = "grid_background"
	local grid_pivot_scenegraph_id = "grid_content_pivot"
	local grid_spacing = {
		10,
		10,
	}
	local grid_direction = "down"
	local use_is_focused_for_navigation = true
	local grid = UIWidgetGrid:new(self._grid_widgets, self._grid_alignment_widgets, self._ui_scenegraph, grid_scenegraph_id, grid_direction, grid_spacing, nil, use_is_focused_for_navigation)

	self._grid = grid

	local grid_scrollbar_widget_id = "grid_scrollbar"
	local scrollbar_widget = widgets_by_name[grid_scrollbar_widget_id]

	grid:assign_scrollbar(scrollbar_widget, grid_pivot_scenegraph_id, grid_scenegraph_id)

	local initial_scroll = self._current_scrollbar_progress or 0

	self._current_scrollbar_progress = nil

	grid:set_scroll_step_length(100)
	grid:set_scrollbar_progress(initial_scroll)
end

StoreItemDetailView.set_expire_time = function (self, time, widget)
	local timer_text = time and Text.format_time_span_long_form_localized(time) or ""

	widget.content.text = timer_text
end

StoreItemDetailView.cb_on_item_pressed = function (self, widget, element)
	if self._selected_element == element then
		return
	end

	self._selected_element = element

	local grid = self._grid
	local index = grid:index_by_widget(widget)

	grid:select_grid_index(nil, nil, nil, true)
	grid:select_grid_index(index)

	self._last_grid_index = nil
	self._details_widget.content.hotspot.is_selected = false

	if not Managers.ui:using_cursor_navigation() then
		local scrollbar_animation_progress = grid:get_scrollbar_percentage_by_index(index)

		grid:set_scrollbar_progress(scrollbar_animation_progress)
	end

	self:_present_current_element()
	self:_update_purchase_buttons()
end

StoreItemDetailView.cb_on_bundle_pressed = function (self)
	if self._selected_element == self._store_item then
		return
	end

	self._selected_element = self._store_item
	self._details_widget.content.hotspot.is_selected = true

	self._grid:select_grid_index(nil, nil, nil, true)
	self._grid:select_grid_index(nil)
	self:_present_current_element()
	self:_update_purchase_buttons()
end

StoreItemDetailView._present_bundle = function (self, offer)
	self:_destroy_profile()

	local widgets_by_name = self._widgets_by_name
	local bundle_background_widget = widgets_by_name.bundle_background
	local bundle_image = self._bundle_image

	if bundle_image then
		bundle_background_widget.style.bundle.material_values.texture_map = bundle_image.texture
	end

	local item_type_lookup = offer.description.type
	local item_type_display_name_localized = Items.type_display_name({
		item_type = item_type_lookup,
	})
	local item_size = {
		700,
		60,
	}
	local ui_renderer = self._ui_forward_renderer
	local scenegraph_id = "item_name_pivot"
	local widget_type = "item_name"
	local template = self._content_blueprints[widget_type]
	local title_item = {
		display_name = offer.sku.name or "",
		item_type = item_type_display_name_localized,
	}
	local config = {
		horizontal_alignment = "right",
		ignore_localization = true,
		use_store_appearance = true,
		vertical_alignment = "bottom",
		size = item_size,
		item = title_item,
	}
	local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
	local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
	local optional_style = template.style_function and template.style_function(self, config, size) or template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

	if widget_definition then
		local name = "item_name"
		local widget = self:_create_widget(name, widget_definition)

		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, config, nil, nil, ui_renderer)
		end

		self._item_name_widget = widget
	end

	local breed_name = self._presentation_profile and self._presentation_profile.archetype.breed or "human"
	local default_camera_settings = self._breeds_default_camera_settings[breed_name]

	self:_set_initial_viewport_camera_position(default_camera_settings)
end

StoreItemDetailView._present_item = function (self, item, visual_item)
	local slot_name = item.slots[1]

	self._selected_slot = ItemSlotSettings[slot_name]

	local item_type = item.item_type
	local preview_on_player = item_type ~= "WEAPON_RANGED" and item_type ~= "WEAPON_MELEE" and item_type ~= "WEAPON_SKIN" and item_type ~= "WEAPON_TRINKET"
	local valid_on_profile = self._profile_spawner and self:_is_spawn_profile_by_item_valid(item)

	if not preview_on_player or not valid_on_profile then
		self:_destroy_profile()
	end

	local set_initial_viewport = false

	if not preview_on_player then
		self._weapon_preview_show_original = false

		self:_setup_weapon_preview()
		self:_present_weapon(visual_item)

		set_initial_viewport = true
	elseif not self._profile_spawner then
		self:_generate_spawn_profile(item)

		self._spawn_player = true
		set_initial_viewport = true
	else
		self:_reset_mannequin(item)
	end

	if set_initial_viewport then
		local breed_name = self._presentation_profile and self._presentation_profile.archetype.breed or "human"
		local default_camera_settings = self._breeds_default_camera_settings[breed_name]

		self:_set_initial_viewport_camera_position(default_camera_settings)
	end

	if preview_on_player then
		local initial_rotation = 0

		if slot_name == "slot_gear_extra_cosmetic" then
			initial_rotation = math.pi
		end

		self._initial_rotation = initial_rotation

		if slot_name then
			self._mannequin_loadout[slot_name] = item

			local gear_loadout = self._gear_loadout

			if gear_loadout then
				gear_loadout[slot_name] = item
			end
		end

		self._previewed_gear_item_slot_name = slot_name

		self:_trigger_zoom_logic(self._spawn_player)
	end

	local item_size = {
		700,
		60,
	}
	local ui_renderer = self._ui_forward_renderer
	local scenegraph_id = "item_name_pivot"
	local widget_type = "item_name"
	local template = self._content_blueprints[widget_type]
	local title = item.display_name and Localize(item.display_name) or ""
	local sub_type = Items.type_display_name(item)
	local title_item = {
		display_name = title,
		item_type = sub_type,
	}
	local config = {
		horizontal_alignment = "right",
		ignore_localization = true,
		use_store_appearance = true,
		vertical_alignment = "bottom",
		size = item_size,
		item = title_item,
	}
	local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
	local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
	local optional_style = template.style_function and template.style_function(self, config, size) or template.style
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)

	if widget_definition then
		local name = "item_name"
		local widget = self:_create_widget(name, widget_definition)

		widget.type = widget_type

		local init = template.init

		if init then
			init(self, widget, config, nil, nil, ui_renderer)
		end

		self._item_name_widget = widget
	end
end

StoreItemDetailView._destroy_side_panel = function (self)
	local side_panel_widgets = self._side_panel_widgets
	local side_panel_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_count do
		local widget = side_panel_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._side_panel_widgets = nil
end

StoreItemDetailView._setup_side_panel = function (self, element)
	self:_destroy_side_panel()

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

	local offer = element.offer
	local item = element.item
	local is_bundle = not not offer.bundleInfo

	if is_bundle or not item then
		return
	end

	local properties_text = Items.item_property_text(item, true)
	local restrictions_text, present_restrictions = Items.restriction_text(item, true)

	if not present_restrictions then
		restrictions_text = nil
	end

	local any_text = restrictions_text or properties_text
	local should_display_side_panel = any_text and #self._items > 1

	if not should_display_side_panel then
		return
	end

	if properties_text then
		if #widgets > 0 then
			_add_spacing(24)
		end

		_add_text_widget(Definitions.premium_sub_title_pass, Utf8.upper(Localize("loc_item_property_header")))
		_add_spacing(8)
		_add_text_widget(Definitions.premium_text_pass, properties_text)
	end

	if restrictions_text then
		if #widgets > 0 then
			_add_spacing(24)
		end

		_add_text_widget(Definitions.item_sub_title_pass, Utf8.upper(Localize("loc_item_equippable_on_header")))
		_add_spacing(8)
		_add_text_widget(Definitions.item_text_pass, restrictions_text)
	end

	for i = 1, #widgets do
		local widget_offset = widgets[i].offset

		widget_offset[1] = 48
		widget_offset[2] = widget_offset[2] - y_offset
	end
end

local _inspect_on_multiple = {
	"WEAPON_SKIN",
	"GEAR_EXTRA_COSMETIC",
	"GEAR_HEAD",
	"GEAR_LOWERBODY",
	"GEAR_UPPERBODY",
}
local _inspect_on_single = {
	"WEAPON_SKIN",
	"GEAR_EXTRA_COSMETIC",
}

StoreItemDetailView._should_show_inspect = function (self, element)
	local offer = element.offer
	local is_bundle = not not offer.bundleInfo

	if is_bundle then
		return true
	end

	local item = element.item
	local item_type = item and item.item_type

	if not item_type then
		return false
	end

	local multiple_items = #self._items > 1
	local appropriate_list = multiple_items and _inspect_on_multiple or _inspect_on_single

	return table.array_contains(appropriate_list, item_type)
end

StoreItemDetailView._present_current_element = function (self)
	self:_destroy_weapon()
	self:_stop_previewing()

	local element = self._selected_element
	local widgets_by_name = self._widgets_by_name
	local bundle_background_widget = widgets_by_name.bundle_background

	bundle_background_widget.style.bundle.material_values.texture_map = nil

	local offer = element.offer
	local is_bundle = not not offer.bundleInfo

	if is_bundle then
		self:_present_bundle(offer)
	else
		self:_present_item(element.item, element.visual_item)
	end

	self:_setup_side_panel(element)

	self._valid_inspect = self:_should_show_inspect(element)
end

StoreItemDetailView.cb_on_weapon_skin_preview_pressed = function (self)
	self._weapon_preview_show_original = not self._weapon_preview_show_original

	local item

	if self._weapon_preview_show_original then
		item = MasterItems.get_item(self._selected_element.item.__master_item.preview_item)
	else
		item = self._selected_element.visual_item
	end

	self:_destroy_weapon_preview()
	self:_setup_weapon_preview()
	self:_present_weapon(item)
end

StoreItemDetailView._destroy_grid = function (self)
	if not self._grid then
		return
	end

	local grid_widgets = self._grid_widgets

	for i = 1, #grid_widgets do
		local widget = grid_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._grid = nil
	self._grid_widgets = nil
	self._grid_alignment_widgets = nil
end

StoreItemDetailView._destroy_description_grid = function (self)
	if not self._description_grid then
		return
	end

	local description_grid_widgets = self._description_grid_widgets

	for i = 1, #description_grid_widgets do
		local widget = description_grid_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._description_grid = nil
	self._description_grid_widgets = nil
	self._description_grid_alignment_widgets = nil
end

StoreItemDetailView._destroy_details = function (self)
	if not self._details_widget then
		return
	end

	self:_unregister_widget_name(self._details_widget.name)

	self._details_widget = nil
end

StoreItemDetailView._generic_profile_from_item = function (self, item)
	local profile = self._profile
	local item_gender, item_breed, item_archetype

	if profile then
		local wanted_gender = profile.gender
		local item_genders = item.genders

		if item_genders and not table.is_empty(item_genders) then
			item_gender = table.array_contains(item_genders, wanted_gender) and wanted_gender
		else
			item_gender = wanted_gender
		end

		local wanted_breed = profile.archetype.breed
		local item_breeds = item.breeds

		if item_breeds and not table.is_empty(item_breeds) then
			item_breed = table.array_contains(item_breeds, wanted_breed) and wanted_breed
		else
			item_breed = wanted_breed
		end

		local wanted_archetype = profile.archetype
		local item_archetypes = item.archetypes

		if item_archetypes and not table.is_empty(item_archetypes) then
			item_archetype = table.array_contains(item_archetypes, wanted_archetype.name) and wanted_archetype
		else
			item_archetype = wanted_archetype
		end
	end

	local dummy_profile
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
			gender = gender,
		}
	end

	return dummy_profile
end

StoreItemDetailView._generate_spawn_profile = function (self, item)
	local profile

	if item then
		profile = self:_generic_profile_from_item(item)
	else
		local player = self:_player()

		profile = player:profile()
	end

	self._preview_profile = profile
	self._mannequin_loadout = self:_generate_mannequin_loadout(profile, item)
	self._default_mannequin_loadout = table.clone_instance(self._mannequin_loadout)
	self._mannequin_profile = table.clone_instance(profile)
	self._mannequin_profile.loadout = self._mannequin_loadout

	local player = self:_player()
	local player_profile = player:profile()

	if player_profile and player_profile.archetype.name == profile.archetype.name then
		local gear_profile = table.clone_instance(player_profile)

		self._default_gear_loadout = table.clone_instance(gear_profile.loadout)
		self._gear_loadout = table.clone_instance(gear_profile.loadout)
		gear_profile.loadout = self._gear_loadout
		gear_profile.character_id = "cosmetics_view_character"
		self._gear_profile = gear_profile
		self._can_preview_with_gear = true
	else
		self._can_preview_with_gear = false
	end

	self._presentation_profile = self._mannequin_profile
	self._spawned_profile = nil
end

StoreItemDetailView._is_spawn_profile_by_item_valid = function (self, item)
	local current_profile = self._preview_profile

	if not current_profile then
		local player = self:_player()

		current_profile = player:profile()
	end

	local required_profile = self:_generic_profile_from_item(item)
	local same_breed = required_profile.archetype.breed == current_profile.archetype.breed
	local same_gender = required_profile.gender == current_profile.gender
	local same_archetype = required_profile.archetype.name == current_profile.archetype.name

	return same_breed and same_gender and same_archetype
end

StoreItemDetailView._generate_mannequin_loadout = function (self, profile, optional_item)
	local presentation_profile = profile
	local gender_name = presentation_profile.gender
	local archetype = presentation_profile.archetype
	local breed_name = archetype.breed
	local new_loadout = {}
	local item_slot = optional_item and optional_item.slots[1]
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]
	local required_items = required_gender_item_names_per_slot and (required_gender_item_names_per_slot[item_slot] or required_gender_item_names_per_slot.default)

	if required_items then
		for slot_name, slot_item_name in pairs(required_items) do
			local item_definition = MasterItems.get_item(slot_item_name)

			if item_definition then
				local slot_item = table.clone(item_definition)

				new_loadout[slot_name] = slot_item
			end
		end
	end

	return new_loadout
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
	local level_settings = StoreItemDetailViewSettings.level_settings
	local breeds_item_camera_by_slot_id = {}

	self._breeds_item_camera_by_slot_id = breeds_item_camera_by_slot_id

	local breeds_default_camera_settings = {}

	self._breeds_default_camera_settings = breeds_default_camera_settings

	local starting_camera_unit

	for breed_name, settings in pairs(Breeds) do
		local is_player = settings.breed_type == "player"

		if is_player then
			local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

			self[default_camera_event_id] = function (self, camera_unit)
				local camera_position = Unit.world_position(camera_unit, 1)
				local camera_rotation = Unit.world_rotation(camera_unit, 1)

				breeds_default_camera_settings[breed_name] = {
					camera_unit = camera_unit,
					original_position_boxed = Vector3Box(camera_position),
					original_rotation_boxed = QuaternionBox(camera_rotation),
				}

				self:_unregister_event(default_camera_event_id)

				if not starting_camera_unit then
					starting_camera_unit = camera_unit
				end
			end

			self:_register_event(default_camera_event_id)

			for slot_name, slot in pairs(ItemSlotSettings) do
				local is_gear = slot.slot_type == "gear"

				if is_gear then
					local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

					self[item_camera_event_id] = function (self, camera_unit)
						if not breeds_item_camera_by_slot_id[breed_name] then
							breeds_item_camera_by_slot_id[breed_name] = {}
						end

						breeds_item_camera_by_slot_id[breed_name][slot_name] = camera_unit

						self:_unregister_event(item_camera_event_id)
					end

					self:_register_event(item_camera_event_id)
				end
			end
		end
	end

	self:_register_event("event_register_cosmetics_preview_character_spawn_point")

	local world_name = level_settings.world_name
	local world_layer = level_settings.world_layer
	local world_timer_name = StoreItemDetailViewSettings.timer_name

	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name, self.view_name)

	local level_name = level_settings.level_name

	self._world_spawner:spawn_level(level_name)
	self:_setup_viewport_camera(starting_camera_unit)
end

StoreItemDetailView.on_resolution_modified = function (self)
	StoreItemDetailView.super.on_resolution_modified(self)

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
	local world_spawner = self._world_spawner

	world_spawner:set_viewport_size(w_scale, h_scale)
	world_spawner:set_viewport_position(x_scale, y_scale)
end

StoreItemDetailView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	local context = self._context

	if context then
		context.spawn_point_unit = spawn_point_unit
	end
end

StoreItemDetailView._setup_viewport_camera = function (self, camera_unit)
	local world_spawner = self._world_spawner

	if not world_spawner then
		self._pending_viewport_camera_unit = camera_unit

		return
	end

	local level_settings = StoreItemDetailViewSettings.level_settings
	local viewport_name = level_settings.viewport_name
	local viewport_type = level_settings.viewport_type
	local viewport_layer = level_settings.viewport_layer
	local shading_environment = level_settings.shading_environment

	world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)
	self:_trigger_zoom_logic(true)
end

StoreItemDetailView.cb_on_preview_with_gear_toggled = function (self, id, input_pressed, instant)
	self._previewed_with_gear = not self._previewed_with_gear
	self._presentation_profile = self._previewed_with_gear and self._gear_profile or self._mannequin_profile
	self._spawn_player = true
	self._keep_current_rotation = true

	self:_play_sound(UISoundEvents.cosmetics_vendor_show_with_gear)
end

StoreItemDetailView._stop_previewing = function (self)
	self:_reset_mannequin()

	local loadout = self._gear_loadout
	local default_loadout = self._default_gear_loadout

	if loadout and default_loadout then
		table.clear(loadout)

		for key, value in pairs(default_loadout) do
			loadout[key] = value
		end
	end

	if self._item_name_widget then
		self:_unregister_widget_name(self._item_name_widget.name)

		self._item_name_widget = nil
	end
end

StoreItemDetailView._reset_mannequin = function (self, optional_item)
	local mannequin_loadout = self._mannequin_loadout

	if not mannequin_loadout then
		return
	end

	local default_mannequin_loadout = self._default_mannequin_loadout

	for key, _ in pairs(mannequin_loadout) do
		mannequin_loadout[key] = default_mannequin_loadout[key]
	end

	local profile = self._presentation_profile
	local archetype = profile and profile.archetype
	local breed_name = profile and archetype.breed or ""
	local gender_name = profile and profile.gender or ""
	local item_slot = optional_item and optional_item.slots[1]
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_per_slot_by_breed_and_gender[breed_name]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]
	local required_items = required_gender_item_names_per_slot and (required_gender_item_names_per_slot[item_slot] or required_gender_item_names_per_slot.default)

	if required_items then
		for slot_name, slot_item_name in pairs(required_items) do
			local item_definition = MasterItems.get_item(slot_item_name)

			if item_definition then
				local slot_item = table.clone(item_definition)

				mannequin_loadout[slot_name] = slot_item
			end
		end
	end
end

StoreItemDetailView._can_zoom = function (self)
	local item_type = table.nested_get(self, "_selected_element", "item", "item_type")

	return self._zoom_delay == 0 and (item_type == "GEAR_EXTRA_COSMETIC" or item_type == "GEAR_HEAD" or item_type == "GEAR_LOWERBODY" or item_type == "GEAR_UPPERBODY") and not self._aquilas_showing
end

StoreItemDetailView._can_preview_voice = function (self)
	local has_profile = self._preview_profile and self._previewed_with_gear
	local voice_fx_key = table.nested_get(self, "_selected_element", "item", "voice_fx_preset")
	local has_voice_fx = voice_fx_key and voice_fx_key ~= "voice_fx_rtpc_none"

	return not self._aquilas_showing and has_profile and has_voice_fx
end

StoreItemDetailView._stop_current_voice = function (self)
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

StoreItemDetailView.cb_preview_voice = function (self)
	local voice_fx_preset_key = table.nested_get(self, "_selected_element", "item", "voice_fx_preset")
	local voice_fx_preset_rtcp = VoiceFxPresetSettings[voice_fx_preset_key]

	if not voice_fx_preset_key then
		return
	end

	local personality_key = table.nested_get(self, "_profile", "lore", "backstory", "personality")
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

StoreItemDetailView._trigger_zoom_logic = function (self, instant, optional_slot_name)
	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name

	if not selected_slot_name then
		return
	end

	local func_ptr = math.easeCubic
	local profile = self._presentation_profile
	local archetype = profile and profile.archetype
	local breed_name = profile and archetype.breed or ""
	local duration = instant and 0 or 0.4

	self._zoom_delay = duration

	self:_set_camera_item_slot_focus(breed_name, selected_slot_name, duration, func_ptr, self._zoom_level)
end

StoreItemDetailView._set_camera_item_slot_focus = function (self, breed_name, slot_name, time, func_ptr, zoom_percentage)
	local world_spawner = self._world_spawner
	local breeds_item_camera_by_slot_id = self._breeds_item_camera_by_slot_id
	local breed_item_camera_by_slot_id = breeds_item_camera_by_slot_id[breed_name]
	local slot_camera = breed_item_camera_by_slot_id and breed_item_camera_by_slot_id[slot_name]

	world_spawner:interpolate_to_camera(slot_camera, zoom_percentage, time, func_ptr)
end

StoreItemDetailView._set_initial_viewport_camera_position = function (self, default_camera_settings)
	local world_spawner = self._world_spawner
	local camera_unit = default_camera_settings.camera_unit
	local default_camera_position_boxed = default_camera_settings.original_position_boxed
	local default_camera_rotation_boxed = default_camera_settings.original_rotation_boxed

	world_spawner:change_camera_unit(camera_unit)

	local camera_world_position = default_camera_position_boxed:unbox()
	local camera_world_rotation = default_camera_rotation_boxed:unbox()

	world_spawner:set_camera_position(camera_world_position)
	world_spawner:set_camera_rotation(camera_world_rotation)
end

StoreItemDetailView.on_exit = function (self)
	self._promise_container:delete()
	self:_stop_current_voice()
	self:_destroy_profile()
	self:_destroy_side_panel()

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

	if self._popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._popup_id)
	end

	self:_unload_url_textures()

	local parent = self._context.parent

	if parent and parent._update_wallets then
		parent:_update_wallets()
	end

	local has_purchased_item = self._has_purchased_item

	if has_purchased_item then
		Managers.event:trigger("event_force_refresh_inventory")
	end

	if self._dlc_info_popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._dlc_info_popup_id)

		self._dlc_info_popup_id = nil
	end

	StoreItemDetailView.super.on_exit(self)
end

StoreItemDetailView._handle_input = function (self, input_service)
	if self._activate_navigation_next_frame then
		self._activate_navigation_next_frame = nil

		self._grid:set_handle_grid_navigation(true)
	end

	if not self._using_cursor_navigation then
		self._reset_navigation = true

		if self._aquilas_showing then
			local new_selection_index, new_selection_row

			if input_service:get("navigate_up_continuous") and self._selected_aquila_row then
				new_selection_row = self._selected_aquila_row > 1 and "up"
			elseif input_service:get("navigate_down_continuous") and self._selected_aquila_row then
				new_selection_row = self._selected_aquila_row < (self._aquilas_navigation_data and self._aquilas_navigation_data.num_rows or self._selected_aquila_row) and "down"
			elseif input_service:get("navigate_left_continuous") and self._selected_aquila_index then
				new_selection_index = self._selected_aquila_index > 1 and self._selected_aquila_index - 1
			elseif input_service:get("navigate_right_continuous") and self._selected_aquila_index then
				new_selection_index = self._selected_aquila_index < (self._aquilas_navigation_data and self._aquilas_navigation_data.total_widgets or self._selected_aquila_index) and self._selected_aquila_index + 1
			end

			if new_selection_index then
				self:_select_aquila_widget_by_index(new_selection_index)
			elseif new_selection_row then
				self:_select_aquila_widget_by_row(new_selection_row)
			end
		elseif self._selected_grid_index and input_service:get("navigate_up_continuous") then
			if self._details_widget.content.hotspot and not self._grid:can_move_vertical("up") then
				self._last_grid_index = self._selected_grid_index

				self._grid:set_handle_grid_navigation(false)
				self:cb_on_bundle_pressed()
			end
		elseif input_service:get("navigate_down_continuous") and self._selected_element == self._store_item then
			if self._grid then
				self._selected_grid_index = self._last_grid_index or 1

				self._grid:select_grid_index(self._selected_grid_index)

				local widget = self._grid_widgets[self._selected_grid_index]

				self:cb_on_item_pressed(widget, widget.content.element)
				self._grid:set_handle_grid_navigation(false)

				self._activate_navigation_next_frame = true
			end
		elseif self._widgets_by_name.purchase_item_button.content.visible == true and not self._widgets_by_name.purchase_item_button.content.hotspot.disabled and input_service:get("confirm_pressed") then
			self._widgets_by_name.purchase_item_button.content.hotspot.pressed_callback()
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
		self:_select_aquila_widget_by_index()
	end
end

StoreItemDetailView._update_zoom_logic = function (self, dt, input_service)
	self._zoom_delay = math.max(self._zoom_delay - dt, 0)

	if not self:_can_zoom() then
		return
	end

	local scroll_axis = input_service:get("scroll_axis")
	local scroll_delta = scroll_axis and scroll_axis[2] or 0
	local description_scroll_content = self._widgets_by_name.description_scrollbar.content
	local grid_scroll_content = self._widgets_by_name.grid_scrollbar.content

	if description_scroll_content.in_scroll_area or grid_scroll_content.in_scroll_area then
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
		self:_trigger_zoom_logic(true)
	end
end

StoreItemDetailView.update = function (self, dt, t, input_service)
	local has_promise = self._store_promise or self._purchase_promise or self._wallet_promise

	self._show_loading = not not has_promise

	if self._show_loading then
		input_service = input_service:null_service()
	end

	local spawn_profile = self._spawn_player and self._spawn_point_unit

	if spawn_profile then
		local profile = self._presentation_profile
		local initial_rotation = self._initial_rotation
		local disable_rotation_input = self._disable_rotation_input
		local keep_current_rotation = self._keep_current_rotation

		self:_spawn_profile(profile, initial_rotation, disable_rotation_input, keep_current_rotation)

		self._keep_current_rotation = nil
		self._spawn_player = false
	end

	self:_update_zoom_logic(dt, input_service)

	local profile_spawner = self._profile_spawner

	if profile_spawner then
		profile_spawner:update(dt, t, input_service)
	end

	local world_spawner = self._world_spawner

	if world_spawner then
		world_spawner:update(dt, t)
	end

	if self._should_expire then
		local widgets_by_name = self._widgets_by_name
		local timer_widget = widgets_by_name.timer_widget
		local offer = self._store_item.offer
		local time_remaining = self._context.parent:_set_expire_time(offer)

		if not time_remaining then
			local purchase_button = widgets_by_name.purchase_item_button

			purchase_button.content.hotspot.disabled = true

			if self.closing_view then
				return
			end

			local view_name = self.view_name

			Managers.ui:close_view(view_name)

			self._should_expire = false
		else
			timer_widget.content.text = time_remaining
		end
	end

	self:_check_details_can_afford()

	local wallet_width = self._wallet_element:get_size()[1]

	if wallet_width ~= self._wallet_width then
		self._wallet_width = wallet_width

		local corner_right = self._widgets_by_name.corner_top_right

		if not corner_right.content.original_size then
			local corner_width, corner_height = self:_scenegraph_size("corner_top_right")

			corner_right.content.original_size = {
				corner_width,
				corner_height,
			}
		end

		local corner_width = corner_right.content.original_size[1]
		local total_corner_width = wallet_width + corner_width

		self:_set_scenegraph_size("corner_top_right", total_corner_width, nil)
	end

	return StoreItemDetailView.super.update(self, dt, t, input_service)
end

StoreItemDetailView._update_grid_widgets = function (self, dt, t, input_service)
	local grid = self._grid
	local widgets = self._grid_widgets
	local widget_count = widgets and #widgets or 0

	for i = 1, widget_count do
		local widget = widgets[i]
		local content = widget.content
		local visible = grid:is_widget_visible(widget)

		content.visible = visible

		local widget_type = widget.type
		local template = self._content_blueprints[widget_type]
		local update = template and template.update

		if update then
			update(self, widget, input_service, dt, t)
		end
	end
end

StoreItemDetailView._update_grid_widgets_visibility = function (self)
	local widgets = self._grid_widgets
	local widget_count = widgets and #widgets or 0
	local ui_renderer = self._ui_offscreen_renderer
	local blueprints = self._content_blueprints

	for i = 1, widget_count do
		local widget = widgets[i]
		local widget_type = widget.type
		local template = blueprints[widget_type]

		if template then
			local content = widget.content
			local element = content.element
			local visible = content.visible
			local unload_function = template.unload_icon

			if not visible and unload_function then
				unload_function(self, widget, element, ui_renderer)
			end
		end
	end

	for i = 1, widget_count do
		local widget = widgets[i]
		local widget_type = widget.type
		local template = blueprints[widget_type]

		if template then
			local content = widget.content
			local element = content.element
			local visible = content.visible
			local load_function = template.load_icon

			if visible and load_function then
				load_function(self, widget, element, ui_renderer, element.dummy_profile)
			end
		end
	end
end

StoreItemDetailView._spawn_profile = function (self, profile, initial_rotation, disable_rotation_input, keep_current_rotation)
	local current_rotation_angle

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
	end

	if current_rotation_angle or initial_rotation then
		local instant = true
		local rotation = (initial_rotation or 0) + (current_rotation_angle or 0)

		self._profile_spawner:set_character_rotation(rotation, instant)
	end

	if disable_rotation_input then
		self._profile_spawner:disable_rotation_input()
	end

	local spawn_position = Unit.world_position(self._spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(self._spawn_point_unit, 1)

	self._profile_spawner:spawn_profile(profile, spawn_position, spawn_rotation)

	self._spawned_profile = profile
end

StoreItemDetailView.cb_on_close_pressed = function (self)
	if self.closing_view then
		return
	end

	if self._aquilas_showing then
		self:_update_wallets()
		self:_destroy_aquilas_presentation()
		self:_show_elements()

		self._aquilas_showing = false
	else
		local view_name = self.view_name

		Managers.ui:close_view(view_name)
	end

	self:_play_sound(UISoundEvents.default_menu_exit)
end

StoreItemDetailView._hide_elements = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.grid_title.content.visible = false
	widgets_by_name.title.content.visible = false
	widgets_by_name.background.content.visible = false
	widgets_by_name.grid_scrollbar.content.visible = false
	widgets_by_name.description_scrollbar.content.visible = false
	widgets_by_name.timer_widget.content.visible = false
	widgets_by_name.bundle_background.content.visible = false

	self:_destroy_grid()
	self:_destroy_description_grid()
	self:_destroy_details()
	self:_destroy_price_presentation()
	self:_destroy_side_panel()

	local item_name_widget = self._item_name_widget

	if item_name_widget then
		item_name_widget.content.visible = false
	end

	widgets_by_name.purchase_item_button.content.visible = false
	widgets_by_name.owned_info_text.content.visible = false
	widgets_by_name.grid_divider.content.visible = false
end

StoreItemDetailView._show_elements = function (self)
	local widgets_by_name = self._widgets_by_name

	widgets_by_name.grid_title.content.visible = true
	widgets_by_name.title.content.visible = true
	widgets_by_name.background.content.visible = true
	widgets_by_name.grid_scrollbar.content.visible = true
	widgets_by_name.description_scrollbar.content.visible = true
	widgets_by_name.timer_widget.content.visible = true
	widgets_by_name.bundle_background.content.visible = true

	local item_name_widget = self._item_name_widget

	if item_name_widget then
		item_name_widget.content.visible = true
	end

	widgets_by_name.grid_title.content.visible = true
	widgets_by_name.grid_divider.content.visible = true

	self:_setup_item_presentation()
	self:_present_current_element()
	self:_update_purchase_buttons()
end

StoreItemDetailView.draw = function (self, dt, t, input_service, layer)
	local is_loading = self._show_loading

	if is_loading then
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
	local grid = self._grid

	if grid then
		grid:update(dt, t, input_service)
		self:_update_grid_widgets(dt, t, input_service)

		local current_scrollbar_progress = grid:scrollbar_progress()

		if self._current_scrollbar_progress ~= current_scrollbar_progress then
			self._current_scrollbar_progress = current_scrollbar_progress

			self:_update_grid_widgets_visibility()
		end

		local selected_grid_index = grid:selected_grid_index()
		local grid_widgets = self._grid_widgets

		if self._selected_grid_index ~= selected_grid_index and grid_widgets[selected_grid_index] then
			grid_widgets[selected_grid_index].content.hotspot.pressed_callback()
		end

		self._selected_grid_index = selected_grid_index
	end

	local description_grid = self._description_grid

	if description_grid then
		description_grid:update(dt, t, input_service)
	end

	UIRenderer.begin_pass(ui_forward_renderer, ui_scenegraph, input_service, dt, render_settings)
	self:_draw_widgets(dt, t, input_service, ui_forward_renderer)

	local wallet_widgets = self._wallet_widgets
	local wallet_widget_count = wallet_widgets and #wallet_widgets or 0

	for i = 1, wallet_widget_count do
		local widget = wallet_widgets[i]

		UIWidget.draw(widget, ui_forward_renderer)
	end

	local price_widgets = self._price_widgets
	local price_widget_count = wallet_widgets and #wallet_widgets or 0

	for i = 1, price_widget_count do
		local widget = price_widgets[i]

		UIWidget.draw(widget, ui_forward_renderer)
	end

	local aquilas_widgets = self._aquilas_widgets
	local aquilas_widget_count = aquilas_widgets and #aquilas_widgets or 0

	for i = 1, aquilas_widget_count do
		local widget = aquilas_widgets[i]

		UIWidget.draw(widget, ui_forward_renderer)
	end

	local side_panel_widgets = self._side_panel_widgets
	local side_panel_widget_count = side_panel_widgets and #side_panel_widgets or 0

	for i = 1, side_panel_widget_count do
		local widget = side_panel_widgets[i]

		UIWidget.draw(widget, ui_forward_renderer)
	end

	local loading_widget = self._loading_widget

	if loading_widget and self._show_loading then
		UIWidget.draw(loading_widget, ui_forward_renderer)
	end

	local details_widget = self._details_widget

	if details_widget then
		UIWidget.draw(details_widget, ui_forward_renderer)
	end

	local item_name_widget = self._item_name_widget

	if item_name_widget then
		UIWidget.draw(item_name_widget, ui_forward_renderer)
	end

	UIRenderer.end_pass(ui_forward_renderer)
	self:_draw_grid(dt, t, input_service)
	self:_draw_description_grid(dt, t, input_service)

	local weapon_preview = self._weapon_preview

	if weapon_preview then
		weapon_preview:draw(dt, t, ui_renderer, render_settings, input_service)
	end

	local input_legend_element = self._input_legend_element

	if input_legend_element then
		input_legend_element:draw(dt, t, ui_forward_renderer, render_settings, input_service)
	end

	local wallet_element = self._wallet_element

	if wallet_element then
		wallet_element:draw(dt, t, ui_forward_renderer, render_settings, input_service)
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
		height,
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
	if self._weapon_preview then
		return
	end

	local reference_name = "weapon_preview"
	local layer = 1

	self._weapon_preview = self:_add_element(ViewElementInventoryWeaponPreview, reference_name, layer, {
		draw_background = true,
		ignore_blur = true,
	})

	self:_update_weapon_preview_viewport()
end

StoreItemDetailView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if not weapon_preview then
		return
	end

	local width_scale, height_scale = 1, 1
	local x_scale, y_scale = 0, 0

	weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
	weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

	local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

	weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)
end

StoreItemDetailView._get_weapon_spawn_position_normalized = function (self)
	self:_force_update_scenegraph()

	local scale
	local pivot_world_position = self:_scenegraph_world_position("weapon_pivot", scale)
	local parent_world_position = self:_scenegraph_world_position("weapon_viewport", scale)
	local viewport_width, viewport_height = self:_scenegraph_size("weapon_viewport", scale)
	local scale_x = (pivot_world_position[1] - parent_world_position[1]) / viewport_width
	local scale_y = 1 - (pivot_world_position[2] - parent_world_position[2]) / viewport_height

	return scale_x, scale_y
end

StoreItemDetailView._destroy_weapon_preview = function (self)
	if not self._weapon_preview then
		return
	end

	local reference_name = "weapon_preview"

	self:_remove_element(reference_name)

	self._weapon_preview = nil
end

StoreItemDetailView._present_weapon = function (self, item)
	local disable_auto_spin = true

	self._can_preview_with_gear = false

	local weapon_preview = self._weapon_preview

	weapon_preview:present_item(item, disable_auto_spin)
	weapon_preview:center_align(0, {
		-0.5,
		-2,
		-0.2,
	})
	weapon_preview:set_force_allow_rotation(true)
end

StoreItemDetailView._destroy_weapon = function (self)
	self:_destroy_weapon_preview()
end

StoreItemDetailView._destroy_profile = function (self)
	if not self._profile_spawner then
		return
	end

	self._profile_spawner:destroy()

	self._profile_spawner = nil
end

StoreItemDetailView._destroy_price_presentation = function (self)
	local price_widgets = self._price_widgets

	if not price_widgets then
		return
	end

	for i = 1, #price_widgets do
		local widget = price_widgets[i]

		self:_unregister_widget_name(widget.name)
	end

	self._price_widgets = nil
end

StoreItemDetailView._update_price_presentation = function (self)
	local offer = self._store_offer_is_bundle and self._store_item.offer or self._selected_element.offer
	local price = offer.price and offer.price.amount

	if not price then
		return
	end

	local widgets_by_name = self._widgets_by_name
	local price_widget = widgets_by_name.price_item_text
	local content = price_widget.content
	local style = price_widget.style

	price_widget.content.element = offer
	content.discount_price = ""

	if offer.discount then
		style.discount_price.text_color = Color.terminal_text_body(255, true)
	end

	content.price = offer.owned and string.format("%s ", Localize("loc_item_owned")) or ""

	local discount_style_options = UIFonts.get_font_options_by_style(style.discount_price)
	local price_style_options = UIFonts.get_font_options_by_style(style.price)
	local discount_width, _ = self:_text_size(content.discount_price, style.discount_price.font_type, style.discount_price.font_size, {
		1920,
		1080,
	}, discount_style_options)
	local text_width, _ = self:_text_size(content.price, style.price.font_type, style.price.font_size, {
		1920,
		1080,
	}, price_style_options)
	local icon_margin = 0
	local discount_margin = 10
	local texture_width = style.price_icon.size[1]

	price_widget.style.price.offset[1] = -texture_width - icon_margin

	local total_width = icon_margin + texture_width + text_width

	if discount_width > 0 then
		total_width = total_width + discount_margin + discount_width
	end

	self:_set_scenegraph_size("price_item_text", total_width, nil)

	local wallet_settings = WalletSettings.aquilas
	local font_gradient_material = wallet_settings.font_gradient_material

	style.price.material = not offer.owned and font_gradient_material
	style.price.text_color = offer.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
	content.price_icon = nil

	local discount_banner_widget = widgets_by_name.promo
	local discount_content = discount_banner_widget.content
	local selected_element = self._selected_element

	if selected_element.offer.bundleInfo then
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

		widgets_by_name.promo.content.visible = not offer.owned
	end
end

local function get_item_type(type)
	local item_type_localization_key = UISettings.item_type_localization_lookup[Utf8.upper(type)]

	return item_type_localization_key and Localize(item_type_localization_key)
end

StoreItemDetailView._update_purchase_buttons = function (self)
	local selected_element = self._selected_element

	if not selected_element then
		return
	end

	local items = self._items
	local is_owned, owned_items = self:_is_owned(items)

	self._owned_items = owned_items

	local offer = self._store_item.offer
	local is_selected_item_owned = false

	if selected_element.offer.bundleInfo then
		is_selected_item_owned = is_owned

		local owned_skus = {}

		for i = 1, #owned_items do
			local owned_item = owned_items[i]
			local sku = owned_item.offer and owned_item.offer.sku and owned_item.offer.sku.id

			if sku then
				owned_skus[#owned_skus + 1] = sku
			end
		end

		offer.owned_skus = not table.is_empty(owned_skus) and owned_skus or nil
	else
		local selected_gear_id = selected_element.item.gear_id

		for i = 1, #owned_items do
			local owned_item = owned_items[i]

			if owned_item.item.gear_id == selected_gear_id then
				is_selected_item_owned = true

				break
			end
		end
	end

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.background.content.force_show_price = self._should_expire
	widgets_by_name.owned_info_text.content.visible = #self._items > 1 and is_selected_item_owned

	local purchase_item_button = widgets_by_name.purchase_item_button

	if self._current_archetype_available_promise and not self._current_archetype_available_promise:is_fulfilled() then
		self._current_archetype_available_promise:cancel()
	end

	local item_archetypes

	if not selected_element.offer.bundleInfo then
		local current_item = selected_element.item or items[selected_element.index].item

		item_archetypes = self:_get_item_archetypes(current_item)
	else
		item_archetypes = self:_get_bundle_archetypes(selected_element.offer)
	end

	local availability_promises = {}
	local all_promises_fulfilled = true

	for k, v in ipairs(item_archetypes) do
		local archetype_available_promise = v:is_available()

		all_promises_fulfilled = all_promises_fulfilled and archetype_available_promise:is_fulfilled()

		table.insert(availability_promises, archetype_available_promise)
	end

	if not all_promises_fulfilled then
		purchase_item_button.content.visible = false
		purchase_item_button.content.hotspot.disabled = true
	end

	if #availability_promises == 0 then
		table.insert(availability_promises, Promise.resolved({
			available = true,
		}))
	end

	local are_archetypes_available_promises = Promise.all(unpack(availability_promises))

	self._current_archetype_available_promise = are_archetypes_available_promises

	self._promise_container:cancel_on_destroy(are_archetypes_available_promises):next(function (is_archetype_available_results)
		local unavailable_archetype

		for _, result in ipairs(is_archetype_available_results) do
			if result.available then
				self:_setup_purchase_button_for_item(purchase_item_button, is_selected_item_owned, selected_element)

				return
			else
				unavailable_archetype = result.archetype
			end
		end

		self:_setup_purchase_button_for_dlc(purchase_item_button, unavailable_archetype)
	end)
end

StoreItemDetailView._get_item_archetypes = function (self, item)
	local item_archetypes = {}

	if not item.archetypes then
		return item_archetypes
	end

	for k, v in pairs(item.archetypes) do
		table.insert(item_archetypes, Archetypes[v])
	end

	return item_archetypes
end

StoreItemDetailView._get_bundle_archetypes = function (self, offer)
	local item_archetypes = {}
	local offer_items = Offer.extract_items(offer)

	for _, offer_item in ipairs(offer_items) do
		table.append(item_archetypes, self:_get_item_archetypes(offer_item.item))
	end

	item_archetypes = table.unique_array_values(item_archetypes)

	return item_archetypes
end

StoreItemDetailView._setup_purchase_button_for_dlc = function (self, purchase_item_button, archetype)
	self._widgets_by_name.dlc_required_text.content.visible = true

	local localized_dlc_name = Localize(archetype.dlc_settings.loc_name_generic)

	self._widgets_by_name.dlc_required_text.content.text = Localize("loc_dlc_required", true, {
		dlc_name = localized_dlc_name,
	})
	purchase_item_button.content.visible = true
	purchase_item_button.content.hotspot.disabled = false
	purchase_item_button.content.hotspot.pressed_callback = callback(self, "_cb_show_dlc_information_popup", purchase_item_button, archetype)

	local purchase_button_text = Utf8.upper(Localize("loc_dlc_cta"))

	purchase_item_button.content.original_text = purchase_button_text

	local purchase_item_button_style_options = UIFonts.get_font_options_by_style(purchase_item_button.style.text)
	local purchase_item_button_width, _ = self:_text_size(purchase_button_text, purchase_item_button.style.text.font_type, purchase_item_button.style.text.font_size, {
		1920,
		ButtonPassTemplates.default_button.size[2],
	}, purchase_item_button_style_options)

	self:_set_scenegraph_size("purchase_button", math.max(ButtonPassTemplates.default_button.size[1], purchase_item_button_width + 100), nil)
end

StoreItemDetailView._cb_show_dlc_information_popup = function (self, purchase_item_button, archetype)
	local localized_dlc_name = Localize(archetype.dlc_settings.loc_name_generic)
	local context = {
		description_text = "loc_dlc_store_popup_info",
		title_text = "loc_dlc_required",
		title_text_params = {
			dlc_name = localized_dlc_name,
		},
		description_text_params = {
			dlc_name = localized_dlc_name,
		},
		options = {
			{
				close_on_pressed = true,
				text = "loc_confirm",
				callback = callback(archetype, "acquire_callback", function (is_success)
					if is_success then
						self:_update_purchase_buttons()
					end
				end),
			},
			{
				close_on_pressed = true,
				hotkey = "back",
				text = "loc_dlc_store_popup_cancel",
			},
		},
	}

	Managers.telemetry_events:dlc_popup_opened(archetype.dlc_settings.telemetry_id)
	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._dlc_info_popup_id = id
	end)
end

StoreItemDetailView._setup_purchase_button_for_item = function (self, purchase_item_button, is_selected_item_owned, selected_element)
	self._widgets_by_name.dlc_required_text.content.visible = false
	purchase_item_button.content.visible = true
	purchase_item_button.content.hotspot.disabled = is_selected_item_owned
	purchase_item_button.content.visible = not is_selected_item_owned
	purchase_item_button.content.hotspot.pressed_callback = callback(self, "cb_on_purchase_pressed", "item")

	self:_update_price_presentation()

	local selected_offer = selected_element.offer
	local cost = selected_offer.price.amount.amount
	local currency = selected_offer.price.amount.type
	local can_afford = self:can_afford(cost, currency)
	local purchase_button_text

	if is_selected_item_owned then
		purchase_button_text = Utf8.upper(Localize("loc_item_owned"))
	elseif can_afford then
		local item_type_lookup = selected_offer.bundleInfo and selected_offer.description.type or selected_element.item.item_type
		local item_type = get_item_type(item_type_lookup) or ""

		purchase_button_text = Utf8.upper(string.format("%s %s", Localize("loc_premium_store_purchase_item"), item_type))
	else
		purchase_button_text = Utf8.upper(Localize("loc_premium_store_purchase_credits"))
	end

	purchase_item_button.content.original_text = purchase_button_text

	local purchase_item_button_style_options = UIFonts.get_font_options_by_style(purchase_item_button.style.text)
	local purchase_item_button_width, _ = self:_text_size(purchase_button_text, purchase_item_button.style.text.font_type, purchase_item_button.style.text.font_size, {
		1920,
		ButtonPassTemplates.default_button.size[2],
	}, purchase_item_button_style_options)

	self:_set_scenegraph_size("purchase_button", math.max(ButtonPassTemplates.default_button.size[1], purchase_item_button_width + 100), nil)
end

StoreItemDetailView._update_wallets = function (self)
	local wallet_element = self._wallet_element

	if not wallet_element then
		return Promise:resolved()
	end

	self._wallet_promise = wallet_element:update_wallets():next(function ()
		self._wallet_promise = nil

		self:_update_purchase_buttons()
	end):catch(function (error)
		self._wallet_promise = nil
	end)

	return self._wallet_promise
end

StoreItemDetailView.can_afford = function (self, cost, currency)
	local current_balance = self._wallet_element:get_amount_by_currency(currency)

	return cost <= current_balance
end

StoreItemDetailView._make_purchase = function (self, is_bundle, offer, wallet_data, purchased_items)
	self._has_purchased_item = true

	local purchase_button_widget = self._widgets_by_name.purchase_item_button

	self._purchase_promise = Managers.data_service.store:purchase_item_with_wallet(offer, wallet_data):next(function (_)
		if self._destroyed or not self._purchase_promise then
			return
		end

		local parent = self._context.parent

		parent:play_vo_events(StoreItemDetailViewSettings.vo_event_vendor_purchase, "purser_a", nil, 1.4)

		local update_store_page_promise = parent and parent._update_store_page and parent:_update_store_page() or Promise.resolved(nil)

		self._purchase_promise = update_store_page_promise:next(function (data)
			self._store_item = data or self._store_item

			return self:_update_wallets()
		end):next(function ()
			self._purchase_promise = nil

			if self.closing_view then
				return
			end

			self:_play_sound(UISoundEvents.aquilas_vendor_on_purchase)

			local condense_notifications = #purchased_items >= 3

			for i = 1, #purchased_items do
				local item_not_owned = purchased_items[i]
				local item = item_not_owned.item

				Items.mark_item_id_as_new(item, true)

				if not condense_notifications then
					Managers.event:trigger("event_add_notification_message", "item_granted", item)
				end
			end

			if condense_notifications then
				local message = Localize("loc_premium_store_notification_success_bundle", true, {
					item = offer.sku.name,
				})

				Managers.event:trigger("event_add_notification_message", "default", message, nil, UISoundEvents.notification_item_received_rarity_6)
			end

			local items = self._items
			local owned_items = self._owned_items

			if is_bundle or #items == 1 or #owned_items == #items then
				local view_name = self.view_name

				Managers.ui:close_view(view_name)
			else
				self:_setup_item_presentation()
				self:_present_current_element()
			end
		end):catch(function (error)
			self._purchase_promise = nil

			if self.closing_view then
				return
			end

			self:_update_purchase_buttons()

			if is_bundle or #self._items == 1 then
				local view_name = self.view_name

				Managers.ui:close_view(view_name)
			else
				self:_setup_item_presentation()
				self:_present_current_element()
			end
		end)
	end):catch(function (error)
		purchase_button_widget.content.hotspot.disabled = false

		local notification_string = Localize("loc_premium_store_notification_fail")

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = notification_string,
		})

		self._popup_id = nil
		self._purchase_promise = nil

		self:_update_purchase_buttons()
	end)
end

StoreItemDetailView.cb_on_purchase_pressed = function (self)
	local selected_element = self._selected_element
	local offer = selected_element.offer
	local item_name, item_type
	local is_bundle = not not selected_element.offer.bundleInfo

	if not is_bundle then
		local sub_type = selected_element.item.item_type
		local item_type_display_name_localized = Items.type_display_name({
			item_type = sub_type,
		})

		item_name = Localize(selected_element.item.display_name)
		item_type = item_type_display_name_localized
	else
		item_name = offer.sku.name
		item_type = get_item_type(offer.description.type)

		local num_items_text = Localize("loc_premium_store_num_items", true, {
			count = #offer.bundleInfo,
		})

		if item_type then
			item_type = string.format("%s - %s", item_type, num_items_text)
		else
			item_type = num_items_text
		end
	end

	local cost = offer.price.amount.amount
	local currency = offer.price.amount.type
	local can_afford = self:can_afford(cost, currency)

	if not can_afford then
		self:_hide_elements()
		self:_destroy_weapon()
		self:_destroy_profile()
		self:_create_aquilas_presentation(offer, item_name)

		self._aquilas_showing = true

		return
	end

	local purchase_button_widget = self._widgets_by_name.purchase_item_button

	purchase_button_widget.content.hotspot.disabled = true

	local purchased_items = self._items

	if not is_bundle and #purchased_items > 1 then
		purchased_items = {
			selected_element,
		}
	end

	local owned_items = self._owned_items
	local items_not_owned = purchased_items

	if owned_items and not table.is_empty(owned_items) and #purchased_items > 1 then
		items_not_owned = {}

		for i = 1, #purchased_items do
			local item = purchased_items[i]
			local already_owned = table.array_contains(owned_items, item)

			if not already_owned then
				items_not_owned[#items_not_owned + 1] = item
			end
		end
	end

	local wallet_type = offer.price.amount.type
	local item_cost = offer.price.amount.amount
	local current_balance = self._wallet_element:get_amount_by_currency(wallet_type)
	local new_balance = current_balance - item_cost
	local wallet_data = self._wallet_element:get_wallet_by_type(wallet_type)
	local context = {
		description_text = "loc_premium_store_confirm_purchase_description",
		title_text = "loc_premium_store_confirm_purchase_title",
		type = "offer",
		description_text_params = {
			item_name = item_name,
			item_cost = item_cost,
			current_balance = current_balance,
			new_balance = new_balance,
		},
		offer = offer,
		offer_name = item_name,
		offer_type = item_type,
		options = {
			{
				close_on_pressed = true,
				text = "loc_popup_button_confirm",
				callback = callback(self, "_make_purchase", is_bundle, offer, wallet_data, items_not_owned),
			},
			{
				close_on_pressed = true,
				hotkey = "back",
				template_type = "terminal_button_small",
				text = "loc_popup_button_cancel",
				callback = callback(function ()
					purchase_button_widget.content.hotspot.disabled = false
					self._popup_id = nil

					self:_update_purchase_buttons()
				end),
			},
		},
	}

	Managers.event:trigger("event_show_ui_popup", context, function (id)
		self._popup_id = id
	end)
end

StoreItemDetailView._create_aquilas_presentation = function (self, offer, item_name)
	self:_destroy_aquilas_presentation()

	local scenegraph_id = "grid_aquilas_content"
	local widgets = {}
	local template = ContentBlueprints.aquila_button
	local size_addition = {
		20,
		20,
	}
	local spacing = {
		20,
		25,
	}
	local large_size = {
		260,
		350,
	}
	local small_size = {
		260,
		250,
	}
	local medium_size = {
		260,
		300,
	}
	local size_per_row = {}
	local pass_template = template.pass_template
	local store_service = Managers.data_service.store

	self._store_promise = store_service:get_premium_store("hard_currency_store"):next(function (data)
		if self._destroyed or not self._store_promise or not data then
			self._store_promise = nil

			return
		end

		self._store_promise = nil

		local all_aquila_offers = data.offers
		local platform
		local authenticate_method = Managers.backend:get_auth_method()

		platform = authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM and "steam" or authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and PLATFORM == "win32" and "microsoft" or authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true and "microsoft" or authenticate_method == Managers.backend.AUTH_METHOD_PSN and "psn" or "steam"

		local bonus_offer_count = 0
		local valid_offers = 0
		local non_bonus_offer_count = 0
		local cost = offer.price.amount.amount
		local currency = offer.price.amount.type
		local current_balance = self._wallet_element:get_amount_by_currency(currency)
		local money_required = cost - current_balance
		local available_aquilas = {}
		local widget_grid_position_by_index = {}
		local widgets_count_per_row = {}

		for offerIdx = 1, #all_aquila_offers do
			local aquila_offer = all_aquila_offers[offerIdx]
			local amount = aquila_offer.value.amount

			if aquila_offer[platform] and money_required <= amount then
				available_aquilas[#available_aquilas + 1] = aquila_offer
				valid_offers = valid_offers + 1

				local bonus_aquila = aquila_offer.bonus or UISettings.bonus_aquila_values[offerIdx] or 0

				if bonus_aquila and bonus_aquila > 0 then
					bonus_offer_count = bonus_offer_count + 1
				else
					non_bonus_offer_count = non_bonus_offer_count + 1
				end
			end
		end

		local canvas_width = self._ui_scenegraph.canvas.size[1]
		local max_allowed_large_per_row = math.floor(canvas_width / (large_size[1] + spacing[1]))
		local max_allowed_small_per_row = math.floor(canvas_width / (small_size[1] + spacing[1]))
		local max_allowed_medium_per_row = math.floor(canvas_width / (medium_size[1] + spacing[1]))
		local large_needed_rows = math.ceil(bonus_offer_count / max_allowed_large_per_row)
		local small_needed_rows = math.ceil(non_bonus_offer_count / max_allowed_small_per_row)
		local use_same_size_on_all_offers = large_needed_rows > 1 and non_bonus_offer_count > 0 or small_needed_rows > 1 and bonus_offer_count > 0

		table.sort(available_aquilas, function (a, b)
			return a.value.amount > b.value.amount
		end)

		for offerIdx = 1, #available_aquilas do
			local aquila_offer = available_aquilas[offerIdx]
			local element = {}
			local values = aquila_offer[platform]

			if values and values.priceCents and values.currency then
				element.formattedPrice = string.format("%.2f %s", values.priceCents / 100, values.currency)
			else
				element.formattedPrice = aquila_offer.price.amount.formattedPrice
			end

			element.title = aquila_offer.value.amount

			local description = ""
			local bonus_aquila = aquila_offer.bonus or UISettings.bonus_aquila_values[offerIdx] or 0

			if bonus_aquila and bonus_aquila > 0 then
				local aquilas = aquila_offer.value.amount
				local aquila_minus_bonus = aquilas - bonus_aquila
				local bonus_text = Localize("loc_premium_store_credits_bonus", true, {
					amount = bonus_aquila,
				})

				description = string.format("%d\n%s", aquila_minus_bonus, bonus_text)
			end

			element.description = description
			element.offer = aquila_offer
			element.item_types = {
				"currency",
			}

			local size, max_allowed_items_per_row, total_elements_in_row

			if use_same_size_on_all_offers then
				size = medium_size
				max_allowed_items_per_row = max_allowed_medium_per_row
			elseif description ~= "" then
				size = large_size
				max_allowed_items_per_row = max_allowed_large_per_row
				total_elements_in_row = bonus_offer_count
			else
				size = small_size
				max_allowed_items_per_row = max_allowed_small_per_row
				total_elements_in_row = non_bonus_offer_count
			end

			local widget_definition = UIWidget.create_definition(pass_template, scenegraph_id, nil, size)
			local name = "currency_widget_" .. offerIdx
			local widget = self:_create_widget(name, widget_definition)

			widget.type = "aquila_button"

			local row = not use_same_size_on_all_offers and (size == large_size and 1 or 2) or math.ceil(offerIdx / max_allowed_items_per_row)
			local start_row = not use_same_size_on_all_offers and (row == 1 and 0 or bonus_offer_count) or (row - 1) * max_allowed_items_per_row

			total_elements_in_row = total_elements_in_row or row == 1 and max_allowed_items_per_row or valid_offers - max_allowed_items_per_row

			local end_row = start_row + total_elements_in_row
			local element_position = end_row - offerIdx

			widget.row = row
			size_per_row[row] = size_per_row[row] or {}
			size_per_row[row][1] = (size_per_row[row][1] or 0) + size[1] + spacing[1]
			size_per_row[row][2] = math.max(size_per_row[row][2] or 0, size[2])
			widget.offset = {
				element_position * (size[1] + spacing[1]),
				0,
				0,
			}

			local init = template.init
			local media_url = aquila_offer.mediaUrl

			if media_url then
				element.media_url = media_url

				local url_textures = self._url_textures

				url_textures[#url_textures + 1] = media_url

				Managers.url_loader:load_texture(media_url):next(function (media_data)
					local texture = media_data.texture

					element.texture_map = texture
					widget.style.texture.material_values.main_texture = texture
				end)
			end

			if init then
				init(self, widget, element, "cb_on_aquila_pressed")
			end

			local description_style_options = UIFonts.get_font_options_by_style(widget.style.bonus_description)
			local description_width, description_height = self:_text_size(widget.content.bonus_description, widget.style.bonus_description.font_type, widget.style.bonus_description.font_size, {
				1920,
				1080,
			}, description_style_options)

			widget.style.bonus_description_background.size = {
				description_width,
				description_height,
			}
			widget.style.bonus_description_background_line.size = {
				description_width,
				description_height,
			}
			widgets[offerIdx] = widget
			widget_grid_position_by_index[#widget_grid_position_by_index + 1] = {
				row = row,
				element_position_in_row = total_elements_in_row - element_position,
				grid_index = start_row + element_position + 1,
			}
			widgets_count_per_row[row] = widgets_count_per_row[row] and widgets_count_per_row[row] + 1 or 1
		end

		local needed_rows = #size_per_row
		local total_width = 0
		local total_height = (needed_rows - 1) * spacing[2]

		for i = 1, needed_rows do
			total_width = math.max(total_width, size_per_row[i][1] - spacing[1])
			total_height = total_height + size_per_row[i][2]
		end

		for i = 1, #widgets do
			local widget = widgets[i]
			local row = widget.row - 1
			local offset_height_value = 0
			local row_width_value = size_per_row[widget.row][1]

			if row > 0 then
				for f = 1, row do
					offset_height_value = offset_height_value + size_per_row[f][2]
				end

				offset_height_value = offset_height_value + spacing[2] * row
			end

			widget.offset[1] = widget.offset[1] + (total_width - row_width_value) * 0.5
			widget.offset[2] = offset_height_value
		end

		self:_set_scenegraph_size(scenegraph_id, total_width, total_height)

		local aquilas_frame_element_vertical_margin = 40
		local min_aquilas_frame_element_height = 0

		self:_set_scenegraph_size("aquilas_background", total_width, math.max(min_aquilas_frame_element_height, total_height + aquilas_frame_element_vertical_margin + size_addition[2] * needed_rows))

		self._aquilas_widgets = widgets
		self._aquilas_navigation_data = {
			widgets_position_by_index = widget_grid_position_by_index,
			num_rows = needed_rows,
			widgets_count_per_row = widgets_count_per_row,
			total_widgets = #widgets,
		}

		if not self._using_cursor_navigation then
			self._selected_aquila_index = 1
			self._selected_aquila_row = 1

			self:_select_aquila_widget_by_index(self._selected_aquila_index)
		end

		local widgets_by_name = self._widgets_by_name

		widgets_by_name.aquilas_background.content.visible = true
		widgets_by_name.required_aquilas_text.content.visible = true
		widgets_by_name.required_aquilas_text.content.text = string.format("%s ", Localize("loc_premium_store_required_credits", true, {
			offer = item_name,
			value = money_required,
		}))

		if IS_PLAYSTATION then
			local POSITION = {
				CENTER = 0,
				LEFT = 1,
				RIGHT = 2,
			}

			if not self._ps_store_icon_showing then
				NpCommerceDialog.show_ps_store_icon(POSITION.RIGHT)

				self._ps_store_icon_showing = true
			end
		end
	end):catch(function (error)
		if error and error.error == "empty_store" then
			self:cb_on_close_pressed()
		end

		self._store_promise = nil
	end)
end

StoreItemDetailView.cb_on_aquila_pressed = function (self, widget, element)
	self._purchase_promise = Managers.data_service.store:purchase_currency(element.offer):next(function (data)
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
			amount = amount,
		})
		self:cb_on_close_pressed()
	end):catch(function (error)
		local notification_string = Localize("loc_premium_store_notification_fail")

		Managers.event:trigger("event_add_notification_message", "alert", {
			text = notification_string,
		})

		self._purchase_promise = nil
	end)
end

StoreItemDetailView._destroy_aquilas_presentation = function (self)
	local aquilas_widgets = self._aquilas_widgets
	local aquilas_widget_count = aquilas_widgets and #aquilas_widgets or 0

	for i = 1, aquilas_widget_count do
		local widget = aquilas_widgets[i]
		local widget_name = widget.name

		self:_unregister_widget_name(widget_name)
	end

	self._aquilas_widgets = nil

	local widgets_by_name = self._widgets_by_name

	widgets_by_name.required_aquilas_text.content.visible = false
	widgets_by_name.aquilas_background.content.visible = false

	if IS_PLAYSTATION and self._ps_store_icon_showing then
		NpCommerceDialog.hide_ps_store_icon()

		self._ps_store_icon_showing = false
	end
end

StoreItemDetailView._select_aquila_widget_by_row = function (self, direction)
	if not self._aquilas_widgets then
		return
	end

	local navigation_data = self._aquilas_navigation_data
	local new_selection_row
	local current_row = self._selected_aquila_row

	if direction == "up" then
		new_selection_row = math.max(current_row - 1, 1)
	elseif direction == "down" then
		new_selection_row = math.max(current_row + 1, navigation_data.num_rows)
	end

	if new_selection_row then
		local current_selection_index = self._selected_aquila_index
		local row_size_top = navigation_data.widgets_count_per_row[1]
		local row_size_bottom = navigation_data.widgets_count_per_row[2]
		local start_position, end_position, delta

		if direction == "up" then
			start_position = 1
			end_position = start_position + row_size_top - 1
			delta = 0.5 * (row_size_top - row_size_bottom) - row_size_top
		elseif direction == "down" then
			start_position = row_size_top + 1
			end_position = start_position + row_size_bottom - 1
			delta = 0.5 * (row_size_bottom - row_size_top) + row_size_top
		end

		local new_selection_index = math.clamp(math.floor(current_selection_index + delta), start_position, end_position)

		self._selected_aquila_row = new_selection_row

		self:_select_aquila_widget_by_index(new_selection_index)
	end
end

StoreItemDetailView._select_aquila_widget_by_index = function (self, index)
	local aquilas_widgets = self._aquilas_widgets

	if not aquilas_widgets then
		return
	end

	if not index then
		for i = 1, #aquilas_widgets do
			local widget = aquilas_widgets[i]

			widget.content.hotspot.is_focused = false
		end

		return
	end

	local navigation_data = self._aquilas_navigation_data
	local widgets_position_by_index = navigation_data.widgets_position_by_index
	local focused_index = table.index_of_condition(widgets_position_by_index, function (widget)
		return index == widget.grid_index and widget.row == self._selected_aquila_row
	end)

	if focused_index >= 1 then
		for i = 1, #aquilas_widgets do
			local widget = aquilas_widgets[i]

			widget.content.hotspot.is_focused = i == focused_index
		end

		self._selected_aquila_index = index
	end
end

StoreItemDetailView.cb_on_inspect_pressed = function (self)
	local view_name = "cosmetics_inspect_view"
	local selected_element = self._selected_element
	local offer = selected_element.offer
	local previewed_item = selected_element.item
	local is_bundle = not not offer.bundleInfo
	local context

	if is_bundle then
		context = {
			use_store_appearance = true,
			bundle = {
				image = self._bundle_image,
				title = offer.sku.name,
				description = offer.sku.description,
				type = offer.description.type,
			},
		}
	elseif previewed_item then
		local item_type = previewed_item.item_type
		local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"

		if is_weapon or item_type == "GADGET" then
			view_name = "inventory_weapon_details_view"
		end

		local player = self:_player()
		local player_profile = player:profile()
		local include_skin_item_texts = true
		local item = item_type == "WEAPON_SKIN" and Items.weapon_skin_preview_item(previewed_item, include_skin_item_texts) or previewed_item
		local is_item_supported_on_played_character
		local item_archetypes = item.archetypes

		if item_archetypes and not table.is_empty(item_archetypes) then
			is_item_supported_on_played_character = table.array_contains(item_archetypes, player_profile.archetype.name)
		else
			is_item_supported_on_played_character = true
		end

		local gender_name = player_profile.gender
		local archetype = player_profile.archetype
		local archetype_name = archetype and archetype.name
		local breed_name = player_profile.archetype.breed
		local profile = is_item_supported_on_played_character and table.clone_instance(player_profile) or Items.create_mannequin_profile_by_item(item, gender_name, archetype_name, breed_name)

		context = {
			use_store_appearance = true,
			profile = profile,
			preview_with_gear = is_item_supported_on_played_character,
			preview_item = item,
		}

		if item_type == "WEAPON_SKIN" then
			local slots = item.slots
			local slot_name = slots[1]

			profile.loadout[slot_name] = item

			local archetype = profile.archetype
			local breed_name = archetype.breed
			local breed = Breeds[breed_name]
			local state_machine = breed.inventory_state_machine
			local animation_event = item.inventory_animation_event or "inventory_idle_default"

			context.disable_zoom = true
			context.state_machine = state_machine
			context.animation_event = animation_event
			context.wield_slot = slot_name
		end
	end

	if context and not Managers.ui:view_active(view_name) then
		Managers.ui:open_view(view_name, nil, nil, nil, nil, context)

		self._inpect_view_opened = view_name
	end
end

StoreItemDetailView._unload_url_textures = function (self)
	local url_textures = self._url_textures
	local url_texture_count = url_textures and #url_textures or 0

	for i = 1, url_texture_count do
		local url = url_textures[i]

		Managers.url_loader:unload_texture(url)
	end

	self._bundle_image = nil
	self._url_textures = {}
end

StoreItemDetailView.dialogue_system = function (self)
	return self._context.parent:dialogue_system()
end

StoreItemDetailView.cb_on_camera_zoom_toggled = function (self)
	self._zoom_level = self._zoom_level > 0.5 and 0 or 1
	self._zoom_speed = 0

	self:_trigger_zoom_logic(false, nil)
end

return StoreItemDetailView
