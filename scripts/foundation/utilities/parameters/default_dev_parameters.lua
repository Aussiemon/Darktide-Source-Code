-- chunkname: @scripts/foundation/utilities/parameters/default_dev_parameters.lua

local categories = {
	"Abilities",
	"Achievements",
	"Action Input",
	"Action",
	"Animation",
	"Auspex",
	"Backend",
	"Blackboard",
	"Bot Character",
	"Breed Picker",
	"Breed",
	"Buffs",
	"Camera",
	"Chain Lightning",
	"Chaos Hound",
	"Chaos Spawn",
	"Chat",
	"Chunk Lod",
	"Coherency",
	"Combat Vector",
	"Corruptors",
	"Covers",
	"Critical Strikes",
	"Crosshair",
	"Daemonhost",
	"Damage Interface",
	"Damage",
	"Debug Print",
	"Destructibles",
	"Dialogue",
	"Difficulty",
	"Effects",
	"Equipment",
	"Error",
	"Event",
	"Feature Info",
	"FGRL",
	"Force Field",
	"Framerate",
	"Free Flight",
	"Game Flow",
	"Game Mode",
	"Gameplay State",
	"Groups",
	"Health Station",
	"Hit Mass",
	"Horde Picker",
	"Hordes",
	"Hub",
	"Hud",
	"Imgui",
	"Input",
	"Item",
	"Ledge Finder",
	"LegacyV2ProximitySystem",
	"Level & Mission",
	"Liquid Area",
	"Liquid Beam",
	"Loading",
	"Localization",
	"Locomotion",
	"Main Path",
	"Master Data",
	"Micro Transaction (\"Premium\") Store",
	"Minigame",
	"Minion Attack Selection",
	"Minion Renegade Captain Custom Attack Selection",
	"Minions",
	"Misc",
	"Mission Objectives",
	"Monsters",
	"Mood",
	"Moveable Platform",
	"Mutant Charger",
	"Navigation",
	"Netgunner",
	"Network",
	"Pacing",
	"Party",
	"Payload",
	"Perception",
	"PerfHud",
	"Physics",
	"PhysicsProximitySystem",
	"Pickup Picker",
	"Pickups",
	"Player Character",
	"Presence",
	"Projectile Locomotion",
	"Projectile",
	"ProximitySystem",
	"Push",
	"Respawn",
	"Roamers",
	"Rumble",
	"Script Components",
	"Shading Environment",
	"Shooting Range",
	"Smart Tagging",
	"Smart Targeting",
	"Social Features",
	"Specials",
	"Stagger",
	"Stats",
	"Stories",
	"Sweep Spline",
	"Talents",
	"Terror Event",
	"Testify",
	"Time Scaling",
	"Training Grounds",
	"UI",
	"Version Info",
	"Volume",
	"Weapon Aim Assist",
	"Weapon Effects",
	"Weapon Handling",
	"Weapon Traits",
	"Weapon Mastery",
	"Weapon Variables",
	"Weapon",
	"Wwise States",
	"Wwise",
}

local function hang_ledge_toggle_draw(new_value, old_value)
	if new_value ~= old_value and Debug then
		Debug:hang_ledge_toggle_draw(new_value)
	end
end

local params = {}

params.replace_input_settings_with_dev_parameters = {
	category = "Input",
	value = false,
}
params.controller_selection = {
	category = "Input",
	value = "latest",
	options = {
		"latest",
		"fixed",
		"combined",
	},
	on_value_set = function (new_value, old_value)
		Managers.input:set_selection_logic(new_value)
	end,
}
params.fixed_controller_type = {
	category = "Input",
	value = "keyboard",
	options = {
		"keyboard",
		"xbox_controller",
		"ps4_controller",
	},
	on_value_set = function (new_value, old_value)
		Managers.input:set_selection_logic(nil, new_value)
	end,
}
params.override_last_pressed_device_on_start = {
	category = "Input",
	value = false,
	options = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller",
	},
}
params.debug_input_last_action_track_time = {
	category = "Input",
	value = 1,
}
params.debug_track_only_used_actions = {
	category = "Input",
	value = true,
}
params.grab_mouse = {
	category = "Input",
	value = true,
}
params.disable_debug_hotkeys = {
	category = "Input",
	value = false,
}
params.controller_look_scale = {
	category = "Input",
	value = 1,
}
params.controller_look_scale_ranged = {
	category = "Input",
	value = 1,
}
params.controller_look_scale_ranged_alternate_fire = {
	category = "Input",
	value = 1,
}
params.controller_invert_look_y = {
	category = "Input",
	value = false,
}
params.controller_look_dead_zone = {
	category = "Input",
	value = 0.1,
}
params.controller_enable_acceleration = {
	category = "Input",
	value = true,
}
params.show_mouse_input_filter = {
	category = "Input",
	value = false,
}
params.show_gamepad_input_filter = {
	category = "Input",
	value = false,
}
params.show_sensitivity_modifier = {
	category = "Input",
	value = false,
}
params.debug_visualize_look_raw_controller = {
	category = "Input",
	value = false,
}
params.debug_input_filter_response_curves = {
	category = "Input",
	value = false,
}

local function _debug_text_color_options()
	local colors = table.clone(Color.list)

	table.sort(colors)

	return colors
end

local _debug_text_font_options = {
	"core/performance_hud/debug",
	"content/ui/fonts/arial",
	"content/ui/fonts/itc_novarese_medium",
	"content/ui/fonts/itc_novarese_bold",
	"content/ui/fonts/proxima_nova_light",
	"content/ui/fonts/proxima_nova_medium",
	"content/ui/fonts/proxima_nova_bold",
	"content/ui/fonts/darktide_custom_regular",
	"content/ui/fonts/friz_quadrata",
	"content/ui/fonts/rexlia",
	"content/ui/fonts/machine_medium",
}

table.array_remove_if(_debug_text_font_options, function (font)
	return not Application.can_get_resource("slug", font)
end)

params.debug_text_enable = {
	category = "Debug Print",
	value = true,
}
params.debug_text_x_offset = {
	category = "Debug Print",
	value = 10,
}
params.debug_text_y_offset = {
	category = "Debug Print",
	value = 0,
}
params.debug_text_layer = {
	category = "Debug Print",
	value = 900,
}
params.debug_text_font_size = {
	category = "Debug Print",
	value = 20,
}
params.debug_text_color = {
	category = "Debug Print",
	value = "cheeseburger",
	options_function = _debug_text_color_options,
}
params.debug_text_font = {
	category = "Debug Print",
	value = _debug_text_font_options[1],
	options = _debug_text_font_options,
}
params.debug_auspex_scanning = {
	category = "Auspex",
	value = false,
}
params.debug_prevent_forced_dequip_of_auspex = {
	category = "Auspex",
	value = false,
}
params.debug_breed_picker_selected_name = {
	category = "Breed Picker",
	hidden = true,
	value = "",
}
params.debug_breed_picker_x_offset = {
	category = "Breed Picker",
	value = 5,
}
params.debug_breed_picker_y_offset = {
	category = "Breed Picker",
	value = 80,
}
params.debug_breed_picker_layer = {
	category = "Breed Picker",
	value = 910,
}
params.debug_breed_picker_font_size = {
	category = "Breed Picker",
	value = 22,
}
params.auto_select_debug_spawned_unit = {
	category = "Breed Picker",
	value = false,
}
params.debug_spawn_multiple_amount = {
	category = "Breed Picker",
	value = 25,
	options = {
		9,
		25,
		49,
		81,
		100,
		196,
	},
}
params.perform_backend_version_check = {
	category = "Backend",
	value = true,
}
params.allow_backend_game_param_overrides = {
	category = "Backend",
	value = false,
}
params.crash_on_account_login_error = {
	category = "Backend",
	value = false,
}
params.enable_stat_reporting = {
	category = "Backend",
	value = true,
}
params.enable_contracts = {
	category = "Backend",
	value = true,
}
params.enable_commendations = {
	category = "Backend",
	value = true,
}
params.backend_debug_log = {
	category = "Backend",
	value = false,
}
params.debug_verify_gear_cache = {
	category = "Backend",
	value = false,
}
params.debug_log_data_service_backend_cache = {
	category = "Backend",
	value = false,
}
params.backend_telemetry_enable = {
	category = "Backend",
	value = false,
}
params.backend_telemetry_debug = {
	category = "Backend",
	value = false,
}
params.backend_telemetry_service_url = {
	category = "Backend",
	value = "https://telemetry.fatsharkgames.com/events",
}
params.verbose_chat_log = {
	category = "Chat",
	value = false,
}
params.disable_chat = {
	category = "Chat",
	value = false,
}
params.debug_template_effects = {
	category = "Effects",
	value = false,
}
params.debug_use_dev_error_levels = {
	category = "Error",
	value = true,
}
params.show_ingame_fps = {
	category = "Framerate",
	value = "simple",
	options = {
		false,
		"simple",
		"detailed",
		"graph",
	},
}
params.aggregate_fps_period = {
	category = "Framerate",
	num_decimals = 2,
	value = 1,
}
params.low_fps_threshold = {
	category = "Framerate",
	value = 30,
}
params.medium_fps_threshold = {
	category = "Framerate",
	value = 60,
}
params.throttle_fps = {
	category = "Framerate",
	user_setting = false,
	value = 0,
	on_value_set = function (new_value, old_value)
		Application.set_time_step_policy("throttle", new_value)
	end,
}
params.debug_pickup_picker_selected_name = {
	category = "Pickup Picker",
	hidden = true,
	value = "",
}
params.debug_pickup_picker_x_offset = {
	category = "Pickup Picker",
	value = 5,
}
params.debug_pickup_picker_y_offset = {
	category = "Pickup Picker",
	value = 80,
}
params.debug_pickup_picker_layer = {
	category = "Pickup Picker",
	value = 910,
}
params.debug_pickup_picker_font_size = {
	category = "Pickup Picker",
	value = 22,
}
params.debug_hit_mass = {
	category = "Hit Mass",
	value = false,
}
params.debug_hit_mass_calculations = {
	category = "Hit Mass",
	value = false,
}
params.debug_lunge_hit_mass = {
	category = "Hit Mass",
	value = false,
}
params.debug_print_wwise_hit_mass = {
	category = "Hit Mass",
	value = false,
}
params.debug_horde_picker_selected_name = {
	category = "Horde Picker",
	hidden = true,
	value = "",
}
params.debug_horde_picker_x_offset = {
	category = "Horde Picker",
	value = 5,
}
params.debug_horde_picker_y_offset = {
	category = "Horde Picker",
	value = 80,
}
params.debug_horde_picker_layer = {
	category = "Horde Picker",
	value = 910,
}
params.debug_horde_picker_font_size = {
	category = "Horde Picker",
	value = 22,
}
params.debug_pickup_spawners = {
	category = "Pickups",
	value = false,
}
params.debug_pickup_rubberband = {
	category = "Pickups",
	value = false,
}
params.show_spawned_pickups = {
	category = "Pickups",
	value = false,
}
params.show_spawned_pickups_location = {
	category = "Pickups",
	value = false,
}
params.debug_fill_pickup_spawners = {
	category = "Pickups",
	value = false,
	options = {
		false,
		"all",
		"distributed",
		"side_mission",
	},
}
params.debug_medkits = {
	category = "Pickups",
	value = false,
}
params.debug_projectile_aim = {
	category = "Projectile Locomotion",
	value = false,
}
params.projectile_aim_disable_aim_offset = {
	category = "Projectile Locomotion",
	value = false,
}
params.projectile_aim_disable_fx_spawner_offset = {
	category = "Projectile Locomotion",
	value = false,
}
params.projectile_aim_disable_sway_recoil = {
	category = "Projectile Locomotion",
	value = false,
}
params.projectile_aim_time_step_multiplier = {
	category = "Projectile Locomotion",
	value = 1,
}
params.projectile_aim_max_steps = {
	category = "Projectile Locomotion",
	value = 500,
}
params.projectile_aim_max_number_of_bounces = {
	category = "Projectile Locomotion",
	value = 10,
}
params.disable_projectile_collision = {
	category = "Projectile Locomotion",
	value = false,
}
params.debug_projectile_locomotion_aiming = {
	category = "Projectile Locomotion",
	value = false,
}
params.visualize_projectile_locomotion = {
	category = "Projectile Locomotion",
	value = false,
}
params.debug_destructibles = {
	category = "Destructibles",
	value = false,
}
params.debug_destructible_collectibles = {
	category = "Destructibles",
	value = false,
}
params.dont_randomize_destructibles = {
	category = "Destructibles",
	value = false,
}
params.physics_debug = {
	category = "Physics",
	value = false,
}
params.physics_debug_highlight_awake = {
	category = "Physics",
	value = false,
}
params.physics_debug_type = {
	category = "Physics",
	value = "both",
	options = {
		"statics",
		"dynamics",
		"both",
	},
}
params.physics_debug_filter = {
	category = "Physics",
	value = "filter_all",
	options = {
		"filter_all",
		"filter_debug_dynamic_actors",
		"filter_debug_unit_selector",
		"filter_explosion_cover",
		"filter_ground_material_check",
		"filter_hang_ledge_collision",
		"filter_interactable_overlap",
		"filter_ladder_climb_collision",
		"filter_minion_line_of_sight_check",
		"filter_minion_shooting_geometry",
		"filter_minion_throwing",
		"filter_minion_shooting_no_friendly_fire",
		"filter_player_character_melee_sweep",
		"filter_player_character_ballistic_raycast",
		"filter_player_character_shooting_projectile",
		"filter_player_character_shooting_raycast",
		"filter_player_character_shooting_raycast_dynamics",
		"filter_player_character_shooting_raycast_statics",
		"filter_player_character_throwing",
		"filter_player_mover",
		"filter_player_ping_target_selection",
		"filter_ray_aim_assist",
		"filter_simple_geometry",
	},
}
params.physics_debug_range = {
	category = "Physics",
	value = 30,
}
params.physics_debug_color = {
	category = "Physics",
	value = "red",
	options_function = function ()
		return Color.short_list
	end,
}
params.physics_debug_only_draw_selected_unit = {
	category = "Physics",
	value = false,
}
params.physics_debug_draw_no_depth = {
	category = "Physics",
	value = false,
}
params.disable_self_assist = {
	category = "Player Character",
	value = true,
}
params.allow_character_input_in_free_flight = {
	category = "Player Character",
	name = "allow_character_input_in_free_flight, Keybind: L-CTRL + SPACE",
	value = false,
}
params.box_minion_collision = {
	category = "Player Character",
	value = false,
}

