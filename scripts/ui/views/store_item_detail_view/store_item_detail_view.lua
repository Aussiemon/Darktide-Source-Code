-- chunkname: @scripts/ui/views/store_item_detail_view/store_item_detail_view.lua

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
local ViewElementWallet = require("scripts/ui/view_elements/view_element_wallet/view_element_wallet")
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
local DefaultViewInputSettings = require("scripts/settings/input/default_view_input_settings")
local InputUtils = require("scripts/managers/input/input_utils")
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

	self._profile = player:profile()
	self._aquilas_showing = false
	self._url_textures = {}
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

	self._store_item = context.store_item

	local offer = context.store_item.offer

	self._store_offer_is_bundle = offer.bundleInfo
	self._content_blueprints = generate_blueprints_function(StoreItemDetailViewSettings.grid_size)
	self._wallet_element = self:_add_element(ViewElementWallet, "wallet_element", 100)

	self:_update_element_position("wallet_element_pivot", self._wallet_element, true)
	self._wallet_element:_generate_currencies(self._wallet_type, {
		nil,
		30
	})

	self._items = context.parent:_extract_items(offer)

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

	if offer.media then
		for i = 1, #offer.media do
			local media = offer.media[i]

			if media.mediaSize == "large" then
				imageURL = media.url

				break
			end
		end
	end

	if imageURL then
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
	self._widgets_by_name.purchase_item_button.content.hotspot.pressed_callback = callback(self, "cb_on_purchase_pressed", "item")
end

StoreItemDetailView._is_owned = function (self, items)
	local total_count = 0
	local owned_count = 0
	local owned_items = {}

	for i = 1, #items do
		local item = items[i]

		total_count = total_count + 1

		local is_owned = self:_is_item_owned(item)

		owned_count = is_owned and owned_count + 1 or owned_count

		if is_owned then
			owned_items[#owned_items + 1] = item
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
			name = real_item.slots and real_item.slots[1]
		},
		item = real_item,
		visual_item = item
	}
end

