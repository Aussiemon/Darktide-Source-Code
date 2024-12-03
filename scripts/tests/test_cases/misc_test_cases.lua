-- chunkname: @scripts/tests/test_cases/misc_test_cases.lua

local TestifySnippets = require("scripts/tests/testify_snippets")

MiscTestCases = {}

local function _ensure_table_structure(tbl, ...)
	local num_args = select("#", ...)

	for i = 1, num_args do
		local arg = select(i, ...)

		tbl[arg] = tbl[arg] or {}
		tbl = tbl[arg]
	end

	return tbl
end

MiscTestCases.validate_weapon_skin_preview_items = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		local item_definitions = Testify:make_request("all_items")
		local missing_preview_items = {}

		for name, item_data in pairs(item_definitions) do
			if item_data.item_type == "WEAPON_SKIN" and (not item_data.preview_item or item_data.preview_item == "") then
				missing_preview_items[#missing_preview_items + 1] = name
			end
		end

		Testify.expect:is_true("invalid_skin_attachment_override", table.is_empty(missing_preview_items), "Items contain nil attachments. These are defined in the item files but won't show up in the Item Manager:\n\t" .. table.concat(missing_preview_items, "\n\t"))
	end)
end

MiscTestCases.validate_minion_visual_loadout_templates = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		local MinionVisualLoadoutTemplates = require("scripts/settings/minion_visual_loadout/minion_visual_loadout_templates")
		local item_definitions = Testify:make_request("all_items")
		local missing_items = {}

		for breed_name, loadout_templates in pairs(MinionVisualLoadoutTemplates) do
			for template_name, template_variations in pairs(loadout_templates) do
				for variation_i, variation in ipairs(template_variations) do
					for slot_name, slot_data in pairs(variation.slots) do
						for item_i, item_name in ipairs(slot_data.items) do
							if not rawget(item_definitions, item_name) then
								local items = _ensure_table_structure(missing_items, breed_name, template_name, variation_i, slot_name)

								items[item_i] = item_name
							end
						end
					end
				end
			end
		end

		if not table.is_empty(missing_items) then
			local error_tbl = {
				"Minion visual loadout items missing in MasterData:",
			}

			for breed_name, templates in pairs(missing_items) do
				table.insert(error_tbl, "\n" .. breed_name .. " = {")

				for template_name, variations in pairs(templates) do
					table.insert(error_tbl, "\n\t" .. template_name .. " = {")

					for variation_i, slot_names in pairs(variations) do
						table.insert(error_tbl, "\n\t\t[" .. variation_i .. "] = {")

						for slot_name, items in pairs(slot_names) do
							table.insert(error_tbl, "\n\t\t\t" .. slot_name .. " = {")

							for item_index, item_name in pairs(items) do
								table.insert(error_tbl, "\n\t\t\t\t[" .. item_index .. "] = " .. item_name)
							end

							table.insert(error_tbl, "\n\t\t\t}")
						end

						table.insert(error_tbl, "\n\t\t}")
					end

					table.insert(error_tbl, "\n\t}")
				end

				table.insert(error_tbl, "\n}")
			end

			Testify.expect:fail("invalid_skin_attachment_override", table.concat(error_tbl))
		end
	end)
end

local function _ensure_no_hidden_attachments_recursive(item_definitions, nil_attachments, attachment_data, attachment_name, parent_item_name, source_item_name)
	local item_name = attachment_data.item

	if not item_name then
		nil_attachments[source_item_name] = nil_attachments[source_item_name] or {}
		nil_attachments[source_item_name][attachment_name] = true

		return
	end

	local children = attachment_data.children

	if children then
		for child_attachment_name, child_data in pairs(children) do
			_ensure_no_hidden_attachments_recursive(item_definitions, nil_attachments, child_data, child_attachment_name, item_name, source_item_name)
		end
	end
end

