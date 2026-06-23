-- chunkname: @scripts/ui/hud/elements/weapon_counter/templates/weapon_counter_template_cooldown_charges.lua

local Colors = require("scripts/utilities/ui/colors")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local UIHudSettings = require("scripts/settings/ui/ui_hud_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local MAX_BAR_MODIFIER = 0.35
local MAX_NUM_BARS = 8
local FILL_TEXTURE = "content/ui/textures/masks/square"
local UNFILLED_FILL_OPACITY = 0.7
local FILLED_FILL_OPACITY = 0.6
local UNFILLED_OUTLINE_COLOR = UIHudSettings.color_tint_main_2
local FILLED_OUTLINE_COLOR = UIHudSettings.color_tint_main_2
local SIZE_THICKNESS_OUTLINE_DEFAULT = {
	0.6,
	0.015,
	0.011,
}
local SIZE_THICKNESS_OUTLINE_SPECIAL_ACTIVE = {
	0.6,
	0.017,
	0.011,
}
local OUTLINE_OPACITY_DEFAULT = 0.8
local OUTLINE_OPACITY_SPECIAL_ACTIVE = 1
local SPECIAL_ACTIVE_TRANSITION_TIME = 0.2
local DISPLAY_CHARGES_HIT_CATCHUP_TIME = 0.2
local DISPLAY_CHARGES_SNAP_THRESHOLD = 2
local PASSIVE_PREDICTION_FILL_CAP = 1
local SCHEDULED_TICK_FILL_TOLERANCE = 0.5
local PULSE_HOLD_TIME = 0.2
local PULSE_DECAY_RATE = 4
local PULSE_FILL_INTENSITY_PEAK = 5
local PULSE_OUTLINE_INTENSITY_PEAK = 2
local PULSE_THICKNESS_PEAK = 0.01
local FADE_WHEN_FULL = true
local FADE_LINGER_TIME = 2
local FADE_OUT_TIME = 0.5
local CHARGE_BAR_STYLE_IDS = {}

for ii = 1, MAX_NUM_BARS do
	CHARGE_BAR_STYLE_IDS[ii] = string.format("charge_bar_%d", ii)
end

local weapon_counter_template_cooldown_charges = {
	data = {
		state = {},
	},
}
local length = 400
local thickness = 400
local size = {
	length,
	thickness,
}
local center_size = {
	4,
	4,
}

weapon_counter_template_cooldown_charges.name = "cooldown_charges"
weapon_counter_template_cooldown_charges.size = size
weapon_counter_template_cooldown_charges.center_size = center_size

local function _charge_state(template, ui_hud)
	local player_extensions = ui_hud:player_extensions()

	if not player_extensions then
		return nil
	end

	local unit_data_extension = player_extensions.unit_data
	local visual_loadout_extension = player_extensions.visual_loadout
	local inventory_comp = unit_data_extension:read_component("inventory")
	local wielded_slot = inventory_comp.wielded_slot

	if wielded_slot == "none" then
		return nil
	end

	if slot_configuration[wielded_slot].slot_type ~= "weapon" then
		return nil
	end

	local slot_name = template.data.slot_name
	local inventory_slot_component = unit_data_extension:read_component(slot_name)
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot_name)
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data

	if not weapon_special_tweak_data then
		return nil
	end

	local thresholds = weapon_special_tweak_data.thresholds
	local max_charges = weapon_special_tweak_data.max_charges

	if not thresholds or not max_charges then
		return nil
	end

	local segment_charges = #thresholds >= 2 and thresholds[2].threshold - thresholds[1].threshold or 1
	local should_predict = segment_charges == 1
	local interval = weapon_special_tweak_data.passive_charge_add_interval or weapon_special_tweak_data.cooldown
	local state = template.data.state

	state.weapon_template = weapon_template
	state.num = inventory_slot_component.num_special_charges or 0
	state.max_charges = max_charges
	state.thresholds = thresholds
	state.special_active = not should_predict and inventory_slot_component.special_active == true
	state.should_predict = should_predict
	state.interval = interval
	state.active_duration = weapon_special_tweak_data.active_duration or 0
	state.per_tick = weapon_special_tweak_data.passive_num_charges_to_add or 1

	return state
end

