-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_shoot_flames_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")
require("scripts/extension_systems/behavior/nodes/actions/bt_shoot_liquid_beam_action")

local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local HitScan = require("scripts/utilities/attack/hit_scan")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local Spread = require("scripts/utilities/spread")
local Suppression = require("scripts/utilities/attack/suppression")
local proc_events = BuffSettings.proc_events
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local BtShootFlamesAction = class("BtShootFlamesAction", "BtNode")
local _unique_minion_hit_during_action = Script.new_map(16)

BtShootFlamesAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local slot_name = action_data.inventory_slot
	local slot_unit = visual_loadout_extension:slot_unit(slot_name)

	scratchpad.slot_unit = slot_unit
	scratchpad.visual_loadout_extension = visual_loadout_extension

	local spawn_component = blackboard.spawn

	scratchpad.spawn_component = spawn_component

	local side_system = Managers.state.extension:system("side_system")

	scratchpad.side_system = side_system

	local buff_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")

	scratchpad.buff_extension = buff_extension

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	scratchpad.animation_extension = animation_extension
	scratchpad._world = Unit.world(unit)
	scratchpad._physics_world = World.physics_world(scratchpad._world)
	scratchpad._target_indexes = {}
	scratchpad._target_actors = {}
	scratchpad._target_damage_times = {}
	scratchpad._target_frame_counts = {}
	scratchpad._dot_targets = {}

	local flamer_gas_template = action_data.flamer_gas_template

	scratchpad._damage_times = flamer_gas_template.damage_times

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	scratchpad.end_time = t + action_data.duration

	local initial_burn_delay = flamer_gas_template.initial_burn_delay

	scratchpad._burn_time = flamer_gas_template.dot_stack_application_rate + initial_burn_delay

	local move_effect_template = action_data.move_effect_template

	if move_effect_template then
		scratchpad.move_effect_id = self:_start_effect_template(unit, scratchpad, action_data.move_effect_template)
	end

	local wait_to_reach_position = action_data.wait_to_reach_position

	if not wait_to_reach_position then
		scratchpad.flame_effect_id = self:_start_effect_template(unit, scratchpad, action_data.effect_template_name)
	end

	if action_data.trigger_stat_hooks_for_player_owner then
		if action_data.trigger_stat_hooks_for_player_owner.action_enter then
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local owner_player = player_unit_spawn_manager and player_unit_spawn_manager:owner(unit)

			scratchpad.owner_player = owner_player

			Managers.stats:record_private(action_data.trigger_stat_hooks_for_player_owner.action_enter, owner_player)
		end

		if action_data.trigger_stat_hooks_for_player_owner.unique_hit then
			table.clear(_unique_minion_hit_during_action)
		end
	end
end

local _hit_units_this_frame = {}

BtShootFlamesAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_collect_targets(unit, scratchpad, action_data, t)
	self:_damage_and_burn_targets(scratchpad, unit, t, dt, false, action_data)
	self:_apply_suppression(unit, scratchpad, action_data)

	if t > scratchpad.end_time then
		return "done"
	end

	return "running"
end

BtShootFlamesAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	self:_stop_effect_template(unit, scratchpad, scratchpad.flame_effect_id)
	self:_stop_effect_template(unit, scratchpad, scratchpad.move_effect_id)

	local optional_leave_function = action_data.optional_leave_function

	if optional_leave_function then
		optional_leave_function(unit)
	end
end

local INDEX_POSITION = 1
local INDEX_NORMAL = 3
local INDEX_ACTOR = 4

BtShootFlamesAction._do_raycast = function (self, unit, scratchpad, action_data, current_shoot_number, spread_angle_pitch, spread_angle_yaw, hit_units_this_frame, t)
	local rotation = self:_shoot_rotation(unit)
	local ray_rotation = Spread.uniform_circle(rotation, spread_angle_pitch, spread_angle_yaw, math.random_seed())
	local shoot_position = self:_shoot_position(unit, scratchpad, action_data)
	local direction = Quaternion.forward(ray_rotation)
	local hits = HitScan.raycast(scratchpad._physics_world, shoot_position, direction, action_data.max_range, nil, action_data.shooting_collision_filter, nil, nil, nil, true)

	if hits then
		for i = 1, #hits do
			local valid_impact_position, impact_position, impact_normal = self:_process_hit(scratchpad, action_data, unit, hits[i], hit_units_this_frame, t)

			self:_set_game_object_field(scratchpad, "fx_position_valid", valid_impact_position)

			if valid_impact_position then
				self:_set_game_object_field(scratchpad, "fx_impact_position", impact_position)
				self:_set_game_object_field(scratchpad, "fx_impact_normal", impact_normal)
			end
		end
	end