local _character_profile_selector_preview_value

params.character_profile_selector = {
	category = "Player Character",
	value = false,
	get_function = function (param_key)
		local value = DevParameters[param_key]

		if value == false then
			return _character_profile_selector_preview_value or value
		end

		return value
	end,
	options_function = function ()
		local options = {}

		if Managers.backend:authenticated() then
			Managers.data_service.profiles:fetch_all_backend_profiles():next(function (profile_data)
				local profiles = profile_data.profiles

				if profiles then
					for ii = 1, #profiles do
						local profile = profiles[ii]

						if profile then
							local character_id = profile.character_id

							table.insert(options, 1, character_id)
						end
					end
				elseif not profiles or #profiles == 0 then
					table.insert(options, 1, false)
				end

				if profile_data.selected_profile then
					_character_profile_selector_preview_value = profile_data.selected_profile.character_id
				end
			end):catch(function ()
				return
			end)
		else
			table.insert(options, 1, false)
		end

		local ProfileUtils = require("scripts/utilities/profile_utils")
		local MasterItems = require("scripts/backend/master_items")
		local local_profiles = ProfileUtils.local_profiles(MasterItems.get_cached())

		for ii = 1, #local_profiles do
			options[#options + 1] = ii
		end

		return options
	end,
	options_texts_function = function ()
		local MasterItems = require("scripts/backend/master_items")
		local ProfileUtils = require("scripts/utilities/profile_utils")
		local options_texts = {}

		if Managers.backend:authenticated() then
			Managers.data_service.profiles:fetch_all_backend_profiles():next(function (profile_data)
				local profiles = profile_data.profiles

				if profiles then
					for ii = 1, #profiles do
						local profile = profiles[ii]

						if profile then
							local archetype_name = profile.archetype.name
							local archetype_name_pretty = archetype_name and string.gsub(archetype_name, "^%l", string.upper) or "no_archetype"
							local character_name = ProfileUtils.character_name(profile)
							local level = profile.current_level and tostring(profile.current_level) or "n/a"
							local option_text = string.format("%s - %s (%s)", archetype_name_pretty, character_name, level)

							table.insert(options_texts, 1, option_text)
						end
					end
				elseif not profiles or #profiles == 0 then
					table.insert(options_texts, 1, "Backend profile")
				end
			end):catch(function ()
				return
			end)
		else
			table.insert(options_texts, 1, "Backend profile")
		end

		local local_profiles = ProfileUtils.local_profiles(MasterItems.get_cached())
		local format_string = #local_profiles >= 10 and "%-4s %s%s" or "%-3s %s%s"

		for ii = 1, #local_profiles do
			local profile = local_profiles[ii]
			local index = string.format("[%d]", ii)
			local option_text = string.format(format_string, index, profile.name or "N/A", profile.loadout_description and string.format(": %s", profile.loadout_description) or "")

			options_texts[#options_texts + 1] = option_text
		end

		return options_texts
	end,
	on_value_set = function (new_value, old_value)
		if not new_value then
			return
		end

		local local_player = Managers.player:local_player(1)

		if not local_player then
			return
		end

		local ProfileUtils = require("scripts/utilities/profile_utils")
		local MasterItems = require("scripts/backend/master_items")
		local peer_id = local_player:peer_id()
		local local_player_id = local_player:local_player_id()
		local want_backend_profile = type(new_value) == "string"

		if want_backend_profile then
			ParameterResolver.set_dev_parameter("character_profile_selector", false)

			_character_profile_selector_preview_value = new_value

			Managers.data_service.account:set_selected_character_id(new_value):next(function (_)
				Managers.narrative:load_character_narrative(new_value):next(function (_)
					local is_server = Managers.state.game_session:is_server()

					if is_server then
						local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

						profile_synchronizer_host:debug_profile_changed(peer_id, local_player_id, new_value)
					else
						local channel = Managers.connection:host_channel()

						RPC.rpc_notify_profile_changed_debug_backend_character_profile(channel, peer_id, local_player_id, new_value)
					end
				end)
			end)
		else
			local local_profiles = ProfileUtils.local_profiles(MasterItems.get_cached())
			local wanted_profile = local_profiles[new_value]
			local character_id = wanted_profile.character_id

			Managers.narrative:load_character_narrative(character_id):next(function ()
				if Managers.state.game_session then
					local is_server = Managers.state.game_session:is_server()

					if is_server then
						local profile_synchronizer_host = Managers.profile_synchronization:synchronizer_host()

						profile_synchronizer_host:profile_changed_debug_local_character_profile(peer_id, local_player_id, new_value)
					else
						local channel = Managers.connection:host_channel()

						RPC.rpc_notify_profile_changed_debug_local_character_profile(channel, peer_id, local_player_id, new_value)
					end
				end
			end)
		end
	end,
}
params.debug_character_interpolated_fixed_frame_movement = {
	category = "Player Character",
	value = false,
}
params.debug_character_ledge_hanging = {
	category = "Player Character",
	value = false,
}
params.debug_character_state_machine = {
	category = "Player Character",
	value = false,
}
params.debug_fixed_frame_update = {
	category = "Player Character",
	value = false,
}
params.debug_interaction = {
	category = "Player Character",
	value = false,
}
params.print_interaction_types = {
	category = "Player Character",
	value = false,
}
params.debug_ladder_movement = {
	category = "Player Character",
	value = false,
}
params.debug_ledge_step_up = {
	category = "Player Character",
	value = false,
}
params.debug_lunging = {
	category = "Player Character",
	value = false,
	on_value_set = function ()
		local debug_drawer = Debug:drawer("character_state_lunging")

		debug_drawer:reset()
	end,
}
params.override_player_profile_current_level = {
	category = "Player Character",
	value = false,
	options_function = function ()
		local ExperienceSettings = require("scripts/settings/experience_settings")
		local options = {
			false,
		}

		for ii = 1, ExperienceSettings.max_level do
			options[#options + 1] = ii
		end

		return options
	end,
	on_value_set = function ()
		local local_player = Managers.player:local_player(1)

		if not local_player then
			return
		end

		local ProfileUtils = require("scripts/utilities/profile_utils")
		local character_id = local_player:character_id()

		Managers.data_service.profiles:fetch_profile(character_id):next(function (profile)
			local new_profile = ProfileUtils.unpack_profile(ProfileUtils.pack_profile(profile))

			local_player:set_profile(new_profile)
		end):catch(function ()
			return
		end)
	end,
}
params.debug_netted_rotation = {
	category = "Player Character",
	value = false,
}
params.debug_player_fx = {
	category = "Player Character",
	value = false,
}
params.debug_player_gear_fx = {
	category = "Player Character",
	value = false,
}
params.debug_player_suppression = {
	category = "Player Character",
	value = false,
}
params.debug_player_unit_data_sync = {
	category = "Player Character",
	value = false,
}
params.debug_step_up = {
	category = "Player Character",
	value = false,
}
params.disable_player_catapulting = {
	category = "Player Character",
	value = false,
}
params.disable_warp_charge = {
	category = "Player Character",
	value = false,
}
params.disable_warp_charge_passive_dissipating = {
	category = "Player Character",
	value = false,
}
params.disable_warp_charge_explosion = {
	category = "Player Character",
	value = false,
}
params.always_max_warp_charge = {
	category = "Player Character",
	value = false,
}
params.debug_draw_ledge_hanging_ik = {
	category = "Player Character",
	value = false,
}
params.disable_ledge_hanging_ik = {
	category = "Player Character",
	value = false,
}
params.hang_ledge_draw_enabled = {
	category = "Player Character",
	value = false,
	on_value_set = hang_ledge_toggle_draw,
}
params.infinite_ledge_hanging = {
	category = "Player Character",
	value = false,
}
params.override_ledge_hanging_time = {
	category = "Player Character",
	value = false,
	options = {
		false,
		5,
		10,
		15,
		20,
		25,
		30,
	},
}
params.infinite_stamina = {
	category = "Player Character",
	value = false,
}
params.debug_stamina = {
	category = "Player Character",
	value = false,
}
params.player_render_frame_position = {
	category = "Player Character",
	value = "interpolate",
	options = {
		"interpolate",
		"extrapolate",
		"raw",
	},
}
params.print_debugged_player_data_fields = {
	category = "Player Character",
	value = false,
}
params.print_player_unit_data = {
	category = "Player Character",
	value = false,
}
params.print_player_unit_data_debug_vertically = {
	category = "Player Character",
	value = true,
}
params.print_player_unit_data_lookups = {
	category = "Player Character",
	value = false,
}
params.use_super_jumps = {
	category = "Player Character",
	value = false,
}
params.use_testify_profiles = {
	category = "Player Character",
	value = false,
}
params.force_third_person_mode = {
	category = "Player Character",
	value = false,
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if not player then
			return
		end

		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			return
		end

		local ext = ScriptUnit.extension(player_unit, "first_person_system")
	end,
}
params.force_third_person_hub_camera_use = {
	category = "Player Character",
	value = false,
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if not player then
			return
		end

		local player_unit = player.player_unit

		if not ALIVE[player_unit] then
			return
		end

		local ext = ScriptUnit.extension(player_unit, "camera_system")
	end,
}
params.debug_player_slots = {
	category = "Player Character",
	value = false,
}
params.debug_sliding_character_state = {
	category = "Player Character",
	value = false,
}
params.debug_likely_stuck = {
	category = "Player Character",
	value = false,
}
params.disable_likely_stuck_implementation = {
	category = "Player Character",
	value = false,
}
params.debug_push_velocity = {
	category = "Player Character",
	value = false,
}
params.add_constant_push = {
	category = "Player Character",
	value = false,
}
params.enable_player_character_scale_overrides = {
	category = "Player Character",
	value = false,
}
params.player_character_first_person_scale_override = {
	category = "Player Character",
	num_decimals = 3,
	value = 1,
}
params.player_character_third_person_scale_override = {
	category = "Player Character",
	num_decimals = 3,
	value = 1,
}
params.disable_last_man_standing_wwise_state = {
	category = "Wwise States",
	value = false,
}
params.debug_wwise_states = {
	category = "Wwise States",
	value = false,
}
params.debug_wwise_state_groups = {
	category = "Wwise States",
	value = false,
}
params.debug_wwise_states_override = {
	category = "Wwise States",
	value = false,
}
params.debug_wwise_states_override_a_game = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"character_creation",
		"defeat",
		"game_score",
		"game_start",
		"mission",
		"mission_briefing",
		"mission_intro",
		"mission_start",
		"title",
		"victory",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_game_state", new_value)
	end,
}
params.debug_wwise_states_override_b_zone = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"hub",
		"prologue",
		"zone_1",
		"zone_2",
		"zone_3",
		"zone_4",
		"zone_5",
		"zone_6",
		"zone_7",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_zone", new_value)
	end,
}
params.debug_wwise_states_override_c_combat = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"normal",
		"boss",
		"horde",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_combat", new_value)
	end,
}
params.debug_wwise_states_override_d_objective = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"control_mission",
		"extraction_mission",
		"fetch_mission",
		"fortification_mission",
		"kill_mission",
		"last_stand",
		"mid_event",
		"purge_mission",
		"vip_mission",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_objective", new_value)
	end,
}
params.debug_wwise_states_override_e_objective_progression = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"one",
		"two",
		"three",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_objective_progression", new_value)
	end,
}
params.debug_wwise_states_override_f_circumstance = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_circumstance", new_value)
	end,
}
params.debug_wwise_states_override_g_event_type = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"mid_event",
		"end_event",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("event_category", new_value)
	end,
}
params.debug_wwise_states_override_h_combat_effects = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"normal",
		"monster",
		"horde",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("minion_aggro_intensity", new_value)
	end,
}
params.debug_wwise_states_override_i_options = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"ingame_menu",
		"vendor_menu",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("options", new_value)
	end,
}
params.debug_wwise_states_override_j_event_intensity = {
	category = "Wwise States",
	value = "None",
	options = {
		"None",
		"low",
		"high",
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("event_intensity", new_value)
	end,
}
params.no_ability_cooldowns = {
	category = "Abilities",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_no_ability_cooldowns(channel, new_value)
		end
	end,
}
params.short_ability_cooldowns = {
	category = "Abilities",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_short_ability_cooldowns(channel, new_value)
		end
	end,
}
params.debug_smoke_fog = {
	category = "Abilities",
	value = false,
}
params.show_ability_cooldowns = {
	category = "Abilities",
	value = false,
}
params.debug_bots = {
	category = "Bot Character",
	value = false,
}
params.debug_bots_aoe_threat = {
	category = "Bot Character",
	value = false,
}
params.debug_bots_order = {
	category = "Bot Character",
	value = false,
}
params.debug_bot_input = {
	category = "Bot Character",
	value = false,
}
params.debug_bots_weapon = {
	category = "Bot Character",
	value = false,
}
params.debug_selected_bot_target_selection = {
	category = "Bot Character",
	value = false,
}
params.disable_bot_follow = {
	category = "Bot Character",
	value = false,
}
params.disable_bot_abilities = {
	category = "Bot Character",
	value = false,
}
params.debug_bot_action_input = {
	category = "Bot Character",
	value = false,
}
params.max_bots = {
	category = "Bot Character",
	value = "default",
	options = {
		"default",
		0,
		1,
		2,
		3,
	},
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if Managers.state.game_session:is_server() then
			Managers.event:trigger("debug_max_bots_changed", new_value, old_value)
		else
			local value_index = new_value == "default" and 0 or new_value + 1
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_set_max_bots(channel, value_index)
		end
	end,
}
params.bots_enabled = {
	category = "Bot Character",
	value = true,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if Managers.state.game_session:is_server() then
			Managers.event:trigger("debug_bots_enabled_changed", new_value, old_value)
		else
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_bots_enabled_changed(channel, new_value)
		end
	end,
}
params.debug_buffs = {
	category = "Buffs",
	value = false,
}
params.debug_buffs_hide_predicted = {
	category = "Buffs",
	value = false,
}
params.debug_buffs_hide_non_predicted = {
	category = "Buffs",
	value = false,
}
params.debug_buffs_show_categories = {
	category = "Buffs",
	value = "all",
	options = {
		"all",
		"generic",
		"talents",
		"weapon_traits",
		"talents_secondary",
		"gadget",
		"aura",
	},
}
params.debug_meta_buffs = {
	category = "Buffs",
	value = false,
}
params.debug_minion_buff_fx = {
	category = "Buffs",
	value = false,
}
params.debug_boons = {
	category = "Buffs",
	value = false,
}
params.disable_buff_screen_space_effects = {
	category = "Buffs",
	value = false,
}
params.debug_perception = {
	category = "Perception",
	value = false,
	options = {
		false,
		"minions",
		"bots",
		"both",
	},
}
params.disable_minion_perception = {
	category = "Perception",
	name = "disable_minion_perception, Keybind: L-SHIFT + Z",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_minion_perception(channel, new_value)
		end
	end,
}
params.ignore_players_as_targets = {
	category = "Perception",
	value = false,
}
params.debug_selected_minion_target_selection_weights = {
	category = "Perception",
	value = false,
}
params.debug_selected_unit_threat = {
	category = "Perception",
	value = false,
}
params.debug_blackboards = {
	category = "Blackboard",
	value = false,
}
params.debug_wwise_elevation = {
	category = "Wwise",
	value = false,
}
params.debug_sound_environments = {
	category = "Wwise",
	name = "Sound environment",
	value = false,
}
params.use_gameplay_sound_indicators = {
	category = "Wwise",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("sound_option_gameplay_indicators", new_value == true and "true" or "false")
		end
	end,
}
params.use_bass_boost = {
	category = "Wwise",
	num_decimals = 2,
	value = 0,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			local world = Application.main_world()
			local wwise_world = Wwise.wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world, "sound_option_bass_boost", new_value)
		end
	end,
}
params.debug_draw_closest_point_on_line_sounds = {
	category = "Wwise",
	value = false,
}
params.debug_draw_moving_line_sfx = {
	category = "Wwise",
	value = false,
}
params.debug_draw_moving_line_vfx = {
	category = "Wwise",
	value = false,
}
params.debug_print_portal = {
	category = "Wwise",
	value = false,
}
params.debug_player_wwise_state = {
	category = "Wwise",
	value = false,
}
params.disable_lua_sound_reflection = {
	category = "Wwise",
	value = false,
}
params.debug_lua_sound_reflection = {
	category = "Wwise",
	value = false,
}
params.always_play_husk_effects = {
	category = "Wwise",
	value = false,
}

