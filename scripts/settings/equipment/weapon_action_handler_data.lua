local BuffSettings = require("scripts/settings/buff/buff_settings")
local MasterItems = require("scripts/backend/master_items")
local Overheat = require("scripts/utilities/overheat")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Scanning = require("scripts/utilities/scanning")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Vo = require("scripts/utilities/vo")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")

local function _require_weapon_action(action)
	local base = "scripts/extension_systems/weapon/actions/"
	local action_file_name = base .. action
	local class = require(action_file_name)

	return class
end

local weapon_action_data = {
	actions = {
		activate_special = _require_weapon_action("action_activate_special"),
		aim = _require_weapon_action("action_aim"),
		aim_force_field = _require_weapon_action("action_aim_force_field"),
		aim_projectile = _require_weapon_action("action_aim_projectile"),
		block = _require_weapon_action("action_block"),
		buff_target = _require_weapon_action("action_buff_target"),
		charge = _require_weapon_action("action_charge"),
		charge_ammo = _require_weapon_action("action_charge_ammo"),
		chain_lightning = _require_weapon_action("action_chain_lightning"),
		damage_target = _require_weapon_action("action_damage_target"),
		discard = _require_weapon_action("action_discard"),
		dummy = _require_weapon_action("action_dummy"),
		flamer_gas = _require_weapon_action("action_flamer_gas"),
		flamer_gas_burst = _require_weapon_action("action_flamer_gas_burst"),
		give_pocketable = _require_weapon_action("action_give_pocketable"),
		heal_target_over_time = _require_weapon_action("action_heal_target_over_time"),
		inspect = _require_weapon_action("action_inspect"),
		melee_explosive = _require_weapon_action("action_melee_explosive"),
		overload_charge = _require_weapon_action("action_overload_charge"),
		overload_charge_position_finder = _require_weapon_action("action_overload_charge_position_finder"),
		overload_charge_target_finder = _require_weapon_action("action_overload_charge_target_finder"),
		overload_explosion = _require_weapon_action("action_overload_explosion"),
		overload_target_finder = _require_weapon_action("action_overload_target_finder"),
		place_deployable = _require_weapon_action("action_place_deployable"),
		place_pickup = _require_weapon_action("action_place_pickup"),
		place_force_field = _require_weapon_action("action_place_force_field"),
		push = _require_weapon_action("action_push"),
		ranged_load_special = _require_weapon_action("action_ranged_load_special"),
		ranged_wield = _require_weapon_action("action_ranged_wield"),
		reload_shotgun = _require_weapon_action("action_reload_shotgun"),
		reload_state = _require_weapon_action("action_reload_state"),
		shoot_hit_scan = _require_weapon_action("action_shoot_hit_scan"),
		shoot_pellets = _require_weapon_action("action_shoot_pellets"),
		shoot_projectile = _require_weapon_action("action_shoot_projectile"),
		smite_targeting = _require_weapon_action("action_smite_targeting"),
		spawn_projectile = _require_weapon_action("action_spawn_projectile"),
		sweep = _require_weapon_action("action_sweep"),
		scan = _require_weapon_action("action_scan"),
		scan_confirm = _require_weapon_action("action_scan_confirm"),
		target_ally = _require_weapon_action("action_target_ally"),
		target_finder = _require_weapon_action("action_target_finder"),
		throw_grenade = _require_weapon_action("action_throw_grenade"),
		throw_luggable = _require_weapon_action("action_throw_luggable"),
		toggle_special = _require_weapon_action("action_toggle_weapon_special"),
		trigger_explosion = _require_weapon_action("action_trigger_explosion"),
		unaim = _require_weapon_action("action_unaim"),
		unwield = _require_weapon_action("action_unwield"),
		unwield_to_previous = _require_weapon_action("action_unwield_to_previous"),
		unwield_to_specific = _require_weapon_action("action_unwield_to_specific"),
		use_syringe = _require_weapon_action("action_use_syringe"),
		vent_overheat = _require_weapon_action("action_vent_overheat"),
		vent_warp_charge = _require_weapon_action("action_vent_warp_charge"),
		wield = _require_weapon_action("action_wield"),
		windup = _require_weapon_action("action_windup"),
		zealot_channel = _require_weapon_action("action_zealot_channel")
	}
}

