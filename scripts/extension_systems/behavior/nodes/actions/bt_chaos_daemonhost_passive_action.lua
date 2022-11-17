require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Daemonhost = require("scripts/utilities/daemonhost")
local DaemonhostSettings = require("scripts/settings/specials/daemonhost_settings")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Suppression = require("scripts/utilities/attack/suppression")
local Threat = require("scripts/utilities/threat")
local Vo = require("scripts/utilities/vo")
local STAGES = DaemonhostSettings.stages
local BtChaosDaemonhostPassiveAction = class("BtChaosDaemonhostPassiveAction", "BtNode")

BtChaosDaemonhostPassiveAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	scratchpad.side = side
	local spawn_component = blackboard.spawn
	scratchpad.spawn_component = spawn_component
	scratchpad.suppression_component = Blackboard.write_component(blackboard, "suppression")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.physics_world = spawn_component.physics_world
	local aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.aim_component = aim_component
	aim_component.controlled_aiming = true
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = animation_extension
	scratchpad.buff_extension = buff_extension
	scratchpad.health_extension = ScriptUnit.extension(unit, "health_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local current_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = current_rotation_speed
	scratchpad.next_flashed_fx_t = 0
	scratchpad.next_anger_t = 0
	scratchpad.anger = 0
	scratchpad.anger_tick = 0
	scratchpad.flashing_units = {}
	scratchpad.distance_threat_units = {}
	scratchpad.next_vo_trigger_t = 0

	Threat.set_threat_decay_enabled(unit, false)

	local spawn_anim_events = action_data.spawn_anim_events
	local spawn_anim = Animation.random_event(spawn_anim_events)

	animation_extension:anim_event(spawn_anim)

	scratchpad.spawn_anim = spawn_anim

	self:_switch_stage(unit, breed, scratchpad, action_data, STAGES.passive)

	local radius = action_data.nav_cost_map_sphere_radius
	local cost = action_data.nav_cost_map_sphere_cost
	local nav_cost_map_name = action_data.nav_cost_map_name
	local nav_cost_map_id = Managers.state.nav_mesh:nav_cost_map_id(nav_cost_map_name)
	local nav_cost_map_volume_id = Managers.state.nav_mesh:add_nav_cost_map_sphere_volume(POSITION_LOOKUP[unit], radius, cost, nav_cost_map_id)
	scratchpad.nav_cost_map_volume_id = nav_cost_map_volume_id
	scratchpad.nav_cost_map_id = nav_cost_map_id
	local on_enter_buff_names = action_data.on_enter_buff_names
	local num_on_enter_buff_names = #on_enter_buff_names
	local on_enter_buffs = Script.new_array(num_on_enter_buff_names)

	for i = 1, num_on_enter_buff_names do
		local buff_name = on_enter_buff_names[i]
		local _, buff_id = buff_extension:add_externally_controlled_buff(buff_name, t)
		on_enter_buffs[i] = buff_id
	end

	scratchpad.on_enter_buffs = on_enter_buffs
	scratchpad.old_anger = 0
	scratchpad.old_flashlight_flat = 0
	scratchpad.old_distance_flat = 0
	scratchpad.old_health_flat = 0
	scratchpad.old_suppression_flat = 0
	scratchpad.old_distance_tick = 0
	scratchpad.old_flashlight_tick = 0
end

BtChaosDaemonhostPassiveAction.init_values = function (self, blackboard, action_data, node_data)
	local statistics_component = Blackboard.write_component(blackboard, "statistics")
	statistics_component.valid_targets_on_aggro = 0
end

BtChaosDaemonhostPassiveAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local locomotion_extension = scratchpad.locomotion_extension
	local original_rotation_speed = scratchpad.original_rotation_speed

	locomotion_extension:set_rotation_speed(original_rotation_speed)

	if HEALTH_ALIVE[unit] then
		local perception_extension = scratchpad.perception_extension

		perception_extension:set_use_action_controlled_alert(false)
		MinionPerception.attempt_aggro(perception_extension)
		self:_switch_stage(unit, breed, scratchpad, action_data, STAGES.aggroed)

		local buff_extension = scratchpad.buff_extension
		local on_enter_buffs = scratchpad.on_enter_buffs

		for i = 1, #on_enter_buffs do
			local buff_id = on_enter_buffs[i]

			buff_extension:remove_externally_controlled_buff(buff_id)
		end

		local on_leave_buff_name = action_data.on_leave_buff_name

		buff_extension:add_internally_controlled_buff(on_leave_buff_name, t)
	end

	Threat.set_threat_decay_enabled(unit, true)

	local nav_cost_map_volume_id = scratchpad.nav_cost_map_volume_id
	local nav_cost_map_id = scratchpad.nav_cost_map_id

	Managers.state.nav_mesh:remove_nav_cost_map_volume(nav_cost_map_volume_id, nav_cost_map_id)

	local statistics_component = Blackboard.write_component(blackboard, "statistics")
	local target_side_id = 1
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_valid_target_units = #target_units
	statistics_component.valid_targets_on_aggro = num_valid_target_units
	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = true
end

BtChaosDaemonhostPassiveAction._switch_stage = function (self, unit, breed, scratchpad, action_data, stage, t)
	local previous_stage = scratchpad.stage
	local stage_settings = action_data.stage_settings[stage]

	if stage_settings then
		local anim_events = nil

		if previous_stage == STAGES.passive then
			anim_events = action_data.exit_passive.on_finished_anim_events
		else
			anim_events = stage_settings.anim_events
		end

		if anim_events then
			local animation_extension = scratchpad.animation_extension
			local anim_event = nil

			if anim_events.damaged ~= nil then
				local health_extension = scratchpad.health_extension
				local current_health_percent = health_extension:current_health_percent()
				local damaged_health_percent = stage_settings.damaged_health_percent

				if current_health_percent < damaged_health_percent then
					anim_event = Animation.random_event(anim_events.damaged)
				else
					anim_event = Animation.random_event(anim_events.default)
				end
			else
				anim_event = Animation.random_event(anim_events)
			end

			animation_extension:anim_event(anim_event)

			local durations = stage_settings.durations

			if durations then
				local duration = durations[anim_event]
				scratchpad.duration = t + duration
			end
		end

		local sfx_event = stage_settings.sfx_event

		if sfx_event then
			local fx_system = scratchpad.fx_system

			fx_system:trigger_wwise_event(sfx_event, nil, unit)
		end

		local suppression_settings = stage_settings.suppression

		if suppression_settings then
			local from_position = POSITION_LOOKUP[unit]
			local relation = "allied"

			Suppression.apply_area_minion_suppression(unit, suppression_settings, from_position, relation)
		end

		local vo_settings = stage_settings.vo

		if vo_settings then
			local on_enter_vo_settings = vo_settings.on_enter

			if on_enter_vo_settings then
				local player_vo = on_enter_vo_settings.player

				if player_vo then
					local vo_event = player_vo.vo_event
					local non_threatening_player = player_vo.is_non_threatening_player

					Vo.random_player_enemy_alert_event(unit, breed, vo_event, non_threatening_player)

					if vo_event == "aggroed" then
						Vo.set_dynamic_smart_tag(unit, vo_event)
					end
				end

				local daemonhost_vo = on_enter_vo_settings.daemonhost

				if daemonhost_vo then
					local vo_event = daemonhost_vo.vo_event

					Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
				end
			end
		end

		local trigger_health_bar = stage_settings.trigger_health_bar and not scratchpad.triggered_health_bar

		if trigger_health_bar then
			local boss_extension = ScriptUnit.extension(unit, "boss_system")

			boss_extension:start_boss_encounter()

			local spawn_component = scratchpad.spawn_component
			local game_object_id = spawn_component.game_object_id

			Managers.state.game_session:send_rpc_clients("rpc_start_boss_encounter", game_object_id)

			scratchpad.triggered_health_bar = true
		end

		if stage_settings.reset_suppression then
			scratchpad.suppression_component.suppress_value = 0
			scratchpad.suppression_component.is_suppressed = false
		end

		if stage_settings.set_aggro_target and scratchpad.wanted_aggro_target then
			Threat.add_flat_threat(unit, scratchpad.wanted_aggro_target, math.huge)
		end
	end

	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "stage", stage)

	scratchpad.stage = stage
