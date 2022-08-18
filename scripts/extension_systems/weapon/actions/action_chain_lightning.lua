require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local ActionChainLightning = class("ActionChainLightning", "ActionWeaponBase")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = 500
local BROADPHASE_RESULTS = {}
local DEFAULT_MAX_TARGETS = 1
local DEFAULT_MAX_ANGLE = math.pi * 0.25
local DEFAULT_MAX_JUMPS = 3
local DEFAULT_RADIUS = 4
local DEFAULT_JUMP_TIME = 0.15
local _damage_finding_func, _target_finding_func, _validation_func, _on_add_func, _on_delete_func = nil

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
	local overload_module_class_name = action_settings.overload_module_class_name
	self._overload_module = ActionModules[overload_module_class_name]:new(player_unit, action_settings, self._inventory_slot_component)
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

	local weapon = action_params.weapon
	self._left_fx_source_name = weapon.fx_sources._left
	self._right_fx_source_name = weapon.fx_sources._right
	self._both_fx_source_name = weapon.fx_sources._both
end

ActionChainLightning.start = function (self, action_settings, t, ...)
	ActionChainLightning.super.start(self, action_settings, t, ...)

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template
	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or weapon_template.charge_template or "none"
	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()
	param_table.unit = self._player_unit

	buff_extension:add_proc_event(proc_events.on_chain_lightning_start, param_table)

	self._action_module_charge_component.max_charge = 1
	local charge_template = self._weapon_extension:charge_template()

	if charge_template and charge_template.charge_on_action_start then
		self._charge_module:start(t)
	end

	self._overload_module:start(t)
	table.clear(self._chain_targets)
	table.clear(self._hit_units)

	local stat_buffs = self._buff_extension:stat_buffs()
	self._stat_buff_max_jumps = stat_buffs.chain_lightning_max_jumps
	self._stat_buff_max_radius = stat_buffs.chain_lightning_max_radius
	self._stat_buff_max_angle = stat_buffs.chain_lightning_max_angle
	local player_unit = self._player_unit
	local chain_settings = action_settings.chain_settings
	local max_targets = chain_settings.max_targets or DEFAULT_MAX_TARGETS
	local target_unit_1 = self._targeting_component.target_unit_1
	local target_unit_2 = self._targeting_component.target_unit_2
	local target_unit_3 = self._targeting_component.target_unit_3

	if target_unit_1 and max_targets >= 1 then
		local _, buff_id = nil
		local target_buff_extension = ScriptUnit.has_extension(target_unit_1, "buff_system")

		if target_buff_extension then
			_, buff_id = target_buff_extension:add_externally_controlled_buff("chain_lightning_interval", t, "owner_unit", player_unit)
		end

		local target = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_1, "buff_id", buff_id)
		self._chain_targets[#self._chain_targets + 1] = target
		self._hit_units[target_unit_1] = true
	end

	if target_unit_2 and max_targets >= 2 then
		local _, buff_id = nil
		local target_buff_extension = ScriptUnit.has_extension(target_unit_2, "buff_system")

		if target_buff_extension then
			_, buff_id = target_buff_extension:add_externally_controlled_buff("chain_lightning_interval", t, "owner_unit", player_unit)
		end

		local target = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_2, "buff_id", buff_id)
		self._chain_targets[#self._chain_targets + 1] = target
		self._hit_units[target_unit_2] = true
	end

	if target_unit_3 and max_targets >= 3 then
		local _, buff_id = nil
		local target_buff_extension = ScriptUnit.has_extension(target_unit_3, "buff_system")

		if target_buff_extension then
			_, buff_id = target_buff_extension:add_externally_controlled_buff("chain_lightning_interval", t, "owner_unit", player_unit)
		end

		local target = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_3, "buff_id", buff_id)
		self._chain_targets[#self._chain_targets + 1] = target
		self._hit_units[target_unit_3] = true
	end

	self._next_jump_time = 0

	self:_play_shoot_sound()
end

ActionChainLightning._play_shoot_sound = function (self)
	local fx_settings = self._action_settings.fx
	local looping_shoot_sfx_alias = fx_settings.looping_shoot_sfx_alias
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
	Profiler.start("ActionChainLightning:fixed_update()")
	self._targeting_module:fixed_update(dt, t)
	self._charge_module:fixed_update(dt, t)
	self._overload_module:fixed_update(dt, t)
	self:_validate_targets(t)

	local shoot_at_time = self._action_settings.shoot_at_time

	if shoot_at_time and shoot_at_time < time_in_action then
		self:_find_new_targets(t)
	end

	Profiler.stop("ActionChainLightning:fixed_update()")
end

ActionChainLightning._decay_charge = function (self, t, time_in_action)
	local action_component = self._component
	local charge_template = self._weapon_extension:charge_template()
	local charge_duration = charge_template.charge_duration
	local min_charge = charge_template.min_charge or 0
	local charge_complete_time = action_component.charge_complete_time
	local max_charge = action_component.max_charge
	local time_charged = charge_duration - math.max(0, charge_complete_time - t)
	local charge_level = math.min(math.clamp(min_charge + ((1 - min_charge) * time_charged) / charge_duration, min_charge, 1), max_charge)
	action_component.charge_level = charge_level
end

ActionChainLightning._validate_targets = function (self, t)
	Profiler.start("_validate_targets")

	local temp_targets = self._temp_targets
	local chain_targets = self._chain_targets
	local hit_units = self._hit_units

	for ii = #chain_targets, 1, -1 do
		local target = chain_targets[ii]
		local target_unit = target:value("unit")

		if not HEALTH_ALIVE[target_unit] then
			table.swap_delete(chain_targets, ii)

			hit_units[target_unit] = nil
		end
	end

	table.clear(temp_targets)

	for ii = 1, #chain_targets, 1 do
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], temp_targets, _validation_func)
	end

	local num_targets = #temp_targets

	for ii = num_targets, 1, -1 do
		local target = temp_targets[ii]

		target:mark_for_deletion()
	end

	for ii = 1, #chain_targets, 1 do
		ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_targets[ii], _on_delete_func, hit_units)
	end

	Profiler.stop("_validate_targets")
