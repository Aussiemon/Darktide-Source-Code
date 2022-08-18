local Action = require("scripts/utilities/weapon/action")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local ChainLightningEffects = class("ChainLightningEffects")
local buff_keywords = BuffSettings.keywords
local ATTACK_VFX = "content/fx/particles/abilities/protectorate_chainlightning_attacking_hands"
local TARGET_VFX = "content/fx/particles/abilities/protectorate_chainlightning"
local FX_SOURCE_NAME_RIGHT = "_right"
local FX_SOURCE_NAME_LEFT = "_left"
local TARGET_NODE = "enemy_aim_target_02"
local PARTICLE_VARIABLE_NAME = "length"
local DEFAULT_HAND = "both"
local MAX_FX_TABLES = 128
local BROADPHASE_RESULTS = {}
local DEFAULT_MAX_TARGETS = 1
local DEFAULT_MAX_ANGLE = math.pi * 0.25
local DEFAULT_MAX_JUMPS = 3
local DEFAULT_RADIUS = 4
local DEFAULT_JUMP_TIME = 0.1
local _target_finding_func, _validation_func, _on_add_func, _on_delete_func = nil

ChainLightningEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit
	self._world = context.world
	self._is_husk = is_husk
	self._owner_unit = owner_unit
	self._slot_name = slot.name
	self._weapon_actions = weapon_template.actions
	self._wwise_world = context.wwise_world
	self._is_local_unit = context.is_local_unit
	self._right_fx_source_name = fx_sources[FX_SOURCE_NAME_RIGHT]
	self._left_fx_source_name = fx_sources[FX_SOURCE_NAME_LEFT]
	self._target_1_right_particle_id = nil
	self._target_2_right_particle_id = nil
	self._target_3_right_particle_id = nil
	self._target_1_left_particle_id = nil
	self._target_2_left_particle_id = nil
	self._target_3_left_particle_id = nil
	self._right_hand_particle_id = nil
	self._left_hand_particle_id = nil
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._chain_targets = {}
	self._hit_units = {}
	self._next_jump_time = 0
	self._length_variable_index = World.find_particles_variable(self._world, TARGET_VFX, PARTICLE_VARIABLE_NAME)
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

ChainLightningEffects.update = function (self, unit, dt, t)
	self:_find_root_targets(t)
	self:_validate_targets(t)
	self:_find_new_targets(t)
	self:_update_fx()
end

