-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/chain_lightning_link_effects.lua

local Action = require("scripts/utilities/action/action")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local Spread = require("scripts/utilities/spread")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ChainLightningLinkEffects = class("ChainLightningLinkEffects")
local Quaternion_look = Quaternion.look
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local World_create_particles = World.create_particles
local World_find_particles_variable = World.find_particles_variable
local World_move_particles = World.move_particles
local World_set_particles_variable = World.set_particles_variable
local World_stop_spawning_particles = World.stop_spawning_particles
local PI = math.pi
local USE_SOURCE_POS = false
local USE_TARGET_POS = true
local USE_TO_TARGET_ROTATION = false
local USE_IMPACT_NORMAL_ROTATION = true
local SET_LENGTH_VARIABLE = false
local SKIP_LENGTH_VARIABLE = true
local BREADTH_FIRST_VALIDATION = ChainLightning.breadth_first_validation_functions
local DEPTH_FIRST_VALIDATION = ChainLightning.depth_first_validation_functions
local JUMP_VALIDATION = ChainLightning.jump_validation_functions
local ACTION_MODULE_TARGETING_COMPONENT_KEYS = {
	"target_unit_1",
	"target_unit_2",
	"target_unit_3",
}
local ROOT_CHAIN_SETTINGS = {
	max_targets = {
		num_targets = #ACTION_MODULE_TARGETING_COMPONENT_KEYS,
	},
}
local LOOPING_TO_TARGET_VFX_ALIAS = "chain_lightning_to_target"
local LOOPING_LINK_VFX_ALIAS = "chain_lightning_link"
local LOOPING_IMPACT_VFX_ALIAS = "chain_lightning_impact"
local PARTICLE_VARIABLE_NAME = "length"
local TARGET_NODE_NAME = "enemy_aim_target_02"
local DEFAULT_HAND = "both"
local VISUAL_JUMP_TIME = 0.05
local NO_TARGET_JUMP_TIME = 0.2
local _vfx_external_properties = {}
local _on_add_func, _root_on_add_func, _on_remove_func, _link_effect_name
local MAX_NUM_FX_DATA_TABLES = 128
local MAX_NUM_EFFECTS_PER_TABLE = 6
local FxData = class("FxData")

FxData.init = function (self, index)
	self.index = index
	self.active = false

	local effects = Script.new_array(MAX_NUM_EFFECTS_PER_TABLE)

	for ii = 1, MAX_NUM_EFFECTS_PER_TABLE do
		effects[ii] = {}
	end

	self._num_effects = 0
	self._effects = effects
end

FxData.spawn_vfx = function (self, world, link_effect_name, source_unit, source_node, target_unit, target_node)
	local num_effects = self._num_effects + 1

	if num_effects > MAX_NUM_EFFECTS_PER_TABLE then
		return
	end

	local entry = self._effects[num_effects]

	self._num_effects = num_effects

	local source_pos = Unit_world_position(source_unit, source_node)
	local target_pos = Unit_world_position(target_unit, target_node)
	local line = target_pos - source_pos
	local direction, length = Vector3_direction_length(line)
	local rotation = Quaternion_look(direction)
	local particle_length = Vector3(length, 1, 1)
	local effect_id = World_create_particles(world, link_effect_name, source_pos, rotation)
	local length_variable_index = World_find_particles_variable(world, link_effect_name, PARTICLE_VARIABLE_NAME)

	World_set_particles_variable(world, effect_id, length_variable_index, particle_length)

	entry.source_unit = source_unit
	entry.target_unit = target_unit
	entry.source_node_index = source_node
	entry.target_node_index = target_node
	entry.effect_name = link_effect_name
	entry.effect_id = effect_id
	entry.use_target_pos = USE_SOURCE_POS
	entry.use_impact_normal_rotation = USE_TO_TARGET_ROTATION
	entry.skip_length_variable = SET_LENGTH_VARIABLE
end

