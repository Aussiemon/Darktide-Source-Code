-- chunkname: @scripts/managers/minion/minion_spawn_manager.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local MinionSpawnManagerTestify = GameParameters.testify and require("scripts/managers/minion/minion_spawn_manager_testify")
local Vo = require("scripts/utilities/vo")
local MinionSpawnManager = class("MinionSpawnManager")
local MINION_QUEUE_RING_BUFFER_SIZE = 256

MinionSpawnManager.init = function (self, level_seed, soft_cap_out_of_bounds_units, network_event_delegate)
	self._seed = level_seed
	self._spawned_minions = {}
	self._spawned_minions_index_lookup = {}
	self._num_spawned_minions = 0
	self._minions_with_owners = {}
	self._side_system = Managers.state.extension:system("side_system")
	self._soft_cap_out_of_bounds_units = soft_cap_out_of_bounds_units

	local spawn_queue = Script.new_array(MINION_QUEUE_RING_BUFFER_SIZE)

	for i = 1, MINION_QUEUE_RING_BUFFER_SIZE do
		spawn_queue[i] = {}
	end

	self._spawn_queue = spawn_queue
	self._spawn_queue_read_index = 1
	self._spawn_queue_write_index = 1
	self._spawn_queue_size = 0
end

MinionSpawnManager.mutator_breed_init = function (self, mutator_context)
	self._mutator_breed_data = mutator_context
end

MinionSpawnManager.replacement_breed = function (self, breed_name)
	local replacement_breed

	if self._mutator_breed_data then
		local breedlookup = self._mutator_breed_data.breed_replacement

		replacement_breed = breedlookup[breed_name]
	end

	return replacement_breed
end

MinionSpawnManager.delete_units = function (self)
	local spawned_minions = self._spawned_minions
	local num_spawned = self._num_spawned_minions

	for i = num_spawned, 1, -1 do
		local minion_unit = spawned_minions[i]

		self:despawn_minion(minion_unit)
	end
end

MinionSpawnManager.update = function (self, dt, t)
	self:_update_spawn_queue()

	if GameParameters.testify then
		Testify:poll_requests_through_handler(MinionSpawnManagerTestify, self)
	end

	local spawned_minions, soft_cap_out_of_bounds_units = self._spawned_minions, self._soft_cap_out_of_bounds_units

	for i = #spawned_minions, 1, -1 do
		local unit = spawned_minions[i]

		if soft_cap_out_of_bounds_units[unit] then
			Log.info("MinionSpawnManager", "%s is out-of-bounds, despawning (%s).", unit, tostring(POSITION_LOOKUP[unit]))
			self:despawn_minion(unit)

			if self._minions_with_owners[unit] then
				local unit_blackboard = BLACKBOARDS[unit]
				local behavior_component = Blackboard.write_component(unit_blackboard, "behavior")

				behavior_component.is_out_of_bound = true

				Managers.state.out_of_bounds:unregister_soft_oob_unit(unit, self)
			end
		end
	end
end

local TEMP_INIT_DATA = {}

MinionSpawnManager.request_param_table = function (self)
	table.clear(TEMP_INIT_DATA)

	return TEMP_INIT_DATA
end

MinionSpawnManager.spawn_minion = function (self, breed_name, position, rotation, side_id, optional_param_table)
	local replacement_breed = self:replacement_breed(breed_name)

	if replacement_breed then
		breed_name = replacement_breed
	end

	local temp_data = optional_param_table or self:request_param_table()
	local breed = Breeds[breed_name]
	local seed = math.random_seed(self._seed)

	temp_data.side_id = side_id
	temp_data.breed = breed
	temp_data.random_seed = seed
	temp_data.optional_aggro_state = temp_data.optional_aggro_state or breed.spawn_aggro_state

	local additional_health_modifier = Managers.state.havoc:minion_health_modifier(breed)
	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local game_mode_name = game_mode:name()

	if game_mode_name == "survival" then
		additional_health_modifier = game_mode:get_minion_health_modifier(breed)
	elseif game_mode_name == "coop_complete_objective" then
		local circumstance_template = Managers.state.circumstance:template()
		local circumstance_health_modifier = circumstance_template and circumstance_template.minion_health_modifier

		if circumstance_health_modifier then
			additional_health_modifier = circumstance_health_modifier
		end
	end

	if additional_health_modifier then
		temp_data.optional_health_modifier = (temp_data.optional_health_modifier or 1) + additional_health_modifier
	end

	local unit_template_name = breed.unit_template_name
	local unit = Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, rotation, nil, temp_data)

	self._seed = seed

	local spawned_index = #self._spawned_minions + 1

	self._spawned_minions[spawned_index] = unit
	self._spawned_minions_index_lookup[unit] = spawned_index
	self._num_spawned_minions = self._num_spawned_minions + 1

	if temp_data.optional_owner_player_unit then
		self._minions_with_owners[unit] = true
	end

	local spawn_anim_state = breed.spawn_anim_state

	if spawn_anim_state then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(spawn_anim_state)
	end

	local blackboard = BLACKBOARDS[unit]

	self:_initialize_inventory(unit, breed, blackboard, temp_data.optional_attack_selection_template_name)
	self:_initialize_blackboard_components(breed, blackboard, seed, temp_data.optional_spawner_unit, temp_data.optional_spawner_spawn_index)

	if temp_data.optional_mission_objective_id then
		self:_register_minion_to_objective(unit, temp_data.optional_mission_objective_id)
	end

	local vo_breed_settings = DialogueBreedSettings[breed_name]
	local spawn_vo_event = vo_breed_settings and vo_breed_settings.spawn_vo_event

	if spawn_vo_event then
		Vo.enemy_generic_vo_event(unit, spawn_vo_event, breed.name)
	end

	if DEDICATED_SERVER then
		Managers.telemetry_reporters:reporter("enemy_spawns"):register_event(breed)
	end

	local spawn_buff = breed.spawn_buff

	if spawn_buff then
		local t = Managers.time:time("gameplay")
		local buff_extension = ScriptUnit.extension(unit, "buff_system")

		buff_extension:add_internally_controlled_buff(spawn_buff, t)
	end

	Managers.event:trigger("minion_unit_spawned", unit)

	return unit