ChainLightningEffects._find_root_targets = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local chain_settings = action_settings and action_settings.chain_settings
	local fx_settings = action_settings and action_settings.fx
	local action_kind = action_settings and action_settings.kind
	local max_targets = chain_settings and chain_settings.max_targets or DEFAULT_MAX_TARGETS
	local fx_hand = fx_settings and fx_settings.fx_hand or DEFAULT_HAND
	local targeting = action_kind == "overload_charge_target_finder"
	local attacking = action_kind == "chain_lightning"

	if attacking then
		local action_module_targeting_component = self._action_module_targeting_component
		local target_unit_1 = action_module_targeting_component.target_unit_1
		local target_unit_2 = action_module_targeting_component.target_unit_2
		local target_unit_3 = action_module_targeting_component.target_unit_3

		if target_unit_1 and not self._hit_units[target_unit_1] and max_targets >= 1 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_1)
			self._hit_units[target_unit_1] = true
		end

		if target_unit_2 and not self._hit_units[target_unit_2] and max_targets >= 2 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_2)
			self._hit_units[target_unit_2] = true
		end

		if target_unit_3 and not self._hit_units[target_unit_3] and max_targets >= 3 then
			self._chain_targets[#self._chain_targets + 1] = ChainLightningTarget:new(max_targets, 1, nil, "unit", target_unit_3)
			self._hit_units[target_unit_3] = true
		end

		local spawner_pose_right = self._fx_extension:vfx_spawner_pose(self._right_fx_source_name)
		local from_pos_right = Matrix4x4.translation(spawner_pose_right)
		local spawner_pose_left = self._fx_extension:vfx_spawner_pose(self._left_fx_source_name)
		local from_pos_left = Matrix4x4.translation(spawner_pose_left)

		if fx_hand == "right" or fx_hand == "both" then
			self._target_1_right_particle_id = self:_update_vfx(t, self._world, self._target_1_right_particle_id, from_pos_right, max_targets >= 1 and action_module_targeting_component.target_unit_1)
			self._target_2_right_particle_id = self:_update_vfx(t, self._world, self._target_2_right_particle_id, from_pos_right, max_targets >= 2 and action_module_targeting_component.target_unit_2)
			self._target_3_right_particle_id = self:_update_vfx(t, self._world, self._target_3_right_particle_id, from_pos_right, max_targets >= 3 and action_module_targeting_component.target_unit_3)
			self._right_hand_particle_id = self:_update_hand_vfx(t, self._world, self._right_hand_particle_id, from_pos_right)
		end

		if fx_hand == "left" or fx_hand == "both" then
			self._target_1_left_particle_id = self:_update_vfx(t, self._world, self._target_1_left_particle_id, from_pos_left, max_targets >= 1 and action_module_targeting_component.target_unit_1)
			self._target_2_left_particle_id = self:_update_vfx(t, self._world, self._target_2_left_particle_id, from_pos_left, max_targets >= 2 and action_module_targeting_component.target_unit_2)
			self._target_3_left_particle_id = self:_update_vfx(t, self._world, self._target_3_left_particle_id, from_pos_left, max_targets >= 3 and action_module_targeting_component.target_unit_3)
			self._left_hand_particle_id = self:_update_hand_vfx(t, self._world, self._left_hand_particle_id, from_pos_left)
		end
	elseif targeting then
		local spawner_pose_right = self._fx_extension:vfx_spawner_pose(self._right_fx_source_name)
		local from_pos_right = Matrix4x4.translation(spawner_pose_right)
		local spawner_pose_left = self._fx_extension:vfx_spawner_pose(self._left_fx_source_name)
		local from_pos_left = Matrix4x4.translation(spawner_pose_left)

		if fx_hand == "right" or fx_hand == "both" then
			self._right_hand_particle_id = self:_update_hand_vfx(t, self._world, self._right_hand_particle_id, from_pos_right)
		end

		if fx_hand == "left" or fx_hand == "both" then
			self._left_hand_particle_id = self:_update_hand_vfx(t, self._world, self._left_hand_particle_id, from_pos_left)
		end
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
		self._right_hand_particle_id = self:_stop_vfx(self._world, self._right_hand_particle_id)
		self._left_hand_particle_id = self:_stop_vfx(self._world, self._left_hand_particle_id)

		table.clear(self._chain_targets)
		table.clear(self._hit_units)
	end
end

local valid_sources = {}

ChainLightningEffects._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, max_jumps, radius, root_target, initial_attack_direction)
	Profiler.start("_find_new_chain_targets")

	local hit_units = self._hit_units

	table.clear(valid_sources)
	ChainLightningTarget.traverse_breadth_first(root_target, valid_sources, _target_finding_func, max_jumps)

	for ii = 1, #valid_sources do
		local source = valid_sources[ii]

		self:_jump(t, source, hit_units, broadphase, enemy_side_names, initial_attack_direction, radius, max_angle)
	end

	Profiler.stop("_find_new_chain_targets")
end

ChainLightningEffects._jump = function (self, t, source_target, hit_units, broadphase, enemy_side_names, initial_attack_direction, radius, max_angle)
	Profiler.start("_jump")

	local source_unit = source_target:value("unit")
	local query_position = POSITION_LOOKUP[source_unit]
	local depth = source_target:depth()
	local attack_direction = nil

	if depth == 1 then
		attack_direction = initial_attack_direction
	else
		local parent_target = source_target:parent()
		local previous_unit = parent_target:value("unit")
		attack_direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[previous_unit] - POSITION_LOOKUP[source_unit]))
	end

	table.clear(BROADPHASE_RESULTS)

	local num_results = broadphase:query(query_position, radius, BROADPHASE_RESULTS, enemy_side_names)

	if num_results > 0 then
		for i = 1, num_results do
			local target_unit = BROADPHASE_RESULTS[i]

			if target_unit and not hit_units[target_unit] then
				local direction = Vector3.normalize(Vector3.flat(query_position - POSITION_LOOKUP[target_unit]))
				local angle = Vector3.angle(attack_direction, direction)
				local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
				local valid_target = buff_extension and buff_extension:has_keyword(buff_keywords.electrocuted)

				if angle <= max_angle and valid_target then
					local child_node = source_target:add_child("unit", target_unit)

					_on_add_func(source_target, child_node, self)

					hit_units[target_unit] = true

					if source_target:is_full() then
						Profiler.stop("_jump")

						return
					end
				end
			end
		end
	end

	Profiler.stop("_jump")
end

local validation_targets = {}
local deletion_targets = {}

ChainLightningEffects._validate_targets = function (self, t)
	Profiler.start("_validate_targets")
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
		ChainLightningTarget.traverse_depth_first(chain_targets[ii], validation_targets, _validation_func)
	end

	local num_validation_targets = #validation_targets

	for ii = num_validation_targets, 1, -1 do
		local target = validation_targets[ii]

		target:mark_for_deletion()
	end

	for ii = 1, #chain_targets do
		ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_targets[ii], _on_delete_func, self)
	end

	Profiler.stop("_validate_targets")
