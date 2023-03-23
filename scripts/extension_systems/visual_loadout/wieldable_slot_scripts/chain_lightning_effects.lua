local Action = require("scripts/utilities/weapon/action")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local ChainLightningEffects = class("ChainLightningEffects")
local Quaternion_look = Quaternion.look
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local buff_keywords = BuffSettings.keywords
local ATTACK_VFX = "content/fx/particles/abilities/protectorate_chainlightning_attacking_hands"
local TARGET_VFX_HIGH = "content/fx/particles/abilities/protectorate_chainlightning"
local TARGET_VFX_MID = "content/fx/particles/abilities/protectorate_chainlightning_02"
local TARGET_VFX_LOW = "content/fx/particles/abilities/protectorate_chainlightning_01"
local NO_TARGET_VFX = "content/fx/particles/weapons/force_staff/force_staff_chainlightning_notarget"
local TARGET_NODE = "enemy_aim_target_02"
local PARTICLE_VARIABLE_NAME = "length"
local DEFAULT_HAND = "both"
local MAX_FX_TABLES = 128
local _jump_validation_func, _on_add_func, _on_delete_func, _target_finding_func, _traverse_validation_func, _target_vfx_from_charge_level = nil

ChainLightningEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._world = context.world
	self._physics_world = context.physics_world
	self._physics_world = context.physics_world
	self._is_server = context.is_server
	self._is_husk = is_husk
	self._is_local_unit = context.is_local_unit
	self._owner_unit = owner_unit
	self._slot_name = slot.name
	self._weapon_actions = weapon_template.actions
	self._wwise_world = context.wwise_world
	self._first_person_unit = context.first_person_unit
	local charge_effects = weapon_template.charge_effects
	self._charge_effects = charge_effects
	local charge_source = charge_effects and charge_effects.sfx_source_name
	self._charge_fx_source_name = fx_sources[charge_source]
	local weapon_chain_settings = weapon_template.chain_settings
	local right_fx_source_name = weapon_chain_settings.right_fx_source_name
	self._right_fx_source_name = weapon_chain_settings.right_fx_source_name_is_base_unit and right_fx_source_name or fx_sources[right_fx_source_name]
	local left_fx_source_name = weapon_chain_settings.left_fx_source_name
	self._left_fx_source_name = weapon_chain_settings.left_fx_source_name_is_base_unit and left_fx_source_name or fx_sources[left_fx_source_name]
	self._is_in_first_person = nil
	self._target_1_right_particle_id = nil
	self._target_2_right_particle_id = nil
	self._target_3_right_particle_id = nil
	self._target_1_left_particle_id = nil
	self._target_2_left_particle_id = nil
	self._target_3_left_particle_id = nil
	self._right_hand_particle_id = nil
	self._left_hand_particle_id = nil
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._chain_targets = {}
	self._hit_units = {}
	self._next_jump_time = 0
	self._length_variable_index = World.find_particles_variable(self._world, TARGET_VFX_HIGH, PARTICLE_VARIABLE_NAME)
	self._fx_tables = Script.new_array(MAX_FX_TABLES)

	for ii = 1, MAX_FX_TABLES do
		self._fx_tables[ii] = {
			active = false,
			index = ii
		}
	end
end

ChainLightningEffects.destroy = function (self)
	self:_reset()
end

ChainLightningEffects.wield = function (self)
	self:_reset()
end

ChainLightningEffects.unwield = function (self)
	self:_reset()
end

ChainLightningEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ChainLightningEffects.update_unit_position = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_find_root_targets(t)
	self:_validate_targets(t)
	self:_find_new_targets(t)
	self:_update_fx(t)
	self:_update_sfx(t)
end