end

ActionChainLightning._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	Profiler.start("_find_new_targets")

	local action_settings = self._action_settings
	local player_unit = self._player_unit
	local chain_targets = self._chain_targets
	local player_position = POSITION_LOOKUP[player_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local chain_settings = action_settings.chain_settings
	local max_angle = chain_settings.max_angle or DEFAULT_MAX_ANGLE + self._stat_buff_max_angle
	local max_jumps = (chain_settings.max_jumps or DEFAULT_MAX_JUMPS) + self._stat_buff_max_jumps
	local radius = chain_settings.radius or DEFAULT_RADIUS + self._stat_buff_max_radius
	local jump_time = chain_settings.jump_time or DEFAULT_JUMP_TIME

	for ii = 1, #chain_targets, 1 do
		local target = chain_targets[ii]
		local travel_direction = Vector3.normalize(Vector3.flat(player_position - POSITION_LOOKUP[target:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, max_jumps, radius, target, travel_direction)
	end

	self._next_jump_time = t + jump_time

	Profiler.stop("_find_new_targets")
end

local function _jump(t, is_server, source_target, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, player_unit)
	Profiler.start("_jump")

	local source_unit = source_target:value("unit")
	local query_position = POSITION_LOOKUP[source_unit]
	local depth = source_target:depth()
	local travel_direction = nil

	if depth == 1 then
		travel_direction = initial_travel_direction
	else
		local parent_target = source_target:parent()
		local previous_unit = parent_target:value("unit")
		travel_direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[previous_unit] - POSITION_LOOKUP[source_unit]))
	end

	table.clear(BROADPHASE_RESULTS)

	local num_results = broadphase:query(query_position, radius, BROADPHASE_RESULTS, enemy_side_names)

	if num_results > 0 then
		for i = 1, num_results, 1 do
			local target_unit = BROADPHASE_RESULTS[i]

			if target_unit and not hit_units[target_unit] then
				local target_position = POSITION_LOOKUP[target_unit]
				local inside_each_other = Vector3.length_squared(query_position, target_position) < 0.001

				if not inside_each_other then
					local direction = Vector3.normalize(Vector3.flat(query_position - target_position))
					local angle = Vector3.angle(travel_direction, direction)

					if angle <= max_angle then
						local node = source_target:add_child("unit", target_unit)

						_on_add_func(node, t, player_unit)

						hit_units[target_unit] = true

						if source_target:is_full() then
							Profiler.stop("_jump")

							return
						end
					end
				end
			end
		end
	end

	Profiler.stop("_jump")
end

ActionChainLightning._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, max_jumps, radius, root_target, initial_travel_direction)
	Profiler.start("_find_new_chain_targets")

	local temp_targets = self._temp_targets
	local hit_units = self._hit_units

	table.clear(temp_targets)
	ChainLightningTarget.traverse_breadth_first(root_target, temp_targets, _target_finding_func, max_jumps)

	for ii = 1, #temp_targets, 1 do
		local source = temp_targets[ii]

		_jump(t, self._is_server, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, self._player_unit)
	end

	Profiler.stop("_find_new_chain_targets")
