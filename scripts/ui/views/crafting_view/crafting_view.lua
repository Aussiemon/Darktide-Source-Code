﻿-- chunkname: @scripts/ui/views/crafting_view/crafting_view.lua

local CraftingViewDefinitions = require("scripts/ui/views/crafting_view/crafting_view_definitions")
local ItemUtils = require("scripts/utilities/items")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIWeaponSpawner = require("scripts/managers/ui/ui_weapon_spawner")

require("scripts/ui/views/vendor_interaction_view_base/vendor_interaction_view_base")

local CraftingView = class("CraftingView", "VendorInteractionViewBase")

CraftingView.init = function (self, settings, context)
	CraftingView.super.init(self, CraftingViewDefinitions, settings, context)

	local ui_renderer = self._ui_renderer

	ui_renderer.render_pass_flag = "render_pass"
	ui_renderer.base_render_pass = "to_screen"
end

CraftingView.show_wallets = function (self, show)
	local wallet_widget = self._widgets_by_name.corner_top_right
	local no_wallet_widget = self._widgets_by_name.corner_top_right_no_wallet

	if show == false then
		self._wallet_type = {}
		wallet_widget.content.visible = false
		no_wallet_widget.content.visible = true
	else
		self._wallet_type = {
			"diamantine",
			"plasteel",
			"credits",
		}
		wallet_widget.content.visible = true
		no_wallet_widget.content.visible = false
	end

	self:_update_wallets()
end

local story_level_order = {
	camera_recipe_enter_anim = 1,
	camera_weapon_selection_enter_anim = 2,
}

CraftingView.go_to_crafting_view = function (self, view_name, item)
	local tab_data = CraftingViewDefinitions.crafting_tab_params[view_name]
	local context = {
		item = item,
		ui_renderer = self._ui_renderer,
	}

	self:_setup_tab_bar(tab_data, context)

	local crafting_level_story_event = tab_data.crafting_level_story_event

	if crafting_level_story_event then
		local world_spawner = self._world_spawner
		local previous_crafting_level_story_event = self._previous_crafting_level_story_event

		if previous_crafting_level_story_event then
			local reverse_privious = story_level_order[previous_crafting_level_story_event] >= story_level_order[crafting_level_story_event]
			local start_time
			local active_story_id = world_spawner:active_story_id()

			if active_story_id and reverse_privious then
				start_time = world_spawner:story_time(active_story_id)
			end

			local story_event = reverse_privious and previous_crafting_level_story_event or crafting_level_story_event

			world_spawner:play_story(story_event, start_time, reverse_privious)
		else
			local start_time
			local active_story_id = world_spawner:active_story_id()

			if active_story_id then
				start_time = world_spawner:story_time(active_story_id)
			end

			world_spawner:play_story(crafting_level_story_event, start_time)
		end

		self._previous_crafting_level_story_event = crafting_level_story_event
	end
end

CraftingView.on_enter = function (self)
	CraftingView.super.on_enter(self)

	local viewport_name = CraftingViewDefinitions.background_world_params.viewport_name

	if self._world_spawner then
		self._world_spawner:set_listener(viewport_name)
	end

	self:show_wallets(false)

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
		"hub_idle_crafting",
	}, "tech_priest_a", nil, 0.8)

	self._next_tab_index = nil
end

CraftingView.start_present_item = function (self, item)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end

	local world_spawner = self._world_spawner
	local world = world_spawner:world()
	local camera = world_spawner:camera()
	local unit_spawner = world_spawner:unit_spawner()
	local ui_weapon_spawner = UIWeaponSpawner:new("CraftingView", world, camera, unit_spawner)
	local render_context
	local alignment_key = "weapon_alignment_tag"

	if render_context and render_context.alignment_key then
		alignment_key = render_context.alignment_key
	end

	local item_base_unit_name = item.base_unit
	local item_level_link_unit = self:_get_unit_by_value_key(alignment_key, item_base_unit_name)
	local default_level_link_unit = self:_get_unit_by_value_key(alignment_key, "content/weapons/player/melee/combat_knife/wpn_combat_knife_chained_rig")
	local spawn_point_unit = item_level_link_unit or default_level_link_unit
	local spawn_position = Unit.world_position(spawn_point_unit, 1)
	local spawn_rotation = Unit.world_rotation(spawn_point_unit, 1)
	local spawn_scale = Unit.world_scale(spawn_point_unit, 1)
	local force_highest_mip = true

	ui_weapon_spawner:start_presentation(item, spawn_position, spawn_rotation, spawn_scale, nil, force_highest_mip)

	self._ui_weapon_spawner = ui_weapon_spawner
end

CraftingView._get_unit_by_value_key = function (self, key, value)
	local world_spawner = self._world_spawner
	local level = world_spawner:level()
	local level_units = Level.units(level)

	for i = 1, #level_units do
		local unit = level_units[i]

		if Unit.get_data(unit, key) == value then
			return unit
		end
	end
end

CraftingView.stop_presenting_current_item = function (self)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:destroy()

		self._ui_weapon_spawner = nil
	end
end

CraftingView.set_item_position = function (self, position)
	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:set_position(position)
	end
end

CraftingView._setup_tab_bar = function (self, tab_bar_params, additional_context)
	CraftingView.super._setup_tab_bar(self, tab_bar_params, additional_context)
end

CraftingView.update = function (self, dt, t, input_service)
	local overlay_style_color = self._widgets_by_name.overlay.style.overlay.color

	overlay_style_color[1] = math.lerp(self._wanted_overlay_alpha or 0, overlay_style_color[1], 1e-05^dt)

	if self._ui_weapon_spawner then
		self._ui_weapon_spawner:update(dt, t, input_service)
	end

	return CraftingView.super.update(self, dt, t, input_service)
end

CraftingView._change_view_callback = function (self, tab_params)
	if not tab_params then
		self:show_wallets(false)
	elseif tab_params.on_active_callback then
		tab_params.on_active_callback(self)
	end
end

CraftingView.previously_active_view_name = function (self)
	return self._previously_active_view_name
end

CraftingView._close_active_view = function (self, is_handling_new_view)
	local world_spawner = self._world_spawner

	if not is_handling_new_view then
		local previous_crafting_level_story_event = self._previous_crafting_level_story_event

		if previous_crafting_level_story_event then
			local start_time
			local active_story_id = world_spawner:active_story_id()

			if active_story_id then
				start_time = world_spawner:story_time(active_story_id)
			end

			world_spawner:play_story(previous_crafting_level_story_event, nil, true)

			self._previous_crafting_level_story_event = nil
		end
	end

	self._wanted_overlay_alpha = 0
	self._previously_active_view_name = self._active_view

	if not is_handling_new_view then
		self:stop_presenting_current_item()
	end

	if not is_handling_new_view then
		self:_change_view_callback()
	end

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
				parent = self,
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
				local merged_input_legend_params

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

	self:_change_view_callback(tab_params)
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
	if self._world_spawner then
		self._world_spawner:release_listener()
	end

	CraftingView.super.on_exit(self)

	local level = Managers.state.mission and Managers.state.mission:mission_level()

	if level then
		Level.trigger_event(level, "lua_crafting_store_closed")
	end
end

CraftingView.craft = function (self, recipe, ingredients, callback, done_callback, additional_context)
	local recipe_name = recipe.name

	Log.info("CraftingView", "Craft operation %q with ingredients:\n%s", recipe_name, table.minidump(ingredients, "ingredients"))

	local promise = recipe.craft(ingredients, additional_context)

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
			"crafting_complete",
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
			text = Localize("loc_crafting_failure"),
		}, callback, nil, done_callback)
		error({
			message = message,
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