end

BtChaosDaemonhostPassiveAction._enter_flashed = function (self, unit, scratchpad, action_data, t)
	local flashlight_settings = action_data.flashlight_settings
	local locomotion_extension = scratchpad.locomotion_extension
	local rotation_speed = flashlight_settings.look_at_rotation_speed

	locomotion_extension:set_rotation_speed(rotation_speed)

	local next_flashed_fx_t = scratchpad.next_flashed_fx_t

	if next_flashed_fx_t < t then
		local fx_system = scratchpad.fx_system
		local sfx_event = flashlight_settings.sfx_event

		fx_system:trigger_wwise_event(sfx_event, nil, unit)

		local fx_trigger_delay = flashlight_settings.fx_trigger_delay
		scratchpad.next_flashed_fx_t = t + fx_trigger_delay
	end

	scratchpad.is_flashed = true
end

BtChaosDaemonhostPassiveAction._exit_flashed = function (self, scratchpad)
	local locomotion_extension = scratchpad.locomotion_extension
	local rotation_speed = scratchpad.original_rotation_speed

	locomotion_extension:set_rotation_speed(rotation_speed)

	scratchpad.is_flashed = false
end

BtChaosDaemonhostPassiveAction._update_flashlights = function (self, unit, position, valid_enemy_player_units, scratchpad, action_data, t)
	local anger_flat = 0
	local anger_tick = 0
	local anger_settings = action_data.anger_settings
	local flashlight_anger_settings = anger_settings.flashlight
	local flashlight_anger_flat = flashlight_anger_settings.flat
	local flashlight_anger_tick = flashlight_anger_settings.tick
	local flashlight_settings = action_data.flashlight_settings
	local flashlight_range = flashlight_settings.range
	local flashlight_threat = flashlight_settings.threat
	local flashing_units = scratchpad.flashing_units
	local any_flashlights_applied = false
	local perception_extension = scratchpad.perception_extension
	local num_enemies = #valid_enemy_player_units
	local closest_flashlight_target = nil
	local closest_distance = math.huge

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]
		local last_los_position = perception_extension:last_los_position(target_unit)
		local is_applying_flashlight = false

		if last_los_position then
			local distance = Vector3.distance(position, last_los_position)

			if distance <= flashlight_range then
				is_applying_flashlight = self:_check_flashlight(position, target_unit, flashlight_settings, perception_extension)
			end

			if is_applying_flashlight and distance < closest_distance then
				closest_flashlight_target = target_unit
				closest_distance = distance
			end
		end

		if is_applying_flashlight then
			if not flashing_units[target_unit] then
				flashing_units[target_unit] = true
			end

			anger_flat = anger_flat + flashlight_anger_flat
			anger_tick = anger_tick + flashlight_anger_tick
			any_flashlights_applied = true
		elseif flashing_units[target_unit] then
			flashing_units[target_unit] = nil
		end
	end

	scratchpad.closest_flashlight_target = closest_flashlight_target
	local is_flashed = scratchpad.is_flashed

	if any_flashlights_applied and not is_flashed then
		self:_enter_flashed(unit, scratchpad, action_data, t)
	elseif is_flashed and not any_flashlights_applied then
		self:_exit_flashed(scratchpad)
	end

	local locomotion_extension = scratchpad.locomotion_extension
	local ALIVE = ALIVE

	if ALIVE[closest_flashlight_target] then
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, closest_flashlight_target)

		locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	return anger_flat, anger_tick
