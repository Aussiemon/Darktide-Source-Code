local TestifySnippets = require("scripts/tests/testify_snippets")
CombatTestCases = {}
local base_talents = {
	veteran_1 = {},
	veteran_2 = {
		veteran_2_base_3 = true,
		veteran_2_base_2 = true,
		veteran_2_base_1 = true,
		veteran_2_combat = true,
		veteran_2_frag_grenade = true
	},
	veteran_3 = {
		veteran_3_base_3 = true,
		veteran_3_base_2 = true,
		veteran_3_combat = true,
		veteran_3_base_1 = true,
		veteran_3_grenade = true,
		veteran_3_base_4 = true
	},
	ogryn_1 = {
		ogryn_1_grenade = true,
		ogryn_1_base_1 = true,
		ogryn_1_base_2 = true,
		ogryn_1_combat = true,
		ogryn_1_base_3 = true,
		ogryn_1_base_4 = true
	},
	ogryn_2 = {
		ogryn_2_grenade = true,
		ogryn_2_combat_ability = true,
		ogryn_2_base_1 = true,
		ogryn_2_base_3 = true,
		ogryn_2_base_2 = true,
		ogryn_2_base_4 = true,
		ogryn_2_charge_buff = true
	},
	ogryn_3 = {},
	zealot_1 = {
		zealot_1_base_1 = true,
		zealot_1_base_2 = true,
		zealot_1_base_3 = true,
		zealot_1_combat = true
	},
	zealot_2 = {
		zealot_2_base_3 = true,
		zealot_2_base_2 = true,
		zealot_2_base_4 = true,
		zealot_2_shock_grenade = true,
		zealot_2_combat = true,
		zealot_2_base_1 = true
	},
	zealot_3 = {},
	psyker_1 = {
		psyker_1_combat = true,
		psyker_1_base_2 = true,
		psyker_1_base_1 = true,
		psyker_1_base_3 = true
	},
	psyker_2 = {
		psyker_2_combat = true,
		psyker_2_base_2 = true,
		psyker_2_base_1 = true,
		psyker_2_smite = true,
		psyker_2_base_3 = true
	},
	psyker_3 = {}
}

local function form_trait_list(traits, existing_traits)
	local new_traits = existing_traits or {}
	local num_existing_traits = #new_traits

	for i = 1, #traits do
		new_traits[num_existing_traits + i] = {
			rarity = 1,
			name = traits[i]
		}
	end

	return new_traits
end