MiscTestCases.ensure_no_hidden_attachments = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		local item_definitions = Testify:make_request("all_items")
		local nil_attachments = {}

		for name, item_data in pairs(item_definitions) do
			local attachments = item_data.attachments

			if attachments then
				for attachment_name, attachment_data in pairs(attachments) do
					_ensure_no_hidden_attachments_recursive(item_definitions, nil_attachments, attachment_data, attachment_name, name, name)
				end
			end
		end

		if not table.is_empty(nil_attachments) then
			local error_tbl = {
				"Items contain holes in their attachment setup. They won't show up in the Item Manager, but can be found in the file, and will load unnecessary resources:\n",
			}

			for source_item_name, nil_attachment_names in pairs(nil_attachments) do
				table.insert(error_tbl, "\t" .. source_item_name .. "\n")

				for name, _ in pairs(nil_attachment_names) do
					table.insert(error_tbl, "\t\t" .. name .. "\n")
				end
			end

			Testify.expect:fail("invalid_skin_attachment_override", table.concat(error_tbl))
		end
	end)
end

local _ignored_attachment_types = {
	slot_trinket_1 = true,
	slot_trinket_2 = true,
}

local function _validate_attachment_parents_recursive(item_definitions, attachment_data, loose_children, attachment_name, parent_item_name, source_item_name)
	local item_name = attachment_data.item

	if not item_name then
		return
	end

	local ignored = _ignored_attachment_types[attachment_name]

	if not ignored and item_name ~= "" and parent_item_name == "" then
		loose_children[source_item_name] = loose_children[source_item_name] or {}
		loose_children[source_item_name][attachment_name] = true

		return
	end

	local children = attachment_data.children

	if children then
		for child_attachment_name, child_data in pairs(children) do
			_validate_attachment_parents_recursive(item_definitions, child_data, loose_children, child_attachment_name, item_name, source_item_name)
		end
	end
end

local _ignored_item_types = {
	WEAPON_SKIN = true,
}

MiscTestCases.validate_attachment_parents = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		local item_definitions = Testify:make_request("all_items")
		local loose_children = {}

		for name, item_data in pairs(item_definitions) do
			local item_type = item_data.item_type
			local ignored = item_type and _ignored_item_types[item_type]
			local attachments = item_data.attachments

			if not ignored and attachments then
				for attachment_name, attachment_data in pairs(attachments) do
					_validate_attachment_parents_recursive(item_definitions, attachment_data, loose_children, attachment_name, name, name)
				end
			end
		end

		if not table.is_empty(loose_children) then
			local error_tbl = {
				"The following items contain attachments without parents:\n",
			}

			for source_item_name, attachment_names in pairs(loose_children) do
				table.insert(error_tbl, "\t" .. source_item_name .. "\n")

				for name, _ in pairs(attachment_names) do
					table.insert(error_tbl, "\t\t" .. name .. "\n")
				end
			end

			Testify.expect:fail("invalid_skin_attachment_override", table.concat(error_tbl))
		end
	end)
end

local function _validate_stripping_recursive(item_definitions, attachment_data, stripped_children, parent_name, source_item_name)
	local item_name = attachment_data.item

	if not item_name then
		return
	end

	if item_name ~= "" then
		local item_data = item_definitions[item_name]

		if not item_data then
			stripped_children[source_item_name] = stripped_children[source_item_name] or {}
			stripped_children[source_item_name][parent_name] = stripped_children[source_item_name][parent_name] or {}
			stripped_children[source_item_name][parent_name][item_name] = true
		end
	end

	local children = attachment_data.children

	if children then
		for child_name, child_data in pairs(children) do
			local child_name = child_data.item

			_validate_stripping_recursive(item_definitions, child_data, stripped_children, item_name, source_item_name)
		end
	end
end

MiscTestCases.validate_attachment_stripping = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		do return end

		local item_definitions = Testify:make_request("all_items")
		local stripped_children = {}

		for name, item_data in pairs(item_definitions) do
			local attachments = item_data.attachments

			if attachments then
				for attachment_name, attachment_data in pairs(attachments) do
					_validate_stripping_recursive(item_definitions, attachment_data, stripped_children, name, name)
				end
			end
		end

		if not table.is_empty(stripped_children) then
			local error_tbl = {
				"MasterItems contains released items with unreleased attachments:\n",
			}

			for source_item_name, faulty_parents in pairs(stripped_children) do
				table.insert(error_tbl, "\t" .. source_item_name .. "\n")

				for parent_name, faulty_children in pairs(faulty_parents) do
					table.insert(error_tbl, "\t\t" .. parent_name .. "\n")

					for name, _ in pairs(faulty_children) do
						table.insert(error_tbl, "\t\t\t" .. name .. "\n")
					end
				end
			end

			Testify.expect:fail("attachment_version_mismatch", table.concat(error_tbl))
		end
	end)
