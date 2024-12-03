-- chunkname: @scripts/ui/hud/elements/weapon_counter/hud_element_weapon_counter.lua

local Crosshair = require("scripts/ui/utilities/crosshair")
local HudElementWeaponCounterDefinitions = require("scripts/ui/hud/elements/weapon_counter/hud_element_weapon_counter_definitions")
local HudElementWeaponCounterSettings = require("scripts/ui/hud/elements/weapon_counter/hud_element_weapon_counter_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local HudElementWeaponCounter = class("HudElementWeaponCounter", "HudElementBase")

HudElementWeaponCounter.init = function (self, parent, draw_layer, start_scale, data)
	HudElementWeaponCounter.super.init(self, parent, draw_layer, start_scale, HudElementWeaponCounterDefinitions)

	self._slot_widgets = {}
	self._slot_weapon_counter_type = {}
	self._weapon_counter_templates = {}
	self._weapon_counter_widget_definitions = {}

	local scenegraph_id = "pivot"
	local templates = HudElementWeaponCounterSettings.templates

	for ii = 1, #templates do
		local template_path = templates[ii]
		local template = require(template_path)
		local name = template.name

		self._weapon_counter_templates[name] = table.clone(template)
		self._weapon_counter_widget_definitions[name] = template.create_widget_defintion(scenegraph_id)
	end

	self._crosshair_position_x = 0
	self._crosshair_position_y = 0
end

HudElementWeaponCounter.destroy = function (self, ui_renderer)
	HudElementWeaponCounter.super.destroy(self, ui_renderer)
end

HudElementWeaponCounter.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementWeaponCounter.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local player_extensions = self._parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local inventory_component = unit_data_extension:read_component("inventory")
		local wielded_slot = inventory_component.wielded_slot

		self:_update_slot(dt, t, "slot_primary", wielded_slot == "slot_primary", ui_renderer)
		self:_update_slot(dt, t, "slot_secondary", wielded_slot == "slot_secondary", ui_renderer)
	end
end

HudElementWeaponCounter._update_slot = function (self, dt, t, slot_name, is_currently_wielded, ui_renderer)
	local weapon_counter_settings = self:_weapon_counter_settings(slot_name)

	self:_update_slot_widget(slot_name, weapon_counter_settings)

	local weapon_counter_type = self._slot_weapon_counter_type[slot_name]

	if weapon_counter_type then
		local template = self._weapon_counter_templates[weapon_counter_type]
		local update_function = template and template.update_function

		if update_function then
			update_function(self, ui_renderer, self._slot_widgets[slot_name], is_currently_wielded, weapon_counter_settings, template, dt, t)
		end
	end
end

HudElementWeaponCounter._weapon_counter_settings = function (self, slot_name)
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local visual_loadout_extension = player_extensions.visual_loadout
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)

		if weapon_template then
			return weapon_template.weapon_counter
		end
	end
end

HudElementWeaponCounter._update_slot_widget = function (self, slot_name, weapon_counter_settings)
	local new_slot_weapon_counter_type = weapon_counter_settings and weapon_counter_settings.weapon_counter_type
	local current_slot_weapon_counter_type = self._slot_weapon_counter_type[slot_name]

	if new_slot_weapon_counter_type ~= current_slot_weapon_counter_type then
		if self._slot_widgets[slot_name] and current_slot_weapon_counter_type then
			self:_unregister_widget_name(string.format("%s_%s", slot_name, current_slot_weapon_counter_type))

			self._slot_widgets[slot_name] = nil
		end

		local widget_definition = self._weapon_counter_widget_definitions[new_slot_weapon_counter_type]

		if widget_definition then
			self._slot_widgets[slot_name] = self:_create_widget(string.format("%s_%s", slot_name, new_slot_weapon_counter_type), widget_definition)

			local template = self._weapon_counter_templates[new_slot_weapon_counter_type]
			local on_enter = template.on_enter

			if on_enter then
				on_enter(self, slot_name, self._slot_widgets[slot_name], template)
			end
		end

		self._slot_weapon_counter_type[slot_name] = new_slot_weapon_counter_type
	end
end

HudElementWeaponCounter._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local pivot_position = self:scenegraph_world_position("pivot", ui_renderer.scale)
	local x, y = Crosshair.position(dt, t, self._parent, ui_renderer, self._crosshair_position_x, self._crosshair_position_y, pivot_position)

	self._crosshair_position_x = x
	self._crosshair_position_y = y

	HudElementWeaponCounter.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	for _, widget in pairs(self._slot_widgets) do
		local widget_offset = widget.offset

		widget_offset[1] = x
		widget_offset[2] = y

		UIWidget.draw(widget, ui_renderer)
	end
end

return HudElementWeaponCounter