local function _ammo_check(action_settings, condition_func_params)
	local inventory_slot_component = condition_func_params.inventory_slot_component
	local visual_loadout_extension = condition_func_params.visual_loadout_extension
	local ammo_reserve = inventory_slot_component.current_ammunition_reserve
	local clip_capacity = inventory_slot_component.max_ammunition_clip
	local current_clip_amount = inventory_slot_component.current_ammunition_clip
	local full_clip = clip_capacity == current_clip_amount
	local empty_clip = current_clip_amount == 0
	local reload_policy = action_settings.reload_policy or "always"
	local policy_fulfilled = reload_policy == "empty" and empty_clip or reload_policy == "always" and not full_clip or reload_policy == "always_with_clip"
	local fulfill_reload_requirements = nil

	if reload_policy == "always_with_clip" then
		if ammo_reserve + current_clip_amount > 0 then
			fulfill_reload_requirements = policy_fulfilled
		else
			fulfill_reload_requirements = false
		end
	else
		fulfill_reload_requirements = ammo_reserve > 0 and policy_fulfilled
	end

	if not fulfill_reload_requirements then
		Vo.out_of_ammo_event(inventory_slot_component, visual_loadout_extension)
	end

	return fulfill_reload_requirements
end

local function _has_ammo(condition_func_params)
	local inventory_slot_component = condition_func_params.inventory_slot_component
	local current_clip_amount = inventory_slot_component.current_ammunition_clip

	return current_clip_amount > 0
end

local function _has_ability_charge(action_settings, condition_func_params)
	local ability_extension = condition_func_params.ability_extension
	local ability_type = action_settings.ability_type

	if not ability_type then
		return false
	end

	if not ability_extension:has_ability_type(ability_type) then
		return false
	end

	if not ability_extension:can_use_ability(ability_type) then
		return false
	end

	return true
end

local function _has_ability_charge_or_ammo(action_settings, condition_func_params)
	local is_ability = not not action_settings.ability_type

	if is_ability then
		return _has_ability_charge(action_settings, condition_func_params)
	end

	local inventory_slot_component = condition_func_params.inventory_slot_component
	local has_ammo = inventory_slot_component and not not inventory_slot_component.current_ammunition_clip

	if has_ammo then
		return _has_ammo(condition_func_params)
	end

	return true
end

local function _ability_has_keyword(action_settings, condition_func_params)
	local keyword = action_settings.ability_keyword

	if not keyword then
		return true
	end

	local item_definition = MasterItems.get_cached()
	local ability_type = action_settings.ability_type
	local equipped_abilities = condition_func_params.ability_extension:equipped_abilities()
	local ability = equipped_abilities[ability_type]
	local ability_item_name = ability.inventory_item_name
	local ability_item = ability_item_name and item_definition[ability_item_name]
	local ability_weapon_template = ability_item and WeaponTemplate.weapon_template_from_item(ability_item)
	local has_keyword = ability_weapon_template and WeaponTemplate.has_keyword(ability_weapon_template, keyword)

	return has_keyword
end

local function _weapon_special_active_cooldown(action_settings, condition_func_params)
	local activation_cooldown = action_settings.activation_cooldown

	if not activation_cooldown then
		return true
	end

	local inventory_slot_component = condition_func_params.inventory_slot_component
	local is_special_active = inventory_slot_component.special_active

	if is_special_active then
		local activated_time = inventory_slot_component.special_active_start_t
		local t = Managers.time:time("gameplay")
		local time_since_active = t - activated_time

		if activation_cooldown > time_since_active then
			return false
		end
	end

	return true
end

local function _weapon_special_is_active(action_settings, condition_func_params)
	local inventory_slot_component = condition_func_params.inventory_slot_component
	local is_special_active = inventory_slot_component.special_active

	return is_special_active
