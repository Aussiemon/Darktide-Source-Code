-- chunkname: @scripts/extension_systems/weapon/actions/action_chain_lightning.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local ActionChainLightning = class("ActionChainLightning", "ActionWeaponBase")
local keywords = BuffSettings.keywords
local special_rules = SpecialRulesSettings.special_rules
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local DEFAULT_POWER_LEVEL_RANDOM_RANGE = {
	max = 1.25,
	min = 0.75,
}
local PROC_EVENTS = BuffSettings.proc_events
local EXTERNAL_PROPERTIES = {}
local TAIL_SOURCE_POS = Vector3Box(0, 0, 0)
local DONT_SYNC_TO_SENDER = true
local SYNC_TO_CLIENTS = true
local BREADTH_FIRST_VALIDATION = ChainLightning.breadth_first_validation_functions
local DEPTH_FIRST_VALIDATION = ChainLightning.depth_first_validation_functions
local ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS = {
	"target_unit_1",
	"target_unit_2",
	"target_unit_3",
}
local _on_add_func, _on_remove_func, _set_charge_level, _trigger_gear_sound, _trigger_gear_tail_sound, _trigger_exclusive_gear_sound

ActionChainLightning.init = function (self, action_context, action_params, action_settings)
	ActionChainLightning.super.init(self, action_context, action_params, action_settings)

	if self._is_server then
		self._chain_root_node = nil
		self._temp_targets = {}
		self._hit_units = {}
		self._next_jump_time = 0

		local talent_extension = ScriptUnit.has_extension(self._player_unit, "talent_system")
		local weapon = self._weapon

		self._func_context = {
			action_settings = self._action_settings,
			buff_extension = self._buff_extension,
			hit_units = self._hit_units,
			player_unit = self._player_unit,
			talent_extension = talent_extension,
			source_item = weapon and weapon.item,
		}

		self._jump_on_add_func = function (node, func_context)
			_on_add_func(node, func_context)
			self:_play_jump_sound()
		end

		self:_create_chain_root_node(action_settings)
	end

	self._action_settings = action_settings
	self._ability_extension = action_context.ability_extension

	local first_person_unit = self._first_person_unit
	local player_unit = self._player_unit
	local physics_world = self._physics_world
	local is_server = self._is_server
	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._action_component = unit_data_extension:write_component("action_shoot")

	local action_module_charge_component = unit_data_extension:write_component("action_module_charge")

	self._action_module_charge_component = action_module_charge_component
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")

	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	local targeting_module_component = unit_data_extension:write_component("action_module_target_finder")

	self._targeting_module_component = targeting_module_component
	self._targeting_module = ActionModules[target_finder_module_class_name]:new(is_server, physics_world, player_unit, targeting_module_component, action_settings)

	local overload_module_class_name = action_settings.overload_module_class_name

	if overload_module_class_name then
		self._overload_module = ActionModules[overload_module_class_name]:new(is_server, player_unit, action_settings, self._inventory_slot_component)
	end

	self._charge_module = ActionModules.charge:new(is_server, physics_world, player_unit, first_person_unit, action_module_charge_component, action_settings)

	local weapon = action_params.weapon

	self._left_fx_source_name = weapon.fx_sources._left
	self._right_fx_source_name = weapon.fx_sources._right
	self._both_fx_source_name = weapon.fx_sources._both
end

ActionChainLightning.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionChainLightning.super.start(self, action_settings, t, time_scale, action_start_params)
	self:_handle_modules_and_components_start(t, action_settings)
	self:_handle_buffs_start()

	if self._is_server then
		self:_clear_initial_targets()
		ChainLightningTarget.remove_all_child_nodes(self._chain_root_node, _on_remove_func, self._func_context)
		table.clear(self._temp_targets)
		table.clear(self._hit_units)

		self._next_jump_time = 0
	end

	if action_settings.can_crit then
		self:_check_for_critical_strike(false, true)
	end

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"

	self:_play_shoot_sound()
	self:_start_looping_shoot_sound()
end

ActionChainLightning._create_chain_root_node = function (self, action_settings)
	if not self._chain_root_node then
		local chain_settings = action_settings.chain_settings
		local depth = 0
		local use_random = false
		local player_unit = self._player_unit
		local num_component_targets = #ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS
		local chain_root_node = ChainLightningTarget:new(chain_settings, depth, use_random, nil, "unit", player_unit)

		chain_root_node:set_max_num_children(num_component_targets)

		for ii = 1, num_component_targets do
			local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[ii]

			chain_root_node:set_value(key, false)
		end

		self._chain_root_node = chain_root_node
	end

	self:_clear_initial_targets()
end

