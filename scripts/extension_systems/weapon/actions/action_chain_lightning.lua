require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local ActionChainLightning = class("ActionChainLightning", "ActionWeaponBase")
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local CHAIN_LIGHTNING_BUFF = "chain_lightning_interval"
local _damage_finding_func, _target_finding_func, _traverse_validation_func, _on_add_func, _on_delete_func = nil

ActionChainLightning.init = function (self, action_context, action_params, action_settings)
	ActionChainLightning.super.init(self, action_context, action_params, action_settings)

	self._action_settings = action_settings
	self._ability_extension = action_context.ability_extension
	local first_person_unit = self._first_person_unit
	local player_unit = self._player_unit
	local physics_world = self._physics_world
	local unit_data_extension = action_context.unit_data_extension
	self._action_component = unit_data_extension:write_component("action_shoot")
	self._action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	local targeting_component = unit_data_extension:write_component("action_module_targeting")
	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	self._targeting_component = targeting_component
	self._targeting_module = ActionModules[target_finder_module_class_name]:new(physics_world, player_unit, targeting_component, action_settings)
	local action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._action_module_charge_component = action_module_charge_component
	self._charge_module = ActionModules.charge:new(physics_world, player_unit, first_person_unit, action_module_charge_component, action_settings)
	self._chain_targets = {}
	self._temp_targets = {}
	self._hit_units = {}
	self._next_jump_time = 0
	local fx_settings = action_settings.fx
	local looping_shoot_sfx_alias = fx_settings.looping_shoot_sfx_alias

	if looping_shoot_sfx_alias then
		local component_name = PlayerUnitData.looping_sound_component_name(looping_shoot_sfx_alias)
		self._looping_shoot_sound_component = unit_data_extension:read_component(component_name)
	end

	local looping_shoot_critical_strike_sfx_alias = fx_settings.looping_shoot_critical_strike_sfx_alias

	if looping_shoot_critical_strike_sfx_alias then
		local component_name = PlayerUnitData.looping_sound_component_name(looping_shoot_critical_strike_sfx_alias)
		self._looping_shoot_critial_strike_sound_component = unit_data_extension:read_component(component_name)
	end

	local weapon = action_params.weapon
	self._left_fx_source_name = weapon.fx_sources._left
	self._right_fx_source_name = weapon.fx_sources._right
	self._both_fx_source_name = weapon.fx_sources._both
end

