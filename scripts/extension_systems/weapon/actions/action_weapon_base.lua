-- chunkname: @scripts/extension_systems/weapon/actions/action_weapon_base.lua

require("scripts/extension_systems/weapon/actions/action_base")

local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CriticalStrike = require("scripts/utilities/attack/critical_strike")
local WarpCharge = require("scripts/utilities/warp_charge")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local EMPTY_TABLE = {}
local ActionWeaponBase = class("ActionWeaponBase", "ActionBase")

ActionWeaponBase.init = function (self, action_context, action_params, action_settings)
	ActionWeaponBase.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_extension = action_context.weapon_extension
	self._weapon_recoil_extension = action_context.weapon_recoil_extension
	self._weapon_spread_extension = action_context.weapon_spread_extension

	local weapon_action_component = action_context.weapon_action_component

	self._weapon_action_component = weapon_action_component
	self._critical_strike_component = action_context.critical_strike_component
	self._weapon_lock_view_component = action_context.weapon_lock_view_component
	self._aim_assist_ramp_component = unit_data_extension:write_component("aim_assist_ramp")
	self._weapon_tweak_templates_component = unit_data_extension:write_component("weapon_tweak_templates")
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
	self._peeking_component = unit_data_extension:write_component("peeking")

	local weapon = action_params.weapon

	self._weapon = weapon
	self._weapon_unit = weapon.weapon_unit
	self._weapon_template = weapon.weapon_template
	self._inventory_slot_component = weapon.inventory_slot_component

	local ability_type = self._action_settings.ability_type

	if ability_type then
		self._ability_type = ability_type
		self._ability_pause_cooldown_setting = self._ability_extension:ability_pause_cooldown_settings(ability_type)
	end
end

ActionWeaponBase.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionWeaponBase.super.start(self, action_settings, t, time_scale, action_start_params)

	local weapon_lock_view_component = self._weapon_lock_view_component

	if weapon_lock_view_component and action_settings.lock_view then
		weapon_lock_view_component.state = "weapon_lock"

		local yaw, pitch, _ = self._input_extension:get_orientation()

		weapon_lock_view_component.yaw = yaw
		weapon_lock_view_component.pitch = pitch
	end

	if not action_settings.keep_critical_strike then
		self._critical_strike_component.is_active = false
	end

	local aim_assist_ramp_template = action_settings.aim_assist_ramp_template

	AimAssist.increase_ramp_multiplier(t, self._aim_assist_ramp_component, aim_assist_ramp_template)
	self:_setup_charge_template(action_settings)

	if action_settings.stop_alternate_fire and self._alternate_fire_component.is_active then
		local from_action_input = true

		AlternateFire.stop(self._alternate_fire_component, self._peeking_component, self._first_person_extension, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, self._player_unit, from_action_input)
	end

	local use_ability_charge = action_settings.use_ability_charge
	local use_charge_at_start = action_settings.use_charge_at_start

	if use_ability_charge and use_charge_at_start then
		self:_use_ability_charge()
	end

	if action_settings.delay_explosion_to_finish then
		self._prevent_explosion = true
	end

	self:_set_haptic_trigger_template(self._action_settings, self._weapon_template)

	if self._ability_pause_cooldown_setting then
		self._ability_extension:pause_cooldown(self._ability_type)
	end
end

ActionWeaponBase.finish = function (self, reason, data, t, time_in_action)
	ActionWeaponBase.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings

	if action_settings then
		local weapon_lock_view_component = self._weapon_lock_view_component

		if weapon_lock_view_component and action_settings.lock_view then
			weapon_lock_view_component.state = "in_active"
		end
	end

	if not action_settings.keep_critical_strike then
		local critical_strike_component = self._critical_strike_component

		critical_strike_component.is_active = false
		critical_strike_component.num_critical_shots = 0
	end

	if action_settings.delay_explosion_to_finish then
		local warp_charge_component = self._warp_charge_component
		local buff_extension = self._buff_extension

		WarpCharge.check_and_set_state(t, warp_charge_component, buff_extension)
	end

	self:_set_haptic_trigger_template(nil, self._weapon_template)
end

ActionWeaponBase._set_haptic_trigger_template = function (self, action_settings, weapon_template)
	if not IS_PLAYSTATION then
		return
	end

	if self._is_local_unit and self._is_human_controlled then
		local inventory_component = self._inventory_component
		local wielded_slot = inventory_component.wielded_slot
		local condition_func_params = wielded_slot ~= "none" and self._weapon_extension:condition_func_params(wielded_slot)

		Managers.input.haptic_trigger_effects:set_haptic_trigger_template(action_settings, weapon_template, condition_func_params)
	end
end

ActionWeaponBase.server_correction_occurred = function (self)
	ActionWeaponBase.super.server_correction_occurred(self)
	self:_set_haptic_trigger_template(self._action_settings, self._weapon_template)
end

