-- chunkname: @scripts/settings/mutator/mutator_monster_spawner_injection/mutator_monster_spawner_injection_templates.lua

local EnemyEventSpawnerSettings = require("scripts/settings/components/enemy_event_spawner_settings")
local LevelProps = require("scripts/settings/level_prop/level_props")
local RoamerSlotPlacementFunctions = require("scripts/settings/roamer/roamer_slot_placement_functions")
local mutator_monster_spawner_injection_templates = {}

mutator_monster_spawner_injection_templates.havoc_twins = {
	spawn = function (template, monster, ahead_target_unit, side_id)
		local threshold_value = 0.2

		if threshold_value < math.random() then
			local breed_names = {
				"renegade_twin_captain",
				"renegade_twin_captain_two",
			}
			local spawn_position = monster.position:unbox()
			local spawned_unit
			local minion_spawn_manager = Managers.state.minion_spawn
			local param_table = minion_spawn_manager:request_param_table()

			for i = 1, 2 do
				local breed_name = breed_names[i]

				param_table.optional_aggro_state = "aggroed"
				param_table.optional_target_unit = ahead_target_unit
				spawned_unit = minion_spawn_manager:spawn_minion(breed_name, spawn_position, Quaternion.identity(), side_id, param_table)

				local reactivation_override = true
				local spawned_unit_toughness_extension = ScriptUnit.extension(spawned_unit, "toughness_system")

				spawned_unit_toughness_extension:set_toughness_damage(0, reactivation_override)

				local force_horde_on_spawn = template.force_horde_on_spawn

				if force_horde_on_spawn and i == 2 then
					Managers.state.pacing:force_horde_pacing_spawn()
				end

				Log.info("MonsterPacing", "Spawned monster %s successfully.", breed_name)
			end
		end
	end,
}
mutator_monster_spawner_injection_templates.nurgle_totems = {
	spawn = function (template, monster, ahead_target_unit, side_id)
		local spawn_position = monster.position:unbox()
		local prop_settings = LevelProps.nurgle_totem

		Managers.state.unit_spawner:spawn_network_unit(prop_settings.unit_name, "level_prop", spawn_position, Quaternion.identity(), nil, prop_settings)

		local nav_mesh_manager = Managers.state.nav_mesh
		local nav_world = nav_mesh_manager:nav_world()
		local breed_data = {}
		local composition = EnemyEventSpawnerSettings.live_event_skull_totem_guards
		local current_faction = Managers.state.pacing:current_faction()
		local faction_composition = composition[current_faction]
		local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(faction_composition[1])

		for i = 1, #resistance_scaled_composition.breeds do
			local current_breed_data = resistance_scaled_composition.breeds[i]
			local amount_to_spawn = math.random(current_breed_data.amount[1], current_breed_data.amount[2])

			for ii = 1, amount_to_spawn do
				breed_data[#breed_data + 1] = current_breed_data.name
			end
		end

		local placement_settings = {
			position_offset = 4,
			num_slots = #breed_data,
		}
		local spawn_locations = RoamerSlotPlacementFunctions.circle_placement(nav_world, monster.position, placement_settings, nil)

		table.shuffle(breed_data)

		for i = 1, #spawn_locations do
			local spawn_data = spawn_locations[i]
			local minion_spawn_manager = Managers.state.minion_spawn
			local param_table = minion_spawn_manager:request_param_table()

			minion_spawn_manager:spawn_minion(breed_data[i], spawn_data.position:unbox(), spawn_data.rotation:unbox(), 2, param_table)
		end
	end,
}

return settings("MutatorMonsterSpawnerInjectionTemplates", mutator_monster_spawner_injection_templates)