end

BtChaosDaemonhostPassiveAction._update_distances = function (self, unit, position, valid_enemy_player_units, scratchpad, action_data)
	local perception_extension = scratchpad.perception_extension
	local distances = Daemonhost.anger_distance_settings(scratchpad.stage)
	local anger_flat = 0
	local anger_tick = 0
	local num_enemies = #valid_enemy_player_units
	local closest_distance_index, closest_target_unit, closest_is_sprinting = nil
	local closest_distance = math.huge

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]
		local has_line_of_sight = perception_extension:has_line_of_sight(target_unit)

		if has_line_of_sight then
			local individual_closest_index = nil
			local target_position = POSITION_LOOKUP[target_unit]
			local distance_to_target_sq = Vector3.distance_squared(position, target_position)

			for j = 1, #distances do
				local entry = distances[j]
				local distance_sq = entry.distance * entry.distance

				if distance_to_target_sq <= distance_sq then
					individual_closest_index = j

					if not closest_distance_index or j < closest_distance_index then
						closest_distance_index = j
					end

					break
				end
			end

			if distance_to_target_sq < closest_distance then
				closest_target_unit = target_unit
				closest_distance = distance_to_target_sq
				local unit_data_extension = ScriptUnit.extension(closest_target_unit, "unit_data_system")
				local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
				closest_is_sprinting = Sprint.is_sprinting(sprint_character_state_component)
			end
		end
	end

	if closest_distance_index then
		local closest_distance_entry = distances[closest_distance_index]
		anger_flat = closest_distance_entry.flat or 0
		anger_tick = closest_distance_entry.tick or 0

		if closest_distance_entry.sprint_flat_bonus and closest_is_sprinting then
			anger_flat = anger_flat + closest_distance_entry.sprint_flat_bonus
		end

		scratchpad.closest_target_unit = closest_target_unit
	end

	return anger_flat, anger_tick
