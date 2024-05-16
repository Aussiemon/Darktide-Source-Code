-- chunkname: @scripts/game_states/game/state_gameplay_testify.lua

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerVisibility = require("scripts/utilities/player_visibility")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local WeaponTraitsMeleeActivated = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
local WeaponTraitsMeleeCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
local WeaponTraitsRangedAimed = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
local WeaponTraitsRangedCommon = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
local WeaponTraitsRangedExplosive = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_explosive")
local WeaponTraitsRangedHighFireRate = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_high_fire_rate")
local WeaponTraitsRangedOverheat = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_overheat")
local WeaponTraitsRangedWarpCharge = require("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_warp_charge")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local gibbing_power = GibbingSettings.gibbing_power
local level_trigger_event = Level.trigger_event
local level_units = Level.units
local quaternion_to_elements = Quaternion.to_elements
local string_format = string.format
local unit_get_data = Unit.get_data
local unit_has_data = Unit.has_data
local unit_id_string = Unit.id_string
local unit_num_cameras = Unit.num_cameras
local unit_world_position = Unit.world_position
local unit_world_rotation = Unit.world_rotation
local world_get_data = World.get_data
local melee_damage_type_index = 1
local melee_damage_types = {
	"blunt_thunder",
	"blunt",
	"blunt_light",
	"combat_blade",
	"metal_slashing_heavy",
	"metal_slashing_light",
	"metal_slashing_medium",
	"ogryn_physical",
	"physical",
	"power_sword",
	"sawing_stuck",
	"sawing",
	"shield_push",
	"shovel_heavy",
	"shovel_light",
	"shovel_medium",
	"shovel_smack",
	"slashing_force_stuck",
	"slashing_force",
	"knife",
	"axe_light",
	"spiked_blunt",
}
local ranged_damage_type_index = 1
local ranged_damage_types = {
	"auto_bullet",
	"boltshell",
	"environment",
	"laser",
	"overheat",
	"pellet",
	"plasma",
	"rippergun_pellet",
	"rippergun_flechette",
	"shell",
	"smite",
	"biomancer_soul",
	"throwing_knife",
}

local function _all_cameras(camera_types)
	local cameras, i = {}, 0
	local data_check_performance = camera_types.performance and "is_" .. camera_types.performance .. "_camera" or nil
	local data_check_screenshot = camera_types.screenshot and "is_" .. camera_types.screenshot .. "_camera" or nil
	local world = Managers.world:world("level_world")
	local levels_data = world_get_data(world, "levels")

	for level_name, level_data in pairs(levels_data) do
		local level = level_data.level
		local go_to_level_link = "fslevel://" .. level_name
		local all_units_in_level = level_units(level)

		for _, unit in pairs(all_units_in_level) do
			if unit_num_cameras(unit) > 0 and (data_check_performance and unit_has_data(unit, data_check_performance) or data_check_screenshot and unit_has_data(unit, data_check_screenshot)) then
				local position = unit_world_position(unit, 1)
				local rotation = unit_world_rotation(unit, 1)
				local x, y, z, w = quaternion_to_elements(rotation)
				local go_to_camera_position_link = string_format("%s&pos=Vector3(%s,%s,%s)&rot=Quaternion.from_elements(%s,%s,%s,%s)", go_to_level_link, position.x, position.y, position.z, x, y, z, w)
				local camera = {
					name = unit_get_data(unit, "camera_id"),
					unit = unit,
					id_string = unit_id_string(unit),
					position = {
						x = position.x,
						y = position.y,
						z = position.z,
					},
					rotation = {
						x = x,
						y = y,
						z = z,
						w = w,
					},
					go_to_camera_position_link = go_to_camera_position_link,
				}

				i = i + 1
				cameras[i] = camera
			end
		end
	end

	return cameras, i
end