end

MiscTestCases.check_logs_size = function (max_messages_per_minute)
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(5)

		local statistics = TestifySnippets.connection_statistics()
		local messages_per_minute = statistics.messages_per_minute

		Log.info("Testify", "messages_per_minute " .. messages_per_minute)
		Testify.expect:is_true("log_size_assert", messages_per_minute <= max_messages_per_minute, string.format("The number of messages in the logs per minute is %s which is bigger than the threshold %s", messages_per_minute, max_messages_per_minute))
	end)
end

local _invalid_skin_attachment_overrides = {}

local function _check_weapon_skin_attachments_recursive(attachment_name, children, faulty_items, attachment_item_name, source_item_name)
	local is_invalid_slot = _invalid_skin_attachment_overrides[attachment_name]
	local slot_is_empty = attachment_item_name == ""

	if is_invalid_slot and not slot_is_empty then
		faulty_items[source_item_name] = faulty_items[source_item_name] or {}
		faulty_items[source_item_name][attachment_name] = attachment_item_name
	end

	for attachment_name, attachment_data in pairs(children) do
		local attachment_children = attachment_data.children
		local item_name = attachment_data.item

		_check_weapon_skin_attachments_recursive(attachment_name, attachment_children, faulty_items, item_name, source_item_name)
	end
end

MiscTestCases.check_unwanted_skin_attachments = function ()
	Testify:run_case(function (dt, t)
		TestifySnippets.skip_splash_and_title_screen()

		do return end

		local item_definitions = Testify:make_request("all_items")
		local faulty_skin_attachment_overrides = {}

		for name, item_data in pairs(item_definitions) do
			if item_data.item_type == "WEAPON_SKIN" then
				local attachments = item_data.attachments

				if attachments then
					for attachment_name, attachment_data in pairs(attachments) do
						local children = attachment_data.children
						local item_name = attachment_data.item

						_check_weapon_skin_attachments_recursive(attachment_name, children, faulty_skin_attachment_overrides, item_name, name)
					end
				end
			end
		end

		if not table.is_empty(faulty_skin_attachment_overrides) then
			local error_tbl = {
				"MasterItems contains weapon skins with invalid attachment overrides:\n",
			}

			for item_name, attachment_names in pairs(faulty_skin_attachment_overrides) do
				table.insert(error_tbl, "\t" .. item_name .. "\n")

				for slot_name, item_name in pairs(attachment_names) do
					table.insert(error_tbl, "\t\t" .. slot_name .. ": " .. item_name .. "\n")
				end
			end

			Testify.expect:fail("invalid_skin_attachment_override", table.concat(error_tbl))
		end
	end)
end