ActionChainLightning._clear_initial_targets = function (self)
	local chain_root_node = self._chain_root_node

	for ii = 1, #ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS do
		local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[ii]

		chain_root_node:set_value(key, false)
	end
end

ActionChainLightning.fixed_update = function (self, dt, t, time_in_action, frame)
	self._targeting_module:fixed_update(dt, t)

	local overload_module = self._overload_module

	if overload_module then
		overload_module:fixed_update(dt, t)
	end

	local charge_template = self._weapon_extension:charge_template()

	if charge_template and charge_template.charge_on_action_start then
		self._charge_module:fixed_update(dt, t)
	end

	if self._run_shoot_loop_sfx then
		self._fx_extension:run_looping_sound(self._looping_shoot_sfx_alias, self._fx_source_name, nil, frame)
	end

	if self._is_server then
		local action_module_charge_component = self._action_module_charge_component
		local charge_cost = charge_template and charge_template.charge_cost or 0
		local new_charge = action_module_charge_component.charge_level - charge_cost * dt

		action_module_charge_component.charge_level = math.clamp01(new_charge)

		self:_find_root_targets(t, time_in_action)
		self:_validate_targets(t)

		local fire_time = self._action_settings.fire_time

		if fire_time and fire_time < time_in_action then
			self:_find_new_targets(t)
		end
	end
end

ActionChainLightning.finish = function (self, reason, data, t, time_in_action, action_settings, next_action_params)
	local no_damage_on_cleanup_on_chain_action_kind = action_settings.no_damage_on_cleanup_on_chain_action_kind
	local skip_last_damage = no_damage_on_cleanup_on_chain_action_kind and reason == "new_interrupting_action" and data.new_action_kind == no_damage_on_cleanup_on_chain_action_kind

	if self._is_server then
		self:_clear_initial_targets()

		if not skip_last_damage then
			local weapon = self._weapon
			local source_item = weapon and weapon.item

			self:_deal_damage(t, time_in_action, source_item)
		end

		ChainLightningTarget.remove_all_child_nodes(self._chain_root_node, _on_remove_func, self._func_context)
	end

	self:_handle_buffs_finish()
	self:_handle_modules_and_components_finish(reason, data, t)
	ActionChainLightning.super.finish(self, reason, data, t, time_in_action)
end

ActionChainLightning.running_action_state = function (self, t, time_in_action)
	local charge_template = self._weapon_extension:charge_template()
	local charge_cost = charge_template.charge_cost
	local charge_component = self._action_module_charge_component

	if charge_cost and charge_component.charge_level <= 0 then
		return "charge_depleted"
	end

	local action_settings = self._action_settings
	local is_critical_strike = self._critical_strike_component.is_active
	local stop_time = is_critical_strike and action_settings.stop_time_critical_strike or action_settings.stop_time

	if stop_time and type(stop_time) == "table" then
		stop_time = math.lerp(stop_time[1], stop_time[2], charge_component.charge_level)
	end

	if stop_time and stop_time <= time_in_action then
		return "stop_time_reached"
	end

	local warp_charge_component = self._warp_charge_component
	local current_warp_charge = warp_charge_component.current_percentage

	if current_warp_charge >= 1 then
		local prevent_overload = self._buff_extension:has_keyword(keywords.psychic_fortress)

		if not prevent_overload then
			warp_charge_component.state = "idle"

			return "force_vent"
		end
	end
end

ActionChainLightning._play_shoot_sound = function (self)
	local action_settings = self._action_settings
	local action_module_charge_component = self._action_module_charge_component
	local fx_extension = self._fx_extension
	local fx_settings = action_settings.fx
	local shoot_sfx_alias = fx_settings.shoot_sfx_alias
	local tail_alias = fx_settings.shoot_tail_sfx_alias
	local charge_level_parameter_name = fx_settings.charge_level_parameter_name
	local fx_hand = fx_settings.fx_hand
	local fx_source_name = fx_hand == "both" and self._both_fx_source_name or fx_hand == "left" and self._left_fx_source_name or self._right_fx_source_name

	if fx_source_name then
		_trigger_gear_sound(fx_extension, fx_source_name, shoot_sfx_alias, action_module_charge_component)
		_trigger_gear_tail_sound(fx_extension, fx_source_name, tail_alias)
		_set_charge_level(fx_extension, fx_source_name, charge_level_parameter_name, action_module_charge_component)
	end
end

ActionChainLightning._play_jump_sound = function (self)
	local action_settings = self._action_settings
	local action_module_charge_component = self._action_module_charge_component
	local fx_extension = self._fx_extension
	local fx_settings = action_settings.fx
	local shoot_sfx_alias = fx_settings.jump_sfx_alias
	local fx_hand = fx_settings.fx_hand
	local fx_source_name = fx_hand == "both" and self._both_fx_source_name or fx_hand == "left" and self._left_fx_source_name or self._right_fx_source_name

	if fx_source_name and shoot_sfx_alias then
		_trigger_gear_sound(fx_extension, fx_source_name, shoot_sfx_alias, action_module_charge_component)
	end
