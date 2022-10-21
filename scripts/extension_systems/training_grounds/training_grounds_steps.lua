local Ammo = require("scripts/utilities/ammo")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local ItemPackage = require("scripts/foundation/managers/package/utilities/item_package")
local MasterItems = require("scripts/backend/master_items")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionSpawnerSpawnPosition = require("scripts/extension_systems/minion_spawner/utilities/minion_spawner_spawn_position")
local PlayerDeath = require("scripts/utilities/player_death")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local TrainingGroundsActionsLookup = require("scripts/settings/training_grounds/training_grounds_actions_lookup")
local TrainingGroundsObjectivesLookup = require("scripts/settings/training_grounds/training_grounds_objectives_lookup")
local TrainingGroundsInfoLookup = require("scripts/settings/training_grounds/training_grounds_info_lookup")
local TrainingGroundsItemNames = require("scripts/settings/training_grounds/training_grounds_item_names")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local Stamina = require("scripts/utilities/attack/stamina")
local Vo = require("scripts/utilities/vo")
local WarpCharge = require("scripts/utilities/warp_charge")
local RAMPING_VFX = "content/fx/particles/weapons/force_staff/force_staff_channel_charge"
local damage_types = DamageSettings.damage_types
local DEFAULT_SPAWN_DURATION = 1.5
local DEFAULT_APPLY_MARKER = true
local DEFAULT_GROUND_POSITION = true
local steps = {
	dynamic = {},
	_condition = {}
}

local function add_objective_marker(unit, marker_type, remove_when_dead, optional_data)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

	scenario_system:add_unit_marker(unit, marker_type, remove_when_dead, optional_data)
end

local function remove_objective_marker(unit)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

	scenario_system:add_unit_marker(unit, nil)
end

local function display_info(info_data)
	local is_server = Managers.state.game_session:is_server()
	local local_player = Managers.player:local_player(1)

	if not is_server or not local_player then
		return
	end

	Managers.event:trigger("event_player_display_prologue_tutorial_info_box", local_player, info_data)
end

local function hide_info()
	local is_server = Managers.state.game_session:is_server()
	local local_player = Managers.player:local_player(1)

	if not is_server or not local_player then
		return
	end

	Managers.event:trigger("event_player_hide_prologue_tutorial_info_box", local_player)
end

local function add_objective_tracker(objective_id, play_sound)
	if play_sound then
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

		scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_objective_new)
		Vo.mission_giver_vo_event("training_ground_psyker_a", "mission_info", objective_id)
	end

	local objective = TrainingGroundsObjectivesLookup[objective_id]

	Managers.event:trigger("event_player_add_objective_tracker", objective)
end

local function remove_objective_tracker(objective_id, play_sound)
	if play_sound then
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

		scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_objective_complete)
	end

	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	local objective = TrainingGroundsObjectivesLookup[objective_id]

	if objective then
		Managers.event:trigger("event_player_remove_objective", objective_id)
	end

	Managers.event:trigger("event_player_remove_current_objectives")
end

local function show_step_tracker(step_description)
	local is_server = Managers.state.game_session:is_server()

	if not is_server or not step_description then
		return
	end

	Managers.event:trigger("event_player_add_step_tracker")
end

local function remove_ste_tracker(step_description)
	local is_server = Managers.state.game_session:is_server()

	if not is_server or not step_description then
		return
	end

	Managers.event:trigger("event_player_remove_tracker")
end

local function show_transition(show)
	local is_server = Managers.state.game_session:is_server()

	if not is_server then
		return
	end

	if show == true then
		Managers.event:trigger("show_transition_popup")
	else
		Managers.event:trigger("hide_transition_popup")
	end
end

local function set_objective_tracker_value(objective_id, new_value, play_sound)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

	if play_sound then
		scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_objective_progress)
	end

	local objective = TrainingGroundsObjectivesLookup[objective_id]

	Managers.event:trigger("event_player_update_objectives_tracker", objective_id, new_value)
end

local function get_relative_position_rotation(reference_unit, relative_position, relative_look_direction, ground_position, ignore_unit_rotation)
	local is_player = Managers.player:player_by_unit(reference_unit)
	local unit_position = Unit.local_position(reference_unit, 1)
	local unit_rotation = nil

	if ignore_unit_rotation then
		unit_rotation = Quaternion.identity()
	elseif is_player then
		local first_person_extension = ScriptUnit.extension(reference_unit, "first_person_system")
		local first_person_unit = first_person_extension:first_person_unit()
		unit_rotation = Unit.local_rotation(first_person_unit, 1)
	else
		unit_rotation = Unit.local_rotation(reference_unit, 1)
	end

	local unit_rotation_yaw_only = Quaternion.from_yaw_pitch_roll(Quaternion.yaw(unit_rotation), 0, 0)
	local relative_look_rotation = Quaternion.look(relative_look_direction, Vector3.up())
	local rotation = Quaternion.multiply(relative_look_rotation, unit_rotation_yaw_only)
	local position = unit_position + Quaternion.rotate(unit_rotation_yaw_only, relative_position)

	if ground_position then
		local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
		local nav_world = scenario_system:nav_world()
		local traverse_logic = scenario_system:traverse_logic()
		local grounded_position = MinionSpawnerSpawnPosition.find_exit_position_on_nav_mesh(nav_world, position + position - unit_position, position, traverse_logic)

		if grounded_position then
			position = grounded_position
		end
	end

	return position, rotation
end

local function valid_position(reference_unit, position)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
	local nav_world = scenario_system:nav_world()
	local traverse_logic = scenario_system:traverse_logic()
	local validation_pos = Vector3(position[1], position[2], position[3])
	validation_pos[3] = POSITION_LOOKUP[reference_unit][3]

	return MinionSpawnerSpawnPosition.validate_exit_position(nav_world, validation_pos, traverse_logic)
end

local function spawn_breed_position_rotation(breed_name, position, rotation, t, duration, apply_objective_marker, spawn_vulnerable)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
	local side_id = 2
	local unit = scenario_system:spawn_breed_ramping(breed_name, position, rotation, t, duration, side_id, spawn_vulnerable)

	if apply_objective_marker then
		add_objective_marker(unit, "objective", true)
	end

	return unit
end

local function teleport_player(scenario_system, player, directional_unit_identifier)
	local directional_unit = scenario_system:get_directional_unit(directional_unit_identifier)
	local position = Unit.local_position(directional_unit, 1)
	local rotation = Unit.local_rotation(directional_unit, 1)

	PlayerMovement.teleport(player, position, rotation)
	scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_teleport_player)

	local world = scenario_system:world()
	local player_spawn_vfx = "content/fx/particles/weapons/force_staff/force_staff_explosion"

	World.create_particles(world, player_spawn_vfx, position, rotation)
end

local function spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, reset_directional_unit_identifier, t, duration, apply_objective_marker, spawn_vulnerable, spawn_datas)
	local spawned_enemies = {}

	for i = 1, #spawn_datas do
		local spawn_data = spawn_datas[i]
		local relative_position = spawn_data.relative_position
		local position = get_relative_position_rotation(reference_unit, relative_position, Vector3.forward(), DEFAULT_GROUND_POSITION)

		if not valid_position(reference_unit, position) then
			teleport_player(scenario_system, player, reset_directional_unit_identifier)

			reference_unit = scenario_system:get_directional_unit(reset_directional_unit_identifier)

			break
		end
	end

	for i = 1, #spawn_datas do
		local spawn_data = spawn_datas[i]
		local breed_name = spawn_data.breed_name
		local relative_position = spawn_data.relative_position
		local relative_look_direction = spawn_data.relative_look_direction
		local position, rotation = get_relative_position_rotation(reference_unit, relative_position, relative_look_direction, DEFAULT_GROUND_POSITION)
		spawned_enemies[i] = spawn_breed_position_rotation(breed_name, position, rotation, t, duration, apply_objective_marker, spawn_vulnerable)
	end

	return spawned_enemies
end

local function spawn_breed_directional_unit(breed_name, directional_unit_identifier, t, duration, apply_objective_marker, side_id, spawn_vulnerable)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
	local directional_unit = scenario_system:get_directional_unit(directional_unit_identifier)
	local position = Unit.local_position(directional_unit, 1)
	local rotation = Unit.local_rotation(directional_unit, 1)
	local unit = scenario_system:spawn_breed_ramping(breed_name, position, rotation, t, duration, side_id, spawn_vulnerable)

	if apply_objective_marker then
		add_objective_marker(unit, "objective", true)
	end

	return unit
end

local function spawn_pickup(pickup_name, position, rotation, apply_objective_marker)
	local pickup_system = Managers.state.extension:system("pickup_system")
	local pickup_unit, pickup_unit_go_id = pickup_system:spawn_pickup(pickup_name, position, rotation)

	if apply_objective_marker then
		add_objective_marker(pickup_unit, "objective", false)
	end

	return pickup_unit, pickup_unit_go_id
end

local function spawn_pickup_relative_safe(scenario_system, player, reference_unit, pickup_name, relative_position, relative_look_direction, apply_objective_marker, reset_directional_unit_identifier)
	local position, rotation = get_relative_position_rotation(reference_unit, relative_position, relative_look_direction, DEFAULT_GROUND_POSITION)

	if not valid_position(reference_unit, position) then
		teleport_player(scenario_system, player, reset_directional_unit_identifier)

		reference_unit = scenario_system:get_directional_unit(reset_directional_unit_identifier)
		position, rotation = get_relative_position_rotation(reference_unit, relative_position, relative_look_direction, DEFAULT_GROUND_POSITION)
	end

	return spawn_pickup(pickup_name, position, rotation, apply_objective_marker)
end

local function despawn_pickup(pickup_unit)
	if ALIVE[pickup_unit] then
		local pickup_extension = ScriptUnit.extension(pickup_unit, "pickup_animation_system")

		if not pickup_extension:pickup_animation_started() then
			local pickup_system = Managers.state.extension:system("pickup_system")

			pickup_system:despawn_pickup(pickup_unit)
		end
	end
end

local function spawn_unit_relative_position_safe(reference_unit, player, unit_name_optional, template_name_optional, relative_position, relative_look_direction, t, spawn_duration, reset_directional_unit_identifier)
	local position, rotation = get_relative_position_rotation(reference_unit, relative_position, relative_look_direction, DEFAULT_GROUND_POSITION)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

	if not valid_position(reference_unit, position) then
		teleport_player(scenario_system, player, reset_directional_unit_identifier)

		local directional_unit = scenario_system:get_directional_unit(reset_directional_unit_identifier)
		position, rotation = get_relative_position_rotation(directional_unit, relative_position, relative_look_direction, DEFAULT_GROUND_POSITION)
	end

	local ramping_spawn_data = {
		done = false,
		unit_name = unit_name_optional,
		template_name = template_name_optional,
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation)
	}

	scenario_system:spawn_unit_ramping(ramping_spawn_data, t, spawn_duration)

	return ramping_spawn_data
end

local function spawn_unit_directional_unit(player, unit_name_optional, template_name_optional, directional_unit_identifier, t, spawn_duration)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")
	local directional_unit = scenario_system:get_directional_unit(directional_unit_identifier)
	local position = Unit.local_position(directional_unit, 1)
	local rotation = Unit.local_rotation(directional_unit, 1)
	local ramping_spawn_data = {
		done = false,
		unit_name = unit_name_optional,
		template_name = template_name_optional,
		position = Vector3Box(position),
		rotation = QuaternionBox(rotation)
	}

	scenario_system:spawn_unit_ramping(ramping_spawn_data, t, spawn_duration)

	return ramping_spawn_data
end

local function add_unique_buff(unit, buff_name, scenario_data, t)
	scenario_data.unique_buffs = scenario_data.unique_buffs or {}
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local _, buff_id, component_index = buff_extension:add_externally_controlled_buff(buff_name, t)
	local buff_data = {
		buff_id = buff_id,
		component_index = component_index
	}
	scenario_data.unique_buffs[buff_name] = buff_data
end

local function remove_unique_buff(unit, buff_name, scenario_data)
	local buff_data = scenario_data.unique_buffs[buff_name]
	local buff_extension = ScriptUnit.extension(unit, "buff_system")

	buff_extension:remove_externally_controlled_buff(buff_data.buff_id, buff_data.component_index)

	scenario_data.unique_buffs[buff_name] = nil
end

local function dissolve_unit(unit, t)
	local scenario_system = Managers.state.extension:system("training_grounds_scenario_system")

	return scenario_system:dissolve_unit(unit, t)
end

local function equip_item(player, slot_name, item_name)
	local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()
	local peer_id = player:peer_id()
	local local_player_id = player:local_player_id()

	profile_synchronizer_host:override_slot(peer_id, local_player_id, slot_name, item_name)
end

local function ensure_has_ammo(player)
	local player_unit = player.player_unit
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	local inventory_slot_component = unit_data_extension:write_component("slot_secondary")
	inventory_slot_component.current_ammunition_reserve = inventory_slot_component.max_ammunition_reserve
end

local function reset_if_knocked_down(scenario_system, unit, t, reset_delay)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")

	if knocked_down_state_input.knock_down then
		scenario_system:reset_scenario(t, reset_delay)
	end

	return knocked_down_state_input.knock_down
end

local function unit_has_buff(unit, name)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local buffs = buff_extension:buffs()

	for i = 1, #buffs do
		local template_name = buffs[i]:template_name()

		if template_name == name then
			return true
		end
	end

	return false
end

local function ensure_has_combat_ability(player, step_data, t, delay)
	local ability_extension = ScriptUnit.extension(player.player_unit, "ability_system")

	if ability_extension:remaining_ability_cooldown("combat_ability") > 0 then
		step_data._reset_ability_t = step_data._reset_ability_t or t + (delay or 0)

		if step_data._reset_ability_t <= t then
			ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)

			step_data._reset_ability_t = nil
		end
	end
