local TestifySnippets = require("scripts/tests/testify_snippets")
MiscTestCases = {
	check_logs_size = function (max_messages_per_minute)
		Testify:run_case(function (dt, t)
			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait(5)

			local statistics = TestifySnippets.connection_statistics()
			local messages_per_minute = statistics.messages_per_minute

			Log.info("Testify", "messages_per_minute " .. messages_per_minute)

			local assert_data = {
				assert = "log_size_assert",
				condition = messages_per_minute <= max_messages_per_minute,
				message = string.format("The number of messages in the logs per minute is %s which is bigger than the threshold %s", messages_per_minute, max_messages_per_minute)
			}

			Testify:make_request("log_size_assert", assert_data)
		end)
	end,
	play_all_vfx = function (case_settings)
		Testify:run_case(function (dt, t)
			local settings = cjson.decode(case_settings or "{}")
			local particle_life_time = settings.particle_life_time or 3
			local PARTICLES_TO_SKIP = {
				"content/fx/particles/debug/mesh_position_spawn_crash",
				"content/fx/particles/enemies/netgunner/netgunner_net_miss",
				"content/fx/particles/enemies/plague_ogryn/plague_ogryn_body_odor",
				"content/fx/particles/environment/foundry_molten_pool_boiling_01",
				"content/fx/particles/environment/molten_steel_splash",
				"content/fx/particles/environment/molten_steel_splashes_impact",
				"content/fx/particles/environment/roofdust_tremor",
				"content/fx/particles/environment/tank_foundry/fire_smoke_02",
				"content/fx/particles/environment/tank_foundry/fire_smoke_03",
				"content/fx/particles/interacts/airlock_closing",
				"content/fx/particles/interacts/airlock_opening",
				"content/fx/particles/liquid_area/fire_lingering_enemy",
				"content/fx/particles/weapons/swords/powersword_1h_activate_mesh"
			}

			if TestifySnippets.is_debug_stripped() then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
				TestifySnippets.load_mission("spawn_all_enemies")
			end

			TestifySnippets.wait_for_gameplay_ready()
			Testify:make_request("set_autoload_enabled", true)

			local world = Testify:make_request("world")
			local boxed_spawn_position = Vector3Box(0, 10, 1.8)
			local query_handle = Testify:make_request("metadata_execute_query_deferred", {
				type = "particles"
			}, {
				include_properties = false
			})
			local particles = Testify:make_request("metadata_wait_for_query_results", query_handle)
			local particle_ids = {}

			for particle_name, _ in pairs(particles) do
				if not table.contains(PARTICLES_TO_SKIP, particle_name) then
					local particle_id = Testify:make_request("create_particles", world, particle_name, boxed_spawn_position, particle_life_time)
					particle_ids[particle_name] = particle_id
				end
			end

			TestifySnippets.wait(particle_life_time)
		end)
	end,
	smoke = function ()
		Testify:run_case(function (dt, t)
			if TestifySnippets.is_debug_stripped() then
				TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			end

			Testify:make_request("wait_for_state_gameplay_reached")
			TestifySnippets.wait(5)
		end)
	end
}

return
