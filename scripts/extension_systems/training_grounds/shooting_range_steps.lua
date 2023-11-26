-- chunkname: @scripts/extension_systems/training_grounds/shooting_range_steps.lua

local Component = require("scripts/utilities/component")
local FixedFrame = require("scripts/utilities/fixed_frame")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerProgressionUnlocks = require("scripts/settings/player/player_progression_unlocks")
local ScriptedScenarioUtility = require("scripts/extension_systems/scripted_scenario/scripted_scenario_utility")
local TrainingGroundsSoundEvents = require("scripts/settings/training_grounds/training_grounds_sound_events")
local AchievementUIHelper = require("scripts/managers/achievements/utility/achievement_ui_helper")
local aggro_states = PerceptionSettings.aggro_states
local ShootingRangeSteps = {
	dynamic = {},
	_condition = {}
}

local function reset_enemies(scenario_system, breed_name, spawn_group_name, enemies, t)
	for ii = 1, #enemies do
		local unit = enemies[ii]

		scenario_system:dissolve_unit(unit, t)

		enemies[ii] = nil
	end

	local duration = 2
	local side_id = 2
	local delay = 2
	local num_spawned = 0
	local spawners = scenario_system:get_spawn_group(spawn_group_name)

	for unit, directional_unit_extension in pairs(spawners) do
		num_spawned = num_spawned + 1

		local position, rotation = Unit.local_position(unit, 1), Unit.local_rotation(unit, 1)

		enemies[num_spawned] = scenario_system:spawn_breed_ramping(breed_name, position, rotation, t, duration, side_id, delay)
	end
end

ShootingRangeSteps.make_player_invulnerable = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local player_unit = player.player_unit
		local health_extension = ScriptUnit.has_extension(player_unit, "health_system")

		if health_extension then
			health_extension:set_invulnerable(true)
		end
	end
}
ShootingRangeSteps.init = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		Wwise.set_state("music_zone", "shooting_range")

		local directional_unit = scenario_system:get_directional_unit("arena_middle")
		local position, rotation = Unit.local_position(directional_unit, 1), Unit.local_rotation(directional_unit, 1)

		PlayerMovement.teleport_fixed_update(player.player_unit, position, rotation)
		scenario_system:spawn_attached_units_in_spawn_group("shooting_range_units")
	end
}

local function _respawn_loadout_chest(scenario_system, step_data)
	local unit_spawner = Managers.state.unit_spawner
	local current_unit = step_data.loadout_unit

	if ALIVE[current_unit] then
		unit_spawner:mark_for_deletion(current_unit)
	end

	local loadout_unit = scenario_system:get_directional_unit("loadout_chest")
	local position, rotation = Unit.local_position(loadout_unit, 1), Unit.local_rotation(loadout_unit, 1)
	local unit_name = "content/environment/gameplay/chests/shooting_range_loadout"
	local template_name = "shooting_range_loadout"

	step_data.loadout_unit = unit_spawner:spawn_network_unit(unit_name, template_name, position, rotation)
end