end

local function spawn_spawn_vfx(scenario_system, position)
	local world = scenario_system:world()
	local vfx_name = "content/fx/particles/weapons/force_staff/force_staff_explosion"

	World.create_particles(world, vfx_name, position, Quaternion.identity())
	scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_generic_spawn, position)
end

local function spawn_despawn_vfx(scenario_system, position)
	local world = scenario_system:world()
	local vfx_name = "content/fx/particles/weapons/force_staff/force_staff_explosion"

	World.create_particles(world, vfx_name, position, Quaternion.identity())
	scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_generic_despawn, position)
end

local function teleport_servitor_if_far_away(scenario_system, servitor_handler, reference_unit)
	local servitor_unit = servitor_handler:unit()
	local reference_pos = Unit.local_position(reference_unit, 1)
	local servitor_pos = Unit.local_position(servitor_unit, 1)
	local distance_sq = Vector3.distance_squared(reference_pos, servitor_pos)
	local threshold_sq = 400
	local tp_distance = 12.5

	if threshold_sq < distance_sq then
		spawn_despawn_vfx(scenario_system, servitor_pos)

		local position, rotation = get_relative_position_rotation(reference_unit, Vector3(0, 15, 5.5), -Vector3.forward(), false, false)

		Unit.set_local_position(servitor_unit, 1, position)
		Unit.set_local_rotation(servitor_unit, 1, rotation)
		spawn_spawn_vfx(scenario_system, position)
	end
end

local function display_radius(scenario_system, position, radius, parent_unit)
	local world = scenario_system:world()
	local decal_unit_name = "content/levels/training_grounds/fx/decal_aoe_indicator"
	local decal_unit = World.spawn_unit_ex(world, decal_unit_name, nil, position + Vector3(0, 0, 0.1))

	if parent_unit then
		World.link_unit(world, decal_unit, 1, parent_unit, 1)
	end

	local diameter = radius * 2

	Unit.set_local_scale(decal_unit, 1, Vector3(diameter, diameter, 1))

	local is_linked = not not parent_unit

	return decal_unit, is_linked
end

local function destroy_radius(scenario_system, fx_id)
	local world = scenario_system:world()

	World.destroy_particles(world, fx_id)
end

local function fadeout_radius(decal_unit, t, start_t, duration)
	local max_color_intensity = 6
	local multiplier = math.clamp01((t - start_t) / duration)
	multiplier = math.smoothstep(multiplier, 0, 1)
	multiplier = math.cos((multiplier - 0.5) * math.pi) * max_color_intensity + 1 - multiplier

	Unit.set_scalar_for_material(decal_unit, "projector", "color_multiplier", multiplier)
end

steps.hide_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		hide_info()

		local cleaning_up = scenario_data.cleaning_up

		remove_objective_tracker(nil, not cleaning_up)
	end
}
steps.make_player_invulnerable = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			health_extension:set_invulnerable(true)
		end
	end
}
steps.remove_player_invulnerable = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			health_extension:set_invulnerable(false)
		end
	end
}
steps.make_player_unkillable = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			health_extension:set_unkillable(true)
		end
	end
}
steps.remove_player_unkillable = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			health_extension:set_unkillable(false)
		end
	end
}
steps.cleanup_ragdolls = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local minion_death_manager = Managers.state.minion_death
		local minion_ragdoll = minion_death_manager:minion_ragdoll()

		minion_ragdoll:cleanup_ragdolls()
	end
}
steps.trigger_training_complete = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local telemetry_reporter = Managers.telemetry_reporters:reporter("training_grounds")

		if telemetry_reporter then
			telemetry_reporter:register_training_completed()
			Managers.telemetry_reporters:stop_reporter("training_grounds")
		end

		scenario_system:trigger_training_complete()
	end
}

steps.dynamic.lerp_time_scale = function (from_scale, to_scale, transition_time)
	return {
		name = "lerp_time_scale",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			step_data.time_scale_data = {}

			scenario_system:start_time_scale(from_scale, to_scale, transition_time)
		end,
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			local current_scale = Managers.time:local_scale("gameplay")

			return current_scale == to_scale
		end
	}
end

steps.dynamic.add_unique_buff = function (buff_name)
	return {
		name = "add_unique_buff",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			add_unique_buff(player.player_unit, buff_name, scenario_data, t)
		end
	}
end

steps.dynamic.remove_unique_buff = function (buff_name)
	return {
		name = "remove_unique_buff",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			remove_unique_buff(player.player_unit, buff_name, scenario_data)
		end
	}
end

steps.dynamic.remove_unique_buff_safe = function (buff_name)
	return {
		name = "remove_unique_buff_safe",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local exists = ALIVE[player.player_unit]
			local has_buff = exists and scenario_data.unique_buffs and scenario_data.unique_buffs[buff_name]

			if has_buff then
				remove_unique_buff(player.player_unit, buff_name, scenario_data)
			end
		end
	}
end

steps.dynamic.delay = function (delay_t)
	return {
		name = "delay",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			step_data.wait_t = t + delay_t
		end,
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			return step_data.wait_t <= t
		end
	}
end

steps.dynamic.equip_item = function (slot_name, item_name)
	return {
		name = "equip_item",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local player_unit = player.player_unit
			local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
			local slot = visual_loadout_extension:item_from_slot(slot_name)
			local currently_equipped_item_name = slot and slot.name

			if item_name == currently_equipped_item_name then
				step_data.already_equipped = true

				return
			end

			equip_item(player, slot_name, item_name)
		end,
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			if step_data.already_equipped then
				return true
			end

			local player_unit = player.player_unit
			local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")
			local slot = visual_loadout_extension:item_from_slot(slot_name)
			local currently_equipped_item_name = slot and slot.name

			if item_name == currently_equipped_item_name then
				return true
			end
		end,
		stop_func = function (scenario_system, player, scenario_data, step_data, t)
			local player_unit = player.player_unit
			local visual_loadout_extension = ScriptUnit.extension(player_unit, "visual_loadout_system")

			if visual_loadout_extension:can_wield(slot_name) then
				PlayerUnitVisualLoadout.wield_slot(slot_name, player_unit, t)
			end
		end
	}
end

steps.dynamic.unequip_slot = function (slot_name)
	return {
		name = "unequip_slot",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local visual_loadout_extension = ScriptUnit.extension(player.player_unit, "visual_loadout_system")

			if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, slot_name) then
				PlayerUnitVisualLoadout.unequip_item_from_slot(player.player_unit, slot_name, t)
			end
		end
	}
end

steps.dynamic.wield_slot = function (slot_name)
	return {
		name = "wield_slot",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
			local inventory_component = unit_data_extension:read_component("inventory")
			local visual_loadout_extension = ScriptUnit.extension(player.player_unit, "visual_loadout_system")

			if PlayerUnitVisualLoadout.slot_equipped(inventory_component, visual_loadout_extension, slot_name) then
				PlayerUnitVisualLoadout.wield_slot(slot_name, player.player_unit, t)
			end
		end
	}
end

steps.dynamic.swap_scenario = function (alias, next_scenario_name)
	return {
		name = "swap_scenario",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_system:start_scenario(alias, next_scenario_name, t)
		end
	}
end

steps.dynamic.set_ability_enabled = function (ability_type, enabled, reset_cooldown)
	return {
		name = "set_ability_enabled",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local ability_extension = ScriptUnit.extension(player.player_unit, "ability_system")

			ability_extension:set_ability_enabled(ability_type, enabled)

			if reset_cooldown then
				ability_extension:reduce_ability_cooldown_percentage(ability_type, 1)
			end
		end
	}
end

steps.dynamic.set_grenade_count = function (new_count)
	return {
		name = "set_grenade_count",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local unit = player.player_unit
			local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
			local grenade_ability_component = unit_data_extension:write_component("grenade_ability")
			grenade_ability_component.num_charges = new_count
		end
	}
end

steps.dynamic.teleport_player = function (directional_unit_identifier)
	return {
		name = "teleport_player",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			teleport_player(scenario_system, player, directional_unit_identifier)
		end
	}
end

steps.dynamic.trigger_wwise_event = function (event_name)
	return {
		name = "trigger_wwise_event",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_system:trigger_wwise_event(event_name)
		end
	}
end

steps.dynamic.trigger_vo_event = function (vo_id)
	return {
		name = "trigger_vo_event",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			Vo.mission_giver_vo_event("training_ground_psyker_a", "mission_info", vo_id)
		end
	}
end

steps.dynamic.level_flow_event = function (event_name)
	return {
		name = "level_flow_event",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			local level = Managers.state.mission:mission_level()

			Level.trigger_event(level, event_name)
		end
	}
end

steps.dynamic.scenario_data_set = function (key, value)
	return {
		name = "scenario_data_set",
		start_func = function (scenario_system, player, scenario_data, step_data, t)
			scenario_data[key] = value
		end
	}
end

steps._condition.archetype_is = function (...)
	local archetype_names = {
		...
	}

	return {
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			local player_archetype_name = player:archetype_name()

			for i = 1, #archetype_names do
				if archetype_names[i] == player_archetype_name then
					return true
				end
			end

			return false
		end
	}
end

steps._condition.archetype_specialization_is = function (...)
	local specialization_names = {
		...
	}

	return {
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			local specialization_extension = ScriptUnit.has_extension(player.player_unit, "specialization_system")
			local specialization_name = specialization_extension:get_specialization_name()

			for i = 1, #specialization_names do
				if specialization_names[i] == specialization_name then
					return true
				end
			end

			return false
		end
	}
end

steps._condition.scenario_data_equals = function (key, value)
	return {
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			return scenario_data[key] == value
		end
	}
end

steps._condition.scenario_data_has = function (key)
	return {
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			return not not scenario_data[key]
		end
	}
end

steps._condition.device_in_use = function (device_name)
	return {
		condition_func = function (scenario_system, player, scenario_data, step_data, t)
			return Managers.input:device_in_use(device_name)
		end
	}
end