local StateGameplayTestify = {
	all_cameras = function ()
		local camera_types = {
			performance = "performance",
			screenshot = "screenshot",
		}
		local cameras, length = _all_cameras(camera_types)

		return cameras, length
	end,
	all_cameras_of_type = function (_, _, camera_type)
		local camera_types = {}

		camera_types[camera_type] = camera_type

		local cameras, length = _all_cameras(camera_types)

		return cameras, length
	end,
	check_and_update_minion_pathing_test = function (state_gameplay, _, minion_pathing_data, num_remaining_path_queries)
		local minion_spawn_manager = Managers.state.minion_spawn
		local num_pathing_data = #minion_pathing_data

		for i = num_pathing_data, 1, -1 do
			local pathing_data = minion_pathing_data[i]
			local unit, breed = pathing_data.unit, pathing_data.breed
			local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
			local is_computing_path, has_path = navigation_extension:is_computing_path(), navigation_extension:has_path()

			if not is_computing_path then
				local start_positions, num_start_positions = pathing_data.start_positions, pathing_data.num_start_positions
				local destinations, num_destinations = pathing_data.destinations, pathing_data.num_destinations
				local start_position_index, destination_index = pathing_data.start_position_index, pathing_data.destination_index

				if not has_path then
					local start_position, destination = start_positions[start_position_index]:unbox(), destinations[destination_index]:unbox()
					local error_message = string.format("%s failed pathing (from: %s to: %s).", breed.name, tostring(start_position), tostring(destination))

					return num_remaining_path_queries, error_message
				end

				if destination_index < num_destinations then
					local new_destination_index = destination_index + 1

					pathing_data.destination_index = new_destination_index

					local destination = destinations[new_destination_index]:unbox()

					navigation_extension:move_to(destination)
				elseif start_position_index < num_start_positions then
					local new_start_position_index = start_position_index + 1

					pathing_data.start_position_index = new_start_position_index

					local new_start_position = start_positions[new_start_position_index]:unbox()
					local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

					locomotion_extension:teleport_to(new_start_position)
					navigation_extension:set_nav_bot_position(new_start_position)

					local new_destination_index = 1

					pathing_data.destination_index = new_destination_index

					local destination = destinations[new_destination_index]:unbox()

					navigation_extension:move_to(destination)
				else
					minion_spawn_manager:despawn(unit)
					table.swap_delete(minion_pathing_data, i)
				end

				num_remaining_path_queries = num_remaining_path_queries - 1
			end
		end

		return num_remaining_path_queries, nil
	end,
	delete_unit = function (_, _, unit)
		local spawner_manager = Managers.state.unit_spawner

		spawner_manager:mark_for_deletion(unit)
	end,
	fast_forward_end_of_round = function (_, _)
		local mission = Managers.state.mission:mission_name()
		local game_mode_name = Managers.state.game_mode:game_mode_name()
		local is_in_hub = game_mode_name == "hub"

		if is_in_hub then
			return
		else
			return Testify.RETRY
		end
	end,
	fetch_weapon_traits = function (_, _, params)
		local traits = {
			melee_traits = {},
			activated_traits = {},
			ranged_traits = {},
			aimed_traits = {},
			overheat_traits = {},
			warp_charge_traits = {},
			explosive_traits = {},
		}
		local melee_common_traits = table.ukeys(WeaponTraitsMeleeCommon)

		table.append(traits.melee_traits, melee_common_traits)

		local activated_traits = table.ukeys(WeaponTraitsMeleeActivated)

		table.append(traits.activated_traits, activated_traits)

		local ranged_common_traits = table.ukeys(WeaponTraitsRangedCommon)

		table.append(traits.ranged_traits, ranged_common_traits)

		local ranged_high_fire_rate_traits = table.ukeys(WeaponTraitsRangedHighFireRate)

		table.append(traits.ranged_traits, ranged_high_fire_rate_traits)

		local aimed_traits = table.ukeys(WeaponTraitsRangedAimed)

		table.append(traits.aimed_traits, aimed_traits)

		local overheat_traits = table.ukeys(WeaponTraitsRangedOverheat)

		table.append(traits.overheat_traits, overheat_traits)

		local warp_charge_traits = table.ukeys(WeaponTraitsRangedWarpCharge)

		table.append(traits.warp_charge_traits, warp_charge_traits)

		local explosive_traits = table.ukeys(WeaponTraitsRangedExplosive)

		table.append(traits.explosive_traits, explosive_traits)

		return traits
	end,
	apply_select_talents = function (_, _, params)
		local player = params.player
		local talents = params.talents
		local talent_system = Managers.state.extension:system("talent_system")

		talent_system:debug_select_talents(player, talents)
	end,
	current_mission = function (state_gameplay, _)
		return Managers.state.mission:mission_name()
	end,
	fetch_portal_position = function (_, _, portal_name)
		local level_name = rawget(_G, "SPAWNED_LEVEL_NAME")

		if level_name then
			local unit_indices = LevelResource.unit_indices(level_name, "content/gizmos/debug/portal")

			for index, unit_index in ipairs(unit_indices) do
				local unit_data = LevelResource.unit_data(level_name, unit_index)
				local portal_id = DynamicData.get(unit_data, "id")

				if portal_id == portal_name then
					local position = LevelResource.unit_position(level_name, unit_index)

					return position
				end
			end
		end

		return nil
	end,
	fetch_unit_and_extensions_from_system = function (state_gameplay, _, system_name)
		local system = Managers.state.extension:system(system_name)

		return system:unit_to_extension_map()
	end,
	get_units_from_component_name = function (state_gameplay, _, component_name)
		local component_system = Managers.state.extension:system("component_system")

		return component_system:get_units_from_component_name(component_name)
	end,
	hit_minion_with_random_melee = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit
		local crit = params.crit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = melee_damage_types[melee_damage_type_index]

			Attack.execute(unit, damage_profile, "target_index", 1, "target_number", 1, "power_level", 5000, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "melee", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", crit)
			Attack.execute(unit, damage_profile, "instakill", true)

			melee_damage_type_index = melee_damage_type_index + 1 > #melee_damage_types and 1 or melee_damage_type_index + 1
		end
	end,
	hit_minion_with_random_ranged = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit
		local crit = params.crit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = ranged_damage_types[ranged_damage_type_index]

			Attack.execute(unit, damage_profile, "target_index", 1, "target_number", 1, "power_level", 5000, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", crit)

			ranged_damage_type_index = ranged_damage_type_index + 1 > #ranged_damage_types and 1 or ranged_damage_type_index + 1
		end
	end,
	hit_minion_with_ranged_alternative_fire_attack = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.default_lasgun_killshot
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "laser"

			Attack.execute(unit, damage_profile, "target_index", 1, "target_number", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_melee_weapon_special_attack = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "metal_slashing_heavy"

			Attack.execute(unit, damage_profile, "target_index", 1, "target_number", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_plasmagun_attack = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.default_plasma_bfg
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "plasma"

			Attack.execute(unit, damage_profile, "target_index", 1, "target_number", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "attack_direction", Vector3(1, 0, 0), "instakill", false, "hit_zone_name", "head", "hit_actor", hit_actor, "hit_world_position", hit_position, "attacking_unit", player_unit, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_warp_charge_explosion = function (_, _, params)
		local unit = params.unit
		local player_unit = params.player_unit
		local hit_position = POSITION_LOOKUP[unit]
		local world = Managers.world:world("level_world")
		local physics_world = World.physics_world(world)
		local charge_level = 1
		local attack_type = AttackSettings.attack_types.explosion
		local explosion_template = ExplosionTemplates.default_force_staff_demolition

		Explosion.create_explosion(world, physics_world, hit_position, Vector3.up(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, charge_level, attack_type)
	end,
	apply_select_traits = function (_, _, params)
		local player = params.player
		local weapon_system = Managers.state.extension:system("weapon_system")
		local slot_name = params.slot_name
		local selected_overrides = {
			traits = params.traits,
			perks = {},
			base_stats = {},
		}

		weapon_system:debug_set_weapon_override(player, selected_overrides, slot_name)
	end,
	set_alternate_fire = function (_, _, params)
		local unit = params.unit
		local active = params.active
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if unit_data_extension then
			local alternate_fire_component = unit_data_extension:write_component("alternate_fire")
			local AlternateFire = require("scripts/utilities/alternate_fire")

			AlternateFire.debug_set_alternate_fire(alternate_fire_component, active)
		end
	end,
	is_unit_alive = function (_, _, unit)
		return HEALTH_ALIVE[unit]
	end,
	kill_minion = function (_, _, unit)
		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill

			Attack.execute(unit, damage_profile, "instakill", true)
		end
	end,
	gib_minion = function (_, _, parameters)
		local unit = parameters.unit

		if HEALTH_ALIVE[unit] then
			local gibbing_type = parameters.gibbing_type
			local gib_settings = parameters.gib_settings
			local damage_profile = table.clone(DamageProfileTemplates.minion_instakill)

			damage_profile.gibbing_type = gibbing_type
			damage_profile.gibbing_power = gib_settings.gibbing_threshold or gibbing_power.always

			local hit_zone_name = parameters.hit_zone_name

			Attack.execute(unit, damage_profile, "hit_zone_name", hit_zone_name, "instakill", true)
		end
	end,
	hide_all_units = function (state_gameplay, _)
		local world = Managers.world:world("level_world")
		local units = World.units(world)

		for i = 1, #units do
			local unit = units[i]

			Unit.set_unit_visibility(unit, false)
		end
	end,
	hide_players = function ()
		Log.info("StateGameplayTestify", "Hiding players")
		PlayerVisibility.hide_players()
	end,
	memory_usage = function ()
		local memory_usage = Memory.usage()

		return memory_usage
	end,
	play_cutscene = function (_, _, cutscene_name)
		Log.info("StateGameplayTestify", "Playing cutscene %s", cutscene_name)

		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

		cinematic_scene_system:play_cutscene(cutscene_name)
	end,
	positions_on_nav_mesh = function (state_gameplay, nav_world, positions, above, below, optional_traverse_logic)
		local num_positions = #positions
		local positions_on_nav_mesh, num_positions_on_nav_mesh = Script.new_array(num_positions), 0

		for i = 1, num_positions do
			local position = positions[i]:unbox()
			local position_on_nav_mesh = NavQueries.position_on_mesh(nav_world, position, above, below, optional_traverse_logic)

			if position_on_nav_mesh then
				num_positions_on_nav_mesh = num_positions_on_nav_mesh + 1
				positions_on_nav_mesh[num_positions_on_nav_mesh] = Vector3Box(position_on_nav_mesh)
			end
		end

		return positions_on_nav_mesh, num_positions_on_nav_mesh
	end,
	show_players = function ()
		Log.info("StateGameplayTestify", "Showing players")
		PlayerVisibility.show_players()
	end,
	spawn_unit = function (_, _, unit_name, position)
		local spawner_manager = Managers.state.unit_spawner
		local unit = spawner_manager:spawn_unit(unit_name, position:unbox())

		return unit
	end,
	spawn_and_destroy_unit = function (_, _, unit_name, position)
		local world = Managers.world:world("level_world")
		local unit = World.spawn_unit_ex(world, unit_name, nil, position:unbox())

		World.destroy_unit(world, unit)
	end,
	start_measuring_performance = function (state_gameplay, _, values_to_measure)
		state_gameplay:init_performance_reporter(values_to_measure)
	end,
	stop_measuring_performance = function (state_gameplay, _)
		local performance_reporter = state_gameplay:performance_reporter()
		local performance_measurements = performance_reporter:performance_measurements()

		state_gameplay:destroy_performance_reporter()

		return performance_measurements
	end,
	trigger_external_event = function (_, _, event_name)
		Log.info("StateGameplayTestify", "Triggering external event %s", event_name)
		level_trigger_event(Managers.state.mission:mission_level(), event_name)
	end,
	traverse_logic = function (state_gameplay, _, unit)
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		return navigation_extension:traverse_logic()
	end,
	unit_health_values = function (_, _, unit)
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			return {
				current_health = health_extension:current_health(),
				max_health = health_extension:max_health(),
			}
		else
			return {
				current_health = "na",
				max_health = "na",
			}
		end
	end,
	unit_navigation_move_to = function (state_gameplay, _, unit, destination)
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		navigation_extension:move_to(destination:unbox())
	end,
	unit_navigation_set_enabled = function (state_gameplay, _, unit, enabled, max_speed)
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

		navigation_extension:set_enabled(enabled, max_speed)
	end,
	unit_positions_on_nav_mesh = function (state_gameplay, nav_world, units, above, below)
		local num_units = #units
		local unit_position_on_nav_mesh = Script.new_map(num_units)

		for i = 1, num_units do
			local unit = units[i]
			local position = POSITION_LOOKUP[unit]
			local position_on_nav_mesh = NavQueries.position_on_mesh(nav_world, position, above, below)

			if position_on_nav_mesh then
				unit_position_on_nav_mesh[unit] = Vector3Box(position_on_nav_mesh)
			end
		end

		return unit_position_on_nav_mesh
	end,
	wait_for_cutscene_to_finish = function (_, _, cutscene_name)
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		local is_cinematic_active = cinematic_scene_system:is_cinematic_active(cutscene_name)

		if is_cinematic_active then
			return Testify.RETRY
		end

		Log.info("StateGameplayTestify", "Cutscene %s has finished playing", cutscene_name)
	end,
	wait_for_cutscene_to_start = function (_, _, cutscene_name)
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		local is_cinematic_active = cinematic_scene_system:is_cinematic_active(cutscene_name)

		if not is_cinematic_active then
			return Testify.RETRY
		end
	end,
	wait_for_in_hub = function ()
		local game_mode_name = Managers.state.game_mode:game_mode_name()
		local is_in_hub = game_mode_name == "hub" or game_mode_name == "prologue_hub"

		if is_in_hub then
			return
		else
			return Testify.RETRY
		end
	end,
	wait_for_in_psychanium = function ()
		local game_mode_name = Managers.state.game_mode:game_mode_name()
		local is_in_psychanium = game_mode_name == "training_grounds" or game_mode_name == "shooting_range"

		if is_in_psychanium then
			return
		else
			return Testify.RETRY
		end
	end,
	wait_for_state_gameplay_reached = function ()
		return
	end,
}

return StateGameplayTestify