CombatTestCases.run_through_mission = function (case_settings)
	Testify:run_case(function (dt, t)
		Log.set_category_log_level("Telemetry", Log.DEBUG)

		local result = ""
		local settings = cjson.decode(case_settings or "{}")
		local flags = settings.flags or {
			"run_through_mission"
		}
		local memory_usage = settings.memory_usage
		local lua_trace = settings.lua_trace
		local mission_key = settings.mission_key
		local num_peers = settings.num_peers or 0

		if lua_trace then
			Testify:make_request_to_runner("monitor_lua_trace")
		end

		local assert_data = {
			condition = num_peers <= 4,
			message = "The number of peers has been set to " .. num_peers .. ". You can't have more than 4 peers!"
		}
		local output = TestifySnippets.check_flags_for_mission(flags, mission_key)

		if output then
			return output
		end

		if memory_usage and TestifySnippets.mission_flag_of_type(mission_key, "memory_usage") == false then
			result = mission_key .. "'s memory usage flag is set to false. Memory usage data not read.\n"
			memory_usage = false
		end

		if TestifySnippets.is_debug_stripped() and Testify:make_request("current_state_name") ~= "StateGameplay" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		if num_peers == 0 then
			TestifySnippets.load_mission(mission_key)
		end

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait_for_peers(num_peers)
		TestifySnippets.wait_for_all_peers_reach_gameplay_state()
		TestifySnippets.wait_for_cinematic_to_be_over()

		while not Testify:make_request("is_party_full") do
			TestifySnippets.spawn_bot()
		end

		local num_bots = Testify:make_request("num_bots")

		Testify:make_request("make_players_unkillable")
		Testify:make_request("make_players_invulnerable")

		local main_path_point = 0
		local total_main_path_distance = Testify:make_request("total_main_path_distance")
		local last_player_teleportation_time = os.clock()
		local player_teleportation_speed_factor = 2
		local memory_usage_measurement_count = 0
		local num_memory_usage_measurements = 3
		local memory_usage_main_path_increments = (total_main_path_distance - 10) / (num_memory_usage_measurements - 1)
		local next_memory_measure_point = 0
		local lua_trace_measurement_count = 0
		local num_lua_trace_measurements = 30
		local lua_trace_main_path_increments = (total_main_path_distance - 10) / (num_lua_trace_measurements - 1)
		local next_lua_trace_measure_point = 0
		local bots_stuck_data = {}

		for i = 1, num_bots do
			bots_stuck_data[i] = {
				Vector3Box(Vector3(-999, -999, -999)),
				os.time()
			}
		end

		local bot_teleportation_data = {
			main_path_point = 0,
			bots_blocked_time_before_teleportation = 15,
			bots_blocked_distance = 2,
			bots_stuck_data = bots_stuck_data
		}
		assert_data = {
			message = "The player(s) has/have been killed, this shouldn't be possible. Please check the video in the Testify results."
		}

		while not Testify:make_request("end_conditions_met") and main_path_point < total_main_path_distance do
			assert_data.condition = Testify:make_request("players_are_alive")

			if memory_usage and next_memory_measure_point < main_path_point and memory_usage_measurement_count < num_memory_usage_measurements then
				Testify:make_request("memory_usage", memory_usage_measurement_count)

				memory_usage_measurement_count = memory_usage_measurement_count + 1
				next_memory_measure_point = next_memory_measure_point + memory_usage_main_path_increments
			end

			if lua_trace and next_lua_trace_measure_point < main_path_point and lua_trace_measurement_count < num_lua_trace_measurements then
				local lua_trace_statistics = TestifySnippets.lua_trace_statistics()
				local lua_trace_data = {
					index = lua_trace_measurement_count,
					stats = lua_trace_statistics
				}

				Testify:make_request("send_lua_trace_statistics_to_telemetry", lua_trace_data)

				lua_trace_measurement_count = lua_trace_measurement_count + 1
				next_lua_trace_measure_point = next_lua_trace_measure_point + lua_trace_main_path_increments
			end

			Testify:make_request("teleport_players_to_main_path_point", main_path_point)
			Testify:make_request("teleport_bots_forward_on_main_path_if_blocked", bot_teleportation_data)
			TestifySnippets.wait(2)

			main_path_point = main_path_point + (os.clock() - last_player_teleportation_time) * player_teleportation_speed_factor
			last_player_teleportation_time = os.clock()
			bot_teleportation_data.main_path_point = main_path_point
		end

		local end_conditions_met_outcome = Testify:make_request("end_conditions_met_outcome")

		if end_conditions_met_outcome then
			result = result .. "Game Mode Outcome = " .. end_conditions_met_outcome
		else
			result = result .. "End of the level reached."
		end

		if memory_usage or lua_trace then
			TestifySnippets.send_telemetry_batch()
		end

		return result
	end)
end

CombatTestCases.spawn_all_enemies = function (case_settings)
	Testify:run_case(function (dt, t)
		local result = ""
		local faulty_minions_spawned = {}
		local minions_auto_killed = {}
		local spawned_minions = {}
		local settings = cjson.decode(case_settings or "{}")
		local kill_timer = settings.kill_timer or 30
		local spawn_simultaneously = settings.spawn_simultaneously or true
		local difficulty = settings.difficulty or {
			resistance = 2,
			challenge = 2
		}

		if TestifySnippets.is_debug_stripped() then
			if not Testify:make_request("current_state_name") ~= "StateGameplay" then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			TestifySnippets.load_mission("spawn_all_enemies")
		end

		TestifySnippets.set_difficulty(difficulty)
		TestifySnippets.reload_current_mission()
		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)

		while not Testify:make_request("is_party_full") do
			TestifySnippets.spawn_bot()
		end

		Testify:make_request("make_players_unkillable")
		Testify:make_request("make_players_invulnerable")

		local breeds = Testify:make_request("all_breeds")
		local breed_side = 2
		local player_current_position = Testify:make_request("player_current_position")
		local player_spawn_position = {
			x = player_current_position.x,
			y = player_current_position.y,
			z = player_current_position.z
		}
		local num_breeds = table.size(breeds)
		local angle_offset = 2 * math.pi / num_breeds
		local distance = 10

		for index, breed in ipairs(breeds) do
			local breed_name = breed.name
			local angle = angle_offset * index
			local spawn_position_offset = {
				z = 0.2,
				x = math.cos(angle) * distance,
				y = math.sin(angle) * distance
			}
			local spawn_position = {
				x = player_spawn_position.x + spawn_position_offset.x,
				y = player_spawn_position.y + spawn_position_offset.y,
				z = player_spawn_position.z + spawn_position_offset.z
			}
			local minion = {
				breed_name = breed_name,
				breed_side = breed_side,
				spawn_position = spawn_position
			}

			Log.info("Testify", "Spawning " .. breed_name)

			minion.unit = Testify:make_request("spawn_minion", minion)
			local is_minion_alive = Testify:make_request("is_unit_alive", minion.unit)

			if not is_minion_alive then
				table.insert(faulty_minions_spawned, breed_name)
			end

			if spawn_simultaneously then
				table.insert(spawned_minions, minion)
			else
				local minion_time_of_spawn = os.clock()

				while kill_timer > os.clock() - minion_time_of_spawn do
					is_minion_alive = Testify:make_request("is_unit_alive", minion.unit)

					if not is_minion_alive then
						break
					end
				end

				is_minion_alive = Testify:make_request("is_unit_alive", minion.unit)

				if is_minion_alive then
					local minion_health_values = Testify:make_request("unit_health_values", minion.unit)
					local output = breed_name .. " " .. minion_health_values.current_health .. "/" .. minion_health_values.max_health

					Log.info("Testify", "Executing " .. breed_name)
					Testify:make_request("kill_minion", minion.unit)
					table.insert(minions_auto_killed, output)
				end
			end
		end

		local wait_duration = spawn_simultaneously and kill_timer or 5

		TestifySnippets.wait(wait_duration)

		if spawn_simultaneously then
			for _, minion in pairs(spawned_minions) do
				local is_minion_alive = Testify:make_request("is_unit_alive", minion.unit)

				if is_minion_alive then
					local breed_name = minion.breed_name
					local minion_health_values = Testify:make_request("unit_health_values", minion.unit)
					local output = breed_name .. " " .. minion_health_values.current_health .. "/" .. minion_health_values.max_health

					Log.info("Testify", "Executing " .. breed_name)
					Testify:make_request("kill_minion", minion.unit)
					table.insert(minions_auto_killed, output)
				end
			end
		end

		if not table.is_empty(faulty_minions_spawned) then
			result = "-Minion unit not alive at spawn: " .. table.concat(faulty_minions_spawned, ", ")
		end

		if not spawn_simultaneously and not table.is_empty(minions_auto_killed) then
			result = result .. "-Bots were unable to kill: " .. table.concat(minions_auto_killed, ", ")
		end

		if result == "" then
			result = "All minion units were spawned and killed"
		end

		return result
	end)