end

BtShootFlamesAction._collect_targets = function (self, unit, scratchpad, action_data, t)
	table.clear(_hit_units_this_frame)

	local number_of_rays_per_frame = action_data.number_of_rays_per_frame
	local spread_angle_pitch = action_data.spread_angle_pitch
	local spread_angle_yaw = action_data.spread_angle_yaw

	for i = 1, number_of_rays_per_frame do
		self:_do_raycast(unit, scratchpad, action_data, i, spread_angle_pitch, spread_angle_yaw, _hit_units_this_frame, t)
	end
end

BtShootFlamesAction._process_hit = function (self, scratchpad, action_data, unit, hit, hit_units_this_frame, t)
	local hit_pos = hit[INDEX_POSITION]
	local hit_actor = hit[INDEX_ACTOR]
	local hit_normal = hit[INDEX_NORMAL]
	local hit_unit = Actor.unit(hit_actor)
	local hit_zone_name_or_nil = HitZone.get_name(hit_unit, hit_actor)
	local hit_afro = hit_zone_name_or_nil == HitZone.hit_zone_names.afro
	local target_actors = scratchpad._target_actors
	local dot_targets = scratchpad._dot_targets

	if hit_units_this_frame[hit_unit] then
		return false
	end

	if hit_afro then
		return false
	end

	local is_player_unit = Managers.state.player_unit_spawn:is_player_unit(hit_unit)

	if is_player_unit then
		return false
	end

	local health_extension = ScriptUnit.has_extension(hit_unit, "health_system")
	local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")
	local unit_position = POSITION_LOOKUP[unit]
	local is_unit_blocking = self:_is_unit_blocking(hit_unit, unit_position)

	if is_unit_blocking or not health_extension and not buff_extension then
		return true, hit_pos, hit_normal
	end

	local side_system = scratchpad.side_system

	if side_system:is_ally(unit, hit_unit) then
		return false
	end

	local distance = Vector3.distance(POSITION_LOOKUP[unit], POSITION_LOOKUP[hit_unit])
	local distance_scalar = distance / action_data.max_range
	local t_offset = distance_scalar * 0.5

	if health_extension then
		self:_hit_target(scratchpad, unit, action_data, hit_unit, hit_pos)

		target_actors[hit_unit] = hit_actor
	end

	if buff_extension then
		dot_targets[hit_unit] = t + t_offset
	end

	hit_units_this_frame[hit_unit] = true

	if action_data.trigger_stat_hooks_for_player_owner and action_data.trigger_stat_hooks_for_player_owner.unique_hit and not _unique_minion_hit_during_action[hit_unit] then
		_unique_minion_hit_during_action[hit_unit] = true

		Managers.stats:record_private(action_data.trigger_stat_hooks_for_player_owner.unique_hit, scratchpad.owner_player)
	end

	return false
end

BtShootFlamesAction._hit_target = function (self, scratchpad, unit, action_data, hit_unit, hit_pos)
	local damage_time = scratchpad._target_damage_times[hit_unit]
	local frame_count = scratchpad._target_frame_counts[hit_unit]
	local index = scratchpad._target_indexes[hit_unit]

	if not index then
		local unit_pos = POSITION_LOOKUP[unit]
		local distance = Vector3.distance(hit_pos, unit_pos)
		local max_range = action_data.max_range

		index = 1
		damage_time = scratchpad._damage_times[index] + distance / max_range * 0.4
		frame_count = 1
	else
		frame_count = frame_count + 1
	end

	scratchpad._target_damage_times[hit_unit] = damage_time
	scratchpad._target_frame_counts[hit_unit] = frame_count
	scratchpad._target_indexes[hit_unit] = index
end

