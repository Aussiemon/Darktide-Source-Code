-- chunkname: @scripts/ui/hud/elements/weapon_counter/templates/weapon_counter_template_kill_charges.lua

local Colors = require("scripts/utilities/ui/colors")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local MAX_BAR_MODIFIER = 0.5
local MAX_NUM_BARS = 5
local UNFILLED_FILL_OPACITY = 0.95
local FILLED_FILL_OPACITY = 1.3
local UNFILLED_OUTLINE_COLOR = {
	255,
	166,
	192,
	147,
}
local FILLED_OUTLINE_COLOR = {
	255,
	241,
	255,
	230,
}
local weapon_counter_template_kill_charges = {
	data = {},
}
local length = 240
local thickness = 240
local size = {
	length,
	thickness,
}
local center_size = {
	4,
	4,
}

weapon_counter_template_kill_charges.name = "kill_charges"
weapon_counter_template_kill_charges.size = size
weapon_counter_template_kill_charges.center_size = center_size

local function _current_and_max_thresholds(template, ui_hud)
	local player_extensions = ui_hud:player_extensions()

	if not player_extensions then
		return 0, 0
	end

	local unit_data_extension = player_extensions.unit_data
	local visual_loadout_extension = player_extensions.visual_loadout
	local inventory_comp = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot == "none" then
		return 0, 0
	end

	local slot_type = slot_configuration[wielded_slot].slot_type

	if slot_type ~= "weapon" then
		return 0, 0
	end

	local slot_name = template.data.slot_name
	local inventory_slot_component = unit_data_extension:read_component(slot_name)
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	if not weapon_special_tweak_data then
		return 0, 0
	end

	local num_special_charges = inventory_slot_component.num_special_charges
	local thresholds = weapon_special_tweak_data.thresholds
	local max_charges = weapon_special_tweak_data.max_charges

	if not thresholds or not max_charges then
		return 0, 0
	end

	local current_threshold = 1
	local num_thresholds = #thresholds

	for ii = #thresholds, 1, -1 do
		if num_special_charges >= thresholds[ii].threshold then
			current_threshold = ii

			break
		end
	end

	return current_threshold, num_thresholds
end