end

ActionChainLightning._start_looping_shoot_sound = function (self)
	local is_critical_strike = self._critical_strike_component.is_active
	local fx_settings = self._action_settings.fx
	local fx_extension = self._fx_extension
	local shoot_alias = fx_settings.looping_shoot_sfx_alias
	local crit_alias = fx_settings.looping_shoot_critical_strike_sfx_alias or shoot_alias

	if not crit_alias and not shoot_alias then
		return
	end

	local is_playing_crit_sfx_loop = fx_extension:is_looping_sound_playing(crit_alias)
	local is_playing_shoot_sfx_loop = fx_extension:is_looping_sound_playing(shoot_alias)
	local can_play = is_critical_strike and not is_playing_crit_sfx_loop or not is_playing_shoot_sfx_loop

	if can_play then
		local fx_hand = fx_settings.fx_hand
		local fx_source_name = fx_hand == "both" and self._both_fx_source_name or fx_hand == "left" and self._left_fx_source_name or self._right_fx_source_name
		local looping_sound_alias = is_critical_strike and crit_alias or shoot_alias

		if fx_source_name and looping_sound_alias then
			self._fx_source_name = fx_source_name
			self._looping_shoot_sfx_alias = looping_sound_alias
			self._run_shoot_loop_sfx = true
		end
	end
end

ActionChainLightning._handle_modules_and_components_start = function (self, t, action_settings)
	local overload_module = self._overload_module
	local action_module_charge_component = self._action_module_charge_component
	local is_critical_strike = self._critical_strike_component.is_active

	if overload_module then
		overload_module:start(t)
	end

	if is_critical_strike and action_settings.super_charge_on_crit then
		action_module_charge_component.charge_level = 1
	end

	action_module_charge_component.max_charge = 1

	local charge_template = self._weapon_extension:charge_template()

	if charge_template and charge_template.charge_on_action_start then
		self._charge_module:start(t)
	end

	local charge_level = action_module_charge_component.charge_level

	self:_start_warp_charge_action(t)
	self:_pay_warp_charge_cost_immediate(t, charge_level)
	self._targeting_module:start(t)
end

ActionChainLightning._handle_modules_and_components_finish = function (self, reason, data, t)
	local overload_module = self._overload_module

	if overload_module then
		overload_module:finish(reason, data, t)
	end

	self._action_module_charge_component.charge_level = 0

	self._targeting_module:finish(reason, data, t)
end

ActionChainLightning._handle_buffs_start = function (self)
	local action_settings = self._action_settings

	if not action_settings.no_chain_lightning_procs then
		local buff_extension = self._buff_extension
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = self._player_unit

			buff_extension:add_proc_event(PROC_EVENTS.on_chain_lightning_start, param_table)
		end
	end
end

ActionChainLightning._handle_buffs_finish = function (self)
	local action_settings = self._action_settings

	if not action_settings.no_chain_lightning_procs then
		local buff_extension = self._buff_extension
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = self._player_unit

			buff_extension:add_proc_event(PROC_EVENTS.on_chain_lightning_finish, param_table)
		end
	end
end

ActionChainLightning._find_root_targets = function (self, t, time_in_action)
	local action_settings = self._action_settings
	local hit_units = self._hit_units
	local chain_root_node = self._chain_root_node
	local chain_settings = action_settings.chain_settings
	local depth = 0
	local use_random = true
	local max_targets = ChainLightning.max_targets(time_in_action, chain_settings, depth, use_random)
	local targeting_module_component = self._targeting_module_component
	local context = self._func_context

	for ii = 1, #ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS do
		if max_targets <= chain_root_node:num_children() then
			break
		end

		local key = ACTION_MODULE_TARGET_FINDER_COMPONENT_KEYS[ii]
		local target_unit = targeting_module_component[key]

		if target_unit and not hit_units[target_unit] then
			local slot_target_node = chain_root_node:value(key)
			local slot_target_unit_alive = HEALTH_ALIVE[chain_root_node:value("target_unit")]

			if slot_target_node and not slot_target_unit_alive then
				ChainLightningTarget.remove_all_child_nodes(slot_target_node, _on_remove_func, context)
				chain_root_node:remove_child(slot_target_node, _on_remove_func, context)

				hit_units[target_unit] = nil
				slot_target_node = false
			end

			if not slot_target_node then
				local child_node = chain_root_node:add_child(_on_add_func, context, "unit", target_unit, "start_t", t)

				chain_root_node:set_value(key, child_node)

				hit_units[target_unit] = true
			end
		end
	end
