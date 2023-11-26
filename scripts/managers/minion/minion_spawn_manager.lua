-- chunkname: @scripts/managers/minion/minion_spawn_manager.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breeds = require("scripts/settings/breed/breeds")
local DialogueBreedSettings = require("scripts/settings/dialogue/dialogue_breed_settings")
local MinionSpawnManagerTestify = GameParameters.testify and require("scripts/managers/minion/minion_spawn_manager_testify")
local Vo = require("scripts/utilities/vo")
local MinionSpawnManager = class("MinionSpawnManager")
local MINION_QUEUE_RING_BUFFER_SIZE = 256
local MINION_QUEUE_PARAMETERS = table.enum("breed_name", "position", "rotation", "side_id", "optional_aggro_state", "optional_target_unit", "optional_spawner_unit", "optional_group_id", "optional_mission_objective_id", "optional_attack_selection_template_name")

MinionSpawnManager.init = function (self, level_seed, soft_cap_out_of_bounds_units, network_event_delegate)
	self._seed = level_seed
	self._spawned_minions = {}
	self._spawned_minions_index_lookup = {}
	self._num_spawned_minions = 0
	self._side_system = Managers.state.extension:system("side_system")
	self._soft_cap_out_of_bounds_units = soft_cap_out_of_bounds_units

	local spawn_queue = Script.new_array(MINION_QUEUE_RING_BUFFER_SIZE)

	for i = 1, MINION_QUEUE_RING_BUFFER_SIZE do
		spawn_queue[i] = Script.new_array(#MINION_QUEUE_PARAMETERS)
	end

	self._spawn_queue = spawn_queue
	self._spawn_queue_read_index = 1
	self._spawn_queue_write_index = 1
	self._spawn_queue_size = 0
end

MinionSpawnManager.delete_units = function (self)
	local spawned_minions = self._spawned_minions
	local num_spawned = self._num_spawned_minions

	for i = num_spawned, 1, -1 do
		local minion_unit = spawned_minions[i]

		self:despawn(minion_unit)
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
			self:despawn(unit)
		end
	end
end

local TEMP_INIT_DATA = {}

MinionSpawnManager.spawn_minion = function (self, breed_name, position, rotation, side_id, optional_aggro_state, optional_target_unit, optional_spawner_unit, optional_group_id, optional_mission_objective_id, optional_attack_selection_template_name, optional_health_modifier, optional_spawner_spawn_index)
	local breed = Breeds[breed_name]
	local seed = math.random_seed(self._seed)
	local spawn_aggro_state = optional_aggro_state or breed.spawn_aggro_state

	TEMP_INIT_DATA.side_id = side_id
	TEMP_INIT_DATA.breed = breed
	TEMP_INIT_DATA.random_seed = seed
	TEMP_INIT_DATA.optional_aggro_state = spawn_aggro_state
	TEMP_INIT_DATA.optional_target_unit = optional_target_unit
	TEMP_INIT_DATA.optional_group_id = optional_group_id
	TEMP_INIT_DATA.optional_mission_objective_id = optional_mission_objective_id
	TEMP_INIT_DATA.optional_attack_selection_template_name = optional_attack_selection_template_name
	TEMP_INIT_DATA.optional_health_modifier = optional_health_modifier

	local unit_template_name = breed.unit_template_name
	local unit = Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, position, rotation, nil, TEMP_INIT_DATA)

	self._seed = seed

	local spawned_index = #self._spawned_minions + 1

	self._spawned_minions[spawned_index] = unit
	self._spawned_minions_index_lookup[unit] = spawned_index
	self._num_spawned_minions = self._num_spawned_minions + 1

	local spawn_anim_state = breed.spawn_anim_state

	if spawn_anim_state then
		local animation_extension = ScriptUnit.extension(unit, "animation_system")

		animation_extension:anim_event(spawn_anim_state)
	end

	local blackboard = BLACKBOARDS[unit]

	self:_initialize_inventory(unit, breed, blackboard, optional_attack_selection_template_name)
	self:_initialize_blackboard_components(breed, blackboard, seed, optional_spawner_unit, optional_spawner_spawn_index)

	if optional_mission_objective_id then
		self:_register_minion_to_objective(unit, optional_mission_objective_id)
	end

	local vo_breed_settings = DialogueBreedSettings[breed_name]
	local spawn_vo_event = vo_breed_settings and vo_breed_settings.spawn_vo_event

	if spawn_vo_event then
		Vo.enemy_generic_vo_event(unit, spawn_vo_event, breed.name)
	end

	if DEDICATED_SERVER then
		Managers.telemetry_reporters:reporter("enemy_spawns"):register_event(breed)
	end

	Managers.event:trigger("minion_unit_spawned", unit)

	return unit