end

CombatTestCases.spawn_breed = function (breed_name)
	Testify:run_case(function (dt, t)
		local player_current_position = Testify:make_request("player_current_position")
		local player_spawn_position = {
			x = player_current_position.x,
			y = player_current_position.y,
			z = player_current_position.z
		}
		local distance = 5
		local spawn_position_offset = {
			z = 0.2,
			x = distance,
			y = distance
		}
		local spawn_position = {
			x = player_spawn_position.x + spawn_position_offset.x,
			y = player_spawn_position.y + spawn_position_offset.y,
			z = player_spawn_position.z + spawn_position_offset.z
		}
		local minion = {
			breed_side = 2,
			breed_name = breed_name,
			spawn_position = spawn_position
		}

		Log.info("Testify", "Spawning " .. breed_name)
		Testify:make_request("spawn_minion", minion)
	end)
end

CombatTestCases.ensure_breed_ragdoll_actors = function (case_settings)
	Testify:run_case(function (dt, t)
		local result = ""
		local settings = cjson.decode(case_settings or "{}")
		local wait_timer = settings.wait_timer or 0.2
		local specific_breed = string.value_or_nil(settings.specific_breed or nil)

		if TestifySnippets.is_debug_stripped() then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)
		Testify:make_request("make_players_unkillable")
		Testify:make_request("make_players_invulnerable")

		local breeds = Testify:make_request("all_breeds")
		local breed_side = 2
		local player_current_position = Testify:make_request("player_current_position")
		local distance = 8
		local minion_spawn_position = {
			x = player_current_position.x + distance,
			y = player_current_position.y + distance,
			z = player_current_position.z + 0.1
		}

		for _, breed in ipairs(breeds) do
			local gib_template = breed.gib_template

			if gib_template then
				local breed_name = breed.name

				if not specific_breed or specific_breed == breed_name then
					Log.info("Testify", "Validating ragdoll actor hit zone map for: " .. breed_name)

					local minion_data = {
						breed = breed,
						breed_name = breed_name,
						breed_side = breed_side,
						spawn_position = minion_spawn_position
					}
					local hit_zone_ragdoll_actors = breed.hit_zone_ragdoll_actors

					if hit_zone_ragdoll_actors then
						local minion_unit = Testify:make_request("spawn_minion", minion_data)

						Unit.animation_event(minion_unit, "ragdoll")
						TestifySnippets.wait(0.1)

						local is_minion_alive = Testify:make_request("is_unit_alive", minion_unit)

						if not is_minion_alive then
							break
						end

						local missing_actor_names = {}

						for _, actor_names in pairs(hit_zone_ragdoll_actors) do
							for i = 1, #actor_names do
								local actor_name = actor_names[i]
								local actor = Unit.actor(minion_unit, actor_name)

								if actor == nil then
									missing_actor_names[#missing_actor_names + 1] = actor_name
								end
							end
						end

						if #missing_actor_names > 0 then
							result = result .. string.format("Breed: %s is missing a ragdoll actor(s) for: %s \n", breed_name, table.tostring(missing_actor_names))
						end
					else
						Log.info("Testify", "Breed: %q is missing a definition for 'hit_zone_ragdoll_actors'", breed_name)
					end

					TestifySnippets.wait(wait_timer)
				end
			end
		end

		if string.value_or_nil(result) == nil then
			result = "Success"
		end

		return result
	end)
