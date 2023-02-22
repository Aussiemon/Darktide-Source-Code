local AttackIntensitySettings = require("scripts/settings/attack_intensity/attack_intensity_settings")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local MinionRagdoll = require("scripts/managers/minion/minion_ragdoll")
local Suppression = require("scripts/utilities/attack/suppression")
local Vo = require("scripts/utilities/vo")
local proc_events = BuffSettings.proc_events
local MinionDeathManager = class("MinionDeathManager")
local _trigger_kill_vo, _trigger_on_kill_procs = nil
local CLIENT_RPCS = {
	"rpc_minion_set_dead"
}

MinionDeathManager.init = function (self, is_server, network_event_delegate, soft_cap_out_of_bounds_units)
	self._is_server = is_server
	self._minion_ragdoll = MinionRagdoll:new()
	self._soft_cap_out_of_bounds_units = soft_cap_out_of_bounds_units
	self._minions_awaiting_death = {}
	self._network_event_delegate = network_event_delegate

	if not is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

MinionDeathManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

MinionDeathManager.delete_units = function (self)
	self._minion_ragdoll:cleanup_ragdolls()
end

local INSTANT_RAGDOLL_STAGGER_TYPES = {
	explosion = true,
	running = true,
	heavy = true
}

MinionDeathManager.die = function (self, unit, attacking_unit_or_nil, attack_direction, hit_zone_name_or_nil, damage_profile, attack_type_or_nil, herding_template_or_nil, damage_type_or_nil)
	local blackboard = BLACKBOARDS[unit]
	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.attack_direction:store(attack_direction)

	death_component.hit_zone_name = hit_zone_name_or_nil
	local damage_profile_name = damage_profile.name
	death_component.damage_profile_name = damage_profile_name
	death_component.herding_template_name = herding_template_or_nil and herding_template_or_nil.name or nil
	death_component.killing_damage_type = damage_type_or_nil
	local was_alive = not death_component.is_dead

	if was_alive then
		local health_extension = ScriptUnit.extension(unit, "health_system")

		health_extension:kill()

		death_component.is_dead = true
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()

		_trigger_kill_vo(unit, attacking_unit_or_nil, hit_zone_name_or_nil, attack_type_or_nil, damage_profile_name)
		_trigger_on_kill_procs(unit, breed, attacking_unit_or_nil, attack_type_or_nil, damage_profile)

		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
		local inventory_slots = visual_loadout_extension:inventory_slots()

		for slot_name, slot_data in pairs(inventory_slots) do
			if slot_data.drop_on_death and visual_loadout_extension:can_drop_slot(slot_name) then
				visual_loadout_extension:drop_slot(slot_name)
			end
		end

		visual_loadout_extension:send_on_death_event()

		local hit_zones = breed.hit_zones

		for i = 1, #hit_zones do
			local hit_zone = hit_zones[i]

			if hit_zone.destroy_on_death then
				unit_data_extension:destroy_hit_zone(hit_zone.name)
			end
		end

		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local is_smart_objecting = navigation_extension:is_using_smart_object()

		if is_smart_objecting then
			death_component.force_instant_ragdoll = true
		else
			local stagger_component = blackboard.stagger
			local stagger_type = stagger_component.type
			local num_triggered_staggers = stagger_component.num_triggered_staggers

			if num_triggered_staggers > 0 and INSTANT_RAGDOLL_STAGGER_TYPES[stagger_type] or stagger_component.controlled_stagger then
				death_component.force_instant_ragdoll = true
			end
		end

		Managers.state.pacing:remove_aggroed_minion(unit)

		if Managers.stats.can_record_stats() and breed.is_boss then
			local boss_max_health = health_extension:max_health()
			local boss_unit_id = Managers.state.unit_spawner:game_object_id(unit)
			local boss_extension = ScriptUnit.extension(unit, "boss_system")
			local time_since_first_damage = boss_extension:time_since_first_damage()

			Managers.stats:record_boss_death(boss_max_health, boss_unit_id, breed.name, time_since_first_damage)
		end
	else
		death_component.hit_during_death = true
	end
