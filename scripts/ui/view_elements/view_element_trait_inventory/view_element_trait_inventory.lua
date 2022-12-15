local ViewElementTraitInventoryBlueprints = require("scripts/ui/view_elements/view_element_trait_inventory/view_element_trait_inventory_blueprints")
local ViewElementTraitInventoryDefinitions = require("scripts/ui/view_elements/view_element_trait_inventory/view_element_trait_inventory_definitions")
local ItemUtils = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")

require("scripts/ui/view_elements/view_element_grid/view_element_grid")

local ViewElementTraitInventory = class("ViewElementTraitInventory", "ViewElementGrid")

ViewElementTraitInventory.init = function (self, parent, draw_layer, start_scale, optional_menu_settings)
	local definitions = ViewElementTraitInventoryDefinitions

	ViewElementTraitInventory.super.init(self, parent, draw_layer, start_scale, definitions.menu_settings, definitions)
	self:present_grid_layout({}, ViewElementTraitInventoryBlueprints)
end

ViewElementTraitInventory.cb_on_grid_entry_left_pressed = function (self, widget, config)
	local trait_item = config.trait_item
	local trait_info_box = self._widgets_by_name.trait_info_box_content
	local content = trait_info_box.content
	local style = trait_info_box.style
	content.display_name = Localize(trait_item.display_name)
	content.description = ItemUtils.trait_description(trait_item, trait_item.rarity, trait_item.value)
	local texture_icon, texture_frame = ItemUtils.trait_textures(trait_item, trait_item.rarity)
	local icon_material_values = style.icon.material_values
	icon_material_values.icon = texture_icon
	icon_material_values.frame = texture_frame
end

ViewElementTraitInventory._make_fake_stacked_traits = function (self, owned_traits, sticker_book)
	local stacked_traits_by_rank = {}

	for item_id, trait_item in pairs(owned_traits) do
		local rank = trait_item.rarity
		local stacked_traits = stacked_traits_by_rank[rank] or {}
		stacked_traits_by_rank[rank] = stacked_traits
		local trait_name = trait_item.name
		local trait_stack_item = stacked_traits[trait_name] or MasterItems.create_preview_item_instance(trait_item)
		trait_stack_item.count = (trait_stack_item.count or 0) + 1
		stacked_traits[trait_name] = trait_stack_item
	end

	return stacked_traits_by_rank
end

ViewElementTraitInventory.present_inventory = function (self, owned_traits, sticker_book, weapon)
	self._owned_traits = owned_traits
	self._sticker_book = sticker_book
	self._weapon = weapon
	self._stacked_traits_by_rank = self:_make_fake_stacked_traits(owned_traits, sticker_book)

	self:_setup_tabs()
	self:_switch_to_rank_tab(1)
end

ViewElementTraitInventory._setup_tabs = function (self, rank)
	return
end

ViewElementTraitInventory._switch_to_rank_tab = function (self, rank)
	self._rank = rank

	self:_present()
end

ViewElementTraitInventory._present = function (self)
	local rank = self._rank
	local stacked_traits_by_rank = self._stacked_traits_by_rank
	local layout = {
		[#layout + 1] = {
			widget_type = "spacing_vertical"
		}
	}

	for trait_name, status in pairs(self._sticker_book) do
		if status ~= nil then
			local trait_stack_item = stacked_traits_by_rank[rank][trait_name]

			if trait_stack_item then
				layout[#layout + 1] = {
					widget_type = "trait",
					trait_item = trait_stack_item,
					trait_rarity = rank,
					trait_amount = trait_stack_item.count
				}
			else
				layout[#layout + 1] = {
					widget_type = "unknown_trait"
				}
			end
		end
	end

	layout[#layout + 1] = {
		widget_type = "spacing_vertical"
	}
	local left_click_callback = callback(self, "cb_on_grid_entry_left_pressed")

	self:present_grid_layout(layout, ViewElementTraitInventoryBlueprints, left_click_callback)
end

return ViewElementTraitInventory
