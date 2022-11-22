local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local CombatRangeUserBehaviorExtension = class("CombatRangeUserBehaviorExtension", "MinionBehaviorExtension")
local _get_combat_range_switch_distance, _should_switch_combat_range = nil

CombatRangeUserBehaviorExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._phase_template = extension_init_data.phase_template

	CombatRangeUserBehaviorExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._unit = unit
	self._fx_system = Managers.state.extension:system("fx_system")
	local breed = self._breed
	local combat_range_data = breed.combat_range_data
	self._start_effect_template = combat_range_data.start_effect_template
	local multi_config = combat_range_data.multi_config

	if multi_config then
		local combat_range_multi_config_key = extension_init_data.combat_range_multi_config_key
		self._combat_range_config = multi_config[combat_range_multi_config_key]
	else
		self._combat_range_config = combat_range_data.config
	end

	if combat_range_data.calculate_target_velocity_dot then
		self._target_velocity_dot_duration = 0
		self._target_velocity_dot_reset = combat_range_data.target_velocity_dot_reset
		self._target_velocity_dot_reset_timer = 0
	end
end

local DEFAULT_SPAWN_INVENTORY_SLOT = "unarmed"

CombatRangeUserBehaviorExtension._init_blackboard_components = function (self, blackboard, breed, ...)
	CombatRangeUserBehaviorExtension.super._init_blackboard_components(self, blackboard, breed, ...)

	local spawn_inventory_slot = breed.spawn_inventory_slot or DEFAULT_SPAWN_INVENTORY_SLOT
	local weapon_switch_component = Blackboard.write_component(blackboard, "weapon_switch")
	weapon_switch_component.wanted_weapon_slot = spawn_inventory_slot
	weapon_switch_component.wanted_combat_range = ""
	weapon_switch_component.is_switching_weapons = false
	weapon_switch_component.last_weapon_switch_t = -math.huge
	self._weapon_switch_component = weapon_switch_component
	local combat_range_data = breed.combat_range_data
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local starting_combat_range = combat_range_data.starting_combat_range
	behavior_component.combat_range = starting_combat_range
	behavior_component.combat_range_sticky_time = 0
	behavior_component.enter_combat_range_flag = false
	behavior_component.lock_combat_range_switch = false
	self._behavior_component = behavior_component
	self._perception_component = blackboard.perception

	if self._phase_template then
		local phase_component = Blackboard.write_component(blackboard, "phase")
		phase_component.current_phase = ""
		phase_component.exit_phase_t = math.huge
		phase_component.lock = false
		phase_component.wanted_phase = ""
		phase_component.force_next_phase = false
		self._phase_component = phase_component
		local wanted_phase_name = self._phase_template[starting_combat_range].entry_phase

		if type(wanted_phase_name) == "table" then
			local index = math.random(#wanted_phase_name)
			wanted_phase_name = wanted_phase_name[index]
		end

		phase_component.wanted_phase = wanted_phase_name
	end
end

CombatRangeUserBehaviorExtension.game_object_initialized = function (self, game_session, game_object_id)
	CombatRangeUserBehaviorExtension.super.game_object_initialized(self, game_session, game_object_id)

	local start_effect_template = self._start_effect_template

	if start_effect_template then
		self._fx_system:start_template_effect(start_effect_template, self._unit)
	end
end

CombatRangeUserBehaviorExtension.update_combat_range = function (self, unit, blackboard, dt, t)
	local behavior_component = self._behavior_component
	local perception_component = self._perception_component
	local target_unit = perception_component.target_unit
	local switch_is_locked = behavior_component.lock_combat_range_switch or t <= behavior_component.combat_range_sticky_time
	local current_combat_range = behavior_component.combat_range
	local combat_range_config = self._combat_range_config[current_combat_range]

	if self._target_velocity_dot_duration and HEALTH_ALIVE[target_unit] then
		if target_unit ~= self._old_target_unit then
			self._target_unit_locomotion_extension = ScriptUnit.extension(target_unit, "locomotion_system")
			self._old_target_unit = target_unit
		end

		local target_unit_locomotion_extension = self._target_unit_locomotion_extension
		local target_velocity_normalized = Vector3.normalize(target_unit_locomotion_extension:current_velocity())
		local forward = Quaternion.forward(Unit.local_rotation(unit, 1))

		if Vector3.dot(forward, target_velocity_normalized) > 0 then
			self._target_velocity_dot_duration = self._target_velocity_dot_duration + dt
		else
			self._target_velocity_dot_reset_timer = self._target_velocity_dot_reset_timer + dt

			if self._target_velocity_dot_reset <= self._target_velocity_dot_reset_timer then
				self._target_velocity_dot_duration = 0
				self._target_velocity_dot_reset_timer = 0
			end
		end
	end

	if switch_is_locked or not HEALTH_ALIVE[target_unit] or not HEALTH_ALIVE[unit] then
		return
	end

	local weapon_switch_component = self._weapon_switch_component

	if weapon_switch_component.is_switching_weapons then
		return
	end

	local target_distance = perception_component.target_distance
	local has_line_of_sight = perception_component.has_line_of_sight

	for i = 1, #combat_range_config do
		repeat
			local config = combat_range_config[i]
			local require_line_of_sight = config.require_line_of_sight

			if require_line_of_sight and not has_line_of_sight then
				break
			end

			local should_switch_combat_range = _should_switch_combat_range(unit, blackboard, target_distance, config, target_unit, self._target_velocity_dot_duration)

			if should_switch_combat_range then
				local switch_weapon_slot = config.switch_weapon_slot
				local wanted_combat_range = config.switch_combat_range

				if switch_weapon_slot then
					weapon_switch_component.wanted_weapon_slot = switch_weapon_slot
					weapon_switch_component.wanted_combat_range = wanted_combat_range
					weapon_switch_component.is_switching_weapons = true
				else
					behavior_component.combat_range = wanted_combat_range
				end

				if config.switch_phase then
					local wanted_phase_name = self._phase_template[wanted_combat_range].entry_phase

					if type(wanted_phase_name) == "table" then
						local index = math.random(#wanted_phase_name)
						wanted_phase_name = wanted_phase_name[index]
					end

					self._phase_component.wanted_phase = wanted_phase_name
				end

				local switch_anim_state = config.switch_anim_state

				if switch_anim_state then
					local animation_extension = ScriptUnit.extension(unit, "animation_system")

					animation_extension:anim_event(switch_anim_state)
				end

				local fx_system = self._fx_system
				local global_effect_id = self._global_effect_id

				if global_effect_id then
					fx_system:stop_template_effect(global_effect_id)
				end

				local wanted_combat_range_config = self._combat_range_config[wanted_combat_range]
				local effect_template = wanted_combat_range_config.effect_template

				if effect_template then
					self._global_effect_id = fx_system:start_template_effect(effect_template, unit)
				end

				local sticky_time = config.sticky_time

				if sticky_time then
					behavior_component.combat_range_sticky_time = t + sticky_time
				end

				local enter_combat_range_flag = config.enter_combat_range_flag

				if enter_combat_range_flag then
					behavior_component.enter_combat_range_flag = true
				end

				local activate_slot_system = config.activate_slot_system
				local slot_system = Managers.state.extension:system("slot_system")

				slot_system:do_slot_search(unit, activate_slot_system)

				return
			end
		until true
	end
end

function _get_combat_range_switch_distance(config, target_unit)
	local locked_in_melee_distance = config.locked_in_melee_distance

	if locked_in_melee_distance then
		local attack_intensity_extension = ScriptUnit.extension(target_unit, "attack_intensity_system")
		local is_locked_in_melee = attack_intensity_extension:locked_in_melee()

		if is_locked_in_melee then
			return locked_in_melee_distance
		end
	end

	local target_weapon_type_distance = config.target_weapon_type_distance

	if target_weapon_type_distance then
		local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
		local target_breed = unit_data_extension:breed()

		if Breed.is_player(target_breed) then
			local visual_loadout_extension = ScriptUnit.extension(target_unit, "visual_loadout_system")
			local inventory_component = unit_data_extension:read_component("inventory")

			for weapon_type, distance in pairs(target_weapon_type_distance) do
				local equipped = PlayerUnitVisualLoadout.has_wielded_weapon_keyword(visual_loadout_extension, inventory_component, weapon_type)

				if equipped then
					return distance
				end
			end
		end
	end

	return config.distance
end

function _should_switch_combat_range(unit, blackboard, target_distance, config, target_unit, target_velocity_dot_duration)
	local return_on_target_velocity_dot_inverted = target_velocity_dot_duration and config.target_velocity_dot_duration_inverted

	if return_on_target_velocity_dot_inverted then
		if type(config.target_velocity_dot_duration_inverted) == "table" then
			local diff_switch_on_target_velocity_dot = Managers.state.difficulty:get_table_entry_by_challenge(config.target_velocity_dot_duration_inverted)

			if diff_switch_on_target_velocity_dot < target_velocity_dot_duration then
				return false
			end
		elseif config.target_velocity_dot_duration_inverted < target_velocity_dot_duration then
			return false
		end
	end

	local z_distance = math.abs(POSITION_LOOKUP[target_unit].z - POSITION_LOOKUP[unit].z)
	local operator = config.distance_operator
	local max_z_distance = config.max_z_distance

	if not max_z_distance or z_distance < max_z_distance then
		local switch_distance = _get_combat_range_switch_distance(config, target_unit)
		local switch_by_distance = operator == "greater" and switch_distance <= target_distance or operator == "lesser" and target_distance <= switch_distance

		if switch_by_distance then
			return true
		end
	end

	if config.switch_on_wait_slot then
		local slot_component = blackboard.slot

		if slot_component.is_waiting_on_slot then
			return true
		end
	end

	local switch_by_z_distance = config.z_distance and config.z_distance <= z_distance

	if switch_by_z_distance then
		return true
	end

	local switch_on_target_velocity_dot = target_velocity_dot_duration and config.target_velocity_dot_duration

	if switch_on_target_velocity_dot then
		if type(config.target_velocity_dot_duration) == "table" then
			local diff_switch_on_target_velocity_dot = Managers.state.difficulty:get_table_entry_by_challenge(config.target_velocity_dot_duration)

			return diff_switch_on_target_velocity_dot <= target_velocity_dot_duration
		else
			return config.target_velocity_dot_duration <= target_velocity_dot_duration
		end
	end
end

CombatRangeUserBehaviorExtension.update_minion_phase = function (self, unit, blackboard, dt, t)
	local phase_component = self._phase_component
	local is_phase_locked = phase_component.lock

	if is_phase_locked then
		return
	end

	local current_phase_name = phase_component.current_phase
	local wanted_phase_name = phase_component.wanted_phase
	local current_combat_range = self._behavior_component.combat_range
	local phases = self._phase_template[current_combat_range].phases

	if current_phase_name ~= wanted_phase_name then
		self:_switch_phase(t, phases, wanted_phase_name, current_combat_range)
	elseif phase_component.force_next_phase then
		phase_component.force_next_phase = false
		local next_phase_name = self:_get_next_phase(phases, current_phase_name)

		if next_phase_name then
			self:_switch_phase(t, phases, next_phase_name, current_combat_range)
		end
	elseif phase_component.exit_phase_t < t then
		local next_phase_name = self:_get_next_phase(phases, current_phase_name)

		if next_phase_name then
			self:_switch_phase(t, phases, next_phase_name, current_combat_range)
		end
	end
end

local TEMP_PHASE_NAMES = {}

CombatRangeUserBehaviorExtension._get_next_phase = function (self, phases, current_phase_name)
	table.keys(phases, TEMP_PHASE_NAMES)

	local old_phase_index = table.index_of(TEMP_PHASE_NAMES, current_phase_name)

	if old_phase_index ~= -1 then
		table.swap_delete(TEMP_PHASE_NAMES, old_phase_index)
	end

	local num_phase_names = #TEMP_PHASE_NAMES

	if num_phase_names <= 0 then
		return nil
	end

	local next_phase_index = math.random(num_phase_names)
	local next_phase_name = TEMP_PHASE_NAMES[next_phase_index]

	table.clear_array(TEMP_PHASE_NAMES, num_phase_names)

	return next_phase_name
end

CombatRangeUserBehaviorExtension._switch_phase = function (self, t, phases, wanted_phase_name, wanted_combat_range)
	local next_phase = phases[wanted_phase_name]
	local wanted_weapon_slot = next_phase.wanted_weapon_slot

	if wanted_weapon_slot then
		local weapon_switch_component = self._weapon_switch_component
		weapon_switch_component.wanted_weapon_slot = wanted_weapon_slot
		weapon_switch_component.wanted_combat_range = wanted_combat_range
	end

	local duration = next_phase.duration or math.huge

	if type(duration) == "table" then
		duration = math.random_range(duration[1], duration[2])
	end

	local exit_phase_t = t + duration
	local phase_component = self._phase_component
	phase_component.exit_phase_t = exit_phase_t
	phase_component.current_phase = wanted_phase_name
	phase_component.wanted_phase = wanted_phase_name
end

return CombatRangeUserBehaviorExtension
