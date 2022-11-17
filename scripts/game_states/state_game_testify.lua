local Breeds = require("scripts/settings/breed/breeds")
local MasterItems = require("scripts/backend/master_items")
local Missions = require("scripts/settings/mission/mission_templates")
local ParameterResolver = require("scripts/foundation/utilities/parameters/parameter_resolver")
local RenderSettings = require("scripts/settings/options/render_settings")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local world_create_particles = World.create_particles
local world_set_particles_life_time = World.set_particles_life_time

local function get_items_for_archetype(archetype, filtered_slots, workflow_states)
	local WORKFLOW_STATES = {
		"SHIPPABLE",
		"RELEASABLE",
		"FUNCTIONAL"
	}
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

			local testable = table.contains(WORKFLOW_STATES, item.workflow_state)

			if not testable then
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

local StateGameTestify = {
	action_rule = function (data)
		local action_name = data.action_name
		local input_service = data.input_service
		local action_rule = input_service:action_rule(action_name)

		return action_rule
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

		local weapons_slots = {
			"slot_primary",
			"slot_secondary"
		}
		local weapons = get_items_for_archetype(archetype, weapons_slots)

		return weapons
	end,
	all_gears = function (archetype, _)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local gears_slots = {
			"slot_gear_head",
			"slot_gear_lowerbody",
			"slot_gear_upperbody",
			"slot_gear_extra_cosmetic"
		}
		local gears = get_items_for_archetype(archetype, gears_slots)

		return gears
	end,
	slot_fallback_item = function (slot, _)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		local fallback_item = MasterItems.find_fallback_item_id(slot)

		return fallback_item
	end,
	all_items = function (_, _)
		if not MasterItems.has_data() then
			return Testify.RETRY
		end

		return MasterItems.get_cached()
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
	["as" .. "sert"] = function (assert_data, _)
		local context = {
			assert_data = assert_data
		}

		setfenv(func, context)
		func(assert_data)
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
	display_and_graphics_presets_settings = function ()
		local settings = RenderSettings.settings
		local render_settings = {}
		local i = 0

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
	mission_cutscenes = function (mission_name)
		local cutscenes = Missions[mission_name].cinematics

		return cutscenes
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
			end

			return Testify.RETRY
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
	skip_privacy_policy_popup_if_displayed = function (_, state_game)
		local current_state_name = state_game:current_state_name()

		if current_state_name == "StateTitle" then
			local state_machine = state_game:state_machine()
			local state_title = state_machine:current_state()
			local state_title_state = state_title:state()

			if state_title_state == "done" then
				return
			end

			if state_title_state == "legal_verification" then
				local constant_elements = Managers.ui:ui_constant_elements()
				local constant_element_popup_handler = constant_elements:element("ConstantElementPopupHandler")
				local widgets_by_name = constant_element_popup_handler:widgets_by_name()
				local accept_button = widgets_by_name.popup_widget_2

				if accept_button then
					constant_element_popup_handler:trigger_widget_callback(accept_button)

					return
				end
			end

			return Testify.RETRY
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
