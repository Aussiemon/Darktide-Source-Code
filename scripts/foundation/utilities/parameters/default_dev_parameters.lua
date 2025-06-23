-- chunkname: @scripts/foundation/utilities/parameters/default_dev_parameters.lua

local categories = {
	"Abilities",
	"Achievements",
	"Action Input",
	"Action",
	"Animation",
	"Auspex",
	"Backend",
	"Behavior_tree",
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
	"Companion",
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
	"Explosion Rework Testing",
	"Event",
	"Feature Info",
	"FGRL",
	"Force Field",
	"Framerate",
	"Free Flight",
	"Game Flow",
	"Game Mode",
	"Gameplay State",
	"Garbage Detection",
	"Groups",
	"Health Station",
	"Hit Mass",
	"Horde Picker",
	"Hordes",
	"Hordes Mode",
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
	"Rumble & Haptics",
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
	"Wwise"
}

local function hang_ledge_toggle_draw(new_value, old_value)
	if new_value ~= old_value and Debug then
		Debug:hang_ledge_toggle_draw(new_value)
	end
end

local params = {}

params.replace_input_settings_with_dev_parameters = {
	value = false,
	category = "Input"
}
params.controller_selection = {
	value = "latest",
	category = "Input",
	options = {
		"latest",
		"fixed",
		"combined"
	},
	on_value_set = function (new_value, old_value)
		Managers.input:set_selection_logic(new_value)
	end
}
params.fixed_controller_type = {
	value = "keyboard",
	category = "Input",
	options = {
		"keyboard",
		"xbox_controller",
		"ps4_controller"
	},
	on_value_set = function (new_value, old_value)
		Managers.input:set_selection_logic(nil, new_value)
	end
}
params.override_last_pressed_device_on_start = {
	value = false,
	category = "Input",
	options = {
		"keyboard",
		"mouse",
		"xbox_controller",
		"ps4_controller"
	}
}
params.debug_input_last_action_track_time = {
	value = 1,
	category = "Input"
}
params.debug_track_only_used_actions = {
	value = true,
	category = "Input"
}
params.grab_mouse = {
	value = true,
	category = "Input"
}
params.disable_debug_hotkeys = {
	value = false,
	category = "Input"
}
params.controller_look_scale = {
	value = 1,
	category = "Input"
}
params.controller_look_scale_ranged = {
	value = 1,
	category = "Input"
}
params.controller_look_scale_ranged_alternate_fire = {
	value = 1,
	category = "Input"
}
params.controller_invert_look_y = {
	value = false,
	category = "Input"
}
params.controller_look_dead_zone = {
	value = 0.1,
	category = "Input"
}
params.controller_enable_acceleration = {
	value = true,
	category = "Input"
}
params.show_mouse_input_filter = {
	value = false,
	category = "Input"
}
params.show_gamepad_input_filter = {
	value = false,
	category = "Input"
}
params.show_sensitivity_modifier = {
	value = false,
	category = "Input"
}
params.debug_visualize_look_raw_controller = {
	value = false,
	category = "Input"
}
params.debug_input_filter_response_curves = {
	value = false,
	category = "Input"
}
params.preview_action_input_hierarchy = {
	value = false,
	category = "Input"
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
	"content/ui/fonts/machine_medium"
}

table.array_remove_if(_debug_text_font_options, function (font)
	return not Application.can_get_resource("slug", font)
end)

params.debug_text_enable = {
	value = true,
	category = "Debug Print"
}
params.debug_text_x_offset = {
	value = 10,
	category = "Debug Print"
}
params.debug_text_y_offset = {
	value = 0,
	category = "Debug Print"
}
params.debug_text_layer = {
	value = 900,
	category = "Debug Print"
}
params.debug_text_font_size = {
	value = 20,
	category = "Debug Print"
}
params.debug_text_color = {
	value = "cheeseburger",
	category = "Debug Print",
	options_function = _debug_text_color_options
}
params.debug_text_font = {
	category = "Debug Print",
	value = _debug_text_font_options[1],
	options = _debug_text_font_options
}
params.debug_auspex_scanning = {
	value = false,
	category = "Auspex"
}
params.debug_prevent_forced_dequip_of_auspex = {
	value = false,
	category = "Auspex"
}
params.debug_breed_picker_selected_name = {
	value = "",
	hidden = true,
	category = "Breed Picker"
}
params.debug_breed_picker_x_offset = {
	value = 5,
	category = "Breed Picker"
}
params.debug_breed_picker_y_offset = {
	value = 80,
	category = "Breed Picker"
}
params.debug_breed_picker_layer = {
	value = 910,
	category = "Breed Picker"
}
params.debug_breed_picker_font_size = {
	value = 22,
	category = "Breed Picker"
}
params.auto_select_debug_spawned_unit = {
	value = false,
	category = "Breed Picker"
}
params.debug_spawn_multiple_amount = {
	value = 25,
	category = "Breed Picker",
	options = {
		9,
		25,
		49,
		81,
		100,
		196
	}
}
params.perform_backend_version_check = {
	value = true,
	category = "Backend"
}
params.allow_backend_game_param_overrides = {
	value = false,
	category = "Backend"
}
params.crash_on_account_login_error = {
	value = false,
	category = "Backend"
}
params.enable_stat_reporting = {
	value = true,
	category = "Backend"
}
params.enable_contracts = {
	value = true,
	category = "Backend"
}
params.enable_commendations = {
	value = true,
	category = "Backend"
}
params.backend_debug_log = {
	value = false,
	category = "Backend"
}
params.debug_verify_gear_cache = {
	value = false,
	category = "Backend"
}
params.debug_log_data_service_backend_cache = {
	value = false,
	category = "Backend"
}
params.auto_select_backend_environment = {
	value = false,
	category = "Backend",
	options = {
		false,
		"staging",
		"dev"
	}
}
params.backend_telemetry_enable = {
	value = false,
	category = "Backend"
}
params.backend_telemetry_debug = {
	value = false,
	category = "Backend"
}
params.backend_telemetry_service_url = {
	value = "https://telemetry.fatsharkgames.com/events",
	category = "Backend"
}
params.verbose_chat_log = {
	value = false,
	category = "Chat"
}
params.disable_chat = {
	value = false,
	category = "Chat"
}
params.debug_template_effects = {
	value = false,
	category = "Effects"
}
params.debug_companion_dog_effects = {
	value = false,
	category = "Effects"
}
params.debug_draw_cultist_ritualist_chanting_effects = {
	value = false,
	category = "Effects"
}
params.debug_draw_shock_mine_link_effects = {
	value = false,
	category = "Effects"
}
params.log_resolve_particle_effect_fallback = {
	value = false,
	category = "Effects",
	options = {
		false,
		"all",
		"debug"
	}
}
params.debug_use_dev_error_levels = {
	value = true,
	category = "Error"
}
params.show_ingame_fps = {
	value = "simple",
	category = "Framerate",
	options = {
		false,
		"simple",
		"detailed",
		"graph"
	}
}
params.aggregate_fps_period = {
	value = 1,
	num_decimals = 2,
	category = "Framerate"
}
params.low_fps_threshold = {
	value = 30,
	category = "Framerate"
}
params.medium_fps_threshold = {
	value = 60,
	category = "Framerate"
}
params.throttle_fps = {
	value = 0,
	user_setting = false,
	category = "Framerate",
	on_value_set = function (new_value, old_value)
		Application.set_time_step_policy("throttle", new_value)
	end
}
params.debug_pickup_picker_selected_name = {
	value = "",
	hidden = true,
	category = "Pickup Picker"
}
params.debug_pickup_picker_x_offset = {
	value = 5,
	category = "Pickup Picker"
}
params.debug_pickup_picker_y_offset = {
	value = 80,
	category = "Pickup Picker"
}
params.debug_pickup_picker_layer = {
	value = 910,
	category = "Pickup Picker"
}
params.debug_pickup_picker_font_size = {
	value = 22,
	category = "Pickup Picker"
}
params.debug_hit_mass = {
	value = false,
	category = "Hit Mass"
}
params.debug_hit_mass_calculations = {
	value = false,
	category = "Hit Mass"
}
params.debug_lunge_hit_mass = {
	value = false,
	category = "Hit Mass"
}
params.debug_print_wwise_hit_mass = {
	value = false,
	category = "Hit Mass"
}
params.debug_horde_picker_selected_name = {
	value = "",
	hidden = true,
	category = "Horde Picker"
}
params.debug_horde_picker_x_offset = {
	value = 5,
	category = "Horde Picker"
}
params.debug_horde_picker_y_offset = {
	value = 80,
	category = "Horde Picker"
}
params.debug_horde_picker_layer = {
	value = 910,
	category = "Horde Picker"
}
params.debug_horde_picker_font_size = {
	value = 22,
	category = "Horde Picker"
}
params.debug_pickup_spawners = {
	value = false,
	category = "Pickups"
}
params.debug_pickup_rubberband = {
	value = false,
	category = "Pickups"
}
params.show_spawned_pickups = {
	value = false,
	category = "Pickups"
}
params.show_spawned_pickups_location = {
	value = false,
	category = "Pickups"
}
params.debug_fill_pickup_spawners = {
	value = false,
	category = "Pickups",
	options = {
		false,
		"all",
		"distributed",
		"side_mission"
	}
}
params.debug_proximity_heal = {
	value = false,
	category = "Pickups"
}
params.debug_proximity_shock = {
	value = false,
	category = "Pickups"
}
params.debug_projectile_aim = {
	value = false,
	category = "Projectile Locomotion"
}
params.projectile_aim_disable_aim_offset = {
	value = false,
	category = "Projectile Locomotion"
}
params.projectile_aim_disable_fx_spawner_offset = {
	value = false,
	category = "Projectile Locomotion"
}
params.projectile_aim_disable_sway_recoil = {
	value = false,
	category = "Projectile Locomotion"
}
params.projectile_aim_time_step_multiplier = {
	value = 1,
	category = "Projectile Locomotion"
}
params.projectile_aim_max_steps = {
	value = 500,
	category = "Projectile Locomotion"
}
params.projectile_aim_max_number_of_bounces = {
	value = 10,
	category = "Projectile Locomotion"
}
params.disable_projectile_collision = {
	value = false,
	category = "Projectile Locomotion"
}
params.debug_projectile_locomotion_aiming = {
	value = false,
	category = "Projectile Locomotion"
}
params.visualize_projectile_locomotion = {
	value = false,
	category = "Projectile Locomotion"
}
params.debug_destructibles = {
	value = false,
	category = "Destructibles"
}
params.debug_destructible_collectibles = {
	value = false,
	category = "Destructibles"
}
params.dont_randomize_destructibles = {
	value = false,
	category = "Destructibles"
}

local function _split_filter_string(filters_string)
	local seperator = "%s"

	return string.split(filters_string, seperator)
end

local function _generate_filter_string(filters)
	local filter_string = ""

	for _, filter in ipairs(filters) do
		filter_string = filter_string .. " " .. filter
	end

	return #filter_string > 0 and string.trim(filter_string) or filter_string
end