end

BtChaosDaemonhostPassiveAction._update_health = function (self, scratchpad, action_data)
	local anger_flat = 0
	local anger_settings = action_data.anger_settings
	local health_extension = scratchpad.health_extension
	local current_health_percent = health_extension:current_health_percent()

	if not scratchpad.agitated_health_percent then
		if current_health_percent < 1 then
			scratchpad.agitated_health_percent = current_health_percent
		else
			return anger_flat, current_health_percent
		end
	end

	local health_anger_settings = anger_settings.health
	local missing_percent = health_anger_settings.missing_percent
	local anger_max = health_anger_settings.max
	scratchpad.current_health_percent = current_health_percent
	local agitated_health_percent = scratchpad.agitated_health_percent
	local lerp_health = (agitated_health_percent - current_health_percent) * 100 / missing_percent
	local missing_health_anger = math.floor(math.clamp(lerp_health * anger_max, 0, anger_max))
	anger_flat = anger_flat + missing_health_anger

	return anger_flat, current_health_percent
end

BtChaosDaemonhostPassiveAction._update_suppression = function (self, scratchpad, action_data)
	local anger_flat = 0
	local anger_settings = action_data.anger_settings
	local suppression_component = scratchpad.suppression_component
	local suppression_anger_settings = anger_settings.suppression
	local suppress_value = suppression_component.suppress_value
	local anger_factor = suppression_anger_settings.factor
	local anger_max = suppression_anger_settings.max
	local suppression_anger = math.clamp(math.floor(suppress_value * anger_factor), 0, anger_max)
	anger_flat = anger_flat + suppression_anger

	if suppression_component.is_suppressed then
		local anger_suppressed = suppression_anger_settings.suppressed
		anger_flat = anger_flat + anger_suppressed
	end

	return anger_flat
end

