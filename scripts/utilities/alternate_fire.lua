local BuffSettings = require("scripts/settings/buff/buff_settings")
local PlayerUnitPeeking = require("scripts/utilities/player_unit_peeking")
local Spread = require("scripts/utilities/spread")
local Sway = require("scripts/utilities/sway")
local proc_events = BuffSettings.proc_events
local AlternateFire = {
	start = function (alternate_fire_component, weapon_tweak_templates_component, spread_control_component, sway_control_component, sway_component, movement_state_component, peeking_component, first_person_extension, animation_extension, weapon_extension, weapon_template, player_unit, t)
		local alternate_fire_settings = weapon_template.alternate_fire_settings
		alternate_fire_component.is_active = true
		alternate_fire_component.start_t = t
		local spread_template_name = alternate_fire_settings.spread_template or weapon_template.spread_template or "none"
		local recoil_template_name = alternate_fire_settings.recoil_template or weapon_template.recoil_template or "none"
		local sway_template_name = alternate_fire_settings.sway_template or weapon_template.sway_template or "none"
		local suppression_template_name = alternate_fire_settings.suppression_template or weapon_template.suppression_template or "none"
		local toughness_template_name = alternate_fire_settings.toughness_template or weapon_template.toughness_template or "none"
		weapon_tweak_templates_component.spread_template_name = spread_template_name
		weapon_tweak_templates_component.recoil_template_name = recoil_template_name
		weapon_tweak_templates_component.sway_template_name = sway_template_name
		weapon_tweak_templates_component.suppression_template_name = suppression_template_name
		weapon_tweak_templates_component.toughness_template_name = toughness_template_name
		local start_anim_event = alternate_fire_settings.start_anim_event
		local start_anim_event_3p = alternate_fire_settings.start_anime_event_3p or start_anim_event

		if start_anim_event and start_anim_event_3p then
			animation_extension:anim_event_1p(start_anim_event)
			animation_extension:anim_event(start_anim_event_3p)
		end

		local spread_template = weapon_extension:spread_template()
		local sway_template = weapon_extension:sway_template()

		Sway.add_immediate_sway(sway_template, sway_control_component, sway_component, movement_state_component, "alternate_fire_start")
		Spread.add_immediate_spread(t, spread_template, spread_control_component, movement_state_component, "alternate_fire_start")

		local player = Managers.state.player_unit_spawn:owner(player_unit)

		if player.aim_assist_data then
			player.aim_assist_data.wants_lock_on = true
		end

		if alternate_fire_settings.peeking_mechanics and peeking_component.peeking_is_possible then
			PlayerUnitPeeking.start(peeking_component, t)
		end

		local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = player_unit

			buff_extension:add_proc_event(proc_events.on_alternative_fire_start, param_table)
		end

		if Managers.stats.can_record_stats() then
			Managers.stats:record_alternate_fire_start(player)
		end
	end
}

AlternateFire.stop = function (alternate_fire_component, peeking_component, first_person_extension, weapon_tweak_templates_component, animation_extension, weapon_template, skip_stop_anim, player_unit, from_action_input)
	alternate_fire_component.is_active = false
	local spread_template_name = weapon_template.spread_template or "none"
	local recoil_template_name = weapon_template.recoil_template or "none"
	local sway_template_name = weapon_template.sway_template or "none"
	local suppression_template_name = weapon_template.suppression_template or "none"
	local toughness_template_name = weapon_template.toughness_template or "none"
	weapon_tweak_templates_component.spread_template_name = spread_template_name
	weapon_tweak_templates_component.recoil_template_name = recoil_template_name
	weapon_tweak_templates_component.sway_template_name = sway_template_name
	weapon_tweak_templates_component.suppression_template_name = suppression_template_name
	weapon_tweak_templates_component.toughness_template_name = toughness_template_name

	if peeking_component.is_peeking then
		PlayerUnitPeeking.stop(peeking_component, first_person_extension)
	end

	local alternate_fire_settings = weapon_template.alternate_fire_settings
	local stop_anim_event = alternate_fire_settings.stop_anim_event
	local stop_anim_event_3p = alternate_fire_settings.stop_anim_event_3p or stop_anim_event

	if stop_anim_event and stop_anim_event_3p and not skip_stop_anim then
		animation_extension:anim_event_1p(stop_anim_event)
		animation_extension:anim_event(stop_anim_event_3p)
	end

	if not from_action_input then
		local action_input_extension = ScriptUnit.extension(player_unit, "action_input_system")

		action_input_extension:clear_input_queue_and_sequences("weapon_action")
	end

	if Managers.stats.can_record_stats() then
		local player = Managers.state.player_unit_spawn:owner(player_unit)

		Managers.stats:record_alternate_fire_stop(player)
	end
end

AlternateFire.check_exit = function (alternate_fire_component, weapon_template, input_extension, stunned_character_state_component, t)
	if not alternate_fire_component.is_active then
		return false
	end

	if stunned_character_state_component.stunned then
		return false
	end

	if not weapon_template then
		return true
	end

	local alternate_fire_settings = weapon_template.alternate_fire_settings

	if not alternate_fire_settings then
		return true
	end
end

AlternateFire.movement_speed_modifier = function (alternate_fire_component, weapon_template, t, weapon_extension)
	if not alternate_fire_component.is_active then
		return 1
	end

	local alternate_fire_settings = weapon_template.alternate_fire_settings
	local movement_speed_modifier = alternate_fire_settings.movement_speed_modifier

	if not movement_speed_modifier then
		return 1
	end

	local start_t = alternate_fire_component.start_t
	local time_in_alternate_fire = t - start_t
	local p1 = 1
	local p2 = 1
	local segment_progress = 0

	for i = 1, #movement_speed_modifier do
		local segment = movement_speed_modifier[i]
		local segment_t = segment.t

		if time_in_alternate_fire <= segment_t then
			p2 = segment.modifier
			segment_progress = segment_t == 0 and 0 or math.min(time_in_alternate_fire / segment_t, 1)
		else
			local modifier = segment.modifier
			p1 = modifier
			p2 = modifier
		end
	end

	local mod = math.lerp(p1, p2, segment_progress)
	mod = AlternateFire.modify_movement_curve(weapon_extension, mod)
	local unit = weapon_extension._unit
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local alternate_fire_movement_speed_reduction_modifier = stat_buffs.alternate_fire_movement_speed_reduction_modifier
	local delta = 1 - mod
	delta = delta * alternate_fire_movement_speed_reduction_modifier
	mod = 1 - delta

	return mod
end

AlternateFire.modify_movement_curve = function (weapon_extension, base_value)
	local weapon_movement_curve_modifier_template = weapon_extension:movement_curve_modifier_template()

	if weapon_movement_curve_modifier_template then
		local value = base_value * weapon_movement_curve_modifier_template.modifier or base_value

		return value
	end

	return base_value
end

AlternateFire.camera_variables = function (weapon_template)
	if not weapon_template then
		return nil, nil, nil
	end

	local alternate_fire_settings = weapon_template.alternate_fire_settings

	if not alternate_fire_settings then
		return nil, nil, nil
	end

	local camera_settings = alternate_fire_settings.camera

	if not camera_settings then
		return nil, nil, nil
	end

	local vertical_fov = math.degrees_to_radians(camera_settings.vertical_fov)
	local custom_vertical_fov = math.degrees_to_radians(camera_settings.custom_vertical_fov)
	local near_range = camera_settings.near_range

	return vertical_fov, custom_vertical_fov, near_range
end

AlternateFire.debug_set_alternate_fire = function (alternate_fire_component, active)
	alternate_fire_component.is_active = active
end

return AlternateFire