end

weapon_action_data.action_kind_condition_funcs = {
	reload_state = function (action_settings, condition_func_params, used_input)
		return _ammo_check(action_settings, condition_func_params)
	end,
	reload_shotgun = function (action_settings, condition_func_params, used_input)
		return _ammo_check(action_settings, condition_func_params)
	end,
	unwield = function (action_settings, condition_func_params, used_input)
		local inventory_read_component = condition_func_params.inventory_read_component
		local weapon_extension = condition_func_params.weapon_extension
		local visual_loadout_extension = condition_func_params.visual_loadout_extension
		local ability_extension = condition_func_params.ability_extension
		local input_extension = condition_func_params.input_extension
		local slot_to_wield = PlayerUnitVisualLoadout.slot_name_from_wield_input(used_input, inventory_read_component, visual_loadout_extension, weapon_extension, ability_extension, input_extension)

		if not weapon_extension:can_wield(slot_to_wield) then
			return false
		end

		if not visual_loadout_extension:can_wield(slot_to_wield) then
			return false
		end

		if not ability_extension:can_wield(slot_to_wield) then
			return false
		end

		return true
	end,
	unwield_to_specific = function (action_settings, condition_func_params, used_input)
		local slot_to_wield = action_settings.slot_to_wield
		local weapon_extension = condition_func_params.weapon_extension
		local visual_loadout_extension = condition_func_params.visual_loadout_extension
		local ability_extension = condition_func_params.ability_extension

		if not weapon_extension:can_wield(slot_to_wield) then
			return false
		end

		if not visual_loadout_extension:can_wield(slot_to_wield) then
			return false
		end

		if not ability_extension:can_wield(slot_to_wield) then
			return false
		end

		return true
	end,
	aim = function (action_settings, condition_func_params, used_input)
		local must_have_ammo_or_charge = action_settings.must_have_ammo_or_charge

		if must_have_ammo_or_charge and not _has_ability_charge(action_settings, condition_func_params) then
			return false
		end

		local alternate_fire_component = condition_func_params.alternate_fire_component

		if alternate_fire_component.is_active then
			return false
		end

		return true
	end,
	push = function (action_settings, condition_func_params, used_input)
		local ability_has_keyword = _ability_has_keyword(action_settings, condition_func_params)
		local special_cooldown = _weapon_special_active_cooldown(action_settings, condition_func_params)
		local stamina_read_component = condition_func_params.stamina_read_component

		return stamina_read_component.current_fraction > 0 and ability_has_keyword and special_cooldown
	end,
	charge_ammo = function (action_settings, condition_func_params, used_input)
		return _has_ammo(condition_func_params)
	end,
	overload_charge = function (action_settings, condition_func_params, used_input)
		if action_settings.psyker_smite or condition_func_params.inventory_slot_component.max_ammunition_clip <= 0 then
			return true
		end

		return _has_ammo(condition_func_params)
	end,
	vent_overheat = function (action_settings, condition_func_params, used_input)
		return Overheat.can_vent(condition_func_params.inventory_slot_component)
	end,
	vent_warp_charge = function (action_settings, condition_func_params, used_input)
		return WarpCharge.can_vent(condition_func_params.warp_charge_component, action_settings)
	end,
	throw_grenade = function (action_settings, condition_func_params, used_input)
		local ability_has_keyword = _ability_has_keyword(action_settings, condition_func_params)
		local has_ability_charge_or_ammo = _has_ability_charge_or_ammo(action_settings, condition_func_params)

		return ability_has_keyword and has_ability_charge_or_ammo
	end,
	flamer_gas = function (action_settings, condition_func_params, used_input)
		return _has_ammo(condition_func_params) or action_settings.uses_warp_charge
	end,
	flamer_gas_burst = function (action_settings, condition_func_params, used_input)
		return _has_ammo(condition_func_params) or action_settings.uses_warp_charge
	end,
	spawn_projectile = function (action_settings, condition_func_params, used_input)
		local ability_has_keyword = _ability_has_keyword(action_settings, condition_func_params)

		if not ability_has_keyword then
			return false
		end

		if action_settings.use_ability_charge then
			return _has_ability_charge(action_settings, condition_func_params)
		end

		return true
	end,
	activate_special = function (action_settings, condition_func_params, used_input)
		return _weapon_special_active_cooldown(action_settings, condition_func_params)
	end,
	ranged_load_special = function (action_settings, condition_func_params, used_input)
		local is_weapon_special_active = _weapon_special_is_active(action_settings, condition_func_params)

		if is_weapon_special_active then
			return false
		end

		local reload_settings = action_settings.reload_settings
		local cost = reload_settings and reload_settings.cost

		if cost then
			local inventory_slot_component = condition_func_params.inventory_slot_component
			local ammo_reserve = inventory_slot_component.current_ammunition_reserve

			if ammo_reserve < cost then
				return false
			end
		end

		return true
	end,
	scan = function (action_settings, condition_func_params, used_input)
		local movement_state_component = condition_func_params.movement_state_component
		local is_dodging = movement_state_component.is_dodging

		return not is_dodging
	end,
	overload_target_finder = function (action_settings, condition_func_params, used_input)
		local can_use = true
		local ability_type = action_settings.ability_type

		if ability_type then
			local ability_extension = condition_func_params.ability_extension
			can_use = ability_extension:can_use_ability(ability_type)
		end

		return can_use
	end,
	chain_lightning = function (action_settings, condition_func_params, used_input)
		local can_use = true
		local ability_type = action_settings.ability_type

		if ability_type then
			local ability_extension = condition_func_params.ability_extension
			can_use = ability_extension:can_use_ability(ability_type)
		end

		local required_charge_level = action_settings.required_charge_level

		if required_charge_level then
			local action_module_charge_component = condition_func_params.action_module_charge_component
			local charge_level = action_module_charge_component.charge_level
			can_use = can_use and required_charge_level <= charge_level
		end

		return can_use
	end,
	smite_targeting = function (action_settings, condition_func_params, used_input)
		local ability_extension = condition_func_params.ability_extension
		local ability_type = action_settings.ability_type
		local can_use = ability_extension:can_use_ability(ability_type)

		return can_use
	end,
	give_pocketable = function (action_settings, condition_func_params, used_input)
		local current_weapon_template = WeaponTemplate.current_weapon_template(condition_func_params.weapon_action_component)
		local give_pickup_name = current_weapon_template.give_pickup_name

		if not give_pickup_name then
			return false
		end

		local action_module_targeting_component = condition_func_params.action_module_targeting_component
		local target_unit = action_module_targeting_component.target_unit_1
		local validate_target_func = action_settings.validate_target_func

		return not validate_target_func or validate_target_func(target_unit)
	end,
	use_syringe = function (action_settings, condition_func_params, used_input)
		local target_unit = nil

		if action_settings.self_use then
			target_unit = condition_func_params.unit
		else
			local action_module_targeting_component = condition_func_params.action_module_targeting_component
			target_unit = action_module_targeting_component.target_unit_1
		end

		if not target_unit then
			return false
		end

		local validate_target_func = action_settings.validate_target_func
		local can_use = not validate_target_func or validate_target_func(target_unit)

		return can_use
	end
}
weapon_action_data.action_kind_total_time_funcs = {
	reload_state = function (action_settings, action_params)
		local weapon = action_params.weapon
		local inventory_slot_component = weapon.inventory_slot_component
		local weapon_template = weapon.weapon_template
		local reload_template = weapon_template.reload_template
		local total_time = ReloadStates.get_total_time(reload_template, inventory_slot_component)

		return total_time
	end,
	toggle_special = function (action_settings, action_params)
		local weapon = action_params.weapon
		local inventory_slot_component = weapon.inventory_slot_component
		local special_active = inventory_slot_component.special_active

		return special_active and action_settings.total_time_deactivate or action_settings.total_time
	end
}
local DEFAULT_NO_AMMO_DELAY_TIME = 1

