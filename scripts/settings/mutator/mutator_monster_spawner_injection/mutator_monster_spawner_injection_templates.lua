-- chunkname: @scripts/settings/mutator/mutator_monster_spawner_injection/mutator_monster_spawner_injection_templates.lua

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

return settings("MutatorMonsterSpawnerInjectionTemplates", mutator_monster_spawner_injection_templates)