BtShootFlamesAction._damage_and_burn_targets = function (self, scratchpad, unit, t, dt, force_damage, action_data)
	local damage_times = scratchpad._damage_times
	local target_damage_times = scratchpad._target_damage_times
	local target_frame_counts = scratchpad._target_frame_counts
	local target_indexes = scratchpad._target_indexes
	local target_actors = scratchpad._target_actors
	local fixed_time_step = Managers.state.game_session.fixed_time_step

	for target_unit, current_index in pairs(target_indexes) do
		repeat
			local current_damage_time = target_damage_times[target_unit]
			local frame_count = target_frame_counts[target_unit]
			local hit_actor = target_actors[target_unit]
			local hit_zone_name_or_nil = HitZone.get_name(target_unit, hit_actor)
			local target_breed_or_nil = Breed.unit_breed_or_nil(target_unit)
			local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(target_unit)
			local is_breed_with_hit_zone = target_breed_or_nil and hit_zone_name_or_nil
			local should_deal_damage = target_is_hazard_prop and hazard_prop_is_active or not target_is_hazard_prop and is_breed_with_hit_zone or not target_breed_or_nil
			local health_extension = ScriptUnit.has_extension(target_unit, "health_system")

			if not ALIVE[target_unit] or not health_extension or not should_deal_damage then
				target_damage_times[target_unit] = nil
				target_frame_counts[target_unit] = nil
				target_indexes[target_unit] = nil
				target_actors[target_unit] = nil

				break
			end

			if current_damage_time <= 0 or force_damage then
				do
					local damage_time_index = math.min(current_index, #damage_times)
					local damage_time = damage_times[damage_time_index]
					local aim_at_percent = frame_count / (damage_time / fixed_time_step)
					local new_damage_time, new_frame_count, new_target_index, new_actor

					if aim_at_percent > 0.33 then
						self:_damage_target(unit, target_unit, action_data, scratchpad)

						local new_damage_time_index = math.min(current_index + 1, #damage_times)

						new_damage_time = damage_times[new_damage_time_index]
						new_frame_count = 0
						new_target_index = math.min(7, current_index + 1)
						new_actor = hit_actor
					elseif current_index > 1 then
						local new_damage_time_index = math.min(current_index - 1, #damage_times)

						new_damage_time = damage_times[new_damage_time_index]
						new_frame_count = 0
						new_target_index = current_index - 1
						new_actor = hit_actor
					else
						new_damage_time = nil
						new_frame_count = nil
						new_target_index = nil
						new_actor = nil
					end

					target_damage_times[target_unit] = new_damage_time
					target_frame_counts[target_unit] = new_frame_count
					target_indexes[target_unit] = new_target_index
					target_actors[target_unit] = new_actor
				end

				break
			end

			target_damage_times[target_unit] = current_damage_time - dt
		until true
	end

	self:_burn_target(dt, t, force_damage, unit, action_data, scratchpad)
end

BtShootFlamesAction._damage_target = function (self, attacking_unit, target_unit, action_data, scratchpad)
	local damage_config = action_data.flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local attacking_unit_pos = POSITION_LOOKUP[attacking_unit]
	local target_pos = POSITION_LOOKUP[target_unit]
	local target_index = 1
	local actor
	local hit_position = target_pos
	local hit_distance = Vector3.distance(target_pos, attacking_unit_pos)
	local direction = Vector3.normalize(target_pos - attacking_unit_pos)
	local hit_normal, hit_zone_name
	local penetrated = false
	local instakill = false
	local damage_type = scratchpad._damage_type
	local is_critical_strike = false
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, attacking_unit, target_index)
	local charge_level = 1
	local damage_dealt, _, _, _ = RangedAction.execute_attack(target_index, attacking_unit, target_unit, actor, hit_position, hit_distance, direction, hit_normal, hit_zone_name, damage_profile, damage_profile_lerp_values, DEFAULT_POWER_LEVEL, charge_level, penetrated, instakill, damage_type, is_critical_strike)

	if damage_dealt then
		local buff_extension = scratchpad._buff_extension

		if buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.attacked_unit = target_unit

				buff_extension:add_proc_event(proc_events.on_direct_flamer_hit, param_table)
			end
		end
	end
end

BtShootFlamesAction._burn_target = function (self, dt, t, force_burn, attacking_unit, action_data, scratchpad)
	local burn_time = scratchpad._burn_time - dt
	local max_stacks = action_data.flamer_gas_template.burn_max_stacks
	local number_of_stacks = action_data.flamer_gas_template.stacks

	if burn_time <= 0 or force_burn then
		local targets = scratchpad._dot_targets
		local dot_buff_name = action_data.flamer_gas_template.dot_buff_name
		local ALIVE = ALIVE

		for hit_unit, _ in pairs(targets) do
			if ALIVE[hit_unit] then
				local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")

				if buff_extension then
					local current_stacks = buff_extension:current_stacks(dot_buff_name)
					local start_time_with_offset = t + math.random() * 0.3

					if current_stacks < max_stacks then
						buff_extension:add_internally_controlled_buff_with_stacks(dot_buff_name, number_of_stacks, start_time_with_offset, "owner_unit", attacking_unit)
					elseif current_stacks == max_stacks then
						buff_extension:refresh_duration_of_stacking_buff(dot_buff_name, start_time_with_offset)
					end
				end
			end
		end

		table.clear(targets)

		burn_time = action_data.flamer_gas_template.dot_stack_application_rate
	end

	scratchpad._burn_time = burn_time
end

BtShootFlamesAction._shoot_position = function (self, unit, scratchpad, action_data)
	local slot_unit = scratchpad.slot_unit
	local shoot_node_name = action_data.fx_source_name
	local unit_has_node = Unit.has_node(slot_unit, shoot_node_name)

	if unit_has_node then
		local node = Unit.node(slot_unit, shoot_node_name)
		local node_position = Unit.world_position(slot_unit, node)

		return node_position
	else
		local visual_loadout_extension = scratchpad.visual_loadout_extension
		local slot_name = action_data.inventory_slot
		local inventory_item = visual_loadout_extension:slot_item(slot_name)

		if inventory_item then
			local fx_source_name = action_data.fx_source_name
			local lookup_fx_sources = false
			local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(inventory_item, fx_source_name, lookup_fx_sources)
			local node_position = Unit.world_position(attachment_unit, node)

			return node_position
		end
	end
end

BtShootFlamesAction._shoot_rotation = function (self, unit)
	local rotation = Unit.world_rotation(unit, 1)
	local forward_direction = Vector3.flat(Quaternion.forward(rotation))
	local new_rotation = Quaternion.look(forward_direction)

	return new_rotation
end

BtShootFlamesAction._is_unit_blocking = function (self, unit, player_pos)
	local shield_extension = ScriptUnit.has_extension(unit, "shield_system")

	if shield_extension then
		return shield_extension:can_block_from_position(player_pos)
	end
end

local broadphase_results = {}
local suppressed_units = {}

BtShootFlamesAction._acquire_suppressed_units = function (self, unit, scratchpad, action_data)
	table.clear(broadphase_results)
	table.clear(suppressed_units)

	local flamer_gas_template = action_data.flamer_gas_template
	local suppression_radius = flamer_gas_template.suppression_radius
	local suppression_cone_dot = flamer_gas_template.suppression_cone_dot
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local unit_position = POSITION_LOOKUP[unit]
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local num_hits = broadphase.query(broadphase, unit_position, suppression_radius, broadphase_results, enemy_side_names)
	local rotation = Unit.world_rotation(unit, 1)
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	for i = 1, num_hits do
		local enemy_unit = broadphase_results[i]
		local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
		local flat_direction = Vector3.flat(enemy_unit_position - unit_position)
		local direction = Vector3.normalize(flat_direction)
		local dot = Vector3.dot(forward, direction)

		if suppression_cone_dot < dot then
			suppressed_units[enemy_unit] = true
		end
	end

	return suppressed_units
end

BtShootFlamesAction._apply_suppression = function (self, unit, scratchpad, action_data)
	local damage_config = action_data.flamer_gas_template.damage
	local damage_profile = damage_config.impact.damage_profile
	local units = self:_acquire_suppressed_units(unit, scratchpad, action_data)

	for hit_unit, _ in pairs(units) do
		Suppression.apply_suppression(hit_unit, unit, damage_profile, POSITION_LOOKUP[unit])
	end
end

BtShootFlamesAction._start_effect_template = function (self, unit, scratchpad, effect_template_name)
	local effect_template = EffectTemplates[effect_template_name]
	local fx_system = scratchpad.fx_system
	local effect_id = fx_system:start_template_effect(effect_template, unit)

	return effect_id
end

BtShootFlamesAction._stop_effect_template = function (self, unit, scratchpad, effect_id)
	if effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(effect_id)
	end
end

BtShootFlamesAction._set_game_object_field = function (self, scratchpad, key, value)
	local spawn_component = scratchpad.spawn_component
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, key, value)
end

return BtShootFlamesAction