local function _delay_from_last_ammunition_usage(condition_func_params, action_params, remaining_time, t)
	local weapon = action_params.weapon
	local weapon_template = weapon and weapon.weapon_template
	local inventory_slot_component = weapon.inventory_slot_component
	local no_ammo_delay = weapon_template and weapon_template.no_ammo_delay or DEFAULT_NO_AMMO_DELAY_TIME
	local end_t = inventory_slot_component.last_ammunition_usage + no_ammo_delay

	return t >= end_t
end

local function _no_ammo(condition_func_params, action_params, remaining_time)
	local player_unit = action_params.player_unit
	local weapon = action_params.weapon
	local inventory_slot_component = weapon.inventory_slot_component
	local no_ammo_in_clip = inventory_slot_component.current_ammunition_clip == 0
	local has_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve > 0
	local buff_keywords = BuffSettings.keywords
	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local no_ammo_consumption = buff_extension:has_keyword(buff_keywords.no_ammo_consumption)

	return not no_ammo_consumption and no_ammo_in_clip and has_ammo_in_reserve
end

local function _is_sprinting(condition_func_params, action_params, remaining_time)
	local sprint_character_state_component = condition_func_params.sprint_character_state_component
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)

	return is_sprinting
end

local function _in_alternate_fire(condition_func_params, action_params, remaining_time)
	local alternate_fire_component = condition_func_params.alternate_fire_component
	local in_alternate_fire = alternate_fire_component and alternate_fire_component.is_active

	return in_alternate_fire