end

ActionChainLightning._deal_damage = function (self, t, time_in_action)
	local action_settings = self._action_settings

	if not action_settings then
		return
	end

	local damage_profile = action_settings.damage_profile
	local damage_type = action_settings.damage_type
	local player_unit = self._player_unit
	local temp_targets = self._temp_targets
	local charge_level = self._action_module_charge_component.charge_level

	table.clear(temp_targets)

	local chain_targets = self._chain_targets

	for ii = 1, #chain_targets, 1 do
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], temp_targets, _damage_finding_func, player_unit)
	end

	for ii = 1, #temp_targets, 1 do
		local target = temp_targets[ii]
		local unit = target:value("unit")
		local hit_zone_name = "torso"
		local hit_zone_actors = HitZone.get_actor_names(unit, hit_zone_name)
		local hit_actor_name = hit_zone_actors[1]
		local hit_actor = Unit.actor(unit, hit_actor_name)
		local node_index = Actor.node(hit_actor)
		local hit_world_position = Unit.world_position(unit, node_index)
		slot22, slot23, slot24 = Attack.execute(unit, damage_profile, "power_level", DEFAULT_POWER_LEVEL * charge_level, "target_index", 1, "hit_world_position", hit_world_position, "hit_zone_name", hit_zone_name, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", attack_types.ranged, "damage_type", damage_type)
	end
end

ActionChainLightning.finish = function (self, reason, data, t, time_in_action)
	self._fx_extension:stop_looping_wwise_event(self._action_settings.fx.looping_shoot_sfx_alias)

	if self._is_server then
		self:_deal_damage(t, time_in_action)

		local chain_targets = self._chain_targets

		for ii = 1, #chain_targets, 1 do
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
	param_table.unit = self._player_unit

	buff_extension:add_proc_event(proc_events.on_chain_lightning_finished, param_table)
	ActionChainLightning.super.finish(self, reason, data, t, time_in_action)
	self._targeting_module:finish(reason, data, t)
	self._charge_module:finish(reason, data, t, true)
	self._overload_module:finish(reason, data, t)
end

ActionChainLightning.running_action_state = function (self, t, time_in_action)
	local stop_time = self._action_settings.stop_time

	if stop_time and stop_time <= time_in_action then
		return "stop_time_reached"
	end
end

function _damage_finding_func(node, player_unit)
	local target_unit = node:value("unit")

	return target_unit ~= player_unit and HEALTH_ALIVE[target_unit]
end

function _target_finding_func(node, max_jumps)
	return not node:is_full() and node:depth() <= max_jumps + 1 and HEALTH_ALIVE[node:value("unit")]
end

function _validation_func(node)
	local target_unit = node:value("unit")

	return not HEALTH_ALIVE[target_unit]
end

function _on_add_func(node, t, player_unit)
	local target_unit = node:value("unit")
	local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if target_buff_extension then
		local _, buff_id = target_buff_extension:add_externally_controlled_buff("chain_lightning_interval", t, "owner_unit", player_unit)

		node:set_value("buff_id", buff_id)
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