local function _toggle_physics_filter(new_filter)
	local current_active_filters_string = DevParameters.physics_debug_multiple_active_filters_string
	local filters = _split_filter_string(current_active_filters_string)
	local existing_filter_index = -1

	for index, filter in ipairs(filters) do
		if filter == new_filter then
			existing_filter_index = index
		end
	end

	if existing_filter_index > 0 then
		table.remove(filters, existing_filter_index)
	else
		table.insert(filters, new_filter)
	end

	local new_filter_string = _generate_filter_string(filters)

	ParameterResolver.set_dev_parameter("physics_debug_multiple_active_filters_string", new_filter_string)
	ParameterResolver.set_dev_parameter("physics_debug_filters_active", "ACTIVE FILTERS: " .. #filters)
end

params.physics_debug = {
	value = false,
	category = "Physics"
}
params.physics_debug_highlight_awake = {
	value = false,
	category = "Physics"
}
params.physics_debug_type = {
	value = "both",
	category = "Physics",
	options = {
		"statics",
		"dynamics",
		"both"
	}
}
params.physics_debug_filter = {
	value = "filter_all",
	category = "Physics",
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
		"filter_minion_explosion",
		"filter_player_character_melee_sweep",
		"filter_player_character_ballistic_raycast",
		"filter_player_character_explosion",
		"filter_player_character_shooting_projectile",
		"filter_player_character_shooting_raycast",
		"filter_player_character_shooting_raycast_dynamics",
		"filter_player_character_shooting_raycast_statics",
		"filter_player_character_throwing",
		"filter_player_mover",
		"filter_player_ping_target_selection",
		"filter_ray_aim_assist",
		"filter_simple_geometry"
	},
	on_value_set = function (new_value, old_value)
		local is_multiple_filters_allowed = DevParameters.physics_debug_allow_multiple_filters

		if is_multiple_filters_allowed then
			_toggle_physics_filter(new_value)
		end
	end
}
params.physics_debug_range = {
	value = 30,
	category = "Physics"
}
params.physics_debug_color = {
	value = "red",
	category = "Physics",
	options_function = function ()
		return Color.short_list
	end
}
params.physics_debug_only_draw_selected_unit = {
	value = false,
	category = "Physics"
}
params.physics_debug_draw_no_depth = {
	value = false,
	category = "Physics"
}
params.physics_debug_allow_multiple_filters = {
	value = false,
	category = "Physics"
}
params.physics_debug_filters_active = {
	value = "ACTIVE FILTERS",
	readonly = false,
	category = "Physics",
	hidden = false,
	dynamic_contents = true,
	options_function = function ()
		local current_active_filters_string = DevParameters.physics_debug_multiple_active_filters_string

		return _split_filter_string(current_active_filters_string)
	end,
	options_texts_function = function ()
		local current_active_filters_string = DevParameters.physics_debug_multiple_active_filters_string

		return _split_filter_string(current_active_filters_string)
	end,
	on_value_set = function (new_value, old_value)
		_toggle_physics_filter(new_value)
	end
}
params.physics_debug_multiple_active_filters_string = {
	value = "",
	readonly = false,
	hidden = true,
	category = "Physics"
}
params.disable_self_assist = {
	value = true,
	category = "Player Character"
}
params.allow_character_input_in_free_flight = {
	value = false,
	name = "allow_character_input_in_free_flight, Keybind: L-CTRL + SPACE",
	category = "Player Character"
}
params.box_minion_collision = {
	value = false,
	category = "Player Character"
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
		local options = {
			false,
			"Backend Profile"
		}

		if Managers.backend:authenticated() then
			Managers.data_service.profiles:fetch_all_backend_profiles():next(function (profile_data)
				local profiles = profile_data.profiles

				if profiles then
					for ii = 1, #profiles do
						local profile = profiles[ii]

						if profile then
							local character_id = profile.character_id

							table.insert(options, 3, character_id)
						end
					end
				end

				if profile_data.selected_profile then
					_character_profile_selector_preview_value = profile_data.selected_profile.character_id
				end
			end):catch(function ()
				return
			end)
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
		local options_texts = {
			"false",
			"Backend Profile"
		}

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

							table.insert(options_texts, 3, option_text)
						end
					end
				end
			end)
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
			_character_profile_selector_preview_value = new_value

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
	end
}
params.debug_character_interpolated_fixed_frame_movement = {
	value = false,
	category = "Player Character"
}
params.debug_character_ledge_hanging = {
	value = false,
	category = "Player Character"
}
params.debug_character_state_machine = {
	value = false,
	category = "Player Character"
}
params.debug_fixed_frame_update = {
	value = false,
	category = "Player Character"
}
params.debug_interaction = {
	value = false,
	category = "Player Character"
}
params.print_interaction_types = {
	value = false,
	category = "Player Character"
}
params.debug_ladder_movement = {
	value = false,
	category = "Player Character"
}
params.debug_ledge_step_up = {
	value = false,
	category = "Player Character"
}
params.debug_lunging = {
	value = false,
	category = "Player Character",
	on_value_set = function ()
		local debug_drawer = Debug:drawer("character_state_lunging")

		debug_drawer:reset()
	end
}
params.override_player_profile_current_level = {
	value = false,
	category = "Player Character",
	options_function = function ()
		local ExperienceSettings = require("scripts/settings/experience_settings")
		local options = {
			false
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
	end
}
params.debug_netted_rotation = {
	value = false,
	category = "Player Character"
}
params.debug_player_fx = {
	value = false,
	category = "Player Character"
}
params.debug_player_gear_fx = {
	value = false,
	category = "Player Character"
}
params.debug_player_suppression = {
	value = false,
	category = "Player Character"
}
params.disable_player_suppression = {
	value = false,
	category = "Player Character"
}
params.debug_player_unit_data_sync = {
	value = false,
	category = "Player Character"
}
params.debug_step_up = {
	value = false,
	category = "Player Character"
}
params.disable_player_catapulting = {
	value = false,
	category = "Player Character"
}
params.disable_warp_charge = {
	value = false,
	category = "Player Character"
}
params.disable_warp_charge_passive_dissipating = {
	value = false,
	category = "Player Character"
}
params.disable_warp_charge_explosion = {
	value = false,
	category = "Player Character"
}
params.always_max_warp_charge = {
	value = false,
	category = "Player Character"
}
params.debug_draw_ledge_hanging_ik = {
	value = false,
	category = "Player Character"
}
params.disable_ledge_hanging_ik = {
	value = false,
	category = "Player Character"
}
params.hang_ledge_draw_enabled = {
	value = false,
	category = "Player Character",
	on_value_set = hang_ledge_toggle_draw
}
params.infinite_ledge_hanging = {
	value = false,
	category = "Player Character"
}
params.override_ledge_hanging_time = {
	value = false,
	category = "Player Character",
	options = {
		false,
		5,
		10,
		15,
		20,
		25,
		30
	}
}
params.infinite_stamina = {
	value = false,
	category = "Player Character"
}
params.debug_stamina = {
	value = false,
	category = "Player Character"
}
params.player_render_frame_position = {
	value = "interpolate",
	category = "Player Character",
	options = {
		"interpolate",
		"extrapolate",
		"raw"
	}
}
params.print_debugged_player_data_fields = {
	value = false,
	category = "Player Character"
}
params.print_player_unit_data = {
	value = false,
	category = "Player Character"
}
params.print_player_unit_data_debug_vertically = {
	value = true,
	category = "Player Character"
}
params.print_player_unit_data_lookups = {
	value = false,
	category = "Player Character"
}
params.use_super_jumps = {
	value = false,
	category = "Player Character"
}
params.use_testify_profiles = {
	value = false,
	category = "Player Character"
}
params.force_third_person_mode = {
	value = false,
	category = "Player Character",
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
	end
}
params.force_third_person_hub_camera_use = {
	value = false,
	category = "Player Character",
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
	end
}
params.debug_player_slots = {
	value = false,
	category = "Player Character"
}
params.debug_sliding_character_state = {
	value = false,
	category = "Player Character"
}
params.debug_likely_stuck = {
	value = false,
	category = "Player Character"
}
params.disable_likely_stuck_implementation = {
	value = false,
	category = "Player Character"
}
params.debug_push_velocity = {
	value = false,
	category = "Player Character"
}
params.add_constant_push = {
	value = false,
	category = "Player Character"
}
params.enable_player_character_scale_overrides = {
	value = false,
	category = "Player Character"
}
params.player_character_first_person_scale_override = {
	value = 1,
	category = "Player Character",
	num_decimals = 3
}
params.player_character_third_person_scale_override = {
	value = 1,
	category = "Player Character",
	num_decimals = 3
}
params.disable_last_man_standing_wwise_state = {
	value = false,
	category = "Wwise States"
}
params.debug_wwise_states = {
	value = false,
	category = "Wwise States"
}
params.debug_wwise_state_groups = {
	value = false,
	category = "Wwise States"
}
params.debug_wwise_states_override = {
	value = false,
	category = "Wwise States"
}
params.debug_wwise_states_override_a_game = {
	value = "None",
	category = "Wwise States",
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
		"victory"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_game_state", new_value)
	end
}
params.debug_wwise_states_override_b_zone = {
	value = "None",
	category = "Wwise States",
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
		"zone_7"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_zone", new_value)
	end
}
params.debug_wwise_states_override_c_combat = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"normal",
		"boss",
		"horde"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_combat", new_value)
	end
}
params.debug_wwise_states_override_d_objective = {
	value = "None",
	category = "Wwise States",
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
		"vip_mission"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_objective", new_value)
	end
}
params.debug_wwise_states_override_e_objective_progression = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"one",
		"two",
		"three"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_objective_progression", new_value)
	end
}
params.debug_wwise_states_override_f_circumstance = {
	value = "None",
	category = "Wwise States",
	options = {
		"None"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("music_circumstance", new_value)
	end
}
params.debug_wwise_states_override_g_event_type = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"mid_event",
		"end_event"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("event_category", new_value)
	end
}
params.debug_wwise_states_override_h_combat_effects = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"normal",
		"monster",
		"horde"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("minion_aggro_intensity", new_value)
	end
}
params.debug_wwise_states_override_i_options = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"ingame_menu",
		"vendor_menu"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("options", new_value)
	end
}
params.debug_wwise_states_override_j_event_intensity = {
	value = "None",
	category = "Wwise States",
	options = {
		"None",
		"low",
		"high"
	},
	on_value_set = function (new_value, old_value)
		Managers.wwise_game_sync:debug_set_override_state("event_intensity", new_value)
	end
}
params.no_ability_cooldowns = {
	value = false,
	category = "Abilities",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_no_ability_cooldowns(channel, new_value)
		end
	end
}
params.short_ability_cooldowns = {
	value = false,
	category = "Abilities",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_short_ability_cooldowns(channel, new_value)
		end
	end
}
params.debug_smoke_fog = {
	value = false,
	category = "Abilities"
}
params.show_ability_cooldowns = {
	value = false,
	category = "Abilities"
}
params.debug_bots = {
	value = false,
	category = "Bot Character"
}
params.debug_bots_aoe_threat = {
	value = false,
	category = "Bot Character"
}
params.debug_bots_order = {
	value = false,
	category = "Bot Character"
}
params.debug_bot_input = {
	value = false,
	category = "Bot Character"
}
params.debug_bots_weapon = {
	value = false,
	category = "Bot Character"
}
params.debug_selected_bot_target_selection = {
	value = false,
	category = "Bot Character"
}
params.disable_bot_follow = {
	value = false,
	category = "Bot Character"
}
params.disable_bot_abilities = {
	value = false,
	category = "Bot Character"
}
params.debug_bot_action_input = {
	value = false,
	category = "Bot Character"
}
params.max_bots = {
	value = "default",
	category = "Bot Character",
	options = {
		"default",
		0,
		1,
		2,
		3
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
	end
}
params.bots_enabled = {
	value = true,
	category = "Bot Character",
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
	end
}
params.debug_buffs = {
	value = false,
	category = "Buffs"
}
params.debug_buffs_hide_predicted = {
	value = false,
	category = "Buffs"
}
params.debug_buffs_hide_non_predicted = {
	value = false,
	category = "Buffs"
}
params.debug_buffs_show_categories = {
	value = "all",
	category = "Buffs",
	options = {
		"all",
		"generic",
		"talents",
		"weapon_traits",
		"talents_secondary",
		"gadget",
		"hordes_buff",
		"hordes_sub_buff",
		"aura"
	}
}
params.debug_meta_buffs = {
	value = false,
	category = "Buffs"
}
params.debug_minion_buff_fx = {
	value = false,
	category = "Buffs"
}
params.debug_boons = {
	value = false,
	category = "Buffs"
}
params.disable_buff_screen_space_effects = {
	value = false,
	category = "Buffs"
}
params.debug_perception = {
	value = false,
	category = "Perception",
	options = {
		false,
		"minions",
		"bots",
		"both"
	}
}
params.disable_companion_perception = {
	value = false,
	name = "disable_companion_perception, Keybind: R-SHIFT + Z",
	category = "Perception",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_companion_perception(channel, new_value)
		end
	end
}
params.disable_minion_perception = {
	value = false,
	name = "disable_minion_perception, Keybind: L-SHIFT + Z",
	category = "Perception",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_minion_perception(channel, new_value)
		end
	end
}
params.ignore_players_as_targets = {
	value = false,
	category = "Perception"
}
params.debug_selected_minion_target_selection_weights = {
	value = false,
	category = "Perception"
}
params.debug_selected_unit_threat = {
	value = false,
	category = "Perception"
}
params.print_current_node_for_selected = {
	value = false,
	category = "Behavior_tree"
}
params.debug_blackboards = {
	value = false,
	category = "Blackboard"
}
params.debug_wwise_elevation = {
	value = false,
	category = "Wwise"
}
params.debug_sound_environments = {
	value = false,
	name = "Sound environment",
	category = "Wwise"
}
params.use_gameplay_sound_indicators = {
	value = false,
	category = "Wwise",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("sound_option_gameplay_indicators", new_value == true and "true" or "false")
		end
	end
}
params.use_bass_boost = {
	value = 0,
	num_decimals = 2,
	category = "Wwise",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			local world = Application.main_world()
			local wwise_world = Wwise.wwise_world(world)

			WwiseWorld.set_global_parameter(wwise_world, "sound_option_bass_boost", new_value)
		end
	end
}
params.debug_draw_closest_point_on_line_sounds = {
	value = false,
	category = "Wwise"
}
params.debug_draw_moving_line_sfx = {
	value = false,
	category = "Wwise"
}
params.debug_draw_moving_line_vfx = {
	value = false,
	category = "Wwise"
}
params.debug_print_portal = {
	value = false,
	category = "Wwise"
}
params.debug_player_wwise_state = {
	value = false,
	category = "Wwise"
}
params.disable_lua_sound_reflection = {
	value = false,
	category = "Wwise"
}
params.debug_lua_sound_reflection = {
	value = false,
	category = "Wwise"
}
params.always_play_husk_effects = {
	value = false,
	category = "Wwise"
}
params.debug_wwise_timestamp = {
	value = false,
	category = "Wwise"
}
params.log_resolve_sound_fallback = {
	value = false,
	category = "Wwise",
	options = {
		false,
		"all",
		"debug"
	}
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
	value = false,
	category = "Event"
}
params.debug_failed_pathing = {
	value = false,
	category = "Navigation"
}
params.debug_ai_movement = {
	value = false,
	category = "Navigation",
	options = {
		false,
		"graphics_only",
		"text_and_graphics"
	}
}
params.nav_mesh_debug = {
	value = false,
	category = "Navigation",
	options = {
		false,
		"without_nav_graphs",
		"with_nav_graphs"
	}
}
params.debug_nav_graph = {
	value = false,
	category = "Navigation",
	options = {
		false,
		"graphics_only",
		"prints_and_graphics"
	}
}
params.nav_graph_draw_distance = {
	value = 50,
	category = "Navigation",
	options = {
		10,
		50,
		100,
		math.huge
	}
}
params.debug_slots = {
	value = false,
	category = "Navigation",
	options_function = _debug_slots_options
}
params.debug_doors = {
	value = false,
	category = "Navigation"
}
params.always_update_doors = {
	value = false,
	category = "Navigation"
}
params.debug_pathfinder_queue = {
	value = false,
	category = "Navigation"
}
params.draw_smartobject_fails = {
	value = false,
	category = "Navigation"
}
params.debug_nav_tag_volume_creation_times = {
	value = false,
	category = "Navigation"
}
params.debug_adapt_speed = {
	value = false,
	category = "Navigation"
}
params.engine_locomotion_debug = {
	value = false,
	category = "Locomotion"
}
params.debug_movement_speed = {
	value = false,
	category = "Locomotion"
}
params.draw_minion_velocity = {
	value = false,
	category = "Locomotion"
}
params.draw_player_mover = {
	value = false,
	category = "Locomotion"
}
params.teleport_on_out_of_bounds = {
	value = false,
	category = "Locomotion"
}
params.debug_draw_fall_damage = {
	value = false,
	category = "Locomotion"
}
params.debug_draw_force_translation = {
	value = false,
	category = "Locomotion"
}
params.draw_third_person_player_rotation = {
	value = false,
	category = "Locomotion"
}
params.debug_move_around_target = {
	value = false,
	category = "Locomotion"
}
params.debug_hub_movement_direction_variable = {
	value = false,
	category = "Hub"
}
params.hub_locomotion_position_mode_override = {
	value = false,
	category = "Hub",
	options = {
		false,
		"simulation",
		"animation",
		"feet_in_air"
	}
}
params.debug_hub_character_rotation = {
	value = false,
	category = "Hub"
}
params.show_predicted_hub_locomotion = {
	value = false,
	category = "Hub"
}
params.show_hub_locomotion = {
	value = false,
	category = "Hub"
}
params.debug_hub_movement_acceleration = {
	value = false,
	category = "Hub"
}
params.debug_hub_movement_move_state = {
	value = false,
	category = "Hub"
}
params.debug_fake_max_allowed_wanted_velocity_angle = {
	value = false,
	category = "Hub",
	options = {
		false,
		"left",
		"right"
	}
}
params.debug_visualize_input_direction = {
	value = false,
	category = "Hub"
}
params.debug_draw_hub_aim_constraint_targets = {
	value = false,
	category = "Hub",
	options = {
		false,
		"head",
		"torso",
		"both"
	}
}
params.always_jog_in_hub = {
	value = false,
	category = "Hub"
}
params.debug_draw_moveable_platforms = {
	value = false,
	category = "Moveable Platform"
}
params.debug_networked_timer = {
	value = false,
	category = "Mission Objectives"
}
params.debug_mission_objectives = {
	value = false,
	category = "Mission Objectives"
}
params.debug_mission_objective_target = {
	value = false,
	category = "Mission Objectives"
}
params.debug_mission_objective_zone = {
	value = false,
	category = "Mission Objectives"
}
params.debug_decoder_synchronizer = {
	value = false,
	category = "Mission Objectives"
}
params.debug_decoding_device = {
	value = false,
	category = "Mission Objectives"
}
params.debug_scanning_device = {
	value = false,
	category = "Mission Objectives"
}
params.debug_spline_follower = {
	value = false,
	category = "Mission Objectives"
}
params.debug_luggable_synchronizer = {
	value = false,
	category = "Mission Objectives"
}
params.debug_show_player_wallets = {
	value = false,
	category = "Mission Objectives"
}
params.use_free_flight_camera_for_bone_lod = {
	value = false,
	category = "Animation"
}
params.debug_bone_lod_radius = {
	value = false,
	category = "Animation"
}
params.debug_skeleton = {
	value = false,
	category = "Animation"
}
params.disable_third_person_weapon_anim_events = {
	value = false,
	category = "Animation"
}
params.show_minion_anim_event = {
	value = false,
	category = "Animation"
}
params.show_minion_anim_event_history = {
	value = false,
	category = "Animation"
}
params.minion_anim_event_history_count = {
	value = 10,
	category = "Animation"
}
params.debug_minion_anim_logging = {
	value = false,
	category = "Animation"
}
params.enable_first_person_anim_logging = {
	value = false,
	category = "Animation",
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if player:unit_is_alive() then
			local player_unit = player.player_unit
			local fp_ext = ScriptUnit.extension(player_unit, "first_person_system")
			local fp_unit = fp_ext:first_person_unit()

			Unit.set_animation_logging(fp_unit, new_value)
		end
	end
}
params.enable_third_person_anim_logging = {
	value = false,
	category = "Animation",
	on_value_set = function (new_value, old_value)
		local player = Managers.player:local_player(1)

		if player:unit_is_alive() then
			local player_unit = player.player_unit

			Unit.set_animation_logging(player_unit, new_value)
		end
	end
}
params.debug_animation_recording = {
	value = false,
	category = "Animation"
}
params.debug_animation_rollback = {
	value = false,
	category = "Animation"
}
params.dump_animation_state_config = {
	value = false,
	category = "Animation",
	on_value_set = function (new_value, old_value)
		if new_value then
			local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
			local PlayerUnitAnimationStateConfig = require("scripts/extension_systems/animation/utilities/player_unit_animation_state_config")

			PlayerUnitAnimationStateConfig.format(PlayerCharacterConstants.animation_rollback)
		end
	end
}
params.debug_first_person_run_speed_animation_scale = {
	value = false,
	category = "Animation"
}
params.show_player_3p_anim_event = {
	value = false,
	category = "Animation"
}
params.show_player_1p_anim_event = {
	value = false,
	category = "Animation"
}
params.max_num_player_anim_events_to_show = {
	value = 10,
	category = "Animation"
}
params.timer_picker_selected_timer_name = {
	value = "gameplay",
	hidden = true,
	category = "Time Scaling"
}
params.timer_picker_x_offset = {
	value = 5,
	category = "Time Scaling"
}
params.timer_picker_y_offset = {
	value = 80,
	category = "Time Scaling"
}
params.timer_picker_layer = {
	value = 910,
	category = "Time Scaling"
}
params.timer_picker_font_size = {
	value = 22,
	category = "Time Scaling"
}
params.max_time_scale = {
	value = 15,
	category = "Time Scaling"
}
params.debug_change_time_scale = {
	value = true,
	category = "Time Scaling"
}
params.disable_training_grounds_minion_respawning = {
	value = false,
	category = "Training Grounds"
}
params.debug_sweep_show_disregarded_actors = {
	value = false,
	category = "Action"
}
params.debug_sweep_show_sweep_lines = {
	value = false,
	category = "Action"
}
params.debug_sweep_log_unit_processing = {
	value = false,
	category = "Action"
}
params.debug_action_sweep_log = {
	value = false,
	category = "Action"
}
params.debug_weapon_actions = {
	value = false,
	category = "Action"
}
params.keep_last_action_drawn = {
	value = true,
	category = "Action"
}
params.log_weapon_action_transitions = {
	value = false,
	category = "Action"
}
params.show_action_movement_curves = {
	value = false,
	category = "Action"
}
params.debug_show_attacked_hit_zones = {
	value = false,
	category = "Action"
}
params.debug_sweep_stickyness = {
	value = false,
	category = "Action"
}
params.draw_closest_targeting_action_module = {
	value = false,
	category = "Action"
}
params.debug_print_action_combo = {
	value = false,
	category = "Action"
}
params.debug_draw_ballistic_raycast = {
	value = false,
	category = "Action"
}
params.debug_aim_placement_raycast = {
	value = false,
	category = "Action"
}
params.always_validate_weapon_shout_action_condition = {
	value = false,
	category = "Action"
}
params.debug_draw_action_weapon_shout = {
	value = false,
	category = "Action"
}
params.debug_action_input_parser = {
	value = false,
	category = "Action Input"
}
params.action_input_parser_mispredict_info = {
	value = false,
	category = "Action Input"
}
params.debug_disable_client_action_input_parsing = {
	value = false,
	category = "Action Input"
}
params.sweep_spline_selected_weapon_template = {
	value = "thunderhammer_2h_p1_m1",
	category = "Sweep Spline",
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
	end
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
	value = false,
	category = "Minion Attack Selection",
	options_function = function ()
		return _attack_selection_template_override_options("renegade_captain")
	end
}
params.cultist_captain_attack_selection_template_override = {
	value = false,
	category = "Minion Attack Selection",
	options_function = function ()
		return _attack_selection_template_override_options("cultist_captain")
	end
}
params.debug_taunting = {
	value = false,
	category = "Minion Attack Selection"
}
params.renegade_captain_custom_attack_selection_bolt_pistol_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_bolt_pistol_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_charge = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_fire_grenade = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_frag_grenade = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_hellgun_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_hellgun_spray_and_pray = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_hellgun_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_hellgun_sweep_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_kick = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_power_sword_melee_combo_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_power_sword_moving_melee_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_powermaul_ground_slam_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_punch = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_shoot_net = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_shotgun_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_shotgun_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.renegade_captain_custom_attack_selection_void_shield_explosion = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_bolt_pistol_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_bolt_pistol_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_charge = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_fire_grenade = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_frag_grenade = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_hellgun_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_hellgun_spray_and_pray = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_hellgun_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_hellgun_sweep_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_kick = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_power_sword_melee_combo_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_power_sword_moving_melee_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_powermaul_ground_slam_attack = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_punch = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_shoot_net = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_shotgun_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_shotgun_strafe_shoot = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.cultist_captain_custom_attack_selection_void_shield_explosion = {
	value = false,
	category = "Minion Renegade Captain Custom Attack Selection"
}
params.debug_minion_ground_impact_fx = {
	value = false,
	category = "Minions",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("minion_ground_impact")
		end
	end
}
params.debug_disable_minion_suppression = {
	value = false,
	category = "Minions"
}
params.debug_minion_dissolve = {
	value = false,
	category = "Minions"
}
params.debug_disable_minion_suppression_indicators = {
	value = false,
	category = "Minions"
}
params.debug_grenadiers = {
	value = false,
	category = "Minions"
}
params.debug_minion_suppression = {
	value = false,
	category = "Minions"
}
params.debug_area_suppression_falloff = {
	value = false,
	category = "Minions",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("suppression_falloff")
		end
	end
}
params.debug_minion_reuse_wounds = {
	value = false,
	category = "Minions"
}
params.debug_draw_minion_bind_pose = {
	value = false,
	category = "Minions"
}
params.debug_draw_minion_wounds_hits = {
	value = false,
	category = "Minions"
}
params.debug_minion_wounds_shape = {
	value = false,
	category = "Minions"
}
params.debug_minion_gibbing = {
	value = false,
	category = "Minions",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("minion_gibbing")
		end
	end
}
params.debug_disable_minion_stagger = {
	value = false,
	category = "Minions"
}
params.debug_disable_minion_blocked_reaction = {
	value = false,
	category = "Minions"
}
params.debug_minion_melee_attacks = {
	value = false,
	category = "Minions"
}
params.debug_minion_shooting = {
	value = false,
	category = "Minions"
}
params.debug_minion_toughness = {
	value = false,
	category = "Minions"
}
params.debug_attack_intensity = {
	value = false,
	category = "Minions"
}
params.debug_locked_in_melee = {
	value = false,
	category = "Minions"
}
params.debug_warp_teleport = {
	value = false,
	category = "Minions"
}
params.show_num_minions = {
	value = false,
	category = "Minions"
}
params.show_player_minion_kills = {
	value = false,
	category = "Minions"
}
params.show_minion_names = {
	value = false,
	category = "Minions"
}
params.show_minion_location = {
	value = false,
	category = "Minions"
}
params.show_minion_health = {
	value = false,
	category = "Minions"
}
params.debug_minion_aiming = {
	value = false,
	category = "Minions"
}
params.print_minion_spawn = {
	value = false,
	category = "Minions"
}
params.debug_minion_spawners = {
	value = false,
	category = "Minions"
}
params.minions_always_accurate = {
	value = false,
	category = "Minions"
}
params.show_combat_ranges = {
	value = false,
	category = "Minions"
}
params.debug_minion_phases = {
	value = false,
	category = "Minions"
}
params.debug_minion_shoot_pattern = {
	value = false,
	category = "Minions"
}
params.show_attack_selection_template = {
	value = false,
	category = "Minions"
}
params.debug_script_minion_collision = {
	value = false,
	category = "Minions"
}
params.show_health_bars_on_all_minions = {
	value = false,
	category = "Minions"
}
params.show_health_bars_on_elite_and_specials = {
	value = false,
	category = "Minions"
}
params.minions_aggro_on_spawn = {
	value = false,
	category = "Minions"
}
params.debug_minion_shields = {
	value = false,
	category = "Minions"
}
params.enable_minion_auto_stagger = {
	value = false,
	category = "Minions"
}
params.ignore_stuck_minions_warning = {
	value = false,
	category = "Minions"
}
params.ignore_horde_failed_spawn_warning = {
	value = false,
	category = "Minions"
}
params.ignore_special_failed_spawn_errors = {
	value = false,
	category = "Minions"
}
params.script_minion_collision = {
	value = true,
	category = "Minions",
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
	end
}
params.calculate_offset_from_peeking_to_aiming_in_cover = {
	value = false,
	category = "Minions"
}
params.kill_debug_spawned_minions_outside_navmesh = {
	value = true,
	category = "Minions"
}
params.show_minion_tokens = {
	value = false,
	category = "Minions"
}
params.mute_minion_sounds = {
	value = false,
	category = "Minions",
	on_value_set = function (new_value, old_value)
		Wwise.set_state("debug_mute_minions", new_value and "true" or "None")
	end
}
params.debug_stats = {
	value = false,
	category = "Stats"
}
params.local_stats = {
	value = false,
	category = "Stats"
}
params.show_stats_rpcs = {
	value = false,
	category = "Stats"
}
params.show_stats_performance = {
	value = false,
	category = "Stats"
}
params.disable_live_event_fetching = {
	value = false,
	category = "Misc"
}
params.distance_to_selected_unit = {
	value = false,
	category = "Misc"
}
params.debug_player_orientation = {
	value = false,
	category = "Misc"
}
params.debug_smooth_force_view_orientation = {
	value = false,
	category = "Misc"
}
params.debug_disable_vertical_smooth_force_view_orientation = {
	value = false,
	category = "Misc"
}
params.allow_server_control_from_client = {
	value = false,
	category = "Misc"
}
params.debug_idle_fullbody_animation_variable = {
	value = false,
	category = "Misc"
}
params.use_screen_timestamp = {
	value = false,
	category = "Misc"
}
params.store_callstack_on_delete = {
	value = false,
	category = "Misc"
}
params.disable_server_metrics_prints = {
	value = false,
	category = "Misc"
}
params.disable_player_unit_weapon_extension_on_reload = {
	value = false,
	category = "Misc"
}
params.lock_look_input = {
	value = false,
	category = "Misc"
}
params.max_num_characters_override = {
	value = 8,
	category = "Misc",
	options = {
		false,
		5,
		6,
		7,
		8
	}
}
params.challenge = {
	value = 3,
	category = "Difficulty",
	options = {
		1,
		2,
		3,
		4,
		5,
		6
	},
	on_value_set = function (new_value, old_value)
		Managers.state.difficulty:set_challenge(new_value)
	end
}
params.resistance = {
	value = 3,
	category = "Difficulty",
	options = {
		1,
		2,
		3,
		4,
		5
	},
	on_value_set = function (new_value, old_value)
		Managers.state.difficulty:set_resistance(new_value)
	end
}
params.havoc_rank = {
	value = 0,
	category = "Difficulty",
	options = {
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23,
		24,
		25,
		26,
		27,
		28,
		29,
		30,
		35,
		40,
		45,
		50,
		55,
		60,
		65,
		70,
		75,
		80,
		85,
		90,
		95,
		100
	}
}
params.minion_friendly_fire = {
	value = true,
	category = "Difficulty"
}
params.player_friendly_fire = {
	value = false,
	category = "Difficulty"
}
params.debug_chaos_hound = {
	value = false,
	category = "Chaos Hound"
}
params.disable_chaos_hound_pounce = {
	value = false,
	category = "Chaos Hound"
}
params.debug_mutant_charger = {
	value = false,
	category = "Mutant Charger"
}
params.debug_chaos_spawn = {
	value = false,
	category = "Chaos Spawn"
}
params.enable_chunk_lod = {
	value = true,
	category = "Chunk Lod"
}
params.chunk_lod_debug = {
	value = false,
	category = "Chunk Lod"
}
params.chunk_lod_free_flight_camera_raycast = {
	value = false,
	category = "Chunk Lod"
}
params.debug_print_stripped_items = {
	value = false,
	category = "Item"
}
params.show_gear_ids = {
	value = false,
	category = "Item"
}
params.only_fallback_items = {
	value = false,
	category = "Item"
}
params.debug_players_immune_net = {
	value = false,
	category = "Netgunner"
}
params.debug_netgunner_shoot_position = {
	value = false,
	category = "Netgunner"
}
params.debug_netted_drag_position = {
	value = false,
	category = "Netgunner",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("netted_drag_position")
		end
	end
}
params.debug_daemonhost = {
	value = false,
	category = "Daemonhost"
}
params.debug_liquid_beam = {
	value = false,
	category = "Liquid Beam"
}
params.debug_covers = {
	value = false,
	category = "Covers"
}
params.debug_combat_vector = {
	value = false,
	category = "Combat Vector"
}
params.debug_combat_vector_simple = {
	value = false,
	category = "Combat Vector"
}
params.debug_corruptors = {
	value = false,
	category = "Corruptors"
}
params.auto_kill_corruptor_pustules = {
	value = false,
	category = "Corruptors"
}
params.disable_corruptor_damage_tick = {
	value = false,
	category = "Corruptors"
}
params.debug_roamer_pacing = {
	value = false,
	category = "Roamers"
}
params.disable_roamer_pacing = {
	value = false,
	category = "Roamers"
}
params.debug_patrols = {
	value = false,
	category = "Roamers"
}
params.disable_cultists = {
	value = false,
	category = "Roamers"
}
params.debug_hordes = {
	value = false,
	category = "Hordes"
}
params.disable_horde_pacing = {
	value = false,
	category = "Hordes"
}
params.disable_trickle_horde_pacing = {
	value = false,
	category = "Hordes"
}
params.debug_horde_pacing = {
	value = false,
	category = "Hordes"
}
params.hordes_mode_override_wave_number = {
	value = false,
	category = "Hordes Mode"
}
params.hordes_mode_wave_number = {
	value = 3,
	category = "Hordes Mode"
}
params.debug_groups = {
	value = false,
	category = "Groups"
}
params.debug_group_sfx = {
	value = false,
	category = "Groups"
}
params.chaos_hound_allowed = {
	value = true,
	category = "Specials"
}
params.chaos_hound_mutator_allowed = {
	value = true,
	category = "Specials"
}
params.cultist_mutant_mutator_allowed = {
	value = true,
	category = "Specials"
}
params.chaos_poxwalker_bomber_allowed = {
	value = true,
	category = "Specials"
}
params.cultist_flamer_allowed = {
	value = true,
	category = "Specials"
}
params.cultist_grenadier_allowed = {
	value = true,
	category = "Specials"
}
params.cultist_mutant_allowed = {
	value = true,
	category = "Specials"
}
params.debug_specials_pacing = {
	value = false,
	category = "Specials"
}
params.disable_specials_pacing = {
	value = false,
	category = "Specials"
}
params.freeze_specials_pacing = {
	value = false,
	category = "Specials"
}
params.renegade_grenadier_allowed = {
	value = true,
	category = "Specials"
}
params.renegade_netgunner_allowed = {
	value = true,
	category = "Specials"
}
params.renegade_sniper_allowed = {
	value = true,
	category = "Specials"
}
params.flamer_allowed = {
	value = true,
	category = "Specials"
}
params.grenadier_allowed = {
	value = true,
	category = "Specials"
}
params.renegade_flamer_allowed = {
	value = true,
	category = "Specials"
}
params.renegade_flamer_mutator_allowed = {
	value = true,
	category = "Specials"
}
params.disable_monster_pacing = {
	value = false,
	category = "Monsters"
}
params.debug_monster_pacing = {
	value = false,
	category = "Monsters"
}
params.debug_mutator_monster_pacing = {
	value = false,
	category = "Monsters"
}
params.debug_pacing = {
	value = false,
	category = "Pacing"
}
params.disable_pacing = {
	value = false,
	name = "disable_pacing, Keybind: L-SHIFT + X",
	category = "Pacing",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_pacing(channel, new_value)
		end
	end
}
params.debug_player_combat_states = {
	value = false,
	category = "Pacing"
}
params.disable_beast_of_nurgle = {
	value = false,
	category = "Pacing"
}
params.disable_daemonhost = {
	value = false,
	category = "Pacing"
}
params.disable_renegade_berzerker = {
	value = false,
	category = "Pacing"
}
params.debug_join_party = {
	value = false,
	category = "Party"
}
params.immaterium_local_grpc = {
	value = false,
	category = "Party"
}
params.party_hash = {
	value = false,
	category = "Party"
}
params.reconnect_to_ongoing_game_session = {
	value = true,
	category = "Party"
}
params.verbose_party_log = {
	value = false,
	category = "Party"
}
params.debug_playload = {
	value = false,
	category = "Payload"
}
params.verbose_presence_log = {
	value = false,
	category = "Presence"
}
params.print_batched_presence_streams = {
	value = false,
	category = "Presence"
}
params.hide_hud = {
	value = false,
	category = "Hud"
}
params.enemy_outlines = {
	value = "on",
	category = "Hud",
	options = {
		"off",
		"on"
	}
}
params.disable_outlines = {
	value = false,
	category = "Hud"
}
params.simulate_color_blindness = {
	value = "off",
	category = "Hud",
	options = {
		"off",
		"rare_protanomaly",
		"common_deuteranomaly",
		"very_rare_tritanomaly"
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
	end
}
params.show_debug_charge_hud = {
	value = false,
	category = "Hud"
}
params.show_debug_overheat_hud = {
	value = false,
	category = "Hud"
}
params.show_debug_warp_charge_hud = {
	value = false,
	category = "Hud"
}
params.show_debug_force_sword_2h_hud = {
	value = false,
	category = "Hud"
}
params.show_debug_scanning_progressbar = {
	value = false,
	category = "Hud"
}
params.always_max_warp_charge_hud_opacity = {
	value = false,
	category = "Hud"
}
params.always_max_overheat_hud_opacity = {
	value = false,
	category = "Hud"
}
params.hide_hud_world_markers = {
	value = false,
	category = "Hud"
}
params.always_show_hit_marker = {
	value = false,
	category = "Crosshair"
}
params.always_show_weakspot_hit_marker = {
	value = false,
	category = "Crosshair"
}
params.dot_crosshair_override = {
	value = false,
	category = "Crosshair"
}
params.hit_marker_color_override = {
	value = false,
	category = "Crosshair",
	options_function = function ()
		local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
		local options = table.keys(HudElementCrosshairSettings.hit_indicator_colors)

		table.insert(options, 1, false)

		return options
	end
}

local SHOW_INFO = BUILD == "dev" or BUILD == "debug"

params.render_version_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_build_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_engine_revision_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_content_revision_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_backend_url = {
	value = false,
	category = "Version Info"
}
params.show_master_data_version = {
	value = true,
	category = "Version Info"
}
params.show_team_city_build_info = {
	value = false,
	category = "Version Info"
}
params.show_backend_account_info = {
	value = true,
	category = "Version Info"
}
params.show_lan_port_info = {
	value = false,
	category = "Version Info"
}
params.show_network_hash_info = {
	value = false,
	category = "Version Info"
}
params.show_screen_resolution_info = {
	value = false,
	category = "Version Info"
}
params.show_mission_name = {
	value = true,
	category = "Version Info"
}
params.show_level_name = {
	value = false,
	category = "Version Info"
}
params.show_chunk_name = {
	value = true,
	category = "Version Info"
}
params.show_game_mode_name = {
	value = false,
	category = "Version Info"
}
params.show_num_hub_players = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_unique_instance_id = {
	value = true,
	category = "Version Info"
}
params.show_region = {
	value = true,
	category = "Version Info"
}
params.show_deployment_id = {
	value = false,
	category = "Version Info"
}
params.show_camera_position_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_camera_rotation_info = {
	value = false,
	category = "Version Info"
}
params.show_player_1p_position_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_player_3p_position_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_mechanism_name = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_network_info = {
	category = "Version Info",
	value = SHOW_INFO
}
params.show_progression_info = {
	value = false,
	category = "Version Info"
}
params.show_presence_info = {
	value = false,
	category = "Version Info"
}
params.show_difficulty = {
	value = true,
	category = "Version Info"
}
params.show_circumstances = {
	value = true,
	category = "Version Info"
}
params.show_selected_unit_info = {
	value = true,
	category = "Version Info"
}
params.show_vo_story_stage_info = {
	value = false,
	category = "Version Info"
}
params.show_cinematic_active = {
	value = false,
	category = "Version Info"
}
params.render_feature_info = {
	category = "Feature Info",
	value = SHOW_INFO
}
params.debug_draw_force_field_collision = {
	value = false,
	category = "Force Field"
}
params.show_force_field_life_and_health = {
	value = false,
	category = "Force Field"
}
params.override_burst_limit = {
	value = false,
	category = "FGRL"
}
params.burst_limit_calls = {
	value = 10,
	category = "FGRL"
}
params.override_sustain_limit = {
	value = false,
	category = "FGRL"
}
params.sustain_limit_calls = {
	value = 30,
	category = "FGRL"
}
params.perfhud_artist = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist")
	end
}
params.perfhud_artist_deferred_lighting = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "deferred_lighting")
	end
}
params.perfhud_artist_fx = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "fx")
	end
}
params.perfhud_artist_gui = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "gui")
	end
}
params.perfhud_artist_lighting = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "lighting")
	end
}
params.perfhud_artist_objects = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "objects")
	end
}
params.perfhud_artist_post_processing = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "artist", "post_processing")
	end
}
params.perfhud_audio = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "audio")
	end
}
params.perfhud_culling = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "culling")
	end
}
params.perfhud_extended_memory = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "extended_memory")
	end
}
params.perfhud_gui = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "gui")
	end
}
params.perfhud_lua = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "lua")
	end
}
params.perfhud_memory = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "memory")
	end
}
params.perfhud_memory_allocator_usage = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "memory", "allocator_usage")
	end
}
params.perfhud_network = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network")
	end
}
params.perfhud_network_messages = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_messages")
	end
}
params.perfhud_network_peers = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers")
	end
}
params.perfhud_network_peers_bytes = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers", "bytes")
	end
}
params.perfhud_network_peers_kbps = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_peers", "kbps")
	end
}
params.perfhud_network_ping = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "network_ping")
	end
}
params.perfhud_texture_streaming = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "texture_streaming")
	end
}
params.perfhud_wwise = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "wwise")
	end
}
params.perfhud_backend_client = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "backend", "client")
	end
}
params.perfhud_backend_server = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "backend", "server")
	end
}
params.perfhud_io = {
	value = false,
	category = "PerfHud",
	on_value_set = function (new_value)
		Application.console_command("perfhud", "io")
	end
}
params.ui_skip_campaign_missions = {
	value = false,
	category = "UI"
}
params.ui_developer_mode = {
	value = false,
	category = "UI"
}
params.ui_debug_3d_rendering = {
	value = false,
	category = "UI"
}
params.ui_debug_3d_no_slug_text = {
	value = false,
	category = "UI"
}
params.ui_disable_kill_feed = {
	value = false,
	category = "UI"
}
params.ui_show_active_views = {
	value = false,
	category = "UI"
}
params.ui_debug_subtitles = {
	value = false,
	category = "UI"
}
params.ui_use_local_inventory = {
	value = false,
	category = "UI"
}
params.ui_always_enable_inventory_access = {
	value = false,
	category = "UI"
}
params.ui_always_enable_achievements_menu = {
	value = false,
	category = "UI"
}
params.ui_hide_hud = {
	value = false,
	category = "UI"
}
params.ui_debug_test_view_spawning = {
	value = false,
	category = "UI"
}
params.ui_debug_scenegraph = {
	value = false,
	category = "UI"
}
params.ui_debug_pixeldistance = {
	value = false,
	category = "UI"
}
params.ui_grid_enabled = {
	value = false,
	category = "UI"
}
params.ui_grid_width = {
	value = 100,
	category = "UI"
}
params.ui_grid_height = {
	value = 100,
	category = "UI"
}
params.ui_debug_hover = {
	value = false,
	category = "UI"
}
params.ui_skip_main_menu_screen = {
	value = false,
	category = "UI"
}
params.ui_skip_title_screen = {
	value = false,
	category = "UI"
}
params.ui_skip_splash_screen = {
	value = false,
	category = "UI"
}
params.ui_disable_view_loader = {
	value = false,
	category = "UI"
}
params.ui_view_scale = {
	value = 1,
	num_decimals = 1,
	category = "UI",
	on_value_set = function ()
		local force_update = true

		UPDATE_RESOLUTION_LOOKUP(force_update)
	end
}
params.ui_safe_rect = {
	value = 0,
	category = "UI",
	on_value_set = function ()
		local force_update = true

		UPDATE_RESOLUTION_LOOKUP(force_update)
	end
}
params.ui_disabled = {
	value = false,
	category = "UI"
}
params.ui_debug_end_screen = {
	value = false,
	category = "UI"
}
params.ui_debug_lobby_screen = {
	value = false,
	category = "UI"
}
params.ui_debug_lobby_screen_havoc = {
	value = false,
	category = "UI"
}
params.ui_debug_mission_intro = {
	value = false,
	category = "UI"
}
params.ui_debug_mission_outro = {
	value = false,
	category = "UI"
}
params.ui_debug_havoc_menu = {
	value = false,
	category = "UI"
}
params.ui_enable_item_names = {
	value = false,
	category = "UI"
}
params.ui_enable_mission_board_debug = {
	value = false,
	category = "UI"
}
params.ui_show_social_menu = {
	value = true,
	category = "UI"
}
params.ui_enable_debug_view = {
	value = false,
	category = "UI"
}
params.ui_debug_news_screen = {
	value = false,
	category = "UI"
}
params.ui_enable_notifications = {
	value = true,
	category = "UI",
	on_value_set = function ()
		Managers.event:trigger("event_clear_notifications")
	end
}
params.spawn_next_to_mission_board = {
	value = false,
	category = "UI"
}
params.spawn_next_to_crafting = {
	value = false,
	category = "UI"
}
params.ui_debug_loc_strings = {
	value = false,
	category = "UI"
}
params.ui_ignore_hub_interaction_requirements = {
	value = false,
	category = "UI"
}
params.local_crafting = {
	value = false,
	category = "UI"
}
params.sticker_book_seen_all_traits = {
	value = false,
	category = "UI"
}
params.debug_render_target_atlas_generator = {
	value = false,
	category = "UI"
}
params.ui_always_show_tutorial_popup = {
	value = false,
	category = "UI"
}
params.debug_hud_element_fading = {
	value = false,
	category = "UI"
}
params.debug_draw_world_marker_component = {
	value = false,
	category = "UI"
}
params.override_stun_type = {
	value = false,
	category = "Damage",
	options_function = function ()
		local DisorientationSettings = require("scripts/settings/damage/disorientation_settings")
		local options = {
			false
		}

		for key, _ in pairs(DisorientationSettings.disorientation_types) do
			options[#options + 1] = key
		end

		return options
	end
}
params.disable_player_wounds = {
	value = false,
	category = "Damage"
}
params.show_selected_unit_health = {
	value = false,
	category = "Damage"
}
params.show_debug_explosions = {
	value = false,
	category = "Damage"
}
params.debug_async_explosions = {
	value = false,
	category = "Damage"
}
params.enable_damage_debug = {
	category = "Damage",
	value = IS_WINDOWS
}
params.debug_damage_power_level = {
	value = 500,
	category = "Damage",
	options = {
		500,
		1000,
		1500,
		2000
	}
}
params.debug_damage_calculation = {
	value = false,
	category = "Damage"
}
params.debug_pellet_damage = {
	value = false,
	category = "Damage"
}
params.debug_attack_utility = {
	value = false,
	category = "Damage"
}
params.debug_players_unkillable = {
	value = false,
	category = "Damage",
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
	end
}
params.debug_players_invulnerable = {
	value = false,
	category = "Damage",
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
	end
}
params.disable_toughness_damage = {
	value = false,
	category = "Damage"
}
params.debug_toughness = {
	value = false,
	category = "Damage"
}
params.player_weapon_instakill = {
	value = false,
	category = "Damage"
}
params.player_damage_disabled = {
	value = false,
	category = "Damage"
}
params.always_min_damage_knocked_down_damage_tick = {
	value = false,
	category = "Damage"
}
params.disable_knocked_down_damage_tick = {
	value = false,
	category = "Damage"
}
params.disable_screen_space_blood = {
	value = false,
	category = "Damage"
}
params.debug_draw_blood_decal_rotation = {
	value = false,
	category = "Damage"
}
params.disable_push_from_damage = {
	value = false,
	category = "Damage"
}
params.disable_catapult_from_damage = {
	value = false,
	category = "Damage"
}
params.enable_auto_healing = {
	value = false,
	category = "Damage"
}
params.debug_minigame = {
	value = false,
	category = "Minigame"
}
params.disable_minigame_angle_check = {
	value = false,
	category = "Minigame"
}
params.sound = {
	value = false,
	category = "Dialogue"
}
params.dialogue_all_contexts = {
	value = false,
	category = "Dialogue"
}
params.dialogue_last_played_query = {
	value = false,
	category = "Dialogue"
}
params.text_to_speech_forced = {
	value = false,
	category = "Dialogue"
}
params.text_to_speech_missing = {
	value = false,
	category = "Dialogue"
}
params.dialogue_missing_vo_trigger_error_sound = {
	value = false,
	category = "Dialogue"
}
params.dialogue_last_query = {
	value = false,
	category = "Dialogue"
}
params.dialogue_queries = {
	value = false,
	category = "Dialogue"
}
params.dialogue_debug_lookat = {
	value = false,
	category = "Dialogue"
}
params.dialogue_disable_vo = {
	value = false,
	category = "Dialogue"
}
params.dialogue_mute_vo = {
	value = false,
	category = "Dialogue",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("debug_mute_vo", new_value == true and "true" or "false")
		end
	end
}
params.dialogue_display_voices_and_lines = {
	value = false,
	category = "Dialogue"
}
params.dialogue_ruledatabase_debug_all = {
	value = false,
	category = "Dialogue"
}
params.dialogue_enable_sound_event_logs = {
	value = false,
	category = "Dialogue"
}
params.dialogue_enable_voice_data_logs = {
	value = false,
	category = "Dialogue"
}
params.dialogue_enable_vo_focus_mode = {
	value = false,
	category = "Dialogue",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Wwise.set_state("debug_focus_vo", new_value == true and "true" or "false")
		end
	end
}
params.dialogue_show_currently_playing_vo_info = {
	value = false,
	category = "Dialogue"
}
params.dialogue_disable_story_lines = {
	value = false,
	category = "Dialogue"
}
params.dialogue_log_enemy_vo_events = {
	value = false,
	category = "Dialogue"
}
params.dialogue_debug_story_tickers = {
	value = false,
	category = "Dialogue"
}
params.dialogue_show_assault_vo_timer = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_player_level = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_player_level_value = {
	value = 1,
	category = "Dialogue"
}
params.dialogue_skip_timediff_conditions = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_level_time_conditions = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_story_tick_start_time = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_story_tick_start_time_value = {
	value = 0,
	category = "Dialogue",
	on_value_set = function (new_value, old_value)
		local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

		if new_value ~= old_value then
			DialogueSettings.story_start_delay = new_value
		end
	end
}
params.dialogue_override_short_story_tick_start_time = {
	value = false,
	category = "Dialogue"
}
params.dialogue_override_short_story_tick_start_time_value = {
	value = 0,
	category = "Dialogue",
	on_value_set = function (new_value, old_value)
		local DialogueSettings = require("scripts/settings/dialogue/dialogue_settings")

		if new_value ~= old_value then
			DialogueSettings.story_start_delay = new_value
		end
	end
}
params.dialogue_force_load_all_player_vo = {
	value = false,
	category = "Dialogue"
}
params.debug_equipment_component = {
	value = false,
	category = "Equipment"
}
params.debug_item_alias_fake_loading = {
	value = false,
	category = "Equipment"
}
params.character_profile_selector_slot_primary_override = {
	value = false,
	category = "Equipment",
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
	end
}
params.character_profile_selector_slot_secondary_override = {
	value = false,
	category = "Equipment",
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
	end
}
params.always_trigger_stagger = {
	value = false,
	category = "Stagger"
}
params.stagger_debug_log = {
	value = false,
	category = "Stagger"
}
params.debug_herding = {
	value = false,
	category = "Stagger",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value then
			Debug:clear_world_text("herding_staggers")
		end
	end
}
params.override_accumulative_stagger_multiplier = {
	value = false,
	category = "Stagger"
}
params.override_accumulative_stagger_multiplier_value = {
	value = 1,
	num_decimals = 2,
	category = "Stagger"
}
params.debug_looping_stagger = {
	value = false,
	category = "Stagger",
	on_value_set = function (new_value)
		if new_value then
			local selected_unit = Debug.selected_unit

			if selected_unit then
				local Stagger = require("scripts/utilities/attack/stagger")

				Stagger.debug_trigger_minion_stagger(selected_unit)
			end
		end
	end
}
params.debug_stagger_length_scale = {
	value = 1,
	num_decimals = 1,
	category = "Stagger"
}
params.debug_use_stagger_keys = {
	value = false,
	category = "Stagger"
}
params.debug_stagger_direction = {
	value = "fwd",
	category = "Stagger",
	options = {
		"left",
		"right",
		"fwd",
		"bwd",
		"dwn"
	}
}
params.debug_stagger_type = {
	value = "heavy",
	category = "Stagger",
	options_function = function ()
		local StaggerSettings = require("scripts/settings/damage/stagger_settings")
		local stagger_types = StaggerSettings.stagger_types
		local options = {}

		for k, _ in pairs(stagger_types) do
			table.insert(options, k)
		end

		table.sort(options)

		return options
	end
}
params.debug_draw_projectiles = {
	value = false,
	category = "Projectile"
}
params.debug_projectile_penetration = {
	value = false,
	category = "Projectile"
}
params.debug_draw_projectile_aiming = {
	value = false,
	category = "Projectile"
}
params.debug_projectile_husk_interpolation = {
	value = false,
	category = "Projectile"
}
params.debug_push_attacks = {
	value = false,
	category = "Push"
}
params.debug_script_components = {
	value = false,
	category = "Script Components"
}
params.script_components_print_data = {
	value = false,
	category = "Script Components"
}
params.debug_game_mode = {
	value = false,
	category = "Game Mode"
}
params.debug_state_machine = {
	value = false,
	category = "Game Mode"
}
params.debug_darkness = {
	value = false,
	category = "Game Mode"
}
params.debug_sides = {
	value = false,
	category = "Game Mode"
}
params.debug_circumstances = {
	value = false,
	category = "Game Mode"
}
params.disable_game_end_conditions = {
	value = false,
	category = "Game Mode"
}
params.debug_alternating_toxic_gas = {
	value = false,
	category = "Game Mode"
}
params.disable_achievement_backend_update = {
	value = false,
	category = "Achievements",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_disable_achievement_backend_update(channel, new_value)
		end
	end
}
params.debug_trophies = {
	value = false,
	category = "Game Mode"
}
params.debug_shading_environment = {
	value = false,
	category = "Shading Environment"
}
params.debug_gameplay_state = {
	value = false,
	category = "Gameplay State"
}
params.debug_spawn_queue = {
	value = false,
	category = "Gameplay State"
}
params.gameplay_timer_base_time_scale = {
	value = 1,
	num_decimals = 2,
	category = "Gameplay State"
}
params.debug_grow_queue_callstacks = {
	value = false,
	category = "Gameplay State"
}
params.mission_seed_override = {
	value = "none",
	category = "Gameplay State"
}
params.dump_leaking_tables_pre_shutdown = {
	value = false,
	category = "Garbage Detection"
}
params.dump_leaking_tables_post_shutdown = {
	value = false,
	category = "Garbage Detection"
}
params.debug_respawn_beacon = {
	value = false,
	category = "Respawn"
}
params.debug_player_spawn = {
	value = false,
	category = "Respawn"
}
params.disable_respawning = {
	value = false,
	category = "Respawn"
}
params.no_respawn_wait_time = {
	value = false,
	category = "Respawn"
}
params.teleport_on_spawn = {
	value = false,
	category = "Respawn"
}
params.teleport_on_spawn_location = {
	value = "Vector3(0,0,0)",
	category = "Respawn"
}
params.teleport_on_spawn_yaw_pitch_roll = {
	value = "Vector3(0,0,0)",
	category = "Respawn"
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
	value = false,
	category = "Network"
}
params.debug_session_layer = {
	value = false,
	category = "Network"
}
params.debug_matchmaking = {
	value = false,
	category = "Network"
}
params.debug_time_since_last_transmit = {
	value = true,
	category = "Network"
}
params.disable_session_update_print = {
	value = false,
	category = "Network"
}
params.visualize_input_packets_received = {
	value = false,
	category = "Network"
}
params.visualize_input_packets_with_ping = {
	value = false,
	category = "Network"
}
params.debug_adaptive_clock = {
	value = false,
	category = "Network"
}
params.disable_adaptive_clock_offset_correction = {
	value = false,
	category = "Network"
}
params.adaptive_clock_offset_correction_info_logging = {
	value = false,
	category = "Network"
}
params.debug_play_sound_on_not_received_input = {
	value = false,
	category = "Network"
}
params.log_mispredicts = {
	value = false,
	category = "Network"
}
params.mispredict_info = {
	value = false,
	category = "Network"
}
params.simulate_ping_variation = {
	value = 0,
	num_decimals = 3,
	category = "Network",
	on_value_set = set_simulated_latency
}
params.simulate_ping = {
	num_decimals = 3,
	value = 0,
	category = "Network",
	options = {
		0,
		0.03,
		0.08,
		0.12,
		0.2
	},
	on_value_set = set_simulated_latency
}
params.debug_stall_game_duration = {
	value = 1,
	num_decimals = 1,
	category = "Network",
	options = {
		0.1,
		0.5,
		1,
		3,
		6,
		10,
		15
	}
}
params.network_hash = {
	value = "",
	category = "Network"
}
params.lag_compensation_draw_enabled = {
	value = false,
	user_setting = false,
	category = "Network",
	on_value_set = lag_compensation_toggle_draw
}
params.manual_lag_compensation = {
	value = false,
	user_setting = false,
	category = "Network",
	on_value_set = set_manual_lag_compensation
}
params.manual_lag_compensation_value = {
	value = 0,
	num_decimals = 3,
	category = "Network",
	on_value_set = set_manual_lag_compensation_value
}
params.packet_loss = {
	value = 0,
	num_decimals = 3,
	category = "Network",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value and Managers.state.game_session then
			Managers.state.game_session:set_simulated_packet_loss(new_value)
		end
	end
}
params.packet_duplication = {
	value = 0,
	num_decimals = 3,
	category = "Network",
	on_value_set = function (new_value, old_value)
		if new_value ~= old_value and Managers.state.game_session then
			Managers.state.game_session:set_simulated_packet_duplication(new_value)
		end
	end
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
		"rpc_interaction_set_active"
	}

	for key, value in ipairs(to_ignore) do
		Network.ignore_rpc_log(value)
	end
end

params.pong_timeout = {
	value = 10,
	category = "Network",
	on_value_set = set_pong_timeout
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
				url_request = Managers.backend.url_request
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
	value = false,
	category = "Network",
	options = {
		false,
		0.5,
		2,
		8
	},
	on_value_set = set_backend_delay
}
params.reliable_rpc_send_count_debug = {
	value = false,
	category = "Network"
}
params.debug_pass_EAC_check = {
	value = true,
	category = "Network"
}
params.debug_rpc_logging = {
	value = false,
	category = "Network",
	on_value_set = enable_rpc_logging
}
params.debug_breed_resource_dependencies = {
	value = false,
	category = "Loading"
}
params.debug_loading = {
	value = false,
	category = "Loading"
}
params.debug_loading_times = {
	value = false,
	category = "Loading"
}
params.debug_package_loading = {
	value = false,
	category = "Loading"
}
params.delay_packages_on_profile_changed = {
	value = false,
	num_decimals = 1,
	category = "Loading",
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
		32
	}
}
params.draw_package_loading = {
	value = false,
	category = "Loading"
}
params.debug_load_wait_info = {
	value = false,
	category = "Loading"
}
params.show_perfhud_io_loading_screen = {
	value = true,
	category = "Loading"
}
params.debug_language_override = {
	name = "Language Override",
	category = "Localization",
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
	end
}
params.debug_localization_string_cache = {
	value = false,
	name = "Debug String Cache",
	category = "Localization"
}
params.volume_event_debug = {
	value = false,
	category = "Volume"
}
params.volume_trigger_debug = {
	value = false,
	category = "Volume"
}
params.debug_buff_volumes = {
	value = false,
	category = "Volume"
}
params.dev_params_gui_auto_expand_tree = {
	value = true,
	category = "Imgui"
}
params.dev_params_gui_reset_filter_on_open = {
	value = true,
	category = "Imgui"
}
params.debug_smart_targeting_template = {
	value = false,
	category = "Smart Targeting"
}
params.visualize_smart_targeting_precision_target = {
	value = false,
	category = "Smart Targeting"
}
params.visualize_smart_targeting_proximity = {
	value = false,
	category = "Smart Targeting"
}
params.debug_smart_tags = {
	value = false,
	category = "Smart Tagging"
}
params.debug_smart_tag_target_selection = {
	value = false,
	category = "Smart Tagging"
}
params.debug_smart_tag_log_events = {
	value = true,
	category = "Smart Tagging"
}
params.debug_use_local_social_backend = {
	value = false,
	category = "Social Features"
}
params.debug_show_logs_ps5_friends_blocks_update = {
	value = false,
	category = "Social Features"
}
params.debug_print_ps5_block_users_states = {
	value = false,
	category = "Social Features"
}
params.debug_print_party_channels = {
	value = false,
	category = "Social Features"
}
params.use_localized_talent_names_in_debug_menu = {
	value = false,
	category = "Talents"
}
params.debug_skip_backend_talent_verification = {
	value = false,
	category = "Talents"
}
params.talent_tree_no_restrictions = {
	value = false,
	category = "Talents"
}
params.talent_tree_infinite_points = {
	value = false,
	category = "Talents"
}
params.testify_test_suite_id = {
	value = false,
	category = "Testify"
}
params.draw_chain_lightning_targeting = {
	value = false,
	category = "Chain Lightning"
}
params.debug_chain_lightning = {
	value = false,
	category = "Chain Lightning"
}
params.debug_draw_chain_lightning_effects = {
	value = false,
	category = "Chain Lightning"
}
params.immediate_chain_lightning_jumps = {
	value = false,
	category = "Chain Lightning"
}
params.disable_chain_lightning_effects = {
	value = false,
	category = "Chain Lightning"
}
params.debug_chain_lightning_hand_effects = {
	value = false,
	category = "Chain Lightning"
}
params.always_max_overheat = {
	value = false,
	category = "Weapon"
}
params.debug_allow_full_magazine_reload = {
	value = false,
	category = "Weapon"
}
params.debug_reload_state = {
	value = false,
	category = "Weapon"
}
params.debug_draw_hit_scan = {
	value = false,
	category = "Weapon"
}
params.debug_draw_flamer_scan = {
	value = false,
	category = "Weapon"
}
params.debug_draw_modified_hit_position = {
	value = false,
	category = "Weapon"
}
params.debug_dump_tweak_template_lerp_setup = {
	value = false,
	category = "Weapon"
}
params.debug_show_weapon_charge_level = {
	value = false,
	category = "Weapon"
}
params.debug_weapon_special = {
	value = false,
	category = "Weapon"
}
params.debug_shooting_status = {
	value = false,
	category = "Weapon"
}
params.debug_weapon_trait_templates = {
	value = false,
	category = "Weapon"
}
params.disable_overheat = {
	value = false,
	category = "Weapon"
}
params.disable_overheat_explosion = {
	value = false,
	category = "Weapon"
}
params.infinite_ammo_clip = {
	value = false,
	name = "Infinite ammo clip",
	category = "Weapon",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_infinite_ammo_clip(channel, new_value)
		end
	end
}
params.infinite_ammo_reserve = {
	value = false,
	name = "Infinite ammo reserve",
	category = "Weapon",
	on_value_set = function (new_value, old_value)
		if not Managers.state or not Managers.state.game_session then
			return
		end

		if not Managers.state.game_session:is_server() and DevParameters.allow_server_control_from_client then
			local channel = Managers.connection:host_channel()

			RPC.rpc_debug_client_request_infinite_ammo_reserve(channel, new_value)
		end
	end
}
params.log_weapon_template_resource_dependencies = {
	value = false,
	category = "Weapon"
}
params.debug_alternate_fire = {
	value = false,
	category = "Weapon"
}
params.debug_blocking = {
	value = false,
	category = "Weapon"
}
params.debug_looping_sounds = {
	value = false,
	category = "Weapon"
}
params.debug_draw_damage_profile_ranges = {
	value = false,
	category = "Weapon"
}
params.debug_always_ogryn_box_of_surprise = {
	value = false,
	category = "Weapon"
}
params.debug_always_extra_grenade_throw_chance = {
	value = false,
	category = "Weapon"
}
params.debug_draw_forcesword_wind_slash_hit = {
	value = false,
	category = "Weapon"
}
params.debug_aim_assist = {
	value = false,
	category = "Weapon Aim Assist"
}
params.disable_aim_assist = {
	value = false,
	category = "Weapon Aim Assist"
}
params.enable_mouse_and_keyboard_aim_assist = {
	value = false,
	category = "Weapon Aim Assist"
}
params.visualize_aim_assist_trajectory = {
	value = false,
	category = "Weapon Aim Assist"
}
params.debug_movement_aim_assist_logging = {
	value = false,
	category = "Weapon Aim Assist"
}
params.debug_ammo_count_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_area_buff_drone_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_chain_weapon_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_charge_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_force_weapon_block_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_force_weapon_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_force_weapon_wind_slash_stage_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_grimoire_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_melee_idling_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_plasmagun_overheat_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_power_weapon_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_power_weapon_overheat_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_psyker_throwing_knives_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_riot_shield_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_shock_mine_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_shock_mine_target_link_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_sticky_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_sweep_trail_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_thunder_hammer_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_weapon_flashlight = {
	value = false,
	category = "Weapon Effects"
}
params.debug_weapon_temperature_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_zealot_relic_effects = {
	value = false,
	category = "Weapon Effects"
}
params.debug_recoil = {
	value = false,
	category = "Weapon Handling"
}
params.debug_spread = {
	value = false,
	category = "Weapon Handling"
}
params.debug_sway = {
	value = false,
	category = "Weapon Handling"
}
params.disable_recoil = {
	value = false,
	category = "Weapon Handling"
}
params.disable_shooting_animations = {
	value = false,
	category = "Weapon Handling"
}
params.disable_spread = {
	value = false,
	category = "Weapon Handling"
}
params.disable_sway = {
	value = false,
	category = "Weapon Handling"
}
params.weapon_traits_randomization_base = {
	value = 0.4,
	num_decimals = 3,
	category = "Weapon Traits"
}
params.weapon_traits_randomization_deviation = {
	value = 0.1,
	num_decimals = 3,
	category = "Weapon Traits"
}
params.weapon_traits_randomization_step = {
	value = 0.01,
	num_decimals = 3,
	category = "Weapon Traits"
}
params.weapon_traits_testify = {
	value = false,
	category = "Weapon Traits"
}
params.use_localized_weapon_trait_names_in_debug_menu = {
	value = false,
	category = "Weapon Traits"
}
params.weapon_mastery_use_override_xp = {
	value = false,
	category = "Weapon Mastery"
}
params.enable_mastery_debug_options = {
	value = true,
	category = "Weapon Mastery"
}
params.debug_aim_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.debug_look_delta_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.debug_move_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.disable_aim_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.disable_look_delta_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.disable_move_weapon_offset = {
	value = false,
	category = "Weapon Variables"
}
params.disable_shooting_charge_level = {
	value = false,
	category = "Weapon Variables"
}
params.alternating_critical_strikes = {
	value = false,
	category = "Critical Strikes"
}
params.always_critical_strikes = {
	value = false,
	category = "Critical Strikes"
}
params.debug_critical_strike_pseudo_random_distribution = {
	value = false,
	category = "Critical Strikes"
}
params.no_critical_strikes = {
	value = false,
	category = "Critical Strikes"
}
params.debug_critical_strike_chance = {
	value = false,
	category = "Critical Strikes"
}
params.disable_terror_events = {
	value = false,
	category = "Terror Event"
}
params.debug_terror_events = {
	value = false,
	category = "Terror Event"
}
params.debug_main_path = {
	value = false,
	category = "Main Path"
}
params.debug_main_path_spawn_points = {
	value = false,
	category = "Main Path"
}
params.debug_main_path_occluded_points = {
	value = false,
	category = "Main Path"
}
params.debug_health_station = {
	value = false,
	category = "Health Station"
}
params.debug_moods = {
	value = false,
	category = "Mood"
}
params.disable_moods = {
	value = false,
	category = "Mood"
}
params.mood_override = {
	value = false,
	category = "Mood",
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
	end
}
params.disable_impact_vfx = {
	value = false,
	category = "Damage Interface"
}
params.disable_toughness_effects = {
	value = false,
	category = "Damage Interface"
}
params.impact_fx_override = {
	value = false,
	category = "Damage Interface",
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
	end
}
params.surface_effect_material_override = {
	value = false,
	category = "Damage Interface",
	options_function = function ()
		local MaterialQuerySettings = require("scripts/settings/material_query_settings")
		local surface_materials = MaterialQuerySettings.surface_materials
		local options = {
			false
		}

		for _, material in ipairs(surface_materials) do
			options[#options + 1] = material
		end

		return options
	end
}
params.debug_draw_missing_surface_materials = {
	value = true,
	category = "Damage Interface"
}
params.debug_draw_shotshell_impacts = {
	value = false,
	category = "Damage Interface"
}
params.debug_draw_impact_fx = {
	value = false,
	category = "Damage Interface"
}
params.debug_draw_impact_vfx_rotation = {
	value = false,
	category = "Damage Interface"
}
params.debug_draw_shield_impact_fx_offset = {
	value = false,
	category = "Damage Interface"
}
params.print_missing_impact_fx_definitions = {
	value = false,
	category = "Damage Interface"
}
params.debug_forced_damage_efficiency = {
	value = "none",
	user_setting = false,
	category = "Damage Interface",
	options_function = function ()
		local AttackSettings = require("scripts/settings/damage/attack_settings")
		local damage_efficiencies = AttackSettings.damage_efficiencies
		local options = {
			"none"
		}

		for damage_efficiency, _ in pairs(damage_efficiencies) do
			options[#options + 1] = damage_efficiency
		end

		return options
	end
}
params.debug_physics_proximity_system = {
	user_setting = false,
	value = false,
	category = "PhysicsProximitySystem",
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_enabled(new_value)
	end
}
params.debug_physics_proximity_system_afros = {
	user_setting = false,
	value = false,
	category = "PhysicsProximitySystem",
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_afros(new_value)
	end
}
params.debug_physics_proximity_system_observers = {
	user_setting = false,
	value = false,
	category = "PhysicsProximitySystem",
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_observers(new_value)
	end
}
params.debug_physics_proximity_system_actors = {
	user_setting = false,
	value = false,
	category = "PhysicsProximitySystem",
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_actors(new_value)
	end
}
params.debug_physics_proximity_system_time_verification = {
	user_setting = false,
	value = false,
	category = "PhysicsProximitySystem",
	on_value_set = function (new_value, old_value)
		PhysicsProximitySystem.set_debug_time_verification(new_value)
	end
}
params.debug_side_proximity = {
	value = false,
	category = "ProximitySystem"
}
params.debug_proximity_system = {
	value = false,
	category = "ProximitySystem"
}
params.debug_has_been_seen = {
	value = false,
	category = "LegacyV2ProximitySystem"
}
params.debug_proximity_fx = {
	value = false,
	category = "LegacyV2ProximitySystem"
}
params.max_allowed_proximity_fx = {
	value = false,
	category = "LegacyV2ProximitySystem",
	options = {
		false,
		8,
		16,
		32,
		64
	}
}
params.override_proximity_fx = {
	value = false,
	category = "LegacyV2ProximitySystem",
	options = {
		false,
		"always_enabled",
		"always_disabled"
	}
}
params.debug_fov = {
	value = false,
	category = "Camera"
}
params.camera_manager_debug = {
	value = false,
	category = "Camera"
}
params.camera_tree_debug = {
	value = false,
	category = "Camera"
}
params.force_spectate = {
	value = false,
	category = "Camera"
}
params.use_far_third_person_camera = {
	value = false,
	category = "Camera"
}
params.override_1p_camera_movement_offset = {
	value = false,
	category = "Camera"
}
params.override_1p_camera_movement_offset_lerp = {
	value = 1,
	category = "Camera",
	num_decimals = 2
}
params.disable_player_hit_reaction = {
	value = false,
	category = "Camera"
}
params.external_fov_multiplier = {
	value = 1,
	num_decimals = 2,
	category = "Camera",
	on_value_set = function (new_value, old_value)
		Managers.state.camera:set_variable("player1", "external_fov_multiplier", new_value)
	end
}
params.free_flight_follow_path_speed = {
	value = 7.4,
	num_decimals = 1,
	category = "Free Flight",
	on_value_set = function (new_value, old_value)
		local free_flight_manager = Managers.free_flight

		if free_flight_manager then
			free_flight_manager:set_follow_path_speed(new_value)
		end
	end
}
params.debug_network_story = {
	value = false,
	category = "Stories"
}
params.debug_cinematics = {
	value = false,
	category = "Stories"
}
params.debug_cinematics_verbose = {
	value = false,
	category = "Stories"
}
params.debug_skip_cinematics = {
	value = false,
	category = "Stories"
}
params.debug_cinematic_scene = {
	value = false,
	category = "Stories"
}
params.debug_cinematic_fast_track_enable = {
	value = false,
	category = "Stories"
}
params.debug_show_dof_info = {
	value = false,
	category = "Stories"
}
params.debug_dof_override = {
	value = false,
	category = "Stories"
}
params.debug_dof_enabled = {
	value = 1,
	num_decimals = 5,
	category = "Stories"
}
params.debug_focal_distance = {
	value = 1,
	num_decimals = 5,
	category = "Stories"
}
params.debug_focal_region = {
	value = 1,
	num_decimals = 5,
	category = "Stories"
}
params.debug_focal_padding = {
	value = 1,
	num_decimals = 5,
	category = "Stories"
}
params.debug_focal_scale = {
	value = 1,
	num_decimals = 5,
	category = "Stories"
}
params.force_hub_location_intros = {
	value = false,
	name = "Always show hub location introductions (hli)",
	category = "Stories"
}
params.ignore_journey = {
	value = false,
	category = "Game Flow"
}
params.skip_prologue = {
	category = "Game Flow",
	value = BUILD ~= "release"
}
params.show_game_states = {
	value = true,
	category = "Game Flow"
}
params.debug_ledge_finder_rays = {
	value = false,
	category = "Ledge Finder"
}
params.debug_ledge_finder_real_pos_rays = {
	value = false,
	category = "Ledge Finder"
}
params.debug_ledge_finder_angle_verification = {
	value = false,
	category = "Ledge Finder"
}
params.debug_visualize_ledge_finder_ledges = {
	value = false,
	category = "Ledge Finder"
}
params.debug_draw_ledge_finder_oobb_sweep = {
	value = false,
	category = "Ledge Finder"
}
params.debug_use_local_mission_board = {
	value = false,
	category = "Level & Mission"
}
params.debug_light_controllers = {
	value = false,
	category = "Level & Mission"
}
params.debug_weather_vfx = {
	value = false,
	category = "Level & Mission"
}
params.debug_world_interaction = {
	value = false,
	category = "Level & Mission"
}
params.debug_reportify = {
	value = false,
	category = "Level & Mission"
}
params.debug_liquid_area = {
	value = false,
	category = "Liquid Area",
	options = {
		false,
		"area",
		"area_and_neighbors"
	}
}
params.debug_liquid_area_paint_template = {
	value = "debug_paint",
	category = "Liquid Area",
	options_function = function ()
		local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")

		return table.keys(LiquidAreaTemplates)
	end
}
params.debug_liquid_area_vfx = {
	value = false,
	category = "Liquid Area"
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
	value = false,
	category = "Coherency"
}
params.coherency_show_other_coherency = {
	value = false,
	category = "Coherency"
}
params.coherency_log_coherency_events = {
	value = false,
	category = "Coherency"
}
params.disable_coherency_toughness_effect = {
	value = false,
	category = "Coherency"
}
params.premium_store_custom_time = {
	value = 0,
	hidden = true,
	category = "Micro Transaction (\"Premium\") Store"
}
params.unlock_all_shooting_range_enemies = {
	value = false,
	category = "Shooting Range"
}
params.trace_rumble_activation_events = {
	value = false,
	category = "Rumble & Haptics"
}
params.trace_haptics_activation_events = {
	value = false,
	category = "Rumble & Haptics"
}
params.debug_haptics = {
	value = false,
	category = "Rumble & Haptics"
}
params.debug_companion_movement = {
	value = false,
	category = "Companion"
}
params.debug_companion_points = {
	value = false,
	category = "Companion"
}
params.debug_companion_idle_state = {
	value = false,
	category = "Companion"
}
params.debug_companion_move_around_enemy_action = {
	value = false,
	category = "Companion"
}
params.debug_companion_leap_action = {
	value = false,
	category = "Companion"
}
params.companion_force_miss_target = {
	value = false,
	category = "Companion"
}
params.debug_companion_force_idle = {
	value = false,
	category = "Companion"
}
params.companion_show_target_weights = {
	value = false,
	category = "Companion"
}
params.companion_show_animation_movement_speed = {
	value = false,
	category = "Companion"
}
params.companion_show_animation_movement_speed_offset = {
	value = false,
	category = "Companion"
}
params.companion_debug_jump_off = {
	value = false,
	category = "Companion"
}
params.companion_log_leap_fail_reason = {
	value = false,
	category = "Companion"
}
params.companion_debug_unstuck_check = {
	value = false,
	category = "Companion"
}
params.debug_companion_hub_interaction_distance_to_player = {
	value = 2.25,
	category = "Companion",
	num_decimals = 2
}

local function _draw_broadphase_spheres_of_all_units_in_broadphase()
	local destructible_system = Managers.state.extension:system("destructible_system")

	if destructible_system then
		destructible_system:debug_draw_destructibles_in_broadphase()
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")

	if broadphase_system then
		broadphase_system:debug_draw_units_in_broadphase()
	end

	local hazard_prop_system = Managers.state.extension:system("hazard_prop_system")

	if hazard_prop_system then
		hazard_prop_system:debug_draw_props_in_broadphase()
	end
end

params.broadphase_use_seperate_query_for_destructibles = {
	value = true,
	category = "Explosion Rework Testing"
}
params.show_broadphase_sphere_upon_spawning = {
	value = false,
	category = "Explosion Rework Testing"
}
params.show_broadphase_spheres_for_explosion_targets = {
	value = false,
	category = "Explosion Rework Testing",
	on_value_set = function (new_value, old_value)
		if new_value then
			_draw_broadphase_spheres_of_all_units_in_broadphase()
			ParameterResolver.set_dev_parameter("show_broadphase_spheres_for_explosion_targets", false)
		end
	end
}
params.switch_to_explosion_physics_overlap = {
	value = false,
	category = "Explosion Rework Testing"
}
params.keep_empty_server_alive = {
	value = false
}
params.category_log_levels = {
	hidden = true,
	value = {
		"Log Internal",
		2
	}
}
params.max_external_time_step = {
	value = "Default",
	num_decimals = 1,
	options = {
		"Default",
		0.2,
		2,
		20
	},
	on_value_set = _set_max_external_time_step
}
params.debug_position_lookup = {
	value = false
}
params.stall_warnings_enabled = {
	value = true,
	on_value_set = function (new_value, old_value)
		Application.set_stall_warnings_enabled(new_value)
	end
}
params.disable_fade_system = {
	value = false
}
params.debug_material_queries = {
	value = false,
	options = {
		false,
		"both",
		"succeeded",
		"failed"
	}
}
params.debug_draw_footstep_decals = {
	value = false
}
params.networked_flow_state = {
	value = false
}
params.debug_print_world_text = {
	value = true
}
params.debug_join_hub_server = {
	value = false
}
params.debug_local_test_hub_server = {
	value = false
}
params.longer_psyker_force_field_duration = {
	value = false
}
params.show_equipped_items = {
	value = false
}
params.debug_gadget_extension = {
	value = false
}
params.disable_beast_of_nurgle_consumed_effect = {
	value = false
}
params.imgui_lua_inspector_input = {
	value = ""
}
params.auto_attach_debugger = {
	value = false
}

local function _set_build_override_parameter(parameter_name, value)
	local old_value = params[parameter_name].value

	params[parameter_name].value = value
end

_set_build_override_parameter("debug_change_time_scale", false)

return {
	enable_filter_by_defaults = true,
	parameters = params,
	categories = categories
}