end

local function _started_reload(condition_func_params, action_params, remaining_time)
	local weapon = action_params.weapon
	local inventory_slot_component = weapon.inventory_slot_component
	local weapon_template = weapon.weapon_template
	local reload_template = weapon_template.reload_template

	return ReloadStates.started_reload(reload_template, inventory_slot_component)
end

weapon_action_data.conditional_state_functions = {
	no_grenades_and_got_grenade = function (condition_func_params, action_params, remaining_time, t)
		local ability_extension = condition_func_params.ability_extension
		local ability_type = "grenade_ability"
		local charge_replenished = ability_extension:charge_replenished(ability_type)
		local remaining_charges = ability_extension:remaining_ability_charges(ability_type)

		return charge_replenished and remaining_charges == 1
	end,
	combat_ability_charges_left = function (condition_func_params, action_params, remaining_time, t)
		local ability_extension = condition_func_params.ability_extension
		local ability_type = "combat_ability"
		local remaining_charges = ability_extension:remaining_ability_charges(ability_type)

		return remaining_charges > 0
	end,
	no_combat_ability_charges_left = function (condition_func_params, action_params, remaining_time, t)
		local ability_extension = condition_func_params.ability_extension
		local ability_type = "combat_ability"
		local remaining_charges = ability_extension:remaining_ability_charges(ability_type)

		return remaining_charges <= 0
	end,
	no_ammo = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)

		return no_ammo and no_sprinting
	end,
	no_ammo_with_delay = function (condition_func_params, action_params, remaining_time, t)
		local delay_from_from_last_ammunition_usage = _delay_from_last_ammunition_usage(condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)

		return delay_from_from_last_ammunition_usage and no_ammo and no_sprinting
	end,
	no_ammo_and_started_reload = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)
		local started_reload = _started_reload(condition_func_params, action_params, remaining_time)

		return no_ammo and no_sprinting and started_reload
	end,
	no_ammo_no_alternate_fire = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)
		local no_alternate_fire = not _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return no_ammo and no_sprinting and no_alternate_fire
	end,
	no_ammo_no_alternate_fire_with_delay = function (condition_func_params, action_params, remaining_time, t)
		local delay_from_from_last_ammunition_usage = _delay_from_last_ammunition_usage(condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)
		local no_alternate_fire = not _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return delay_from_from_last_ammunition_usage and no_ammo and no_sprinting and no_alternate_fire
	end,
	no_ammo_and_started_reload_no_alternate_fire = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local no_sprinting = not _is_sprinting(condition_func_params, action_params, remaining_time)
		local started_reload = _started_reload(condition_func_params, action_params, remaining_time)
		local no_alternate_fire = not _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return no_ammo and no_sprinting and started_reload and no_alternate_fire
	end,
	no_ammo_alternate_fire = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local in_alternate_fire = _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return no_ammo and in_alternate_fire
	end,
	no_ammo_alternate_fire_with_delay = function (condition_func_params, action_params, remaining_time, t)
		local delay_from_from_last_ammunition_usage = _delay_from_last_ammunition_usage(condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local in_alternate_fire = _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return delay_from_from_last_ammunition_usage and no_ammo and in_alternate_fire
	end,
	no_ammo_and_started_reload_alternate_fire = function (condition_func_params, action_params, remaining_time, t)
		local no_ammo = _no_ammo(condition_func_params, action_params, remaining_time)
		local started_reload = _started_reload(condition_func_params, action_params, remaining_time)
		local in_alternate_fire = _in_alternate_fire(condition_func_params, action_params, remaining_time)

		return no_ammo and started_reload and in_alternate_fire
	end,
	started_reload = function (condition_func_params, action_params, remaining_time, t)
		local started_reload = _started_reload(condition_func_params, action_params, remaining_time)

		return started_reload
	end,
	has_cocked_weapon = function (condition_func_params, action_params, remaining_time, t)
		local inventory_slot_component = condition_func_params.inventory_slot_component
		local reload_state = inventory_slot_component.reload_state
		local test = reload_state == "cock_weapon" and not _is_sprinting(condition_func_params, action_params, remaining_time)

		return test
	end,
	auto_chain = function (condition_func_params, action_params, remaining_time, t)
		local no_time_left = remaining_time <= 0

		return no_time_left
	end,
	no_mission_zone = function (condition_func_params, action_params, remaining_time, t)
		return not Scanning.has_active_scanning_zone()
	end,
	no_running_action = function (condition_func_params, action_params, remaining_time, t)
		local weapon_action_component = condition_func_params.weapon_action_component
		local current_action = weapon_action_component.current_action_name
		local no_running_action = current_action == "none"

		return no_running_action
	end,
	auto_block = function (condition_func_params, action_params, remaining_time, t)
		local Managers = Managers

		if Managers.input:cursor_active() then
			return true
		end

		if IS_WINDOWS and not Window.has_focus() then
			return true
		end

		if HAS_STEAM and Managers.steam:is_overlay_active() then
			return true
		end
	end
}
weapon_action_data.action_kind_to_running_action_chain_event = {
	aim = {
		has_charge = true
	},
	block = {
		has_blocked = true
	},
	chain_lightning = {
		stop_time_reached = true,
		charge_depleted = true,
		force_vent = true
	},
	charge = {
		fully_charged = true
	},
	charge_ammo = {
		fully_charged = true
	},
	flamer_gas = {
		reserve_empty = true,
		charge_depleted = true,
		clip_empty = true
	},
	overload_charge = {
		fully_charged = true,
		overheating = true
	},
	overload_charge_position_finder = {
		fully_charged = true
	},
	overload_charge_target_finder = {
		fully_charged = true
	},
	reload_shotgun = {
		reload_loop = true
	},
	scan = {
		no_mission_zone = true
	},
	scan_confirm = {
		stop_scanning = true,
		no_mission_zone = true
	},
	smite_targeting = {
		fully_charged = true
	},
	spawn_projectile = {
		out_of_charges = true,
		force_vent = true
	},
	vent_overheat = {
		fully_vented = true
	},
	vent_warp_charge = {
		fully_vented = true
	}
}

for name, _ in pairs(weapon_action_data.action_kind_condition_funcs) do
	-- Nothing
end

for name, _ in pairs(weapon_action_data.action_kind_total_time_funcs) do
	-- Nothing
end

return weapon_action_data
