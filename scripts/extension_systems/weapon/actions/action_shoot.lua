-- chunkname: @scripts/extension_systems/weapon/actions/action_shoot.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local AimAssist = require("scripts/utilities/aim_assist")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Component = require("scripts/utilities/component")
local InputDevice = require("scripts/managers/input/input_device")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Overheat = require("scripts/utilities/overheat")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Recoil = require("scripts/utilities/recoil")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local SmartTargeting = require("scripts/utilities/smart_targeting")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local Spread = require("scripts/utilities/spread")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Vo = require("scripts/utilities/vo")
local ActionShoot = class("ActionShoot", "ActionWeaponBase")
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSetting.special_rules
local DEFUALT_NUM_CRITICAL_SHOTS = 1
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local EMPTY_TABLE = {}
local ALT_FIRE_WWISE_SWITCH = {
	[false] = "false",
	[true] = "true",
}
local EXTERNAL_PROPERTIES = {}
local TAIL_SOURCE_POS = Vector3Box(0, 0, 0)
local DONT_SYNC_TO_SENDER = true
local SYNC_TO_CLIENTS = true
local _set_charge_level, _trigger_gear_sound, _trigger_exclusive_gear_sound, _trigger_gear_tail_sound, _trigger_critical_sound, _update_alt_fire_state

ActionShoot.init = function (self, action_context, action_params, action_settings)
	ActionShoot.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._action_component = unit_data_extension:write_component("action_shoot")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._recoil_component = unit_data_extension:read_component("recoil")
	self._recoil_control_component = unit_data_extension:write_component("recoil_control")
	self._sway_component = unit_data_extension:read_component("sway")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._alternate_fire_component = action_context.unit_data_extension:write_component("alternate_fire")
	self._shooting_status_component = unit_data_extension:write_component("shooting_status")
	self._weapon_action_component = unit_data_extension:write_component("weapon_action")
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	self._talent_extension = ScriptUnit.has_extension(self._player_unit, "talent_system")

	local player_unit = self._player_unit
	local first_person_unit = self._first_person_unit
	local physics_world = self._physics_world

	self._charge_module = ActionModules.charge:new(physics_world, player_unit, first_person_unit, self._action_module_charge_component, action_settings)

	local weapon = action_params.weapon

	self._muzzle_fx_source_name = weapon.fx_sources._muzzle
	self._muzzle_fx_source_secondary_name = weapon.fx_sources._muzzle_secondary
	self._eject_fx_spawner_name = weapon.fx_sources._eject
	self._eject_fx_spawner_secondary_name = weapon.fx_sources._eject_secondary
	self._expression_vo_triggered = false
	self._leadbelcher_shot = false

	local fx_settings = action_settings.fx

	if fx_settings then
		local looping_shoot_sfx_alias = fx_settings.looping_shoot_sfx_alias

		if looping_shoot_sfx_alias then
			local component_name = PlayerUnitData.looping_sound_component_name(looping_shoot_sfx_alias)

			self._looping_shoot_sound_component = unit_data_extension:read_component(component_name)
		end
	end

	self._shot_result = {}
end

ActionShoot.start = function (self, action_settings, t, time_scale, params)
	ActionShoot.super.start(self, action_settings, t, time_scale, params)

	local action_component = self._action_component
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local fx_extension = self._fx_extension
	local muzzle_fx_source_name = self:_muzzle_fx_source()
	local weapon_template = self._weapon_template
	local fire_rate_settings = self:_fire_rate_settings()
	local fire_time = fire_rate_settings.fire_time or 0
	local auto_fire_time = fire_rate_settings.auto_fire_time

	auto_fire_time = auto_fire_time and self:_scale_auto_fire_time_with_buffs(auto_fire_time)

	local max_shots = fire_rate_settings.max_shots

	self._is_auto_fire_weapon = (max_shots == nil or max_shots == math.huge) and not not auto_fire_time

	local combo_count = params.combo_count

	self._combo_count = combo_count

	self:_start_warp_charge_action(t)

	local talent_extension = self._talent_extension
	local check_leadbelcher = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher)
	local check_leadbelcher_improved = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher_improved)
	local has_ammo = ActionUtility.has_ammunition(self._inventory_slot_component, action_settings)

	if has_ammo and (check_leadbelcher or check_leadbelcher_improved) then
		local leadbelcher_chance = 0

		if check_leadbelcher then
			leadbelcher_chance = TalentSettings.ogryn_1.passive_1.free_ammo_proc_chance
		elseif check_leadbelcher_improved then
			leadbelcher_chance = TalentSettings.ogryn_1.spec_passive_2.increased_passive_proc_chance
		end

		self._leadbelcher_shot = self:_check_for_lucky_strike(false, true, leadbelcher_chance)
	end

	if not self._is_auto_fire_weapon then
		local leadbelcher_auto_crit = false

		if self._leadbelcher_shot then
			leadbelcher_auto_crit = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher_auto_crit)
		end

		self:_check_for_critical_strike(false, true, leadbelcher_auto_crit)
	end

	self:_set_fire_state(t, "waiting_to_shoot")

	local fx_settings = action_settings.fx

	if fx_settings then
		local pre_shoot_sfx_alias = fx_settings.pre_shoot_sfx_alias

		if pre_shoot_sfx_alias then
			_trigger_gear_sound(fx_extension, muzzle_fx_source_name, pre_shoot_sfx_alias, self._action_module_charge_component)
		end
	end

	action_component.fire_at_time = math.max(t + fire_time, action_component.fire_at_time)
	action_component.num_shots_fired = 0

	local fallback_template
	local alternate_fire_settings = self._weapon_template.alternate_fire_settings

	if self._alternate_fire_component.is_active and alternate_fire_settings then
		fallback_template = alternate_fire_settings
	else
		fallback_template = weapon_template
	end

	local inventory_slot_component = self._inventory_slot_component
	local ammunition_usage = action_settings.ammunition_usage

	if action_settings.activate_special_on_required_ammo and ammunition_usage and ammunition_usage <= inventory_slot_component.current_ammunition_clip then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true)

		self._weapon_action_component.special_active_at_start = true
	end

	local special_active = inventory_slot_component.special_active
	local special_recoil_template

	if special_active then
		special_recoil_template = action_settings.special_recoil_template or fallback_template.special_recoil_template
	end

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or fallback_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = special_recoil_template or action_settings.recoil_template or fallback_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or fallback_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"

	local reload_state_transitions = action_settings.reload_state_transitions

	if reload_state_transitions then
		local inventory_slot = self._inventory_slot_component
		local reload_state = inventory_slot.reload_state
		local transition_state = reload_state and reload_state_transitions[reload_state]

		if transition_state then
			inventory_slot_component.reload_state = transition_state
		end
	end