StoreItemDetailView._setup_item_presentation = function (self)
	local description_text
	local offer = self._store_item.offer

	if #self._items == 1 then
		local entry = self._items[1]

		entry.offer = offer

		if entry.item then
			local item = entry.item
			local owned_count = 0
			local element = self:_generate_element_from_item(entry)

			owned_count = self:_is_item_owned(entry) and owned_count + 1 or owned_count
			element.item_index = 1
			element.total_count = 1
			element.owned_count = owned_count
			element.entry = entry
			element.offer = offer
			self._selected_element = element

			local profile = self:_get_generic_profile_from_item(item)

			if item.slots then
				profile.loadout[item.slots[1]] = item
			end

			element.dummy_profile = profile

			local title_text = ItemUtils.display_name(entry.real_item)
			local item_type = ItemUtils.type_display_name(entry.real_item)

			description_text = Localize(self._selected_element.item.description)

			self:_setup_details(title_text, item_type)
			self:_setup_description_grid(description_text)
			self:_present_single_item()
		end
	else
		local title_text = offer.sku.name or ""
		local item_type_lookup = offer.description.type
		local item_type_display_name_localized = ItemUtils.type_display_name({
			item_type = item_type_lookup
		})

		self:_setup_details(title_text, item_type_display_name_localized)
		self:_setup_item_grid()
	end

	self:_update_wallets()

	if self._grid and self._selected_element then
		if self._selected_element.item_index then
			local index = self._selected_element.item_index

			self._grid:select_grid_index(index)
		else
			self._grid:select_grid_index(nil, nil, nil, true)

			self._details_widget.content.hotspot.is_selected = true
		end
	elseif self._grid then
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

	local is_owned, owned_items = self:_is_owned(self._items)
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
			2
		}
		owned_item_text_style.text_color = Color.terminal_text_header(255, true)

		local owned_pass = {
			{
				style_id = "text",
				pass_type = "text",
				value_id = "text",
				style = owned_item_text_style,
				value = string.format("%s ", Localize("loc_premium_store_owned_note"))
			}
		}
		local owned_definition = UIWidget.create_definition(owned_pass, "details_pivot")
		local owned_widget = self:_create_widget("detail_widget", owned_definition)
		local content = owned_widget.content
		local style = owned_widget.style
		local text_options = UIFonts.get_font_options_by_style(style.text)
		local text_width, text_height = self:_text_size(owned_widget.content.text, style.text.font_type, style.text.font_size, {
			1920,
			1080
		}, text_options)
		local extra_width = 10

		content.size = {
			text_width + extra_width,
			text_height
		}
		self._details_widget = owned_widget

		self:_set_scenegraph_size("details_pivot", text_width + extra_width, text_height)
	else
		local price_pass = Definitions.price_text_definition
		local price_definition = UIWidget.create_definition(price_pass, "details_pivot", nil, {
			560,
			80
		})
		local price_widget = self:_create_widget("detail_widget", price_definition)
		local price_data = offer.price.amount
		local type = price_data.type
		local price = price_data.amount
		local price_text = TextUtils.format_currency(price)
		local wallet_settings = WalletSettings[type]
		local content = price_widget.content
		local style = price_widget.style

		content.price_text = price_text
		content.texture = wallet_settings.icon_texture_small
		style.price_text.material = wallet_settings.font_gradient_material

		local text_options = UIFonts.get_font_options_by_style(style.price_text)
		local text_width, text_height = self:_text_size(price_text, style.price_text.font_type, style.price_text.font_size, {
			1920,
			1080
		}, text_options)
		local margin = 5
		local total_width = text_width + margin + style.texture.size[1]

		content.size = {
			total_width,
			text_height
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
		160
	}
	local bundle_definition = UIWidget.create_definition(bundle_pass, "details_pivot", nil, size)
	local bundle_widget = self:_create_widget("detail_widget", bundle_definition)

	bundle_widget.content.hotspot.pressed_callback = function ()
		self:cb_on_bundle_pressed()
	end

	bundle_widget.style.icon.material_values.texture_map = self._bundle_image and self._bundle_image.texture

	local image_size = {
		1720,
		1580
	}
	local image_ratio = image_size[2] / image_size[1]
	local bundle_image_height = image_ratio * size[1]
	local top_padding_to_trim = 240
	local image_uv_height = size[2] / bundle_image_height
	local uv_trim_top = top_padding_to_trim / image_size[2]

	bundle_widget.style.icon.uvs[1][2] = uv_trim_top
	bundle_widget.style.icon.uvs[2][2] = image_uv_height + uv_trim_top

	local content = bundle_widget.content
	local style = bundle_widget.style
	local offer = self._store_item.offer
	local price_data = offer.price.amount
	local type = price_data.type
	local price = price_data.amount
	local price_text = TextUtils.format_currency(price)

	content.has_price_tag = true
	content.price_text = price_text

	local wallet_settings = WalletSettings[type]

	content.wallet_icon = wallet_settings.icon_texture_small

	local price_text_style = style.price_text

	price_text_style.material = wallet_settings.font_gradient_material

	local is_owned, owned_items = self:_is_owned(self._items)
	local owned_items = owned_items and #owned_items or 0
	local owned_count = owned_items
	local total_count = #self._items

	if owned_count and total_count and total_count > 0 then
		content.owned = is_owned and "" or nil
	end

	if offer.discount then
		style.discount_price.text_color = Color.terminal_text_body(255, true)
		content.discount_price = string.format("{#strike(true)}%s{#strike(false)}", TextUtils.format_currency(offer.discount))
	else
		content.discount_price = ""
	end

	local icon_margin = 0
	local discount_margin = 10
	local texture_width = bundle_widget.style.wallet_icon.size[1]
	local price_style_options = UIFonts.get_font_options_by_style(price_text_style)
	local text_width, _ = self:_text_size(content.price_text, price_text_style.font_type, price_text_style.font_size, {
		1920,
		1080
	}, price_style_options)

	price_text_style.offset[1] = -texture_width - icon_margin
	bundle_widget.style.discount_price.offset[1] = price_text_style.offset[1] - text_width - discount_margin

	local localized_text = Localize("loc_premium_store_bundle_button_title")

	content.title = string.format(localized_text, self._store_item.offer.sku.name)

	local acquire_text = Localize("loc_premium_store_bundle_button_subtitle")

	content.description = not is_owned and string.format(acquire_text, #self._items) or ""

	local hightlight_color = Color.terminal_text_header(255, true)
	local localized_string = Localize("loc_premium_store_bundle_items_owned")

	content.owned_items = owned_items > 0 and owned_items < #offer.bundleInfo and string.format(localized_string, owned_items, #offer.bundleInfo) or ""

	local title_max_width = (style.title.size and style.title.size[1] or size[1]) + (style.title.size_addition and style.title.size_addition[1] or 0)
	local description_max_width = (style.description.size and style.description.size[1] or size[1]) + (style.description.size_addition and style.description.size_addition[1] or 0)
	local title_style_options = UIFonts.get_font_options_by_style(style.title)
	local title_width, title_height = self:_text_size(content.title, style.title.font_type, style.title.font_size, {
		title_max_width,
		1080
	}, title_style_options)
	local description_style_options = UIFonts.get_font_options_by_style(style.description)
	local description_width, description_height = self:_text_size(content.description, style.description.font_type, style.description.font_size, {
		description_max_width,
		1080
	}, description_style_options)
	local description_margin = 5
	local total_size = title_height + description_margin + description_height

	style.title.offset[2] = -(total_size * 0.5) + title_height * 0.5 - style.price_background.size[2] * 0.5
	style.description.offset[2] = style.title.offset[2] + title_height * 0.5 + description_margin + description_height * 0.5
	bundle_widget.content.size = size
	self._details_widget = bundle_widget
	self._widgets_by_name.grid_divider.content.visible = true
end

StoreItemDetailView._check_details_can_afford = function (self)
	if self._details_widget and self._details_widget.style.price_text then
		local cost = self._store_item.offer.price.amount.amount
		local currency = self._store_item.offer.price.amount.type
		local can_afford = self:can_afford(cost, currency)
		local wallet_settings = WalletSettings[currency]

		self._details_widget.style.price_text.material = can_afford and wallet_settings.font_gradient_material or wallet_settings.font_gradient_material_insufficient_funds
	end
end

StoreItemDetailView._setup_description_grid = function (self, description_text)
	if not description_text then
		return
	end

	self:_destroy_description_grid()

	local widgets = {}
	local alignment_widgets = {}
	local scenegraph_id = "description_content_pivot"
	local pass_template = Definitions.text_description_pass_template
	local max_width = self._ui_scenegraph.description_grid.size[1]
	local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, {
		max_width,
		0
	})
	local widget = self:_create_widget("description_widget", widget_definition)
	local description_text_font_style = widget.style.text

	widget.content.text = description_text

	local text_options = UIFonts.get_font_options_by_style(widget.style.text)
	local text_width, text_height = self:_text_size(description_text, description_text_font_style.font_type, description_text_font_style.font_size, {
		max_width,
		math.huge
	}, text_options)

	widget.content.size[2] = text_height
	widgets[#widgets + 1] = widget
	alignment_widgets[#alignment_widgets + 1] = widget

	if #self._items == 1 then
		local item = self._items[1].item
		local restrictions_text, present_text

		if item.item_type == "WEAPON_SKIN" then
			restrictions_text, present_text = ItemUtils.weapon_skin_requirement_text(item)
		elseif item.item_type == "GEAR_UPPERBODY" or item.item_type == "GEAR_EXTRA_COSMETIC" or item.item_type == "GEAR_HEAD" or item.item_type == "GEAR_LOWERBODY" then
			restrictions_text, present_text = ItemUtils.class_requirement_text(item)
		end

		if present_text then
			local sub_title_margin = 10
			local margin_compensation = 5
			local restriction_pass_template = Definitions.item_restrictions_pass
			local widget_definition = pass_template and UIWidget.create_definition(restriction_pass_template, scenegraph_id, nil, {
				max_width,
				0
			})
			local widget = self:_create_widget("description_widget_restrictions", widget_definition)

			widget.content.text = restrictions_text

			local restriction_title_style = widget.style.title
			local restriction_text_style = widget.style.text
			local restriction_title_options = UIFonts.get_font_options_by_style(restriction_title_style)
			local restriction_text_options = UIFonts.get_font_options_by_style(restriction_text_style)
			local restriction_max_width = self._ui_scenegraph.item_restrictions.size[1]
			local restriction_title_width, restriction_title_height = self:_text_size(widget.content.title, restriction_title_style.font_type, restriction_title_style.font_size, {
				restriction_max_width,
				math.huge
			}, restriction_title_options)
			local restriction_text_width, restriction_text_height = self:_text_size(widget.content.text, restriction_text_style.font_type, restriction_text_style.font_size, {
				restriction_max_width,
				math.huge
			}, restriction_text_options)
			local text_height = restriction_title_height + restriction_text_height + sub_title_margin

			self:_set_scenegraph_size("item_restrictions_background", nil, text_height + margin_compensation * 2)
			self:_set_scenegraph_size("item_restrictions", nil, text_height)

			widget.style.text.offset[2] = restriction_title_height + sub_title_margin
			widget.content.size[2] = text_height

			local spacing_vertical = {
				size = {
					550,
					80
				}
			}

			widgets[#widgets + 1] = nil
			alignment_widgets[#alignment_widgets + 1] = spacing_vertical
			widgets[#widgets + 1] = widget
			alignment_widgets[#alignment_widgets + 1] = widget
		end
	end

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
		local element = {}

		total_count = 1

		if entry.item then
			element = self:_generate_element_from_item(entry)
			owned_count = self:_is_item_owned(entry) and owned_count + 1 or owned_count
			element.item_index = index
			element.total_count = total_count
			element.owned_count = owned_count
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

			local profile = self:_get_generic_profile_from_item(entry.item)

			profile.loadout[entry.item.slots[1]] = entry.item
			element.dummy_profile = profile

			if widget then
				widgets[#widgets + 1] = widget
				alignment_widgets[#alignment_widgets + 1] = {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					size = size,
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

	local num_items_text = string.format(Localize("loc_premium_store_items_in_collection"), #self._items)

	self._widgets_by_name.grid_title.content.text = num_items_text
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
	if self._selected_element ~= element then
		self._grid:select_grid_index(nil, nil, nil, true)
		self._grid:select_grid_index(nil)

		self._last_grid_index = nil

		local index = self._grid:index_by_widget(widget)

		self._grid:select_grid_index(index)

		if self._previous_widget then
			local hotspot = self._previous_widget.content.hotspot
		end

		self._previous_widget = widget
		self._details_widget.content.hotspot.is_selected = false
		self._selected_element = element

		if not Managers.ui:using_cursor_navigation() then
			local scrollbar_animation_progress = self._grid:get_scrollbar_percentage_by_index(index)

			self._grid:set_scrollbar_progress(scrollbar_animation_progress)
		end

		self:_present_single_item()
		self:_update_purchase_buttons()
	end
end

StoreItemDetailView.cb_on_bundle_pressed = function (self)
	if self._selected_element ~= self._store_item then
		self._selected_element = self._store_item
		self._details_widget.content.hotspot.is_selected = true

		self._grid:select_grid_index(nil, nil, nil, true)
		self._grid:select_grid_index(nil)
		self:_present_single_item()
		self:_update_purchase_buttons()
	end
end

StoreItemDetailView._present_single_item = function (self)
	local title = ""
	local sub_type

	self:_destroy_weapon()
	self:_stop_previewing()

	local element = self._selected_element

	self._widgets_by_name.bundle_background.style.bundle.material_values.texture_map = nil

	local offer = element.offer
	local is_bundle = not not offer.bundleInfo

	if is_bundle then
		self:_destroy_profile()

		if self._bundle_image then
			self._widgets_by_name.bundle_background.style.bundle.material_values.texture_map = self._bundle_image.texture
		end

		local item_type_lookup = offer.description.type
		local item_type_display_name_localized = ItemUtils.type_display_name({
			item_type = item_type_lookup
		})

		self._widgets_by_name.item_restrictions.content.visible = false

		local item_size = {
			700,
			60
		}
		local ui_renderer = self._ui_forward_renderer
		local scenegraph_id = "item_name_pivot"
		local widget_type = "item_name"
		local template = self._content_blueprints[widget_type]
		local title_item = {
			display_name = offer.sku.name or "",
			item_type = item_type_display_name_localized
		}
		local config = {
			vertical_alignment = "bottom",
			ignore_localization = true,
			use_store_appearance = true,
			horizontal_alignment = "right",
			size = item_size,
			item = title_item
		}
		local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
		local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
		local optional_style = template.style_function and template.style_function(self, config, size) or template.style
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)
		local widget

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

		local breed_name = self._presentation_profile and self._presentation_profile.archetype.breed or "human"
		local default_camera_settings = self._breeds_default_camera_settings[breed_name]

		self:_set_initial_viewport_camera_position(default_camera_settings)
	else
		local slot_name = element.item.slots[1]

		self._selected_slot = ItemSlotSettings[slot_name]
		title = element.item.display_name and Localize(element.item.display_name) or ""
		sub_type = ItemUtils.type_display_name(element.item)

		if element.item.item_type == "WEAPON_RANGED" or element.item.item_type == "WEAPON_MELEE" or element.item.item_type == "WEAPON_SKIN" or element.item.item_type == "WEAPON_TRINKET" then
			self._weapon_preview_show_original = false

			self:_destroy_profile()
			self:_setup_weapon_preview()
			self:_present_weapon(element.visual_item)

			local breed_name = self._presentation_profile and self._presentation_profile.archetype.breed or "human"
			local default_camera_settings = self._breeds_default_camera_settings[breed_name]

			self:_set_initial_viewport_camera_position(default_camera_settings)
		else
			if self._profile_spawner and not self:_is_spawn_profile_by_item_valid(element.item) then
				self:_destroy_profile()
			end

			if not self._profile_spawner then
				self._previewed_with_gear = false

				self:_generate_spawn_profile(element.item)

				local breed_name = self._presentation_profile.archetype.breed
				local default_camera_settings = self._breeds_default_camera_settings[breed_name]

				self:_set_initial_viewport_camera_position(default_camera_settings)

				self._spawn_player = true
			end

			local initial_rotation = 0

			if slot_name == "slot_gear_extra_cosmetic" then
				initial_rotation = math.pi
			end

			self._initial_rotation = initial_rotation

			if slot_name then
				self._mannequin_loadout[slot_name] = element.item

				if self._gear_loadout then
					self._gear_loadout[slot_name] = element.item
				end
			end

			self._previewed_gear_item_slot_name = slot_name

			self:_trigger_zoom_logic(self._spawn_player)
		end

		local item_size = {
			700,
			60
		}
		local ui_renderer = self._ui_forward_renderer
		local scenegraph_id = "item_name_pivot"
		local widget_type = "item_name"
		local template = self._content_blueprints[widget_type]
		local title_item = {
			display_name = title,
			item_type = sub_type
		}
		local config = {
			vertical_alignment = "bottom",
			ignore_localization = true,
			use_store_appearance = true,
			horizontal_alignment = "right",
			size = item_size,
			item = title_item
		}
		local size = template.size_function and template.size_function(self, config, ui_renderer) or template.size
		local pass_template = template.pass_template_function and template.pass_template_function(self, config, ui_renderer) or template.pass_template
		local optional_style = template.style_function and template.style_function(self, config, size) or template.style
		local widget_definition = pass_template and UIWidget.create_definition(pass_template, scenegraph_id, nil, size, optional_style)
		local widget

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

		local restrictions_text, present_text

		if element.item.item_type == "WEAPON_SKIN" then
			restrictions_text, present_text = ItemUtils.weapon_skin_requirement_text(element.item)
		elseif element.item.item_type == "GEAR_UPPERBODY" or element.item.item_type == "GEAR_EXTRA_COSMETIC" or element.item.item_type == "GEAR_HEAD" or element.item.item_type == "GEAR_LOWERBODY" then
			restrictions_text, present_text = ItemUtils.class_requirement_text(element.item)
		end

		if present_text and #self._items > 1 then
			local sub_title_margin = 10
			local margin_compensation = 20

			self._widgets_by_name.item_restrictions.content.text = restrictions_text

			local restriction_title_style = self._widgets_by_name.item_restrictions.style.title
			local restriction_text_style = self._widgets_by_name.item_restrictions.style.text
			local restriction_title_options = UIFonts.get_font_options_by_style(restriction_title_style)
			local restriction_text_options = UIFonts.get_font_options_by_style(restriction_text_style)
			local restriction_max_width = self._ui_scenegraph.item_restrictions.size[1]
			local restriction_title_width, restriction_title_height = self:_text_size(self._widgets_by_name.item_restrictions.content.title, restriction_title_style.font_type, restriction_title_style.font_size, {
				restriction_max_width,
				math.huge
			}, restriction_title_options)
			local restriction_text_width, restriction_text_height = self:_text_size(self._widgets_by_name.item_restrictions.content.text, restriction_text_style.font_type, restriction_text_style.font_size, {
				restriction_max_width,
				math.huge
			}, restriction_text_options)
			local text_height = restriction_title_height + restriction_text_height + sub_title_margin
			local background_size = text_height + margin_compensation * 2

			self:_set_scenegraph_size("item_restrictions_background", nil, background_size)
			self:_set_scenegraph_size("item_restrictions", nil, text_height)

			self._widgets_by_name.item_restrictions.style.text.offset[2] = restriction_title_height + sub_title_margin
			self._widgets_by_name.item_restrictions.content.visible = true
		else
			self._widgets_by_name.item_restrictions.content.visible = false
		end
	end

	self._valid_inspect = element.item and (element.item.item_type == "WEAPON_SKIN" or element.item.item_type == "GEAR_EXTRA_COSMETIC" or element.item.item_type == "GEAR_HEAD" or element.item.item_type == "GEAR_LOWERBODY" or element.item.item_type == "GEAR_UPPERBODY") or element.offer.bundleInfo
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

StoreItemDetailView._destroy_details = function (self)
	if self._details_widget then
		self:_unregister_widget_name(self._details_widget.name)

		self._details_widget = nil
	end
end

StoreItemDetailView._get_generic_profile_from_item = function (self, item)
	local item_gender, item_breed, item_archetype, dummy_profile
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

	return dummy_profile
end

StoreItemDetailView._generate_spawn_profile = function (self, item)
	local profile

	if item then
		profile = self:_get_generic_profile_from_item(item)
	else
		local player = self:_player()

		profile = player:profile()
	end

	self._preview_profile = profile
	self._mannequin_loadout = self:_generate_mannequin_loadout(profile)
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
	local required_profile = self:_get_generic_profile_from_item(item)
	local current_profile = self._preview_profile

	if not current_profile then
		local player = self:_player()

		current_profile = player:profile()
	end

	return required_profile.breed == current_profile.breed and required_profile.gender == current_profile.gender and required_profile.archetype.name == current_profile.archetype.name
end

StoreItemDetailView._generate_mannequin_loadout = function (self, profile)
	local presentation_profile = profile
	local gender_name = presentation_profile.gender
	local archetype = presentation_profile.archetype
	local breed_name = archetype.breed
	local new_loadout = {}
	local required_breed_item_names_per_slot = UISettings.item_preview_required_slot_items_set_per_slot_by_breed_and_gender[breed_name]
	local required_gender_item_names_per_slot = required_breed_item_names_per_slot and required_breed_item_names_per_slot[gender_name]

	if required_gender_item_names_per_slot then
		local required_items = required_gender_item_names_per_slot

		if required_items then
			for slot_name, slot_item_name in pairs(required_items) do
				local item_definition = MasterItems.get_item(slot_item_name)

				if item_definition then
					local slot_item = table.clone(item_definition)

					new_loadout[slot_name] = slot_item
				end
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
	local context = self._context
	local level_settings = StoreItemDetailViewSettings.level_settings

	self._breeds_item_camera_by_slot_id = {}
	self._breeds_default_camera_settings = {}

	local starting_camera_unit

	for breed_name, settings in pairs(Breeds) do
		if settings.breed_type == "player" then
			local default_camera_event_id = "event_register_cosmetics_preview_default_camera_" .. breed_name

			self[default_camera_event_id] = function (self, camera_unit)
				local camera_position = Unit.world_position(camera_unit, 1)
				local camera_rotation = Unit.world_rotation(camera_unit, 1)

				self._breeds_default_camera_settings[breed_name] = {
					camera_unit = camera_unit,
					original_position_boxed = Vector3Box(camera_position),
					original_rotation_boxed = QuaternionBox(camera_rotation)
				}

				self:_unregister_event(default_camera_event_id)

				if not starting_camera_unit then
					starting_camera_unit = camera_unit
				end
			end

			self:_register_event(default_camera_event_id)

			for slot_name, slot in pairs(ItemSlotSettings) do
				if slot.slot_type == "gear" then
					local item_camera_event_id = "event_register_cosmetics_preview_item_camera_" .. breed_name .. "_" .. slot_name

					self[item_camera_event_id] = function (self, camera_unit)
						if not self._breeds_item_camera_by_slot_id[breed_name] then
							self._breeds_item_camera_by_slot_id[breed_name] = {}
						end

						self._breeds_item_camera_by_slot_id[breed_name][slot_name] = camera_unit

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

StoreItemDetailView.event_register_cosmetics_preview_character_spawn_point = function (self, spawn_point_unit)
	self:_unregister_event("event_register_cosmetics_preview_character_spawn_point")

	self._spawn_point_unit = spawn_point_unit

	if self._context then
		self._context.spawn_point_unit = spawn_point_unit
	end
end

StoreItemDetailView._setup_viewport_camera = function (self, camera_unit)
	if not self._world_spawner then
		self._pending_viewport_camera_unit = camera_unit

		return
	end

	local context = self._context
	local level_settings = StoreItemDetailViewSettings.level_settings
	local viewport_name = level_settings.viewport_name
	local viewport_type = level_settings.viewport_type
	local viewport_layer = level_settings.viewport_layer
	local shading_environment = level_settings.shading_environment

	self._world_spawner:create_viewport(camera_unit, viewport_name, viewport_type, viewport_layer, shading_environment)

	self._camera_zoomed_in = true

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
end

StoreItemDetailView._reset_mannequin = function (self)
	if self._mannequin_loadout then
		for key, value in pairs(self._mannequin_loadout) do
			if self._default_mannequin_loadout[key] ~= self._mannequin_loadout[key] then
				self._mannequin_loadout[key] = self._default_mannequin_loadout[key]
			end
		end

		local profile = self._presentation_profile
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

StoreItemDetailView.cb_on_camera_zoom_toggled = function (self, id, input_pressed, instant)
	self._camera_zoomed_in = not self._camera_zoomed_in

	if self._camera_zoomed_in then
		self:_play_sound(UISoundEvents.apparel_zoom_in)
	else
		self:_play_sound(UISoundEvents.apparel_zoom_out)
	end

	self:_trigger_zoom_logic(instant)
end

StoreItemDetailView._can_zoom = function (self)
	return self._selected_element and self._selected_element.item and (self._selected_element.item.item_type == "GEAR_EXTRA_COSMETIC" or self._selected_element.item.item_type == "GEAR_HEAD" or self._selected_element.item.item_type == "GEAR_LOWERBODY" or self._selected_element.item.item_type == "GEAR_UPPERBODY")
end

StoreItemDetailView._trigger_zoom_logic = function (self, instant, optional_slot_name)
	local world_spawner = self._world_spawner
	local selected_slot = self._selected_slot
	local selected_slot_name = optional_slot_name or selected_slot and selected_slot.name

	if not selected_slot_name then
		return
	end

	local func_ptr = math.easeCubic
	local duration = instant and 0 or 1
	local profile = self._presentation_profile
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

StoreItemDetailView._set_camera_item_slot_focus = function (self, breed_name, slot_name, time, func_ptr)
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

StoreItemDetailView._set_camera_node_focus = function (self, node_name, time, func_ptr)
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

StoreItemDetailView._set_camera_position_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_position_axis_offset(axis, value, animation_time, func_ptr)
end

StoreItemDetailView._set_camera_rotation_axis_offset = function (self, axis, value, animation_time, func_ptr)
	self._world_spawner:set_camera_rotation_axis_offset(axis, value, animation_time, func_ptr)
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
	world_spawner:reset_camera_rotation_axis_offset()
	world_spawner:reset_camera_position_axis_offset()
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

	if self._popup_id then
		Managers.event:trigger("event_remove_ui_popup", self._popup_id)
	end

	self:_unload_url_textures()

	if self._context.parent then
		self._context.parent:_update_wallets()
	end

	self.super.on_exit(self)
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

	if self._spawn_player and self._spawn_point_unit then
		local profile = self._presentation_profile
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

	if self._should_expire then
		local widget = self._widgets_by_name.timer_widget
		local offer = self._store_item.offer
		local time_remaining = self._context.parent:_set_expire_time(offer)

		if not time_remaining then
			self._widgets_by_name.purchase_item_button.content.hotspot.disabled = true

			if self.closing_view then
				return
			end

			local view_name = self.view_name

			Managers.ui:close_view(view_name)

			self._should_expire = false
		else
			widget.content.text = time_remaining
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
				corner_height
			}
		end

		local corner_width = corner_right.content.original_size[1]
		local total_corner_width = wallet_width + corner_width

		self:_set_scenegraph_size("corner_top_right", total_corner_width, nil)
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
	self._widgets_by_name.grid_title.content.visible = false
	self._widgets_by_name.title.content.visible = false
	self._widgets_by_name.background.content.visible = false
	self._widgets_by_name.grid_scrollbar.content.visible = false
	self._widgets_by_name.description_scrollbar.content.visible = false
	self._widgets_by_name.item_restrictions.content.visible = false
	self._widgets_by_name.timer_widget.content.visible = false
	self._widgets_by_name.bundle_background.content.visible = false

	self:_destroy_grid()
	self:_destroy_description_grid()
	self:_destroy_details()
	self:_destroy_price_presentation()

	if self._item_name_widget then
		self._item_name_widget.content.visible = false
	end

	self._widgets_by_name.purchase_item_button.content.visible = false
	self._widgets_by_name.owned_info_text.content.visible = false
	self._widgets_by_name.grid_divider.content.visible = false
end

StoreItemDetailView._show_elements = function (self)
	self._widgets_by_name.grid_title.content.visible = true
	self._widgets_by_name.title.content.visible = true
	self._widgets_by_name.background.content.visible = true
	self._widgets_by_name.grid_scrollbar.content.visible = true
	self._widgets_by_name.description_scrollbar.content.visible = true
	self._widgets_by_name.item_restrictions.content.visible = true
	self._widgets_by_name.timer_widget.content.visible = true
	self._widgets_by_name.bundle_background.content.visible = true

	if self._item_name_widget then
		self._item_name_widget.content.visible = true
	end

	self._widgets_by_name.grid_title.content.visible = true
	self._widgets_by_name.grid_divider.content.visible = true

	self:_setup_item_presentation()
	self:_present_single_item()
	self:_update_purchase_buttons()
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

	if self._details_widget then
		UIWidget.draw(self._details_widget, ui_forward_renderer)
	end

	if self._item_name_widget then
		UIWidget.draw(self._item_name_widget, ui_forward_renderer)
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

	if self._wallet_element then
		self._wallet_element:draw(dt, t, ui_forward_renderer, render_settings, input_service)
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
			ignore_blur = true,
			draw_background = false
		})

		self:_update_weapon_preview_viewport()
	end
end

StoreItemDetailView._update_weapon_preview_viewport = function (self)
	local weapon_preview = self._weapon_preview

	if weapon_preview then
		local width_scale, height_scale = 1, 1
		local x_scale, y_scale = 0, 0

		weapon_preview:set_viewport_position_normalized(x_scale, y_scale)
		weapon_preview:set_viewport_size_normalized(width_scale, height_scale)

		local weapon_x_scale, weapon_y_scale = self:_get_weapon_spawn_position_normalized()

		weapon_preview:set_weapon_position_normalized(weapon_x_scale, weapon_y_scale)
	end
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
	if self._weapon_preview then
		local reference_name = "weapon_preview"

		self:_remove_element(reference_name)

		self._weapon_preview = nil
	end
end

StoreItemDetailView._present_weapon = function (self, item)
	local disable_auto_spin = true

	self._can_preview_with_gear = false

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

StoreItemDetailView._update_price_presentation = function (self)
	local offer = self._store_offer_is_bundle and self._store_item.offer or self._selected_element.offer
	local total_width = 0
	local price_widget = self._widgets_by_name.price_item_text
	local price = offer.price and offer.price.amount

	if not price then
		return
	end

	local content = price_widget.content
	local style = price_widget.style
	local texture_width = price_widget.style.price_icon.size[1]
	local icon_margin = 0
	local discount_margin = 10

	price_widget.content.element = offer

	if offer.discount then
		style.discount_price.text_color = Color.terminal_text_body(255, true)
		content.discount_price = ""
	else
		content.discount_price = ""
	end

	content.price = offer.owned and string.format("%s ", Localize("loc_item_owned")) or ""

	local discount_style_options = UIFonts.get_font_options_by_style(style.discount_price)
	local price_style_options = UIFonts.get_font_options_by_style(style.price)
	local discount_width, _ = self:_text_size(content.discount_price, style.discount_price.font_type, style.discount_price.font_size, {
		1920,
		1080
	}, discount_style_options)
	local text_width, _ = self:_text_size(content.price, style.price.font_type, style.price.font_size, {
		1920,
		1080
	}, price_style_options)

	price_widget.style.price.offset[1] = -texture_width - icon_margin
	total_width = icon_margin + texture_width + text_width

	if discount_width > 0 then
		total_width = total_width + discount_margin + discount_width
	end

	self:_set_scenegraph_size("price_item_text", total_width, nil)

	local wallet_settings = WalletSettings.aquilas
	local font_gradient_material = wallet_settings.font_gradient_material
	local icon_texture_small = wallet_settings.icon_texture_small

	style.price.material = not offer.owned and font_gradient_material
	style.price.text_color = offer.owned and Color.terminal_text_header(255, true) or Color.white(255, true)
	content.price_icon = nil

	local discount_banner_widget = self._widgets_by_name.promo
	local discount_content = discount_banner_widget.content

	if self._selected_element.offer.bundleInfo then
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
end

StoreItemDetailView._update_purchase_buttons = function (self)
	if not self._selected_element then
		return
	end

	local items = self._items
	local is_owned, owned_items = self:_is_owned(items)

	self._owned_items = owned_items

	local offer = self._store_item.offer
	local is_selected_item_owned = false

	if self._selected_element.offer.bundleInfo then
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
		for i = 1, #owned_items do
			local owned_item = owned_items[i]

			if owned_item.item.gear_id == self._selected_element.item.gear_id then
				is_selected_item_owned = true
			end
		end
	end

	self._widgets_by_name.background.content.force_show_price = self._should_expire
	self._widgets_by_name.purchase_item_button.content.visible = true
	self._widgets_by_name.purchase_item_button.content.hotspot.disabled = is_selected_item_owned
	self._widgets_by_name.purchase_item_button.content.visible = not is_selected_item_owned
	self._widgets_by_name.owned_info_text.content.visible = #self._items > 1 and is_selected_item_owned

	local purchase_button_text

	self:_update_price_presentation()

	local selected_offer = self._selected_element.offer
	local cost = selected_offer.price.amount.amount
	local currency = selected_offer.price.amount.type
	local can_afford = self:can_afford(cost, currency)
	local item_type_lookup = selected_offer.bundleInfo and selected_offer.description.type or self._selected_element.item.item_type
	local item_type_localization_key = UISettings.item_type_localization_lookup[Utf8.upper(item_type_lookup)]
	local item_type = item_type_localization_key and Localize(item_type_localization_key) or ""

	if can_afford or is_selected_item_owned then
		purchase_button_text = Utf8.upper(string.format("%s %s", Localize("loc_premium_store_purchase_item"), item_type))
	else
		purchase_button_text = Utf8.upper(Localize("loc_premium_store_purchase_credits"))
	end

	if is_selected_item_owned then
		purchase_button_text = Utf8.upper(Localize("loc_item_owned"))
	end

	self._widgets_by_name.purchase_item_button.content.original_text = purchase_button_text
end

StoreItemDetailView._update_wallets = function (self)
	if self._wallet_element then
		self._wallet_promise = self._wallet_element:update_wallets():next(function ()
			self._wallet_promise = nil

			self:_update_purchase_buttons()
		end):catch(function (error)
			self._wallet_promise = nil
		end)

		return self._wallet_promise
	end

	return Promise:resolved()
end

StoreItemDetailView.can_afford = function (self, cost, currency)
	local can_afford = true
	local current_balance = self._wallet_element:get_amount_by_currency(currency)

	can_afford = cost <= current_balance

	return can_afford
end

StoreItemDetailView.cb_on_purchase_pressed = function (self)
	local offer = self._selected_element.offer
	local wallet_type = offer.price.amount.type
	local context, item_name, item_type
	local is_bundle = not not self._selected_element.offer.bundleInfo

	if not is_bundle then
		local sub_type = self._selected_element.item.item_type
		local item_type_display_name_localized = ItemUtils.type_display_name({
			item_type = sub_type
		})

		item_name = Localize(self._selected_element.item.display_name)
		item_type = item_type_display_name_localized
	else
		item_name = offer.sku.name

		local item_type_localization_key = UISettings.item_type_localization_lookup[Utf8.upper(offer.description.type)]

		item_type = item_type_localization_key and Localize(item_type_localization_key)

		local num_items_text = Localize("loc_premium_store_num_items", true, {
			count = #offer.bundleInfo
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
	local item_cost = offer.price.amount.amount
	local current_balance = self._wallet_element:get_amount_by_currency(wallet_type)
	local new_balance = current_balance - item_cost
	local wallet_data = self._wallet_element:get_wallet_by_type(wallet_type)

	if can_afford then
		self._widgets_by_name.purchase_item_button.content.hotspot.disabled = true

		local items_not_owned = {}
		local purchased_items = self._items

		if not is_bundle and #self._items > 1 then
			purchased_items = {
				self._selected_element
			}
		end

		if self._owned_items and not table.is_empty(self._owned_items) and #purchased_items > 1 then
			for i = 1, #purchased_items do
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
			items_not_owned = purchased_items
		end

		context = {
			type = "offer",
			title_text = "loc_premium_store_confirm_purchase_title",
			description_text = "loc_premium_store_confirm_purchase_description",
			description_text_params = {
				item_name = item_name,
				item_cost = item_cost,
				current_balance = current_balance,
				new_balance = new_balance
			},
			offer = offer,
			offer_name = item_name,
			offer_type = item_type,
			options = {
				{
					text = "loc_popup_button_confirm",
					close_on_pressed = true,
					callback = callback(function ()
						self._purchase_promise = Managers.data_service.store:purchase_item_with_wallet(offer, wallet_data):next(function (data)
							if self._destroyed or not self._purchase_promise then
								return
							end

							self._context.parent:play_vo_events(StoreItemDetailViewSettings.vo_event_vendor_purchase, "purser_a", nil, 1.4)

							self._purchase_promise = self._context.parent:_update_store_page():next(function (data)
								self._purchase_promise = self:_update_wallets():next(function ()
									self._purchase_promise = nil

									if self.closing_view then
										return
									end

									self:_play_sound(UISoundEvents.aquilas_vendor_on_purchase)

									if #items_not_owned >= 3 then
										local message = Localize("loc_premium_store_notification_success_bundle", true, {
											item = offer.sku.name
										})

										Managers.event:trigger("event_add_notification_message", "default", message)
									else
										for i = 1, #items_not_owned do
											local item_not_owned = items_not_owned[i]
											local item = item_not_owned.item

											Managers.event:trigger("event_add_notification_message", "item_granted", item)
										end
									end

									if is_bundle or #self._items == 1 or #self._owned_items == #self._items then
										local view_name = self.view_name

										Managers.ui:close_view(view_name)
									else
										self._store_item = data or self._store_item

										self:_setup_item_presentation()
										self:_present_single_item()
									end
								end)
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
									self:_present_single_item()
								end
							end)
						end):catch(function (data)
							self._widgets_by_name.purchase_item_button.content.hotspot.disabled = false

							local notification_string = Localize("loc_premium_store_notification_fail")

							Managers.event:trigger("event_add_notification_message", "alert", {
								text = notification_string
							})

							self._popup_id = nil
							self._purchase_promise = nil

							self:_update_purchase_buttons()
						end)
					end)
				},
				{
					text = "loc_popup_button_cancel",
					template_type = "terminal_button_small",
					close_on_pressed = true,
					hotkey = "back",
					callback = callback(function ()
						self._widgets_by_name.purchase_item_button.content.hotspot.disabled = false
						self._popup_id = nil

						self:_update_purchase_buttons()
					end)
				}
			}
		}

		Managers.event:trigger("event_show_ui_popup", context, function (id)
			self._popup_id = id
		end)
	else
		self:_hide_elements()
		self:_destroy_weapon()
		self:_destroy_profile()
		self:_create_aquilas_presentation(offer, item_name)

		self._aquilas_showing = true
	end
end

StoreItemDetailView._create_aquilas_presentation = function (self, offer, item_name)
	self:_destroy_aquilas_presentation()

	local scenegraph_id = "grid_aquilas_content"
	local widgets = {}
	local template = ContentBlueprints.aquila_button
	local size_addition = {
		20,
		20
	}
	local spacing = {
		20,
		25
	}
	local large_size = {
		260,
		350
	}
	local small_size = {
		260,
		250
	}
	local medium_size = {
		260,
		300
	}
	local size_per_row = {}
	local pass_template = template.pass_template
	local store_service = Managers.data_service.store

	self._store_promise = store_service:get_premium_store("hard_currency_store"):next(function (data)
		if self._destroyed or not self._store_promise then
			return
		end

		self._store_promise = nil

		local all_aquila_offers = data.offers
		local platform
		local authenticate_method = Managers.backend:get_auth_method()

		platform = authenticate_method == Managers.backend.AUTH_METHOD_STEAM and HAS_STEAM and "steam" or authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and PLATFORM == "win32" and "microsoft" or authenticate_method == Managers.backend.AUTH_METHOD_XBOXLIVE and Application.xbox_live and Application.xbox_live() == true and "microsoft" or "steam"

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
			local offer = all_aquila_offers[offerIdx]
			local amount = offer.value.amount

			if offer[platform] and money_required <= amount then
				available_aquilas[#available_aquilas + 1] = offer
				valid_offers = valid_offers + 1

				local bonus_aquila = offer.bonus or UISettings.bonus_aquila_values[offerIdx] or 0

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

		local i = 0

		for offerIdx = 1, #available_aquilas do
			local offer = available_aquilas[offerIdx]
			local element = {}

			i = i + 1

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
				local bonus_text = Localize("loc_premium_store_credits_bonus", true, {
					amount = bonus_aquila
				})

				description = string.format("%d\n%s", aquila_minus_bonus, bonus_text)
			end

			element.description = description
			element.offer = offer
			element.item_types = {
				"currency"
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
			local name = "currency_widget_" .. i
			local widget = self:_create_widget(name, widget_definition)

			widget.type = "aquila_button"

			local row = not use_same_size_on_all_offers and (size == large_size and 1 or 2) or math.ceil(i / max_allowed_items_per_row)
			local start_row = not use_same_size_on_all_offers and (row == 1 and 0 or bonus_offer_count) or (row - 1) * max_allowed_items_per_row

			total_elements_in_row = total_elements_in_row or row == 1 and max_allowed_items_per_row or valid_offers - max_allowed_items_per_row

			local end_row = start_row + total_elements_in_row
			local element_position = end_row - i

			widget.row = row
			size_per_row[row] = size_per_row[row] or {}
			size_per_row[row][1] = (size_per_row[row][1] or 0) + size[1] + spacing[1]
			size_per_row[row][2] = math.max(size_per_row[row][2] or 0, size[2])
			widget.offset = {
				element_position * (size[1] + spacing[1]),
				0,
				0
			}

			local init = template.init

			element.media_url = offer.mediaUrl

			if element.media_url then
				Managers.url_loader:load_texture(element.media_url):next(function (data)
					element.texture_map = data.texture
					self._url_textures[#self._url_textures + 1] = data

					if init then
						init(self, widget, element, "cb_on_aquila_pressed")
					end
				end)
			end

			if init then
				init(self, widget, element, "cb_on_aquila_pressed")
			end

			local description_style_options = UIFonts.get_font_options_by_style(widget.style.bonus_description)
			local description_width, description_height = self:_text_size(widget.content.bonus_description, widget.style.bonus_description.font_type, widget.style.bonus_description.font_size, {
				1920,
				1080
			}, description_style_options)

			widget.style.bonus_description_background.size = {
				description_width,
				description_height
			}
			widget.style.bonus_description_background_line.size = {
				description_width,
				description_height
			}
			widgets[i] = widget
			widget_grid_position_by_index[#widget_grid_position_by_index + 1] = {
				row = row,
				element_position_in_row = total_elements_in_row - element_position,
				grid_index = start_row + element_position + 1
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
			total_widgets = #self._aquilas_widgets
		}

		if not self._using_cursor_navigation then
			self._selected_aquila_index = 1
			self._selected_aquila_row = 1

			self:_select_aquila_widget_by_index(self._selected_aquila_index)
		end

		self._widgets_by_name.aquilas_background.content.visible = true
		self._widgets_by_name.required_aquilas_text.content.visible = true
		self._widgets_by_name.required_aquilas_text.content.text = string.format("%s ", Localize("loc_premium_store_required_credits", true, {
			offer = item_name,
			value = money_required
		}))
	end):catch(function (error)
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

	self._widgets_by_name.required_aquilas_text.content.visible = false
	self._widgets_by_name.aquilas_background.content.visible = false
end

StoreItemDetailView._select_aquila_widget_by_row = function (self, direction)
	if not self._aquilas_widgets then
		return
	end

	local new_selection_row, new_selection_index

	if direction == "up" then
		new_selection_row = self._selected_aquila_row > 1 and self._selected_aquila_row - 1 or self._selected_aquila_row
	elseif direction == "down" then
		new_selection_row = self._selected_aquila_row < self._aquilas_navigation_data.num_rows and self._selected_aquila_row + 1 or self._selected_aquila_row
	end

	if new_selection_row then
		local row_size_top = self._aquilas_navigation_data.widgets_count_per_row[1]
		local row_size_bottom = self._aquilas_navigation_data.widgets_count_per_row[2]

		if direction == "up" then
			local start_row_position = 1
			local end_row_position = start_row_position + row_size_top - 1
			local grid_diff = (row_size_bottom - row_size_top) * 0.5
			local new_position = math.floor(self._selected_aquila_index - row_size_top - grid_diff)

			new_selection_index = math.clamp(new_position, start_row_position, end_row_position)
		elseif direction == "down" then
			local start_row_position = row_size_top + 1
			local end_row_position = start_row_position + row_size_bottom - 1
			local grid_diff = (row_size_top - row_size_bottom) * 0.5
			local new_position = math.floor(self._selected_aquila_index + row_size_top - grid_diff)

			new_selection_index = math.clamp(new_position, start_row_position, end_row_position)
		end

		self._selected_aquila_row = new_selection_row

		self:_select_aquila_widget_by_index(new_selection_index)
	end
end

StoreItemDetailView._select_aquila_widget_by_index = function (self, index)
	if not self._aquilas_widgets then
		return
	end

	if not index then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]

			widget.content.hotspot.is_focused = false
		end

		return
	end

	local widgets_position_by_index = self._aquilas_navigation_data.widgets_position_by_index
	local focused_index

	for i = 1, #self._aquilas_widgets do
		local data = widgets_position_by_index[i]

		if index == data.grid_index then
			if data.row == self._selected_aquila_row then
				focused_index = i
			end

			break
		end
	end

	if focused_index then
		for i = 1, #self._aquilas_widgets do
			local widget = self._aquilas_widgets[i]

			widget.content.hotspot.is_focused = i == focused_index
		end

		self._selected_aquila_index = index
	end
end

StoreItemDetailView.cb_on_inspect_pressed = function (self)
	local view_name = "cosmetics_inspect_view"
	local previewed_item = self._selected_element.item
	local is_bundle = not not self._selected_element.offer.bundleInfo

	if is_bundle then
		if not Managers.ui:view_active(view_name) then
			local context = {
				use_store_appearance = true,
				bundle = {
					image = self._bundle_image,
					title = self._selected_element.offer.sku.name,
					description = self._selected_element.offer.sku.description,
					type = self._selected_element.offer.description.type
				}
			}

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)

			self._inpect_view_opened = view_name
		end
	elseif previewed_item then
		local item_type = previewed_item.item_type
		local is_weapon = item_type == "WEAPON_MELEE" or item_type == "WEAPON_RANGED"
		local view_name = "cosmetics_inspect_view"

		if is_weapon or item_type == "GADGET" then
			view_name = "inventory_weapon_details_view"
		end

		if not Managers.ui:view_active(view_name) then
			local context

			if item_type == "WEAPON_SKIN" then
				local player = self:_player()
				local player_profile = player:profile()
				local include_skin_item_texts = true
				local item = ItemUtils.weapon_skin_preview_item(previewed_item, include_skin_item_texts)
				local is_item_supported_on_played_character = false

				if item.archetypes and not table.is_empty(item.archetypes) then
					for i = 1, #item.archetypes do
						local archetype = item.archetypes[i]

						if archetype == player_profile.archetype.name then
							is_item_supported_on_played_character = true

							break
						end
					end
				else
					is_item_supported_on_played_character = true
				end

				local profile = is_item_supported_on_played_character and table.clone_instance(player_profile) or ItemUtils.create_mannequin_profile_by_item(item)
				local slots = item.slots
				local slot_name = slots[1]

				profile.loadout[slot_name] = item

				local archetype = profile.archetype
				local breed_name = archetype.breed
				local breed = Breeds[breed_name]
				local state_machine = breed.inventory_state_machine
				local animation_event = item.inventory_animation_event or "inventory_idle_default"

				context = {
					disable_zoom = true,
					profile = profile,
					state_machine = state_machine,
					animation_event = animation_event,
					wield_slot = slot_name,
					preview_with_gear = is_item_supported_on_played_character,
					preview_item = item
				}
			else
				local player = self:_player()
				local profile = player:profile()
				local is_item_supported_on_played_character = false

				if previewed_item.archetypes and not table.is_empty(previewed_item.archetypes) then
					for i = 1, #previewed_item.archetypes do
						local archetype = previewed_item.archetypes[i]

						if archetype == profile.archetype.name then
							is_item_supported_on_played_character = true

							break
						end
					end
				else
					is_item_supported_on_played_character = true
				end

				context = {
					profile = profile,
					preview_with_gear = is_item_supported_on_played_character,
					preview_item = previewed_item
				}
			end

			context.use_store_appearance = true

			Managers.ui:open_view(view_name, nil, nil, nil, nil, context)

			self._inpect_view_opened = view_name
		end
	end
end

StoreItemDetailView._unload_url_textures = function (self)
	if self._bundle_image then
		local texture_data = self._bundle_image

		Managers.url_loader:unload_texture(texture_data)

		self._bundle_image = nil
	end

	local url_textures = self._url_textures

	if url_textures and #url_textures > 0 then
		for i = 1, #url_textures do
			local texture_data = url_textures[i]

			Managers.url_loader:unload_texture(texture_data)
		end

		self._url_textures = {}
	end
end

StoreItemDetailView.dialogue_system = function (self)
	return self._context.parent:dialogue_system()
end

return StoreItemDetailView
