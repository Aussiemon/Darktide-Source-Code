local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_efficiencies = AttackSettings.damage_efficiencies
local mood_types = MoodSettings.mood_types
local AttackReportManager = class("AttackReportManager")
local _trigger_hit_events, _trigger_damage_indicator, _play_camera_effect_shake_event = nil
local PI = math.pi
local DAMAGE_INDICATOR_ATTACK_RESULTS = {
	[attack_results.damaged] = true,
	[attack_results.toughness_absorbed] = true,
	[attack_results.toughness_absorbed_melee] = true,
	[attack_results.toughness_broken] = true,
	[attack_results.friendly_fire] = true,
	[attack_results.blocked] = true
}
local RING_BUFFER_SIZE = 2048
local MAX_UPDATES_PER_FRAME = 64
local CLIENT_RPCS = {
	"rpc_add_attack_result"
}

AttackReportManager.init = function (self, is_server, network_event_delegate)
	self._is_server = is_server

	if not is_server then
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))

		self._network_event_delegate = network_event_delegate
	end

	local ring_buffer = Script.new_array(RING_BUFFER_SIZE)

	for i = 1, RING_BUFFER_SIZE do
		ring_buffer[i] = {
			hit_weakspot = false,
			damage = 0,
			absorbed_damage = 0,
			attack_direction = Vector3Box(),
			hit_world_position = Vector3Box(),
			attack_result = attack_results.died,
			attack_type = attack_types.melee,
			damage_efficiency = damage_efficiencies.full
		}
	end

	self._ring_buffer = ring_buffer
	self._write_index = 1
	self._read_index = 1
	self._buffer_size = 0
end

AttackReportManager.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

AttackReportManager.update = function (self, dt, t)
	local ring_buffer = self._ring_buffer
	local size = self._buffer_size

	if size <= 0 then
		return
	end

	if self._is_server then
		local lowest_reliable_buffer_size = Managers.state.game_session:currently_lowest_reliable_send_buffer_size()

		if lowest_reliable_buffer_size < 8000 then
			return
		end
	end

	local num_updates = math.min(MAX_UPDATES_PER_FRAME, size)
	local read_index = self._read_index

	for i = 1, num_updates do
		local buffer_data = ring_buffer[read_index]

		self:_process_attack_result(buffer_data)

		read_index = read_index % RING_BUFFER_SIZE + 1
		size = size - 1
	end

	self._buffer_size = size
	self._read_index = read_index
end

AttackReportManager.add_attack_result = function (self, damage_profile, attacked_unit, attacking_unit, attack_direction, hit_world_position, hit_weakspot, damage, attack_result, attack_type, damage_efficiency, is_critical_strike)
	local ring_buffer = self._ring_buffer
	local read_index = self._read_index
	local write_index = self._write_index
	local size = self._buffer_size

	Log.debug("AttackReportManager", "Added attack result damage_profile: %q attacked_unit: %q attacking_unit: %q attack_direction: %q hit_weakspot: %q damage: %q attack_result: %q attack_type: %q damage_efficiency: %q", damage_profile.name, attacked_unit, attacking_unit, attack_direction, hit_weakspot, damage, attack_result, attack_type, damage_efficiency)

	if RING_BUFFER_SIZE < size + 1 then
		local buffer_data = ring_buffer[read_index]

		self:_process_attack_result(buffer_data)

		read_index = read_index % RING_BUFFER_SIZE + 1
		size = size - 1

		Log.debug("AttackReportManager", "Force advance ring buffer. new read index: %i", read_index)
	end

	local buffer_data = ring_buffer[write_index]
	buffer_data.damage_profile = damage_profile
	buffer_data.attacked_unit = attacked_unit
	buffer_data.attacking_unit = attacking_unit

	buffer_data.attack_direction:store(attack_direction)

	if hit_world_position and buffer_data.hit_world_position then
		buffer_data.hit_world_position:store(hit_world_position)
	elseif hit_world_position and not buffer_data.hit_world_position then
		buffer_data.hit_world_position = Vector3Box(hit_world_position)
	else
		buffer_data.hit_world_position = nil
	end

	buffer_data.hit_weakspot = hit_weakspot
	buffer_data.damage = damage
	buffer_data.attack_result = attack_result
	buffer_data.attack_type = attack_type
	buffer_data.damage_efficiency = damage_efficiency
	buffer_data.is_critical_strike = is_critical_strike
	self._buffer_size = size + 1
	self._write_index = write_index % RING_BUFFER_SIZE + 1
	self._read_index = read_index