end

ActionShoot.fixed_update = function (self, dt, t, time_in_action)
	local action_component = self._action_component
	local action_settings = self._action_settings
	local inventory_slot_component = self._inventory_slot_component

	self._has_shot_this_frame = false

	local is_auto_fire_weapon = self._is_auto_fire_weapon
	local fire_state = action_component.fire_state
	local is_not_auto_and_has_shot = not is_auto_fire_weapon and fire_state == "shot"

	if action_settings.ammunition_usage and not is_not_auto_and_has_shot then
		local is_critical_strike = self._critical_strike_component.is_active
		local buff_extension = self._buff_extension
		local has_no_ammo_keyword = buff_extension:has_keyword(buff_keywords.no_ammo_consumption)
		local has_no_ammo_on_crit_keyword = buff_extension:has_keyword(buff_keywords.no_ammo_consumption_on_crits)
		local no_ammo_consumption = has_no_ammo_keyword or is_critical_strike and has_no_ammo_on_crit_keyword or self._leadbelcher_shot
		local has_ammo = ActionUtility.has_ammunition(inventory_slot_component, action_settings)
		local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

		if not has_ammo and not no_ammo_consumption and current_ammunition_reserve > 0 then
			return true
		end
	end

	local fire_config = action_settings.fire_configuration

	if fire_config.charge_cost then
		local charge_component = self._action_module_charge_component
		local charge_template = self._weapon_extension:charge_template()
		local charge_cost = charge_template.charge_cost or 0
		local new_charge = charge_component.charge_level - charge_cost * dt

		charge_component.charge_level = math.clamp01(new_charge)
	end

	if action_component.fire_state == "waiting_to_shoot" and t >= action_component.fire_at_time then
		self:_set_fire_state(t, "prepare_shooting")
	end

	if action_component.fire_state == "prepare_shooting" then
		local is_critical_strike = self._critical_strike_component.is_active
		local buff_extension = self._buff_extension
		local has_no_ammo_keyword = buff_extension:has_keyword(buff_keywords.no_ammo_consumption)
		local has_no_ammo_on_crit_keyword = buff_extension:has_keyword(buff_keywords.no_ammo_consumption_on_crits)
		local no_ammo_consumption = has_no_ammo_keyword or is_critical_strike and has_no_ammo_on_crit_keyword or self._leadbelcher_shot
		local has_ammo = ActionUtility.has_ammunition(self._inventory_slot_component, action_settings)

		if no_ammo_consumption or has_ammo then
			self:_set_fire_state(t, "start_shooting")
			self:_prepare_shooting(dt, t)
		else
			self:_set_fire_state(t, "shot")
		end
	end

	if action_component.fire_state == "start_shooting" or action_component.fire_state == "shooting" then
		local position = self._action_component.shooting_position
		local rotation = self._action_component.shooting_rotation
		local charge_level = self._action_component.shooting_charge_level

		if not self._unit_data_extension.is_resimulating then
			table.clear(self._shot_result)
			self:_shoot(position, rotation, DEFAULT_POWER_LEVEL, charge_level, t)
		end

		self._has_shot_this_frame = true
		action_component.fire_last_t = t

		local aim_assist_ramp_template = action_settings.aim_assist_ramp_template

		if aim_assist_ramp_template and aim_assist_ramp_template.reset_on_attack then
			AimAssist.reset_ramp_multiplier(self._aim_assist_ramp_component)
		end

		local next_fire_state = self:_next_fire_state(dt, t)

		if next_fire_state == "waiting_to_shoot" or next_fire_state == "shot" then
			self:_spend_ammunition(dt, t, charge_level)
			self:_add_heat(dt, t, charge_level)
			self:_pay_warp_charge_cost_immediate(t, charge_level)
			self:_trigger_new_charge(t)
			self:_handle_shot_concluded_stats()
		end

		self:_set_fire_state(t, next_fire_state)
	end
end

