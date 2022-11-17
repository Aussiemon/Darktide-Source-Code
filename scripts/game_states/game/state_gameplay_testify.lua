local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HerdingTemplates = require("scripts/settings/damage/herding_templates")
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
	"spiked_blunt"
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
	"throwing_knife"
}
local StateGameplayTestify = {
	all_cameras_of_type = function (camera_type, state_gameplay)
		local cameras = {}
		local data_check = "is_" .. camera_type .. "_camera"
		local world = Managers.world:world("level_world")
		local levels_data = World.get_data(world, "levels")

		for level_name, level_data in pairs(levels_data) do
			local level = level_data.level
			local go_to_level_link = "fslevel://" .. level_name
			local all_units_in_level = Level.units(level)

			for _, unit in pairs(all_units_in_level) do
				if Unit.num_cameras(unit) > 0 and Unit.get_data(unit, data_check) then
					local position = Unit.world_position(unit, 1)
					local rotation = Unit.world_rotation(unit, 1)
					local x, y, z, w = Quaternion.to_elements(rotation)
					local go_to_camera_position_link = string.format("%s&pos=Vector3(%s,%s,%s)&rot=Quaternion.from_elements(%s,%s,%s,%s)", go_to_level_link, position.x, position.y, position.z, x, y, z, w)
					local camera = {
						name = Unit.get_data(unit, "camera_id"),
						unit = unit,
						id_string = Unit.id_string(unit),
						position = {
							x = position.x,
							y = position.y,
							z = position.z
						},
						rotation = {
							x = x,
							y = y,
							z = z,
							w = w
						},
						go_to_camera_position_link = go_to_camera_position_link
					}

					table.insert(cameras, camera)
				end
			end
		end

		return cameras
	end,
	fetch_weapon_traits = function (params)
		local traits = {
			melee_traits = {},
			activated_traits = {},
			ranged_traits = {},
			aimed_traits = {},
			overheat_traits = {},
			warp_charge_traits = {},
			explosive_traits = {}
		}
		local melee_common_traits = table.keys(WeaponTraitsMeleeCommon)

		table.append(traits.melee_traits, melee_common_traits)

		local activated_traits = table.keys(WeaponTraitsMeleeActivated)

		table.append(traits.activated_traits, activated_traits)

		local ranged_common_traits = table.keys(WeaponTraitsRangedCommon)

		table.append(traits.ranged_traits, ranged_common_traits)

		local ranged_high_fire_rate_traits = table.keys(WeaponTraitsRangedHighFireRate)

		table.append(traits.ranged_traits, ranged_high_fire_rate_traits)

		local aimed_traits = table.keys(WeaponTraitsRangedAimed)

		table.append(traits.aimed_traits, aimed_traits)

		local overheat_traits = table.keys(WeaponTraitsRangedOverheat)

		table.append(traits.overheat_traits, overheat_traits)

		local warp_charge_traits = table.keys(WeaponTraitsRangedWarpCharge)

		table.append(traits.warp_charge_traits, warp_charge_traits)

		local explosive_traits = table.keys(WeaponTraitsRangedExplosive)

		table.append(traits.explosive_traits, explosive_traits)

		return traits
	end,
	apply_select_talents = function (params)
		local player = params.player
		local specialization_name = params.specialization_name
		local talents = params.talents
		local specialization_system = Managers.state.extension:system("specialization_system")

		specialization_system:debug_select_talents(player, specialization_name, talents)
	end,
	current_mission = function (_, state_gameplay)
		return Managers.state.mission:mission_name()
	end,
	fetch_portal_position = function (portal_name, _)
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
	fetch_unit_and_extensions_from_system = function (system_name, state_gameplay)
		local system = Managers.state.extension:system(system_name)

		return system:unit_to_extension_map()
	end,
	hit_minion_with_random_melee = function (params)
		local unit = params.unit
		local player_unit = params.player_unit
		local crit = params.crit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = melee_damage_types[melee_damage_type_index]

			Attack.execute(unit, damage_profile, "target_index", 1, "power_level", 99999, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "melee", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", crit)
			Attack.execute(unit, damage_profile, "instakill", true)

			melee_damage_type_index = melee_damage_type_index + 1 > #melee_damage_types and 1 or melee_damage_type_index + 1
		end
	end,
	hit_minion_with_random_ranged = function (params, _)
		local unit = params.unit
		local player_unit = params.player_unit
		local crit = params.crit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = ranged_damage_types[ranged_damage_type_index]

			Attack.execute(unit, damage_profile, "target_index", 1, "power_level", 99999, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", crit)

			ranged_damage_type_index = ranged_damage_type_index + 1 > #ranged_damage_types and 1 or ranged_damage_type_index + 1
		end
	end,
	hit_minion_with_ranged_alternative_fire_attack = function (params, _)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.default_lasgun_killshot
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "laser"

			Attack.execute(unit, damage_profile, "target_index", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_melee_weapon_special_attack = function (params, _)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.heavy_chainsword_sticky_last
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "metal_slashing_heavy"

			Attack.execute(unit, damage_profile, "target_index", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "hit_world_position", hit_position, "attack_direction", Vector3(1, 0, 0), "hit_zone_name", "head", "instakill", false, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_plasmagun_attack = function (params, _)
		local unit = params.unit
		local player_unit = params.player_unit

		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.default_plasma_bfg
			local hit_actor = Unit.actor(unit, 1)
			local hit_position = POSITION_LOOKUP[unit]
			local damage_type = "plasma"

			Attack.execute(unit, damage_profile, "target_index", 1, "power_level", 500, "charge_level", 1, "dropoff_scalar", 0, "attack_direction", Vector3(1, 0, 0), "instakill", false, "hit_zone_name", "head", "hit_actor", hit_actor, "hit_world_position", hit_position, "attacking_unit", player_unit, "attack_type", "ranged", "herding_template", HerdingTemplates.thunder_hammer_left_heavy, "damage_type", damage_type, "is_critical_strike", true)
		end
	end,
	hit_minion_with_warp_charge_explosion = function (params, _)
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
	apply_select_traits = function (params)
		local player = params.player
		local weapon_system = Managers.state.extension:system("weapon_system")
		local slot_name = params.slot_name
		local selected_overrides = {
			traits = params.traits,
			perks = {},
			base_stats = {}
		}

		weapon_system:debug_set_weapon_override(player, selected_overrides, slot_name)
	end,
	set_alternate_fire = function (params)
		local unit = params.unit
		local active = params.active
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if unit_data_extension then
			local alternate_fire_component = unit_data_extension:write_component("alternate_fire")
			local AlternateFire = require("scripts/utilities/alternate_fire")

			AlternateFire.debug_set_alternate_fire(alternate_fire_component, active)
		end
	end,
	is_unit_alive = function (unit, _)
		return HEALTH_ALIVE[unit]
	end,
	kill_minion = function (unit, _)
		if HEALTH_ALIVE[unit] then
			local damage_profile = DamageProfileTemplates.minion_instakill

			Attack.execute(unit, damage_profile, "instakill", true)
		end
	end,
	gib_minion = function (parameters, _)
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
	hide_players = function ()
		Log.info("StateGameplayTestify", "Hiding players")
		PlayerVisibility.hide_players()
	end,
	load_mission = function (mission_key, _)
		FlowCallbacks.load_mission({
			mission_name = mission_key
		})
	end,
	memory_usage = function (index, state_gameplay)
		local mission_name = Managers.state.mission:mission_name()
		local memory_usage = Memory.usage()

		Managers.telemetry_events:memory_usage(mission_name, index, memory_usage)
	end,
	play_cutscene = function (cutscene_name)
		Log.info("StateGameplayTestify", "Playing cutscene %s", cutscene_name)

		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")

		cinematic_scene_system:play_cutscene(cutscene_name)
	end,
	send_lua_trace_statistics_to_telemetry = function (lua_trace_data, state_gameplay)
		local mission_name = Managers.state.mission:mission_name()
		local index = lua_trace_data.index
		local lua_trace_stats = lua_trace_data.stats

		Managers.telemetry_events:lua_trace_stats(mission_name, index, lua_trace_stats)
	end,
	show_players = function ()
		Log.info("StateGameplayTestify", "Showing players")
		PlayerVisibility.show_players()
	end,
	start_measuring_performance = function (_, state_gameplay)
		state_gameplay:init_performance_reporter()
	end,
	stop_measuring_performance = function (camera, state_gameplay)
		local performance_reporter = state_gameplay:performance_reporter()
		local ms_per_frame = {
			min = performance_reporter:min_ms_per_frame(),
			max = performance_reporter:max_ms_per_frame(),
			avg = performance_reporter:avg_ms_per_frame(),
			median = performance_reporter:median_ms_per_frame()
		}
		local batchcount = {
			min = performance_reporter:min_batchcount(),
			max = performance_reporter:max_batchcount(),
			avg = performance_reporter:avg_batchcount(),
			median = performance_reporter:median_batchcount()
		}
		local primitives_count = {
			min = performance_reporter:min_primitives_count(),
			max = performance_reporter:max_primitives_count(),
			avg = performance_reporter:avg_primitives_count(),
			median = performance_reporter:median_primitives_count()
		}
		local performance_measurements = {
			ms_per_frame = ms_per_frame,
			batchcount = batchcount,
			primitives_count = primitives_count
		}

		state_gameplay:destroy_performance_reporter()

		local mission_name = Managers.state.mission:mission_name()

		if camera then
			Managers.telemetry_events:camera_performance_measurements(mission_name, camera, performance_measurements)
		else
			Managers.telemetry_events:performance_measurements(mission_name, performance_measurements)
		end
	end,
	take_a_screenshot = function (screenshot_settings, state_gameplay)
		local type = "file_system"
		local window = nil
		local scale = 1
		local output_dir = screenshot_settings.output_dir
		local date_and_time = os.date("%y_%m_%d-%H%M%S")
		local filename = screenshot_settings.filename .. "-" .. date_and_time
		local filetype = screenshot_settings.filetype

		os.execute("mkdir -p " .. "\"" .. output_dir .. "\"")
		FrameCapture.screen_shot(type, window, scale, output_dir, filename, filetype)
	end,
	trigger_external_event = function (event_name)
		Log.info("StateGameplayTestify", "Triggering external event %s", event_name)
		level_trigger_event(Managers.state.mission:mission_level(), event_name)
	end,
	unit_health_values = function (unit, _)
		local health_extension = ScriptUnit.has_extension(unit, "health_system")

		if health_extension then
			return {
				current_health = health_extension:current_health(),
				max_health = health_extension:max_health()
			}
		else
			return {
				current_health = "na",
				max_health = "na"
			}
		end
	end,
	wait_for_cutscene_to_finish = function (cutscene_name)
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		local is_cinematic_active = cinematic_scene_system:is_cinematic_active(cutscene_name)

		if is_cinematic_active then
			return Testify.RETRY
		end

		Log.info("StateGameplayTestify", "Cutscene %s has finished playing", cutscene_name)
	end,
	wait_for_cutscene_to_start = function (cutscene_name)
		local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
		local is_cinematic_active = cinematic_scene_system:is_cinematic_active(cutscene_name)

		if not is_cinematic_active then
			return Testify.RETRY
		end
	end,
	wait_for_state_gameplay_reached = function (_, _)
		return
	end
}

return StateGameplayTestify