end

CombatTestCases.gib_all_minions = function (case_settings)
	Testify:run_case(function (dt, t)
		local result = ""
		local settings = cjson.decode(case_settings or "{}")
		local gib_timer = settings.gib_timer or 1
		local wait_timer = settings.wait_timer or 1
		local specific_breed = type(settings.specific_breed) == "string" and string.value_or_nil(settings.specific_breed) or settings.specific_breed

		if TestifySnippets.is_debug_stripped() then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(1)
		Testify:make_request("make_players_unkillable")
		Testify:make_request("make_players_invulnerable")

		local function _is_valid_breed(breed_name)
			if not specific_breed then
				return true
			end

			if type(specific_breed) == "string" then
				return specific_breed == breed_name
			elseif type(specific_breed) == "table" then
				return table.contains(specific_breed, breed_name)
			end

			return false
		end

		local breeds = Testify:make_request("all_breeds")
		local breed_side = 2
		local player_current_position = Testify:make_request("player_current_position")
		local num_edges = 36
		local angle_offset = 2 * math.pi / num_edges
		local distance = 10
		local spawn_positions = {}

		for i = 1, num_edges do
			local angle = angle_offset * i
			local spawn_position_offset = {
				z = 0.2,
				x = math.cos(angle) * distance,
				y = math.sin(angle) * distance
			}
			spawn_positions[i] = {
				x = player_current_position.x + spawn_position_offset.x,
				y = player_current_position.y + spawn_position_offset.y,
				z = player_current_position.z + spawn_position_offset.z
			}
		end

		local spawn_index = 1

		local function _run_gib(minion_data, hit_zone_name, gibbing_type, gib_settings)
			local breed_name = minion_data.breed_name
			spawn_index = num_edges < spawn_index and 1 or spawn_index
			minion_data.spawn_position = spawn_positions[spawn_index]
			spawn_index = spawn_index + 1
			local minion_unit = Testify:make_request("spawn_minion", minion_data)
			local is_minion_alive = nil
			local minion_time_of_spawn = os.clock()

			while os.clock() - minion_time_of_spawn < gib_timer do
				is_minion_alive = Testify:make_request("is_unit_alive", minion_unit)

				if not is_minion_alive then
					break
				end
			end

			is_minion_alive = Testify:make_request("is_unit_alive", minion_unit)

			if is_minion_alive then
				Log.info("Testify", "Gibbing: %q, hit_zone_name: %q, gibbing_type: %q", breed_name, hit_zone_name, gibbing_type)

				local parameters = {
					unit = minion_unit,
					hit_zone_name = hit_zone_name,
					gibbing_type = gibbing_type,
					gib_settings = gib_settings
				}

				Testify:make_request("gib_minion", parameters)
			else
				Log.info("Testify", "Faulty breed: %q", breed_name)

				result = result .. string.format("Faulty breed: %s \n", breed_name)
			end

			TestifySnippets.wait(wait_timer)
		end

		for _, breed in ipairs(breeds) do
			local gib_template = breed.gib_template

			if gib_template then
				local breed_name = breed.name

				if _is_valid_breed(breed_name) then
					Log.info("Testify", "Running gib routine for: " .. breed_name)

					local minion_data = {
						breed = breed,
						breed_name = breed_name,
						breed_side = breed_side
					}

					for hit_zone_name, data in pairs(gib_template) do
						if hit_zone_name ~= "name" then
							if hit_zone_name == "fallback_hit_zone" then
								hit_zone_name = nil
							end

							for gibbing_type, gib_settings in pairs(data) do
								if gib_settings.conditional then
									for _, conditional_gib_settings in ipairs(gib_settings.conditional) do
										_run_gib(minion_data, hit_zone_name, gibbing_type, conditional_gib_settings)
									end
								else
									_run_gib(minion_data, hit_zone_name, gibbing_type, gib_settings)
								end
							end
						end
					end
				end
			end
		end

		TestifySnippets.wait(2)

		if string.value_or_nil(result) == nil then
			result = "Success"
		end

		return result
	end)
end
