local Breeds = require("scripts/settings/breed/breeds")
local ErrorTestify = require("scripts/foundation/utilities/error_testify")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local RenderSettings = require("scripts/settings/options/render_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local world_create_particles = World.create_particles
local world_set_particles_life_time = World.set_particles_life_time
local StateGameTestify = {
	action_rule = function (data)
		local action_name = data.action_name
		local input_service = data.input_service
		local action_rule = input_service:action_rule(action_name)

		return action_rule
	end,
	activate_debug_function = function (debug_data, _)
		local debug_function = debug_data.debug_function
		local params = debug_data.params

		for _, entry in pairs(DebugFunctions.parameters) do
			if entry.name == debug_function then
				entry.on_activated(params)

				break
			end
		end
	end,
	all_breeds = function (_, _)
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
	all_mission_flags = function (mission_key, _)
		local flags = {}

		for mission_name, mission_data in pairs(Missions) do
			if mission_name == mission_key then
				flags = mission_data.testify_flags
			end
		end

		return flags
	end,
	all_missions_with_flag_of_type = function (flag_type, _)
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
	all_weapons = function (archetype, _)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local SLOT_PRIMARY = "slot_primary"
		local SLOT_SECONDARY = "slot_secondary"
		local item_definitions = MasterItems.get_cached()
		local weapons = {
			slot_primary = {},
			slot_secondary = {}
		}

		for item_name, item in pairs(item_definitions) do
			repeat
				local slots = item.slots
				local slot = slots and slots[1]

				if slot ~= SLOT_PRIMARY and slot ~= SLOT_SECONDARY then
					break
				end

				local archetypes = item.archetypes

				if not archetypes or not table.contains(archetypes, archetype) then
					break
				end

				local testable = item.workflow_state == "FUNCTIONAL" or item.workflow_state == "SHIPPABLE" or item.workflow_state == "RELEASABLE"

				if not testable then
					break
				end

				weapons[slot][item_name] = item
			until true
		end

		return weapons
	end,
	current_state_name = function (_, state_game)
		local current_state_name = state_game:current_state_name()

		return current_state_name
	end,
	get_weapon = function (name, _)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local item_definitions = MasterItems.get_cached()

		return item_definitions[name]
	end,
	assert = function (assert_data, _)
		ErrorTestify[assert_data.assert](assert_data.condition, assert_data.message)
	end,
	log_size_assert = function (assert_data)
		ErrorTestify.log_size_assert(assert_data.condition, assert_data.message)
	end,
	num_peers_assert = function (assert_data)
		ErrorTestify.num_peers_assert(assert_data.condition, assert_data.message)
	end,
	performance_cameras_assert = function (assert_data)
		ErrorTestify.performance_cameras_assert(assert_data.condition, assert_data.message)
	end,
	player_died_assert = function (assert_data)
		ErrorTestify.player_died_assert(assert_data.condition, assert_data.message)
	end,
	change_dev_parameter = function (parameter, _)
		ParameterResolver.set_dev_parameter(parameter.name, parameter.value)
	end,
	create_particles = function (world, particle_name, boxed_spawn_position, particle_life_time)
		Log.info("StateGameTestify", "Creating particle %s", particle_name)

		local spawn_position = boxed_spawn_position:unbox()
		local particle_id = world_create_particles(world, particle_name, spawn_position)

		world_set_particles_life_time(world, particle_id, particle_life_time)

		return particle_id
	end,
	debug_function_first_option = function (debug_function, _)
		for _, entry in pairs(DebugFunctions.parameters) do
			if entry.name == debug_function then
				local options = entry.options_function()
				local _, first_option = next(options)

				return first_option
			end
		end
	end,
	display_and_graphics_presets_settings = function ()
		local settings = RenderSettings.settings
		local render_settings = {}
		local i = 0

		for j = 1, #settings, 1 do
			if settings[j].display_name == "loc_settings_menu_group_graphics" then
				break
			elseif not settings[j].widget_type then
				i = i + 1
				render_settings[i] = settings[j]
			end
		end

		return render_settings
	end,
	metadata_execute_query_deferred = function (type, include_properties)
		local query_handle = Metadata.execute_query_deferred(type, include_properties)

		return query_handle
	end,
	metadata_wait_for_query_results = function (query_handle)
		local results = Metadata.claim_results(query_handle)

		if not results then
			return Testify.RETRY
		end

		return results
	end,
	player_profile = function (player)
		local profile = player:profile()

		return profile
	end,
	set_autoload_enabled = function (is_enabled)
		Application.set_autoload_enabled(is_enabled)
	end,
	setting_on_activated = function (option_data)
		Log.info("StateGameTestify", "Changing render settings for %s, old value: %s, new value: %s", option_data.setting.display_name, option_data.old_value, option_data.new_value)
		option_data.setting.on_activated(option_data.new_value)
	end,
	setting_value = function (setting)
		return setting.get_function()
	end,
	skip_splash_screen = function (_, state_game)
		local current_state_name = state_game:current_state_name()

		if current_state_name == "StateSplash" then
			local view_name = "splash_view"
			local view = Managers.ui:view_instance(view_name)
			local view_active = Managers.ui:view_active(view_name)

			if view and view_active then
				view:on_skip_pressed()

				return Testify.RETRY
			else
				return Testify.RETRY
			end
		end
	end,
	skip_title_screen = function (_, state_game)
		local current_state_name = state_game:current_state_name()

		if current_state_name == "StateSplash" then
			return Testify.RETRY
		elseif current_state_name == "StateTitle" then
			Managers.event:trigger("event_state_title_continue")
		end
	end,
	weapon_template = function (weapon)
		local weapon_template = WeaponTemplate.weapon_template_from_item(weapon)

		return weapon_template
	end,
	world = function ()
		local world = Managers.world:world("level_world")

		return world
	end
}

return StateGameTestify