ActionShoot._next_fire_state = function (self, dt, t)
	local action_component = self._action_component
	local fire_rate_settings = self:_fire_rate_settings()
	local max_num_shots = fire_rate_settings.max_shots or math.huge
	local auto_fire_time = fire_rate_settings.auto_fire_time

	if max_num_shots <= action_component.num_shots_fired then
		return "shot"
	elseif auto_fire_time then
		auto_fire_time = self:_scale_auto_fire_time_with_buffs(auto_fire_time)
		action_component.fire_at_time = t + auto_fire_time

		return "waiting_to_shoot"
	else
		return "shot"
	end
end

ActionShoot._prepare_shooting = function (self, dt, t)
	local action_settings = self._action_settings
	local first_person_unit = self._first_person_unit
	local player_unit = self._player_unit
	local weapon_extension = self._weapon_extension
	local weapon_template = self._weapon_template
	local action_component = self._action_component
	local action_module_charge_component = self._action_module_charge_component
	local first_person_component = self._first_person_component
	local movement_state_component = self._movement_state_component
	local recoil_component = self._recoil_component
	local shooting_status_component = self._shooting_status_component
	local sway_component = self._sway_component
	local weapon_action_component = self._weapon_action_component
	local position = first_person_component.position
	local rotation = first_person_component.rotation
	local smart_targeting_template = SmartTargeting.smart_targeting_template(t, weapon_action_component)
	local fire_config = action_settings.fire_configuration
	local anim_event = fire_config.anim_event
	local anim_event_3p = fire_config.anim_event_3p or anim_event

	if fire_config.anim_event_func then
		anim_event, anim_event_3p = fire_config.anim_event_func(self._inventory_slot_component)
		anim_event_3p = anim_event_3p or anim_event
	end

	local charge_level = 1

	if fire_config.use_charge then
		charge_level = action_module_charge_component.charge_level
		action_module_charge_component.charge_level = 0
	end

	if fire_config.reset_charge then
		action_module_charge_component.charge_level = 0
	end

	action_component.shooting_charge_level = charge_level

	self:_set_charge_animation_variable(first_person_unit, charge_level)
	self:trigger_anim_event(anim_event, anim_event_3p)

	local recoil_template = weapon_extension:recoil_template()
	local sway_template = weapon_extension:sway_template()

	rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, recoil_component, movement_state_component, rotation)
	rotation = Sway.apply_sway_rotation(sway_template, sway_component, movement_state_component, rotation)

	local last_pressed_device = InputDevice.last_pressed_device
	local gamepad_active = last_pressed_device and last_pressed_device:type() == "xbox_controller"
	local enable_aim_assist = gamepad_active

	if enable_aim_assist and not DevParameters.disable_aim_assist then
		rotation = self._smart_targeting_extension:assisted_hitscan_trajectory(smart_targeting_template, weapon_template, rotation)
	end

	rotation = self._weapon_spread_extension:randomized_spread(rotation)
	action_component.shooting_position = position
	action_component.shooting_rotation = rotation

	self:_play_muzzle_flash_vfx(rotation, charge_level)
	self:_update_sound_reflection()

	local num_shots = shooting_status_component.num_shots
	local new_num_shots = num_shots + 1

	shooting_status_component.num_shots = new_num_shots

	local spread_template = weapon_extension:spread_template()

	Sway.add_immediate_sway(sway_template, self._sway_control_component, sway_component, movement_state_component, "shooting", new_num_shots, player_unit)
	Spread.add_immediate_spread_from_shooting(t, spread_template, self._spread_control_component, movement_state_component, shooting_status_component, "shooting", player_unit)
	Recoil.add_recoil(t, recoil_template, recoil_component, self._recoil_control_component, movement_state_component, first_person_component.rotation, player_unit)

	if self._is_server then
		local suppression_settings = fire_config.close_range_suppression

		if suppression_settings then
			Suppression.apply_area_minion_suppression(player_unit, suppression_settings, position)
		end
	end

	action_component.num_shots_fired = action_component.num_shots_fired + 1
end

ActionShoot._spend_ammunition = function (self, dt, t, charge_level)
	local action_settings = self._action_settings
	local inventory_slot_component = self._inventory_slot_component
	local use_charge = action_settings.use_charge
	local is_critical_strike = self._critical_strike_component.is_active
	local buff_extension = self._buff_extension
	local has_no_ammo_keyword = self._leadbelcher_shot or buff_extension:has_keyword(buff_keywords.no_ammo_consumption)
	local has_no_ammo_on_crit_keyword = buff_extension:has_keyword(buff_keywords.no_ammo_consumption_on_crits)
	local trigger_proc = has_no_ammo_keyword

	trigger_proc = trigger_proc or is_critical_strike and has_no_ammo_on_crit_keyword

	if trigger_proc then
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.t = t
			param_table.ammo_usage = 0
			param_table.charged_ammo = use_charge
			param_table.is_critical_strike = is_critical_strike
			param_table.is_leadbelcher_shot = self._leadbelcher_shot

			buff_extension:add_proc_event(proc_events.on_ammo_consumed, param_table)
		end

		return
	end

	local ammo_usage

	if use_charge then
		local min_ammo_useage = action_settings.ammunition_usage_min
		local max_ammo_useage = action_settings.ammunition_usage_max

		if min_ammo_useage and max_ammo_useage then
			local charged_ammo = math.lerp(min_ammo_useage, max_ammo_useage, charge_level)

			ammo_usage = math.round(charged_ammo)
		end
	else
		ammo_usage = self._action_settings.ammunition_usage
	end

	if not ammo_usage then
		return
	end

	local has_reduced_ammo_consumption = buff_extension:has_keyword(buff_keywords.reduced_ammo_consumption)

	if has_reduced_ammo_consumption then
		ammo_usage = math.max(math.round(ammo_usage * 1 / 3))
	end

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.t = t
		param_table.ammo_usage = ammo_usage
		param_table.charged_ammo = use_charge
		param_table.is_critical_strike = is_critical_strike

		buff_extension:add_proc_event(proc_events.on_ammo_consumed, param_table)
	end

	local inventory_slot = self._inventory_slot_component
	local new_ammunition = math.max(inventory_slot.current_ammunition_clip - ammo_usage, 0)
	local fx_settings = action_settings.fx or EMPTY_TABLE
	local out_of_ammo_sfx_alias = fx_settings.out_of_ammo_sfx_alias

	if new_ammunition == 0 and inventory_slot_component.current_ammunition_clip > 0 and out_of_ammo_sfx_alias then
		_trigger_gear_sound(self._fx_extension, self:_muzzle_fx_source(), out_of_ammo_sfx_alias, self._action_module_charge_component)
	end

	inventory_slot_component.current_ammunition_clip = new_ammunition
	inventory_slot_component.last_ammunition_usage = t

	local wielded_slot = self._inventory_component.wielded_slot
	local current_ammunition_reserve = inventory_slot_component.current_ammunition_reserve

	Managers.stats:record_private("hook_ammo_consumed", self._player, wielded_slot, ammo_usage, new_ammunition, current_ammunition_reserve)