end

AttackReportManager.rpc_add_attack_result = function (self, channel_id, damage_profile_id, attacked_unit_id, attacked_unit_is_level_unit, attacking_unit_id, attack_direction, hit_world_position, hit_weakspot, damage, attack_result_id, attack_type_id, damage_efficiency_id, is_critical_strike)
	local unit_spawner_manager = Managers.state.unit_spawner
	local attacked_unit = attacked_unit_id and unit_spawner_manager:unit(attacked_unit_id, attacked_unit_is_level_unit)
	local attacking_unit = attacking_unit_id and unit_spawner_manager:unit(attacking_unit_id)
	local attack_result = NetworkLookup.attack_results[attack_result_id]
	local attack_type = attack_type_id and NetworkLookup.attack_types[attack_type_id]
	local damage_efficiency = damage_efficiency_id and NetworkLookup.damage_efficiencies[damage_efficiency_id]
	local damage_profile_name = NetworkLookup.damage_profile_templates[damage_profile_id]
	local damage_profile = DamageProfileTemplates[damage_profile_name]

	self:add_attack_result(damage_profile, attacked_unit, attacking_unit, attack_direction, hit_world_position, hit_weakspot, damage, attack_result, attack_type, damage_efficiency, is_critical_strike)
end

AttackReportManager._process_attack_result = function (self, buffer_data)
	local attacked_unit = buffer_data.attacked_unit
	local attacking_unit = buffer_data.attacking_unit
	local attack_direction = buffer_data.attack_direction:unbox()
	local hit_world_position = buffer_data.hit_world_position and buffer_data.hit_world_position:unbox()
	local damage = buffer_data.damage
	local hit_weakspot = buffer_data.hit_weakspot
	local attack_result = buffer_data.attack_result
	local attack_type = buffer_data.attack_type
	local damage_profile = buffer_data.damage_profile
	local damage_efficiency = buffer_data.damage_efficiency
	local is_critical_strike = buffer_data.is_critical_strike
	local did_damage = damage > 0
	local player_unit_spawn_manager = Managers.state.player_unit_spawn
	local attacking_player = attacking_unit and player_unit_spawn_manager:owner(attacking_unit)

	if attacked_unit then
		local attacked_player = player_unit_spawn_manager:owner(attacked_unit)

		if attacked_player then
			local first_person_extension = ScriptUnit.extension(attacked_unit, "first_person_system")
			local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

			if not attacked_player.remote and attacked_player:is_human_controlled() or is_in_first_person_mode then
				_trigger_damage_indicator(attacked_unit, attacking_unit, attack_direction, attack_result, damage_profile, is_critical_strike)
			end
		end
	end

	local unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local breed_or_nil = unit_data_extension and unit_data_extension:breed()

	if attacking_player then
		local first_person_extension = ScriptUnit.has_extension(attacking_unit, "first_person_system")
		local local_human = not attacking_player.remote and attacking_player:is_human_controlled()
		local is_in_first_person_mode = first_person_extension and first_person_extension:is_in_first_person_mode()

		_trigger_hit_events(local_human, is_in_first_person_mode, attacking_unit, attack_result, did_damage, hit_weakspot, hit_world_position, damage_efficiency, is_critical_strike, damage_profile)

		local tags = breed_or_nil and breed_or_nil.tags
		local allowed_breed = tags and (tags.monster or tags.special or tags.elite)

		if allowed_breed and attack_result == attack_results.died then
			Managers.event:trigger("event_combat_feed_kill", attacking_unit, attacked_unit)
		end
	end

	if self._is_server then
		local target_unit_alive = ALIVE[attacked_unit]

		if not target_unit_alive then
			attacked_unit = nil
		end

		local target_is_minion = Breed.is_minion(breed_or_nil)

		if target_is_minion then
			local owned_by_death_manager = unit_data_extension:is_owned_by_death_manager()

			if owned_by_death_manager then
				attacked_unit = nil
			end
		end

		local unit_spawner_manager = Managers.state.unit_spawner
		local attacking_unit_id = attacking_unit and unit_spawner_manager:game_object_id(attacking_unit)
		local attacked_unit_is_level_unit, attacked_unit_id = nil

		if attacked_unit then
			attacked_unit_is_level_unit, attacked_unit_id = unit_spawner_manager:game_object_id_or_level_index(attacked_unit)
		end

		local attack_result_id = NetworkLookup.attack_results[attack_result]
		local attack_type_id = attack_type and NetworkLookup.attack_types[attack_type]
		local damage_profile_id = NetworkLookup.damage_profile_templates[damage_profile.name]
		local damage_efficiency_id = damage_efficiency and NetworkLookup.damage_efficiencies[damage_efficiency]

		Managers.state.game_session:send_rpc_clients("rpc_add_attack_result", damage_profile_id, attacked_unit_id, not not attacked_unit_is_level_unit, attacking_unit_id, attack_direction, hit_world_position, hit_weakspot, damage, attack_result_id, attack_type_id, damage_efficiency_id, is_critical_strike)
	end
