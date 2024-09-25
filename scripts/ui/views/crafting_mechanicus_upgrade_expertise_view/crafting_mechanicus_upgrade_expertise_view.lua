-- chunkname: @scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view.lua

local CraftingMechanicusUpgradeExpertiseViewDefinitions = require("scripts/ui/views/crafting_mechanicus_upgrade_expertise_view/crafting_mechanicus_upgrade_expertise_view_definitions")
local CraftingSettings = require("scripts/settings/item/crafting_mechanicus_settings")
local InputDevice = require("scripts/managers/input/input_device")
local Items = require("scripts/utilities/items")
local Mastery = require("scripts/utilities/mastery")
local ViewElementCraftingRecipe = require("scripts/ui/view_elements/view_element_crafting_recipe/view_element_crafting_recipe")
local ViewElementWeaponStats = require("scripts/ui/view_elements/view_element_weapon_stats/view_element_weapon_stats")
local CraftingMechanicusUpgradeExpertiseView = class("CraftingMechanicusUpgradeExpertiseView", "BaseView")

CraftingMechanicusUpgradeExpertiseView.init = function (self, settings, context)
	CraftingMechanicusUpgradeExpertiseView.super.init(self, CraftingMechanicusUpgradeExpertiseViewDefinitions, settings, context)

	self._pass_input = true
	self._pass_draw = true
	self._item = context.item
	self._parent = context.parent
	self._recipe = CraftingSettings.recipes.upgrade_expertise
	self._ingredients = {
		item = self._item,
		trait_ids = {},
		trait_master_ids = {},
		tiers = {},
	}
	self._can_craft_context = {
		trait_items = {},
	}
end

CraftingMechanicusUpgradeExpertiseView.on_enter = function (self)
	CraftingMechanicusUpgradeExpertiseView.super.on_enter(self)

	if not self._item then
		Managers.ui:close_view(self.view_name)
		self._parent:go_to_crafting_view("select_item_mechanicus")

		return
	end

	self._parent:set_active_view_instance(self)

	local crafting_recipe_context = table.clone_instance(CraftingSettings.crafting_recipe_context)

	crafting_recipe_context.refresh_on_grid_pressed = false
	self._weapon_stats = self:_add_element(ViewElementWeaponStats, "weapon_stats", 10, CraftingSettings.weapon_stats_context, "weapon_stats_pivot")
	self._crafting_recipe = self:_add_element(ViewElementCraftingRecipe, "crafting_recipe", 10, crafting_recipe_context, "crafting_recipe_pivot")

	self._crafting_recipe:set_handle_grid_navigation(true)
	self._crafting_recipe:set_overlay_texture(self._recipe.overlay_texture)

	local pattern_name = self._item.parent_pattern

	Managers.data_service.mastery:get_mastery_by_pattern(pattern_name):next(function (mastery_data)
		self._mastery_data = mastery_data

		self:_present_crafting(self._mastery_data)
		self:_get_wallet()
	end)

	self._enter_animation_id = self:_start_animation("on_enter", self._widgets, self)
end

CraftingMechanicusUpgradeExpertiseView.on_exit = function (self)
	if self._traits_promises then
		self._traits_promises:cancel()

		self._traits_promises = nil
	end

	if self._craft_promise then
		self._craft_promise:cancel()

		self._craft_promise = nil
	end

	CraftingMechanicusUpgradeExpertiseView.super.on_exit(self)
end

CraftingMechanicusUpgradeExpertiseView._get_wallet = function (self)
	local store_service = Managers.data_service.store

	self._crafting_recipe:set_loading_state(true)

	return store_service:combined_wallets():next(function (wallets_data)
		if wallets_data and wallets_data.wallets then
			local wallets_values = {}

			for i = 1, #wallets_data.wallets do
				local currency = wallets_data.wallets[i].balance
				local type = currency.type
				local amount = currency.amount

				wallets_values[type] = amount
			end

			self._wallet = wallets_values
			self._can_craft_context.wallet = self._wallet

			self._crafting_recipe:set_loading_state(false)

			return true
		end
	end)
end