local function _debug_slots_options()
	local SlotTypeSettings = require("scripts/settings/slot/slot_type_settings")
	local options = table.keys(SlotTypeSettings)

	local function descending_sort(a, b)
		return b < a
	end

	table.sort(options, descending_sort)
	table.insert(options, 1, false)

	options[#options + 1] = "all"

	return options
end

params.debug_event_manager = {
	category = "Event",
	value = false,
}
params.debug_failed_pathing = {
	category = "Navigation",
	value = false,
}
params.debug_ai_movement = {
	category = "Navigation",
	value = false,
	options = {
		false,
		"graphics_only",
		"text_and_graphics",
	},
}
params.nav_mesh_debug = {
	category = "Navigation",
	value = false,
	options = {
		false,
		"without_nav_graphs",
		"with_nav_graphs",
	},
}
params.debug_nav_graph = {
	category = "Navigation",
	value = false,
	options = {
		false,
		"graphics_only",
		"prints_and_graphics",
	},
}
params.nav_graph_draw_distance = {
	category = "Navigation",
	value = 50,
	options = {
		10,
		50,
		100,
		math.huge,
	},
}
params.debug_slots = {
	category = "Navigation",
	value = false,
	options_function = _debug_slots_options,
}
params.debug_doors = {
	category = "Navigation",
	value = false,
}
params.always_update_doors = {
	category = "Navigation",
	value = false,
}
params.debug_pathfinder_queue = {
	category = "Navigation",
	value = false,
}
params.draw_smartobject_fails = {
	category = "Navigation",
	value = false,
}
params.debug_nav_tag_volume_creation_times = {
	category = "Navigation",
	value = false,
}
params.engine_locomotion_debug = {
	category = "Locomotion",
	value = false,
}
params.debug_movement_speed = {
	category = "Locomotion",
	value = false,
}
params.draw_minion_velocity = {
	category = "Locomotion",
	value = false,
}
params.draw_player_mover = {
	category = "Locomotion",
	value = false,
}
params.teleport_on_out_of_bounds = {
	category = "Locomotion",
	value = false,
}
params.debug_draw_fall_damage = {
	category = "Locomotion",
	value = false,
}
params.debug_draw_force_translation = {
	category = "Locomotion",
	value = false,
}
params.draw_third_person_player_rotation = {
	category = "Locomotion",
	value = false,
}
params.debug_hub_movement_direction_variable = {
	category = "Hub",
	value = false,
}
params.hub_locomotion_position_mode_override = {
	category = "Hub",
	value = false,
	options = {
		false,
		"simulation",
		"animation",
		"feet_in_air",
	},
}
params.debug_hub_character_rotation = {
	category = "Hub",
	value = false,
}
params.show_predicted_hub_locomotion = {
	category = "Hub",
	value = false,
}
params.show_hub_locomotion = {
	category = "Hub",
	value = false,
}
params.debug_hub_movement_acceleration = {
	category = "Hub",
	value = false,
}
params.debug_hub_movement_move_state = {
	category = "Hub",
	value = false,
}
params.debug_fake_max_allowed_wanted_velocity_angle = {
	category = "Hub",
	value = false,
	options = {
		false,
		"left",
		"right",
	},
}
params.debug_visualize_input_direction = {
	category = "Hub",
	value = false,
}
params.debug_draw_hub_aim_constraint_targets = {
	category = "Hub",
	value = false,
	options = {
		false,
		"head",
		"torso",
		"both",
	},
}
params.always_jog_in_hub = {
	category = "Hub",
	value = false,
}
params.debug_draw_moveable_platforms = {
	category = "Moveable Platform",
	value = false,
}
params.debug_networked_timer = {
	category = "Mission Objectives",
	value = false,
}
params.debug_mission_objectives = {
	category = "Mission Objectives",
	value = false,
}
params.debug_mission_objective_target = {
	category = "Mission Objectives",
	value = false,
}
params.debug_mission_objective_zone = {
	category = "Mission Objectives",
	value = false,
}
params.debug_decoder_synchronizer = {
	category = "Mission Objectives",
	value = false,
}
params.debug_decoding_device = {
	category = "Mission Objectives",
	value = false,
}
params.debug_scanning_device = {
	category = "Mission Objectives",
	value = false,
}
params.debug_spline_follower = {
	category = "Mission Objectives",
	value = false,
}
params.debug_luggable_synchronizer = {
	category = "Mission Objectives",
	value = false,
}
params.debug_show_player_wallets = {
	category = "Mission Objectives",
	value = false,
}
params.use_free_flight_camera_for_bone_lod = {
	category = "Animation",
	value = false,
}
params.debug_bone_lod_radius = {
	category = "Animation",
	value = false,
}
params.debug_skeleton = {
	category = "Animation",
	value = false,
}
params.disable_third_person_weapon_anim_events = {
	category = "Animation",
	value = false,
}
params.show_minion_anim_event = {
	category = "Animation",
	value = false,
}
params.show_minion_anim_event_history = {
	category = "Animation",
	value = false,
}
params.minion_anim_event_history_count = {
	category = "Animation",
	value = 10,
}
params.debug_minion_anim_logging = {
	category = "Animation",
	value = false,
}
params.enable_first_person_anim_logging = {
	category = "Animation",
	value = false,
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if player:unit_is_alive() then
			local player_unit = player.player_unit
			local fp_ext = ScriptUnit.extension(player_unit, "first_person_system")
			local fp_unit = fp_ext:first_person_unit()

			Unit.set_animation_logging(fp_unit, new_value)
		end
	end,
}
params.enable_third_person_anim_logging = {
	category = "Animation",
	value = false,
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if player:unit_is_alive() then
			local player_unit = player.player_unit

			Unit.set_animation_logging(player_unit, new_value)
		end
	end,
}
params.debug_animation_recording = {
	category = "Animation",
	value = false,
}
params.debug_animation_rollback = {
	category = "Animation",
	value = false,
}
params.dump_animation_state_config = {
	category = "Animation",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value then
			local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
			local PlayerUnitAnimationStateConfig = require("scripts/extension_systems/animation/utilities/player_unit_animation_state_config")

			PlayerUnitAnimationStateConfig.format(PlayerCharacterConstants.animation_rollback)
		end
	end,
}
params.debug_first_person_run_speed_animation_scale = {
	category = "Animation",
	value = false,
}
params.show_player_3p_anim_event = {
	category = "Animation",
	value = false,
}
params.show_player_1p_anim_event = {
	category = "Animation",
	value = false,
}
params.max_num_player_anim_events_to_show = {
	category = "Animation",
	value = 10,
}
params.timer_picker_selected_timer_name = {
	category = "Time Scaling",
	hidden = true,
	value = "gameplay",
}
params.timer_picker_x_offset = {
	category = "Time Scaling",
	value = 5,
}
params.timer_picker_y_offset = {
	category = "Time Scaling",
	value = 80,
}
params.timer_picker_layer = {
	category = "Time Scaling",
	value = 910,
}
params.timer_picker_font_size = {
	category = "Time Scaling",
	value = 22,
}
params.max_time_scale = {
	category = "Time Scaling",
	value = 15,
}
params.debug_change_time_scale = {
	category = "Time Scaling",
	value = true,
}
params.disable_training_grounds_minion_respawning = {
	category = "Training Grounds",
	value = false,
}
params.debug_sweep_show_disregarded_actors = {
	category = "Action",
	value = false,
}
params.debug_sweep_show_sweep_lines = {
	category = "Action",
	value = false,
}
params.debug_sweep_log_unit_processing = {
	category = "Action",
	value = false,
}
params.debug_action_sweep_log = {
	category = "Action",
	value = false,
}
params.debug_weapon_actions = {
	category = "Action",
	value = false,
}
params.keep_last_action_drawn = {
	category = "Action",
	value = true,
}
params.log_weapon_action_transitions = {
	category = "Action",
	value = false,
}
params.show_action_movement_curves = {
	category = "Action",
	value = false,
}
params.debug_show_attacked_hit_zones = {
	category = "Action",
	value = false,
}
params.debug_sweep_stickyness = {
	category = "Action",
	value = false,
}
params.draw_closest_targeting_action_module = {
	category = "Action",
	value = false,
}
params.debug_print_action_combo = {
	category = "Action",
	value = false,
}
params.debug_draw_ballistic_raycast = {
	category = "Action",
	value = false,
}
params.debug_aim_placement_raycast = {
	category = "Action",
	value = false,
}
params.debug_action_input_parser = {
	category = "Action Input",
	value = false,
}
params.action_input_parser_mispredict_info = {
	category = "Action Input",
	value = false,
}
params.debug_disable_client_action_input_parsing = {
	category = "Action Input",
	value = false,
}
params.sweep_spline_selected_weapon_template = {
	category = "Sweep Spline",
	value = "thunderhammer_2h_p1_m1",
	options_function = function ()
		local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
		local options = {}

		for weapon_template_name, weapon_template in pairs(WeaponTemplates) do
			for _, action_settings in pairs(weapon_template.actions) do
				if action_settings.kind == "sweep" then
					options[#options + 1] = weapon_template_name

					break
				end
			end
		end

		return options
	end,
}

local function _attack_selection_template_override_options(breed_name)
	local Breeds = require("scripts/settings/breed/breeds")
	local data = Breeds[breed_name]
	local options, attack_selection_templates = {}, data.attack_selection_templates

	for i = 1, #attack_selection_templates do
		local template = attack_selection_templates[i]

		options[i] = template.name
	end

	options[#options + 1] = "custom"

	table.sort(options)
	table.insert(options, 1, false)

	return options
end

params.renegade_captain_attack_selection_template_override = {
	category = "Minion Attack Selection",
	value = false,
	options_function = function ()
		return _attack_selection_template_override_options("renegade_captain")
	end,
}
params.cultist_captain_attack_selection_template_override = {
	category = "Minion Attack Selection",
	value = false,
	options_function = function ()
		return _attack_selection_template_override_options("cultist_captain")
	end,
}
params.debug_taunting = {
	category = "Minion Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_bolt_pistol_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_bolt_pistol_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_charge = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_fire_grenade = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_frag_grenade = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_hellgun_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_hellgun_spray_and_pray = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_hellgun_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_hellgun_sweep_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_kick = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_power_sword_melee_combo_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_power_sword_moving_melee_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_powermaul_ground_slam_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_punch = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_shoot_net = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_shotgun_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_shotgun_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.renegade_captain_custom_attack_selection_void_shield_explosion = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_bolt_pistol_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_bolt_pistol_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_charge = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_fire_grenade = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_frag_grenade = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_hellgun_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_hellgun_spray_and_pray = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_hellgun_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_hellgun_sweep_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_kick = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_power_sword_melee_combo_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_power_sword_moving_melee_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_powermaul_ground_slam_attack = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_punch = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_shoot_net = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_shotgun_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_shotgun_strafe_shoot = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.cultist_captain_custom_attack_selection_void_shield_explosion = {
	category = "Minion Renegade Captain Custom Attack Selection",
	value = false,
}
params.debug_minion_ground_impact_fx = {
	category = "Minions",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("minion_ground_impact")
		end
	end,
}
params.debug_disable_minion_suppression = {
	category = "Minions",
	value = false,
}
params.debug_minion_dissolve = {
	category = "Minions",
	value = false,
}
params.debug_disable_minion_suppression_indicators = {
	category = "Minions",
	value = false,
}
params.debug_grenadiers = {
	category = "Minions",
	value = false,
}
params.debug_minion_suppression = {
	category = "Minions",
	value = false,
}
params.debug_area_suppression_falloff = {
	category = "Minions",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("suppression_falloff")
		end
	end,
}
params.debug_minion_reuse_wounds = {
	category = "Minions",
	value = false,
}
params.debug_draw_minion_bind_pose = {
	category = "Minions",
	value = false,
}
params.debug_draw_minion_wounds_hits = {
	category = "Minions",
	value = false,
}
params.debug_minion_wounds_shape = {
	category = "Minions",
	value = false,
}
params.debug_minion_gibbing = {
	category = "Minions",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("minion_gibbing")
		end
	end,
}
params.debug_disable_minion_stagger = {
	category = "Minions",
	value = false,
}
params.debug_disable_minion_blocked_reaction = {
	category = "Minions",
	value = false,
}
params.debug_minion_melee_attacks = {
	category = "Minions",
	value = false,
}
params.debug_minion_shooting = {
	category = "Minions",
	value = false,
}
params.debug_minion_toughness = {
	category = "Minions",
	value = false,
}
params.debug_attack_intensity = {
	category = "Minions",
	value = false,
}
params.debug_locked_in_melee = {
	category = "Minions",
	value = false,
}
params.debug_warp_teleport = {
	category = "Minions",
	value = false,
}
params.show_num_minions = {
	category = "Minions",
	value = false,
}
params.show_player_minion_kills = {
	category = "Minions",
	value = false,
}
params.show_minion_names = {
	category = "Minions",
	value = false,
}
params.show_minion_location = {
	category = "Minions",
	value = false,
}
params.show_minion_health = {
	category = "Minions",
	value = false,
}
params.debug_minion_aiming = {
	category = "Minions",
	value = false,
}
params.debug_minion_spawners = {
	category = "Minions",
	value = false,
}
params.minions_always_accurate = {
	category = "Minions",
	value = false,
}
params.show_combat_ranges = {
	category = "Minions",
	value = false,
}
params.debug_minion_phases = {
	category = "Minions",
	value = false,
}
params.debug_minion_shoot_pattern = {
	category = "Minions",
	value = false,
}
params.show_attack_selection_template = {
	category = "Minions",
	value = false,
}
params.debug_script_minion_collision = {
	category = "Minions",
	value = false,
}
params.show_health_bars_on_all_minions = {
	category = "Minions",
	value = false,
}
params.show_health_bars_on_elite_and_specials = {
	category = "Minions",
	value = false,
}
params.minions_aggro_on_spawn = {
	category = "Minions",
	value = false,
}
params.debug_minion_shields = {
	category = "Minions",
	value = false,
}
params.enable_minion_auto_stagger = {
	category = "Minions",
	value = false,
}
params.ignore_stuck_minions_warning = {
	category = "Minions",
	value = false,
}
params.ignore_special_failed_spawn_errors = {
	category = "Minions",
	value = false,
}
params.script_minion_collision = {
	category = "Minions",
	value = true,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if Managers.state.game_session:is_server() then
			local players = Managers.player:players()

			for _, player in pairs(players) do
				if player:unit_is_alive() then
					local player_unit = player.player_unit

					ScriptUnit.extension(player_unit, "locomotion_system"):enable_script_minion_collision(new_value)

					if player.remote then
						local go_id = Managers.state.unit_spawner:game_object_id(player_unit)

						RPC.rpc_enable_script_minion_collision(player:channel_id(), go_id, new_value)
					end
				end
			end
		end
	end,
}
params.calculate_offset_from_peeking_to_aiming_in_cover = {
	category = "Minions",
	value = false,
}
params.kill_debug_spawned_minions_outside_navmesh = {
	category = "Minions",
	value = true,
}
params.mute_minion_sounds = {
	category = "Minions",
	value = false,
	on_value_set = function (new_value, old_value)
		Wwise.set_state("debug_mute_minions", new_value and "true" or "None")
	end,
}
params.debug_stats = {
	category = "Stats",
	value = false,
}
params.local_stats = {
	category = "Stats",
	value = false,
}
params.show_stats_rpcs = {
	category = "Stats",
	value = false,
}
params.show_stats_performance = {
	category = "Stats",
	value = false,
}
params.distance_to_selected_unit = {
	category = "Misc",
	value = false,
}
params.debug_player_orientation = {
	category = "Misc",
	value = false,
}
params.debug_smooth_force_view_orientation = {
	category = "Misc",
	value = false,
}
params.debug_disable_vertical_smooth_force_view_orientation = {
	category = "Misc",
	value = false,
}
params.allow_server_control_from_client = {
	category = "Misc",
	value = false,
}
params.debug_idle_fullbody_animation_variable = {
	category = "Misc",
	value = false,
}
params.use_screen_timestamp = {
	category = "Misc",
	value = false,
}
params.store_callstack_on_delete = {
	category = "Misc",
	value = false,
}
params.disable_server_metrics_prints = {
	category = "Misc",
	value = false,
}
params.disable_player_unit_weapon_extension_on_reload = {
	category = "Misc",
	value = false,
}
params.lock_look_input = {
	category = "Misc",
	value = false,
}
params.max_num_characters_override = {
	category = "Misc",
	value = 8,
	options = {
		false,
		5,
		6,
		7,
		8,
	},
}
params.challenge = {
	category = "Difficulty",
	value = 3,
	options = {
		1,
		2,
		3,
		4,
		5,
		6,
	},
	on_value_set = function (new_value, old_value)
		Managers.state.difficulty:set_challenge(new_value)
	end,
}
params.resistance = {
	category = "Difficulty",
	value = 3,
	options = {
		1,
		2,
		3,
		4,
		5,
	},
	on_value_set = function (new_value, old_value)
		Managers.state.difficulty:set_resistance(new_value)
	end,
}
params.minion_friendly_fire = {
	category = "Difficulty",
	value = true,
}
params.player_friendly_fire = {
	category = "Difficulty",
	value = false,
}
params.debug_chaos_hound = {
	category = "Chaos Hound",
	value = false,
}
params.disable_chaos_hound_pounce = {
	category = "Chaos Hound",
	value = false,
}
params.debug_mutant_charger = {
	category = "Mutant Charger",
	value = false,
}
params.debug_chaos_spawn = {
	category = "Chaos Spawn",
	value = false,
}
params.enable_chunk_lod = {
	category = "Chunk Lod",
	value = true,
}
params.chunk_lod_debug = {
	category = "Chunk Lod",
	value = false,
}
params.chunk_lod_free_flight_camera_raycast = {
	category = "Chunk Lod",
	value = false,
}
params.debug_print_stripped_items = {
	category = "Item",
	value = true,
}
params.show_gear_ids = {
	category = "Item",
	value = false,
}
params.only_fallback_items = {
	category = "Item",
	value = false,
}
params.debug_players_immune_net = {
	category = "Netgunner",
	value = false,
}
params.debug_netgunner_shoot_position = {
	category = "Netgunner",
	value = false,
}
params.debug_netted_drag_position = {
	category = "Netgunner",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("netted_drag_position")
		end
	end,
}
params.debug_daemonhost = {
	category = "Daemonhost",
	value = false,
}
params.debug_liquid_beam = {
	category = "Liquid Beam",
	value = false,
}
params.debug_covers = {
	category = "Covers",
	value = false,
}
params.debug_combat_vector = {
	category = "Combat Vector",
	value = false,
}
params.debug_combat_vector_simple = {
	category = "Combat Vector",
	value = false,
}
params.debug_corruptors = {
	category = "Corruptors",
	value = false,
}
params.auto_kill_corruptor_pustules = {
	category = "Corruptors",
	value = false,
}
params.disable_corruptor_damage_tick = {
	category = "Corruptors",
	value = false,
}
params.debug_roamer_pacing = {
	category = "Roamers",
	value = false,
}
params.disable_roamer_pacing = {
	category = "Roamers",
	value = false,
}
params.debug_patrols = {
	category = "Roamers",
	value = false,
}
params.disable_cultists = {
	category = "Roamers",
	value = false,
}
params.debug_hordes = {
	category = "Hordes",
	value = false,
}
params.disable_horde_pacing = {
	category = "Hordes",
	value = false,
}
params.disable_trickle_horde_pacing = {
	category = "Hordes",
	value = false,
}
params.debug_horde_pacing = {
	category = "Hordes",
	value = false,
}
params.debug_groups = {
	category = "Groups",
	value = false,
}
params.debug_group_sfx = {
	category = "Groups",
	value = false,
}
params.chaos_hound_allowed = {
	category = "Specials",
	value = true,
}
params.chaos_hound_mutator_allowed = {
	category = "Specials",
	value = true,
}
params.cultist_mutant_mutator_allowed = {
	category = "Specials",
	value = true,
}
params.chaos_poxwalker_bomber_allowed = {
	category = "Specials",
	value = true,
}
params.cultist_flamer_allowed = {
	category = "Specials",
	value = true,
}
params.cultist_grenadier_allowed = {
	category = "Specials",
	value = true,
}
params.cultist_mutant_allowed = {
	category = "Specials",
	value = true,
}
params.debug_specials_pacing = {
	category = "Specials",
	value = false,
}
params.disable_specials_pacing = {
	category = "Specials",
	value = false,
}
params.freeze_specials_pacing = {
	category = "Specials",
	value = false,
}
params.renegade_grenadier_allowed = {
	category = "Specials",
	value = true,
}
params.renegade_netgunner_allowed = {
	category = "Specials",
	value = true,
}
params.renegade_sniper_allowed = {
	category = "Specials",
	value = true,
}
params.flamer_allowed = {
	category = "Specials",
	value = true,
}
params.grenadier_allowed = {
	category = "Specials",
	value = true,
}
params.renegade_flamer_allowed = {
	category = "Specials",
	value = true,
}
params.renegade_flamer_mutator_allowed = {
	category = "Specials",
	value = true,
}
params.disable_monster_pacing = {
	category = "Monsters",
	value = false,
}
params.debug_monster_pacing = {
	category = "Monsters",
	value = false,
}
params.debug_pacing = {
	category = "Pacing",
	value = false,
}
params.disable_pacing = {
	category = "Pacing",
	name = "disable_pacing, Keybind: L-SHIFT + X",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_pacing(channel, new_value)
		end
	end,
}
params.debug_player_combat_states = {
	category = "Pacing",
	value = false,
}
params.disable_beast_of_nurgle = {
	category = "Pacing",
	value = false,
}
params.disable_daemonhost = {
	category = "Pacing",
	value = false,
}
params.disable_renegade_berzerker = {
	category = "Pacing",
	value = false,
}
params.debug_join_party = {
	category = "Party",
	value = false,
}
params.immaterium_local_grpc = {
	category = "Party",
	value = false,
}
params.party_hash = {
	category = "Party",
	value = false,
}
params.reconnect_to_ongoing_game_session = {
	category = "Party",
	value = true,
}
params.verbose_party_log = {
	category = "Party",
	value = false,
}
params.debug_playload = {
	category = "Payload",
	value = false,
}
params.verbose_presence_log = {
	category = "Presence",
	value = false,
}
params.print_batched_presence_streams = {
	category = "Presence",
	value = false,
}
params.hide_hud = {
	category = "Hud",
	value = false,
}
params.enemy_outlines = {
	category = "Hud",
	value = "on",
	options = {
		"off",
		"on",
	},
}
params.player_outlines_mode = {
	category = "Hud",
	value = "skeleton",
	options = {
		"off",
		"always",
		"obscured",
		"skeleton",
	},
}
params.player_outlines_type = {
	category = "Hud",
	value = "both",
	options = {
		"outlines",
		"mesh",
		"both",
	},
}
params.disable_outlines = {
	category = "Hud",
	value = false,
}
params.simulate_color_blindness = {
	category = "Hud",
	value = "off",
	options = {
		"off",
		"rare_protanomaly",
		"common_deuteranomaly",
		"very_rare_tritanomaly",
	},
	on_value_set = function (new_value)
		local on = true
		local mode = 0

		if new_value == "off" then
			on = false
		else
			mode = new_value == "rare_protanomaly" and 0 or new_value == "common_deuteranomaly" and 1 or 2
		end

		if on then
			Application.set_render_setting("color_blindness_mode", mode)
			Application.set_render_setting("simulate_color_blindness", "true")
		else
			Application.set_render_setting("simulate_color_blindness", "false")
		end
	end,
}
params.show_debug_charge_hud = {
	category = "Hud",
	value = false,
}
params.show_debug_overheat_hud = {
	category = "Hud",
	value = false,
}
params.show_debug_warp_charge_hud = {
	category = "Hud",
	value = false,
}
params.show_debug_force_sword_2h_hud = {
	category = "Hud",
	value = false,
}
params.show_debug_scanning_progressbar = {
	category = "Hud",
	value = false,
}
params.always_max_warp_charge_hud_opacity = {
	category = "Hud",
	value = false,
}
params.always_max_overheat_hud_opacity = {
	category = "Hud",
	value = false,
}
params.hide_hud_world_markers = {
	category = "Hud",
	value = false,
}
params.always_show_hit_marker = {
	category = "Crosshair",
	value = false,
}
params.always_show_weakspot_hit_marker = {
	category = "Crosshair",
	value = false,
}
params.dot_crosshair_override = {
	category = "Crosshair",
	value = false,
}
params.hit_marker_color_override = {
	category = "Crosshair",
	value = false,
	options_function = function ()
		local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
		local options = table.keys(HudElementCrosshairSettings.hit_indicator_colors)

		table.insert(options, 1, false)

		return options
	end,
}

local SHOW_INFO = BUILD == "dev" or BUILD == "debug"

params.render_version_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_build_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_engine_revision_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_content_revision_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_backend_url = {
	category = "Version Info",
	value = false,
}
params.show_master_data_version = {
	category = "Version Info",
	value = true,
}
params.show_team_city_build_info = {
	category = "Version Info",
	value = false,
}
params.show_backend_account_info = {
	category = "Version Info",
	value = true,
}
params.show_lan_port_info = {
	category = "Version Info",
	value = false,
}
params.show_network_hash_info = {
	category = "Version Info",
	value = false,
}
params.show_screen_resolution_info = {
	category = "Version Info",
	value = false,
}
params.show_mission_name = {
	category = "Version Info",
	value = true,
}
params.show_level_name = {
	category = "Version Info",
	value = false,
}
params.show_chunk_name = {
	category = "Version Info",
	value = true,
}
params.show_game_mode_name = {
	category = "Version Info",
	value = false,
}
params.show_num_hub_players = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_unique_instance_id = {
	category = "Version Info",
	value = true,
}
params.show_region = {
	category = "Version Info",
	value = true,
}
params.show_deployment_id = {
	category = "Version Info",
	value = false,
}
params.show_camera_position_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_camera_rotation_info = {
	category = "Version Info",
	value = false,
}
params.show_player_1p_position_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_player_3p_position_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_mechanism_name = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_network_info = {
	category = "Version Info",
	value = SHOW_INFO,
}
params.show_progression_info = {
	category = "Version Info",
	value = false,
}
params.show_presence_info = {
	category = "Version Info",
	value = false,
}
params.show_difficulty = {
	category = "Version Info",
	value = true,
}
params.show_circumstances = {
	category = "Version Info",
	value = true,
}
params.show_selected_unit_info = {
	category = "Version Info",
	value = true,
}
params.show_vo_story_stage_info = {
	category = "Version Info",
	value = false,
}
params.show_cinematic_active = {
	category = "Version Info",
	value = false,
}
params.render_feature_info = {
	category = "Feature Info",
	value = SHOW_INFO,
}
params.debug_draw_force_field_collision = {
	category = "Force Field",
	value = false,
}
params.show_force_field_life_and_health = {
	category = "Force Field",
	value = false,
}
params.override_burst_limit = {
	category = "FGRL",
	value = false,
}
params.burst_limit_calls = {
	category = "FGRL",
	value = 10,
}
params.override_sustain_limit = {
	category = "FGRL",
	value = false,
}
params.sustain_limit_calls = {
	category = "FGRL",
	value = 30,
}
params.perfhud_artist = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist")
	end,
}
params.perfhud_artist_deferred_lighting = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "deferred_lighting")
	end,
}
params.perfhud_artist_fx = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "fx")
	end,
}
params.perfhud_artist_gui = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "gui")
	end,
}
params.perfhud_artist_lighting = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "lighting")
	end,
}
params.perfhud_artist_objects = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "objects")
	end,
}
params.perfhud_artist_post_processing = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "post_processing")
	end,
}
params.perfhud_audio = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "audio")
	end,
}
params.perfhud_culling = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "culling")
	end,
}
params.perfhud_extended_memory = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "extended_memory")
	end,
}
params.perfhud_gui = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "gui")
	end,
}
params.perfhud_lua = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "lua")
	end,
}
params.perfhud_memory = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "memory")
	end,
}
params.perfhud_memory_allocator_usage = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "memory", "allocator_usage")
	end,
}
params.perfhud_network = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network")
	end,
}
params.perfhud_network_messages = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_messages")
	end,
}
params.perfhud_network_peers = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers")
	end,
}
params.perfhud_network_peers_bytes = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers", "bytes")
	end,
}
params.perfhud_network_peers_kbps = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers", "kbps")
	end,
}
params.perfhud_network_ping = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_ping")
	end,
}
params.perfhud_texture_streaming = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "texture_streaming")
	end,
}
params.perfhud_wwise = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "wwise")
	end,
}
params.perfhud_backend_client = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "backend", "client")
	end,
}
params.perfhud_backend_server = {
	category = "PerfHud",
	value = false,
	on_value_set = function (new_value)
		Application.console_command("perfhud", "backend", "server")
	end,
}
params.ui_developer_mode = {
	category = "UI",
	value = false,
}
params.ui_debug_3d_rendering = {
	category = "UI",
	value = false,
}
params.ui_debug_3d_no_slug_text = {
	category = "UI",
	value = false,
}
params.ui_disable_kill_feed = {
	category = "UI",
	value = false,
}
params.ui_show_active_views = {
	category = "UI",
	value = false,
}
params.ui_debug_subtitles = {
	category = "UI",
	value = false,
}
params.ui_use_local_inventory = {
	category = "UI",
	value = false,
}
params.ui_always_enable_inventory_access = {
	category = "UI",
	value = false,
}
params.ui_always_enable_achievements_menu = {
	category = "UI",
	value = false,
}
params.ui_hide_hud = {
	category = "UI",
	value = false,
}
params.ui_debug_test_view_spawning = {
	category = "UI",
	value = false,
}
params.ui_debug_scenegraph = {
	category = "UI",
	value = false,
}
params.ui_debug_pixeldistance = {
	category = "UI",
	value = false,
}
params.ui_grid_enabled = {
	category = "UI",
	value = false,
}
params.ui_grid_width = {
	category = "UI",
	value = 100,
}
params.ui_grid_height = {
	category = "UI",
	value = 100,
}
params.ui_debug_hover = {
	category = "UI",
	value = false,
}
params.ui_skip_main_menu_screen = {
	category = "UI",
	value = false,
}
params.ui_skip_title_screen = {
	category = "UI",
	value = false,
}
params.ui_skip_splash_screen = {
	category = "UI",
	value = false,
}
params.ui_disable_view_loader = {
	category = "UI",
	value = false,
}
params.ui_view_scale = {
	category = "UI",
	num_decimals = 1,
	value = 1,
	on_value_set = function ()
		local force_update = true

		UPDATE_RESOLUTION_LOOKUP(force_update)
	end,
}
params.ui_safe_rect = {
	category = "UI",
	value = 0,
	on_value_set = function ()
		local force_update = true

		UPDATE_RESOLUTION_LOOKUP(force_update)
	end,
}
params.ui_disabled = {
	category = "UI",
	value = false,
}
params.ui_debug_end_screen = {
	category = "UI",
	value = false,
}
params.ui_debug_lobby_screen = {
	category = "UI",
	value = false,
}
params.ui_debug_mission_intro = {
	category = "UI",
	value = false,
}
params.ui_debug_mission_outro = {
	category = "UI",
	value = false,
}
params.ui_enable_item_names = {
	category = "UI",
	value = false,
}
params.ui_enable_mission_board_debug = {
	category = "UI",
	value = false,
}
params.ui_show_social_menu = {
	category = "UI",
	value = true,
}
params.ui_enable_debug_view = {
	category = "UI",
	value = false,
}
params.ui_debug_news_screen = {
	category = "UI",
	value = false,
}
params.ui_enable_notifications = {
	category = "UI",
	value = true,
	on_value_set = function ()
		Managers.event:trigger("event_clear_notifications")
	end,
}
params.spawn_next_to_mission_board = {
	category = "UI",
	value = false,
}
params.spawn_next_to_crafting = {
	category = "UI",
	value = false,
}
params.ui_debug_loc_strings = {
	category = "UI",
	value = false,
}
params.ui_ignore_hub_interaction_requirements = {
	category = "UI",
	value = false,
}
params.local_crafting = {
	category = "UI",
	value = false,
}
params.sticker_book_seen_all_traits = {
	category = "UI",
	value = false,
}
params.debug_render_target_atlas_generator = {
	category = "UI",
	value = false,
}
params.ui_always_show_tutorial_popup = {
	category = "UI",
	value = false,
}
params.override_stun_type = {
	category = "Damage",
	value = false,
	options_function = function ()
		local DisorientationSettings = require("scripts/settings/damage/disorientation_settings")
		local options = {
			false,
		}

		for key, _ in pairs(DisorientationSettings.disorientation_types) do
			options[#options + 1] = key
		end

		return options
	end,
}
params.disable_player_wounds = {
	category = "Damage",
	value = false,
}
params.show_selected_unit_health = {
	category = "Damage",
	value = false,
}
params.show_debug_explosions = {
	category = "Damage",
	value = false,
}
params.debug_async_explosions = {
	category = "Damage",
	value = false,
}
params.enable_damage_debug = {
	category = "Damage",
	value = false,
}
params.debug_damage_power_level = {
	category = "Damage",
	value = 500,
	options = {
		500,
		1000,
		1500,
		2000,
	},
}
params.debug_damage_calculation = {
	category = "Damage",
	value = false,
}
params.debug_pellet_damage = {
	category = "Damage",
	value = false,
}
params.debug_attack_utility = {
	category = "Damage",
	value = false,
}
params.debug_players_unkillable = {
	category = "Damage",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if Managers.state.game_session:is_server() then
			local players = Managers.player:players()

			for _, player in pairs(players) do
				if player:unit_is_alive() then
					local player_unit = player.player_unit
					local health_extension = ScriptUnit.extension(player_unit, "health_system")

					health_extension:set_unkillable(new_value)
				end
			end
		elseif DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_set_players_unkillable(channel, new_value)
		end
	end,
}
params.debug_players_invulnerable = {
	category = "Damage",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if Managers.state.game_session:is_server() then
			local players = Managers.player:players()

			for _, player in pairs(players) do
				if player:unit_is_alive() then
					local player_unit = player.player_unit
					local health_extension = ScriptUnit.extension(player_unit, "health_system")

					health_extension:set_invulnerable(new_value)
				end
			end
		elseif DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_set_players_invulnerable(channel, new_value)
		end
	end,
}
params.disable_toughness_damage = {
	category = "Damage",
	value = false,
}
params.debug_toughness = {
	category = "Damage",
	value = false,
}
params.player_weapon_instakill = {
	category = "Damage",
	value = false,
}
params.player_damage_disabled = {
	category = "Damage",
	value = false,
}
params.disable_knocked_down_damage_tick = {
	category = "Damage",
	value = false,
}
params.disable_screen_space_blood = {
	category = "Damage",
	value = false,
}
params.debug_draw_blood_decal_rotation = {
	category = "Damage",
	value = false,
}
params.disable_push_from_damage = {
	category = "Damage",
	value = false,
}
params.disable_catapult_from_damage = {
	category = "Damage",
	value = false,
}
params.enable_auto_healing = {
	category = "Damage",
	value = false,
}
params.debug_minigame = {
	category = "Minigame",
	value = false,
}
params.disable_minigame_angle_check = {
	category = "Minigame",
	value = false,
}
params.sound = {
	category = "Dialogue",
	value = false,
}
params.dialogue_all_contexts = {
	category = "Dialogue",
	value = false,
}
params.dialogue_last_played_query = {
	category = "Dialogue",
	value = false,
}
params.text_to_speech_forced = {
	category = "Dialogue",
	value = false,
}
params.text_to_speech_missing = {
	category = "Dialogue",
	value = false,
}
params.dialogue_missing_vo_trigger_error_sound = {
	category = "Dialogue",
	value = false,
}
params.dialogue_last_query = {
	category = "Dialogue",
	value = false,
}
params.dialogue_queries = {
	category = "Dialogue",
	value = false,
}
params.dialogue_debug_lookat = {
	category = "Dialogue",
	value = false,
}
params.dialogue_disable_vo = {
	category = "Dialogue",
	value = false,
}
params.dialogue_mute_vo = {
	category = "Dialogue",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("debug_mute_vo", new_value == true and "true" or "false")
		end
	end,
}
params.dialogue_display_voices_and_lines = {
	category = "Dialogue",
	value = false,
}
params.dialogue_ruledatabase_debug_all = {
	category = "Dialogue",
	value = false,
}
params.dialogue_enable_sound_event_logs = {
	category = "Dialogue",
	value = false,
}
params.dialogue_enable_voice_data_logs = {
	category = "Dialogue",
	value = false,
}
params.dialogue_enable_vo_focus_mode = {
	category = "Dialogue",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("debug_focus_vo", new_value == true and "true" or "false")
		end
	end,
}
params.dialogue_show_currently_playing_vo_info = {
	category = "Dialogue",
	value = false,
}
params.dialogue_disable_story_lines = {
	category = "Dialogue",
	value = false,
}
params.dialogue_log_enemy_vo_events = {
	category = "Dialogue",
	value = false,
}
params.dialogue_debug_story_tickers = {
	category = "Dialogue",
	value = false,
}
params.dialogue_show_assault_vo_timer = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_player_level = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_player_level_value = {
	category = "Dialogue",
	value = 1,
}
params.dialogue_skip_timediff_conditions = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_level_time_conditions = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_story_tick_start_time = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_story_tick_start_time_value = {
	category = "Dialogue",
	value = 0,
	on_value_set = function (new_value, old_value)
		local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

		if new_value ~= old_value then
			DialogueSettings.story_start_delay = new_value
		end
	end,
}
params.dialogue_override_short_story_tick_start_time = {
	category = "Dialogue",
	value = false,
}
params.dialogue_override_short_story_tick_start_time_value = {
	category = "Dialogue",
	value = 0,
	on_value_set = function (new_value, old_value)
		local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

		if new_value ~= old_value then
			DialogueSettings.story_start_delay = new_value
		end
	end,
}
params.dialogue_force_load_all_player_vo = {
	category = "Dialogue",
	value = false,
}
params.debug_equipment_component = {
	category = "Equipment",
	value = false,
}
params.debug_item_alias_fake_loading = {
	category = "Equipment",
	value = false,
}
params.character_profile_selector_slot_primary_override = {
	category = "Equipment",
	value = false,
	options_function = function ()
		local MasterItems = require("scripts/backend/master_items")
		local options = {}

		for item_name, item_data in pairs(MasterItems.get_cached()) do
			local slots = item_data.slots
			local valid_slot = slots ~= nil

			if slots then
				for ii = 1, #slots do
					local slot_name = slots[ii]

					valid_slot = slot_name == "slot_primary"

					if not valid_slot then
						valid_slot = false

						break
					end
				end
			end

			local archetypes = item_data.archetypes
			local valid_archetype = not archetypes or archetypes and not table.contains(archetypes, "npc")
			local valid_type = item_data.item_type == "WEAPON_MELEE"

			if valid_slot and valid_archetype and valid_type then
				options[#options + 1] = item_name
			end
		end

		table.sort(options)
		table.insert(options, 1, false)

		return options
	end,
}
params.character_profile_selector_slot_secondary_override = {
	category = "Equipment",
	value = false,
	options_function = function ()
		local MasterItems = require("scripts/backend/master_items")
		local options = {}

		for item_name, item_data in pairs(MasterItems.get_cached()) do
			local slots = item_data.slots
			local valid_slot = slots ~= nil

			if slots then
				for ii = 1, #slots do
					local slot_name = slots[ii]

					valid_slot = slot_name == "slot_secondary"

					if not valid_slot then
						valid_slot = false

						break
					end
				end
			end

			local archetypes = item_data.archetypes
			local valid_archetype = not archetypes or archetypes and not table.contains(archetypes, "npc")
			local valid_type = item_data.item_type == "WEAPON_RANGED"

			if valid_slot and valid_archetype and valid_type then
				options[#options + 1] = item_name
			end
		end

		table.sort(options)
		table.insert(options, 1, false)

		return options
	end,
}
params.always_trigger_stagger = {
	category = "Stagger",
	value = false,
}
params.stagger_debug_log = {
	category = "Stagger",
	value = false,
}
params.debug_herding = {
	category = "Stagger",
	value = false,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("herding_staggers")
		end
	end,
}
params.override_accumulative_stagger_multiplier = {
	category = "Stagger",
	value = false,
}
params.override_accumulative_stagger_multiplier_value = {
	category = "Stagger",
	num_decimals = 2,
	value = 1,
}
params.debug_looping_stagger = {
	category = "Stagger",
	value = false,
	on_value_set = function (new_value)
		if new_value then
			local selected_unit = Debug.selected_unit

			if selected_unit then
				local Stagger = require("scripts/utilities/attack/stagger")

				Stagger.debug_trigger_minion_stagger(selected_unit)
			end
		end
	end,
}
params.debug_stagger_length_scale = {
	category = "Stagger",
	num_decimals = 1,
	value = 1,
}
params.debug_use_stagger_keys = {
	category = "Stagger",
	value = false,
}
params.debug_stagger_direction = {
	category = "Stagger",
	value = "fwd",
	options = {
		"left",
		"right",
		"fwd",
		"bwd",
		"dwn",
	},
}
params.debug_stagger_type = {
	category = "Stagger",
	value = "heavy",
	options_function = function ()
		local StaggerSettings = require("scripts/settings/damage/stagger_settings")
		local stagger_types = StaggerSettings.stagger_types
		local options = {}

		for k, _ in pairs(stagger_types) do
			table.insert(options, k)
		end

		table.sort(options)

		return options
	end,
}
params.debug_draw_projectiles = {
	category = "Projectile",
	value = false,
}
params.debug_projectile_penetration = {
	category = "Projectile",
	value = false,
}
params.debug_draw_projectile_aiming = {
	category = "Projectile",
	value = false,
}
params.debug_projectile_husk_interpolation = {
	category = "Projectile",
	value = false,
}
params.debug_push_attacks = {
	category = "Push",
	value = false,
}
params.debug_script_components = {
	category = "Script Components",
	value = false,
}
params.script_components_print_data = {
	category = "Script Components",
	value = false,
}
params.debug_game_mode = {
	category = "Game Mode",
	value = false,
}
params.debug_state_machine = {
	category = "Game Mode",
	value = false,
}
params.debug_darkness = {
	category = "Game Mode",
	value = false,
}
params.debug_sides = {
	category = "Game Mode",
	value = false,
}
params.debug_circumstances = {
	category = "Game Mode",
	value = false,
}
params.disable_game_end_conditions = {
	category = "Game Mode",
	value = false,
}
params.debug_alternating_toxic_gas = {
	category = "Game Mode",
	value = false,
}
params.disable_achievement_backend_update = {
	category = "Achievements",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_achievement_backend_update(channel, new_value)
		end
	end,
}
params.debug_shading_environment = {
	category = "Shading Environment",
	value = false,
}
params.debug_gameplay_state = {
	category = "Gameplay State",
	value = false,
}
params.debug_spawn_queue = {
	category = "Gameplay State",
	value = false,
}
params.gameplay_timer_base_time_scale = {
	category = "Gameplay State",
	num_decimals = 2,
	value = 1,
}
params.debug_grow_queue_callstacks = {
	category = "Gameplay State",
	value = false,
}
params.debug_respawn_beacon = {
	category = "Respawn",
	value = false,
}
params.debug_player_spawn = {
	category = "Respawn",
	value = false,
}
params.disable_respawning = {
	category = "Respawn",
	value = false,
}
params.no_respawn_wait_time = {
	category = "Respawn",
	value = false,
}
params.teleport_on_spawn = {
	category = "Respawn",
	value = false,
}
params.teleport_on_spawn_location = {
	category = "Respawn",
	value = "Vector3(0,0,0)",
}
params.teleport_on_spawn_yaw_pitch_roll = {
	category = "Respawn",
	value = "Vector3(0,0,0)",
}

local function set_simulated_latency(new_value, old_value)
	if new_value ~= old_value and Managers.state.game_session then
		local latency = DevParameters.simulate_ping * 0.5

		Managers.state.game_session:set_simulated_latency(latency)
	end
end

local function set_manual_lag_compensation(new_value, old_value)
	if new_value ~= old_value and Debug then
		Debug:set_manual_lag_compensation(new_value)
	end
end

local function set_manual_lag_compensation_value(new_value, old_value)
	if new_value ~= old_value and Debug then
		Debug:set_manual_lag_compensation_value(new_value)
	end
end

local function lag_compensation_toggle_draw(new_value, old_value)
	if new_value ~= old_value and Debug then
		Debug:lag_compensation_toggle_draw(new_value)
	end
end

params.debug_connection_layer = {
	category = "Network",
	value = false,
}
params.debug_session_layer = {
	category = "Network",
	value = false,
}
params.debug_matchmaking = {
	category = "Network",
	value = false,
}
params.debug_time_since_last_transmit = {
	category = "Network",
	value = true,
}
params.visualize_input_packets_received = {
	category = "Network",
	value = false,
}
params.visualize_input_packets_with_ping = {
	category = "Network",
	value = false,
}
params.debug_adaptive_clock = {
	category = "Network",
	value = false,
}
params.disable_adaptive_clock_offset_correction = {
	category = "Network",
	value = false,
}
params.adaptive_clock_offset_correction_info_logging = {
	category = "Network",
	value = false,
}
params.debug_play_sound_on_not_received_input = {
	category = "Network",
	value = false,
}
params.log_mispredicts = {
	category = "Network",
	value = false,
}
params.mispredict_info = {
	category = "Network",
	value = false,
}
params.simulate_ping_variation = {
	category = "Network",
	num_decimals = 3,
	value = 0,
	on_value_set = set_simulated_latency,
}
params.simulate_ping = {
	category = "Network",
	num_decimals = 3,
	value = 0,
	options = {
		0,
		0.03,
		0.08,
		0.12,
		0.2,
	},
	on_value_set = set_simulated_latency,
}
params.debug_stall_game_duration = {
	category = "Network",
	num_decimals = 1,
	value = 1,
	options = {
		0.1,
		0.5,
		1,
		3,
		6,
		10,
		15,
	},
}
params.network_hash = {
	category = "Network",
	value = "",
}
params.lag_compensation_draw_enabled = {
	category = "Network",
	user_setting = false,
	value = false,
	on_value_set = lag_compensation_toggle_draw,
}
params.manual_lag_compensation = {
	category = "Network",
	user_setting = false,
	value = false,
	on_value_set = set_manual_lag_compensation,
}
params.manual_lag_compensation_value = {
	category = "Network",
	num_decimals = 3,
	value = 0,
	on_value_set = set_manual_lag_compensation_value,
}
params.packet_loss = {
	category = "Network",
	num_decimals = 3,
	value = 0,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value and Managers.state.game_session then
			Managers.state.game_session:set_simulated_packet_loss(new_value)
		end
	end,
}
params.packet_duplication = {
	category = "Network",
	num_decimals = 3,
	value = 0,
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value and Managers.state.game_session then
			Managers.state.game_session:set_simulated_packet_duplication(new_value)
		end
	end,
}

local function set_pong_timeout(new_value, old_value)
	if new_value ~= old_value then
		Network.set_pong_timeout(new_value)
	end
end

function enable_rpc_logging()
	if not DevParameters.debug_rpc_logging then
		Network.log("warnings")

		return
	end

	Log.info("Network", "enabling rpc logging")
	Network.log("messages")

	local to_ignore = {
		"rpc_player_input_array",
		"rpc_player_input_array_ack",
		"rpc_minion_anim_event",
		"rpc_player_anim_event",
		"rpc_set_allowed_nav_tag_layer",
		"rpc_add_buff",
		"rpc_minion_wield_slot",
		"rpc_hazard_prop_hot_join",
		"rpc_sync_destructible",
		"rpc_sync_anim_state",
		"rpc_interaction_set_active",
	}

	for key, value in ipairs(to_ignore) do
		Network.ignore_rpc_log(value)
	end
end

params.pong_timeout = {
	category = "Network",
	value = 10,
	on_value_set = set_pong_timeout,
}

local cached_network_functions

local function set_backend_delay(new_value)
	local Promise = require("scripts/foundation/utilities/promise")
	local has_saved_values = cached_network_functions ~= nil

	if not new_value and has_saved_values then
		Managers.backend.title_request = cached_network_functions.title_request
		Managers.backend.url_request = cached_network_functions.url_request
		cached_network_functions = nil

		return
	end

	if new_value then
		if not has_saved_values then
			cached_network_functions = {
				title_request = Managers.backend.title_request,
				url_request = Managers.backend.url_request,
			}
		end

		Managers.backend.title_request = function (...)
			local f = callback(cached_network_functions.title_request, ...)

			return Promise.delay(new_value):next(function ()
				return f()
			end)
		end

		Managers.backend.url_request = function (...)
			local f = callback(cached_network_functions.url_request, ...)

			return Promise.delay(new_value):next(function ()
				return f()
			end)
		end
	end
end

params.backend_delay = {
	category = "Network",
	value = false,
	options = {
		false,
		0.5,
		2,
		8,
	},
	on_value_set = set_backend_delay,
}
params.reliable_rpc_send_count_debug = {
	category = "Network",
	value = false,
}
params.debug_pass_EAC_check = {
	category = "Network",
	value = true,
}
params.debug_rpc_logging = {
	category = "Network",
	value = false,
	on_value_set = enable_rpc_logging,
}
params.debug_breed_resource_dependencies = {
	category = "Loading",
	value = false,
}
params.debug_loading = {
	category = "Loading",
	value = false,
}
params.debug_loading_times = {
	category = "Loading",
	value = false,
}
params.debug_package_loading = {
	category = "Loading",
	value = false,
}
params.delay_packages_on_profile_changed = {
	category = "Loading",
	num_decimals = 1,
	value = false,
	options = {
		false,
		0.1,
		0.2,
		0.5,
		1,
		2,
		4,
		8,
		16,
		32,
	},
}
params.draw_package_loading = {
	category = "Loading",
	value = false,
}
params.debug_language_override = {
	category = "Localization",
	name = "Language Override",
	value = "None",
	options_function = function ()
		local supported_languages = Managers.localization:debug_supported_languages()
		local options = table.clone(supported_languages)

		table.insert(options, 1, "None")

		return options
	end,
	on_value_set = function (new_value, old_value)
		if new_value == "None" then
			Managers.localization:debug_reset_language()
		else
			Managers.localization:debug_set_language(new_value)
		end
	end,
}
params.debug_localization_string_cache = {
	category = "Localization",
	name = "Debug String Cache",
	value = false,
}
params.volume_event_debug = {
	category = "Volume",
	value = false,
}
params.volume_trigger_debug = {
	category = "Volume",
	value = false,
}
params.debug_buff_volumes = {
	category = "Volume",
	value = false,
}
params.dev_params_gui_auto_expand_tree = {
	category = "Imgui",
	value = true,
}
params.dev_params_gui_reset_filter_on_open = {
	category = "Imgui",
	value = true,
}
params.debug_smart_targeting_template = {
	category = "Smart Targeting",
	value = false,
}
params.visualize_smart_targeting_precision_target = {
	category = "Smart Targeting",
	value = false,
}
params.visualize_smart_targeting_proximity = {
	category = "Smart Targeting",
	value = false,
}
params.debug_smart_tags = {
	category = "Smart Tagging",
	value = false,
}
params.debug_smart_tag_target_selection = {
	category = "Smart Tagging",
	value = false,
}
params.debug_smart_tag_log_events = {
	category = "Smart Tagging",
	value = true,
}
params.debug_use_local_social_backend = {
	category = "Social Features",
	value = false,
}
params.use_localized_talent_names_in_debug_menu = {
	category = "Talents",
	value = false,
}
params.debug_skip_backend_talent_verification = {
	category = "Talents",
	value = false,
}
params.testify_test_suite_id = {
	category = "Testify",
	value = false,
}
params.draw_chain_lightning_targeting = {
	category = "Chain Lightning",
	value = false,
}
params.debug_chain_lightning = {
	category = "Chain Lightning",
	value = false,
}
params.debug_draw_chain_lightning_effects = {
	category = "Chain Lightning",
	value = false,
}
params.immediate_chain_lightning_jumps = {
	category = "Chain Lightning",
	value = false,
}
params.disable_chain_lightning_effects = {
	category = "Chain Lightning",
	value = false,
}
params.debug_chain_lightning_hand_effects = {
	category = "Chain Lightning",
	value = false,
}
params.always_max_overheat = {
	category = "Weapon",
	value = false,
}
params.debug_allow_full_magazine_reload = {
	category = "Weapon",
	value = false,
}
params.debug_reload_state = {
	category = "Weapon",
	value = false,
}
params.debug_draw_hit_scan = {
	category = "Weapon",
	value = false,
}
params.debug_draw_flamer_scan = {
	category = "Weapon",
	value = false,
}
params.debug_draw_modified_hit_position = {
	category = "Weapon",
	value = false,
}
params.debug_dump_tweak_template_lerp_setup = {
	category = "Weapon",
	value = false,
}
params.debug_show_weapon_charge_level = {
	category = "Weapon",
	value = false,
}
params.debug_weapon_special = {
	category = "Weapon",
	value = false,
}
params.debug_shooting_status = {
	category = "Weapon",
	value = false,
}
params.debug_weapon_trait_templates = {
	category = "Weapon",
	value = false,
}
params.disable_overheat = {
	category = "Weapon",
	value = false,
}
params.disable_overheat_explosion = {
	category = "Weapon",
	value = false,
}
params.infinite_ammo_clip = {
	category = "Weapon",
	name = "Infinite ammo clip",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_infinite_ammo_clip(channel, new_value)
		end
	end,
}
params.infinite_ammo_reserve = {
	category = "Weapon",
	name = "Infinite ammo reserve",
	value = false,
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_infinite_ammo_reserve(channel, new_value)
		end
	end,
}
params.log_weapon_template_resource_dependencies = {
	category = "Weapon",
	value = false,
}
params.debug_alternate_fire = {
	category = "Weapon",
	value = false,
}
params.debug_looping_sound_components = {
	category = "Weapon",
	value = false,
}
params.debug_draw_damage_profile_ranges = {
	category = "Weapon",
	value = false,
}
params.debug_always_extra_grenade_throw_chance = {
	category = "Weapon",
	value = false,
}
params.debug_draw_forcesword_wind_slash_hit = {
	category = "Weapon",
	value = false,
}
params.debug_aim_assist = {
	category = "Weapon Aim Assist",
	value = false,
}
params.disable_aim_assist = {
	category = "Weapon Aim Assist",
	value = false,
}
params.enable_mouse_and_keyboard_aim_assist = {
	category = "Weapon Aim Assist",
	value = false,
}
params.visualize_aim_assist_trajectory = {
	category = "Weapon Aim Assist",
	value = false,
}
params.debug_movement_aim_assist_logging = {
	category = "Weapon Aim Assist",
	value = false,
}
params.debug_ammo_count_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_chain_weapon_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_charge_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_force_weapon_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_force_weapon_block_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_force_weapon_wind_slash_stage_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_grimoire_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_plasmagun_overheat_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_power_weapon_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_psyker_throwing_knives_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_sticky_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_sweep_trail_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_thunder_hammer_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_weapon_flashlight = {
	category = "Weapon Effects",
	value = false,
}
params.debug_weapon_temperature_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_zealot_relic_effects = {
	category = "Weapon Effects",
	value = false,
}
params.debug_recoil = {
	category = "Weapon Handling",
	value = false,
}
params.debug_spread = {
	category = "Weapon Handling",
	value = false,
}
params.debug_sway = {
	category = "Weapon Handling",
	value = false,
}
params.disable_recoil = {
	category = "Weapon Handling",
	value = false,
}
params.disable_shooting_animations = {
	category = "Weapon Handling",
	value = false,
}
params.disable_spread = {
	category = "Weapon Handling",
	value = false,
}
params.disable_sway = {
	category = "Weapon Handling",
	value = false,
}
params.weapon_traits_randomization_base = {
	category = "Weapon Traits",
	num_decimals = 3,
	value = 0.4,
}
params.weapon_traits_randomization_deviation = {
	category = "Weapon Traits",
	num_decimals = 3,
	value = 0.1,
}
params.weapon_traits_randomization_step = {
	category = "Weapon Traits",
	num_decimals = 3,
	value = 0.01,
}
params.weapon_traits_testify = {
	category = "Weapon Traits",
	value = false,
}
params.use_localized_weapon_trait_names_in_debug_menu = {
	category = "Weapon Traits",
	value = false,
}
params.weapon_mastery_use_override_xp = {
	category = "Weapon Mastery",
	value = false,
}
params.enable_mastery_debug_options = {
	category = "Weapon Mastery",
	value = true,
}
params.debug_aim_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.debug_look_delta_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.debug_move_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.disable_aim_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.disable_look_delta_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.disable_move_weapon_offset = {
	category = "Weapon Variables",
	value = false,
}
params.disable_shooting_charge_level = {
	category = "Weapon Variables",
	value = false,
}
params.alternating_critical_strikes = {
	category = "Critical Strikes",
	value = false,
}
params.always_critical_strikes = {
	category = "Critical Strikes",
	value = false,
}
params.debug_critical_strike_pseudo_random_distribution = {
	category = "Critical Strikes",
	value = false,
}
params.no_critical_strikes = {
	category = "Critical Strikes",
	value = false,
}
params.debug_critical_strike_chance = {
	category = "Critical Strikes",
	value = false,
}
params.disable_terror_events = {
	category = "Terror Event",
	value = false,
}
params.debug_terror_events = {
	category = "Terror Event",
	value = false,
}
params.debug_main_path = {
	category = "Main Path",
	value = false,
}
params.debug_main_path_spawn_points = {
	category = "Main Path",
	value = false,
}
params.debug_main_path_occluded_points = {
	category = "Main Path",
	value = false,
}
params.debug_health_station = {
	category = "Health Station",
	value = false,
}
params.debug_moods = {
	category = "Mood",
	value = false,
}
params.disable_moods = {
	category = "Mood",
	value = false,
}
params.mood_override = {
	category = "Mood",
	value = false,
	options_function = function ()
		local MoodSettings = require("scripts/settings/camera/mood/mood_settings")
		local mood_types = MoodSettings.mood_types
		local options = {}

		for mood_type, _ in pairs(mood_types) do
			options[#options + 1] = mood_type
		end

		table.sort(options)
		table.insert(options, 1, false)

		return options
	end,
}
params.disable_impact_vfx = {
	category = "Damage Interface",
	value = false,
}
params.disable_toughness_effects = {
	category = "Damage Interface",
	value = false,
}
params.impact_fx_override = {
	category = "Damage Interface",
	value = false,
	options_function = function ()
		local ArmorSettings = require("scripts/settings/damage/armor_settings")
		local armor_hit_types = ArmorSettings.hit_types
		local options = {}

		for hit_type, _ in pairs(armor_hit_types) do
			options[#options + 1] = hit_type
		end

		table.sort(options)
		table.insert(options, 1, false)

		return options
	end,
}
params.surface_effect_material_override = {
	category = "Damage Interface",
	value = false,
	options_function = function ()
		local MaterialQuerySettings = require("scripts/settings/material_query_settings")
		local surface_materials = MaterialQuerySettings.surface_materials
		local options = {
			false,
		}

		for _, material in ipairs(surface_materials) do
			options[#options + 1] = material
		end

		return options
	end,
}
params.debug_draw_missing_surface_materials = {
	category = "Damage Interface",
	value = true,
}
params.debug_draw_shotshell_impacts = {
	category = "Damage Interface",
	value = false,
}
params.debug_draw_impact_fx = {
	category = "Damage Interface",
	value = false,
}
params.debug_draw_impact_vfx_rotation = {
	category = "Damage Interface",
	value = false,
}
params.debug_draw_shield_impact_fx_offset = {
	category = "Damage Interface",
	value = false,
}
params.print_missing_impact_fx_definitions = {
	category = "Damage Interface",
	value = false,
}
params.debug_forced_damage_efficiency = {
	category = "Damage Interface",
	user_setting = false,
	value = "none",
	options_function = function ()
		local AttackSettings = require("scripts/settings/damage/attack_settings")
		local damage_efficiencies = AttackSettings.damage_efficiencies
		local options = {
			"none",
		}

		for damage_efficiency, _ in pairs(damage_efficiencies) do
			options[#options + 1] = damage_efficiency
		end

		return options
	end,
}
params.debug_physics_proximity_system = {
	category = "PhysicsProximitySystem",
	user_setting = false,
	value = false,
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_enabled(new_value)
	end,
}
params.debug_physics_proximity_system_afros = {
	category = "PhysicsProximitySystem",
	user_setting = false,
	value = false,
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_afros(new_value)
	end,
}
params.debug_physics_proximity_system_observers = {
	category = "PhysicsProximitySystem",
	user_setting = false,
	value = false,
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_observers(new_value)
	end,
}
params.debug_physics_proximity_system_actors = {
	category = "PhysicsProximitySystem",
	user_setting = false,
	value = false,
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_actors(new_value)
	end,
}
params.debug_physics_proximity_system_time_verification = {
	category = "PhysicsProximitySystem",
	user_setting = false,
	value = false,
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_time_verification(new_value)
	end,
}
params.debug_side_proximity = {
	category = "ProximitySystem",
	value = false,
}
params.debug_proximity_system = {
	category = "ProximitySystem",
	value = false,
}
params.debug_has_been_seen = {
	category = "LegacyV2ProximitySystem",
	value = false,
}
params.debug_proximity_fx = {
	category = "LegacyV2ProximitySystem",
	value = false,
}
params.max_allowed_proximity_fx = {
	category = "LegacyV2ProximitySystem",
	value = false,
	options = {
		false,
		8,
		16,
		32,
		64,
	},
}
params.override_proximity_fx = {
	category = "LegacyV2ProximitySystem",
	value = false,
	options = {
		false,
		"always_enabled",
		"always_disabled",
	},
}
params.debug_fov = {
	category = "Camera",
	value = false,
}
params.camera_manager_debug = {
	category = "Camera",
	value = false,
}
params.camera_tree_debug = {
	category = "Camera",
	value = false,
}
params.force_spectate = {
	category = "Camera",
	value = false,
}
params.use_far_third_person_camera = {
	category = "Camera",
	value = false,
}
params.override_1p_camera_movement_offset = {
	category = "Camera",
	value = false,
}
params.override_1p_camera_movement_offset_lerp = {
	category = "Camera",
	num_decimals = 2,
	value = 1,
}
params.disable_player_hit_reaction = {
	category = "Camera",
	value = false,
}
params.external_fov_multiplier = {
	category = "Camera",
	num_decimals = 2,
	value = 1,
	on_value_set = function (new_value, old_value)
		Managers.state.camera:set_variable("player1", "external_fov_multiplier", new_value)
	end,
}
params.free_flight_follow_path_speed = {
	category = "Free Flight",
	num_decimals = 1,
	value = 7.4,
	on_value_set = function (new_value, old_value)
		local free_flight_manager = Managers.free_flight

		if free_flight_manager then
			free_flight_manager:set_follow_path_speed(new_value)
		end
	end,
}
params.debug_network_story = {
	category = "Stories",
	value = false,
}
params.debug_cinematics = {
	category = "Stories",
	value = false,
}
params.debug_cinematics_verbose = {
	category = "Stories",
	value = false,
}
params.debug_skip_cinematics = {
	category = "Stories",
	value = false,
}
params.debug_cinematic_scene = {
	category = "Stories",
	value = false,
}
params.debug_cinematic_fast_track_enable = {
	category = "Stories",
	value = false,
}
params.debug_show_dof_info = {
	category = "Stories",
	value = false,
}
params.debug_dof_override = {
	category = "Stories",
	value = false,
}
params.debug_dof_enabled = {
	category = "Stories",
	num_decimals = 5,
	value = 1,
}
params.debug_focal_distance = {
	category = "Stories",
	num_decimals = 5,
	value = 1,
}
params.debug_focal_region = {
	category = "Stories",
	num_decimals = 5,
	value = 1,
}
params.debug_focal_padding = {
	category = "Stories",
	num_decimals = 5,
	value = 1,
}
params.debug_focal_scale = {
	category = "Stories",
	num_decimals = 5,
	value = 1,
}
params.force_hub_location_intros = {
	category = "Stories",
	name = "Always show hub location introductions (hli)",
	value = false,
}
params.skip_prologue = {
	category = "Game Flow",
	value = BUILD ~= "release",
}
params.debug_ledge_finder_rays = {
	category = "Ledge Finder",
	value = false,
}
params.debug_ledge_finder_real_pos_rays = {
	category = "Ledge Finder",
	value = false,
}
params.debug_ledge_finder_angle_verification = {
	category = "Ledge Finder",
	value = false,
}
params.debug_visualize_ledge_finder_ledges = {
	category = "Ledge Finder",
	value = false,
}
params.debug_draw_ledge_finder_oobb_sweep = {
	category = "Ledge Finder",
	value = false,
}
params.debug_use_local_mission_board = {
	category = "Level & Mission",
	value = false,
}
params.debug_light_controllers = {
	category = "Level & Mission",
	value = false,
}
params.debug_weather_vfx = {
	category = "Level & Mission",
	value = false,
}
params.debug_world_interaction = {
	category = "Level & Mission",
	value = false,
}
params.debug_reportify = {
	category = "Level & Mission",
	value = false,
}
params.debug_liquid_area = {
	category = "Liquid Area",
	value = false,
	options = {
		false,
		"area",
		"area_and_neighbors",
	},
}
params.debug_liquid_area_paint_template = {
	category = "Liquid Area",
	value = "debug_paint",
	options_function = function ()
		local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")

		return table.keys(LiquidAreaTemplates)
	end,
}

local function _set_max_external_time_step(new_value, old_value)
	if new_value == "Default" then
		local game_time_step_policy = GameParameters.time_step_policy
		local base_index = table.find(game_time_step_policy, "external_step_range")
		local min_value = game_time_step_policy[base_index + 1]
		local max_value = game_time_step_policy[base_index + 2]

		Application.set_time_step_policy("external_step_range", min_value, max_value)
	else
		Application.set_time_step_policy("external_step_range", 0, new_value)
	end
end

params.coherency_show_self_coherency = {
	category = "Coherency",
	value = false,
}
params.coherency_show_other_coherency = {
	category = "Coherency",
	value = false,
}
params.coherency_log_coherency_events = {
	category = "Coherency",
	value = false,
}
params.disable_coherency_toughness_effect = {
	category = "Coherency",
	value = false,
}
params.premium_store_custom_time = {
	category = "Micro Transaction (\"Premium\") Store",
	hidden = true,
	value = 0,
}
params.unlock_all_shooting_range_enemies = {
	category = "Shooting Range",
	value = false,
}
params.trace_rumble_activation_events = {
	category = "Rumble",
	value = false,
}
params.category_log_levels = {
	hidden = true,
	value = {
		"Log Internal",
		2,
	},
}
params.max_external_time_step = {
	num_decimals = 1,
	value = "Default",
	options = {
		"Default",
		0.2,
		2,
		20,
	},
	on_value_set = _set_max_external_time_step,
}
params.debug_position_lookup = {
	value = false,
}
params.stall_warnings_enabled = {
	value = true,
	on_value_set = function (new_value, old_value)
		Application.set_stall_warnings_enabled(new_value)
	end,
}
params.disable_fade_system = {
	value = false,
}
params.debug_material_queries = {
	value = false,
	options = {
		false,
		"both",
		"succeeded",
		"failed",
	},
}
params.debug_draw_footstep_decals = {
	value = false,
}
params.networked_flow_state = {
	value = false,
}
params.debug_print_world_text = {
	value = true,
}
params.debug_join_hub_server = {
	value = false,
}
params.debug_local_test_hub_server = {
	value = false,
}
params.longer_psyker_force_field_duration = {
	value = false,
}
params.show_equipped_items = {
	value = false,
}
params.debug_gadget_extension = {
	value = false,
}
params.disable_beast_of_nurgle_consumed_effect = {
	value = false,
}

local function _set_build_override_parameter(parameter_name, value)
	local old_value = params[parameter_name].value

	params[parameter_name].value = value
end

_set_build_override_parameter("debug_change_time_scale", false)

return {
	enable_filter_by_defaults = true,
	parameters = params,
	categories = categories,
}