end

ActionShoot._add_heat = function (self, dt, t, charge_level)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	local inventory_slot_component = self._inventory_slot_component
	local player_unit = self._player_unit
	local is_critical_strike = self._critical_strike_component.is_active

	Overheat.increase_immediate(t, charge_level, inventory_slot_component, charge_template, player_unit, is_critical_strike)
end

ActionShoot._trigger_new_charge = function (self, t)
	local action_settings = self._action_settings

	if action_settings.continous_charge then
		self._charge_module:reset(t)
	end
end

ActionShoot._shoot = function (self, position, rotation, power_level, charge_level, t)
	return
end

ActionShoot._set_fire_state = function (self, t, new_fire_state)
	local action_component = self._action_component
	local shooting_status_component = self._shooting_status_component
	local unit_data_extension = self._unit_data_extension
	local recoil_control_component = self._recoil_control_component
	local still_shooting = new_fire_state ~= "shot"

	action_component.fire_state = new_fire_state
	shooting_status_component.shooting = still_shooting

	Recoil.set_shooting(recoil_control_component, still_shooting)

	if not still_shooting then
		shooting_status_component.shooting_end_time = t

		self:_play_muzzle_smoke()
	end

	if not unit_data_extension.is_resimulating then
		self:_play_shoot_sound()
	end

	self:_update_looping_shoot_sound()

	if new_fire_state == "prepare_shooting" then
		self:_check_for_auto_critical_strike()
	end

	if new_fire_state == "shot" or new_fire_state == "waiting_to_shoot" then
		self:_check_for_auto_critical_strike_end(t, new_fire_state)
	end
end

ActionShoot.finish = function (self, reason, data, t, time_in_action)
	ActionShoot.super.finish(self, reason, data, t, time_in_action)

	local action_component = self._action_component

	if action_component.fire_state ~= "shot" then
		self:_set_fire_state(t, "shot")
	end

	local weapon_template = self._weapon_template

	if not weapon_template.alternate_fire_settings then
		self._weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
	end

	self._expression_vo_triggered = false

	local fire_rate_settings = self:_fire_rate_settings()
	local fire_time = fire_rate_settings.fire_time or 0
	local past_fire_time = fire_time <= time_in_action
	local action_settings = self._action_settings
	local fx_settings = action_settings.fx

	if fx_settings then
		local fx_extension = self._fx_extension
		local muzzle_fx_source_name = self:_muzzle_fx_source()
		local pre_shoot_abort_sfx_alias = fx_settings.pre_shoot_abort_sfx_alias

		if pre_shoot_abort_sfx_alias and not past_fire_time then
			_trigger_gear_sound(fx_extension, muzzle_fx_source_name, pre_shoot_abort_sfx_alias, self._action_module_charge_component)
		end
	end

	if fire_rate_settings.auto_fire_time and action_component.num_shots_fired > 0 then
		local semi_fire_factor = weapon_template.semi_auto_chain_factor or 1.5
		local auto_fire_time = fire_rate_settings.auto_fire_time

		auto_fire_time = self:_scale_auto_fire_time_with_buffs(auto_fire_time)
		action_component.fire_at_time = action_component.fire_at_time + auto_fire_time * semi_fire_factor
	end

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event(proc_events.on_shoot_finish, param_table)
	end

	self._leadbelcher_shot = false
	action_component.num_shots_fired = 0
end

ActionShoot._rewind_ms = function (self, is_local_unit, player, position, direction, max_distance)
	local is_server = self._is_server
	local rewind_ms = LagCompensation.rewind_ms(is_server, is_local_unit, self._player)

	return rewind_ms
end