end

function _trigger_hit_events(local_human, is_in_first_person_mode, attacking_unit, attack_result, did_damage, hit_weakspot, hit_world_position, damage_efficiency, is_critical_strike, damage_profile)
	if (local_human or is_in_first_person_mode) and (hit_world_position or attack_result == attack_results.died) then
		Managers.event:trigger("event_crosshair_hit_report", hit_weakspot, attack_result, did_damage, hit_world_position, damage_efficiency, is_critical_strike)
	end

	if local_human or is_in_first_person_mode then
		_play_camera_effect_shake_event(attacking_unit, damage_profile)
	end

	Managers.event:trigger("event_on_player_hit", attacking_unit, attack_result, did_damage, hit_weakspot, hit_world_position, damage_efficiency, is_critical_strike, damage_profile)
end

function _trigger_damage_indicator(attacked_unit, attacking_unit, attack_direction, attack_result, damage_profile, is_critical_strike)
	if not DAMAGE_INDICATOR_ATTACK_RESULTS[attack_result] then
		return
	end

	local target_unit_data_extension = ScriptUnit.has_extension(attacked_unit, "unit_data_system")
	local breed_or_nil = target_unit_data_extension and target_unit_data_extension:breed()
	local target_is_player = Breed.is_player(breed_or_nil)

	if not target_is_player then
		return
	end

	local unit_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
	local first_person_component = unit_data_extension:read_component("first_person")
	local rotation = first_person_component.rotation
	local forward = Quaternion.forward(rotation)
	forward.z = 0
	local forward_dot_dir = Vector3.dot(forward, attack_direction)
	local right_dot_dir = Vector3.dot(Quaternion.right(rotation), attack_direction)
	local angle = math.atan2(right_dot_dir, forward_dot_dir)
	angle = angle + PI

	if attacking_unit and attacked_unit ~= attacking_unit then
		Managers.event:trigger("spawn_hud_damage_indicator", angle, attack_result)
	end

	if not damage_profile.ignore_mood_effects then
		local mood_extension = ScriptUnit.has_extension(attacked_unit, "mood_system")

		if mood_extension then
			local permanent_damage_ratio = damage_profile.permanent_damage_ratio
			local have_permanent_damage = permanent_damage_ratio and permanent_damage_ratio > 0
			local have_normal_damage = not permanent_damage_ratio or permanent_damage_ratio < 1
			local t = Managers.time:time("gameplay")
			local skip_rpc = true

			if attack_result == attack_results.damaged then
				if have_normal_damage then
					mood_extension:add_timed_mood(t, mood_types.damage_taken, skip_rpc)
				end

				if have_permanent_damage then
					mood_extension:add_timed_mood(t, mood_types.corruption_taken, skip_rpc)
				end
			elseif attack_result == attack_results.toughness_broken then
				mood_extension:add_timed_mood(t, mood_types.toughness_broken, skip_rpc)
				mood_extension:add_timed_mood(t, mood_types.toughness_absorbed, skip_rpc)
			elseif attack_result == attack_results.toughness_absorbed or attack_result == attack_results.toughness_absorbed_melee then
				mood_extension:add_timed_mood(t, mood_types.toughness_absorbed, skip_rpc)
			end
		end
	end
end

function _play_camera_effect_shake_event(attacking_unit, damage_profile)
	local attacker_impact_effects = damage_profile.attacker_impact_effects

	if not attacker_impact_effects then
		return
	end

	local camera_effect_shake_event = attacker_impact_effects.camera_effect_shake_event

	if not camera_effect_shake_event then
		return
	end

	local camera_extension = ScriptUnit.has_extension(attacking_unit, "camera_system")

	if not camera_extension then
		return
	end

	local will_be_predicted = false

	camera_extension:trigger_camera_shake(camera_effect_shake_event, will_be_predicted)
end

return AttackReportManager