BtChaosDaemonhostPassiveAction._update = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local anger_settings = action_data.anger_settings
	local side = scratchpad.side
	local valid_enemy_player_units = side.valid_enemy_player_units
	local position = POSITION_LOOKUP[unit]
	local flashlight_flat, flashlight_tick = self:_update_flashlights(unit, position, valid_enemy_player_units, scratchpad, action_data, t)
	local distance_flat, distance_tick = self:_update_distances(unit, position, valid_enemy_player_units, scratchpad, action_data)
	local health_flat, current_health_percent = self:_update_health(scratchpad, action_data)
	local suppression_flat = self:_update_suppression(scratchpad, action_data)
	local anger_flat = flashlight_flat + distance_flat + health_flat + suppression_flat
	local anger_tick = scratchpad.anger_tick
	local stage = scratchpad.stage

	if stage == STAGES.passive then
		local total_anger = anger_flat + anger_tick
		local exit_passive_t = scratchpad.exit_passive_t

		if exit_passive_t and exit_passive_t < t then
			self:_switch_stage(unit, breed, scratchpad, action_data, STAGES.agitated, t)
		elseif (total_anger > 0 or current_health_percent and current_health_percent < 1) and not exit_passive_t then
			local exit_passive_data = action_data.exit_passive
			local spawn_anim_used = scratchpad.spawn_anim
			local exit_passive_anim_event = exit_passive_data.anim_events[spawn_anim_used]

			scratchpad.animation_extension:anim_event(exit_passive_anim_event)

			local duration = exit_passive_data.durations[exit_passive_anim_event]
			scratchpad.exit_passive_t = t + duration
			local player_vo_event = exit_passive_data.player_vo_event

			if player_vo_event then
				local optional_non_threatening_player = true

				Vo.random_player_enemy_alert_event(unit, breed, player_vo_event, optional_non_threatening_player)
			end
		end
	else
		local next_anger_t = scratchpad.next_anger_t

		if next_anger_t < t then
			local decay_anger_settings = anger_settings.decay
			local anger_decay = decay_anger_settings[stage]
			anger_tick = distance_tick + flashlight_tick + anger_tick - anger_decay
			scratchpad.next_anger_t = t + anger_settings.tick_interval
		end

		scratchpad.anger_tick = math.max(0, anger_tick)
		local anger = math.max(0, math.max(anger_flat + anger_tick, anger_flat))
		scratchpad.anger = anger
		local wanted_stage = self:_get_stage(scratchpad, action_data)

		if wanted_stage ~= stage then
			local switch_stage_reason = self:_get_switch_stage_reason(scratchpad, distance_flat, health_flat, flashlight_flat, suppression_flat, distance_tick, flashlight_tick)
			scratchpad.switch_reason = switch_stage_reason
			local wanted_aggro_target = self:_get_wanted_aggro_target(unit, scratchpad, switch_stage_reason)
			scratchpad.wanted_aggro_target = wanted_aggro_target

			self:_switch_stage(unit, breed, scratchpad, action_data, wanted_stage, t)
		end

		scratchpad.old_anger = anger
	end

	scratchpad.old_flashlight_flat = flashlight_flat
	scratchpad.old_distance_flat = distance_flat
	scratchpad.old_health_flat = health_flat
	scratchpad.old_suppression_flat = suppression_flat
	scratchpad.old_distance_tick = distance_tick
	scratchpad.old_flashlight_tick = flashlight_tick

	self:_update_looping_vo(unit, breed, scratchpad, action_data, stage, t)
end

BtChaosDaemonhostPassiveAction._check_flashlight = function (self, from, target_unit, flashlight_settings, perception_extension)
	local look_at_angle = flashlight_settings.look_at_angle
	local visual_loadout_extension = ScriptUnit.extension(target_unit, "visual_loadout_system")
	local current_wielded_slot_scripts = visual_loadout_extension:current_wielded_slot_scripts()

	if current_wielded_slot_scripts then
		for i = 1, #current_wielded_slot_scripts do
			local script = current_wielded_slot_scripts[i]
			local flashlight_enabled = script.flashlight_enabled and script:flashlight_enabled()

			if flashlight_enabled then
				local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
				local first_person_component = unit_data_extension:read_component("first_person")
				local target_rotation = first_person_component.rotation
				local to = POSITION_LOOKUP[target_unit]
				local direction = Vector3.normalize(from - to)
				local target_forward = Quaternion.forward(target_rotation)
				local angle = Vector3.angle(direction, target_forward)
				local is_flashed = angle < look_at_angle
				is_flashed = is_flashed and perception_extension:has_line_of_sight(target_unit)

				return is_flashed
			end
		end
	end

	return false
end

BtChaosDaemonhostPassiveAction._get_stage = function (self, scratchpad, action_data)
	local anger_settings = action_data.anger_settings
	local stages = anger_settings.stages
	local anger = scratchpad.anger
	local num_stages = #stages

	for i = 1, num_stages do
		local amount = stages[i]

		if anger <= amount then
			return i
		end
	end

	return num_stages
end

BtChaosDaemonhostPassiveAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local stage_settings = action_data.stage_settings[scratchpad.stage]
	local wanted_target = scratchpad.wanted_aggro_target or scratchpad.closest_flashlight_target or scratchpad.closest_target_unit

	if stage_settings and stage_settings.rotate_towards_target and HEALTH_ALIVE[wanted_target] then
		local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, wanted_target)

		scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
	end

	if wanted_target and HEALTH_ALIVE[wanted_target] then
		local aim_pos = Unit.world_position(wanted_target, Unit.node(wanted_target, "j_head"))

		scratchpad.aim_component.controlled_aim_position:store(aim_pos)
	end

	local duration = scratchpad.duration

	if duration then
		if scratchpad.duration < t then
			return "done"
		end
	else
		self:_update(unit, breed, blackboard, scratchpad, action_data, t)
	end

	return "running"
end

BtChaosDaemonhostPassiveAction._update_looping_vo = function (self, unit, breed, scratchpad, action_data, stage, t)
	local stage_settings = action_data.stage_settings[stage]

	if stage_settings and stage_settings.vo and stage_settings.vo.looping then
		local next_vo_trigger_t = scratchpad.next_vo_trigger_t

		if next_vo_trigger_t < t then
			local vo_settings = stage_settings.vo.looping
			local vo_event = vo_settings.vo_event

			if type(vo_event) == "table" then
				vo_event = math.random_array_entry(vo_event)
			end

			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)

			local cooldown_duration = vo_settings.cooldown_duration

			if type(cooldown_duration) == "table" then
				cooldown_duration = math.random_range(cooldown_duration[1], cooldown_duration[2])
			end

			scratchpad.next_vo_trigger_t = t + cooldown_duration
		end
	end
end

BtChaosDaemonhostPassiveAction._get_switch_stage_reason = function (self, scratchpad, distance_flat, health_flat, flashlight_flat, suppression_flat, distance_tick, flashlight_tick)
	local biggest_diff = 0
	local switch_reason = "none"
	local old_flashlight_flat = scratchpad.old_flashlight_flat
	local flashlight_flat_diff = flashlight_flat - old_flashlight_flat

	if biggest_diff < flashlight_flat_diff then
		biggest_diff = flashlight_flat_diff
		switch_reason = "flashlight"
	end

	local old_distance_flat = scratchpad.old_distance_flat
	local distance_flat_diff = distance_flat - old_distance_flat

	if biggest_diff < distance_flat_diff then
		biggest_diff = distance_flat_diff
		switch_reason = "distance"
	end

	local old_health_flat = scratchpad.old_health_flat
	local health_flat_diff = health_flat - old_health_flat

	if biggest_diff < health_flat_diff then
		biggest_diff = health_flat_diff
		switch_reason = "health"
	end

	local old_suppression_flat = scratchpad.old_suppression_flat
	local suppression_flat_diff = suppression_flat - old_suppression_flat

	if biggest_diff < suppression_flat_diff then
		biggest_diff = suppression_flat_diff
		switch_reason = "suppression"
	end

	local old_distance_tick = scratchpad.old_distance_tick
	local distance_tick_diff = distance_tick - old_distance_tick

	if biggest_diff < distance_tick_diff then
		biggest_diff = distance_tick_diff
		switch_reason = "distance"
	end

	local old_flashlight_tick = scratchpad.old_flashlight_tick
	local flashlight_tick_diff = flashlight_tick - old_flashlight_tick

	if biggest_diff < flashlight_tick_diff then
		switch_reason = "flashlight"
	end

	if switch_reason == "none" then
		if distance_tick < flashlight_tick then
			switch_reason = "flashlight"
		else
			switch_reason = "distance"
		end
	end

	return switch_reason
end

BtChaosDaemonhostPassiveAction._get_wanted_aggro_target = function (self, unit, scratchpad, switch_reason)
	local target_unit = nil

	if switch_reason == "distance" then
		target_unit = scratchpad.closest_target_unit
	elseif switch_reason == "flashlight" then
		target_unit = scratchpad.closest_flashlight_target
	elseif switch_reason == "suppression" then
		local suppression_extension = ScriptUnit.extension(unit, "suppression_system")
		target_unit = suppression_extension:last_suppressing_unit()
	elseif switch_reason == "health" then
		local health_extension = ScriptUnit.extension(unit, "health_system")
		target_unit = health_extension:last_damaging_unit()
	end

	return target_unit or scratchpad.closest_target_unit
end

return BtChaosDaemonhostPassiveAction