ActionChainLightning.start = function (self, action_settings, t, ...)
	ActionChainLightning.super.start(self, action_settings, t, ...)

	local charge_component = self._action_module_charge_component

	if action_settings.can_crit then
		self:_check_for_critical_strike(false, true)
	end

	local is_critical_strike = self._critical_strike_component.is_active

	if is_critical_strike and action_settings.super_charge_on_crit then
		charge_component.charge_level = 1
	end

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._player_unit

		buff_extension:add_proc_event(proc_events.on_chain_lightning_start, param_table)
	end

	charge_component.max_charge = 1
	local charge_template = self._weapon_extension:charge_template()

	if charge_template and charge_template.charge_on_action_start then
		self._charge_module:start(t)
	end

	if self._is_server then
		table.clear(self._chain_targets)
		table.clear(self._hit_units)

		local player_unit = self._player_unit
		local chain_settings = action_settings.chain_settings
		local max_targets_settings = chain_settings.max_targets
		local max_targets = ChainLightning.calculate_max_targets(max_targets_settings, 1)
		local use_random = true
		local target_unit_1 = self._targeting_component.target_unit_1
		local target_unit_2 = self._targeting_component.target_unit_2
		local target_unit_3 = self._targeting_component.target_unit_3

		if target_unit_1 and max_targets >= 1 then
			local _, buff_id = nil
			local target_buff_extension = ScriptUnit.has_extension(target_unit_1, "buff_system")

			if target_buff_extension then
				_, buff_id = target_buff_extension:add_externally_controlled_buff(CHAIN_LIGHTNING_BUFF, t, "owner_unit", player_unit)
			end

			local target = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_1, "buff_id", buff_id)
			self._chain_targets[#self._chain_targets + 1] = target
			self._hit_units[target_unit_1] = true
		end

		if target_unit_2 and max_targets >= 2 then
			local _, buff_id = nil
			local target_buff_extension = ScriptUnit.has_extension(target_unit_2, "buff_system")

			if target_buff_extension then
				_, buff_id = target_buff_extension:add_externally_controlled_buff(CHAIN_LIGHTNING_BUFF, t, "owner_unit", player_unit)
			end

			local target = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_2, "buff_id", buff_id)
			self._chain_targets[#self._chain_targets + 1] = target
			self._hit_units[target_unit_2] = true
		end

		if target_unit_3 and max_targets >= 3 then
			local _, buff_id = nil
			local target_buff_extension = ScriptUnit.has_extension(target_unit_3, "buff_system")

			if target_buff_extension then
				_, buff_id = target_buff_extension:add_externally_controlled_buff(CHAIN_LIGHTNING_BUFF, t, "owner_unit", player_unit)
			end

			local target = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_3, "buff_id", buff_id)
			self._chain_targets[#self._chain_targets + 1] = target
			self._hit_units[target_unit_3] = true
		end

		self._next_jump_time = 0
	end

	self:_play_shoot_sound(is_critical_strike)

	local charge_level = charge_component.charge_level

	self:_start_warp_charge_action(t)
	self:_pay_warp_charge_cost(t, charge_level)
	self._targeting_module:start(t)
end

ActionChainLightning._play_shoot_sound = function (self, is_critical_strike)
	local fx_settings = self._action_settings.fx
	local looping_shoot_sfx_alias = is_critical_strike and fx_settings.looping_shoot_critical_strike_sfx_alias or fx_settings.looping_shoot_sfx_alias
	local fx_hand = fx_settings.fx_hand

	if fx_hand == "both" then
		self._fx_extension:trigger_looping_wwise_event(looping_shoot_sfx_alias, self._both_fx_source_name)
	elseif fx_hand == "right" then
		self._fx_extension:trigger_looping_wwise_event(looping_shoot_sfx_alias, self._right_fx_source_name)
	elseif fx_hand == "left" then
		self._fx_extension:trigger_looping_wwise_event(looping_shoot_sfx_alias, self._left_fx_source_name)
	end
end

ActionChainLightning.fixed_update = function (self, dt, t, time_in_action)
	self._targeting_module:fixed_update(dt, t)

	local charge_template = self._weapon_extension:charge_template()

	if charge_template and charge_template.charge_on_action_start then
		self._charge_module:fixed_update(dt, t)
	end

	if not self._is_server then
		return
	end

	self:_validate_targets(t)

	local shoot_at_time = self._action_settings.shoot_at_time

	if shoot_at_time and shoot_at_time < time_in_action then
		self:_find_new_targets(t)
	end

	local charge_component = self._action_module_charge_component
	local charge_cost = charge_template.charge_cost or 0
	local new_charge = charge_component.charge_level - charge_cost * dt
	charge_component.charge_level = math.clamp01(new_charge)
end

ActionChainLightning._validate_targets = function (self, t)
	local temp_targets = self._temp_targets
	local chain_targets = self._chain_targets
	local hit_units = self._hit_units

	for ii = #chain_targets, 1, -1 do
		local target = chain_targets[ii]
		local target_unit = target:value("unit")

		if not HEALTH_ALIVE[target_unit] then
			ChainLightningTarget.remove_all_child_nodes(target, _on_delete_func, self._hit_units)
			table.swap_delete(chain_targets, ii)

			hit_units[target_unit] = nil
		end
	end

	table.clear(temp_targets)

	for ii = 1, #chain_targets do
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], temp_targets, _traverse_validation_func)
	end

	local num_targets = #temp_targets

	for ii = num_targets, 1, -1 do
		local target = temp_targets[ii]

		target:mark_for_deletion()
	end

	for ii = 1, #chain_targets do
		ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_targets[ii], _on_delete_func, hit_units)
	end
end

