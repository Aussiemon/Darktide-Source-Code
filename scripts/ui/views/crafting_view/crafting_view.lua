local CraftingViewDefinitions = require("scripts/ui/views/crafting_view/crafting_view_definitions")
local ItemUtils = require("scripts/utilities/items")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")

require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")

local CraftingView = class("CraftingView", "VendorInteractionViewBase")

CraftingView.init = function (self, settings, context)
	self._wallet_type = {
		"diamantine",
		"plasteel",
		"credits"
	}

	CraftingView.super.init(self, CraftingViewDefinitions, settings, context)

	local ui_renderer = self._ui_renderer
	ui_renderer.render_pass_flag = "render_pass"
	ui_renderer.base_render_pass = "to_screen"
end

CraftingView.go_to_crafting_view = function (self, view_name, item)
	local tab_data = CraftingViewDefinitions.crafting_tab_params[view_name]
	local context = {
		item = item,
		ui_renderer = self._ui_renderer
	}

	self:_setup_tab_bar(tab_data, context)
end

CraftingView.on_enter = function (self)
	CraftingView.super.on_enter(self)

	local narrative_manager = Managers.narrative
	local narrative_event_name = "level_unlock_crafting_station_visited"

	if narrative_manager:can_complete_event(narrative_event_name) then
		narrative_manager:complete_event(narrative_event_name)
	end

	local player = Managers.player:local_player(1)
	local achievements_manager = Managers.achievements
	local achievement_name = "unlock_crafting"

	achievements_manager:unlock_achievement(player, achievement_name)
	self:play_vo_events({
		"hub_idle_crafting"
	}, "tech_priest_a", nil, 0.8)

	self._next_tab_index = nil
end

CraftingView._setup_tab_bar = function (self, tab_bar_params, additional_context)
	CraftingView.super._setup_tab_bar(self, tab_bar_params, additional_context)
end

CraftingView.update = function (self, dt, t, input_service)
	local overlay_style_color = self._widgets_by_name.overlay.style.overlay.color
	overlay_style_color[1] = math.lerp(self._wanted_overlay_alpha or 0, overlay_style_color[1], 1e-05^dt)

	return CraftingView.super.update(self, dt, t, input_service)
end

CraftingView.previously_active_view_name = function (self)
	return self._previously_active_view_name
end

CraftingView._close_active_view = function (self, is_handling_new_view)
	self._wanted_overlay_alpha = 0
	self._previously_active_view_name = self._active_view

	CraftingView.super._close_active_view(self)
end

CraftingView._switch_tab = function (self, index)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end

	self._selected_tab_index = index

	if self._selected_tab_index then
		self:_switch_tab_view(self._selected_tab_index)

		self._selected_tab_index = nil
	end
end

CraftingView._switch_tab_view = function (self, index)
	local tab_bar_menu = self._elements.tab_bar

	if tab_bar_menu then
		tab_bar_menu:set_selected_panel_index(index)
	end

	local tab_params = self._tab_bar_views[index]
	local view = tab_params.view
	local view_function = tab_params.view_function
	local view_input_legend_buttons = tab_params.input_legend_buttons
	local current_view = self._active_view
	local ui_manager = Managers.ui

	if view ~= current_view or not current_view then
		local is_handling_new_view = view ~= nil

		self:_close_active_view(is_handling_new_view)

		self._active_view = view

		if view then
			local context = {
				parent = self
			}
			local additional_context = tab_params.context
			local context_function = tab_params.context_function

			if context_function then
				additional_context = context_function()
			end

			if additional_context then
				table.merge(context, additional_context)
			end

			ui_manager:open_view(view, nil, nil, nil, nil, context)

			local input_legend_params = self._definitions.input_legend_params

			if input_legend_params then
				local merged_input_legend_params = nil

				if view_input_legend_buttons then
					merged_input_legend_params = table.clone(input_legend_params)

					table.append(merged_input_legend_params.buttons_params, view_input_legend_buttons)
				end

				self:_setup_input_legend(merged_input_legend_params or input_legend_params)
			end
		end
	end

	local alpha = tab_params.background_alpha or 0
	self._wanted_overlay_alpha = alpha
	self._active_view_on_enter_callback = self._active_view and view_function and callback(function ()
		if self._active_view == view then
			local view_instance = ui_manager:view_instance(self._active_view)

			if view_instance and view_instance:entered() then
				view_instance[view_function](view_instance)

				return true
			end
		end

		return false
	end)
	local story_name = tab_params.level_story_event

	if story_name then
		if story_name or self._previous_story_name or self._previous_story_name ~= story_name then
			local play_backwards = not story_name and true or false
			story_name = story_name or self._previous_story_name

			self._world_spawner:play_story(story_name, nil, play_backwards)

			self._previous_story_name = story_name
		end
	else
		self._previous_story_name = nil
	end
