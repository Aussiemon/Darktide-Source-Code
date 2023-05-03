require("scripts/extension_systems/weapon/actions/action_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local CriticalStrike = require("scripts/utilities/attack/critical_strike")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WarpCharge = require("scripts/utilities/warp_charge")
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
	local weapon = action_params.weapon
	self._weapon = weapon
	self._weapon_unit = weapon.weapon_unit
	self._weapon_template = weapon.weapon_template
	self._inventory_slot_component = weapon.inventory_slot_component
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

	if action_settings.unaim and self._alternate_fire_component.is_active then
		local skip_unaim_anim = action_settings.skip_unaim_anim

		AlternateFire.stop(self._alternate_fire_component, self._weapon_tweak_templates_component, self._animation_extension, self._weapon_template, skip_unaim_anim, self._player_unit)
	end

	local use_ability_charge = action_settings.use_ability_charge

	if use_ability_charge then
		self:_use_ability_charge()
	end

	if action_settings.delay_explosion_to_finish then
		self._prevent_explosion = true
	end
end

ActionWeaponBase._use_ability_charge = function (self)
	local action_settings = self._action_settings
	local ability_type = action_settings.ability_type
	local ability_extension = self._ability_extension

	ability_extension:use_ability_charge(ability_type)
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

		WarpCharge.check_and_set_state(t, warp_charge_component)
	end
end

ActionWeaponBase._check_for_critical_strike = function (self, is_melee, is_ranged)
	local critical_strike_component = self._critical_strike_component
	local player = self._player
	local weapon_extension = self._weapon_extension
	local buff_extension = self._buff_extension
	local weapon_handling_template = weapon_extension:weapon_handling_template() or EMPTY_TABLE
	local seed = critical_strike_component.seed
	local prd_state = critical_strike_component.prd_state
	local guaranteed_crit = buff_extension:has_keyword("guaranteed_critical_strike") or is_ranged and buff_extension:has_keyword("guaranteed_ranged_critical_strike") or is_melee and buff_extension:has_keyword("guaranteed_melee_critical_strike")
	local chance = nil

	if guaranteed_crit then
		chance = 1
	else
		chance = CriticalStrike.chance(player, weapon_handling_template, is_ranged, is_melee)
	end

	local is_critical_strike, new_prd_state, new_seed = CriticalStrike.is_critical_strike(chance, prd_state, seed)

	if is_critical_strike then
		local param_table = self._buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.attacker_unit = self._player_unit

			self._buff_extension:add_proc_event(proc_events.on_critical_strike, param_table)
		end
	end

	self._critical_strike_component.prd_state = new_prd_state
	self._critical_strike_component.seed = new_seed
	self._critical_strike_component.is_active = is_critical_strike
end

ActionWeaponBase._increase_action_duration = function (self, additional_time)
	local weapon_action_component = self._weapon_action_component

	if weapon_action_component.is_infinite_duration then
		return
	end

	local new_end_t = weapon_action_component.end_t + additional_time
	weapon_action_component.end_t = new_end_t
end

ActionWeaponBase._add_weapon_blood = function (self, amount)
	local wielded_slot = self._inventory_component.wielded_slot

	Managers.state.blood:add_weapon_blood(self._player, wielded_slot, amount)
end

ActionWeaponBase._set_weapon_special = function (self, active, t)
	local last_start_time = self._inventory_slot_component.special_active_start_t
	self._inventory_slot_component.special_active = active

	if active then
		self._inventory_slot_component.special_active_start_t = t
		local proc_cooldown_time = 0.5

		if t > last_start_time + proc_cooldown_time then
			local param_table = self._buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.t = t

				self._buff_extension:add_proc_event(proc_events.on_weapon_special, param_table)
			end
		end
	end
end

ActionWeaponBase._setup_charge_template = function (self, action_settings)
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
end

ActionWeaponBase._start_warp_charge_action = function (self, t)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	local warp_charge_component = self._warp_charge_component

	WarpCharge.start_warp_action(t, warp_charge_component)
end

ActionWeaponBase._pay_warp_charge_cost = function (self, t, charge_level, ignore_clients)
	local charge_template = self._weapon_extension:charge_template()

	if not charge_template then
		return
	end

	if ignore_clients and not self._is_server then
		return
	end

	local warp_charge_component = self._warp_charge_component
	local player_unit = self._player_unit
	local action_settings = self._action_settings
	local prevent_explosion = self._prevent_explosion

	WarpCharge.increase_immediate(t, charge_level, warp_charge_component, charge_template, player_unit, nil, prevent_explosion)
end

return ActionWeaponBase