end

local extensions_to_keep = {
	MinionUnitDataExtension = "unit_data_system",
	MinionBuffExtension = "buff_system",
	AIProximityExtension = "legacy_v2_proximity_system",
	FadeExtension = "fade_system",
	MinionVisualLoadoutExtension = "visual_loadout_system",
	WoundsExtension = "wounds_system",
	MinionDissolveExtension = "dissolve_system"
}

MinionDeathManager.set_dead = function (self, unit, attack_direction, hit_zone_name, damage_profile_name, do_ragdoll_push, herding_template_name)
	local minions_awaiting_death = self._minions_awaiting_death
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local death_velocity = breed.use_death_velocity and Vector3Box(ScriptUnit.extension(unit, "locomotion_system"):current_velocity())
	local death_data = {
		unit = unit,
		attack_direction = Vector3Box(attack_direction),
		hit_zone_name = hit_zone_name,
		damage_profile_name = damage_profile_name,
		do_ragdoll_push = do_ragdoll_push,
		herding_template_name = herding_template_name,
		death_velocity = death_velocity
	}

	Unit.flow_event(unit, "on_death")

	local dialogue_extension = ScriptUnit.has_extension(unit, "dialogue_system")

	if dialogue_extension then
		dialogue_extension:stop_currently_playing_vo()
	end

	if self._is_server then
		minions_awaiting_death[#minions_awaiting_death + 1] = death_data
	else
		minions_awaiting_death[unit] = death_data
	end

	unit_data_extension:set_owned_by_death_manager(true)
end

MinionDeathManager.update = function (self, dt, t)
	self._minion_ragdoll:update(self._soft_cap_out_of_bounds_units)

	if self._is_server then
		self:_server_update_minions_awaiting_death(t)
	end
end

MinionDeathManager._server_update_minions_awaiting_death = function (self, t)
	local minions_awaiting_death = self._minions_awaiting_death
	local num_minions_awaiting_death = #minions_awaiting_death

	for i = 1, num_minions_awaiting_death do
		local death_data = minions_awaiting_death[i]

		self:_server_finalize_death(death_data)

		minions_awaiting_death[i] = nil
	end
end

MinionDeathManager._server_finalize_death = function (self, death_data)
	local unit = death_data.unit
	local unit_id = Managers.state.unit_spawner:game_object_id(unit)

	self:_remove_extensions_on_death(unit, unit_id)
	Managers.state.unit_spawner:make_network_unit_local_unit(unit)
	Managers.state.minion_spawn:unregister_unit(unit)

	if DEDICATED_SERVER then
		Managers.state.unit_spawner:mark_for_deletion(unit)
	else
		self._minion_ragdoll:create_ragdoll(death_data)
	end
end

MinionDeathManager._remove_extensions_on_death = function (self, unit, unit_id)
	local extension_manager = Managers.state.extension

	extension_manager:remove_all_extensions_from_unit_except(unit, extensions_to_keep)

	for extension_name, system_name in pairs(extensions_to_keep) do
		if ScriptUnit.has_extension(unit, system_name) then
			local system = extension_manager:system(system_name)

			system:set_unit_local(unit)
		end
	end
end

MinionDeathManager.client_finalize_death = function (self, unit, unit_id)
	self:_remove_extensions_on_death(unit, unit_id)

	local death_data = self._minions_awaiting_death[unit]

	self._minion_ragdoll:create_ragdoll(death_data)

	self._minions_awaiting_death[unit] = nil
end

MinionDeathManager.rpc_minion_set_dead = function (self, channel_id, unit_id, attack_direction, hit_zone_id, damage_profile_id, do_ragdoll_push, herding_template_id_or_nil)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local hit_zone_name = hit_zone_id and NetworkLookup.hit_zones[hit_zone_id]
	local damage_profile_name = NetworkLookup.damage_profile_templates[damage_profile_id]
	local herding_template_name = herding_template_id_or_nil and NetworkLookup.herding_templates[herding_template_id_or_nil]

	self:set_dead(unit, attack_direction, hit_zone_name, damage_profile_name, do_ragdoll_push, herding_template_name)
end

MinionDeathManager.minion_ragdoll = function (self)
	return self._minion_ragdoll
end

function _trigger_kill_vo(unit, attacking_unit_or_nil, hit_zone_name_or_nil, attack_type_or_nil, damage_profile_name)
	if attacking_unit_or_nil == nil then
		return
	end

	Vo.enemy_kill_event(attacking_unit_or_nil, unit)

	if attack_type_or_nil == AttackSettings.attack_types.ranged and hit_zone_name_or_nil == "head" then
		local attacking_unit_position = POSITION_LOOKUP[attacking_unit_or_nil]
		local unit_position = POSITION_LOOKUP[unit]
		local distance = Vector3.distance(unit_position, attacking_unit_position)

		Vo.head_shot_event(attacking_unit_or_nil, distance, damage_profile_name)
	end
end

local locked_in_melee_settings = AttackIntensitySettings.locked_in_melee_settings
local MAX_TENSION_TO_ADD_DEATH_TENSION = 50
local CHALLENGE_RATING_TENSION_MULTIPLIER = 0.75

function _trigger_on_kill_procs(unit, breed, attacking_unit_or_nil, attack_type_or_nil, damage_profile)
	local pacing_manager = Managers.state.pacing

	if pacing_manager:tension() < MAX_TENSION_TO_ADD_DEATH_TENSION then
		local tension = breed.challenge_rating * CHALLENGE_RATING_TENSION_MULTIPLIER

		pacing_manager:add_tension(tension, attacking_unit_or_nil)
	end

	local attacking_unit_data_extension = attacking_unit_or_nil and ScriptUnit.has_extension(attacking_unit_or_nil, "unit_data_system")
	local attacking_unit_breed = attacking_unit_data_extension and attacking_unit_data_extension:breed()

	if Breed.is_player(attacking_unit_breed) then
		local attack_intensity_extension = ScriptUnit.extension(attacking_unit_or_nil, "attack_intensity_system")

		if attacking_unit_or_nil and attack_type_or_nil == AttackSettings.attack_types.melee then
			local kill_delay = Managers.state.difficulty:get_table_entry_by_challenge(locked_in_melee_settings.default_melee_kill_delay)

			attack_intensity_extension:add_to_locked_in_melee_timer(kill_delay)
		elseif attacking_unit_or_nil and attack_type_or_nil == AttackSettings.attack_types.ranged then
			attack_intensity_extension:reset_locked_in_melee_timer()
		end
	end

	local side_system = Managers.state.extension:system("side_system")
	local victim_position = POSITION_LOOKUP[unit]
	local attacking_side = side_system.side_by_unit[attacking_unit_or_nil]
	local on_kill_area_suppression = damage_profile.on_kill_area_suppression

	if on_kill_area_suppression and attacking_side then
		local lerp_values = DamageProfile.lerp_values(damage_profile, attacking_unit_or_nil)
		lerp_values = DamageProfile.progress_lerp_values_path(lerp_values, "on_kill_area_suppression")
		local optional_relation, optional_include_self = nil

		Suppression.apply_area_minion_suppression(attacking_unit_or_nil, on_kill_area_suppression, victim_position, optional_relation, optional_include_self, lerp_values)
	end

	local victim_side = side_system.side_by_unit[unit]
	local player_units = victim_side.valid_enemy_player_units

	for i = 1, #player_units do
		local player_unit = player_units[i]
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension then
			local param_table = buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.dying_unit = unit
				param_table.attacking_unit = attacking_unit_or_nil
				param_table.attack_type = attack_type_or_nil
				param_table.damage_profile_name = damage_profile.name
				param_table.damage_type = damage_profile.damage_type
				param_table.breed_name = breed.name
				param_table.side_name = victim_side:name()
				param_table.position = Vector3Box(victim_position)

				buff_extension:add_proc_event(proc_events.on_minion_death, param_table)
			end
		end
	end
end

return MinionDeathManager
