local Definitions = require("scripts/ui/hud/elements/wield_info/hud_element_wield_info_definitions")
local WieldInfoPassivesTemplates = require("scripts/ui/hud/elements/wield_info/wield_info_passives_templates")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local InputUtils = require("scripts/managers/input/input_utils")
local TextUtils = require("scripts/utilities/ui/text")
local UIWidget = require("scripts/managers/ui/ui_widget")
local Action = require("scripts/utilities/weapon/action")
local _input_devices = {
	"xbox_controller",
	"keyboard",
	"mouse"
}
local HudElementWieldInfo = class("HudElementWieldInfo", "HudElementBase")

HudElementWieldInfo.init = function (self, parent, draw_layer, start_scale)
	self._active_wield_inputs = {}
	self._widget_counter = 0
	self._input_info_definition = Definitions.input_info_definition

	HudElementWieldInfo.super.init(self, parent, draw_layer, start_scale, Definitions)
end

HudElementWieldInfo._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if not self._draw_info then
		return
	end

	local active_wield_inputs = self._active_wield_inputs
	local num_inputs = #active_wield_inputs

	for i = 1, num_inputs do
		local input_data = active_wield_inputs[i]
		local widget = input_data.widget
		local alpha_multiplier = input_data.alpha_multiplier
		render_settings.alpha_multiplier = alpha_multiplier

		UIWidget.draw(widget, ui_renderer)

		input_data.alpha_multiplier = math.min(alpha_multiplier + dt * 3, 1)
	end

	HudElementWieldInfo.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

HudElementWieldInfo._create_entry = function (self, input, optional_validation_function)
	local id = input.id
	local input_action = input.input_action
	local description = input.description
	local icon = input.icon and input.icon ~= "" and input.icon or nil
	local icon_width = input.icon_width or 0
	local icon_height = input.icon_height or 0
	local service_type = "Ingame"
	local text = TextUtils.localize_with_button_hint(input_action, description, nil, service_type, Localize("loc_input_legend_text_template"))
	local widget_name = "input_widget_" .. self._widget_counter
	self._widget_counter = self._widget_counter + 1
	local widget = self:_create_widget(widget_name, self._input_info_definition)
	local data = {
		alpha_multiplier = 0,
		id = id,
		validation_function = optional_validation_function,
		input_action = input_action,
		description = description,
		text = text,
		widget = widget,
		widget_name = widget_name,
		icon = icon,
		extra_height = icon and icon_height + 10 or 0
	}
	local style = widget.style
	local content = widget.content
	local offset = widget.offset
	content.icon = icon
	content.text = text

	if icon then
		local icon_style = style.icon
		icon_style.size[1] = icon_width
		icon_style.size[2] = icon_height
	end

	return data
end

HudElementWieldInfo._input_by_id = function (self, id)
	local active_wield_inputs = self._active_wield_inputs

	for i = 1, #active_wield_inputs do
		local input = active_wield_inputs[i]

		if input.id == id then
			return input
		end
	end
end

HudElementWieldInfo._remove_entry = function (self, index)
	local active_wield_inputs = self._active_wield_inputs
	local data = table.remove(active_wield_inputs, index)
	local widget = data.widget
	local widget_name = data.widget_name

	self:_unregister_widget_name(widget_name)
end

