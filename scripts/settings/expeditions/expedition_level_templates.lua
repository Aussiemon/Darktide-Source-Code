-- chunkname: @scripts/settings/expeditions/expedition_level_templates.lua

local Expedition = require("scripts/utilities/expedition")

local function _special_tags_contains(special_tags, slot_id, tag)
	if special_tags and special_tags[slot_id] ~= nil then
		for i = 1, #special_tags[slot_id] do
			if special_tags[slot_id][i] == tag then
				return true
			end
		end
	end

	return false
end

local level_templates = {
	level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
	},
	arrival_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local custom_data = level_data.custom_data
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.arrival_unit = level_slot_unit
		end,
	},
	procgen_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		on_gameplay_resume_function = function (level_data, belongs_to_current_safe_zone_section)
			local section = level_data.section
			local entrance_level = section.connector_entrance_level
			local exit_level = section.connector_exit_level

			Level.trigger_event(entrance_level, "event_is_location_entrance")
			Unit.flow_event(section.connector_exit_unit, "lua_is_level_exit")
			Level.trigger_event(exit_level, "event_is_location_exit")
			Level.trigger_event(entrance_level, "event_players_entered_location")
		end,
		on_registered_function = function (level_data, world)
			return
		end,
	},
	safe_zone_connector_entrance_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return in_safe_zone and belongs_to_current_safe_zone_section
		end,
		on_gameplay_pause_function = function (level_data, belongs_to_current_safe_zone_section, is_hotjoin)
			if belongs_to_current_safe_zone_section then
				local level = level_data.level

				if not is_hotjoin then
					Level.trigger_event(level, "event_players_entered_safe_zone")
				end
			end
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_safe_zone_entrance")
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local safe_zone_level_data = Expedition.get_level_data_by_reference_name(section, "safe_zone_level")
			local safe_zone_level = safe_zone_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(safe_zone_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
	},
	safe_zone_connector_exit_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return in_safe_zone and belongs_to_current_safe_zone_section
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_safe_zone_exit")

			local section = level_data.section
			local safe_zone_level_data = Expedition.get_level_data_by_reference_name(section, "safe_zone_level")
			local safe_zone_level = safe_zone_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(safe_zone_level, level_slot_id)

			Unit.flow_event(level_slot_unit, "lua_is_safe_zone_level_exit")
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local custom_data = level_data.custom_data
			local safe_zone_level_data = Expedition.get_level_data_by_reference_name(section, "safe_zone_level")
			local parent_level = safe_zone_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.safe_zone_connector_exit_unit = level_slot_unit
			section.safe_zone_connector_exit_level = level_data.level

			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local safe_zone_level_data = Expedition.get_level_data_by_reference_name(section, "safe_zone_level")
			local safe_zone_level = safe_zone_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(safe_zone_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
	},
	connector_entrance_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		on_gameplay_resume_function = function (level_data, belongs_to_current_safe_zone_section)
			local level = level_data.level

			Level.trigger_event(level, "event_players_entered_location")
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_location_entrance")
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local custom_data = level_data.custom_data
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.connector_entrance_unit = level_slot_unit
			section.connector_entrance_level = level_data.level
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local wanted_rotation = Quaternion.multiply(Unit.world_rotation(level_slot_unit, 1), Quaternion.from_euler_angles_xyz(0, 0, 180))

			Unit.set_local_rotation(level_slot_unit, 1, wanted_rotation)
			World.update_unit(world, level_slot_unit)

			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
	},
	connector_exit_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_location_exit")

			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local level_index = Managers.state.unit_spawner:index_by_level(level_data.level)

			Managers.event:trigger("exit_level_spawned", level_index, position)
			Unit.flow_event(level_slot_unit, "lua_is_level_exit")
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local custom_data = level_data.custom_data
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.connector_exit_unit = level_slot_unit
			section.connector_exit_level = level_data.level
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
	},
	extraction_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local custom_data = level_data.custom_data
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.extraction_unit = level_slot_unit
			section.extraction_level = level_data.level
		end,
		on_registered_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local level_index = Managers.state.unit_spawner:index_by_level(level_data.level)

			Managers.event:trigger("extraction_level_spawned", level_index, position)
		end,
	},
	main_objective_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			return position, rotation
		end,
		pre_spawn_function = function (level_data, world)
			local level_name = level_data.level_name
			local excluded_object_sets = level_data.excluded_object_sets
			local object_set_names = LevelResource.object_set_names(level_name)

			if object_set_names and #object_set_names > 0 then
				local object_set_index_to_keep = Expedition.random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
	},
	opportunity_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			if level_data.tags and table.array_contains(level_data.tags, "rot_mode_random") and not _special_tags_contains(parent_level_data.special_tags, level_slot_id, "rot_mode_slot") then
				local random_rotation_degree = level_data.random_rotation_degree
				local random_rotation = Quaternion.from_euler_angles_xyz(0, 0, random_rotation_degree)

				rotation = Quaternion.multiply(rotation, random_rotation)
			end

			return position, rotation
		end,
		pre_spawn_function = function (level_data, world)
			local level_name = level_data.level_name
			local excluded_object_sets = level_data.excluded_object_sets
			local object_set_names = LevelResource.object_set_names(level_name)

			if object_set_names and #object_set_names > 0 then
				local object_set_index_to_keep = Expedition.random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
		on_registered_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local level_index = Managers.state.unit_spawner:index_by_level(level_data.level)
			local location_tags = level_data.tags
			local has_required_objective = location_tags and table.contains(location_tags, "required_objective") and true or false

			if has_required_objective then
				Managers.state.game_mode:game_mode():expedition_disable_transition_activators()
			end

			Managers.event:trigger("opportunity_level_spawned", level_index, position)
		end,
	},
	traversal_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = Expedition.get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local rotation = Unit.world_rotation(level_slot_unit, 1)

			if level_data.tags and table.array_contains(level_data.tags, "rot_mode_random") and not _special_tags_contains(parent_level_data.special_tags, level_slot_id, "rot_mode_slot") then
				local random_rotation_degree = level_data.random_rotation_degree
				local random_rotation = Quaternion.from_euler_angles_xyz(0, 0, random_rotation_degree)

				rotation = Quaternion.multiply(rotation, random_rotation)
			end

			return position, rotation
		end,
		pre_spawn_function = function (level_data, world)
			local level_name = level_data.level_name
			local excluded_object_sets = level_data.excluded_object_sets
			local object_set_names = LevelResource.object_set_names(level_name)

			if object_set_names and #object_set_names > 0 then
				local object_set_index_to_keep = Expedition.random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
	},
	toxic_gas = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return not in_safe_zone
		end,
		position_and_rotation_function = function (level_data, world)
			local custom_data = level_data.custom_data
			local position = Vector3.from_array(custom_data.position)
			local rotation = Quaternion.identity()
			local physics_world = World.physics_world(world)
			local to = Vector3(position.x, position.y, -100)
			local from = Vector3(position.x, position.y, 100)
			local to_target = to - from
			local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target)
			local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", "filter_player_mover")

			if hit_position then
				position = hit_position
			end

			return position, rotation
		end,
		pre_spawn_function = function (level_data, world)
			local level_name = level_data.level_name
			local excluded_object_sets = level_data.excluded_object_sets
			local object_set_names = LevelResource.object_set_names(level_name)

			if object_set_names and #object_set_names > 0 then
				local object_set_index_to_keep = Expedition.random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
	},
	safe_zone_level = {
		visibility_function = function (level_data, belongs_to_current_safe_zone_section, in_safe_zone)
			return in_safe_zone and belongs_to_current_safe_zone_section
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local level = level_data.level
			local custom_data = level_data.custom_data
			local entrance_level_slot_id = custom_data.entrance_level_slot_id
			local exit_level_slot_id = custom_data.exit_level_slot_id

			section.safe_zone_entrance_slot_unit = Level.unit_by_id(level, entrance_level_slot_id)
			section.safe_zone_exit_slot_unit = Level.unit_by_id(level, exit_level_slot_id)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local section_index = section.index
			local spawn_height = 0
			local position = section_index % 2 == 0 and Vector3(384, 384, spawn_height) or Vector3(-384, -384, spawn_height)
			local rotation = Quaternion.identity()

			return position, rotation
		end,
		on_registered_function = function (level_data, world)
			local section = level_data.section
			local level = level_data.level
			local level_units = Level.units(level)
			local custom_data = level_data.custom_data
			local store_info = custom_data.store_info
			local pickups = store_info.pickups
			local store_units = {}
			local safe_zone_respawn_beacons = {}

			for i = 1, #level_units do
				local unit = level_units[i]
				local unit_pickup_extension = unit and ScriptUnit.has_extension(unit, "pickup_system")

				if unit_pickup_extension and unit_pickup_extension:get_distribution_type() == "manual" then
					store_units[#store_units + 1] = unit
				else
					local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")
					local interaction_type = interactee_extension and interactee_extension:interaction_type()

					if pickups[interaction_type] then
						store_units[#store_units + 1] = unit
					else
						local pickup_type = Unit.get_data(unit, "pickup_type")

						if pickups[pickup_type] then
							store_units[#store_units + 1] = unit
						end
					end
				end

				local respawn_beacon_extension = unit and ScriptUnit.has_extension(unit, "respawn_beacon_system")

				if respawn_beacon_extension then
					safe_zone_respawn_beacons[unit] = respawn_beacon_extension
				end
			end

			section.store_units = store_units
			section.safe_zone_respawn_beacons = safe_zone_respawn_beacons
		end,
	},
	airstrike_level = {
		position_and_rotation_function = function (level_data, world)
			local position = Vector3(0, 0, 0)
			local rotation = Quaternion.identity()

			return position, rotation
		end,
	},
}

return level_templates