end

MinionSpawnManager.queue_minion_to_spawn = function (self, breed_name, position, rotation, side_id)
	local queue = self._spawn_queue
	local write_index = self._spawn_queue_write_index
	local queue_entry = queue[write_index]

	queue_entry.breed_name = breed_name
	queue_entry.position = Vector3Box(position)
	queue_entry.rotation = QuaternionBox(rotation)
	queue_entry.side_id = side_id
	self._spawn_queue_write_index = write_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size + 1

	return queue_entry
end

MinionSpawnManager._update_spawn_queue = function (self)
	local size = self._spawn_queue_size

	if size == 0 then
		return
	end

	local queue = self._spawn_queue
	local read_index = self._spawn_queue_read_index
	local queue_entry = queue[read_index]

	self:spawn_minion(queue_entry.breed_name, queue_entry.position:unbox(), queue_entry.rotation:unbox(), queue_entry.side_id, queue_entry)
	table.clear(queue_entry)

	self._spawn_queue_read_index = read_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size - 1
end

MinionSpawnManager._initialize_inventory = function (self, unit, breed, blackboard, optional_attack_selection_template_name)
	local spawn_inventory_slot = breed.spawn_inventory_slot

	if spawn_inventory_slot then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local has_wielded_weapon = visual_loadout_extension:wielded_slot_name()

		if not has_wielded_weapon then
			visual_loadout_extension:wield_slot(spawn_inventory_slot)
		end
	end
end

MinionSpawnManager._initialize_blackboard_components = function (self, breed, blackboard, seed, optional_spawner_unit, optional_spawner_spawn_index)
	local spawn_component = Blackboard.write_component(blackboard, "spawn")
	local size_variation_range = breed.size_variation_range

	if size_variation_range then
		local _, random_percentage = math.next_random(seed)
		local scale = math.lerp(size_variation_range[1], size_variation_range[2], random_percentage)

		spawn_component.anim_translation_scale_factor = 1 / scale
	end

	if optional_spawner_unit then
		spawn_component.is_exiting_spawner = true
		spawn_component.spawner_unit = optional_spawner_unit

		if optional_spawner_spawn_index then
			spawn_component.spawner_spawn_index = optional_spawner_spawn_index
		end
	end
end

MinionSpawnManager._register_minion_to_objective = function (self, unit, optional_mission_objective_id)
	local mission_objective_target_extension = ScriptUnit.has_extension(unit, "mission_objective_target_system")

	if mission_objective_target_extension then
		local objective_name = optional_mission_objective_id
		local ui_target_type = "default"
		local objective_stage = 1
		local add_marker_on_registration = true
		local add_marker_on_objective_start = false
		local enabled_only_during_mission = false
		local sync_to_clients = true

		mission_objective_target_extension:setup_from_external(objective_name, ui_target_type, objective_stage, add_marker_on_registration, add_marker_on_objective_start, enabled_only_during_mission, sync_to_clients)
	end
end

MinionSpawnManager.unregister_unit = function (self, unit)
	local spawned_minions_index_lookup = self._spawned_minions_index_lookup
	local index = spawned_minions_index_lookup[unit]

	if not index then
		return false
	end

	local spawned_minions = self._spawned_minions
	local last_index = #spawned_minions

	spawned_minions_index_lookup[unit] = nil

	if index == last_index then
		spawned_minions[last_index] = nil
	else
		local last_minion = spawned_minions[last_index]

		spawned_minions[index] = last_minion
		spawned_minions[last_index] = nil
		spawned_minions_index_lookup[last_minion] = index
	end

	self._num_spawned_minions = self._num_spawned_minions - 1

	return true
end

MinionSpawnManager.despawn_all_minions = function (self)
	local spawned_minions = self._spawned_minions

	for i = #spawned_minions, 1, -1 do
		local minion_unit = spawned_minions[i]

		self:despawn_minion(minion_unit)
	end
end

MinionSpawnManager.despawn_minion = function (self, unit)
	if self._minions_with_owners[unit] then
		return
	end

	local success = self:unregister_unit(unit)

	if success then
		Managers.state.pacing:remove_aggroed_minion(unit)
		Managers.state.unit_spawner:mark_for_deletion(unit)
	else
		Log.warning("MinionSpawnManager", "Tried to despawn a minion twice. Might be due to locomotion system deleting a unit outside of world. Poke Sebastian if this gets spammed for the same unit.")
	end
end

MinionSpawnManager.num_spawned_minions = function (self)
	return self._num_spawned_minions
end

MinionSpawnManager.spawned_minions = function (self)
	return self._spawned_minions
end

return MinionSpawnManager