ChainLightningEffects._find_root_targets = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local chain_settings = action_settings and action_settings.chain_settings
	local fx_settings = action_settings and action_settings.fx
	local is_critical_strike = self._critical_strike_component.is_active
	local action_kind = action_settings and action_settings.kind
	local use_random = false
	local max_targets_settings = chain_settings and chain_settings.max_targets
	local max_targets = ChainLightning.calculate_max_targets(max_targets_settings, 1, false)
	local fx_hand = fx_settings and (is_critical_strike and fx_settings.fx_hand_critical_strike or fx_settings.fx_hand) or DEFAULT_HAND
	local use_charge = fx_settings and fx_settings.use_charge
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = use_charge and action_module_charge_component.charge_level or 1
	self._charge_level = charge_level
	local targeting = action_kind == "overload_charge_target_finder" or action_kind == "overload_target_finder"
	local attacking = action_kind == "chain_lightning"

	if attacking then
		local action_module_targeting_component = self._action_module_targeting_component
		local target_unit_1 = action_module_targeting_component.target_unit_1
		local target_unit_2 = action_module_targeting_component.target_unit_2
		local target_unit_3 = action_module_targeting_component.target_unit_3

		if target_unit_1 and not self._hit_units[target_unit_1] and max_targets >= 1 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_1)
			self._hit_units[target_unit_1] = true
		end

		if target_unit_2 and not self._hit_units[target_unit_2] and max_targets >= 2 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_2)
			self._hit_units[target_unit_2] = true
		end

		if target_unit_3 and not self._hit_units[target_unit_3] and max_targets >= 3 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets_settings, 1, use_random, nil, "unit", target_unit_3)
			self._hit_units[target_unit_3] = true
		end

		local spawner_unit_right, spawner_node_right = self._fx_extension:vfx_spawner_unit_and_node(self._right_fx_source_name)
		local spawner_unit_left, spawner_node_left = self._fx_extension:vfx_spawner_unit_and_node(self._left_fx_source_name)

		if fx_hand == "right" or fx_hand == "both" then
			self._target_1_right_particle_id = self:_update_vfx(t, self._world, self._target_1_right_particle_id, spawner_unit_right, spawner_node_right, max_targets >= 1 and action_module_targeting_component.target_unit_1)
			self._target_2_right_particle_id = self:_update_vfx(t, self._world, self._target_2_right_particle_id, spawner_unit_right, spawner_node_right, max_targets >= 2 and action_module_targeting_component.target_unit_2)
			self._target_3_right_particle_id = self:_update_vfx(t, self._world, self._target_3_right_particle_id, spawner_unit_right, spawner_node_right, max_targets >= 3 and action_module_targeting_component.target_unit_3)
			self._right_hand_particle_id = self:_update_hand_vfx(t, self._world, self._right_hand_particle_id, spawner_unit_right, spawner_node_right, true)
			local has_any_particle_effect = self._target_1_right_particle_id or self._target_2_right_particle_id or self._target_3_right_particle_id
			self._no_target_particle_right_id = self:_update_no_target_vfx(t, self._world, self._no_target_particle_right_id, has_any_particle_effect, spawner_unit_right, spawner_node_right)
		end

		if fx_hand == "left" or fx_hand == "both" then
			self._target_1_left_particle_id = self:_update_vfx(t, self._world, self._target_1_left_particle_id, spawner_unit_left, spawner_node_left, max_targets >= 1 and action_module_targeting_component.target_unit_1)
			self._target_2_left_particle_id = self:_update_vfx(t, self._world, self._target_2_left_particle_id, spawner_unit_left, spawner_node_left, max_targets >= 2 and action_module_targeting_component.target_unit_2)
			self._target_3_left_particle_id = self:_update_vfx(t, self._world, self._target_3_left_particle_id, spawner_unit_left, spawner_node_left, max_targets >= 3 and action_module_targeting_component.target_unit_3)
			self._left_hand_particle_id = self:_update_hand_vfx(t, self._world, self._left_hand_particle_id, spawner_unit_left, spawner_node_left, true)
			local has_any_particle_effect = self._target_1_left_particle_id or self._target_2_left_particle_id or self._target_3_left_particle_id
			self._no_target_particle_left_id = self:_update_no_target_vfx(t, self._world, self._no_target_particle_left_id, has_any_particle_effect, spawner_unit_left, spawner_node_left)
		end
	elseif targeting then
		local spawner_unit_right, spawner_node_right = self._fx_extension:vfx_spawner_unit_and_node(self._right_fx_source_name)
		local spawner_unit_left, spawner_node_left = self._fx_extension:vfx_spawner_unit_and_node(self._left_fx_source_name)

		if fx_hand == "right" or fx_hand == "both" then
			self._right_hand_particle_id = self:_update_hand_vfx(t, self._world, self._right_hand_particle_id, spawner_unit_right, spawner_node_right)
		end

		if fx_hand == "left" or fx_hand == "both" then
			self._left_hand_particle_id = self:_update_hand_vfx(t, self._world, self._left_hand_particle_id, spawner_unit_left, spawner_node_left)
		end

		self._target_1_right_particle_id = self:_stop_vfx(self._world, self._target_1_right_particle_id)
		self._target_2_right_particle_id = self:_stop_vfx(self._world, self._target_2_right_particle_id)
		self._target_3_right_particle_id = self:_stop_vfx(self._world, self._target_3_right_particle_id)
		self._target_1_left_particle_id = self:_stop_vfx(self._world, self._target_1_left_particle_id)
		self._target_2_left_particle_id = self:_stop_vfx(self._world, self._target_2_left_particle_id)
		self._target_3_left_particle_id = self:_stop_vfx(self._world, self._target_3_left_particle_id)
		self._no_target_particle_right_id = self:_stop_vfx(self._world, self._no_target_particle_right_id)
		self._no_target_particle_left_id = self:_stop_vfx(self._world, self._no_target_particle_left_id)
	else
		local chain_targets = self._chain_targets

		for ii = 1, #chain_targets do
			ChainLightningTarget.remove_all_child_nodes(chain_targets[ii], _on_delete_func, self)
		end

		self._target_1_right_particle_id = self:_stop_vfx(self._world, self._target_1_right_particle_id)
		self._target_2_right_particle_id = self:_stop_vfx(self._world, self._target_2_right_particle_id)
		self._target_3_right_particle_id = self:_stop_vfx(self._world, self._target_3_right_particle_id)
		self._target_1_left_particle_id = self:_stop_vfx(self._world, self._target_1_left_particle_id)
		self._target_2_left_particle_id = self:_stop_vfx(self._world, self._target_2_left_particle_id)
		self._target_3_left_particle_id = self:_stop_vfx(self._world, self._target_3_left_particle_id)
		self._no_target_particle_right_id = self:_stop_vfx(self._world, self._no_target_particle_right_id)
		self._no_target_particle_left_id = self:_stop_vfx(self._world, self._no_target_particle_left_id)
		self._right_hand_particle_id = self:_stop_vfx(self._world, self._right_hand_particle_id)
		self._left_hand_particle_id = self:_stop_vfx(self._world, self._left_hand_particle_id)

		table.clear(self._chain_targets)
		table.clear(self._hit_units)

		self._charge_level = nil
	end