MiscTestCases.play_all_cutscenes = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local flags = settings.flags or {
			"cutscenes",
			"load_mission",
		}
		local hide_players = settings.hide_players or false
		local mission_key = settings.mission_key
		local use_trigger_volumes = settings.use_trigger_volumes or false
		local intro_cutscenes = settings.intro_cutscenes or {
			"intro_abc",
		}
		local cutscenes_to_skip = settings.cutscenes_to_skip or {
			"intro_abc",
		}
		local measure_performance = settings.measure_performance or false
		local performance_measurements = measure_performance and {} or nil
		local telemetry_event_name = measure_performance and "perf_cutscene" or nil

		if (TestifySnippets.is_debug_stripped() or BUILD == "release") and Testify:make_request("current_state_name") ~= "StateGameplay" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		local output = TestifySnippets.check_flags_for_mission(flags, mission_key)

		if output then
			return output
		end

		TestifySnippets.load_mission(mission_key)
		Testify:make_request("wait_for_state_gameplay_reached")

		for _, cutscene_name in ipairs(intro_cutscenes) do
			Testify:make_request("wait_for_cutscene_to_start", cutscene_name)

			if measure_performance then
				local values_to_measure = {
					batchcount = true,
					primitives_count = true,
				}

				Testify:make_request("start_measuring_performance", values_to_measure)
			end

			Testify:make_request("wait_for_cutscene_to_finish", cutscene_name)

			if measure_performance then
				performance_measurements = Testify:make_request("stop_measuring_performance")

				Testify:make_request("create_telemetry_event", telemetry_event_name, mission_key, cutscene_name, performance_measurements)
			end

			TestifySnippets.wait(2)
		end

		local cutscenes = Testify:make_request("mission_cutscenes", mission_key)

		for _, cutscene_name in ipairs(cutscenes_to_skip) do
			cutscenes[cutscene_name] = nil
		end

		local temp_keys = {}

		for cutscene_name, _ in table.sorted(cutscenes, temp_keys) do
			local outro_win = cutscene_name == "outro_win"

			if outro_win then
				Testify:make_request("trigger_external_event", "mission_outro_win")
			end

			if hide_players then
				Testify:make_request("hide_players")
			end

			if use_trigger_volumes then
				local event_name = "event_cutscene_" .. cutscene_name

				Testify:make_request("trigger_external_event", event_name)
				Testify:make_request("wait_for_cutscene_to_start", cutscene_name)
			else
				Testify:make_request("play_cutscene", cutscene_name)
				Testify:make_request("wait_for_cutscene_to_start", cutscene_name)
			end

			if measure_performance then
				local values_to_measure = {
					batchcount = true,
					primitives_count = true,
				}

				Testify:make_request("start_measuring_performance", values_to_measure)
			end

			Testify:make_request("wait_for_cutscene_to_finish", cutscene_name)

			if measure_performance then
				performance_measurements = Testify:make_request("stop_measuring_performance")

				Testify:make_request("create_telemetry_event", telemetry_event_name, mission_key, cutscene_name, performance_measurements)
			end

			if hide_players then
				Testify:make_request("show_players")
			end

			TestifySnippets.wait(2)
		end

		if measure_performance then
			TestifySnippets.send_telemetry_batch()
		end

		table.clear(temp_keys)
		TestifySnippets.wait(3)
	end)
end

MiscTestCases.play_all_vfx = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local particle_life_time = settings.particle_life_time or 3
		local PARTICLES_TO_SKIP = {
			"content/fx/particles/enemies/netgunner/netgunner_net_miss",
			"content/fx/particles/enemies/plague_ogryn/plague_ogryn_body_odor",
			"content/fx/particles/environment/foundry_molten_pool_boiling_01",
			"content/fx/particles/environment/ice_zone/lightnings_emit_from_mesh_01",
			"content/fx/particles/environment/molten_steel_splash",
			"content/fx/particles/environment/molten_steel_splashes_impact",
			"content/fx/particles/environment/roofdust_tremor",
			"content/fx/particles/environment/tank_foundry/fire_smoke_02",
			"content/fx/particles/environment/tank_foundry/fire_smoke_03",
			"content/fx/particles/interacts/airlock_closing",
			"content/fx/particles/interacts/airlock_opening",
			"content/fx/particles/liquid_area/fire_lingering_enemy",
			"content/fx/particles/weapons/shock_maul/powermaul_1h_activate_mesh",
			"content/fx/particles/weapons/shock_maul/powermaul_1h_looping_mesh",
			"content/fx/particles/weapons/swords/powersword_1h_activate_mesh_loop",
			"content/fx/particles/weapons/swords/powersword_1h_activate_mesh",
			"content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh_loop",
			"content/fx/particles/weapons/swords/powersword_2h/powersword_2h_activate_mesh",
		}

		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		TestifySnippets.wait_for_gameplay_ready()
		Testify:make_request("set_autoload_enabled", true)

		local world = Testify:make_request("world")
		local boxed_spawn_position = Vector3Box(0, 10, 1.8)
		local query_handle = Testify:make_request("metadata_execute_query_deferred", {
			type = "particles",
		}, {
			include_properties = false,
		})
		local particles = Testify:make_request("metadata_wait_for_query_results", query_handle)
		local num_particles, i = #particles, 1
		local particle_ids = {}

		for particle_name, _ in pairs(particles) do
			if not table.contains(PARTICLES_TO_SKIP, particle_name) then
				Log.info("Testify", "%s/%s Playing vfx %s", i, num_particles, particle_name)

				local particle_id = Testify:make_request("create_particles", world, particle_name, boxed_spawn_position, particle_life_time)

				particle_ids[particle_name] = particle_id
			end

			i = i + 1
		end

		TestifySnippets.wait(particle_life_time)
	end)