local function _set_arc_sizes(widget, thresholds, max_charges)
	if not thresholds or #thresholds < 2 or not max_charges then
		return
	end

	local style = widget.style
	local max_segments = #thresholds - 1
	local total_min = 0.5 - MAX_BAR_MODIFIER / 2
	local gap_size = MAX_BAR_MODIFIER / max_segments * 0.25

	for ii = 1, MAX_NUM_BARS do
		local segment_style = style[CHARGE_BAR_STYLE_IDS[ii]]

		if max_segments < ii then
			segment_style.material_values.arc_top_bottom[1] = 0
			segment_style.material_values.arc_top_bottom[2] = 0
		else
			local low = thresholds[ii].threshold
			local high = thresholds[math.min(ii + 1, #thresholds)].threshold
			local range_per_bar = MAX_BAR_MODIFIER * (high - low) / max_charges

			segment_style.material_values.arc_top_bottom[1] = total_min + range_per_bar - gap_size
			segment_style.material_values.arc_top_bottom[2] = total_min + gap_size
			total_min = total_min + range_per_bar
		end
	end
end

weapon_counter_template_cooldown_charges.create_widget_defintion = function (scenegraph_id)
	local charge_bar_offset_right = {
		0,
		0,
		1,
	}

	local function create_passes(num_bars)
		local passes = {}

		for ii = 1, num_bars do
			passes[ii] = {
				pass_type = "texture",
				value = "content/ui/materials/effects/forcesword_bar",
				style_id = CHARGE_BAR_STYLE_IDS[ii],
				style = {
					horizontal_alignment = "center",
					vertical_alignment = "center",
					offset = {
						charge_bar_offset_right[1],
						charge_bar_offset_right[2],
						ii + 1,
					},
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
							OUTLINE_OPACITY_DEFAULT,
						},
						outline_color = Colors.format_color_to_material(UNFILLED_OUTLINE_COLOR),
						fillcolor = UIHudSettings.color_tint_main_1,
						SizeThicknessOutline = {
							SIZE_THICKNESS_OUTLINE_DEFAULT[1],
							SIZE_THICKNESS_OUTLINE_DEFAULT[2],
							SIZE_THICKNESS_OUTLINE_DEFAULT[3],
						},
						fillTex = FILL_TEXTURE,
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
					size[1] / 1.4,
					size[2] / 1.4,
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
					fillTex = FILL_TEXTURE,
				},
			},
		}

		return passes
	end

	return UIWidget.create_definition(create_passes(MAX_NUM_BARS), scenegraph_id)
end

weapon_counter_template_cooldown_charges.on_enter = function (hud_element_weapon_counter, slot_name, widget, template)
	template.data.slot_name = slot_name

	local ui_hud = hud_element_weapon_counter._parent
	local state = _charge_state(template, ui_hud)

	if state then
		_set_arc_sizes(widget, state.thresholds, state.max_charges)
	end
end

local function _catchup_displayed_post_tick(previous_displayed, effective_charges, dt)
	if effective_charges < previous_displayed then
		return effective_charges
	end

	if effective_charges - previous_displayed > DISPLAY_CHARGES_SNAP_THRESHOLD then
		return effective_charges
	end

	local catchup_per_second = 1 / DISPLAY_CHARGES_HIT_CATCHUP_TIME

	return math.min(previous_displayed + dt * catchup_per_second, effective_charges)
end

local function _catchup_displayed_predicted(previous_displayed, effective_charges, dt)
	if math.abs(effective_charges - previous_displayed) > DISPLAY_CHARGES_SNAP_THRESHOLD then
		return effective_charges
	end

	local catchup_per_second = 1 / DISPLAY_CHARGES_HIT_CATCHUP_TIME

	if effective_charges < previous_displayed then
		return math.max(previous_displayed - dt * catchup_per_second, effective_charges)
	end

	return math.min(previous_displayed + dt * catchup_per_second, effective_charges)
end