FxData.spawn_vfx_world_position = function (self, world, source_unit, source_node, target_pos, target_normal, effect_name, use_target_pos, use_impact_normal_rotation, skip_length_variable)
	local num_effects = self._num_effects + 1

	if num_effects > MAX_NUM_EFFECTS_PER_TABLE then
		return
	end

	local entry = self._effects[num_effects]

	self._num_effects = num_effects

	local source_pos = Unit_world_position(source_unit, source_node)
	local line = target_pos - source_pos
	local direction, length = Vector3_direction_length(line)
	local rotation = Quaternion_look(direction)
	local particle_length = Vector3(length, 1, 1)
	local rotation_to_use = use_impact_normal_rotation and target_normal and Quaternion_look(target_normal) or rotation
	local effect_id = World_create_particles(world, effect_name, source_pos, rotation_to_use)

	if not skip_length_variable then
		local length_variable_index = World_find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

		World_set_particles_variable(world, effect_id, length_variable_index, particle_length)
	end

	entry.source_unit = source_unit
	entry.target_pos = Vector3Box(target_pos)
	entry.target_normal = target_normal and Vector3Box(target_normal)
	entry.source_node_index = source_node
	entry.effect_name = effect_name
	entry.effect_id = effect_id
	entry.use_target_pos = use_target_pos
	entry.use_impact_normal_rotation = use_impact_normal_rotation
	entry.skip_length_variable = skip_length_variable
end

FxData.update_target_pos = function (self, target_pos, target_normal)
	local effects = self._effects

	for ii = 1, self._num_effects do
		local entry = effects[ii]

		entry.target_pos:store(target_pos)

		if target_normal and entry.target_normal then
			entry.target_normal:store(target_normal)
		end
	end
end

FxData.stop_vfx = function (self, world)
	local effects = self._effects

	for ii = 1, self._num_effects do
		local entry = effects[ii]
		local effect_id = entry.effect_id

		World_stop_spawning_particles(world, effect_id)
		table.clear(entry)
	end

	self._num_effects = 0
end

FxData.update_vfx = function (self, t, world)
	local effects = self._effects

	for ii = 1, self._num_effects do
		local entry = effects[ii]
		local source_unit = entry.source_unit
		local source_node_index = entry.source_node_index
		local target_unit = entry.target_unit
		local target_node_index = entry.target_node_index
		local source_pos = Unit_world_position(source_unit, source_node_index)
		local target_pos = entry.target_pos and entry.target_pos:unbox() or target_unit and Unit_world_position(target_unit, target_node_index)
		local line = target_pos - source_pos
		local direction, length = Vector3_direction_length(line)
		local rotation = Quaternion_look(direction)
		local particle_length = Vector3(length, 1, 1)
		local effect_name = entry.effect_name
		local effect_id = entry.effect_id
		local use_impact_normal_rotation = entry.use_impact_normal_rotation
		local use_target_pos = entry.use_target_pos
		local set_length_variable = entry.set_length_variable
		local target_normal = entry.target_normal and entry.target_normal:unbox()
		local rotation_to_use = use_impact_normal_rotation and target_normal and Quaternion_look(target_normal) or rotation
		local position_to_use = use_target_pos and target_pos or source_pos

		World_move_particles(world, effect_id, position_to_use, rotation_to_use)

		if set_length_variable then
			local length_variable_index = World_find_particles_variable(world, effect_name, PARTICLE_VARIABLE_NAME)

			World_set_particles_variable(world, effect_id, length_variable_index, particle_length)
		end
	end
end

FxData.clear = function (self)
	self.active = false

	local effects = self._effects

	for ii = 1, MAX_NUM_EFFECTS_PER_TABLE do
		table.clear(effects[ii])
	end
end

local FxDataTables = class("FxDataTables")

FxDataTables.init = function (self)
	local fx_data_tables = Script.new_array(MAX_NUM_FX_DATA_TABLES)

	for ii = 1, MAX_NUM_FX_DATA_TABLES do
		fx_data_tables[ii] = FxData:new(ii)
	end

	self._fx_data_tables = fx_data_tables
end

FxDataTables.next_table = function (self)
	local fx_data_tables = self._fx_data_tables

	for ii = 1, MAX_NUM_FX_DATA_TABLES do
		local fx_data_table = fx_data_tables[ii]

		if not fx_data_table.active then
			fx_data_table.active = true

			return fx_data_table
		end
	end
end

FxDataTables.return_table = function (self, fx_data_table)
	fx_data_table:clear()
end

ChainLightningLinkEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit

	self._world = context.world
	self._physics_world = context.physics_world
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._owner_unit = owner_unit
	self._weapon_actions = weapon_template.actions
	self._buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._targeting_module_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._chain_root_node = nil
	self._hit_units = {}
	self._temp_targets = {}
	self._attacking = false
	self._next_jump_time = 0
	self._next_no_target_jump_time = 0
	self._no_target_position = Vector3Box(0, 0, 0)
	self._no_target_normal = Vector3Box(0, 0, 0)
	self._charge_level = false

	local weapon_chain_settings = weapon_template.chain_settings
	local right_fx_source_name = fx_sources[weapon_chain_settings.right_fx_source_name]
	local left_fx_source_name = fx_sources[weapon_chain_settings.left_fx_source_name]

	if weapon_chain_settings.right_fx_source_name_base_unit then
		right_fx_source_name = weapon_chain_settings.right_fx_source_name_base_unit
	end

	if weapon_chain_settings.left_fx_source_name_base_unit then
		left_fx_source_name = weapon_chain_settings.left_fx_source_name_base_unit
	end

	self._fx_data_tables = FxDataTables:new()
	self._func_context = {
		charge_level = self._charge_level,
		fx_data_tables = self._fx_data_tables,
		hit_units = self._hit_units,
		world = self._world,
		right_fx_source_name = right_fx_source_name,
		left_fx_source_name = left_fx_source_name,
		fx_extension = self._fx_extension,
		visual_loadout_extension = self._visual_loadout_extension,
		weapon_action_component = self._weapon_action_component,
		weapon_template = self._weapon_template,
		weapon_actions = self._weapon_actions,
	}

	self:_create_chain_root_node()
end

ChainLightningLinkEffects._create_chain_root_node = function (self)
	if not self._chain_root_node then
		local depth = 0
		local use_random = false
		local chain_root_node = ChainLightningTarget:new(ROOT_CHAIN_SETTINGS, depth, use_random, nil, "unit", self._owner_unit)

		for ii = 1, #ACTION_MODULE_TARGETING_COMPONENT_KEYS do
			local key = ACTION_MODULE_TARGETING_COMPONENT_KEYS[ii]

			chain_root_node:set_value(key, false)
		end

		self._chain_root_node = chain_root_node
	end

	self:_clear_initial_targets()
	self:_clear_no_target()
end

ChainLightningLinkEffects._clear_initial_targets = function (self)
	local chain_root_node = self._chain_root_node

	for ii = 1, #ACTION_MODULE_TARGETING_COMPONENT_KEYS do
		local key = ACTION_MODULE_TARGETING_COMPONENT_KEYS[ii]

		chain_root_node:set_value(key, false)
	end
end

ChainLightningLinkEffects.destroy = function (self)
	self:_reset()
end

ChainLightningLinkEffects.wield = function (self)
	self:_reset()
end

ChainLightningLinkEffects.unwield = function (self)
	self:_reset()
end

ChainLightningLinkEffects.update_unit_position = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_find_root_targets(t)
	self:_validate_targets(t)
	self:_find_new_targets(t)
	self:_update_fx(t)
end

ChainLightningLinkEffects._find_root_targets = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local attacking = action_kind == "chain_lightning"

	if attacking then
		local hit_units = self._hit_units
		local chain_root_node = self._chain_root_node
		local time_in_action = t - self._weapon_action_component.start_t
		local chain_settings = action_settings.chain_settings
		local depth = 0
		local use_random = true
		local max_targets = ChainLightning.max_targets(time_in_action, chain_settings, depth, use_random)
		local targeting_module_component = self._targeting_module_component
		local func_context = self._func_context
		local is_critical_strike = self._critical_strike_component.is_active
		local fx_settings = action_settings and action_settings.fx
		local fx_hand = fx_settings and (is_critical_strike and fx_settings.fx_hand_critical_strike or fx_settings.fx_hand) or DEFAULT_HAND

		func_context.fx_hand = fx_hand

		for ii = 1, #ACTION_MODULE_TARGETING_COMPONENT_KEYS do
			if max_targets <= chain_root_node:num_children() then
				break
			end

			local key = ACTION_MODULE_TARGETING_COMPONENT_KEYS[ii]
			local target_unit = targeting_module_component[key]

			if target_unit and not hit_units[target_unit] and JUMP_VALIDATION.target_alive_and_electrocuted(target_unit) then
				local slot_target_node = chain_root_node:value(key)
				local slot_target_unit_alive = HEALTH_ALIVE[chain_root_node:value("target_unit")]

				if slot_target_node and not slot_target_unit_alive then
					ChainLightningTarget.remove_all_child_nodes(slot_target_node, _on_remove_func, func_context)
					chain_root_node:remove_child(slot_target_node, _on_remove_func, func_context)

					hit_units[target_unit] = nil
					slot_target_node = false
				end

				if not slot_target_node then
					local child_node = chain_root_node:add_child(_root_on_add_func, func_context, "unit", target_unit, "start_t", t)

					chain_root_node:set_value(key, child_node)

					hit_units[target_unit] = true
				end
			end
		end

		self:_find_no_target(t)
	elseif self._attacking and not attacking then
		local chain_root_node = self._chain_root_node

		ChainLightningTarget.remove_all_child_nodes(chain_root_node, _on_remove_func, self._func_context)
		self:_clear_initial_targets()
		self:_clear_no_target()
	end

	self._attacking = attacking