ActionChainLightning._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	local action_settings = self._action_settings
	local player_unit = self._player_unit
	local chain_targets = self._chain_targets
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local stat_buffs = self._buff_extension:stat_buffs()
	local chain_settings = action_settings.chain_settings
	local max_angle, close_max_angle, max_z_diff, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(chain_settings, stat_buffs)

	for ii = 1, #chain_targets do
		local target = chain_targets[ii]
		local travel_direction = Vector3_normalize(Vector3_flat(player_position - POSITION_LOOKUP[target:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, close_max_angle, max_z_diff, max_jumps, radius, target, travel_direction)
	end

	self._next_jump_time = t + jump_time
end

ActionChainLightning._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, close_max_angle, max_z_diff, max_jumps, radius, root_target, initial_travel_direction)
	local temp_targets = self._temp_targets
	local hit_units = self._hit_units

	table.clear(temp_targets)
	ChainLightningTarget.traverse_breadth_first(root_target, temp_targets, _target_finding_func, max_jumps)

	for ii = 1, #temp_targets do
		local source = temp_targets[ii]

		ChainLightning.jump(self, t, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, max_z_diff, _on_add_func)
	end
end

ActionChainLightning._deal_damage = function (self, t, time_in_action)
	local action_settings = self._action_settings

	if not action_settings then
		return
	end

	local attack_charge = nil
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

	local chain_targets = self._chain_targets

	for ii = 1, #chain_targets do
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], temp_targets, _damage_finding_func, player_unit)
	end

	for ii = 1, #temp_targets do
		local target = temp_targets[ii]
		local unit = target:value("unit")
		local depth = target:depth()
		local hit_zone_name = "center_mass"
		local hit_zone_actors = HitZone.get_actor_names(unit, hit_zone_name)
		local hit_actor_name = hit_zone_actors[1]
		local hit_actor = Unit.actor(unit, hit_actor_name)
		local node_index = Actor.node(hit_actor)
		local hit_world_position = Unit.world_position(unit, node_index)
		local is_critical_strike = self._critical_strike_component.is_active
		local power_level = DEFAULT_POWER_LEVEL

		if damage_profile.random_damage then
			local random_range = damage_profile.random_damage[depth] or {
				max = 1.25,
				min = 0.75
			}
			local random_mod = random_range.min + math.random() * (random_range.max - random_range.min)
			power_level = power_level * random_mod
		end

		local damage_dealt, attack_result, damage_efficiency = Attack.execute(unit, damage_profile, "power_level", power_level, "charge_level", attack_charge, "target_index", depth, "hit_world_position", hit_world_position, "hit_zone_name", hit_zone_name, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", attack_types.ranged, "damage_type", damage_type, "is_critical_strike", is_critical_strike)
	end
end

ActionChainLightning.finish = function (self, reason, data, t, time_in_action)
	local fx_settings = self._action_settings.fx
	local looping_shoot_sound_component = self._looping_shoot_sound_component

	if looping_shoot_sound_component and looping_shoot_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(fx_settings.looping_shoot_sfx_alias)
	end

	local looping_shoot_critical_strike_sound_component = self._looping_shoot_critial_strike_sound_component

	if looping_shoot_critical_strike_sound_component and looping_shoot_critical_strike_sound_component.is_playing then
		self._fx_extension:stop_looping_wwise_event(fx_settings.looping_shoot_critical_strike_sfx_alias)
	end

	if self._is_server then
		self:_deal_damage(t, time_in_action)

		local chain_targets = self._chain_targets

		for ii = 1, #chain_targets do
			ChainLightningTarget.remove_all_child_nodes(chain_targets[ii], _on_delete_func, self._hit_units)

			local target_unit = chain_targets[ii]:value("unit")
			local buff_id = chain_targets[ii]:value("buff_id")
			local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			if buff_id and target_buff_extension then
				target_buff_extension:remove_externally_controlled_buff(buff_id)
			end
		end
	end

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._player_unit

		buff_extension:add_proc_event(proc_events.on_chain_lightning_finish, param_table)
	end

	self._action_module_charge_component.charge_level = 0

	ActionChainLightning.super.finish(self, reason, data, t, time_in_action)
	self._targeting_module:finish(reason, data, t)
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
end

function _damage_finding_func(node, player_unit)
	local target_unit = node:value("unit")

	return target_unit ~= player_unit and HEALTH_ALIVE[target_unit]
end

function _target_finding_func(node, max_jumps)
	return not node:is_full() and node:depth() <= max_jumps and HEALTH_ALIVE[node:value("unit")]
end

function _traverse_validation_func(node)
	local target_unit = node:value("unit")

	return not HEALTH_ALIVE[target_unit]
end

function _on_add_func(self, t, parent_node, child_node)
	local target_unit = child_node:value("unit")
	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if target_buff_extension then
		local _, buff_id = target_buff_extension:add_externally_controlled_buff(CHAIN_LIGHTNING_BUFF, t, "owner_unit", self._layer_unit)

		child_node:set_value("buff_id", buff_id)
	end
end

function _on_delete_func(node, hit_units)
	local unit = node:value("unit")
	local buff_id = node:value("buff_id")
	hit_units[unit] = nil
	local target_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if buff_id and target_buff_extension then
		target_buff_extension:remove_externally_controlled_buff(buff_id)
		node:set_value("buff_id", nil)
	end
end

return ActionChainLightning
