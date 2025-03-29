-- chunkname: @scripts/game_states/state_game_testify.lua

local BotSpawning = require("scripts/managers/bot/bot_spawning")
local Breeds = require("scripts/settings/breed/breeds")
local MissionBuffsAllowedBuffs = require("scripts/managers/mission_buffs/mission_buffs_allowed_buffs")
local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local GameModeSettings = require("scripts/settings/game_mode/game_mode_settings")
local MasterItems = require("scripts/backend/master_items")
local MissionObjectives = require("scripts/settings/mission_objective/mission_objective_templates")
local Missions = require("scripts/settings/mission/mission_templates")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local RenderSettings = require("scripts/settings/options/render_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local application_console_command = Application.console_command
local application_memory_tree_to_console = Application.memory_tree_to_console
local unit_actor = Unit.actor
local unit_animation_event = Unit.animation_event
local unit_flow_event = Unit.flow_event
local world_create_particles = World.create_particles
local world_set_particles_life_time = World.set_particles_life_time
local world_unit_by_name = World.unit_by_name

local function _console_command(command, ...)
	application_console_command(command, ...)
end

local function retrieve_items_for_archetype(archetype, filtered_slots, workflow_states)
	local WORKFLOW_STATES = {
		"SHIPPABLE",
		"RELEASABLE",
		"FUNCTIONAL",
	}

	workflow_states = workflow_states and workflow_states or WORKFLOW_STATES

	local item_definitions = MasterItems.get_cached()
	local items = {}

	for item_name, item in pairs(item_definitions) do
		repeat
			local slots = item.slots
			local slot = slots and slots[1]

			if not table.contains(filtered_slots, slot) then
				break
			end

			local archetypes = item.archetypes

			if not archetypes or not table.contains(archetypes, archetype) then
				break
			end

			local is_item_stripped = true
			local strip_tags_table = Application.get_strip_tags_table()

			if table.size(item.feature_flags) == 0 then
				is_item_stripped = false
			else
				for _, feature_flag in pairs(item.feature_flags) do
					if strip_tags_table[feature_flag] == true then
						is_item_stripped = false

						break
					end
				end
			end

			if is_item_stripped then
				break
			end

			local filtered_workflow_states = table.contains(workflow_states, item.workflow_state)

			if not filtered_workflow_states then
				break
			end

			if items[slot] == nil then
				items[slot] = {}
			end

			items[slot][item_name] = item
		until true
	end

	return items
end

local _fill_with_hordes_buff_names_recursive

function _fill_with_hordes_buff_names_recursive(source, destination)
	for key, content in pairs(source) do
		if type(content) == "table" then
			_fill_with_hordes_buff_names_recursive(content, destination)
		else
			destination[content] = true
		end
	end
end

local StateGameTestify = {
	action_rule = function (_, data)
		local action_name = data.action_name
		local input_service = data.input_service
		local action_rule = input_service:action_rule(action_name)

		return action_rule
	end,
	all_breeds = function ()
		local breeds = {}

		for _, breed in pairs(Breeds) do
			local testify_flags = breed.testify_flags
			local flag = testify_flags and testify_flags.spawn_all_enemies

			if flag ~= false then
				table.insert(breeds, breed)
			end
		end

		return breeds
	end,
	all_gears = function (_, archetype, workflow_states)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local gears_slots = {
			"slot_gear_head",
			"slot_gear_lowerbody",
			"slot_gear_upperbody",
			"slot_gear_extra_cosmetic",
		}
		local gears = retrieve_items_for_archetype(archetype, gears_slots, workflow_states)

		return gears
	end,
	all_gears_per_slot = function (_, archetype, slot_name, workflow_states)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local gears_slots = {
			slot_name,
		}
		local gears = retrieve_items_for_archetype(archetype, gears_slots, workflow_states)

		return gears[slot_name]
	end,
	all_hordes_buffs_names = function ()
		local used_buff_names = {}
		local buff_families = MissionBuffsAllowedBuffs.buff_families

		for buff_family, buff_family_data in pairs(buff_families) do
			for _, buff_name in pairs(buff_family_data.priority_buffs) do
				used_buff_names[buff_name] = true
			end

			for _, buff_name in pairs(buff_family_data.buffs) do
				used_buff_names[buff_name] = true
			end
		end

		local legendary_buffs = MissionBuffsAllowedBuffs.legendary_buffs

		_fill_with_hordes_buff_names_recursive(legendary_buffs, used_buff_names)

		local results = {}

		for buff_name, _ in pairs(used_buff_names) do
			table.insert(results, buff_name)
		end

		table.sort(results)

		return results
	end,
	all_items = function ()
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		return MasterItems.get_cached()
	end,
	all_mission_flags = function (_, mission_key)
		local flags = {}

		for mission_name, mission_data in pairs(Missions) do
			if mission_name == mission_key then
				flags = mission_data.testify_flags
			end
		end

		return flags
	end,
	all_missions_with_flag_of_type = function (_, flag_type)
		local missions = {}

		for mission_name, mission_data in pairs(Missions) do
			local testify_flags = mission_data.testify_flags

			if testify_flags then
				local flag = testify_flags[flag_type]

				if flag ~= nil then
					missions[mission_name] = flag
				end
			end
		end

		return missions
	end,
	all_weapons = function (_, archetype)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local weapon_slots = {
			"slot_primary",
			"slot_secondary",
		}
		local weapons = retrieve_items_for_archetype(archetype, weapon_slots)

		return weapons
	end,
	change_dev_parameter = function (_, parameter)
		ParameterResolver.set_dev_parameter(parameter.name, parameter.value)
	end,
	circumstance_theme = function (_, circumstance_name)
		local circumstance_template = CircumstanceTemplates[circumstance_name]

		return circumstance_template.theme_tag
	end,
	circumstances = function ()
		return CircumstanceTemplates
	end,
	console_command_lua_trace = function ()
		_console_command("lua", "trace")
	end,
	console_command_memory_tree_formatted = function (_, depth, ascii_separator, memory_limit)
		_console_command("memory_tree", depth, ascii_separator, memory_limit)
	end,
	console_command_memory_resources_all = function (_)
		_console_command("memory_resources", "all")
	end,
	console_command_memory_resources_list = function (_, resource_name)
		_console_command("memory_resources", "list", resource_name)
	end,
	create_particles = function (_, world, particle_name, boxed_spawn_position, particle_life_time)
		Log.info("StateGameTestify", "Creating particle %s", particle_name)

		local spawn_position = boxed_spawn_position:unbox()
		local particle_id = world_create_particles(world, particle_name, spawn_position)

		world_set_particles_life_time(world, particle_id, particle_life_time)

		return particle_id
	end,
	create_telemetry_event = function (_, event_name, ...)
		local telemetry_events_manager = Managers.telemetry_events

		telemetry_events_manager[event_name](telemetry_events_manager, ...)
	end,
	current_state_name = function (state_game)
		local current_state_name = state_game:current_state_name()

		return current_state_name
	end,
	display_and_graphics_presets_settings = function ()
		local settings, render_settings, i = RenderSettings.settings, {}, 0

		for j = 1, #settings do
			if settings[j].display_name == "loc_settings_menu_group_graphics" then
				break
			elseif not settings[j].widget_type then
				i = i + 1
				render_settings[i] = settings[j]
			end
		end

		return render_settings
	end,
	load_mission = function (_, mission_context)
		local mission_settings = Missions[mission_context.mission_name]
		local mechanism_name = mission_settings.mechanism_name
		local game_mode_name = mission_settings.game_mode_name
		local game_mode_settings = GameModeSettings[game_mode_name]

		if game_mode_settings.host_singleplay then
			local multiplayer_session_manager = Managers.multiplayer_session

			multiplayer_session_manager:reset("Hosting singleplayer session from Testify")
			multiplayer_session_manager:boot_singleplayer_session()
		end

		local mechanism_manager = Managers.mechanism

		mechanism_manager:change_mechanism(mechanism_name, mission_context)
		mechanism_manager:trigger_event("all_players_ready")
	end,
	mechanism_name = function (_, mission_name)
		local mechanism_name = Missions[mission_name].mechanism_name

		return mechanism_name
	end,
	metadata_execute_query_deferred = function (_, type, include_properties)
		local query_handle = Metadata.execute_query_deferred(type, include_properties)

		return query_handle
	end,
	metadata_wait_for_query_results = function (_, query_handle)
		local results = Metadata.claim_results(query_handle)

		if not results then
			return Testify.RETRY
		end

		return results
	end,
	mission_cutscenes = function (_, mission_name)
		local cutscenes = Missions[mission_name].cinematics

		return cutscenes
	end,
	mission_themes = function (_, mission_name)
		local file_path = mission_name .. "_mission_themes"
		local themes = require(file_path)

		return themes
	end,
	mission_settings = function (_, mission_name)
		local settings = Missions[mission_name]

		return settings
	end,
	output_to_file = function (_, performance_measurements)
		local output_directory = "c:/performance_measurements"
		local date_and_time = os.date("%y_%m_%d-%H%M%S")
		local filename = "performance_measurements-" .. date_and_time .. ".txt"

		os.execute("mkdir -p " .. "\"" .. output_directory .. "\"")

		local filepath = output_directory .. "/" .. filename
		local filehandle = io.open(filepath, "w")

		for measurement_type, measurements in pairs(performance_measurements) do
			filehandle:write(measurement_type .. ":\n")

			for key, value in pairs(measurements) do
				filehandle:write(key .. ": " .. value .. "\n")
			end

			filehandle:write("\n")
		end

		filehandle:close()
	end,
	player_profile = function (_, player)
		local profile = player:profile()

		return profile
	end,
	register_timer = function (_, name, start_time)
		Managers.time:register_timer(name, "main", start_time)
	end,
	remove_best_bot = function ()
		BotSpawning.despawn_best_bot()
	end,
	set_autoload_enabled = function (_, is_enabled)
		Application.set_autoload_enabled(is_enabled)
	end,
	setting_on_activated = function (_, option_data)
		Log.info("StateGameTestify", "Changing render settings for %s, old value: %s, new value: %s", option_data.setting.display_name, option_data.old_value, option_data.new_value)
		option_data.setting.on_activated(option_data.new_value, option_data.setting)
	end,
	setting_value = function (_, setting)
		return setting.get_function(setting)
	end,
	side_missions = function ()
		local side_missions = MissionObjectives.side_mission.objectives

		return side_missions
	end,
	skip_splash_screen = function (state_game)
		local current_state_name = state_game:current_state_name()

		if current_state_name == "StateSplash" then
			local view_name = "splash_view"
			local view = Managers.ui:view_instance(view_name)
			local view_active = Managers.ui:view_active(view_name)

			if view and view_active then
				view:on_skip_pressed()
			end

			return Testify.RETRY
		end
	end,
	skip_title_screen = function (state_game)
		local current_state_name = state_game:current_state_name()

		if current_state_name == "StateSplash" then
			return Testify.RETRY
		elseif current_state_name == "StateTitle" then
			Managers.event:trigger("event_state_title_continue")
		end
	end,
	spawn_bot = function (_, profile_name)
		BotSpawning.spawn_bot_character(profile_name)
	end,
	take_a_screenshot = function (state_game, screenshot_settings)
		local type = "file_system"
		local window
		local scale = 1
		local save_depth = false
		local output_dir = screenshot_settings.output_dir
		local date_and_time = os.date("%y_%m_%d-%H%M")
		local filename = screenshot_settings.filename .. "-" .. date_and_time
		local filetype = screenshot_settings.filetype

		os.execute("mkdir -p " .. "\"" .. output_dir .. "\"")
		FrameCapture.screen_shot(type, window, scale, output_dir, filename, filetype, save_depth)
	end,
	time = function (_, name)
		local time = Managers.time:time(name)

		return time
	end,
	trigger_unit_animation_event = function (_, unit, animation_event)
		unit_animation_event(unit, animation_event)
	end,
	unit_actor = function (_, unit, actor_name)
		local actor = unit_actor(unit, actor_name)

		return actor
	end,
	unit_flow_event = function (_, unit, flow_event_name)
		Log.info("StateGameTestify", "Triggering flow event %s", flow_event_name)
		unit_flow_event(unit, flow_event_name)
	end,
	unregister_timer = function (_, name)
		Managers.time:unregister_timer(name)
	end,
	wait_for_promise = function (_, promise)
		local promise_state = promise.state

		if promise_state == "pending" then
			return Testify.RETRY
		end
	end,
	weapon = function (_, name)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local item_definitions = MasterItems.get_cached()

		return item_definitions[name]
	end,
	weapon_template = function (_, weapon)
		local weapon_template = WeaponTemplate.weapon_template_from_item(weapon)

		return weapon_template
	end,
	world = function ()
		local world = Managers.world:world("level_world")

		return world
	end,
	world_unit_by_name = function (_, world, unit_name)
		local unit = world_unit_by_name(world, unit_name)

		return unit
	end,
}

return StateGameTestify
