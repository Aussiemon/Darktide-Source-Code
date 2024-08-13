-- chunkname: @scripts/managers/pacing/monster_pacing/templates/monster_injection_templates.lua

local MonsterInjectionTemplates = {}

MonsterInjectionTemplates.backend_twins = {
	breed_names = {
		"renegade_twin_captain",
		"renegade_twin_captain_two",
	},
	difficulties = {
		false,
		false,
		true,
		true,
		true,
	},
	should_inject = function ()
		local pacing_manager = Managers.state.pacing
		local backend_activated = pacing_manager and pacing_manager:get_backend_pacing_control_flag("activate_twins")

		return backend_activated
	end,
	add_overrides = function (monster)
		monster.is_twin = true
		monster.objective = "objective_twins_ambush"
		monster.set_enraged = Managers.state.mutator:mutator("mutator_auric_tension_modifier")
	end,
	sound_data = {
		breed_name = "renegade_twin_captain_two",
		event = "wwise/events/minions/play_minion_special_twins_ambush_spawn",
		vo_event = "cult_pre_ambush_a",
		voice_profile = "captain_twin_female_a",
		distance = math.random(25, 45),
	},
}

do
	local single_twin = table.clone(MonsterInjectionTemplates.backend_twins)

	single_twin.breed_names = {
		"renegade_twin_captain_two",
	}
	single_twin.difficulties = {
		true,
		true,
		true,
		true,
		true,
	}

	single_twin.should_inject = function ()
		local pacing_manager = Managers.state.pacing
		local backend_activated = pacing_manager and pacing_manager:get_backend_pacing_control_flag("activate_twins")
		local mutator_activated = Managers.state.mutator:mutator("mutator_single_twin")

		return not backend_activated and mutator_activated
	end

	MonsterInjectionTemplates.single_twin = single_twin
end

return settings("MonsterInjectionTemplates", MonsterInjectionTemplates)