ActionShoot._trigger_wwise_event = function (self, event_name, tail_event_name, source_name, append_husk_to_event_name, charge_level_parameter_name, charge_level)
	local fx_extension = self._fx_extension

	fx_extension:trigger_wwise_event_with_source(event_name, source_name, append_husk_to_event_name)

	if charge_level_parameter_name then
		fx_extension:set_source_parameter(charge_level_parameter_name, charge_level, source_name)
	end

	local alternate_fire_is_active = self._alternate_fire_component.is_active
	local muzzle_source = fx_extension:sound_source(source_name)

	WwiseWorld.set_switch(self._wwise_world, "alt_fire_active", ALT_FIRE_WWISE_SWITCH[alternate_fire_is_active], muzzle_source)

	if tail_event_name then
		fx_extension:trigger_exclusive_wwise_event(tail_event_name, Vector3(0, 0, 0), true)
	end
end

ActionShoot._play_shoot_sound = function (self)
	local action_settings = self._action_settings
	local muzzle_fx_source_name = self:_muzzle_fx_source()
	local wwise_world = self._wwise_world
	local action_component = self._action_component
	local action_module_charge_component = self._action_module_charge_component
	local alternate_fire_component = self._alternate_fire_component
	local critical_strike_component = self._critical_strike_component
	local inventory_slot_component = self._inventory_slot_component
	local looping_shoot_sound_component = self._looping_shoot_sound_component
	local fx_extension = self._fx_extension
	local visual_loadout_extension = self._visual_loadout_extension
	local fx_settings = action_settings.fx or EMPTY_TABLE
	local shoot_sfx_alias = fx_settings.shoot_sfx_alias
	local shoot_sfx_special_extra_alias = fx_settings.shoot_sfx_special_extra_alias
	local tail_alias = fx_settings.shoot_tail_sfx_alias
	local crit_shoot_sfx_alias = fx_settings.crit_shoot_sfx_alias
	local pre_loop_shoot_sfx_alias = fx_settings.pre_loop_shoot_sfx_alias
	local pre_loop_tail_alias = fx_settings.pre_loop_shoot_tail_sfx_alias
	local num_pre_loop_events = fx_settings.num_pre_loop_events or 0
	local no_ammo_shoot_sfx_alias = fx_settings.no_ammo_shoot_sfx_alias
	local charge_level_parameter_name = fx_settings.charge_level_parameter_name
	local has_ammunition = ActionUtility.has_ammunition(inventory_slot_component, action_settings)
	local fire_state = action_component.fire_state
	local num_shots_fired = action_component.num_shots_fired
	local is_looping_shoot_sound_playing = looping_shoot_sound_component and looping_shoot_sound_component.is_playing
	local automatic_fire = is_looping_shoot_sound_playing and (fire_state == "waiting_to_shoot" or fire_state == "prepare_shooting")
	local shooting = fire_state == "start_shooting" or automatic_fire
	local trigger_single_shot_sound = shooting and has_ammunition and not automatic_fire
	local trigger_no_ammo_sound = not shooting and no_ammo_shoot_sfx_alias and not has_ammunition

	if trigger_single_shot_sound then
		if looping_shoot_sound_component and num_shots_fired < num_pre_loop_events then
			if pre_loop_shoot_sfx_alias then
				_trigger_gear_sound(fx_extension, muzzle_fx_source_name, pre_loop_shoot_sfx_alias, action_module_charge_component)
				_trigger_gear_tail_sound(fx_extension, muzzle_fx_source_name, pre_loop_tail_alias)
				_set_charge_level(fx_extension, muzzle_fx_source_name, charge_level_parameter_name, action_module_charge_component)
				_update_alt_fire_state(wwise_world, fx_extension, alternate_fire_component, muzzle_fx_source_name)
			end
		elseif shoot_sfx_alias then
			_trigger_gear_sound(fx_extension, muzzle_fx_source_name, shoot_sfx_alias, action_module_charge_component)
			_trigger_gear_tail_sound(fx_extension, muzzle_fx_source_name, tail_alias)
			_set_charge_level(fx_extension, muzzle_fx_source_name, charge_level_parameter_name, action_module_charge_component)
			_update_alt_fire_state(wwise_world, fx_extension, alternate_fire_component, muzzle_fx_source_name)

			local has_special_shot = self._inventory_slot_component.special_active

			if shoot_sfx_special_extra_alias and has_special_shot then
				local shoot_sfx_special_extra_with_offset = fx_settings.shoot_sfx_special_extra_with_offset

				if shoot_sfx_special_extra_with_offset then
					local spawner_pose = fx_extension:vfx_spawner_pose(muzzle_fx_source_name)
					local from_pos = Matrix4x4.translation(spawner_pose)
					local aim_rotation = self._first_person_component.rotation
					local aim_direction = Quaternion.forward(aim_rotation)
					local distance = 3

					table.clear(EXTERNAL_PROPERTIES)

					local charge_level = action_module_charge_component.charge_level

					EXTERNAL_PROPERTIES.charge_level = charge_level >= 1 and "fully_charged"

					local sync_to_clients = true

					fx_extension:trigger_gear_wwise_event_with_position(shoot_sfx_special_extra_alias, EXTERNAL_PROPERTIES, from_pos + aim_direction * distance, sync_to_clients)
				else
					_trigger_gear_sound(fx_extension, muzzle_fx_source_name, shoot_sfx_special_extra_alias, action_module_charge_component)
				end
			end
		end
	elseif trigger_no_ammo_sound then
		_trigger_gear_sound(fx_extension, muzzle_fx_source_name, no_ammo_shoot_sfx_alias, action_module_charge_component)
		Vo.out_of_ammo_event(inventory_slot_component, visual_loadout_extension)
	end

	_trigger_critical_sound(fx_extension, crit_shoot_sfx_alias, critical_strike_component, fire_state)