end

MinionSpawnManager.queue_minion_to_spawn = function (self, breed_name, position, rotation, side_id, optional_aggro_state, optional_target_unit, optional_spawner_unit, optional_group_id, optional_mission_objective_id, optional_attack_selection_template_name)
	local queue = self._spawn_queue
	local write_index = self._spawn_queue_write_index
	local queue_entry = queue[write_index]

	queue_entry[MINION_QUEUE_PARAMETERS.breed_name] = breed_name
	queue_entry[MINION_QUEUE_PARAMETERS.position] = Vector3Box(position)
	queue_entry[MINION_QUEUE_PARAMETERS.rotation] = QuaternionBox(rotation)
	queue_entry[MINION_QUEUE_PARAMETERS.side_id] = side_id
	queue_entry[MINION_QUEUE_PARAMETERS.optional_aggro_state] = optional_aggro_state
	queue_entry[MINION_QUEUE_PARAMETERS.optional_target_unit] = optional_target_unit
	queue_entry[MINION_QUEUE_PARAMETERS.optional_spawner_unit] = optional_spawner_unit
	queue_entry[MINION_QUEUE_PARAMETERS.optional_group_id] = optional_group_id
	queue_entry[MINION_QUEUE_PARAMETERS.optional_mission_objective_id] = optional_mission_objective_id
	queue_entry[MINION_QUEUE_PARAMETERS.optional_attack_selection_template_name] = optional_attack_selection_template_name
	self._spawn_queue_write_index = write_index % MINION_QUEUE_RING_BUFFER_SIZE + 1
	self._spawn_queue_size = self._spawn_queue_size + 1
end

MinionSpawnManager._update_spawn_queue = function (self)
	local size = self._spawn_queue_size

	if size == 0 then
		return
	end

	local queue = self._spawn_queue
	local read_index = self._spawn_queue_read_index
	local queue_entry = queue[read_index]

	self:spawn_minion(queue_entry[MINION_QUEUE_PARAMETERS.breed_name], queue_entry[MINION_QUEUE_PARAMETERS.position]:unbox(), queue_entry[MINION_QUEUE_PARAMETERS.rotation]:unbox(), queue_entry[MINION_QUEUE_PARAMETERS.side_id], queue_entry[MINION_QUEUE_PARAMETERS.optional_aggro_state], queue_entry[MINION_QUEUE_PARAMETERS.optional_target_unit], queue_entry[MINION_QUEUE_PARAMETERS.optional_spawner_unit], queue_entry[MINION_QUEUE_PARAMETERS.optional_group_id], queue_entry[MINION_QUEUE_PARAMETERS.optional_mission_objective_id], queue_entry[MINION_QUEUE_PARAMETERS.optional_attack_selection_template_name])

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

		self:despawn(minion_unit)
	end
end

MinionSpawnManager.despawn = function (self, unit)
	local success = self:unregister_unit(unit)

	if success then
		Managers.state.pacing:remove_aggroed_minion(unit)
		Managers.state.unit_spawner:mark_for_deletion(unit)
	else
		Log.warning("MinionSpawnManager", "Tried to despawn a minion twice. Might be due to locomotion system deleting a unit outside of world. Poke Morja if this gets spammed for the same unit.")
	end
end

MinionSpawnManager.num_spawned_minions = function (self)
	return self._num_spawned_minions
end

return MinionSpawnManager