local function _segment_threshold_progress(template, ui_hud, segment_index, current_threshold)
	local player_extensions = ui_hud:player_extensions()

	if not player_extensions then
		return 0
	end

	local unit_data_extension = player_extensions.unit_data
	local visual_loadout_extension = player_extensions.visual_loadout
	local inventory_comp = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot == "none" then
		return 0
	end

	local slot_type = slot_configuration[wielded_slot].slot_type

	if slot_type ~= "weapon" then
		return 0
	end

	local slot_name = template.data.slot_name
	local inventory_slot_component = unit_data_extension:read_component(slot_name)
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	if not weapon_special_tweak_data then
		return 0
	end

	local num_special_charges = inventory_slot_component.num_special_charges
	local thresholds = weapon_special_tweak_data.thresholds
	local max_charges = weapon_special_tweak_data.max_charges

	if not thresholds or not max_charges then
		return 0
	end

	local threshold_segment = thresholds[segment_index]
	local next_threshold_segment = thresholds[math.min(segment_index + 1, #thresholds)]
	local threshold = threshold_segment.threshold
	local next_threshold = next_threshold_segment.threshold
	local charges_into_segment = num_special_charges - threshold
	local charges_in_segment = next_threshold - threshold
	local percentage_filled = math.clamp01(charges_into_segment / charges_in_segment)

	return percentage_filled
end

local function _percentage_of_max_per_segment(template, ui_hud, segment_index)
	local player_extensions = ui_hud:player_extensions()

	if not player_extensions then
		return 0
	end

	local unit_data_extension = player_extensions.unit_data
	local visual_loadout_extension = player_extensions.visual_loadout
	local inventory_comp = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot == "none" then
		return 0
	end

	local slot_type = slot_configuration[wielded_slot].slot_type

	if slot_type ~= "weapon" then
		return 0
	end

	local slot_name = template.data.slot_name
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	if not weapon_special_tweak_data then
		return 0
	end

	local thresholds = weapon_special_tweak_data.thresholds
	local max_charges = weapon_special_tweak_data.max_charges

	if not thresholds or not max_charges then
		return 0
	end

	local threshold_segment = thresholds[segment_index]
	local next_threshold_segment = thresholds[math.min(segment_index + 1, #thresholds)]
	local threshold = threshold_segment.threshold
	local next_threshold = next_threshold_segment.threshold
	local charges_in_segment = next_threshold - threshold
	local percentage_of_max = charges_in_segment / max_charges

	return percentage_of_max
end

local function _min_max_material_arc_values(template, ui_hud, segment_index, max_segments)
	local percentage_of_max = _percentage_of_max_per_segment(template, ui_hud, segment_index)
	local range_per_bar = 1 * MAX_BAR_MODIFIER * percentage_of_max
	local min = 0
	local max = range_per_bar

	return min, max
end

local function _set_arc_sizes(widget, ui_hud, template, max_segments)
	local style = widget.style
	local total_min = 0
	local gap_size = MAX_BAR_MODIFIER / max_segments * 0.15

	for ii = 1, MAX_NUM_BARS do
		local add_top_gap = ii < max_segments
		local add_bottom_gap = ii > 1
		local segment_style = style[string.format("charge_bar_%d", ii)]

		if max_segments < ii then
			segment_style.material_values.arc_top_bottom[1] = 0
			segment_style.material_values.arc_top_bottom[2] = 0
		else
			local min, max = _min_max_material_arc_values(template, ui_hud, ii, max_segments)

			segment_style.material_values.arc_top_bottom[1] = total_min + min + max - (add_top_gap and gap_size or 0)
			segment_style.material_values.arc_top_bottom[2] = total_min + min + (add_bottom_gap and gap_size or 0)
			total_min = total_min + min + max
		end
	end
end

weapon_counter_template_kill_charges.create_widget_defintion = function (scenegraph_id)
	local charge_bar_offset_right = {
		60,
		41,
		1,
	}

	local function create_passes(num_bars)
		local passes = {}

		for ii = 1, num_bars do
			local offset = {
				charge_bar_offset_right[1],
				charge_bar_offset_right[2],
				ii + 1,
			}

			passes[ii] = {
				pass_type = "texture",
				value = "content/ui/materials/effects/forcesword_bar",
				style_id = string.format("charge_bar_%d", ii),
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = offset,
					size = {
						size[1],
						size[2],
					},
					color = UIHudSettings.color_tint_main_1,
					material_values = {
						amount = 0.5,
						glow_on_off = 0,
						lightning_opacity = 0,
						arc_top_bottom = {
							1,
							0,
						},
						fill_outline_opacity = {
							FILLED_FILL_OPACITY,
							1,
						},
						outline_color = Colors.format_color_to_material(UNFILLED_OUTLINE_COLOR),
					},
				},
			}
		end

		passes[#passes + 1] = {
			pass_type = "texture",
			style_id = "lightning_and_glow",
			value = "content/ui/materials/effects/forcesword_bar",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center",
				offset = {
					charge_bar_offset_right[1],
					charge_bar_offset_right[2],
					1,
				},
				size = {
					size[1],
					size[2],
				},
				color = UIHudSettings.color_tint_main_1,
				material_values = {
					amount = 0,
					glow_on_off = 0,
					lightning_opacity = 0,
					arc_top_bottom = {
						0,
						1,
					},
					fill_outline_opacity = {
						FILLED_FILL_OPACITY,
						1,
					},
					outline_color = Colors.format_color_to_material(UNFILLED_OUTLINE_COLOR),
				},
			},
		}

		return passes
	end

	return UIWidget.create_definition(create_passes(MAX_NUM_BARS), scenegraph_id)
end

weapon_counter_template_kill_charges.on_enter = function (hud_element_weapon_counter, slot_name, widget, template)
	template.data.slot_name = slot_name

	local ui_hud = hud_element_weapon_counter._parent
	local _, max_thresholds = _current_and_max_thresholds(template, ui_hud)

	_set_arc_sizes(widget, ui_hud, template, max_thresholds - 1)
end

weapon_counter_template_kill_charges.update_function = function (hud_element_weapon_counter, ui_renderer, widget, is_currently_wielded, weapon_counter_settings, template, dt, t)
	local content = widget.content
	local style = widget.style
	local ui_hud = hud_element_weapon_counter._parent
	local current_threshold, max_thresholds = _current_and_max_thresholds(template, ui_hud)

	for ii = 2, max_thresholds do
		local percentage_filled = _segment_threshold_progress(template, ui_hud, ii - 1, current_threshold)
		local segment_style = style[string.format("charge_bar_%d", ii - 1)]

		segment_style.material_values.amount = percentage_filled
		segment_style.material_values.lightning_opacity = 0

		local segment_filled = percentage_filled >= 1

		if segment_filled then
			segment_style.material_values.fill_outline_opacity[1] = FILLED_FILL_OPACITY
			segment_style.material_values.outline_color = Colors.format_color_to_material(FILLED_OUTLINE_COLOR)
		else
			segment_style.material_values.fill_outline_opacity[1] = UNFILLED_FILL_OPACITY
			segment_style.material_values.outline_color = Colors.format_color_to_material(UNFILLED_OUTLINE_COLOR)
		end

		if ii == max_thresholds and segment_filled then
			style.lightning_and_glow.material_values.lightning_opacity = 0.414
		else
			style.lightning_and_glow.material_values.lightning_opacity = 0
		end
	end

	local visible = is_currently_wielded or weapon_counter_settings.show_when_unwielded and not is_currently_wielded

	widget.visible = visible

	if not visible then
		return
	end
end

return weapon_counter_template_kill_charges