end

ActionShoot._update_looping_shoot_sound = function (self)
	local looping_shoot_sound_component = self._looping_shoot_sound_component

	if not looping_shoot_sound_component then
		return
	end

	local action_component = self._action_component
	local inventory_slot_component = self._inventory_slot_component
	local fx_extension = self._fx_extension
	local action_settings = self._action_settings
	local muzzle_fx_source_name = self:_muzzle_fx_source()
	local fx_settings = action_settings.fx or EMPTY_TABLE
	local looping_shoot_sfx_alias = fx_settings.looping_shoot_sfx_alias
	local post_loop_tail_alias = fx_settings.post_loop_shoot_tail_sfx_alias
	local num_pre_loop_events = fx_settings.num_pre_loop_events or 0
	local has_ammo = ActionUtility.has_ammunition(inventory_slot_component, action_settings)
	local fire_state = action_component.fire_state
	local is_looping_shoot_sfx_playing = looping_shoot_sound_component.is_playing
	local automatic_fire = is_looping_shoot_sfx_playing and (fire_state == "waiting_to_shoot" or fire_state == "prepare_shooting")
	local shooting = fire_state == "start_shooting" or automatic_fire
	local num_shots_fired = action_component.num_shots_fired
	local started_shooting = shooting and has_ammo and not is_looping_shoot_sfx_playing and num_pre_loop_events <= num_shots_fired
	local stopped_shooting = not shooting and is_looping_shoot_sfx_playing

	if started_shooting then
		local fire_rate_settings = self:_fire_rate_settings()
		local auto_fire_time = fire_rate_settings.auto_fire_time
		local parameter_name = fx_settings.auto_fire_time_parameter_name

		if auto_fire_time and parameter_name then
			auto_fire_time = self:_scale_auto_fire_time_with_buffs(auto_fire_time)

			fx_extension:set_source_parameter(parameter_name, auto_fire_time, muzzle_fx_source_name)
		end

		fx_extension:trigger_looping_wwise_event(looping_shoot_sfx_alias, muzzle_fx_source_name)
	elseif stopped_shooting then
		fx_extension:stop_looping_wwise_event(looping_shoot_sfx_alias)
		_trigger_gear_tail_sound(fx_extension, muzzle_fx_source_name, post_loop_tail_alias)
	end
end

ActionShoot._play_muzzle_flash_vfx = function (self, shoot_rotation, charge_level)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local fx = self._action_settings.fx

	if not fx then
		return
	end

	local is_critical_strike = self._critical_strike_component.is_active
	local effect_name = fx.muzzle_flash_effect
	local effect_name_secondary = fx.muzzle_flash_effect_secondary
	local crit_effect_name = fx.muzzle_flash_crit_effect
	local weapon_special_effect_name = fx.weapon_special_muzzle_flash_effect
	local weapon_special_crit_effect_name = fx.weapon_special_muzzle_flash_crit_effect
	local inventory_slot_component = self._inventory_slot_component
	local special_active = inventory_slot_component.special_active
	local effect_to_play

	if special_active then
		effect_to_play = is_critical_strike and weapon_special_crit_effect_name or weapon_special_effect_name
	end

	effect_to_play = effect_to_play or is_critical_strike and crit_effect_name or effect_name
	effect_to_play = effect_to_play or effect_name

	local is_charge_dependant = effect_to_play and type(effect_to_play) == "table"

	if is_charge_dependant then
		local effect_to_play_table = effect_to_play

		effect_to_play = nil

		for i = 1, #effect_to_play_table do
			local entry = effect_to_play_table[i]
			local required_charge = entry.charge_level
			local effect = entry.effect

			if required_charge <= charge_level then
				effect_to_play = effect
			end
		end
	end

	if not effect_to_play then
		return
	end

	local fx_extension = self._fx_extension
	local muzzle_spawner_name = self:_muzzle_fx_source()
	local secondary_muzzle_spawner_name = self._muzzle_fx_source_secondary_name
	local eject_spawner_name = self:_eject_fx_source()
	local link = true
	local orphaned_policy = "stop"
	local position_offset, rotation_offset
	local spread_rotated_muzzle_flash = fx.spread_rotated_muzzle_flash

	if spread_rotated_muzzle_flash then
		local spawner_pose = fx_extension:vfx_spawner_pose(muzzle_spawner_name)
		local spawner_position = Matrix4x4.translation(spawner_pose)
		local shoot_pose = Matrix4x4.from_quaternion_position(shoot_rotation, spawner_position)
		local delta_pose = Matrix4x4.multiply(shoot_pose, Matrix4x4.inverse(spawner_pose))

		position_offset = Matrix4x4.translation(delta_pose)
		rotation_offset = Matrix4x4.rotation(delta_pose)
	end

	local particle_id = fx_extension:spawn_unit_particles(effect_to_play, muzzle_spawner_name, link, orphaned_policy, position_offset, rotation_offset)

	if secondary_muzzle_spawner_name and effect_name_secondary then
		fx_extension:spawn_unit_particles(effect_name_secondary, secondary_muzzle_spawner_name, link, orphaned_policy, position_offset, rotation_offset)
	end

	local muzzle_flash_size_variable_name = fx.muzzle_flash_size_variable_name
	local muzzle_flash_size = fx.muzzle_flash_variable_size

	if muzzle_flash_size_variable_name then
		local charge_level = self._action_module_charge_component.charge_level
		local min, max = muzzle_flash_size.min, muzzle_flash_size.max
		local variable_value = (max - min) * charge_level + min
		local variable_index = World.find_particles_variable(self._world, effect_name, muzzle_flash_size_variable_name)

		World.set_particles_variable(self._world, particle_id, variable_index, Vector3(variable_value, variable_value, variable_value))
	end

	local shell_casing_effect = fx.shell_casing_effect

	if shell_casing_effect then
		fx_extension:spawn_unit_particles(shell_casing_effect, eject_spawner_name, link, orphaned_policy, position_offset, rotation_offset)
	end