ShootingRangeSteps.chest_loop = {
	events = {
		"shooting_range_chest_interact"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		_respawn_loadout_chest(scenario_system, step_data)
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		step_data.loadout_opened = true
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		if not step_data.loadout_opened then
			return false
		end

		local interactee_extension = ScriptUnit.extension(step_data.loadout_unit, "interactee_system")

		interactee_extension:set_active(false)

		local inventory_view_open = Managers.ui:view_instance("inventory_background_view")

		if inventory_view_open then
			step_data.inventory_view_opened = true

			return false
		end

		if step_data.inventory_view_opened then
			step_data.inventory_view_opened = false
			step_data.loadout_opened = false

			interactee_extension:set_active(true)

			local unit_data_extension = ScriptUnit.extension(player.player_unit, "unit_data_system")
			local interaction_component = unit_data_extension:write_component("interaction")

			Component.event(step_data.loadout_unit, "interaction_canceled", interaction_component.type, player.player_unit)

			interaction_component.target_unit = nil
		end

		return false
	end
}
ShootingRangeSteps.portal_loop = {
	events = {
		"leave_shooting_range"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local portal_directional = scenario_system:get_directional_unit_extension("shooting_range_portal")
		local portal_unit = portal_directional:spawn_attached_unit()
		local end_pos = Unit.local_position(portal_unit, 1)

		step_data.end_position, step_data.end_rotation = Vector3Box(end_pos), QuaternionBox(Unit.local_rotation(portal_unit, 1))

		Managers.ui:play_3d_sound(TrainingGroundsSoundEvents.tg_end_portal_spawned, end_pos)
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		step_data.wants_leave = true
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local wants_leave = step_data.wants_leave

		if wants_leave then
			Managers.ui:play_2d_sound(TrainingGroundsSoundEvents.tg_end_portal_entered)

			local local_player = Managers.player:local_player(1)

			Managers.event:trigger("event_cutscene_fade_in", local_player, 1, math.easeCubic)
			Managers.state.game_mode:complete_game_mode(false)

			return true
		end

		return false
	end
}
ShootingRangeSteps.pickup_loop = {
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local pickup_system = Managers.state.extension:system("pickup_system")
		local med_unit = step_data.med_unit

		if not ALIVE[med_unit] then
			local directional_med = scenario_system:get_directional_unit("health_refill")

			step_data.med_unit = pickup_system:spawn_pickup("medical_crate_pocketable", Unit.local_position(directional_med, 1), Unit.local_rotation(directional_med, 1))
		end

		local ammo_unit = step_data.ammo_unit

		if not ALIVE[ammo_unit] then
			local directional_ammo = scenario_system:get_directional_unit("ammo_refill")

			step_data.ammo_unit = pickup_system:spawn_pickup("small_clip", Unit.local_position(directional_ammo, 1), Unit.local_rotation(directional_ammo, 1))
		end

		local grenade_unit = step_data.grenade_unit

		if not ALIVE[grenade_unit] then
			local directional_grenade = scenario_system:get_directional_unit("grenade_refill")

			step_data.grenade_unit = pickup_system:spawn_pickup("small_grenade", Unit.local_position(directional_grenade, 1), Unit.local_rotation(directional_grenade, 1))
		end

		return false
	end
}

local function _spawn_locked_vfx_unit(reference_unit, required_achievement)
	local unit_name = "content/levels/training_grounds/fx/locked_sr_unit_indicator"
	local template_name = "shooting_range_locked_indicator"
	local position, rotation = Unit.local_position(reference_unit, 1), Unit.local_rotation(reference_unit, 1)
	local locked_unit = Managers.state.unit_spawner:spawn_network_unit(unit_name, template_name, position, rotation)
	local interactee_extension = ScriptUnit.extension(locked_unit, "interactee_system")
	local achievement_definition = Managers.achievements:achievement_definition(required_achievement)

	interactee_extension:set_block_text("loc_requires_achievement", {
		achievement_label = AchievementUIHelper.localized_title(achievement_definition)
	})

	return locked_unit
end

local function _breed_is_unlocked(breed_name, required_achievement)
	if not required_achievement then
		return true
	end

	local has_player = Managers.achievements:has_player(1)

	if not has_player then
		return true
	end

	local player = Managers.player:local_player(1)

	return Managers.achievements:achievement_completed(player, required_achievement)
end

ShootingRangeSteps.enemies_loop = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local enemy_spawners = scenario_system:get_spawn_group("shooting_range_enemies")
		local spawn_datas = {}
		local breed_unlocks = PlayerProgressionUnlocks.shooting_range_breed_unlocks

		for directional_unit, directional_unit_extension in pairs(enemy_spawners) do
			local identifier = directional_unit_extension:identifier()
			local breed_name = string.sub(identifier, 1, string.find(identifier, ":") - 1)
			local spawn_data = {
				was_unlocked = true,
				breed_name = breed_name
			}
			local required_achievement = breed_unlocks[breed_name]

			spawn_data.required_achievement = required_achievement
			spawn_datas[directional_unit] = spawn_data
		end

		step_data.spawn_datas = spawn_datas
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local spawn_datas = step_data.spawn_datas
		local aggro_state = aggro_states.aggroed

		for directional_unit, spawn_data in pairs(spawn_datas) do
			repeat
				local spawned_unit = spawn_data.unit
				local was_unlocked = spawn_data.was_unlocked
				local unlocked = _breed_is_unlocked(spawn_data.breed_name, spawn_data.required_achievement)

				if not unlocked then
					if was_unlocked then
						spawn_data.was_unlocked = false

						scenario_system:dissolve_unit(spawned_unit, t)

						spawn_data.unit = _spawn_locked_vfx_unit(directional_unit, spawn_data.required_achievement)
					end

					break
				elseif ALIVE[spawned_unit] and not was_unlocked then
					Managers.state.unit_spawner:mark_for_deletion(spawned_unit)

					spawn_data.was_unlocked = true
					spawn_data.unit = nil
					spawned_unit = nil

					break
				end

				if not HEALTH_ALIVE[spawned_unit] then
					if not spawn_data.dissolve_t then
						spawn_data.dissolve_t = t + 2 + math.random_range(0, 1)

						break
					end

					if t > spawn_data.dissolve_t then
						scenario_system:dissolve_unit(spawned_unit, t)

						spawn_data.dissolve_t = nil

						local position, rotation = Unit.local_position(directional_unit, 1), Unit.local_rotation(directional_unit, 1)
						local breed_name = spawn_data.breed_name
						local new_unit = scenario_system:spawn_breed_ramping(breed_name, position, rotation, t, 2, 2, nil, aggro_state)

						Managers.event:trigger("add_world_marker_unit", "damage_indicator", new_unit)

						spawn_data.unit = new_unit
					end
				end
			until true
		end
	end
}
ShootingRangeSteps.weak_enemies_loop = {
	events = {
		"reset_weak_enemies",
		"aggro_weak_enemies"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.enemies = {}
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		if event_name == "reset_weak_enemies" then
			local t = FixedFrame.get_latest_fixed_time()

			reset_enemies(scenario_system, "chaos_newly_infected", "weak_enemies", step_data.enemies, t)
		elseif event_name == "aggro_weak_enemies" then
			-- Nothing
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return false
	end
}
ShootingRangeSteps.medium_enemies_loop = {
	events = {
		"reset_medium_enemies",
		"aggro_medium_enemies"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.enemies = {}
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		if event_name == "reset_medium_enemies" then
			local t = FixedFrame.get_latest_fixed_time()

			reset_enemies(scenario_system, "renegade_melee", "medium_enemies", step_data.enemies, t)
		elseif event_name == "aggro_medium_enemies" then
			-- Nothing
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return false
	end
}
ShootingRangeSteps.heavy_enemies_loop = {
	events = {
		"reset_heavy_enemies",
		"aggro_heavy_enemies"
	},
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		step_data.enemies = {}
	end,
	on_event = function (scenario_system, player, scenario_data, step_data, event_name)
		if event_name == "reset_heavy_enemies" then
			local t = FixedFrame.get_latest_fixed_time()

			reset_enemies(scenario_system, "chaos_ogryn_executor", "heavy_enemies", step_data.enemies, t)
		elseif event_name == "aggro_heavy_enemies" then
			-- Nothing
		end
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		return false
	end
}
ShootingRangeSteps.fade_to_black = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local local_player = Managers.player:local_player(1)

		Managers.event:trigger("event_cutscene_fade_in", local_player, 0.5, math.easeCubic)
	end
}
ShootingRangeSteps.disable_loadout = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		Managers.event:trigger("shooting_range_chest_interact")
	end
}
ShootingRangeSteps.open_loadout = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		Managers.ui:open_view("inventory_background_view")
	end,
	condition_func = function (scenario_system, player, scenario_data, step_data, t)
		local instance = Managers.ui:view_instance("inventory_background_view")

		return instance and not instance:loading()
	end
}
ShootingRangeSteps.fade_from_black = {
	start_func = function (scenario_system, player, scenario_data, step_data, t)
		local local_player = Managers.player:local_player(1)

		Managers.event:trigger("event_cutscene_fade_out", local_player, 0.3, math.easeCubic)
	end
}

ScriptedScenarioUtility.parse_condition_steps(ShootingRangeSteps)

local ignored_templates = {
	condition_if = true,
	dynamic = true,
	condition_elseif = true,
	_condition = true
}

for name, template in pairs(ShootingRangeSteps) do
	if not ignored_templates[name] then
		template.name = name
	end
end

return ShootingRangeSteps