HudElementWieldInfo.update = function (self, dt, t)
	local parent = self._parent
	local extensions = parent:player_extensions()

	if not extensions then
		return
	end

	local player = self._parent:player()
	local unit_data = extensions.unit_data
	local inventory_component = unit_data:read_component("inventory")
	local wielded_slot_id = inventory_component.wielded_slot
	local visual_loadout_extension = extensions.visual_loadout
	local ability_extension = extensions.ability
	local active_wield_inputs = self._active_wield_inputs

	for i = 1, #active_wield_inputs do
		active_wield_inputs[i].synced = false
	end

	local weapon_name, weapon_template, weapon_action_component, current_action_name, current_action, current_passive_wield_info_name = nil
	weapon_name = wielded_slot_id ~= "none" and inventory_component[wielded_slot_id]
	weapon_template = weapon_name and visual_loadout_extension:weapon_template_from_slot(wielded_slot_id)

	if weapon_template then
		local weapon_action_component = unit_data:read_component("weapon_action")
		current_action_name, current_action = Action.current_action(weapon_action_component, weapon_template)
	end

	local item = weapon_name and visual_loadout_extension:item_from_slot(wielded_slot_id)
	local input_descriptions = item and item.input_descriptions
	local update_weapon_action = input_descriptions and current_action_name ~= self._previous_action_name

	if not input_descriptions then
		for i = 1, #WieldInfoPassivesTemplates do
			local data = WieldInfoPassivesTemplates[i]
			local name = data.name
			local validation_function = data.validation_function

			if validation_function(wielded_slot_id, item, current_action, current_action_name, player) then
				current_passive_wield_info_name = name
				input_descriptions = data.input_descriptions

				break
			end
		end
	end

	local reset_all = wielded_slot_id ~= self._wielded_slot_id or current_passive_wield_info_name ~= self._current_passive_wield_info_name
	local update = reset_all or update_weapon_action
	local entries_removed = false

	if reset_all then
		for i = #active_wield_inputs, 1, -1 do
			self:_remove_entry(i)

			entries_removed = true
		end
	else
		for i = #active_wield_inputs, 1, -1 do
			local input = active_wield_inputs[i]
			local validation_function = input.validation_function

			if validation_function and not validation_function(wielded_slot_id, item, current_action, current_action_name, player) then
				self:_remove_entry(i)

				entries_removed = true
			end
		end
	end

	self._wielded_slot_id = wielded_slot_id
	self._previous_action_name = current_action_name
	self._current_passive_wield_info_name = current_passive_wield_info_name
	local entries_added = false

	if input_descriptions and input_descriptions and #input_descriptions > 0 then
		local previous_input_icon_size = 0

		for i = #input_descriptions, 1, -1 do
			local input = input_descriptions[i]
			local id = input.id

			if not self:_input_by_id(id) then
				local weapon_template_validation_function = input.weapon_template_validation_function
				local validation_function = weapon_template and weapon_template_validation_function and weapon_template_validation_function ~= "" and weapon_template[weapon_template_validation_function]

				if not validation_function or validation_function(wielded_slot_id, item, current_action, current_action_name, player) then
					local data = self:_create_entry(input, validation_function)
					active_wield_inputs[#active_wield_inputs + 1] = data
					entries_added = true
				end
			end
		end
	end

	if entries_added or entries_removed then
		self:_realign_input_entries()
	end

	self._draw_info = #active_wield_inputs > 0
end

HudElementWieldInfo._realign_input_entries = function (self)
	local active_wield_inputs = self._active_wield_inputs
	local num_entries = #active_wield_inputs
	local previous_input_icon_size = 0

	for i = num_entries, 1, -1 do
		local data = active_wield_inputs[i]
		local widget = data.widget
		local offset = widget.offset
		local extra_height = data.extra_height
		offset[2] = -((num_entries - i) * 40 + previous_input_icon_size)
		previous_input_icon_size = previous_input_icon_size + extra_height
	end
end

HudElementWieldInfo._get_input_alias = function (self, alias_name)
	local service_type = "Ingame"
	local alias = Managers.input:alias_object(service_type)

	return alias
end

HudElementWieldInfo._get_input_text = function (self, alias_name)
	local service_type = "Ingame"
	local alias_array_index = 1
	local alias = Managers.input:alias_object(service_type)
	local key_info = alias:get_keys_for_alias(alias_name, alias_array_index, _input_devices)
	local input_key = key_info and InputUtils.localized_string_from_key_info(key_info) or "n/a"

	return input_key
end

return HudElementWieldInfo
