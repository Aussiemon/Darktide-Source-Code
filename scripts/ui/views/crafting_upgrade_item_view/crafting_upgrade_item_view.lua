local CraftingUpgradeItemViewDefinitions = require("scripts/ui/views/crafting_upgrade_item_view/crafting_upgrade_item_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local ViewElementItemResultOverlay = require("scripts/ui/view_elements/view_element_item_result_overlay/view_element_item_result_overlay")
local InputDevice = require("scripts/managers/input/input_device")
local InputUtils = require("scripts/managers/input/input_utils")
local ItemUtils = require("scripts/utilities/items")
local CraftingUpgradeItemView = class("CraftingUpgradeItemView", "BaseView")

CraftingUpgradeItemView.init = function (self, settings, context)
	CraftingUpgradeItemView.super.init(self, CraftingUpgradeItemViewDefinitions, settings, context)

	self._pass_input = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.upgrade_item
	self._ingredients = {
		item = self._item
	}
end

CraftingUpgradeItemView.on_enter = function (self)
	CraftingUpgradeItemView.super.on_enter(self)
	self._parent:set_active_view_instance(self)

	self._weapon_stats_1 = self:_add_element(ViewElementWeaponStats, "weapon_stats_1", 10, CraftingSettings.weapon_stats_context, "weapon_stats_1_pivot")
	self._weapon_stats_2 = self:_add_element(ViewElementWeaponStats, "weapon_stats_2", 10, CraftingSettings.weapon_stats_context, "weapon_stats_2_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, CraftingSettings.crafting_recipe_context, "crafting_recipe_pivot")

	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)
	self:_present_crafting(self._item)

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)

	if self._crafting_recipe:can_craft() then
		local force_effect = true

		self._crafting_recipe:set_continue_button_force_disabled(false, force_effect)
	end
end

CraftingUpgradeItemView.on_exit = function (self)
	if self._craft_promise then
		self._craft_promise:cancel()

		self._craft_promise = nil
	end

	CraftingUpgradeItemView.super.on_exit(self)
end

CraftingUpgradeItemView._present_upgrade_result = function (self, item)
	local result_data = {
		type = "item",
		item = item
	}

	self:_setup_result_overlay(result_data)
end

CraftingUpgradeItemView._close_result_overlay = function (self)
	if self._result_overlay then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	local result_item = self._result_item
	local gear_id = result_item.gear_id
	local item_type = result_item.item_type

	ItemUtils.mark_item_id_as_new(gear_id, item_type)
	Managers.event:trigger("event_vendor_view_purchased_item")
	self._crafting_recipe:set_continue_button_force_disabled(false)
end

CraftingUpgradeItemView._setup_result_overlay = function (self, result_data)
	if self._result_overlay then
		self._result_overlay = nil

		self:_remove_element("result_overlay")
	end

	local reference_name = "result_overlay"
	local layer = 40
	self._result_overlay = self:_add_element(ViewElementItemResultOverlay, reference_name, layer)
	local result_title_text_localized = Utf8.upper(Localize("loc_crafting_upgrade_reward_popup_title"))

	self._result_overlay:set_title_text(result_title_text_localized)
	self._result_overlay:start(result_data)
end

CraftingUpgradeItemView._is_result_presentation_active = function (self)
	if self._result_overlay then
		return true
	end

	return false
end

CraftingUpgradeItemView.draw = function (self, dt, t, input_service, layer)
	if self._result_overlay then
		input_service = input_service:null_service()
	end

	return CraftingUpgradeItemView.super.draw(self, dt, t, input_service, layer)
end

CraftingUpgradeItemView.update = function (self, dt, t, input_service)
	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	local result_overlay = self._result_overlay
	local handle_input = true

	if result_overlay then
		if result_overlay:presentation_complete() then
			self:_close_result_overlay()
		end

		handle_input = false
	end

	local pass_input, pass_draw = CraftingUpgradeItemView.super.update(self, dt, t, input_service)

	return handle_input and pass_input, pass_draw
end

local _device_list = {
	Keyboard,
	Mouse,
	Pad1
}

CraftingUpgradeItemView._handle_input = function (self, input_service)
	if not self._craft_promise then
		if self:_is_result_presentation_active() then
			local any_input_pressed = false

			if IS_XBS then
				local input_device_list = InputUtils.input_device_list
				local xbox_controllers = input_device_list.xbox_controller

				for i = 1, #xbox_controllers do
					local xbox_controller = xbox_controllers[i]

					if xbox_controller.active() and xbox_controller.any_released() then
						any_input_pressed = true

						break
					end
				end
			else
				for i = 1, #_device_list do
					local device = _device_list[i]

					if device and device.active and device.any_released() then
						any_input_pressed = true

						break
					end
				end
			end

			if any_input_pressed then
				self:_close_result_overlay()
			end
		else
			local crafting_recipe = self._crafting_recipe

			if InputDevice.gamepad_active and crafting_recipe:can_craft() and input_service:get("hotkey_menu_special_2_released") then
				self._should_perform_crafting = true
			end
		end
	end

	CraftingUpgradeItemView.super._handle_input(self, input_service)
end

CraftingUpgradeItemView.on_back_pressed = function (self)
	if self._craft_promise then
		return true
	end

	self._parent:go_to_crafting_view("select_item", self._item)

	return true
end

CraftingUpgradeItemView._present_crafting = function (self)
	local function on_present_callback()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)

		if not self._using_cursor_navigation then
			self._crafting_recipe:select_first_index()
		end
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, nil, on_present_callback)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))
	self._weapon_stats_1:present_item(self._item, nil, callback(self, "_update_element_position", "weapon_stats_1_pivot", self._weapon_stats_1))

	local can_craft = self._recipe.can_craft(self._ingredients)

	if can_craft then
		local bogus_item = self._recipe.get_bogus_result(self._ingredients)

		self._weapon_stats_2:present_item(bogus_item, nil, callback(self, "_update_element_position", "weapon_stats_2_pivot", self._weapon_stats_2))
	else
		self._weapon_stats_2:stop_presenting()
	end

	self._widgets_by_name.progression_arrows.visible = can_craft
end

CraftingUpgradeItemView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingUpgradeItemView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	self._crafting_recipe:play_craft_animation()

	local recipe = self._recipe

	if recipe then
		self:_play_sound(recipe.sound_event)
	end

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local craft_promise = self._parent:craft(self._recipe, self._ingredients)
	self._craft_promise = craft_promise

	craft_promise:next(function (results)
		self._craft_promise = nil
		local new_item = results.items[1]
		self._item = new_item
		self._ingredients.item = new_item
		self._result_item = new_item

		self:_present_crafting(new_item)
		self:_present_upgrade_result(new_item)
	end, function ()
		self._craft_promise = nil
	end)
end

CraftingUpgradeItemView._on_navigation_input_changed = function (self)
	if self._using_cursor_navigation then
		self._crafting_recipe:select_grid_index(nil)
	else
		self._crafting_recipe:select_first_index()
	end
end

CraftingUpgradeItemView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingUpgradeItemView
