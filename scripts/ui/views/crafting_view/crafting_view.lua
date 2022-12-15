local CraftingViewDefinitions = require("scripts/ui/views/crafting_view/crafting_view_definitions")
local ItemUtils = require("scripts/utilities/items")
local UIRenderer = require("scripts/managers/ui/ui_renderer")

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

	local achievements_manager = Managers.achievements
	local achievement_name = "unlock_crafting"

	achievements_manager:unlock_achievement(achievement_name)
	self:play_vo_events({
		"hub_idle_crafting"
	}, "tech_priest_a", nil, 0.8)
end

CraftingView._setup_tab_bar = function (self, tab_bar_params, additional_context)
	CraftingView.super._setup_tab_bar(self, tab_bar_params, additional_context)

	local alpha = #tab_bar_params.tabs_params > 0 and 175 or 0
	self._wanted_overlay_alpha = alpha
end

CraftingView.update = function (self, dt, t, input_service)
	local overlay_style_color = self._widgets_by_name.overlay.style.overlay.color
	overlay_style_color[1] = math.lerp(self._wanted_overlay_alpha or 0, overlay_style_color[1], 1e-05^dt)

	return CraftingView.super.update(self, dt, t, input_service)
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

CraftingView.craft = function (self, recipe, ingredients)
	local recipe_name = recipe.name

	Log.info("CraftingView", "Craft operation %q with ingredients:\n%s", recipe_name, table.minidump(ingredients, "ingredients"))

	local promise = recipe.craft(ingredients)

	return promise:next(function (result)
		Log.info("CraftingView", "Craft operation %q succeeded", recipe_name)

		if recipe.success_text then
			Managers.event:trigger("event_add_notification_message", "default", Localize(recipe.success_text))
		end

		if recipe.show_item_granted_toast then
			Managers.event:trigger("event_add_notification_message", "item_granted", result)
		end

		self:play_vo_events({
			"crafting_complete"
		}, "tech_priest_a", nil, 1.4)
		self:_loadout_refresh(ingredients.item)
		self:_update_wallets()

		return self._wallet_promise:next(function ()
			return result
		end)
	end, function (message)
		Log.error("CraftingView", "Craft operation %q failed! Error:\n%s", recipe_name, message)
		Managers.event:trigger("event_add_notification_message", "alert", {
			text = Localize("loc_crafting_failure")
		})
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