end

ChainLightningLinkEffects._find_no_target = function (self, t)
	local chain_root_node = self._chain_root_node
	local context = self._func_context

	if chain_root_node:num_children() <= 0 then
		local target_pos, target_normal = self:_find_no_target_pos(t)

		if not chain_root_node:value("fx_data") then
			local fx_data_table = context.fx_data_tables:next_table()
			local link_effect_name, impact_effect_name, to_target_effect_name = _link_effect_name(context, "no_target")
			local fx_hand = context.fx_hand
			local spawn_left = fx_hand == "both" or fx_hand == "left"
			local spawn_right = fx_hand == "both" or fx_hand == "right"

			if spawn_left then
				local parent_unit, source_node_index = context.fx_extension:vfx_spawner_unit_and_node(context.left_fx_source_name)

				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, link_effect_name, USE_SOURCE_POS, USE_TO_TARGET_ROTATION, SET_LENGTH_VARIABLE)
				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, impact_effect_name, USE_TARGET_POS, USE_IMPACT_NORMAL_ROTATION, SKIP_LENGTH_VARIABLE)
				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, to_target_effect_name, USE_SOURCE_POS, USE_TO_TARGET_ROTATION, SET_LENGTH_VARIABLE)
			end

			if spawn_right then
				local parent_unit, source_node_index = context.fx_extension:vfx_spawner_unit_and_node(context.right_fx_source_name)

				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, link_effect_name, USE_SOURCE_POS, USE_TO_TARGET_ROTATION, SET_LENGTH_VARIABLE)
				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, impact_effect_name, USE_TARGET_POS, USE_IMPACT_NORMAL_ROTATION, SKIP_LENGTH_VARIABLE)
				fx_data_table:spawn_vfx_world_position(context.world, parent_unit, source_node_index, target_pos, target_normal, to_target_effect_name, USE_SOURCE_POS, USE_TO_TARGET_ROTATION, SET_LENGTH_VARIABLE)
			end

			chain_root_node:set_value("fx_data", fx_data_table)
		else
			local fx_data_table = chain_root_node:value("fx_data")

			fx_data_table:update_target_pos(target_pos, target_normal)
		end
	else
		self:_clear_no_target()
	end
end

local COLLISION_FILTER = "filter_player_character_shooting_raycast_statics"

ChainLightningLinkEffects._no_target_raycast = function (self, position, rotation, max_length)
	local spread_angle = 5
	local bullseye = false
	local ray_rotation = Spread.target_style_spread(rotation, 1, 1, 2, bullseye, spread_angle, spread_angle, nil, false, nil, math.random_seed())
	local direction = Quaternion.forward(ray_rotation)
	local hit, hit_position, distance, hit_normal, _ = PhysicsWorld.raycast(self._physics_world, position, direction, max_length, "closest", "collision_filter", COLLISION_FILTER)

	if not hit then
		hit_position = position + direction * max_length
		distance = max_length
		hit_normal = direction
	end

	return hit, hit_position, distance, hit_normal
end

ChainLightningLinkEffects._find_no_target_pos = function (self, t)
	if t < self._next_no_target_jump_time then
		return self._no_target_position:unbox(), self._no_target_normal:unbox()
	end

	local position = self._first_person_component.position
	local rotation = self._first_person_component.rotation
	local hit, hit_position, _, hit_normal = self:_no_target_raycast(position, rotation, 10)

	if not hit then
		local right = Quaternion.right(rotation)
		local downwards_rotation = Quaternion.multiply(Quaternion.axis_angle(right, -PI * 0.1), rotation)

		_, hit_position, _, hit_normal = self:_no_target_raycast(position, downwards_rotation, 10)
	end

	local jump_time = NO_TARGET_JUMP_TIME

	self._next_no_target_jump_time = t + jump_time

	self._no_target_position:store(hit_position)
	self._no_target_normal:store(hit_normal)

	return hit_position, hit_normal