end

ActionShoot._play_muzzle_smoke = function (self)
	local fx = self._action_settings.fx

	if not fx then
		return
	end

	local effect_name = fx.muzzle_smoke_effect

	if not effect_name then
		return
	end

	local num_shots_for_muzzle_smoke = fx.num_shots_for_muzzle_smoke
	local num_shots_fired = self._action_component.num_shots_fired

	if num_shots_for_muzzle_smoke and num_shots_fired < num_shots_for_muzzle_smoke then
		return
	end

	local fx_extension = self._fx_extension
	local spawner_name = self:_muzzle_fx_source()
	local link = true
	local orphaned_policy = "stop"
	local position_offset, rotation_offset

	fx_extension:spawn_unit_particles(effect_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset)
end

ActionShoot._check_for_auto_critical_strike = function (self)
	local auto_fire = self._is_auto_fire_weapon

	if not auto_fire then
		return
	end

	local talent_extension = self._talent_extension
	local check_leadbelcher = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher)
	local check_leadbelcher_improved = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher_improved)

	if check_leadbelcher or check_leadbelcher_improved then
		local leadbelcher_chance = 0

		if check_leadbelcher then
			leadbelcher_chance = TalentSettings.ogryn_1.passive_1.free_ammo_proc_chance
		elseif check_leadbelcher_improved then
			leadbelcher_chance = TalentSettings.ogryn_1.spec_passive_2.increased_passive_proc_chance
		end

		self._leadbelcher_shot = self:_check_for_lucky_strike(false, true, leadbelcher_chance)
	end

	local critical_strike_component = self._critical_strike_component
	local is_critical_strike = critical_strike_component.is_active
	local num_critical_shots = critical_strike_component.num_critical_shots
	local weapon_handling_template = self._weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local critical_strike = weapon_handling_template.critical_strike or EMPTY_TABLE
	local max_critical_shots = critical_strike.max_critical_shots or DEFUALT_NUM_CRITICAL_SHOTS
	local auto_crits_left = num_critical_shots < max_critical_shots

	if auto_fire and is_critical_strike and auto_crits_left then
		critical_strike_component.num_critical_shots = num_critical_shots + 1
	end

	local check_crit = not is_critical_strike and auto_crits_left

	if not check_crit then
		return
	end

	local leadbelcher_auto_crit = false

	if self._leadbelcher_shot then
		leadbelcher_auto_crit = talent_extension:has_special_rule(special_rules.ogryn_leadbelcher_auto_crit)
	end

	self:_check_for_critical_strike(false, true, leadbelcher_auto_crit)

	if critical_strike_component.is_active then
		critical_strike_component.num_critical_shots = num_critical_shots + 1
	end
end

ActionShoot._check_for_auto_critical_strike_end = function (self, t)
	local auto_fire = self._is_auto_fire_weapon

	if not auto_fire then
		return
	end

	local critical_strike_component = self._critical_strike_component
	local weapon_handling_template = self._weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local critical_strike = weapon_handling_template.critical_strike or EMPTY_TABLE
	local num_critical_shots = critical_strike_component.num_critical_shots
	local max_critical_shots = critical_strike.max_critical_shots or 1
	local auto_crits_left = num_critical_shots < max_critical_shots

	if not auto_crits_left then
		critical_strike_component.is_active = false
		critical_strike_component.num_critical_shots = 0
	end
end

ActionShoot._update_sound_reflection = function (self)
	local is_husk = self._fx_extension:should_play_husk_effect()

	if is_husk then
		return
	end

	local do_sound_reflection = true
	local action_settings = self._action_settings
	local first_shot_only_sound_reflection = action_settings.first_shot_only_sound_reflection

	if first_shot_only_sound_reflection and self._action_component.num_shots_fired > 0 then
		do_sound_reflection = false
	end

	if do_sound_reflection then
		Component.event(self._player_unit, "update_sound_reflection")
	end
end

ActionShoot._set_charge_animation_variable = function (self, first_person_unit, charge_level)
	local charge_variable = Unit.animation_find_variable(first_person_unit, "charge_shoot")

	if charge_variable then
		Unit.animation_set_variable(first_person_unit, charge_variable, charge_level)
	end
end

ActionShoot.trigger_anim_event = function (self, anim_event, anim_event_3p)
	if anim_event and not self._unit_data_extension.is_resimulating then
		ActionShoot.super.trigger_anim_event(self, anim_event, anim_event_3p)
	end
end