end

ChainLightningEffects._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	Profiler.start("_find_new_targets")

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[self._owner_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local chain_settings = action_settings and action_settings.chain_settings
	local max_angle = chain_settings and chain_settings.max_angle or DEFAULT_MAX_ANGLE
	local max_jumps = chain_settings and chain_settings.max_jumps or DEFAULT_MAX_JUMPS
	local radius = chain_settings and chain_settings.radius or DEFAULT_RADIUS
	local jump_time = chain_settings and chain_settings.jump_time or DEFAULT_JUMP_TIME

	for ii = 1, #self._chain_targets do
		local attack_direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[self._owner_unit] - POSITION_LOOKUP[self._chain_targets[ii]:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, max_jumps, radius, self._chain_targets[ii], attack_direction)
	end

	self._next_jump_time = t + jump_time

	Profiler.stop("_find_new_targets")
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
			local source_pos = Unit.world_position(data.source_unit, data.source_node_index)
			local target_pos = Unit.world_position(data.target_unit, data.target_node_index)
			local line = target_pos - source_pos
			local direction = Vector3.normalize(line)
			local rotation = Quaternion.look(direction)
			local length = Vector3(Vector3.length(line), 1, 1)

			World.move_particles(world, data.effect_id, source_pos, rotation)
			World.set_particles_variable(world, data.effect_id, self._length_variable_index, length)
		end
	end
end

ChainLightningEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ChainLightningEffects._update_vfx = function (self, t, world, current_particle_id, from_pos, target_unit)
	if target_unit then
		if current_particle_id then
			local target_pos = Unit.world_position(target_unit, Unit.node(target_unit, TARGET_NODE))
			local line = target_pos - from_pos
			local direction = Vector3.normalize(line)
			local rotation = Quaternion.look(direction)
			local length = Vector3(Vector3.length(line), 1, 1)

			World.move_particles(world, current_particle_id, from_pos, rotation)
			World.set_particles_variable(world, current_particle_id, World.find_particles_variable(world, TARGET_VFX, PARTICLE_VARIABLE_NAME), length)

			return current_particle_id
		else
			local target_pos = Unit.world_position(target_unit, Unit.node(target_unit, TARGET_NODE))
			local line = target_pos - from_pos
			local direction = Vector3.normalize(line)
			local rotation = Quaternion.look(direction)
			local length = Vector3(Vector3.length(line), 1, 1)
			local effect_id = World.create_particles(world, TARGET_VFX, from_pos, rotation)

			World.set_particles_variable(world, effect_id, World.find_particles_variable(world, TARGET_VFX, PARTICLE_VARIABLE_NAME), length)

			return effect_id
		end
	elseif current_particle_id then
		World.stop_spawning_particles(world, current_particle_id)

		return nil
	end
end

ChainLightningEffects._update_hand_vfx = function (self, t, world, current_particle_id, from_pos)
	if current_particle_id then
		World.move_particles(world, current_particle_id, from_pos)

		return current_particle_id
	else
		local effect_id = World.create_particles(world, ATTACK_VFX, from_pos)

		return effect_id
	end
end

ChainLightningEffects._stop_vfx = function (self, world, particle_id)
	if particle_id then
		World.stop_spawning_particles(world, particle_id)
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

function _target_finding_func(node, max_jumps)
	return not node:is_full() and node:depth() <= max_jumps + 1
end

function _validation_func(node)
	local target_unit = node:value("unit")
	local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")
	local valid_target = buff_extension and buff_extension:has_keyword(buff_keywords.electrocuted)

	return not valid_target or not HEALTH_ALIVE[target_unit]
end

function _on_add_func(parent_node, child_node, self)
	local parent_unit = parent_node:value("unit")
	local child_unit = child_node:value("unit")

	if not child_node:value("parent_effect_data") then
		local world = self._world
		local target_node_index = Unit.node(parent_unit, TARGET_NODE)
		local source_node_index = Unit.node(child_unit, TARGET_NODE)
		local source_pos = Unit.world_position(parent_unit, source_node_index)
		local target_pos = Unit.world_position(child_unit, target_node_index)
		local line = target_pos - source_pos
		local direction = Vector3.normalize(line)
		local rotation = Quaternion.look(direction)
		local length = Vector3(Vector3.length(line), 1, 1)
		local effect_id = World.create_particles(world, TARGET_VFX, source_pos, rotation)

		World.set_particles_variable(world, effect_id, self._length_variable_index, length)

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

return ChainLightningEffects