weapon_counter_template_cooldown_charges.update_function = function (hud_element_weapon_counter, ui_renderer, widget, is_currently_wielded, weapon_counter_settings, template, dt, t)
	local content = widget.content
	local style = widget.style
	local ui_hud = hud_element_weapon_counter._parent
	local state = _charge_state(template, ui_hud)
	local max_thresholds = state and #state.thresholds or 0
	local current_weapon_template = state and state.weapon_template

	if current_weapon_template ~= content.last_weapon_template then
		content.last_weapon_template = current_weapon_template

		if state then
			_set_arc_sizes(widget, state.thresholds, state.max_charges)
		end

		content.previous_filled = nil
		content.delay_timer = nil
		content.pulse = nil
		content.displayed_charges = nil
		content.previous_num_charges = nil
		content.synth_next_tick_at = nil
		content.idle_alpha = nil
		content.idle_linger = nil
	end

	content.previous_filled = content.previous_filled or {}
	content.delay_timer = content.delay_timer or {}
	content.pulse = content.pulse or {}

	local effective_charges = 0
	local actual_num_charges = 0
	local smooth_thresholds
	local should_predict = false
	local actually_spent_this_frame = false
	local previous_num_charges

	if state then
		actual_num_charges = state.num
		smooth_thresholds = state.thresholds
		should_predict = state.should_predict
		previous_num_charges = content.previous_num_charges
		content.previous_num_charges = actual_num_charges
		actually_spent_this_frame = previous_num_charges ~= nil and actual_num_charges < previous_num_charges

		if previous_num_charges ~= nil and actual_num_charges ~= previous_num_charges and state.interval and state.interval > 0 then
			if actual_num_charges < previous_num_charges then
				content.synth_next_tick_at = t + state.interval + state.active_duration
			else
				local predicted = content.displayed_charges or actual_num_charges
				local anticipated_tick = not content.synth_next_tick_at or predicted >= actual_num_charges - SCHEDULED_TICK_FILL_TOLERANCE

				if anticipated_tick then
					content.synth_next_tick_at = t + state.interval
				end
			end
		end

		effective_charges = actual_num_charges

		local can_predict = should_predict and not state.special_active and actual_num_charges < state.max_charges and state.interval and state.interval > 0 and content.synth_next_tick_at

		if can_predict then
			local time_to_next = content.synth_next_tick_at - t
			local fractional = math.clamp01(1 - time_to_next / state.interval) * PASSIVE_PREDICTION_FILL_CAP

			effective_charges = math.min(actual_num_charges + fractional * state.per_tick, state.max_charges)
		end
	end

	local catchup_displayed = should_predict and _catchup_displayed_predicted or _catchup_displayed_post_tick
	local previous_displayed = content.displayed_charges or effective_charges
	local displayed_charges = catchup_displayed(previous_displayed, effective_charges, dt)

	content.displayed_charges = displayed_charges

	local special_active = state and state.special_active or false
	local target = special_active and 1 or 0
	local progress = content.special_active_progress or target
	local step = dt / SPECIAL_ACTIVE_TRANSITION_TIME

	if progress < target then
		progress = math.min(target, progress + step)
	elseif target < progress then
		progress = math.max(target, progress - step)
	end

	content.special_active_progress = progress

	local active_thickness_radius = math.lerp(SIZE_THICKNESS_OUTLINE_DEFAULT[1], SIZE_THICKNESS_OUTLINE_SPECIAL_ACTIVE[1], progress)
	local active_thickness = math.lerp(SIZE_THICKNESS_OUTLINE_DEFAULT[2], SIZE_THICKNESS_OUTLINE_SPECIAL_ACTIVE[2], progress)
	local active_thickness_outline = math.lerp(SIZE_THICKNESS_OUTLINE_DEFAULT[3], SIZE_THICKNESS_OUTLINE_SPECIAL_ACTIVE[3], progress)
	local active_outline_opacity = math.lerp(OUTLINE_OPACITY_DEFAULT, OUTLINE_OPACITY_SPECIAL_ACTIVE, progress)
	local is_full_idle = state ~= nil and state.num >= state.max_charges and not state.special_active

	if FADE_WHEN_FULL and is_full_idle then
		content.idle_linger = (content.idle_linger or FADE_LINGER_TIME) - dt
	else
		content.idle_linger = FADE_LINGER_TIME
	end

	local fade_target = FADE_WHEN_FULL and is_full_idle and content.idle_linger <= 0 and 0 or 1
	local current_alpha = content.idle_alpha or 1

	if fade_target < current_alpha then
		current_alpha = math.max(fade_target, current_alpha - dt / FADE_OUT_TIME)
	else
		current_alpha = fade_target
	end

	content.idle_alpha = current_alpha

	for ii = 2, max_thresholds do
		local index = ii - 1
		local percentage_filled = 0
		local segment_full_threshold

		if smooth_thresholds then
			local low_node = smooth_thresholds[index]
			local high_node = smooth_thresholds[math.min(index + 1, #smooth_thresholds)]

			if low_node and high_node then
				local low = low_node.threshold
				local high = high_node.threshold

				segment_full_threshold = high

				if low < high then
					percentage_filled = math.clamp01((displayed_charges - low) / (high - low))
				end
			end
		end

		local segment_style = style[CHARGE_BAR_STYLE_IDS[index]]
		local material_values = segment_style.material_values
		local was_filled = content.previous_filled[index] or false
		local now_filled = percentage_filled >= 1
		local crossed_full_boundary = segment_full_threshold ~= nil and previous_num_charges ~= nil and segment_full_threshold <= previous_num_charges and actual_num_charges < segment_full_threshold
		local just_spent = was_filled and not now_filled and actually_spent_this_frame or crossed_full_boundary
		local delay = content.delay_timer[index] or 0

		if just_spent then
			delay = PULSE_HOLD_TIME
		end

		if delay > 0 then
			delay = math.max(0, delay - dt)
		end

		content.delay_timer[index] = delay

		if just_spent then
			content.pulse[index] = 1
		end

		local pulse = math.max(0, (content.pulse[index] or 0) - dt * PULSE_DECAY_RATE)

		content.pulse[index] = pulse

		local segment_filled = delay > 0 or now_filled
		local base_color = segment_filled and FILLED_OUTLINE_COLOR or UNFILLED_OUTLINE_COLOR
		local color_pulse = delay > 0 and 1 or pulse
		local fill_intensity = 1 + color_pulse * PULSE_FILL_INTENSITY_PEAK
		local outline_intensity = 1 + color_pulse * PULSE_OUTLINE_INTENSITY_PEAK
		local fillcolor = material_values.fillcolor

		fillcolor[1] = math.min(base_color[2] / 255 * fill_intensity, 2)
		fillcolor[2] = math.min(base_color[3] / 255 * fill_intensity, 2)
		fillcolor[3] = math.min(base_color[4] / 255 * fill_intensity, 2)
		fillcolor[4] = 1

		local outline_color = material_values.outline_color

		outline_color[1] = math.min(base_color[2] * outline_intensity, 255) / 255
		outline_color[2] = math.min(base_color[3] * outline_intensity, 255) / 255
		outline_color[3] = math.min(base_color[4] * outline_intensity, 255) / 255
		outline_color[4] = 1
		material_values.fill_outline_opacity[1] = (segment_filled and FILLED_FILL_OPACITY or UNFILLED_FILL_OPACITY) * current_alpha
		material_values.fill_outline_opacity[2] = active_outline_opacity * current_alpha
		material_values.amount = delay > 0 and 1 or percentage_filled

		local size_thickness_outline = material_values.SizeThicknessOutline

		size_thickness_outline[1] = active_thickness_radius
		size_thickness_outline[2] = active_thickness + pulse * PULSE_THICKNESS_PEAK
		size_thickness_outline[3] = active_thickness_outline
		content.previous_filled[index] = now_filled
	end

	if state and style.lightning_and_glow then
		local glow_material_values = style.lightning_and_glow.material_values

		if glow_material_values and glow_material_values.fill_outline_opacity then
			glow_material_values.fill_outline_opacity[1] = FILLED_FILL_OPACITY * current_alpha
			glow_material_values.fill_outline_opacity[2] = 1 * current_alpha
		end
	end

	for ii = max_thresholds, MAX_NUM_BARS do
		local segment_style = style[CHARGE_BAR_STYLE_IDS[ii]]

		if segment_style then
			local material_values = segment_style.material_values

			material_values.amount = 0

			if material_values.fill_outline_opacity then
				material_values.fill_outline_opacity[1] = 0
				material_values.fill_outline_opacity[2] = 0
			end
		end
	end

	local visible = is_currently_wielded or weapon_counter_settings.show_when_unwielded and not is_currently_wielded

	widget.visible = visible

	if not visible then
		return
	end
end

return weapon_counter_template_cooldown_charges