end

local valid_sources = {}

ChainLightningEffects._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, close_max_angle, max_z_diff, max_jumps, radius, root_target, initial_travel_direction)
	local hit_units = self._hit_units

	table.clear(valid_sources)
	ChainLightningTarget.traverse_breadth_first(root_target, valid_sources, _target_finding_func, max_jumps)

	for ii = 1, #valid_sources do
		local source = valid_sources[ii]

		ChainLightning.jump(self, t, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, max_z_diff, _on_add_func, _jump_validation_func)
	end
end

local validation_targets = {}
local deletion_targets = {}

ChainLightningEffects._validate_targets = function (self, t)
	table.clear(validation_targets)

	local chain_targets = self._chain_targets
	local num_chain_targets = #chain_targets

	for ii = num_chain_targets, 1, -1 do
		local target = chain_targets[ii]
		local target_unit = target:value("unit")
		local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
		local valid_target = buff_extension and buff_extension:has_keyword(buff_keywords.electrocuted)

		if not valid_target or not HEALTH_ALIVE[target_unit] then
			table.clear(deletion_targets)
			ChainLightningTarget.traverse_depth_first(chain_targets[ii], deletion_targets)

			for jj = 1, #deletion_targets do
				local child_target = deletion_targets[jj]

				_on_delete_func(child_target, self)
			end

			table.swap_delete(chain_targets, ii)

			self._hit_units[target_unit] = nil
		end
	end

	table.clear(validation_targets)

	for ii = 1, #chain_targets do
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], validation_targets, _traverse_validation_func)
	end

	local num_validation_targets = #validation_targets

	for ii = num_validation_targets, 1, -1 do
		local target = validation_targets[ii]

		target:mark_for_deletion()
	end

	for ii = 1, #chain_targets do
		ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_targets[ii], _on_delete_func, self)
	end
end