end

ChainLightningLinkEffects._clear_no_target = function (self)
	local world = self._world
	local chain_root_node = self._chain_root_node
	local fx_data_table = chain_root_node:value("fx_data")

	if fx_data_table and fx_data_table.active then
		fx_data_table:stop_vfx(world)
		chain_root_node:set_value("fx_data", nil)
		self._fx_data_tables:return_table(fx_data_table)
	end
end

ChainLightningLinkEffects._validate_targets = function (self, t)
	local chain_root_node = self._chain_root_node
	local temp_targets = self._temp_targets

	table.clear(temp_targets)
	ChainLightningTarget.traverse_depth_first(t, chain_root_node, temp_targets, DEPTH_FIRST_VALIDATION.node_target_not_electrocuted_or_not_alive)

	local num_targets = #temp_targets

	for ii = num_targets, 1, -1 do
		local target = temp_targets[ii]

		target:mark_for_deletion()
	end

	ChainLightningTarget.remove_child_nodes_marked_for_deletion(chain_root_node, _on_remove_func, self._func_context)
end

ChainLightningLinkEffects._find_new_targets = function (self, t)
	if t < self._next_jump_time then
		return
	end

	local owner_unit = self._owner_unit
	local chain_root_node = self._chain_root_node
	local owner_unit_position = POSITION_LOOKUP[owner_unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[owner_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local broadphase = broadphase_system.broadphase
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local stat_buffs = self._buff_extension:stat_buffs()
	local chain_settings = action_settings and action_settings.chain_settings
	local time_in_action = t - weapon_action_component.start_t
	local max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, jump_time = ChainLightning.targeting_parameters(time_in_action, chain_settings, stat_buffs)

	jump_time = VISUAL_JUMP_TIME

	for child_node, _ in pairs(chain_root_node:children()) do
		local travel_direction = Vector3_normalize(Vector3_flat(owner_unit_position - POSITION_LOOKUP[child_node:value("unit")]))

		self:_find_new_chain_targets(t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, child_node, travel_direction)
	end

	self._next_jump_time = t + jump_time
end

ChainLightningLinkEffects._find_new_chain_targets = function (self, t, broadphase, enemy_side_names, max_angle, close_max_angle, vertical_max_angle, max_z_diff, max_jumps, radius, root_target, initial_travel_direction)
	local func_context = self._func_context
	local hit_units = self._hit_units
	local temp_targets = self._temp_targets
	local physics_world = self._physics_world

	table.clear(temp_targets)
	ChainLightningTarget.traverse_breadth_first(t, root_target, temp_targets, BREADTH_FIRST_VALIDATION.node_available_within_depth, max_jumps)

	for ii = 1, #temp_targets do
		local source = temp_targets[ii]

		ChainLightning.jump(t, physics_world, source, hit_units, broadphase, enemy_side_names, initial_travel_direction, radius, max_angle, close_max_angle, vertical_max_angle, max_z_diff, _on_add_func, func_context, JUMP_VALIDATION.target_alive_and_electrocuted)
	end
end

ChainLightningLinkEffects._update_fx = function (self, t)
	local temp_targets = self._temp_targets

	table.clear(temp_targets)

	local world = self._world
	local chain_root_node = self._chain_root_node

	ChainLightningTarget.traverse_breadth_first(t, chain_root_node, temp_targets)

	for ii = 1, #temp_targets do
		local target = temp_targets[ii]
		local fx_data_table = target:value("fx_data")

		if fx_data_table and fx_data_table.active then
			fx_data_table:update_vfx(t, world)
		end
	end
end

ChainLightningLinkEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ChainLightningLinkEffects._reset = function (self)
	self._next_jump_time = 0
	self._next_no_target_jump_time = 0

	ChainLightningTarget.remove_all_child_nodes(self._chain_root_node, _on_remove_func, self._func_context)
	self:_clear_initial_targets()
	self:_clear_no_target()
	table.clear(self._hit_units)

	self._hit_units[self._owner_unit] = true
end

function _on_add_func(node, context)
	local child_unit = node:value("unit")

	if not node:value("fx_data") then
		local parent_node = node:parent()
		local parent_unit = parent_node:value("unit")
		local source_node_index = Unit_node(parent_unit, TARGET_NODE_NAME)
		local target_node_index = Unit_node(child_unit, TARGET_NODE_NAME)
		local fx_data_table = context.fx_data_tables:next_table()
		local link_effect_name = _link_effect_name(context)

		fx_data_table:spawn_vfx(context.world, link_effect_name, parent_unit, source_node_index, child_unit, target_node_index)
		node:set_value("fx_data", fx_data_table)
	end

	context.hit_units[child_unit] = true
end

function _root_on_add_func(node, context)
	local child_unit = node:value("unit")

	if not node:value("fx_data") then
		local fx_hand = context.fx_hand
		local spawn_left = fx_hand == "both" or fx_hand == "left"
		local spawn_right = fx_hand == "both" or fx_hand == "right"
		local target_node_index = Unit_node(child_unit, TARGET_NODE_NAME)
		local fx_data_table = context.fx_data_tables:next_table()
		local link_effect_name, _, to_target_effect_name = _link_effect_name(context)

		if spawn_left then
			local parent_unit, source_node_index = context.fx_extension:vfx_spawner_unit_and_node(context.left_fx_source_name)

			fx_data_table:spawn_vfx(context.world, link_effect_name, parent_unit, source_node_index, child_unit, target_node_index)
			fx_data_table:spawn_vfx(context.world, to_target_effect_name, parent_unit, source_node_index, child_unit, target_node_index)
		end

		if spawn_right then
			local parent_unit, source_node_index = context.fx_extension:vfx_spawner_unit_and_node(context.right_fx_source_name)

			fx_data_table:spawn_vfx(context.world, link_effect_name, parent_unit, source_node_index, child_unit, target_node_index)
			fx_data_table:spawn_vfx(context.world, to_target_effect_name, parent_unit, source_node_index, child_unit, target_node_index)
		end

		node:set_value("fx_data", fx_data_table)
	end

	context.hit_units[child_unit] = true
end

function _on_remove_func(node, context)
	local world = context.world
	local fx_data_table = node:value("fx_data")

	if fx_data_table and fx_data_table.active then
		fx_data_table:stop_vfx(world)
		node:set_value("fx_data", nil)
		context.fx_data_tables:return_table(fx_data_table)
	end

	local unit = node:value("unit")

	context.hit_units[unit] = nil
end

function _link_effect_name(context, power_override)
	local action_settings = Action.current_action_settings_from_component(context.weapon_action_component, context.weapon_actions)
	local weapon_template = context.weapon_template
	local chain_lightning_link_effects = action_settings and action_settings.chain_lightning_link_effects or weapon_template and weapon_template.chain_lightning_link_effects
	local power = power_override

	if not power and chain_lightning_link_effects then
		local charge_level_to_power = chain_lightning_link_effects.charge_level_to_power

		if charge_level_to_power then
			local charge_level = context.charge_level

			if charge_level then
				for ii = #charge_level_to_power, 1, -1 do
					local entry = charge_level_to_power[ii]

					if charge_level > entry.charge_level then
						power = entry.power

						break
					end
				end
			else
				power = "high"
			end
		else
			power = chain_lightning_link_effects.power or "high"
		end
	end

	_vfx_external_properties.power = power or "high"

	local visual_loadout_extension = context.visual_loadout_extension
	local resolved_link_effect, link_effect_name = visual_loadout_extension:resolve_gear_particle(LOOPING_LINK_VFX_ALIAS, _vfx_external_properties)
	local resolved_impact_effect, impact_effect_name = visual_loadout_extension:resolve_gear_particle(LOOPING_IMPACT_VFX_ALIAS, _vfx_external_properties)
	local resolved_to_target_effect, to_target_effect_name = visual_loadout_extension:resolve_gear_particle(LOOPING_TO_TARGET_VFX_ALIAS, _vfx_external_properties)

	return resolved_link_effect and link_effect_name, resolved_impact_effect and impact_effect_name, resolved_to_target_effect and to_target_effect_name
end

implements(ChainLightningLinkEffects, WieldableSlotScriptInterface)

return ChainLightningLinkEffects