ActionShoot._play_line_fx = function (self, line_effect, position, end_position)
	if not line_effect then
		return
	end

	local out_of_bounds_manager = Managers.state.out_of_bounds

	end_position = out_of_bounds_manager:limit_line_end_position_to_soft_cap_extents(position, end_position)

	local is_critical_strike = self._critical_strike_component.is_active
	local source_name = self:_muzzle_fx_source()
	local link = true

	if line_effect.link ~= nil then
		link = line_effect.link
	end

	local orphaned_policy = "stop"
	local scale
	local append_husk_to_event_name = true

	self._fx_extension:spawn_unit_fx_line(line_effect, is_critical_strike, source_name, end_position, link, orphaned_policy, scale, append_husk_to_event_name)
end

ActionShoot._muzzle_fx_source = function (self)
	local action_settings = self._action_settings
	local fx = action_settings.fx
	local alternate_muzzle_flashes = fx.alternate_muzzle_flashes
	local double_barrel_shotgun_muzzle_flashes = fx.double_barrel_shotgun_muzzle_flashes

	if alternate_muzzle_flashes then
		local action_component = self._action_component
		local num_shots_fired = action_component.num_shots_fired
		local use_primary_node = num_shots_fired % 2 == 0

		return use_primary_node and self._muzzle_fx_source_name or self._muzzle_fx_source_secondary_name
	end

	if double_barrel_shotgun_muzzle_flashes then
		local inventory_slot_component = self._inventory_slot_component
		local current_ammunition_clip = inventory_slot_component.current_ammunition_clip
		local use_primary_node = current_ammunition_clip % 2 == 0

		return use_primary_node and self._muzzle_fx_source_name or self._muzzle_fx_source_secondary_name
	end

	return self._muzzle_fx_source_name
end

ActionShoot._eject_fx_source = function (self)
	local action_settings = self._action_settings
	local fx = action_settings.fx

	if not fx or not fx.alternate_shell_casings then
		return self._eject_fx_spawner_name
	end

	local action_component = self._action_component
	local num_shots_fired = action_component.num_shots_fired
	local use_primary_node = num_shots_fired % 2 == 0

	return use_primary_node and self._eject_fx_spawner_name or self._eject_fx_spawner_secondary_name
end

ActionShoot._handle_shot_concluded_stats = function (self)
	local shot_result = self._shot_result
	local data_valid = shot_result.data_valid

	if data_valid then
		local hit_minion = shot_result.hit_minion
		local hit_weakspot = shot_result.hit_weakspot
		local killing_blow = shot_result.killing_blow
		local inventory_slot_component = self._inventory_slot_component
		local last_round_in_mag = inventory_slot_component.current_ammunition_clip == 0

		Managers.stats:record_private("hook_ranged_attack_concluded", self._player, hit_minion, hit_weakspot, killing_blow, last_round_in_mag)
	end
end

ActionShoot._fire_rate_settings = function (self)
	local weapon_handling_template = self._weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local fire_rate = weapon_handling_template.fire_rate or EMPTY_TABLE

	return fire_rate
end

ActionShoot._scale_auto_fire_time_with_buffs = function (self, auto_fire_time)
	local stat_buffs = self._buff_extension:stat_buffs()
	local attack_speed_factor = 1
	local ranged_attack_speed = stat_buffs and stat_buffs.ranged_attack_speed or 1
	local attack_speed = stat_buffs and stat_buffs.attack_speed or 1

	attack_speed_factor = attack_speed_factor + ranged_attack_speed + attack_speed - 2

	local scaled_auto_fire_time = auto_fire_time * 1 / attack_speed_factor

	return scaled_auto_fire_time
end

function _set_charge_level(fx_extension, fx_source_name, parameter_name, action_module_charge_component)
	if parameter_name then
		local charge_level = action_module_charge_component.charge_level * 100

		fx_extension:set_source_parameter(parameter_name, charge_level, fx_source_name)
	end
end

function _trigger_gear_sound(fx_extension, fx_source_name, sound_alias, action_module_charge_component)
	table.clear(EXTERNAL_PROPERTIES)

	local charge_level = action_module_charge_component.charge_level

	EXTERNAL_PROPERTIES.charge_level = charge_level >= 1 and "fully_charged"

	fx_extension:trigger_gear_wwise_event_with_source(sound_alias, EXTERNAL_PROPERTIES, fx_source_name, SYNC_TO_CLIENTS)
end

function _trigger_gear_tail_sound(fx_extension, fx_source_name, sound_alias)
	_trigger_exclusive_gear_sound(fx_extension, sound_alias, TAIL_SOURCE_POS:unbox(), DONT_SYNC_TO_SENDER)
end

function _trigger_exclusive_gear_sound(fx_extension, sound_alias, ...)
	if sound_alias then
		table.clear(EXTERNAL_PROPERTIES)
		fx_extension:trigger_exclusive_gear_wwise_event(sound_alias, EXTERNAL_PROPERTIES, ...)
	end
end

function _trigger_critical_sound(fx_extension, crit_shoot_sfx_alias, critical_strike_component, fire_state)
	local is_critical_strike = critical_strike_component.is_active
	local play_crit_sound = is_critical_strike and fire_state == "start_shooting"

	if not play_crit_sound then
		return
	end

	_trigger_exclusive_gear_sound(fx_extension, crit_shoot_sfx_alias)
end

function _update_alt_fire_state(wwise_world, fx_extension, alternate_fire_component, fx_source_name)
	local alternate_fire_is_active = alternate_fire_component.is_active
	local fx_source = fx_extension:sound_source(fx_source_name)

	WwiseWorld.set_switch(wwise_world, "alt_fire_active", ALT_FIRE_WWISE_SWITCH[alternate_fire_is_active], fx_source)
end

return ActionShoot