ActionWeaponBase._check_for_critical_strike = function (self, is_melee, is_ranged, action_auto_crit, should_crit)
	local wielded_slot = self._inventory_component.wielded_slot

	if not should_crit and (wielded_slot == "slot_combat_ability" or wielded_slot == "slot_grenade_ability") then
		return
	end

	local critical_strike_component = self._critical_strike_component
	local player = self._player
	local weapon_extension = self._weapon_extension
	local buff_extension = self._buff_extension
	local weapon_handling_template = weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local seed = critical_strike_component.seed
	local prd_state = critical_strike_component.prd_state
	local prevent_crit = buff_extension:has_keyword("prevent_critical_strike")
	local guaranteed_crit = buff_extension:has_keyword("guaranteed_critical_strike") or is_ranged and buff_extension:has_keyword("guaranteed_ranged_critical_strike") or is_melee and buff_extension:has_keyword("guaranteed_melee_critical_strike") or action_auto_crit
	local chance

	chance = prevent_crit and 0 or guaranteed_crit and 1 or CriticalStrike.chance(player, weapon_handling_template, is_ranged, is_melee, false)

	local is_critical_strike, new_prd_state, new_seed = CriticalStrike.is_critical_strike(chance, prd_state, seed)

	if is_critical_strike then
		local param_table = self._buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.attack_type = is_melee and attack_types.melee or is_ranged and attack_types.ranged
			param_table.attacker_unit = self._player_unit

			self._buff_extension:add_proc_event(proc_events.on_critical_strike, param_table)
		end
	end

	self._critical_strike_component.prd_state = new_prd_state
	self._critical_strike_component.seed = new_seed
	self._critical_strike_component.is_active = is_critical_strike
end

ActionWeaponBase._check_for_lucky_strike = function (self, is_melee, is_ranged, chance)
	local wielded_slot = self._inventory_component.wielded_slot

	if wielded_slot == "slot_combat_ability" or wielded_slot == "slot_grenade_ability" then
		return
	end

	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local leadbelcher_chance_bonus = stat_buffs.leadbelcher_chance_bonus

	chance = chance + leadbelcher_chance_bonus

	if buff_extension:has_keyword("guaranteed_leadbelcher") then
		chance = 1
	end

	local critical_strike_component = self._critical_strike_component
	local seed = critical_strike_component.seed
	local prd_state = critical_strike_component.prd_state
	local is_lucky_strike, new_prd_state, new_seed = CriticalStrike.is_critical_strike(chance, prd_state, seed)

	self._critical_strike_component.seed = new_seed

	if is_lucky_strike then
		self._critical_strike_component.prd_state = new_prd_state
	end

	return is_lucky_strike
end

ActionWeaponBase._increase_action_duration = function (self, additional_time)
	local weapon_action_component = self._weapon_action_component

	if weapon_action_component.is_infinite_duration then
		return
	end

	local new_end_t = weapon_action_component.end_t + additional_time

	weapon_action_component.end_t = new_end_t
end

ActionWeaponBase._add_weapon_blood = function (self, target_unit, amount)
	local breed_or_nil = Breed.unit_breed_or_nil(target_unit)

	if not breed_or_nil then
		return
	end

	if not Breed.is_character(breed_or_nil) and not Breed.is_living_prop(breed_or_nil) then
		return
	end

	local wielded_slot = self._inventory_component.wielded_slot

	Managers.state.blood:add_weapon_blood(self._player, wielded_slot, amount)
end

ActionWeaponBase._reference_attachment_id = function (self, fire_config)
	local attachment_id_or_nil

	if fire_config.reference_attachment_id_func then
		attachment_id_or_nil = fire_config.reference_attachment_id_func(self._inventory_component, self._weapon_extension)
	else
		attachment_id_or_nil = fire_config.reference_attachment_id
	end

	return attachment_id_or_nil
end

ActionWeaponBase._setup_charge_template = function (self, action_settings)
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	local charge_template = action_settings.charge_template or weapon_template.charge_template or weapon_template.special_charge_template or "none"

	weapon_tweak_templates_component.charge_template_name = charge_template
end

ActionWeaponBase._start_warp_charge_action = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	local warp_charge_component = self._warp_charge_component

	WarpCharge.start_warp_action(t, warp_charge_component)
end

ActionWeaponBase._pay_warp_charge_cost_immediate = function (self, t, charge_level, ignore_clients)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	if ignore_clients and not self._is_server then
		return
	end

	local warp_charge_component = self._warp_charge_component
	local player_unit = self._player_unit
	local prevent_explosion = self._prevent_explosion

	WarpCharge.increase_immediate(t, charge_level, warp_charge_component, charge_template, player_unit, nil, prevent_explosion)
end

ActionWeaponBase._pay_warp_charge_cost_over_time = function (self, dt, t, charge_level, ignore_clients, first_charge)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	if ignore_clients and not self._is_server then
		return
	end

	local warp_charge_component = self._warp_charge_component
	local player_unit = self._player_unit

	WarpCharge.increase_over_time(dt, t, charge_level, warp_charge_component, charge_template, player_unit, first_charge)
end

return ActionWeaponBase