steps.init_servitor_wait_interact = {
	events = {
		"tg_servitor_interact"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local servitor_handler = scenario_system:servitor_handler()
		local position, rotation = get_relative_position_rotation(player.player_unit, Vector3(0, 100, -50), -Vector3.forward(), false)
		local servitor_unit = servitor_handler:unit() or servitor_handler:spawn_servitor(position, rotation)
		local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()
		local camera_position = Unit.local_position(first_person_unit, 1)
		local relative_camera_height = camera_position[3] - POSITION_LOOKUP[player.player_unit][3]

		servitor_handler:move_to_unit_relative_arc(player.player_unit, Vector3(0, 1, relative_camera_height), true, false, true)

		local interactee_extension = servitor_handler:interactee_extension()

		interactee_extension:set_active(true)
		interactee_extension:set_description("loc_training_grounds_start_training")
		add_objective_marker(servitor_unit, "objective", false)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local servitor_handler = scenario_system:servitor_handler()

		teleport_servitor_if_far_away(scenario_system, servitor_handler, player.player_unit)

		return step_data.interacted
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		step_data.interacted = true
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local servitor_handler = scenario_system:servitor_handler()

		servitor_handler:move_idle(player.player_unit, true)
		servitor_handler:interactee_extension():set_active(false)
		remove_objective_marker(servitor_handler:unit())
	end
}
steps.basic_training = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local telemetry_reporters = Managers.telemetry_reporters
		local existing_reporter = telemetry_reporters:reporter("training_grounds")

		if existing_reporter then
			existing_reporter:reset()
			telemetry_reporters:stop_reporter("training_grounds")
		end

		telemetry_reporters:start_reporter("training_grounds")

		local training_grounds_reporter = telemetry_reporters:reporter("training_grounds")

		training_grounds_reporter:set_start_type("basic")
		training_grounds_reporter:register_training_checkpoint("basic")
	end
}
steps.attack_chains_kill_infected_loop = {
	events = {
		"on_killed",
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.kill_count_heavy = 0
		step_data.enemies = {}
		step_data.target_kill_count = 3
		step_data.target_kill_count_heavy = 2
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, event_data)
		if event_name == "on_damaged" then
			local damage_profile = event_data.damage_profile
			local attack_type = event_data.attack_type
			local wounds_shape = event_data.wounds_shape
			local name = damage_profile and damage_profile.name
			local damage_type = event_data.damage_type
			local performed_light = name == "light_combatsword_smiter" or name == "combat_blade_light_smiter" and wounds_shape == "default"
			local performed_heavy = name == "heavy_combatsword_smiter" or name == "combat_blade_heavy_linesman" and wounds_shape == "right_45_slash"

			if performed_light or performed_heavy then
				local enemy = step_data.enemy
				local enemy_health_ext = ScriptUnit.has_extension(enemy, "health_system")
				local max_health = enemy_health_ext:max_health()

				enemy_health_ext:set_unkillable(false)
				Attack.execute(enemy, DamageProfileTemplates.melee_fighter_default, "attack_direction", -Vector3.up(), "power_level", 50000, "hit_zone_name", "torso", "damage_type", damage_types.minion_melee_blunt)

				if performed_light then
					step_data.kill_count = step_data.kill_count + 1

					set_objective_tracker_value("attack_chain", step_data.kill_count, true)
				else
					step_data.kill_count_heavy = step_data.kill_count_heavy + 1

					set_objective_tracker_value("attack_chain_2", step_data.kill_count_heavy, true)
				end
			end
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_kill_count <= step_data.kill_count and step_data.target_kill_count_heavy <= step_data.kill_count_heavy then
			return true
		end

		local enemy = step_data.enemy

		if not HEALTH_ALIVE[enemy] then
			local enemy = step_data.enemy

			dissolve_unit(enemy, t)

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(0, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemy = spawned_enemies[1]
			local enemy_health_ext = ScriptUnit.has_extension(step_data.enemy, "health_system")

			if enemy_health_ext then
				enemy_health_ext:set_unkillable(true)
			end
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemy = step_data.enemy

		dissolve_unit(enemy, t)
	end
}
steps.armor_types_armored_loop = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 1
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "renegade_melee",
				relative_position = Vector3(0, 6, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
		step_data.enemy_unit = spawned_enemies[1]
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.kill_count = step_data.kill_count + 1

		set_objective_tracker_value("armor_objective_1", 1, true)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return step_data.target_kill_count <= step_data.kill_count
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.armor_types_heavy_armored_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.hit_count = 0
		step_data.target_hit_count = 3
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local damage_profile = damage_data_scratchpad.damage_profile
		local attack_type = damage_data_scratchpad.attack_type
		local name = damage_profile and damage_profile.name
		local correct_damage = name == "heavy_chainsword" or name == "heavy_chainsword_sticky_last" or name == "light_chainsword_sticky_last" or name == "default_light_chainsword_stab_sticky_last" or name == "combat_blade_heavy_linesman" or name == "heavy_combatsword"

		if correct_damage then
			step_data.hit_count = step_data.hit_count + 1

			set_objective_tracker_value("armor_objective_2", step_data.hit_count, true)
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.target_hit_count <= step_data.hit_count

		if condition_met then
			return true
		end

		local enemy_unit = step_data.enemy_unit

		if not HEALTH_ALIVE[enemy_unit] then
			dissolve_unit(enemy_unit, t)

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "chaos_ogryn_executor",
					relative_position = Vector3(0, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			enemy_unit = spawned_enemies[1]
			local enemy_health_ext = ScriptUnit.has_extension(enemy_unit, "health_system")
			local max_health = enemy_health_ext:max_health()

			enemy_health_ext:add_damage(max_health * 0.8)

			step_data.enemy_unit = enemy_unit
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		set_objective_tracker_value("armor_objective_1", 1, true)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.armor_types_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.armor_types)
	end
}
steps.use_weapon_special = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.hit_count = 0
		step_data.target_hit_count = 3
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_hit_count <= step_data.hit_count then
			return true
		end

		if not HEALTH_ALIVE[step_data.enemy_unit] then
			if not step_data.grace_timer then
				step_data.grace_timer = t + 1

				dissolve_unit(step_data.enemy_unit, t)
			elseif step_data.grace_timer < t then
				step_data.grace_timer = nil
				local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
				step_data.spawned_once = true
				local spawn_vulnerable = true
				local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, spawn_vulnerable, {
					{
						breed_name = "chaos_newly_infected",
						relative_position = Vector3(0, 6, 0),
						relative_look_direction = -Vector3.forward()
					}
				})
				step_data.enemy_unit = spawned_enemies[1]
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, scratchpad)
		local damage_type = scratchpad.damage_type

		if damage_type == "sawing_stuck" or damage_type == "warp" then
			step_data.hit_count = step_data.hit_count + 1

			set_objective_tracker_value("weapon_special", step_data.hit_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.use_weapon_special_ogryn = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.hit_count = 0
		step_data.target_hit_count = 3
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_hit_count <= step_data.hit_count then
			return true
		end

		if not HEALTH_ALIVE[step_data.enemy_unit] then
			if not step_data.grace_timer then
				step_data.grace_timer = t + 1

				dissolve_unit(step_data.enemy_unit, t)
			elseif step_data.grace_timer < t then
				step_data.grace_timer = nil
				local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
				local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
					{
						breed_name = "chaos_newly_infected",
						relative_position = Vector3(0, 6, 0),
						relative_look_direction = -Vector3.forward()
					}
				})
				step_data.spawned_once = true
				step_data.enemy_unit = spawned_enemies[1]
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local damage_profile = damage_data_scratchpad.damage_profile
		local name = damage_profile and damage_profile.name

		if name == "special_uppercut" then
			step_data.hit_count = step_data.hit_count + 1

			set_objective_tracker_value("weapon_special", step_data.hit_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.stagger_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.stagger)
	end
}
steps.stagger_renegade_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.enemies = {}
		step_data.stagger_count = 0
		step_data.target_stagger_count = 3
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_stagger_count <= step_data.stagger_count then
			return true
		end

		local enemies = step_data.enemies
		local enemies_alive = false
		local HEALTH_ALIVE = HEALTH_ALIVE

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(2, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(-2, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local player_unit = player.player_unit

		if player_unit ~= damage_data_scratchpad.attacked_unit then
			step_data.stagger_count = step_data.stagger_count + 1

			set_objective_tracker_value("stagger_objective_1", step_data.stagger_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.stagger_executioner_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.stagger_count = 0
		step_data.target_stagger_count = 3
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local player_unit = player.player_unit

		if player_unit ~= damage_data_scratchpad.attacked_unit then
			step_data.stagger_count = step_data.stagger_count + 1

			set_objective_tracker_value("stagger_objective_2", step_data.stagger_count, true)
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_stagger_count <= step_data.stagger_count then
			return true
		end

		local enemy_unit = step_data.enemy_unit

		if not HEALTH_ALIVE[enemy_unit] then
			dissolve_unit(enemy_unit, t)

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_executor",
					relative_position = Vector3(0, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemy_unit = spawned_enemies[1]
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.push_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.pushing)
	end
}
steps.push_enemies_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.push_count = 0
		step_data.target_push_count = 5
		step_data.last_sound_t = 0
		step_data.sound_grace_delay = 0.1
		step_data.enemies = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(-1, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(0, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(1, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return step_data.target_push_count <= step_data.push_count
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local damage_profile = damage_data_scratchpad.damage_profile
		local is_push = damage_profile and damage_profile.is_push

		if is_push then
			step_data.push_count = step_data.push_count + 1
			local t = Managers.time:time("gameplay")
			local play_sound = false

			if not step_data.last_sound_t or t > step_data.last_sound_t + step_data.sound_grace_delay then
				play_sound = true
				step_data.last_sound_t = t
			end

			set_objective_tracker_value("push", step_data.push_count, play_sound)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.enemies then
			scenario_data.enemies = step_data.enemies
		end
	end
}
steps.push_clean_enemies = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		if enemies then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)
			end
		end
	end
}
steps.push_follow_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.push_follow_up)
	end
}
steps.push_follow_enemies_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.enemies = {}
		step_data.hit_count = 0
		step_data.target_hit_count = 3
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_hit_count <= step_data.hit_count then
			return true
		end

		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = not step_data.spawned_once and scenario_system:get_directional_unit("player_reset") or player.player_unit
			step_data.spawned_once = true
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(-2.5, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(0, 7, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(2.5, 6, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local damage_profile = damage_data_scratchpad.damage_profile
		local attack_type = damage_data_scratchpad.attack_type
		local name = damage_profile and damage_profile.name
		local play_sound = false
		local t = FixedFrame.get_latest_fixed_time()

		if not step_data.last_sound_t or t > step_data.last_sound_t + 0.1 then
			step_data.last_sound_t = t
			play_sound = true
		end

		if name == "default_light_chainsword_stab" or name == "ogryn_club_smiter_pushfollow" or name == "force_sword_push_followup_fling" then
			step_data.hit_count = step_data.hit_count + 1

			set_objective_tracker_value("push_follow", step_data.hit_count, play_sound)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.ranged_basic_gun_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.ranged_basic)
	end
}
steps.ranged_basic_gun_enemies_loop = {
	events = {
		"on_damaged",
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.hit_count = 0
		step_data.target_hit_count = 2
		step_data.enemies = {}
		step_data.kill_count = 0
		step_data.target_kill_count = 3
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		ensure_has_ammo(player)

		local condition_met = step_data.target_hit_count <= step_data.hit_count and step_data.target_kill_count <= step_data.kill_count

		if condition_met then
			return true
		end

		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			local enemy = enemies[i]

			if HEALTH_ALIVE[enemy] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(-3, 12, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(0, 12, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(3, 12, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		if event_name == "on_damaged" then
			local attack_type = damage_data_scratchpad.attack_type
			local is_ranged_attack = attack_type and attack_type == "ranged"

			if not is_ranged_attack then
				return
			end

			local hit_weakspot = damage_data_scratchpad.hit_weakspot

			if hit_weakspot then
				step_data.hit_count = step_data.hit_count + 1

				set_objective_tracker_value("basic_ranged_objective_2", step_data.hit_count, true)
			end
		else
			step_data.kill_count = step_data.kill_count + 1

			set_objective_tracker_value("basic_ranged_objective_1", step_data.kill_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.ranged_warp_charge_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.ranged_warp_charge)
	end
}
steps.ranged_warp_charge_loop = {
	events = {
		"on_damaged",
		"on_killed",
		"on_vent"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.hit_count = 0
		step_data.target_hit_count = 2
		step_data.enemies = {}
		step_data.kill_count = 0
		step_data.target_kill_count = 3
		step_data.vent_count = 0
		step_data.vent_count_target = 20
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.target_hit_count <= step_data.hit_count and step_data.target_kill_count <= step_data.kill_count and step_data.vent_count_target <= step_data.vent_count

		if condition_met then
			return true
		end

		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			local enemy = enemies[i]

			if HEALTH_ALIVE[enemy] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(-3, 12, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(0, 12, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(3, 12, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemies = enemies
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		if event_name == "on_damaged" then
			local damage_profile = damage_data_scratchpad.damage_profile

			if damage_profile.name ~= "force_staff_ball" and damage_profile.name ~= "force_staff_bash" then
				step_data.hit_count = step_data.hit_count + 1

				set_objective_tracker_value("ranged_warp_charge_objective_2", step_data.hit_count, true)
			end
		elseif event_name == "on_killed" then
			step_data.kill_count = step_data.kill_count + 1

			set_objective_tracker_value("ranged_warp_charge_objective_1", step_data.kill_count, true)
		else
			step_data.vent_count = step_data.vent_count + 1

			set_objective_tracker_value("ranged_warp_charge_objective_3", step_data.vent_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
local _camera_pos_hit_target_offset = Vector3Box(0, 0, -0.3)
steps.incoming_supression_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.incoming_suppression)
	end
}
steps.incoming_suppression_crouch = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		scenario_data.rifleman_override = false

		scenario_system:spawn_attached_units_in_spawn_group("arena_b_cover_behind")

		scenario_data.cover_middle_spawned = true
		step_data.cover_directional_unit = scenario_system:get_directional_unit("incoming_suppression_cover")

		add_objective_marker(step_data.cover_directional_unit, "objective", false)

		local enemies = {}
		scenario_data.num_enemies = scenario_data.rifleman_override and 3 or 1
		scenario_data.enemies = enemies

		for i = 1, scenario_data.num_enemies do
			local breed = scenario_data.rifleman_override and "renegade_rifleman" or "renegade_gunner"
			local offset = scenario_data.rifleman_override and 1 or 2
			local side_id = 2
			local spawn_vulnerable = true
			enemies[i] = spawn_breed_directional_unit(breed, "suppression_" .. i + offset, t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, side_id, spawn_vulnerable)
			local health_extension = ScriptUnit.extension(enemies[i], "health_system")

			health_extension:set_invulnerable(true)

			local suppression_extension = ScriptUnit.extension(enemies[i], "suppression_system")

			suppression_extension:set_enabled(false)
		end

		local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:write_component("slot_secondary")

		Ammo.move_clip_to_reserve(inventory_slot_component)

		local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve

		Ammo.remove_from_reserve(inventory_slot_component, current_ammo_in_reserve)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local cover_directional_unit = step_data.cover_directional_unit
		local cover_pos = POSITION_LOOKUP[cover_directional_unit]
		local player_pos = POSITION_LOOKUP[player.player_unit]
		local cover_dist_sq = 9

		if Vector3.distance_squared(cover_pos, player_pos) < cover_dist_sq then
			local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
			local movement_state_component = unit_data_extension:read_component("movement_state")
			local is_crouching = movement_state_component.is_crouching

			if is_crouching then
				local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()
				local camera_position = Unit.local_position(first_person_unit, 1)
				local enemies = scenario_data.enemies

				for i = 1, #enemies do
					local enemy_unit = enemies[i]

					add_objective_marker(enemy_unit)

					local behavior_extension = ScriptUnit.extension(enemy_unit, "behavior_system")
					local behavior_tree_name = scenario_data.rifleman_override and "renegade_rifleman_tg" or "renegade_gunner_tg"

					behavior_extension:override_brain(behavior_tree_name, t)

					local blackboard = BLACKBOARDS[enemy_unit]
					local perception_component = Blackboard.write_component(blackboard, "perception")
					perception_component.lock_target = true

					perception_component.target_position:store(camera_position + _camera_pos_hit_target_offset:unbox())

					perception_component.target_unit = player.player_unit
					local perception_extension = ScriptUnit.extension(enemy_unit, "perception_system")

					MinionPerception.attempt_aggro(perception_extension)
				end

				set_objective_tracker_value("incoming_suppression_objective_0", 1, true)

				return true
			end
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		remove_objective_marker(step_data.cover_directional_unit)
	end
}
steps.incoming_suppression_loop = {
	events = {
		"on_ammo_consumed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.suppressed_shots = 10
		step_data.current_shots = 0

		remove_objective_tracker("incoming_suppression_objective_0", true)
		add_objective_tracker("incoming_suppression_objective_1", true)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		ensure_has_ammo(player)

		local enemies = scenario_data.enemies
		local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()
		local camera_position = Unit.local_position(first_person_unit, 1)

		for i = 1, #enemies do
			local enemy_unit = enemies[i]
			local blackboard = BLACKBOARDS[enemy_unit]
			local perception_component = Blackboard.write_component(blackboard, "perception")

			perception_component.target_position:store(camera_position + _camera_pos_hit_target_offset:unbox())
		end

		local toughness_extension = ScriptUnit.extension(player.player_unit, "toughness_system")

		toughness_extension:recover_percentage_toughness(1, true)

		if step_data.suppressed_shots <= step_data.current_shots then
			return true
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		step_data.current_shots = step_data.current_shots + 1

		set_objective_tracker_value("incoming_suppression_objective_1", step_data.current_shots, true)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			remove_objective_marker(enemies[i])
		end
	end
}
steps.incoming_suppression_loop_2 = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		remove_objective_tracker("incoming_suppression_objective_1", true)
		add_objective_tracker("incoming_suppression_objective_2", true)

		step_data.cover_spawn_data = spawn_unit_directional_unit(player, nil, nil, "arena_b_cover_right_unit_1", t, DEFAULT_SPAWN_DURATION)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		ensure_has_ammo(player)

		local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()
		local camera_pos = Unit.local_position(first_person_unit, 1)
		local enemies = scenario_data.enemies

		for i = 1, scenario_data.num_enemies do
			local enemy_unit = enemies[i]
			local blackboard = BLACKBOARDS[enemy_unit]
			local perception_component = Blackboard.write_component(blackboard, "perception")

			perception_component.target_position:store(camera_pos)
		end

		local cover_ready = step_data.cover_spawn_data.done

		if not cover_ready then
			return false
		elseif not step_data.cover_spawned then
			step_data.cover_spawned = true

			scenario_system:spawn_attached_units_in_spawn_group("arena_b_cover_right")

			scenario_data.cover_right_spawned = true
			local end_directional_unit = scenario_system:get_directional_unit("incoming_suppression_end")

			add_objective_marker(end_directional_unit, "objective")

			step_data.end_rotation = QuaternionBox(Unit.local_rotation(end_directional_unit, 1))
			step_data.end_position = Vector3Box(Unit.local_position(end_directional_unit, 1))
		end

		if step_data.end_position then
			local enemy_pos = POSITION_LOOKUP[scenario_data.enemies[1]]
			local player_pos = POSITION_LOOKUP[player.player_unit]
			local end_pos = step_data.end_position:unbox()
			local dot_behind_cover = 0.9995
			local player_dot_from_cover = Vector3.dot(Vector3.normalize(player_pos - enemy_pos), Vector3.normalize(end_pos - enemy_pos))
			local sq_dist_cover = Vector3.distance_squared(end_pos, enemy_pos)
			local sq_dist_player = Vector3.distance_squared(player_pos, enemy_pos)

			if dot_behind_cover < player_dot_from_cover and sq_dist_cover < sq_dist_player then
				set_objective_tracker_value("incoming_suppression_objective_2", 1, true)

				local cover_directional_unit = scenario_system:get_directional_unit("incoming_suppression_cover")
				local cover_pos = POSITION_LOOKUP[cover_directional_unit] + Vector3(0, 0, 1.5)

				for i = 1, scenario_data.num_enemies do
					local enemy_unit = enemies[i]
					local blackboard = BLACKBOARDS[enemy_unit]
					local perception_component = Blackboard.write_component(blackboard, "perception")

					perception_component.target_position:store(cover_pos)
				end

				return true
			end
		end

		local toughness_extension = ScriptUnit.extension(player.player_unit, "toughness_system")

		toughness_extension:recover_percentage_toughness(1, true)

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local end_directional_unit = scenario_system:get_directional_unit("incoming_suppression_end")

		remove_objective_marker(end_directional_unit)
	end
}
steps.incoming_suppression_loop_3 = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		remove_objective_tracker("incoming_suppression_objective_2", true)
		add_objective_tracker("incoming_suppression_objective_3", true)

		step_data.enemies_killed = 0
		local enemies = scenario_data.enemies

		for i = 1, scenario_data.num_enemies do
			if HEALTH_ALIVE[enemies[i]] then
				local health_extension = ScriptUnit.extension(enemies[i], "health_system")

				health_extension:set_invulnerable(false)
			end
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		ensure_has_ammo(player)

		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				return false
			end
		end

		return true
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.enemies_killed = step_data.enemies_killed + 1

		set_objective_tracker_value("incoming_suppression_objective_3", step_data.enemies_killed, true)
	end
}
steps.cleanup_incoming_suppression = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		if scenario_data.cover_middle_spawned then
			scenario_system:unspawn_attached_units_in_spawn_group("arena_b_cover_behind")
		end

		if scenario_data.cover_right_spawned then
			scenario_system:unspawn_attached_units_in_spawn_group("arena_b_cover_right")
		end
	end
}
steps.ranged_suppression_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.ranged_suppression)
	end
}
steps.ranged_suppression_enemies_loop = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.num_enemies_in_cover = 0
		step_data.enemies = {}
		step_data.num_enemies = 5
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies
		local num_using_cover = 0

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				local cover_user_extension = ScriptUnit.extension(enemies[i], "cover_system")

				if cover_user_extension:has_claimed_cover_slot() then
					num_using_cover = num_using_cover + 1

					remove_objective_marker(enemies[i])
				end
			end
		end

		if num_using_cover ~= step_data.num_enemies_in_cover then
			step_data.num_enemies_in_cover = num_using_cover

			set_objective_tracker_value("suppression_objective_1", num_using_cover, true)
		end

		if step_data.num_enemies <= num_using_cover then
			if not step_data.grace_timer then
				step_data.grace_timer = t + 3
			end

			return step_data.grace_timer < t
		end

		ensure_has_ammo(player)

		for i = 1, step_data.num_enemies do
			if not HEALTH_ALIVE[enemies[i]] then
				dissolve_unit(enemies[i], t)

				local side_id = 2
				local spawn_vulnerable = true
				enemies[i] = spawn_breed_directional_unit("renegade_rifleman", "suppression_" .. i, t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, side_id, spawn_vulnerable)
				local health_extension = ScriptUnit.extension(enemies[i], "health_system")

				health_extension:set_invulnerable(true)
			end
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.grunt_blitz_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.grunt_blitz)
	end
}
steps.maniac_blitz_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.maniac_blitz)
	end
}
steps.stun_enemies_grenade_loop = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.last_frame_num_staggered = 0
		step_data.stun_count = 5
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-4, 12, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-2, 13, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(0, 14, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(2, 13, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(4, 12, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
		step_data.grenade_objective = scenario_data.grenade_objective
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.last_frame_num_staggered == step_data.stun_count

		if condition_met then
			step_data.grace_t = step_data.grace_t or t + 2.5

			return step_data.grace_t < t
		end

		local enemies = step_data.enemies
		local num_staggered_enemies = 0

		for i = 1, #enemies do
			if not HEALTH_ALIVE[enemies[i]] then
				num_staggered_enemies = num_staggered_enemies + 1
			else
				local blackboard = BLACKBOARDS[enemies[i]]
				local stagger_component = blackboard.stagger
				local is_staggered = stagger_component.num_triggered_staggers > 0

				if is_staggered then
					num_staggered_enemies = num_staggered_enemies + 1
				end
			end
		end

		if step_data.last_frame_num_staggered ~= num_staggered_enemies then
			step_data.last_frame_num_staggered = num_staggered_enemies
			local play_sound = true

			set_objective_tracker_value(step_data.grenade_objective, num_staggered_enemies, play_sound)
		end

		local player_unit = player.player_unit
		local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

		if ability_extension:remaining_ability_charges("grenade_ability") == 0 then
			local grenade_pack_exists = ALIVE[step_data.grenade_pack_unit]

			if not grenade_pack_exists then
				local reference_unit = player.player_unit
				step_data.grenade_pack_unit = spawn_pickup_relative_safe(scenario_system, player, reference_unit, "small_grenade", Vector3(0, 2, 0), -Vector3.forward(), DEFAULT_APPLY_MARKER, "player_reset")
			end
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end

		despawn_pickup(step_data.grenade_pack_unit)
	end
}
steps.ranged_grenade_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.ranged_grenade)
	end
}
steps.kill_enemies_grenade_loop = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 5
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-2, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-1, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(0, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(1, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(2, 10, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.target_kill_count <= step_data.kill_count

		if condition_met then
			return true
		end

		local player_unit = player.player_unit
		local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

		if ability_extension:remaining_ability_charges("grenade_ability") == 0 then
			local grenade_pack_exists = ALIVE[step_data.grenade_pack_unit]

			if not grenade_pack_exists then
				local reference_unit = player.player_unit
				step_data.grenade_pack_unit = spawn_pickup_relative_safe(scenario_system, player, reference_unit, "small_grenade", Vector3(0, 2, 0), -Vector3.forward(), DEFAULT_APPLY_MARKER, "player_reset")
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.kill_count = step_data.kill_count + 1
		local play_sound = false
		local t = FixedFrame.get_latest_fixed_time()

		if not step_data.last_sound_t or t > step_data.last_sound_t + 0.1 then
			step_data.last_sound_t = t
			play_sound = true
		end

		set_objective_tracker_value("grenade", step_data.kill_count, play_sound)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end

		despawn_pickup(step_data.grenade_pack_unit)
	end
}
steps.bonebreaker_blitz_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.bonebreaker_blitz)
	end
}
steps.kill_enemies_grenade_loop_ogryn = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 1
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "renegade_executor",
				relative_position = Vector3(-1, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "renegade_executor",
				relative_position = Vector3(1, 10, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.target_kill_count <= step_data.kill_count

		if condition_met then
			return true
		end

		local player_unit = player.player_unit
		local ability_extension = ScriptUnit.extension(player_unit, "ability_system")

		if ability_extension:remaining_ability_charges("grenade_ability") == 0 then
			local grenade_pack_exists = ALIVE[step_data.grenade_pack_unit]

			if not grenade_pack_exists then
				local reference_unit = player.player_unit
				step_data.grenade_pack_unit = spawn_pickup_relative_safe(scenario_system, player, reference_unit, "small_grenade", Vector3(0, 2, 0), -Vector3.forward(), DEFAULT_APPLY_MARKER, "player_reset")
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.kill_count = step_data.kill_count + 1
		local play_sound = false
		local t = FixedFrame.get_latest_fixed_time()

		if not step_data.last_sound_t or t > step_data.last_sound_t + 0.1 then
			step_data.last_sound_t = t
			play_sound = true
		end

		set_objective_tracker_value("bonebreaker_blitz", step_data.kill_count, play_sound)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end

		despawn_pickup(step_data.grenade_pack_unit)
	end
}
steps.biomancer_blitz_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.biomancer_blitz)
	end
}
steps.biomancer_blitz_loop = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 3
		step_data.enemies = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local condition_met = step_data.target_kill_count <= step_data.kill_count

		if condition_met then
			return true
		end

		local player_unit = player.player_unit
		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive and not step_data.ramping_spawn_ids then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(-3, 10, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_ogryn_executor",
					relative_position = Vector3(0, 10, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_sniper",
					relative_position = Vector3(3, 10, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		local damage_profile = kill_data_scratchpad.damage_profile

		if damage_profile and damage_profile.name == "psyker_smite_kill" then
			step_data.kill_count = step_data.kill_count + 1

			set_objective_tracker_value("biomancer_blitz", step_data.kill_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.tagging_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.tagging)
	end
}
steps.sniper_tag_loop = {
	events = {
		"on_tag"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.pinged_target = false
		step_data.pinged_world = false
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemy_unit = step_data.enemy_unit

		if not HEALTH_ALIVE[enemy_unit] and not step_data.pinged_target then
			dissolve_unit(enemy_unit, t)

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_sniper",
					relative_position = Vector3(0, 10, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemy_unit = spawned_enemies[1]
		end

		local condition_met = step_data.pinged_target and step_data.pinged_world

		if condition_met then
			step_data.complete_grace_timer = step_data.complete_grace_timer or t + 1.5

			if step_data.complete_grace_timer < t then
				return true
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, tag_event_data)
		local target_unit = tag_event_data.target_unit
		local target_locaction = tag_event_data.target_locaction

		if target_unit and not step_data.pinged_target then
			set_objective_tracker_value("tag_sniper", 1, true)

			step_data.pinged_target = true

			remove_objective_marker(target_unit)
		elseif not step_data.pinged_world then
			set_objective_tracker_value("tag_world", 1, true)

			step_data.pinged_world = true
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.dodge_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.dodge)
	end
}
steps.dodge_loop = {
	events = {
		"on_dodge",
		"on_successful_dodge",
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.dodge_left = false
		step_data.dodge_backward = false
		step_data.dodge_right = false
		step_data.dodge_melee = 0
		step_data.target_melee_dodges = 3
		step_data.do_once = false
		step_data.enemies = {}
		step_data.player_hit = 0
		step_data.time_manager = Managers.time
		step_data.slow_time_scale = 0.05
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_melee_dodges <= step_data.dodge_melee then
			step_data.complete_grace_timer = step_data.complete_grace_timer or t + 1

			if step_data.complete_grace_timer < t then
				return true
			end

			return false
		end

		local enemy_unit = step_data.enemy_unit

		if not HEALTH_ALIVE[enemy_unit] and step_data.dodge_left and step_data.dodge_right and step_data.dodge_backward then
			dissolve_unit(enemy_unit, t)

			local reference_unit = player.player_unit
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_executor",
					relative_position = Vector3(0, 8, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemy_unit = spawned_enemies[1]
			step_data.blackboard = BLACKBOARDS[step_data.enemy_unit]
		end

		local behavior_extension = ScriptUnit.has_extension(step_data.enemy_unit, "behavior_system")
		local brain = behavior_extension and behavior_extension:brain()
		local current_action = brain and brain:running_action()
		local t_raw = step_data.time_manager:time("main")
		local current_scale = step_data.time_manager:local_scale("gameplay")

		if not step_data.is_attacking then
			if current_action == "melee_attack" or current_action == "running_melee_attack" then
				step_data.is_attacking = true
				step_data.raw_t = t_raw
				local current_lerp_t = math.ilerp(1, step_data.slow_time_scale, current_scale)
				step_data.lerp_t = current_lerp_t
				step_data.from_scale = 1
				step_data.to_scale = step_data.slow_time_scale
				step_data.transition_time = 0.5

				if step_data.dodge_melee < step_data.target_melee_dodges and step_data.player_hit >= 2 then
					step_data.manipulate_time = true
				end
			elseif current_action == "moving_melee_attack" or current_action == "moving_melee_cleave_attack" or current_action == "melee_cleave_attack" then
				step_data.is_attacking = true
				step_data.raw_t = step_data.time_manager:time("main")
				local current_lerp_t = math.ilerp(1, step_data.slow_time_scale, current_scale)
				step_data.lerp_t = current_lerp_t
				step_data.from_scale = 1
				step_data.to_scale = step_data.slow_time_scale
				step_data.transition_time = 2

				if step_data.dodge_melee < step_data.target_melee_dodges and step_data.player_hit >= 2 then
					step_data.manipulate_time = true
				end
			elseif current_scale < 1 then
				step_data.manipulate_time = false

				step_data.time_manager:set_local_scale("gameplay", 1)
			end
		end

		if step_data.is_attacking and current_action ~= "melee_attack" and current_action ~= "running_melee_attack" and current_action ~= "moving_melee_attack" and current_action ~= "melee_cleave_attack" and current_action ~= "moving_melee_cleave_attack" then
			step_data.is_attacking = false
		end

		local player_unit = player.player_unit
		local data_ext = ScriptUnit.extension(player_unit, "unit_data_system")
		local inair_state_component = data_ext:has_component("inair_state") and data_ext:read_component("inair_state")
		local on_ground = inair_state_component and inair_state_component.on_ground

		if not on_ground then
			step_data.manipulate_time = false

			step_data.time_manager:set_local_scale("gameplay", 1)
		end

		if step_data.manipulate_time then
			local raw_t = step_data.time_manager:time("main")
			local dt = raw_t - step_data.raw_t
			step_data.lerp_t = step_data.lerp_t + dt / step_data.transition_time
			local new_scale = math.lerp(step_data.from_scale, step_data.to_scale, step_data.lerp_t)
			new_scale = math.clamp(new_scale, step_data.to_scale, step_data.from_scale)
			step_data.raw_t = raw_t

			if math.abs(new_scale - step_data.to_scale) < 0.01 then
				step_data.time_manager:set_local_scale("gameplay", step_data.to_scale)

				step_data.manipulate_time = false
			else
				step_data.time_manager:set_local_scale("gameplay", new_scale)
			end
		end

		if not step_data.do_once and step_data.dodge_left and step_data.dodge_right and step_data.dodge_backward then
			if not step_data.grace_timer then
				remove_objective_tracker(nil, true)

				step_data.grace_timer = t + 1.5
			end

			if step_data.grace_timer and step_data.grace_timer < t then
				remove_unique_buff(player.player_unit, "tg_player_unperceivable", scenario_data)
				add_objective_tracker("dodge_melee", true)

				step_data.do_once = true
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, event_data)
		if event_name == "on_damaged" then
			local attacked_unit = event_data.attacked_unit
			local player_unit = player.player_unit

			if player_unit and attacked_unit and player_unit == attacked_unit then
				step_data.player_hit = step_data.player_hit + 1
			end
		elseif event_name == "on_dodge" then
			step_data.manipulate_time = false

			step_data.time_manager:set_local_scale("gameplay", 1)

			local direction = event_data.direction

			if direction then
				if not step_data.dodge_left and direction.x and direction.x < 0 then
					step_data.dodge_left = true

					set_objective_tracker_value("dodge_left", 1, true)
				end

				if not step_data.dodge_right and direction.x and direction.x > 0 then
					step_data.dodge_right = true

					set_objective_tracker_value("dodge_right", 1, true)
				end

				if not step_data.dodge_backward and direction.y and direction.y < 0 then
					step_data.dodge_backward = true

					set_objective_tracker_value("dodge_backward", 1, true)
				end
			end
		else
			step_data.dodge_melee = step_data.dodge_melee + 1

			set_objective_tracker_value("dodge_melee", step_data.dodge_melee, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
		step_data.time_manager:set_local_scale("gameplay", 1)
	end
}
steps.sprint_slide_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.sprint_slide)
	end
}
steps.sprint_slide = {
	events = {
		"on_slide"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.slide_count = 0
		step_data.slide_target = 2
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return step_data.slide_target <= step_data.slide_count
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, event_data)
		if event_name == "on_slide" and step_data.slide_count < step_data.slide_target then
			step_data.slide_count = step_data.slide_count + 1

			set_objective_tracker_value("slide", step_data.slide_count, true)
		end
	end
}

local function _setup_sprint_dodge_enemy(scenario_system, player, enemy_unit, target_directional_unit_name, t)
	local directional_unit = scenario_system:get_directional_unit(target_directional_unit_name)
	local position = Unit.local_position(directional_unit, 1)
	local rotation = Unit.local_rotation(directional_unit, 1)
	local behavior_extension = ScriptUnit.extension(enemy_unit, "behavior_system")

	behavior_extension:override_brain("renegade_rifleman_tg", t)

	local blackboard = BLACKBOARDS[enemy_unit]
	local perception_component = Blackboard.write_component(blackboard, "perception")
	perception_component.lock_target = true

	perception_component.target_position:store(position)

	perception_component.target_unit = player.player_unit
	local perception_extension = ScriptUnit.extension(enemy_unit, "perception_system")

	MinionPerception.attempt_aggro(perception_extension)
end

steps.sprint_dodge_run_through_corridor = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.sprint_dodge)

		step_data.transition_time = 0.7

		Stamina.drain(player.player_unit, -500, t)

		scenario_data.sprint_dodge_world_spawned = true

		scenario_system:spawn_attached_units_in_spawn_group("arena_b_cover_left")
		scenario_system:spawn_attached_units_in_spawn_group("arena_b_cover_middle_right")
		scenario_system:spawn_attached_units_in_spawn_group("arena_b_cover_right")

		local end_directional_unit = scenario_system:get_directional_unit("sprint_player_end")

		add_objective_marker(end_directional_unit, "objective")

		local enemy_side_id = 2
		local apply_marker = false
		scenario_data.enemies = {
			spawn_breed_directional_unit("renegade_rifleman", "sprint_dodge_enemy_1", t, DEFAULT_SPAWN_DURATION, apply_marker, enemy_side_id),
			spawn_breed_directional_unit("renegade_rifleman", "sprint_dodge_enemy_2", t, DEFAULT_SPAWN_DURATION, apply_marker, enemy_side_id)
		}

		_setup_sprint_dodge_enemy(scenario_system, player, scenario_data.enemies[1], "sprint_dodge_target_1", t)
		_setup_sprint_dodge_enemy(scenario_system, player, scenario_data.enemies[2], "sprint_dodge_target_2", t)

		local end_directional_unit = scenario_system:get_directional_unit("sprint_player_end")
		step_data.end_rotation = QuaternionBox(Unit.local_rotation(end_directional_unit, 1))
		step_data.end_position = Vector3Box(Unit.local_position(end_directional_unit, 1))
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.manipulate_time then
			local raw_t = Managers.time:time("main")
			local dt = raw_t - step_data.raw_t
			step_data.lerp_t = step_data.lerp_t + dt / step_data.transition_time
			local new_scale = math.lerp(1, 0.05, step_data.lerp_t)
			new_scale = math.clamp(new_scale, 0.05, 1)
			step_data.raw_t = raw_t

			if math.abs(new_scale - 0.05) < 0.01 then
				Managers.time:set_local_scale("gameplay", 0.05)

				if not step_data.initiate_teleport then
					step_data.initiate_teleport = t + 0.04
				end

				step_data.manipulate_time = false
			else
				Managers.time:set_local_scale("gameplay", new_scale)
			end
		end

		if step_data.initiate_teleport and step_data.initiate_teleport < t then
			step_data.initiate_teleport = nil

			Managers.time:set_local_scale("gameplay", 1)
			teleport_player(scenario_system, player, "sprint_player_start")
		end

		local player_unit = player.player_unit
		local player_pos = POSITION_LOOKUP[player_unit]
		local reset_pos = POSITION_LOOKUP[scenario_system:get_directional_unit("sprint_player_start")]

		if step_data.damage_taken and Vector3.distance_squared(player_pos, reset_pos) > 1 then
			return false
		end

		step_data.damage_taken = false
		local end_diff = player_pos - step_data.end_position:unbox()
		local end_rotated_diff = Quaternion.rotate(Quaternion.inverse(step_data.end_rotation:unbox()), end_diff)
		local distance_from_end = end_rotated_diff[2]

		if distance_from_end < 4 then
			set_objective_tracker_value("sprint", 1, true)

			return true
		end

		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			local enemy_unit = enemies[i]
			local blackboard = BLACKBOARDS[enemy_unit]
			local perception_component = Blackboard.write_component(blackboard, "perception")
			local target_pos = Vector3.flat(perception_component.target_position:unbox())
			local enemy_pos = Vector3.flat(POSITION_LOOKUP[enemy_unit])
			local dir_to_target = Vector3.normalize(target_pos - enemy_pos)
			local vec_to_player = Vector3.flat(player_pos) - enemy_pos
			local dist_to_player_sq = Vector3.length_squared(vec_to_player)
			local dist_to_closest = Vector3.dot(dir_to_target, vec_to_player)
			local player_dist_from_line_sq = dist_to_player_sq - dist_to_closest * dist_to_closest
			local damage_dist_sq = 0.0625

			if player_dist_from_line_sq < damage_dist_sq then
				local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
				local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
				local is_sprinting = sprint_character_state_component.is_sprinting
				local stamina_read_component = unit_data_extension:read_component("stamina")
				local specialization = unit_data_extension:specialization()
				local specialization_stamina_template = specialization.stamina
				local current_stamina = Stamina.current_and_max_value(player_unit, stamina_read_component, specialization_stamina_template)
				local have_sprint_overtime = sprint_character_state_component.sprint_overtime > 0
				local movement_state_component = unit_data_extension:read_component("movement_state")
				local is_sliding = movement_state_component.method == "sliding"

				if (not is_sprinting or have_sprint_overtime) and not is_sliding then
					local health_extension = ScriptUnit.extension(player_unit, "health_system")

					health_extension:add_damage(1, 0)
					Attack.execute(player_unit, DamageProfileTemplates.default_lasgun_killshot, "attack_direction", dir_to_target, "power_level", 1, "hit_zone_name", "torso", "damage_type", damage_types.minion_melee_blunt)
				end
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, event_params)
		if not step_data.damage_taken and event_params.attacked_unit == player.player_unit then
			step_data.damage_taken = true
			local t = Managers.time:time("gameplay")
			step_data.raw_t = Managers.time:time("main")
			step_data.manipulate_time = true
			local current_scale = Managers.time:local_scale("gameplay")
			local current_lerp_t = math.ilerp(1, 0.05, current_scale)
			step_data.lerp_t = current_lerp_t
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		Managers.time:set_local_scale("gameplay", 1)

		local end_directional_unit = scenario_system:get_directional_unit("sprint_player_end")

		remove_objective_marker(end_directional_unit)
	end
}
steps.sprint_dodge_flank_enemies = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local end_directional_unit = scenario_system:get_directional_unit("sprint_override_brain")

		add_objective_marker(end_directional_unit, "objective")

		step_data.end_rotation = QuaternionBox(Unit.local_rotation(end_directional_unit, 1))
		step_data.end_position = Vector3Box(Unit.local_position(end_directional_unit, 1))
		step_data.bridge_spawn_data = spawn_unit_directional_unit(player, nil, nil, "sprint_dodge_bridge_vfx", t, DEFAULT_SPAWN_DURATION)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local bridge_ready = step_data.bridge_spawn_data.done

		if not scenario_data.bridge_spawned and bridge_ready then
			scenario_data.bridge_spawned = true

			scenario_system:spawn_attached_units_in_spawn_group("sprint_dodge_bridge")

			local bridge_blocker_unit_ext_1 = scenario_system:get_directional_unit_extension("sprint_dodge_bridge_blocker_1")

			bridge_blocker_unit_ext_1:unspawn_attached_unit()

			local bridge_blocker_unit_ext_2 = scenario_system:get_directional_unit_extension("sprint_dodge_bridge_blocker_2")

			bridge_blocker_unit_ext_2:unspawn_attached_unit()
		end

		local player_pos = POSITION_LOOKUP[player.player_unit]
		local end_diff = player_pos - step_data.end_position:unbox()
		local end_rotated_diff = Quaternion.rotate(Quaternion.inverse(step_data.end_rotation:unbox()), end_diff)
		local distance_from_end = end_rotated_diff[2]

		if distance_from_end < 4 then
			local enemies = scenario_data.enemies

			for i = 1, #enemies do
				local enemy_unit = enemies[i]
				local behavior_extension = ScriptUnit.extension(enemy_unit, "behavior_system")

				behavior_extension:override_brain("renegade_rifleman", t)

				local perception_extension = ScriptUnit.extension(enemy_unit, "perception_system")

				MinionPerception.attempt_aggro(perception_extension)
			end

			return true
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local end_directional_unit = scenario_system:get_directional_unit("sprint_override_brain")

		remove_objective_marker(end_directional_unit)
	end
}
steps.sprint_dodge_kill_enemies = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.locked_enemies = {}
		step_data.num_locked_enemies = 0
		step_data.killed_enemies = 0
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies
		local locked_enemies = step_data.locked_enemies
		local condition_met = true

		for i = 1, #enemies do
			local enemy_unit = enemies[i]

			if not locked_enemies[enemy_unit] then
				local blackboard = BLACKBOARDS[enemies[i]]

				if blackboard then
					local behavior_component = blackboard.behavior
					local combat_range = behavior_component.combat_range

					if combat_range == "melee" then
						locked_enemies[enemy_unit] = true
						step_data.num_locked_enemies = step_data.num_locked_enemies + 1

						set_objective_tracker_value("lock_in_melee", step_data.num_locked_enemies, true)
					end
				end
			end

			if HEALTH_ALIVE[enemies[i]] then
				condition_met = false
			end
		end

		return condition_met
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.killed_enemies = step_data.killed_enemies + 1

		set_objective_tracker_value("lock_in_melee_2", step_data.killed_enemies, true)
	end
}
steps.sprint_dodge_cleanup = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		if scenario_data.sprint_dodge_world_spawned then
			scenario_system:unspawn_attached_units_in_spawn_group("arena_b_cover_left")
			scenario_system:unspawn_attached_units_in_spawn_group("arena_b_cover_middle_right")
			scenario_system:unspawn_attached_units_in_spawn_group("arena_b_cover_right")
		end

		if scenario_data.bridge_spawned then
			scenario_system:unspawn_attached_units_in_spawn_group("sprint_dodge_bridge")

			local bridge_blocker_unit_ext_1 = scenario_system:get_directional_unit_extension("sprint_dodge_bridge_blocker_1")
			local blocker_unit_1 = bridge_blocker_unit_ext_1:spawn_attached_unit()

			Unit.set_unit_visibility(blocker_unit_1, false)

			local bridge_blocker_unit_ext_2 = scenario_system:get_directional_unit_extension("sprint_dodge_bridge_blocker_2")
			local blocker_unit_2 = bridge_blocker_unit_ext_2:spawn_attached_unit()

			Unit.set_unit_visibility(blocker_unit_2, false)
		end

		local enemies = scenario_data.enemies

		if enemies then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)
			end
		end
	end
}
steps.end_of_tg_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.end_of_tg)
	end
}
steps.end_of_tg_loop = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local reference_unit = scenario_system:get_directional_unit("arena_middle")

		add_objective_marker(reference_unit, "objective")

		local end_pos = Unit.local_position(reference_unit, 1) + Vector3(0, 0, 2)
		step_data.end_rotation = QuaternionBox(Unit.local_rotation(reference_unit, 1))
		step_data.end_position = Vector3Box(end_pos)

		scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_end_portal_spawned, end_pos)

		local world = scenario_system:world()
		local vfx_id = World.create_particles(world, "content/levels/training_grounds/fx/end_portal", end_pos, Quaternion.identity())
		local var_idx = World.find_particles_variable(world, "content/levels/training_grounds/fx/end_portal", "size")

		World.set_particles_variable(world, vfx_id, var_idx, Vector3(4.5, 4.5, 4.5))

		local player_pos = POSITION_LOOKUP[player.player_unit]
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_pos = POSITION_LOOKUP[player.player_unit]
		local distance_to_portal = Vector3.distance(Vector3.flat(player_pos), Vector3.flat(step_data.end_position:unbox()))

		if distance_to_portal < 1.2 then
			scenario_system:trigger_wwise_event(TrainingGroundsSoundEvents.tg_end_portal_entered)

			local local_player = Managers.player:local_player(1)

			Managers.event:trigger("event_cutscene_fade_in", local_player, 1, math.easeCubic)
			set_objective_tracker_value("end_of_tg", 1, false)

			return true
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		Managers.time:set_local_scale("gameplay", 1)

		local reference_unit = scenario_system:get_directional_unit("player_reset")

		remove_objective_marker(reference_unit)
	end
}
steps.lock_in_melee_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.lock_in_melee)
	end
}
steps.lock_in_melee_wait_for_kill = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.killed_target = false
		local player_unit = player.player_unit
		step_data.starting_position = Vector3Box(POSITION_LOOKUP[player_unit])
		step_data.timer = 0
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "renegade_rifleman",
				relative_position = Vector3(0, 24, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
		step_data.enemy_unit = spawned_enemies[1]
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local player_pos = POSITION_LOOKUP[player_unit]

		if step_data.timer < t and not step_data.buff_removed then
			step_data.timer = t + 1
			local starting_position = step_data.starting_position:unbox()
			local distance_moved_from_start = Vector3.distance(starting_position, player_pos)

			if distance_moved_from_start > 2 then
				step_data.buff_removed = true

				remove_unique_buff(player.player_unit, "tg_player_unperceivable", scenario_data)
			end
		end

		local enemy_pos = POSITION_LOOKUP[step_data.enemy_unit]

		if enemy_pos then
			local distance_to_enemy = Vector3.distance(enemy_pos, player_pos)

			if distance_to_enemy < 5 and not step_data.do_once then
				step_data.do_once = true

				set_objective_tracker_value("lock_in_melee", 1, true)
			end
		end

		return step_data.killed_target
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		set_objective_tracker_value("lock_in_melee_2", 1, true)

		step_data.killed_target = true
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy_unit, t)
	end
}
steps.toughness_damage = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local unit = player.player_unit

		Attack.execute(unit, DamageProfileTemplates.melee_fighter_default, "attack_direction", -Vector3.up(), "power_level", 500, "hit_zone_name", "torso", "damage_type", damage_types.minion_melee_blunt)
	end
}
steps.toughness_pre_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.toughness_pre)
	end
}
steps.toughness_pre_loop = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 2
		local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

		if health_extension then
			health_extension:set_invulnerable(true)
		end

		local toughness_extension = ScriptUnit.has_extension(player.player_unit, "toughness_system")

		if toughness_extension then
			toughness_extension:recover_max_toughness()
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.took_health_damage and step_data.took_toughness_damage and step_data.toughness_broken then
			return true
		end

		if not HEALTH_ALIVE[step_data.enemy] then
			local reference_unit = scenario_system:get_directional_unit("player_reset")
			local spawned_enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(0, 16, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
			step_data.enemy = spawned_enemies[1]
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, event_params)
		if event_params.attacked_unit == player.player_unit then
			local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

			if health_extension then
				local current_health = health_extension:current_health()
				local max_health = health_extension:max_health()

				if current_health < max_health then
					set_objective_tracker_value("toughness_pre_3", 1, true)

					step_data.took_health_damage = true
				end
			end

			local toughness_extension = ScriptUnit.has_extension(player.player_unit, "toughness_system")

			if toughness_extension then
				local max_toughness = toughness_extension:max_toughness()

				toughness_extension:add_damage(max_toughness / 10)
			end

			if not step_data.took_toughness_damage then
				set_objective_tracker_value("toughness_pre_1", 1, true)

				step_data.took_toughness_damage = true
			end

			local toughness_extension = ScriptUnit.has_extension(player.player_unit, "toughness_system")

			if toughness_extension then
				local current_toughness = toughness_extension:current_toughness_percent()

				if current_toughness <= 0 then
					local health_extension = ScriptUnit.has_extension(player.player_unit, "health_system")

					if health_extension then
						health_extension:set_invulnerable(false)
					end

					set_objective_tracker_value("toughness_pre_2", 1, true)

					step_data.toughness_broken = true
				end
			end
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		dissolve_unit(step_data.enemy, t)
	end
}
steps.toughness_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.toughness)
	end
}
steps.toughness_wait_for_kill = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 2
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "renegade_rifleman",
				relative_position = Vector3(-2, 6, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "renegade_rifleman",
				relative_position = Vector3(2, 6, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return step_data.target_kill_count <= step_data.kill_count
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		step_data.kill_count = step_data.kill_count + 1

		set_objective_tracker_value("toughness_melee", step_data.kill_count, true)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.toughness_spawn_bot = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.bot_local_id = scenario_system:queue_bot_addition()
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local peer_id = Network.peer_id()
		local local_bot_player_id = step_data.bot_local_id
		local bot_player = Managers.player:player(peer_id, local_bot_player_id)
		local bot_is_spawned = bot_player and bot_player.player_unit

		if not bot_is_spawned then
			return false
		end

		local coherency_extension = ScriptUnit.extension(bot_player.player_unit, "coherency_system")

		if not step_data.do_once then
			step_data.do_once = true
			local reference_unit = scenario_system:get_directional_unit("player_reset")
			local position, rotation = get_relative_position_rotation(reference_unit, Vector3(0, 18, 0), -Vector3.forward(), DEFAULT_GROUND_POSITION)
			step_data.boxed_position = Vector3Box(position)

			PlayerMovement.teleport(bot_player, position, rotation)

			local radius, limit = coherency_extension:current_radius()
			radius = radius + 1
			step_data.decal_radius_sq = radius * radius
			step_data.decal_unit, step_data.decal_is_linked = display_radius(scenario_system, position, radius, bot_player.player_unit)
			local behavior_extension = ScriptUnit.extension(bot_player.player_unit, "behavior_system")

			behavior_extension:set_hold_position(position, math.huge)
		end

		local player_position = POSITION_LOOKUP[player.player_unit]
		local bot_position = POSITION_LOOKUP[bot_player.player_unit]

		if step_data.bot_teleported and not step_data.fadeout_t and Vector3.distance_squared(player_position, step_data.boxed_position:unbox()) < step_data.decal_radius_sq then
			step_data.fadeout_t = t
			step_data.coherency_area_entered = true
		end

		if step_data.fadeout_t then
			local duration = 1

			fadeout_radius(step_data.decal_unit, t, step_data.fadeout_t, duration)
		end

		if not step_data.bot_teleported and step_data.boxed_position and Vector3.distance(bot_position, Vector3Box.unbox(step_data.boxed_position)) < 1 then
			step_data.bot_teleported = true
			local bot_unit = bot_player.player_unit
			local bot_position = POSITION_LOOKUP[bot_unit]

			spawn_spawn_vfx(scenario_system, bot_position)
		end

		if not step_data.buffs_swapped and (step_data.coherency_area_entered or coherency_extension:num_units_in_coherency() == 0) then
			step_data.buffs_swapped = true

			remove_unique_buff(player.player_unit, "tg_no_coherency", scenario_data)

			local specialization_extension = ScriptUnit.has_extension(player.player_unit, "specialization_system")
			local specialization_name = specialization_extension:get_specialization_name()

			if specialization_name == "ogryn_2" then
				add_unique_buff(player.player_unit, "tg_increased_coherency_ogryn_2", scenario_data, t)
			elseif specialization_name == "psyker_2" then
				add_unique_buff(player.player_unit, "tg_increased_coherency_psyker_2", scenario_data, t)
			elseif specialization_name == "zealot_2" then
				add_unique_buff(player.player_unit, "tg_increased_coherency_zealot_2", scenario_data, t)
			elseif specialization_name == "veteran_2" then
				add_unique_buff(player.player_unit, "tg_increased_coherency_veteran_2", scenario_data, t)
			else
				add_unique_buff(player.player_unit, "tg_increased_coherency", scenario_data, t)
			end
		end

		local player_unit = player.player_unit
		local toughness_extension = ScriptUnit.has_extension(player_unit, "toughness_system")

		if toughness_extension then
			local toughness_percent = toughness_extension:current_toughness_percent()

			if toughness_percent >= 1 then
				set_objective_tracker_value("toughness_coherency", 1, true)

				return true
			end
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		scenario_data.bot_local_id = step_data.bot_local_id
		local decal_unit = step_data.decal_unit

		if decal_unit then
			local world = scenario_system:world()

			if step_data.decal_is_linked then
				World.unlink_unit(world, decal_unit, false)
			end

			World.destroy_unit(world, decal_unit)
		end
	end
}
steps.toughness_remove_bot = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local bot_local_id = scenario_data.bot_local_id
		local peer_id = Network.peer_id()
		local bot_player = Managers.player:player(peer_id, bot_local_id)
		local bot_unit = bot_player.player_unit
		local bot_position = POSITION_LOOKUP[bot_unit]

		spawn_despawn_vfx(scenario_system, bot_position)
		scenario_system:queue_bot_removal(bot_local_id)
	end
}
steps.combat_ability_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.combat_ability)
	end
}
steps.combat_ability_prompt_ogryn = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.combat_ability_bone_breaker)
	end
}
steps.combat_ability_prompt_psyker = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.combat_ability_biomancer)
	end
}
steps.combat_ability_prompt_zealot = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.combat_ability_maniac)
	end
}
steps.combat_ability_loop_grunt = {
	events = {
		"on_killed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.kill_count = 0
		step_data.target_kill_count = 2
		step_data.enemies = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		ensure_has_ammo(player)

		if step_data.target_kill_count <= step_data.kill_count then
			return true
		end

		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_sniper",
					relative_position = Vector3(-0.5, 15, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_gunner",
					relative_position = Vector3(0.5, 15, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(3, 16, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(4, 16, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(-3, 16, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_rifleman",
					relative_position = Vector3(-4, 16, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, kill_data_scratchpad)
		local player_unit = player.player_unit
		local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")

		if buff_extension and buff_extension:has_keyword("veteran_ranger_combat_ability") then
			step_data.kill_count = step_data.kill_count + 1

			set_objective_tracker_value("combat_ability", step_data.kill_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.combat_ability_loop_maniac = {
	events = {
		"on_damaged",
		"on_combat_ability"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.crit_count = 0
		step_data.target_crit_count = 2
		step_data.dash_count = 0
		step_data.dash_count_target = 2
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "renegade_rifleman",
				relative_position = Vector3(-3.5, 14, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "renegade_sniper",
				relative_position = Vector3(5, 24, 0),
				relative_look_direction = -Vector3.forward()
			}
		})

		ScriptUnit.extension(step_data.enemies[1], "health_system"):set_unkillable(true)
		ScriptUnit.extension(step_data.enemies[2], "health_system"):set_unkillable(true)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if step_data.target_crit_count <= step_data.crit_count and step_data.dash_count_target <= step_data.dash_count then
			return true
		end

		ensure_has_combat_ability(player, step_data, t, 1.5)

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, scratchpad)
		if event_name == "on_damaged" then
			local is_critical_strike = scratchpad.is_critical_strike
			local buff_extension = ScriptUnit.extension(player.player_unit, "buff_system")
			local has_dash_buff = false
			local buffs = buff_extension:buffs()

			for i = #buffs, 1, -1 do
				local buff_template = buffs[i]:template()

				if buff_template.name == "zealot_maniac_dash_buff" then
					has_dash_buff = true

					break
				end
			end

			if is_critical_strike and has_dash_buff then
				local unit = scratchpad.attacked_unit
				local health_extension = ScriptUnit.extension(unit, "health_system")

				health_extension:set_unkillable(false)
				Attack.execute(unit, DamageProfileTemplates.melee_fighter_default, "attack_direction", -Vector3.up(), "power_level", 50000, "hit_zone_name", "torso", "damage_type", damage_types.minion_melee_blunt)

				step_data.crit_count = step_data.crit_count + 1

				set_objective_tracker_value("combat_ability_zealot_2", step_data.crit_count, true)
			end
		else
			step_data.dash_count = step_data.dash_count + 1

			set_objective_tracker_value("combat_ability_zealot_1", step_data.dash_count, true)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.combat_ability_loop_bone_breaker = {
	events = {
		"on_damaged"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.small_stagger_count = 0
		step_data.target_stagger_count = 5
		step_data.big_stagger = false
		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-1, 7, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(1, 7, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-1, 8, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(1, 8, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-1, 9, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(1, 9, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(-1, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_newly_infected",
				relative_position = Vector3(1, 10, 0),
				relative_look_direction = -Vector3.forward()
			},
			{
				breed_name = "chaos_ogryn_executor",
				relative_position = Vector3(0, 11.5, 0),
				relative_look_direction = -Vector3.forward()
			}
		})
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local ability_extension = ScriptUnit.extension(player.player_unit, "ability_system")
		local max_cooldown = ability_extension:max_ability_cooldown("combat_ability")
		local remaining_cooldown = ability_extension:remaining_ability_cooldown("combat_ability")

		if remaining_cooldown ~= 0 and remaining_cooldown / max_cooldown < 0.8 then
			ability_extension:reduce_ability_cooldown_percentage("combat_ability", 1)
		end

		return step_data.target_stagger_count <= step_data.small_stagger_count and step_data.big_stagger
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local play_sound = false
		local t = FixedFrame.get_latest_fixed_time()

		if not step_data.last_sound_t or t > step_data.last_sound_t + 0.1 then
			play_sound = true
			step_data.last_sound_t = t
		end

		local breed = damage_data_scratchpad.breed_or_nil

		if breed and breed.name and breed.name == "chaos_ogryn_executor" then
			step_data.big_stagger = true

			set_objective_tracker_value("combat_ability_ogryn_2", 1, play_sound)
		else
			step_data.small_stagger_count = step_data.small_stagger_count + 1

			set_objective_tracker_value("combat_ability_ogryn_1", step_data.small_stagger_count, play_sound)
		end
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		scenario_data.enemies = step_data.enemies
	end
}
steps.combat_ability_ogryn_remove = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.combat_ability_loop_psyker_pre = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		WarpCharge.decrease_immediate(1, warp_charge_component, player_unit)

		local reference_unit = scenario_system:get_directional_unit("player_reset")
		step_data.enemies = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		if not step_data.timer or step_data.timer < t and not step_data.do_once then
			step_data.timer = t + 0.2
			local player_unit = player.player_unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local warp_charge_component = unit_data_extension:read_component("warp_charge")
			step_data.current_percentage = warp_charge_component.current_percentage
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			step_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(-2, 8, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(0, 8, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "renegade_melee",
					relative_position = Vector3(2, 8, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		if step_data.current_percentage >= 0.5 and not step_data.compleated then
			step_data.compleated = true
			step_data.grace_timer = t + 1.5
		end

		return step_data.grace_timer and step_data.grace_timer < t
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = step_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end

		remove_objective_tracker(nil, true)
	end
}
steps.combat_ability_loop_psyker = {
	events = {
		"on_damaged",
		"on_combat_ability"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.knock_back_count = 0
		step_data.target_knock_back_count = 5
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local warp_charge_component = unit_data_extension:write_component("warp_charge")

		WarpCharge.decrease_immediate(1, warp_charge_component, player_unit)
		WarpCharge.decrease_immediate(-0.7, warp_charge_component, player_unit)

		step_data.current_percentage = 0.7
		scenario_data.enemies = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies
		local enemies_alive = false

		for i = 1, #enemies do
			if HEALTH_ALIVE[enemies[i]] then
				enemies_alive = true

				break
			end
		end

		ensure_has_combat_ability(player, step_data, t, 1.5)

		if not step_data.timer or step_data.timer < t and not step_data.do_once then
			step_data.timer = t + 0.2
			local player_unit = player.player_unit
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local warp_charge_component = unit_data_extension:read_component("warp_charge")
			step_data.current_percentage = warp_charge_component.current_percentage
		end

		if not enemies_alive then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)

				enemies[i] = nil
			end

			local reference_unit = scenario_system:get_directional_unit("player_reset")
			scenario_data.enemies = spawn_enemies_relative_position_safe(scenario_system, player, reference_unit, "player_reset", t, DEFAULT_SPAWN_DURATION, DEFAULT_APPLY_MARKER, false, {
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(-2, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(0, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(2, 6, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(-2, 8, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(0, 8, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(2, 8, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(-2, 10, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(0, 10, 0),
					relative_look_direction = -Vector3.forward()
				},
				{
					breed_name = "chaos_newly_infected",
					relative_position = Vector3(2, 10, 0),
					relative_look_direction = -Vector3.forward()
				}
			})
		end

		return step_data.target_knock_back_count <= step_data.knock_back_count
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, damage_data_scratchpad)
		local play_sound = false
		local t = FixedFrame.get_latest_fixed_time()

		if not step_data.last_sound_t or t > step_data.last_sound_t + 0.1 then
			play_sound = true
			step_data.last_sound_t = t
		end

		if event_name == "on_damaged" then
			local attack_type = damage_data_scratchpad.attack_type

			if attack_type and attack_type == "shout" then
				step_data.knock_back_count = step_data.knock_back_count + 1

				set_objective_tracker_value("combat_ability_psyker_3", step_data.knock_back_count, play_sound)
			end
		end
	end
}
steps.combat_ability_biomancer_remove = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		for i = 1, #enemies do
			dissolve_unit(enemies[i], t)
		end
	end
}
steps.generic_dissolve_scenario_enemies = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemies = scenario_data.enemies

		if enemies then
			for i = 1, #enemies do
				dissolve_unit(enemies[i], t)
			end
		end
	end
}
steps.weapon_special_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.weapon_special)
	end
}
steps.m1_chain_attack_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.chain_attack)
	end
}
steps.reviving_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.reviving)
	end
}
steps.reviving_spawn_bot = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		scenario_data.bot_local_id = scenario_system:queue_bot_addition()
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local peer_id = Network.peer_id()
		local bot_local_id = scenario_data.bot_local_id
		local bot_player = Managers.player:player(peer_id, bot_local_id)

		if not bot_player or not bot_player.player_unit then
			return false
		end

		if not step_data.frame_delay then
			step_data.frame_delay = true

			return
		end

		local reference_unit = scenario_system:get_directional_unit("player_reset")
		local position, rotation = get_relative_position_rotation(reference_unit, Vector3(0, 6, 0), -Vector3.forward(), DEFAULT_GROUND_POSITION)

		PlayerMovement.teleport(bot_player, position, rotation)

		local bot_unit = bot_player.player_unit
		local bot_position = POSITION_LOOKUP[bot_unit]

		spawn_spawn_vfx(scenario_system, bot_position)

		scenario_data.bot_unit = bot_unit

		PlayerDeath.knock_down(bot_unit)
		add_unique_buff(bot_unit, "tg_player_resist_death", scenario_data, t)

		return true
	end
}
steps.reviving_wait_for_bot_revival = {
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local bot_unit = scenario_data.bot_unit
		local unit_data_extension = ScriptUnit.extension(bot_unit, "unit_data_system")
		local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")
		local bot_is_spawned = not not knocked_down_state_input

		if bot_is_spawned then
			if knocked_down_state_input.knock_down then
				return false
			end

			set_objective_tracker_value("reviving", 1, true)
			remove_unique_buff(bot_unit, "tg_player_resist_death", scenario_data)

			return true
		end

		return false
	end
}
steps.reviving_spawn_servitor = {
	events = {
		"tg_servitor_interact"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local servitor_handler = scenario_system:servitor_handler()
		step_data.servitor_handler = servitor_handler
		local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()
		local camera_position = Unit.local_position(first_person_unit, 1)
		local relative_camera_height = camera_position[3] - POSITION_LOOKUP[player.player_unit][3]

		servitor_handler:spawn_servitor(Vector3(100, 100, -100), Quaternion.identity())
		teleport_servitor_if_far_away(scenario_system, servitor_handler, player.player_unit)
		add_objective_marker(servitor_handler:unit(), "objective")
		servitor_handler:move_to_unit_relative_arc(player.player_unit, Vector3(0, 1, relative_camera_height), true, false, true)

		local interactee_extension = servitor_handler:interactee_extension()

		interactee_extension:set_active(true)
		interactee_extension:set_description("loc_training_grounds_force_down")
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		teleport_servitor_if_far_away(scenario_system, step_data.servitor_handler, player.player_unit)

		if step_data.interacted then
			if not step_data.grace_timer then
				step_data.grace_timer = t + 1.5
			elseif step_data.grace_timer < t then
				return true
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		step_data.interacted = true

		set_objective_tracker_value("corruption", 1, true)

		local player_unit = player.player_unit

		PlayerDeath.knock_down(player_unit)
		remove_objective_marker(step_data.servitor_handler:unit())

		local peer_id = Network.peer_id()
		local bot_local_id = scenario_data.bot_local_id
		local bot_player = Managers.player:player(peer_id, bot_local_id)
		local bot_position = POSITION_LOOKUP[bot_player.player_unit]
		local behavior_extension = ScriptUnit.extension(bot_player.player_unit, "behavior_system")

		behavior_extension:set_hold_position(bot_position, 0)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, event_name)
		step_data.servitor_handler:move_idle(player.player_unit, true)
		step_data.servitor_handler:interactee_extension():set_active(false)
	end
}
steps.reviving_wait_for_player_revival = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local peer_id = Network.peer_id()
		local bot_local_id = scenario_data.bot_local_id
		local bot_player = Managers.player:player(peer_id, bot_local_id)
		local behavior_extension = ScriptUnit.extension(bot_player.player_unit, "behavior_system")

		behavior_extension:set_hold_position(nil, nil)

		step_data.timeout_t = t + 15
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit

		if step_data.timeout_t < t then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
			assisted_state_input_component.force_assist = true

			return true
		end

		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")

		if character_state_component then
			if PlayerUnitStatus.is_knocked_down(character_state_component) then
				return false
			end

			return true
		end

		return false
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			local heal_amount = 5000
			local heal_type = DamageSettings.heal_types.blessing
			local heal_type = DamageSettings.heal_types.healing_station
		end
	end
}
steps.corruption_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.corruption)
	end
}
steps.health_station_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.health_station)
	end
}
steps.reviving_spawn_health_station = {
	events = {
		"on_health_station_activated"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		local quarter_health = health_extension:max_health() * 0.66
		local current_health = health_extension:current_health()
		local permanent_damage_to_deal = math.max(0, current_health - quarter_health)
		local unit_name = "content/environment/gameplay/health_station/health_station"
		local template_name = "health_station"
		local reference_unit = player.player_unit
		step_data.station_spawn_data = spawn_unit_relative_position_safe(reference_unit, player, unit_name, template_name, Vector3(0, 9, 0), Vector3.forward(), t, DEFAULT_SPAWN_DURATION, "player_reset")
		step_data.battery_spawn_data = spawn_unit_relative_position_safe(reference_unit, player, nil, nil, Vector3(-1.5, 7, 0), Vector3.forward(), t, DEFAULT_SPAWN_DURATION, "player_reset")
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local station_spawn_data = step_data.station_spawn_data

		if not station_spawn_data.done then
			return false
		end

		local health_station_unit = station_spawn_data.unit
		local health_station_extension = ScriptUnit.extension(health_station_unit, "health_station_system")

		if not step_data.battery_spawned then
			step_data.battery_spawned = true

			health_station_extension:spawn_battery()

			local battery_unit = health_station_extension:battery_unit()
			local battery_pos = Unit.local_position(battery_unit, 1)
			local wanted_pos = step_data.battery_spawn_data.position:unbox()
			wanted_pos[3] = battery_pos[3]

			Unit.set_local_position(battery_unit, 1, wanted_pos)
			add_objective_marker(health_station_extension:battery_unit(), "objective")

			step_data.battery_marked = true
		end

		local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local held_luggable = inventory_component.slot_luggable
		local powered_up = health_station_extension:battery_in_slot()
		local carrying_battery = held_luggable ~= "not_equipped"

		if not powered_up then
			if not carrying_battery and not step_data.battery_marked then
				step_data.battery_marked = true
				step_data.station_marked = false

				add_objective_marker(health_station_extension:battery_unit(), "objective")
				remove_objective_marker(health_station_unit)
			elseif carrying_battery and not step_data.station_marked then
				step_data.battery_marked = false
				step_data.station_marked = true

				add_objective_marker(health_station_unit, "objective")
				remove_objective_marker(health_station_extension:battery_unit())
			end

			return false
		end

		local player_health_extension = ScriptUnit.extension(player.player_unit, "health_system")
		local is_full_health = player_health_extension:damage_taken() <= 0

		if is_full_health then
			if not step_data.despawn_grace_t then
				set_objective_tracker_value("health_staton_objective_2", 1, true)

				step_data.despawn_grace_t = t + 1.5
			elseif step_data.despawn_grace_t < t then
				return true
			end
		end

		return false
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		set_objective_tracker_value("health_staton_objective_1", 1, true)
	end,
	stop_func = function (scenario_system, player, scenario_data, step_data, t)
		local health_station_unit = step_data.station_spawn_data.unit

		remove_objective_marker(health_station_unit)

		scenario_data.health_station_unit = health_station_unit
	end
}
steps.reviving_cleanup = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local bot_unit = scenario_data.bot_unit

		if bot_unit then
			local interactor_extension = ScriptUnit.extension(bot_unit, "interactor_system")

			interactor_extension:cancel_interaction(t)
		end

		if scenario_data.health_station_unit then
			Managers.state.unit_spawner:mark_for_deletion(scenario_data.health_station_unit)
		end
	end
}
steps.healing_self_and_others_prompt = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		display_info(TrainingGroundsInfoLookup.healing_self_and_others)
	end
}
steps.healing_self_and_others_spawn_bot = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		scenario_data.bot_local_id = scenario_system:queue_bot_addition()
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local peer_id = Network.peer_id()
		local bot_local_id = scenario_data.bot_local_id
		local bot_player = Managers.player:player(peer_id, bot_local_id)

		if not bot_player or not bot_player.player_unit then
			return false
		end

		if not step_data.do_once then
			step_data.do_once = true
			local bot_unit = bot_player.player_unit
			local bot_position = POSITION_LOOKUP[bot_unit]

			spawn_spawn_vfx(scenario_system, bot_position)
		end

		local reference_unit = scenario_system:get_directional_unit("player_reset")
		local position, rotation = get_relative_position_rotation(reference_unit, Vector3(0, 6, 0), -Vector3.forward(), DEFAULT_GROUND_POSITION)

		PlayerMovement.teleport(bot_player, position, rotation)

		scenario_data.bot_unit = bot_player.player_unit

		return true
	end
}
steps.spawn_med_and_ammo_kits = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:write_component("slot_secondary")

		Ammo.move_clip_to_reserve(inventory_slot_component)

		local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve

		Ammo.remove_from_reserve(inventory_slot_component, current_ammo_in_reserve)

		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		local half_health = health_extension:max_health() * 0.5
		local current_health = health_extension:current_health()
		local damage_to_deal = math.max(0, current_health - half_health)

		health_extension:add_damage(damage_to_deal, 0)

		local bot_unit = scenario_data.bot_unit
		local unit_data_extension = ScriptUnit.extension(bot_unit, "unit_data_system")
		local inventory_slot_component = unit_data_extension:write_component("slot_secondary")

		Ammo.move_clip_to_reserve(inventory_slot_component)

		local current_ammo_in_reserve = inventory_slot_component.current_ammunition_reserve

		Ammo.remove_from_reserve(inventory_slot_component, current_ammo_in_reserve)

		local health_extension = ScriptUnit.extension(bot_unit, "health_system")
		local half_health = health_extension:max_health() * 0.5
		local current_health = health_extension:current_health()
		local damage_to_deal = math.max(0, current_health - half_health)

		health_extension:add_damage(damage_to_deal, 0)
	end
}
steps.wait_for_full_health_and_ammo = {
	events = {
		"on_pickup_placed"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.heal_once = false
		step_data.ammo_once = false
		step_data.spawn_frequency = 15
		step_data.time_out = 30
		step_data.placed_ammo_pos = Vector3Box()
		step_data.placed_med_pos = Vector3Box()
		scenario_data.placed_units = {}
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local placed_units = scenario_data.placed_units
		local player_unit = player.player_unit
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local inventory_component = unit_data_extension:read_component("inventory")
		local held_pocketable = inventory_component.slot_pocketable

		if held_pocketable ~= "not_equipped" then
			remove_objective_marker(scenario_data.med_kit_unit)
			remove_objective_marker(scenario_data.ammo_kit_unit)
		end

		if not step_data.spawned_med and not step_data.heal_once and not ALIVE[scenario_data.placed_med_kit] then
			step_data.spawned_med = true
			local reference_unit = scenario_system:get_directional_unit("player_reset")
			scenario_data.med_kit_unit = spawn_pickup_relative_safe(scenario_system, player, reference_unit, "medical_crate_pocketable", Vector3(-0.75, 5, 0), -Vector3.forward(), DEFAULT_APPLY_MARKER, "player_reset")
		end

		if not step_data.spawned_ammo and not step_data.ammo_once and not ALIVE[scenario_data.placed_ammo_kit] then
			step_data.spawned_ammo = true
			local reference_unit = scenario_system:get_directional_unit("player_reset")
			scenario_data.ammo_kit_unit = spawn_pickup_relative_safe(scenario_system, player, reference_unit, "ammo_cache_pocketable", Vector3(0.75, 5, 0), -Vector3.forward(), DEFAULT_APPLY_MARKER, "player_reset")
		end

		local ammo_percentage = Ammo.current_slot_percentage(player_unit, "slot_secondary")
		local health_extension = ScriptUnit.extension(player_unit, "health_system")
		local health_is_full = health_extension:current_health_percent() == 1

		if ammo_percentage > 0.5 and not step_data.ammo_once then
			step_data.ammo_once = true

			set_objective_tracker_value("healing_objective_4", 1, true)
			remove_objective_marker(scenario_data.placed_ammo_kit)
		end

		if health_is_full and not step_data.heal_once then
			step_data.heal_once = true

			set_objective_tracker_value("healing_objective_3", 1, true)
			remove_objective_marker(scenario_data.placed_med_kit)
		end

		if #scenario_data.placed_units >= 2 then
			if not step_data.timeout_t then
				step_data.timeout_t = t + step_data.time_out
			end

			if step_data.timeout_t < t then
				Log.warning("TrainingGrounds", "Pocketables were placed but scenario timed out. Unreachable? Ammo: %s, Medcrate: %s", step_data.placed_ammo_pos, step_data.placed_med_pos)
				ensure_has_ammo(player)

				return true
			end
		end

		return ammo_percentage > 0.5 and health_is_full
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name, unit_placed)
		if ALIVE[unit_placed] then
			local side_relation_extension = ScriptUnit.has_extension(unit_placed, "proximity_system")

			if side_relation_extension then
				set_objective_tracker_value("healing_objective_1", 1, true)

				scenario_data.placed_med_kit = unit_placed
				step_data.spawned_med = false

				step_data.placed_med_pos:store(POSITION_LOOKUP[unit_placed])
			else
				set_objective_tracker_value("healing_objective_2", 1, true)

				scenario_data.placed_ammo_kit = unit_placed
				step_data.spawned_ammo = false

				step_data.placed_ammo_pos:store(POSITION_LOOKUP[unit_placed])
			end

			add_objective_marker(unit_placed, "objective")
		end

		scenario_data.placed_units[#scenario_data.placed_units + 1] = unit_placed

		if ALIVE[scenario_data.med_kit_unit] then
			add_objective_marker(scenario_data.med_kit_unit, "objective")
		elseif ALIVE[scenario_data.ammo_kit_unit] then
			add_objective_marker(scenario_data.ammo_kit_unit, "objective")
		end
	end
}
steps.health_and_ammo_cleanup = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local unit_spawner = Managers.state.unit_spawner
		local bot_local_id = scenario_data.bot_local_id

		if bot_local_id then
			local peer_id = Network.peer_id()
			local bot_player = Managers.player:player(peer_id, bot_local_id)
			local bot_unit = bot_player.player_unit
			local bot_position = POSITION_LOOKUP[bot_unit]

			if bot_position then
				spawn_despawn_vfx(scenario_system, bot_position)
			end

			scenario_system:queue_bot_removal(bot_local_id)
		end

		local ammo_kit = scenario_data.ammo_kit_unit

		if ALIVE[ammo_kit] then
			Unit.set_local_position(ammo_kit, 1, Vector3(0, 0, 0))
			despawn_pickup(ammo_kit)
		end

		local med_kit = scenario_data.med_kit_unit

		if ALIVE[med_kit] then
			Unit.set_local_position(med_kit, 1, Vector3(0, 0, 0))
			despawn_pickup(med_kit)
		end

		local placed_med_kit = scenario_data.placed_med_kit

		if ALIVE[placed_med_kit] then
			Unit.set_local_position(placed_med_kit, 1, Vector3(0, 0, 0))

			local side_relation_extension = ScriptUnit.has_extension(placed_med_kit, "proximity_system")

			if side_relation_extension then
				side_relation_extension:cancel_job()
			end
		end

		local placed_ammo_kit = scenario_data.placed_ammo_kit

		if ALIVE[placed_ammo_kit] then
			Unit.set_local_position(placed_ammo_kit, 1, Vector3(0, 0, 0))
			despawn_pickup(placed_ammo_kit)
		end
	end
}
steps.remove_all_bots = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local bot_synchronizer_host = Managers.bot:synchronizer_host()
		local active_bot_ids = bot_synchronizer_host:active_bot_ids()
		local world = scenario_system:world()
		local peer_id = Network.peer_id()

		for bot_local_id, _ in pairs(active_bot_ids) do
			local bot_player = Managers.player:player(peer_id, bot_local_id)

			if bot_player and bot_player.player_unit then
				local bot_position = POSITION_LOOKUP[bot_player.player_unit]

				spawn_despawn_vfx(scenario_system, bot_position)
			end

			scenario_data.bot_local_id = scenario_system:queue_bot_removal(bot_local_id)
		end
	end
}
steps.transition_show = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		show_transition(true)
	end
}
steps.transition_hide = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		show_transition(false)
	end
}
steps.part_1_completed_decide_continue = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local cb_continue = callback(function ()
			scenario_data.continue_training = true
			step_data.chosen = true
		end)
		local cb_quit = callback(function ()
			step_data.chosen = true
		end)
		local context = {
			title_text = "loc_training_grounds_choice_header_advanced",
			description_text = "loc_training_grounds_choice_body",
			options = {
				{
					text = "loc_training_grounds_choice_continue",
					close_on_pressed = true,
					callback = cb_continue
				},
				{
					text = "loc_training_grounds_choice_quit",
					close_on_pressed = true,
					callback = cb_quit
				}
			}
		}

		Managers.event:trigger("event_show_ui_popup", context)
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return step_data.chosen
	end
}
steps.advanced_training = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local telemetry_reporters = Managers.telemetry_reporters
		local existing_reporter = telemetry_reporters:reporter("training_grounds")

		if not existing_reporter then
			telemetry_reporters:start_reporter("training_grounds")

			local training_grounds_reporter = telemetry_reporters:reporter("training_grounds")

			training_grounds_reporter:set_start_type("advanced")

			existing_reporter = training_grounds_reporter
		end

		existing_reporter:register_training_checkpoint("advanced")
	end
}
steps.ensure_player_healthy = {
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
		local knocked_down_state_input = unit_data_extension:read_component("knocked_down_state_input")

		if not step_data.assisted and knocked_down_state_input.knock_down then
			if not step_data.transition_shown then
				step_data.transition_shown = true

				show_transition(true)

				step_data.force_assist_t = t + 0.5
			elseif step_data.force_assist_t < t then
				local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
				local assisted_state_input_component = unit_data_extension:write_component("assisted_state_input")
				assisted_state_input_component.force_assist = true
				step_data.assisted = true
			end

			return false
		end

		local first_person_extension = ScriptUnit.extension(player.player_unit, "first_person_system")

		if not first_person_extension:is_in_first_person_mode() then
			return false
		end

		if step_data.transition_shown then
			show_transition(false)
		end

		local toughness_extension = ScriptUnit.extension(player.player_unit, "toughness_system")

		toughness_extension:recover_max_toughness()

		local health_ext = ScriptUnit.has_extension(player.player_unit, "health_system")
		local corruption_to_remove = health_ext:max_wounds() - health_ext:num_wounds()

		health_ext:remove_wounds(-corruption_to_remove)

		local damage_taken = health_ext:damage_taken()

		health_ext:add_damage(-damage_taken, 0)

		return true
	end
}
steps.condition_if = {}
steps.condition_elseif = {}

for step_name, func in pairs(steps._condition) do
	steps.condition_if[step_name] = function (...)
		local template = func(...)
		template.name = step_name
		template.condition_type = "if"
		template.is_condition = true

		return template
	end

	steps.condition_elseif[step_name] = function (...)
		local template = func(...)
		template.name = step_name
		template.condition_type = "elseif"
		template.is_condition = true

		return template
	end
end

steps.condition_else = {
	condition_type = "else",
	name = "condition_else",
	is_condition = true,
	condition_func = function ()
		return true
	end
}
steps.condition_end = {
	condition_type = "end",
	name = "condition_end",
	is_condition = true
}
local ignored_templates = {
	condition_if = true,
	dynamic = true,
	condition_elseif = true,
	_condition = true
}

for name, template in pairs(steps) do
	if not ignored_templates[name] then
		template.name = name
	end
end

return steps