end

CraftingView._handle_back_pressed = function (self)
	local active_view_instance = self._active_view_instance
	local handled_by_active_view_instance = active_view_instance and active_view_instance.on_back_pressed

	if not handled_by_active_view_instance then
		self._wanted_overlay_alpha = 0
	end

	CraftingView.super._handle_back_pressed(self)
end

CraftingView.draw = function (self, dt, t, input_service, layer)
	UIRenderer.clear_render_pass_queue(self._ui_renderer)
	UIRenderer.add_render_pass(self._ui_renderer, 1, "to_screen", false)
	CraftingView.super.draw(self, dt, t, input_service, layer)
end

CraftingView.on_exit = function (self)
	CraftingView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_crafting_store_closed")
	end
end

CraftingView.craft = function (self, recipe, ingredients, callback, done_callback)
	local recipe_name = recipe.name

	Log.info("CraftingView", "Craft operation %q with ingredients:\n%s", recipe_name, table.minidump(ingredients, "ingredients"))

	local promise = recipe.craft(ingredients)

	return promise:next(function (result)
		Log.info("CraftingView", "Craft operation %q succeeded", recipe_name)

		if recipe.success_text then
			Managers.event:trigger("event_add_notification_message", "default", Localize(recipe.success_text), callback, nil, done_callback)
		end

		if recipe.show_item_granted_toast then
			local items = result.items

			for i, item in ipairs(items) do
				Managers.event:trigger("event_add_notification_message", "item_granted", item, callback, nil, done_callback)
			end

			local message_delay = 1.5
			local traits = result.traits

			for i, trait in ipairs(traits) do
				Managers.event:trigger("event_add_notification_message", "item_granted", trait, callback, nil, done_callback, message_delay)
			end
		end

		self:play_vo_events({
			"crafting_complete"
		}, "tech_priest_a", nil, 1.4)

		local input_item = ingredients.item

		if input_item then
			self:_loadout_refresh(input_item)
		end

		local world_spawner = self._world_spawner

		if world_spawner then
			world_spawner:trigger_level_event("event_despawn_upgrade_particle")
			world_spawner:trigger_level_event("event_spawn_upgrade_particle")
		end

		self:_update_wallets()

		return self._wallet_promise:next(function ()
			return result
		end)
	end):catch(function (crafting_error)
		local message = crafting_error.message or crafting_error

		Log.error("CraftingView", "Craft operation %q failed! Error:\n%s", recipe_name, message)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_crafting_failure")
		}, callback, nil, done_callback)
		error({
			message = message
		})
	end)
end

CraftingView._loadout_refresh = function (self, item)
	local slots = item.slots

	if not slots then
		return
	end

	local player = self:_player()
	local profile = player:profile()
	local loadout = profile.loadout
	local gear_id = item.gear_id

	for i = 1, #slots do
		local slot_name = slots[i]
		local equipped_item = loadout[slot_name]

		if equipped_item and equipped_item.gear_id == gear_id then
			ItemUtils.refresh_equipped_items()

			break
		end
	end
end

return CraftingView