end

MiscTestCases.spawn_all_units = function (case_settings)
	Testify:run_case(function (dt, t)
		local UNITS_TO_SKIP = {
			"content/characters/enemy/chaos_hound/third_person/base",
			"content/characters/npc/human/attachments_base/face_emora_brahms/face_emora_brahms",
			"content/characters/player/human/first_person/preview",
			"content/environment/artsets/debug/events_test/test_decoder_server_02",
			"content/environment/artsets/debug/events_test/test_spinny_thing",
			"content/environment/artsets/debug/events_test/test_vox_array",
			"content/environment/gameplay/events/rise/end/turntable_bogie_01",
			"content/fx/meshes/shells/cylinder",
			"content/fx/meshes/shells/lightning_pipe_discharge_tube",
			"content/fx/meshes/vfx_plane",
			"content/fx/units/weapons/small_caliber_plastic_large_01",
		}
		local settings = cjson.decode(case_settings or "{}")
		local interval = settings.interval or 0
		local spawn_and_destroy_same_frame = settings.spawn_and_destroy_same_frame == true
		local units_to_skip = settings.units_to_skip or UNITS_TO_SKIP
		local folder = settings.folder

		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
			TestifySnippets.load_mission("spawn_all_enemies")
		end

		TestifySnippets.wait_for_gameplay_ready()
		Testify:make_request("set_autoload_enabled", true)

		local boxed_spawn_position = Vector3Box(-2, 11.76, 2)
		local query_handle = Testify:make_request("metadata_execute_query_deferred", {
			type = "unit",
		}, {
			include_properties = false,
		})
		local units = Testify:make_request("metadata_wait_for_query_results", query_handle)
		local num_units, i = table.size(units), 1

		TestifySnippets.wait(1)

		for unit_name, _ in pairs(units) do
			if not table.array_contains(units_to_skip, unit_name) then
				if not folder or string.starts_with(unit_name, folder) then
					Log.info("Testify", "%s/%s Spawning unit %s", i, num_units, unit_name)

					if spawn_and_destroy_same_frame then
						Testify:make_request("spawn_and_destroy_unit", unit_name, boxed_spawn_position)
					else
						local unit = Testify:make_request("spawn_unit", unit_name, boxed_spawn_position)

						TestifySnippets.wait(interval)
						Testify:make_request("delete_unit", unit)
					end
				end

				i = i + 1
			end
		end
	end)
end

MiscTestCases.validate_critter_spawner = function (case_settings)
	Testify:run_case(function (dt, t)
		return
	end)
end

MiscTestCases.smoke = function ()
	Testify:run_case(function (dt, t)
		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		Testify:make_request("wait_for_state_gameplay_reached")
		TestifySnippets.wait(5)
	end)
end

MiscTestCases.stress_alt_combinations = function (case_settings)
	Testify:run_case(function (dt, t)
		local settings = cjson.decode(case_settings or "{}")
		local key = settings.key or "tab"
		local screen_mode = settings.screen_mode
		local num_iterations_during_loading = settings.num_iterations_during_loading or 6
		local num_iterations_during_gameplay_state = settings.num_iterations_during_gameplay_state or 10
		local interval_time = settings.interval_time or 3

		if TestifySnippets.is_debug_stripped() or BUILD == "release" then
			TestifySnippets.skip_title_and_main_menu_and_create_character_if_none()
		end

		if screen_mode then
			TestifySnippets.set_render_settings("screen_mode", screen_mode, 1)
		end

		for i = 1, num_iterations_during_loading do
			Testify:make_request_to_runner("press_keyboard_combination", "alt", key)
			TestifySnippets.wait(interval_time)
		end

		Testify:make_request("wait_for_state_gameplay_reached")

		for i = 1, num_iterations_during_gameplay_state do
			Testify:make_request_to_runner("press_keyboard_combination", "alt", key)
			TestifySnippets.wait(interval_time)
		end

		TestifySnippets.set_render_settings("screen_mode", "borderless_fullscreen", 1)
	end)
end