CraftingMechanicusUpgradeExpertiseView._present_crafting = function (self, mastery_data, optional_present_callback)
	local function on_present_callback()
		if optional_present_callback then
			optional_present_callback()
		end

		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	local function on_update_callback(new_value)
		self:_expertise_updated(new_value)
	end

	local current_expertise = Items.expertise_level(self._item, true)
	local start_value = tonumber(current_expertise)
	local max_available_value = Mastery.get_current_expertise_cap(mastery_data)
	local max_value = Mastery.get_max_expertise_cap(mastery_data)

	max_available_value = max_available_value > 0 and max_available_value or start_value
	max_value = max_value > 0 and max_value or start_value

	local expertise_data = {
		start = start_value,
		current = start_value,
		max_available = max_available_value,
		max = max_value,
	}

	expertise_data.start = math.max(expertise_data.current, expertise_data.start)
	expertise_data.current = expertise_data.start
	self._expertise_data = expertise_data
	self._can_craft_context.expertise_data = expertise_data

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, nil, on_present_callback, self._can_craft_context, on_update_callback, CraftingSettings.type)
	self._crafting_recipe:set_continue_button_callback(callback(self, "cb_on_main_button_pressed"))
	self._weapon_stats:present_item(self._item, nil, function ()
		self:_update_element_position("weapon_stats_pivot", self._weapon_stats)

		local one_level_increase_value = 1 * Items.get_expertise_multiplier()

		if expertise_data.start + one_level_increase_value <= max_available_value then
			local new_value = expertise_data.start + one_level_increase_value

			self:_expertise_updated(new_value)
		else
			self:_expertise_updated(expertise_data.start)
		end
	end)
end

CraftingMechanicusUpgradeExpertiseView._expertise_updated = function (self, new_value)
	local expertise_data = self._expertise_data
	local current

	if expertise_data.start >= expertise_data.max_available then
		current = expertise_data.max_available
	else
		current = new_value
	end

	expertise_data.current = current

	local function on_update_callback(new_value)
		self:_expertise_updated(new_value)
	end

	self._crafting_recipe:present_recipe(self._recipe, self._ingredients, nil, nil, nil, self._can_craft_context, on_update_callback, CraftingSettings.type)
	self._weapon_stats:update_expertise_value(expertise_data.start, current)

	self._can_craft_context.expertise_data = expertise_data
	self._resync_can_craft = true
end

CraftingMechanicusUpgradeExpertiseView.on_back_pressed = function (self)
	self._parent:go_to_crafting_view("select_item_mechanicus", self._item)

	return true
end

CraftingMechanicusUpgradeExpertiseView.cb_on_main_button_pressed = function (self)
	if self._craft_promise then
		return
	end

	self._should_perform_crafting = true
end

CraftingMechanicusUpgradeExpertiseView._perform_crafting = function (self)
	if self._craft_promise then
		return
	end

	local recipe = self._recipe

	if recipe then
		local expertise_data = self._expertise_data
		local current_expertise = expertise_data and expertise_data.current
		local max_available_value = Mastery.get_current_expertise_cap(self._mastery_data)

		if max_available_value <= (current_expertise or 0) then
			self:_play_sound(recipe.sound_event_max)
		else
			self:_play_sound(recipe.sound_event)
		end
	end

	self._crafting_recipe:set_continue_button_force_disabled(true)

	local craft_promise = self._parent:craft(self._recipe, self._ingredients, nil, nil, self._can_craft_context)

	self._craft_promise = craft_promise

	craft_promise:next(function (results)
		self._craft_promise = nil

		local new_item = results.items[1]

		self._item = new_item
		self._ingredients.item = new_item

		local optional_present_callback = callback(function ()
			self:_on_navigation_input_changed()
		end)

		self:_present_crafting(self._mastery_data, optional_present_callback)
		self._crafting_recipe:set_continue_button_force_disabled(false)
		self._weapon_stats:play_expertise_upgrade_animation()
	end, function ()
		self._craft_promise = nil

		self._crafting_recipe:set_continue_button_force_disabled(false)
	end)
end

CraftingMechanicusUpgradeExpertiseView.update = function (self, dt, t, input_service)
	if self._resync_can_craft then
		self._crafting_recipe:refresh_cost(self._can_craft_context)
		self._crafting_recipe:refresh_can_craft(self._can_craft_context)

		self._resync_can_craft = nil
	end

	if self._should_perform_crafting then
		self._should_perform_crafting = nil

		self:_perform_crafting()
		self:_update_element_position("crafting_recipe_pivot", self._crafting_recipe)
	end

	return CraftingMechanicusUpgradeExpertiseView.super.update(self, dt, t, input_service)
end

CraftingMechanicusUpgradeExpertiseView._handle_input = function (self, input_service)
	CraftingMechanicusUpgradeExpertiseView.super._handle_input(self, input_service)
end

CraftingMechanicusUpgradeExpertiseView._on_navigation_input_changed = function (self)
	return
end

CraftingMechanicusUpgradeExpertiseView.dialogue_system = function (self)
	return self._parent:dialogue_system()
end

return CraftingMechanicusUpgradeExpertiseView
