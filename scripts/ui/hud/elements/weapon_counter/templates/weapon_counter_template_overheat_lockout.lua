-- chunkname: @scripts/ui/hud/elements/weapon_counter/templates/weapon_counter_template_overheat_lockout.lua

local Overheat = require("scripts/utilities/overheat")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local weapon_counter_template_overheat_lockout = {
	data = {}
}
local length = 200
local thickness = 200
local size = {
	length,
	thickness
}
local center_size = {
	4,
	4
}

weapon_counter_template_overheat_lockout.name = "overheat_lockout"
weapon_counter_template_overheat_lockout.size = size
weapon_counter_template_overheat_lockout.center_size = center_size

local function _current_overheat_status(template, ui_hud)
	local player_extensions = ui_hud:player_extensions()

	if not player_extensions then
		return nil, 0, "", false
	end

	local unit_data_extension = player_extensions.unit_data
	local visual_loadout_extension = player_extensions.visual_loadout
	local inventory_comp = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot == "none" then
		return nil, 0, "", false
	end

	local slot_name = template.data.slot_name
	local inventory_slot_component = unit_data_extension:read_component(slot_name)
	local special_active = inventory_slot_component.special_active
	local overheat_configuration = Overheat.configuration(visual_loadout_extension, slot_name)

	if overheat_configuration then
		local slot_component = unit_data_extension:read_component(slot_name)
		local overheat_level = slot_component.overheat_current_percentage
		local overheat_state = slot_component.overheat_state

		return overheat_configuration, overheat_level, overheat_state, special_active
	end

	return nil, 0, "", false
end

weapon_counter_template_overheat_lockout.create_widget_defintion = function (scenegraph_id)
	local center_half_width = center_size[1] * 0.5
	local charge_bar_offset = 100
	local charge_bar_offset_right = {
		charge_bar_offset + center_half_width,
		35,
		1
	}

	return UIWidget.create_definition({
		{
			value = "content/ui/materials/effects/powersword_bar",
			style_id = "charge_bar",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				offset = charge_bar_offset_right,
				size = {
					size[1],
					size[2]
				},
				color = UIHudSettings.color_tint_main_1,
				material_values = {
					color_blend = 0,
					outline_opacity = 1,
					fill_opacity = 1,
					progress = 0,
					active = 0,
					lockout = 0
				}
			}
		}
	}, scenegraph_id)
end

weapon_counter_template_overheat_lockout.on_enter = function (hud_element_weapon_counter, slot_name, widget, template)
	template.data.slot_name = slot_name
end

weapon_counter_template_overheat_lockout.update_function = function (hud_element_weapon_counter, ui_renderer, widget, is_currently_wielded, weapon_counter_settings, template, dt, t)
	local content = widget.content
	local style = widget.style
	local overheat_configuration, overheat_percentage, overheat_state, special_active = _current_overheat_status(template, hud_element_weapon_counter._parent)
	local visible = is_currently_wielded or weapon_counter_settings.show_when_unwielded and not is_currently_wielded

	widget.visible = visible

	if not visible then
		return
	end

	local lockout = overheat_state == "lockout"
	local charge_bar_style = style.charge_bar

	charge_bar_style.material_values.progress = math.lerp(0.028, 0.252, overheat_percentage)
	charge_bar_style.material_values.active = special_active and 1 or 0
	charge_bar_style.material_values.color_blend = math.lerp(0, 1, lockout and 1 or math.easeInCubic(overheat_percentage) + 0.1)
	charge_bar_style.material_values.fill_opacity = special_active and not lockout and 0.75 or 0.4
	charge_bar_style.material_values.outline_opacity = special_active and not lockout and 2 or 1
	charge_bar_style.material_values.lockout = lockout and 1 or 0
end

return weapon_counter_template_overheat_lockout