end

ActionChainLightning._validate_targets = function (self, t)
	local chain_root_node = self._chain_root_node
	local temp_targets = self._temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_not_alive)

	local num_targets = #temp_targets

	for ii = num_targets, 1, -1 do
		local target = temp_targets[ii]

		target:mark_for_deletion()
	end

	ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_root_node, _on_remove_func, self._func_context)
end

ActionChainLightning._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	local action_settings = self._action_settings
	local player_unit = self._player_unit
	local chain_root_node = self._chain_root_node
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local stat_buffs = self._buff_extension:stat_buffs()
	local chain_settings = action_settings.chain_settings
	local time_in_action = t - self._weapon_action_component.start_t
	local max_angle, close_max_angle, max_z_diff, vertical_max_angle, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(time_in_action, chain_settings, stat_buffs)

	for child_node, _ in pairs(chain_root_node:children()) do
		local travel_direction = Vector3_normalize(Vector3_flat(player_position - POSITION_LOOKUP[child_node:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, child_node, travel_direction)
	end

	self._next_jump_time = t + jump_time
end

ActionChainLightning._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, source_node, initial_travel_direction)
	local temp_targets = self._temp_targets
	local hit_units = self._hit_units
	local func_context = self._func_context
	local physics_world = self._physics_world

	table.clear(temp_targets)
	ChainLightningTarget.traverse_breadth_first(t, source_node, temp_targets, BREADTH_FIRST_VALIDATION.node_available_within_depth_and_target_alive, max_jumps)

	for ii = 1, #temp_targets do
		local source = temp_targets[ii]

		ChainLightning.jump(t, physics_world, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, vertical_max_angle, max_z_diff, self._jump_on_add_func, func_context, nil)
	end
end

ActionChainLightning._deal_damage = function (self, t, time_in_action, source_item)
	local action_settings = self._action_settings

	if not action_settings then
		return
	end

	local attack_charge
	local charge_template = self._weapon_extension:charge_template()
	local time_in_action_to_attack_charge = charge_template.time_in_action_to_attack_charge

	if time_in_action_to_attack_charge then
		attack_charge = math.clamp01(time_in_action / time_in_action_to_attack_charge)
	else
		attack_charge = self._action_module_charge_component.charge_level
	end

	local damage_profile = action_settings.damage_profile
	local damage_type = action_settings.damage_type
	local player_unit = self._player_unit
	local temp_targets = self._temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, self._chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_alive_and_not_self, player_unit)

	for ii = 1, #temp_targets do
		local target = temp_targets[ii]
		local unit = target:value("unit")
		local depth = target:depth()
		local is_critical_strike = self._critical_strike_component.is_active
		local power_level = DEFAULT_POWER_LEVEL
		local player_rotation = self._first_person_component.rotation
		local attack_direction = Quaternion.rotate(player_rotation, Vector3.forward())

		if damage_profile.random_damage then
			local random_range = damage_profile.random_damage[depth] or DEFAULT_POWER_LEVEL_RANDOM_RANGE
			local random_mod = random_range.min + math.random() * (random_range.max - random_range.min)

			power_level = power_level * random_mod
		end

		ChainLightning.execute_attack(unit, player_unit, power_level, attack_charge, depth, ii, attack_direction, damage_profile, damage_type, is_critical_strike, source_item)
	end
end

function _on_add_func(node, context)
	local target_unit = node:value("unit")
	local start_t = node:value("start_t") or 0

	context.hit_units[target_unit] = true

	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if target_buff_extension then
		local action_settings = context.action_settings
		local improved_target_buff = context.talent_extension:has_special_rule(special_rules.psyker_chain_lightning_improved_target_buff)
		local target_buff = improved_target_buff and action_settings.improved_target_buff or action_settings.target_buff
		local _, buff_id = target_buff_extension:add_externally_controlled_buff(target_buff, start_t, "owner_unit", context.player_unit, "source_item", context.source_item)

		node:set_value("buff_id", buff_id)

		local buff_extension = context.buff_extension
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.attacked_unit = target_unit

			buff_extension:add_proc_event(PROC_EVENTS.on_chain_lightning_jump, param_table)
		end
	end
end

function _on_remove_func(node, context)
	local target_unit = node:value("unit")
	local buff_id = node:value("buff_id")

	context.hit_units[target_unit] = nil

	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if buff_id and target_buff_extension then
		target_buff_extension:remove_externally_controlled_buff(buff_id)
		node:set_value("buff_id", nil)
	end
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

return ActionChainLightning