ChainLightningEffects._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	local owner_unit = self._owner_unit
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[owner_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local stat_buffs = self._buff_extension:stat_buffs()
	local chain_settings = action_settings and action_settings.chain_settings
	local max_angle, close_max_angle, max_z_diff, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(chain_settings, stat_buffs)

	for ii = 1, #self._chain_targets do
		local attack_direction = Vector3_normalize(Vector3_flat(POSITION_LOOKUP[owner_unit] - POSITION_LOOKUP[self._chain_targets[ii]:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, close_max_angle, max_z_diff, max_jumps, radius, self._chain_targets[ii], attack_direction)
	end

	self._next_jump_time = t + jump_time
end

local effect_targets = {}

ChainLightningEffects._update_fx = function (self)
	local world = self._world

	table.clear(effect_targets)

	for ii = 1, #self._chain_targets do
		ChainLightningTarget.traverse_breadth_first(self._chain_targets[ii], effect_targets)
	end

	for ii = 1, #effect_targets do
		local target = effect_targets[ii]
		local data = target:value("parent_effect_data")

		if data then
			local source_pos = Unit_world_position(data.source_unit, data.source_node_index)
			local target_pos = Unit_world_position(data.target_unit, data.target_node_index)
			local line = target_pos - source_pos
			local direction, length = Vector3_direction_length(line)
			local rotation = Quaternion_look(direction)
			local particle_length = Vector3(length, 1, 1)

			World.move_particles(world, data.effect_id, source_pos, rotation)
			World.set_particles_variable(world, data.effect_id, self._length_variable_index, particle_length)
		end
	end
end

ChainLightningEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode
end

ChainLightningEffects._update_vfx = function (self, t, world, current_particle_id, node_unit, node, target_unit)
	if target_unit then
		local from_pos = Unit_world_position(node_unit, node)
		local target_pos = Unit_world_position(target_unit, Unit_node(target_unit, TARGET_NODE))
		local line = target_pos - from_pos
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)

		if current_particle_id then
			World.move_particles(world, current_particle_id, from_pos, rotation)
			World.set_particles_variable(world, current_particle_id, self._length_variable_index, particle_length)

			return current_particle_id
		else
			local target_vfx = _target_vfx_from_charge_level(self._charge_level)
			local effect_id = World.create_particles(world, target_vfx, Vector3.zero())

			World.set_particles_variable(world, effect_id, self._length_variable_index, particle_length)

			return effect_id
		end
	elseif current_particle_id then
		World.stop_spawning_particles(world, current_particle_id)

		return nil
	end
end

ChainLightningEffects._update_no_target_vfx = function (self, t, world, current_particle_id, has_any_particle_effect, node_unit, node)
	if not has_any_particle_effect then
		if current_particle_id then
			local from_pos = Unit_world_position(node_unit, node)
			local first_person_unit = self._first_person_unit
			local rotation = Unit.world_rotation(first_person_unit, 1)

			World.move_particles(world, current_particle_id, from_pos, rotation)
			World.set_particles_variable(world, current_particle_id, self._length_variable_index, Vector3(0.2, 1, 1))

			return current_particle_id
		else
			local effect_id = World.create_particles(world, NO_TARGET_VFX, Vector3.zero())

			World.link_particles(world, effect_id, node_unit, node, Matrix4x4.identity(), "destroy")

			local in_first_person = self._is_in_first_person

			if in_first_person then
				World.set_particles_use_custom_fov(world, effect_id, true)
			end

			return effect_id
		end
	elseif current_particle_id then
		World.stop_spawning_particles(world, current_particle_id)

		return nil
	end
end

ChainLightningEffects._update_hand_vfx = function (self, t, world, current_particle_id, node_unit, node, charge_level)
	if current_particle_id then
		return current_particle_id
	else
		local effect_id = World.create_particles(world, ATTACK_VFX, Vector3.zero())

		World.link_particles(world, effect_id, node_unit, node, Matrix4x4.identity(), "destroy")

		local in_first_person = self._is_in_first_person

		if in_first_person then
			World.set_particles_use_custom_fov(world, effect_id, true)
		end

		return effect_id
	end
end

ChainLightningEffects._stop_vfx = function (self, world, particle_id)
	if particle_id then
		World.destroy_particles(world, particle_id)
	end

	return nil
end

ChainLightningEffects._reset = function (self)
	self._next_jump_time = 0
	self._target_1_right_particle_id = self:_stop_vfx(self._world, self._target_1_right_particle_id)
	self._target_2_right_particle_id = self:_stop_vfx(self._world, self._target_2_right_particle_id)
	self._target_3_right_particle_id = self:_stop_vfx(self._world, self._target_3_right_particle_id)
	self._target_1_left_particle_id = self:_stop_vfx(self._world, self._target_1_left_particle_id)
	self._target_2_left_particle_id = self:_stop_vfx(self._world, self._target_2_left_particle_id)
	self._target_3_left_particle_id = self:_stop_vfx(self._world, self._target_3_left_particle_id)
	self._right_hand_particle_id = self:_stop_vfx(self._world, self._right_hand_particle_id)
	self._left_hand_particle_id = self:_stop_vfx(self._world, self._left_hand_particle_id)
	self._no_target_particle_right_id = self:_stop_vfx(self._world, self._no_target_particle_right_id)
	self._no_target_particle_left_id = self:_stop_vfx(self._world, self._no_target_particle_left_id)
	local chain_targets = self._chain_targets

	for ii = 1, #chain_targets do
		ChainLightningTarget.remove_all_child_nodes(chain_targets[ii], _on_delete_func, self)
	end

	table.clear(self._chain_targets)
	table.clear(self._hit_units)
end

ChainLightningEffects._next_free_fx_table = function (self)
	local fx_tables = self._fx_tables

	for ii = 1, MAX_FX_TABLES do
		local fx_table = fx_tables[ii]

		if not fx_table.active then
			fx_table.active = true

			return fx_table
		end
	end
end

ChainLightningEffects._return_fx_table = function (self, fx_table)
	self._fx_tables[fx_table.index].active = false
end

ChainLightningEffects._update_sfx = function (self)
	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level
	local charge_effects = self._charge_effects
	local charge_sfx_parameter = charge_effects and charge_effects.sfx_parameter

	if charge_sfx_parameter == nil then
		return
	end

	local charge_fx_source_name = self._charge_fx_source_name
	local wwise_world = self._wwise_world
	local source = self._fx_extension:sound_source(charge_fx_source_name)
	local parameter = charge_sfx_parameter
	local parameter_value = charge_level

	WwiseWorld.set_source_parameter(wwise_world, source, parameter, parameter_value)
end

function _target_finding_func(node, max_jumps)
	return not node:is_full() and node:depth() <= max_jumps
end

function _jump_validation_func(target_unit)
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
	local valid_target = buff_extension and buff_extension:has_keyword(buff_keywords.electrocuted)

	return valid_target
end

function _traverse_validation_func(node)
	local target_unit = node:value("unit")
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
	local valid_target = buff_extension and buff_extension:has_keyword(buff_keywords.electrocuted)

	return not valid_target or not HEALTH_ALIVE[target_unit]
end

function _on_add_func(self, t, parent_node, child_node)
	local parent_unit = parent_node:value("unit")
	local child_unit = child_node:value("unit")

	if not child_node:value("parent_effect_data") then
		local world = self._world
		local source_node_index = Unit_node(parent_unit, TARGET_NODE)
		local target_node_index = Unit_node(child_unit, TARGET_NODE)
		local source_pos = Unit_world_position(parent_unit, source_node_index)
		local target_pos = Unit_world_position(child_unit, target_node_index)
		local line = target_pos - source_pos
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)
		local target_vfx = _target_vfx_from_charge_level(self._charge_level)
		local effect_id = World.create_particles(world, target_vfx, source_pos, rotation)

		World.set_particles_variable(world, effect_id, self._length_variable_index, particle_length)

		local data = self:_next_free_fx_table()
		data.source_unit = parent_unit
		data.target_unit = child_unit
		data.source_node_index = source_node_index
		data.target_node_index = target_node_index
		data.effect_id = effect_id

		child_node:set_value("parent_effect_data", data)
	end
end

function _on_delete_func(node, self)
	local data = node:value("parent_effect_data")

	if data and data.active then
		self:_return_fx_table(data)
		World.stop_spawning_particles(self._world, data.effect_id)
		node:set_value("parent_effect_data", nil)
	end

	local unit = node:value("unit")
	self._hit_units[unit] = nil
end

function _target_vfx_from_charge_level(charge_level)
	if not charge_level then
		return TARGET_VFX_HIGH
	end

	if charge_level > 0.86 then
		return TARGET_VFX_HIGH
	elseif charge_level > 0.33 then
		return TARGET_VFX_MID
	else
		return TARGET_VFX_LOW
	end
end

return ChainLightningEffects
