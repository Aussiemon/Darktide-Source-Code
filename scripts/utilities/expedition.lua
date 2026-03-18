-- chunkname: @scripts/utilities/expedition.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local LevelGridUtilities = require("scripts/utilities/levels/level_grid")
local Pickups = require("scripts/settings/pickup/pickups")
local ExpeditionEventSettings = require("scripts/settings/expeditions/expedition_event_settings")
local ENABLE_LOGS = true
local Expedition = {}
local SEED = 2023062419930608

local function _random(...)
	local seed, value = math.next_random(SEED, ...)

	SEED = seed

	return value
end

local function get_masterdata_by_levels(raw_query)
	local query_handle = Metadata.prepare_query({
		type = "level",
	}, {
		include_properties = true,
	}, {
		raw_query = raw_query,
	})
	local resources = Metadata.execute_query(query_handle)
	local sorted_data = {}

	for k, v in pairs(resources) do
		table.insert(sorted_data, {
			k,
			v,
		})
	end

	table.sort(sorted_data, function (p1, p2)
		return p1[1] < p2[1]
	end)

	local results_by_level = {}

	for _, p in ipairs(sorted_data) do
		local k, v = unpack(p)
		local decode

		if not v or v == "" then
			-- Nothing
		else
			decode = cjson.decode(v)
			results_by_level[k] = decode
		end
	end

	return results_by_level
end

local function fetch_levels_tags_from_metadata(strip_debug)
	local raw_query = "AND json_extract(properties, '$.tags.expedition') IS NOT NULL"
	local masterdata_by_levels = get_masterdata_by_levels(raw_query)
	local tags_by_level_name = {}

	for level_name, data in pairs(masterdata_by_levels) do
		repeat
			local level_slot_tags = data.tags and data.tags.expedition

			if level_slot_tags then
				local new_tag_list = {}

				for tag, _ in pairs(level_slot_tags) do
					new_tag_list[#new_tag_list + 1] = tag
				end

				if strip_debug and table.contains(new_tag_list, "biome_debug") then
					break
				end

				if string.find(level_name, "template") then
					break
				end

				table.sort(new_tag_list)

				tags_by_level_name[level_name] = new_tag_list
			end
		until true
	end

	return tags_by_level_name
end

local function fetch_levels_slots_data_from_metadata(ignored_level_slot_tags)
	local raw_query = "AND json_extract(properties, '$.expedition') IS NOT NULL"
	local masterdata_by_levels = get_masterdata_by_levels(raw_query)
	local slot_tags_by_level_name = {}

	for level_name, data in pairs(masterdata_by_levels) do
		local level_slots_tags = data.expedition

		if level_slots_tags then
			slot_tags_by_level_name[level_name] = level_slots_tags

			for slot_id, tags in pairs(level_slots_tags) do
				for i = 1, #ignored_level_slot_tags do
					local tag_to_ignore = ignored_level_slot_tags[i]
					local contains_at_index = table.index_of(tags, tag_to_ignore)

					if contains_at_index and contains_at_index > 0 then
						table.remove(tags, contains_at_index)
					end
				end
			end
		end
	end

	return slot_tags_by_level_name
end

local function _get_level_data_by_reference_name(section, reference_name)
	local levels_data = section.levels_data

	for i = 1, #levels_data do
		local level_data = levels_data[i]

		if level_data.reference_name == reference_name then
			return level_data
		end
	end
end

local function _on_register_world_marker_spawned(level_data, unit, id)
	local world_markers = level_data.world_markers
	local world_markers_by_unit = level_data.world_markers_by_unit

	world_markers[#world_markers + 1] = id

	if unit then
		world_markers_by_unit[unit] = id
	end
end

local function _is_tags_included_in_array(tags, taget_tags)
	local contains_all_tags = false

	for _, tag in ipairs(tags) do
		if table.contains(taget_tags, tag) then
			contains_all_tags = true
		else
			contains_all_tags = false

			break
		end
	end

	return contains_all_tags
end

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

local function get_levels_by_slot_distribution_config(settings, slot_distribution, level_slots, tags_by_level_name)
	local return_data = {}

	slot_distribution = table.clone_instance(slot_distribution)

	local spawn_conditions_met = false
	local level_slot_distribution_phase = 1
	local tags_depleted = {}

	local function make_tag_array_string(tag_array)
		local str = ""

		for _, tag in ipairs(tag_array) do
			str = str .. "[" .. tag .. "] "
		end

		return str
	end

	local level_names_array = table.keys(tags_by_level_name)

	table.sort(level_names_array)

	SEED = table.shuffle(level_names_array, SEED)

	local total_spawn_amount = 0
	local phases = slot_distribution.phases
	local complete_conditions = slot_distribution.complete_conditions
	local min_spawn = complete_conditions.min
	local max_spawn = complete_conditions.max
	local wanted_spawn_amount = _random(min_spawn, max_spawn)
	local level_slot_ids = table.keys(level_slots)

	table.sort(level_slot_ids)

	SEED = table.shuffle(level_slot_ids, SEED)

	local level_slots_size = table.size(level_slots)

	wanted_spawn_amount = math.clamp(wanted_spawn_amount, min_spawn, level_slots_size)

	if ENABLE_LOGS then
		Log.info("Expedition - get_levels_by_slot_distribution_config:", "Num available levels with tags: " .. tostring(#level_names_array))
		Log.info("Expedition - get_levels_by_slot_distribution_config:", "Num available level slots: " .. tostring(level_slots_size))
	end

	local sorted_distribution_phase = {}

	while not spawn_conditions_met do
		if table.size(level_slots) <= 0 then
			spawn_conditions_met = true

			if ENABLE_LOGS then
				Log.info("Expedition", "Level slots are now depeleted. Managed to spawn: " .. total_spawn_amount .. " levels.")
			end
		end

		local phase_data = phases[level_slot_distribution_phase]

		if not phase_data.done then
			if ENABLE_LOGS then
				Log.info("Expedition", "Proccessing DSL distribution phase [" .. level_slot_distribution_phase .. "] - Available slots left: " .. table.size(level_slots) .. ". Goal to spawn " .. wanted_spawn_amount - total_spawn_amount .. " levels.")
			end

			table.clear(sorted_distribution_phase)

			local total_order_score = 0

			for _, data in ipairs(phase_data) do
				total_order_score = total_order_score + data.order_score
			end

			local current_order_index = 1

			for k = 1, #phase_data do
				local random_score = _random(1, total_order_score)

				total_order_score = 0

				for _, data in ipairs(phase_data) do
					local order_score = data.order_score or 1

					if not table.contains(sorted_distribution_phase, data) then
						if random_score <= total_order_score + order_score then
							data.order = current_order_index
							current_order_index = current_order_index + 1
							sorted_distribution_phase[#sorted_distribution_phase + 1] = data
							random_score = math.huge

							if ENABLE_LOGS then
								Log.info("Expedition", "Phase entry: " .. _ .. " with order score: " .. order_score .. " will now be handled as number: " .. #sorted_distribution_phase .. " in order.")
							end
						else
							total_order_score = total_order_score + order_score
						end
					end
				end
			end

			for _, entry in ipairs(sorted_distribution_phase) do
				local total_spawn_amount_left = wanted_spawn_amount - total_spawn_amount
				local tags = entry.tags
				local optional_resource_tags = entry.optional_resource_tags
				local min = entry.min
				local max = entry.max
				local requires_everything_spawned = entry.requires_everything_spawned
				local consume_level_on_spawn_per_expedition = entry.consume_level_on_spawn_per_expedition or false
				local consume_level_on_spawn_per_location = entry.consume_level_on_spawn_per_location or false
				local tags_string = make_tag_array_string(tags)
				local spawn_amount = _random(min, max)

				spawn_amount = math.clamp(spawn_amount, 0, total_spawn_amount_left)

				if not tags_depleted[tags_string] then
					local num_spawns = 0
					local phase_return_data = {}

					for j = 1, spawn_amount do
						local wanted_level_slot_id, wanted_level_slot_tags
						local matching_slot_levels = {}

						for i = #level_slot_ids, 1, -1 do
							local level_slot_id = level_slot_ids[i]
							local slot_tags = level_slots[level_slot_id]

							if _is_tags_included_in_array(tags, slot_tags) then
								wanted_level_slot_id = level_slot_id
								wanted_level_slot_tags = table.clone_instance(slot_tags)

								local level_tags_by_type = settings.level_tags_by_type
								local type_tags = level_tags_by_type.type

								for k = #type_tags, 1, -1 do
									local type_tag = type_tags[k]
									local tag_index = table.index_of(wanted_level_slot_tags, type_tag)

									if tag_index > 0 and not table.contains(tags, type_tag) then
										table.remove(wanted_level_slot_tags, tag_index)
									end
								end

								local biome_tags = level_tags_by_type.biome

								if biome_tags then
									for k = #biome_tags, 1, -1 do
										local type_tag = biome_tags[k]
										local tag_index = table.index_of(wanted_level_slot_tags, type_tag)

										if tag_index > 0 and not table.contains(tags, type_tag) then
											table.remove(wanted_level_slot_tags, tag_index)
										end
									end
								end

								for _, level_name in ipairs(level_names_array) do
									local level_tags = tags_by_level_name[level_name]

									if _is_tags_included_in_array(optional_resource_tags or wanted_level_slot_tags, level_tags) then
										matching_slot_levels[#matching_slot_levels + 1] = {
											level_name = level_name,
											level_tags = level_tags,
										}
									end
								end

								if #matching_slot_levels > 0 then
									break
								else
									table.clear(matching_slot_levels)
								end
							end
						end

						if wanted_level_slot_id then
							local wanted_level_name, wanted_level_name_tags

							if #matching_slot_levels > 0 then
								local random_level_index = _random(1, #matching_slot_levels)
								local matching_slot_level = matching_slot_levels[random_level_index]

								wanted_level_name = matching_slot_level.level_name
								wanted_level_name_tags = matching_slot_level.level_tags
							elseif ENABLE_LOGS then
								Log.info("Expedition", "Did not find any level slot tags: " .. make_tag_array_string(wanted_level_slot_tags))
							end

							if wanted_level_name then
								level_slots[wanted_level_slot_id] = nil

								local level_slot_id_index = table.find(level_slot_ids, wanted_level_slot_id)

								table.remove(level_slot_ids, level_slot_id_index)

								if consume_level_on_spawn_per_location or consume_level_on_spawn_per_expedition then
									tags_by_level_name[wanted_level_name] = nil

									local level_array_index = table.find(level_names_array, wanted_level_name)

									table.remove(level_names_array, level_array_index)
								end

								total_spawn_amount = total_spawn_amount + 1
								num_spawns = num_spawns + 1
								phase_return_data[#phase_return_data + 1] = {
									level_slot_id = wanted_level_slot_id,
									level_name = wanted_level_name,
									level_tags = wanted_level_name_tags,
									consume_level_on_spawn_per_expedition = entry.consume_level_on_spawn_per_expedition or false,
									consume_level_on_spawn_per_location = entry.consume_level_on_spawn_per_location or false,
								}
							end
						end

						local level_slots_depleted = table.size(level_slots) == 0
						local wanted_spawn_amount_met = wanted_spawn_amount == total_spawn_amount

						if requires_everything_spawned and (level_slots_depleted or j == spawn_amount and not wanted_spawn_amount_met) then
							table.clear(phase_return_data)
						end

						if wanted_spawn_amount_met or level_slots_depleted then
							break
						end
					end

					table.append(return_data, phase_return_data)

					if ENABLE_LOGS then
						Log.info("Expedition", "(" .. _ .. "/" .. #sorted_distribution_phase .. ")" .. " - Distribution part is now done for tags " .. tags_string .. ". Min/Max Spawn ranges: " .. min .. "-" .. max .. ". Wanted spawn amount: " .. spawn_amount .. ". Completed spawn amount: " .. num_spawns)
					end

					if spawn_amount > 0 and num_spawns < spawn_amount then
						if not requires_everything_spawned then
							tags_depleted[tags_string] = true
						end

						entry.done = true

						if ENABLE_LOGS then
							Log.info("Expedition", "-- Slots for tags " .. tags_string .. "are now depleted --")
						end
					end

					if ENABLE_LOGS and wanted_spawn_amount == total_spawn_amount then
						Log.info("Expedition", "Spawn goal of " .. total_spawn_amount .. " are now reached!")
					end
				else
					entry.done = true
				end
			end

			local phase_is_depleted = true

			for _, entry in ipairs(sorted_distribution_phase) do
				if not entry.done then
					phase_is_depleted = false

					break
				end
			end

			if phase_is_depleted then
				if ENABLE_LOGS then
					Log.info("Expedition", "Phase depleted")
				end

				sorted_distribution_phase.done = true
				phase_data.done = true
			end
		end

		local is_all_phases_done = true

		if not spawn_conditions_met then
			for _, phase in ipairs(phases) do
				if not phase.done then
					is_all_phases_done = false

					break
				end
			end

			if is_all_phases_done then
				spawn_conditions_met = true
			end
		end

		if table.size(level_slots) == 0 or wanted_spawn_amount == total_spawn_amount then
			spawn_conditions_met = true
		end

		if spawn_conditions_met then
			if ENABLE_LOGS then
				Log.info("Expedition", "ALL PHASES DEPLETED - Total amount spawned: " .. total_spawn_amount .. ". Available slots left for DSL spawns: " .. table.size(level_slots))
			end

			break
		else
			level_slot_distribution_phase = level_slot_distribution_phase % #phases + 1
		end
	end

	if ENABLE_LOGS then
		Log.info("Expedition", "////////////////////////////////////////////////////////////////////////////")
		Log.info("Expedition", "////////////////////////////////// DONE ////////////////////////////////////")
		Log.info("Expedition", "////////////////////////////////////////////////////////////////////////////")
	end

	return return_data
end

local function _in_expedition_safe_zone()
	local game_mode_manager = Managers.state.game_mode

	if game_mode_manager then
		local game_mode = game_mode_manager:game_mode()

		if game_mode.in_safe_zone then
			return game_mode:in_safe_zone()
		end
	end

	return false
end

local level_spawn_template = {
	level = {
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		on_teleport_players_to_safe_zone_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		on_spawned_function = function (level_data, world, settings)
			if _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
	},
	arrival_level = {
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.arrival_unit = level_slot_unit

			if _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
	},
	safe_zone_connector_entrance_level = {
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_players_entered_safe_zone")
			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_spawned_function = function (level_data, world, settings)
			if not _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_safe_zone_entrance")
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local safe_zone_level_data = _get_level_data_by_reference_name(section, "safe_zone_level")
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
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_safe_zone_exit")

			local section = level_data.section
			local safe_zone_level_data = _get_level_data_by_reference_name(section, "safe_zone_level")
			local safe_zone_level = safe_zone_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(safe_zone_level, level_slot_id)

			Unit.flow_event(level_slot_unit, "lua_is_safe_zone_level_exit")
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section

			section.safe_zone_connector_exit_level = level_data.level

			if not _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local safe_zone_level_data = _get_level_data_by_reference_name(section, "safe_zone_level")
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
		on_gameplay_resume_function = function (level_data, world, expedition)
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
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.connector_entrance_unit = level_slot_unit
			section.connector_entrance_level = level_data.level
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
		on_registered_function = function (level_data, world)
			local level = level_data.level

			Level.trigger_event(level, "event_is_location_exit")

			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.connector_exit_unit = level_slot_unit
			section.connector_exit_level = level_data.level
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)

			section.extraction_unit = level_slot_unit

			if _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
		on_registered_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
				local object_set_index_to_keep = _random(1, #object_set_names)

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
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
				local object_set_index_to_keep = _random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
		on_spawned_function = function (level_data, world, settings)
			if _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
		on_registered_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
			local parent_level = parent_level_data.level
			local custom_data = level_data.custom_data
			local level_slot_id = custom_data.level_slot_id
			local level_slot_unit = Level.unit_by_id(parent_level, level_slot_id)
			local position = Unit.world_position(level_slot_unit, 1)
			local level_index = Managers.state.unit_spawner:index_by_level(level_data.level)

			Managers.event:trigger("opportunity_level_spawned", level_index, position)
		end,
	},
	traversal_level = {
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
			local parent_level_reference_name = level_data.parent_level_reference_name or "level"
			local parent_level_data = _get_level_data_by_reference_name(section, parent_level_reference_name)
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
				local object_set_index_to_keep = _random(1, #object_set_names)

				for i = 1, #object_set_names do
					if i ~= object_set_index_to_keep then
						local object_set_name = object_set_names[i]

						excluded_object_sets[#excluded_object_sets + 1] = object_set_name
					end
				end
			end
		end,
		on_spawned_function = function (level_data, world, settings)
			if _in_expedition_safe_zone() then
				local level = level_data.level

				Level.set_lod_level_type(level, LodLevelType.HIDE)
			end
		end,
	},
	toxic_gas = {
		on_spawned_function = function (level_data, world)
			return
		end,
		position_and_rotation_function = function (level_data, world)
			local section = level_data.section
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
				local object_set_index_to_keep = _random(1, #object_set_names)

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
		on_gameplay_resume_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.HIDE)
		end,
		on_gameplay_pause_function = function (level_data, world)
			local level = level_data.level

			Level.set_lod_level_type(level, LodLevelType.SHOW_LEVEL)
		end,
		on_spawned_function = function (level_data, world, settings)
			local section = level_data.section
			local level = level_data.level
			local custom_data = level_data.custom_data
			local entrance_level_slot_id = custom_data.entrance_level_slot_id
			local exit_level_slot_id = custom_data.exit_level_slot_id

			section.safe_zone_entrance_slot_unit = Level.unit_by_id(level, entrance_level_slot_id)
			section.safe_zone_exit_slot_unit = Level.unit_by_id(level, exit_level_slot_id)

			Level.set_lod_level_type(level, LodLevelType.HIDE)
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
			end

			section.store_units = store_units
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

Expedition.get_level_template_by_type = function (level_type)
	return level_spawn_template[level_type]
end

Expedition.initialize_layout_instance = function (layout_config)
	local layout = table.clone_instance(layout_config)

	for _, instance in ipairs(layout) do
		instance.players_purchases = {}

		local levels_data = instance.levels_data

		for level_index, level_data in ipairs(levels_data) do
			level_data.section = instance
			level_data.world_markers = {}
			level_data.world_markers_by_unit = {}
			level_data.level_loader = nil
			level_data.despawned = false
			level_data.spawned = false
			level_data.level_id = nil
			level_data.level = nil
			level_data.excluded_object_sets = {}
			level_data.level_loaders = {}
		end
	end

	return layout
end

Expedition.get_expedition_config_layout = function (config_name)
	local ExpeditionGenerator = require("scripts/settings/expeditions/expedition_generator")

	return ExpeditionGenerator.load_local_config_file(config_name)
end

Expedition.generate_expedition_layout = function (settings, seed, optional_section_amount, debug_generate, circumstance_name)
	Log.debug("Expedition", "Layout generated with seed %s", seed)

	SEED = seed

	local location_levels = table.clone_instance(settings.location_levels)

	SEED = table.shuffle(location_levels, SEED)

	local circumstance_event_list, circumstance_theme_tag, circumstance_template

	if circumstance_name and circumstance_name ~= "default" then
		circumstance_template = CircumstanceTemplates[circumstance_name]
		circumstance_theme_tag = circumstance_template.theme_tag
		circumstance_event_list = circumstance_template.expedition_events
	end

	local theme_tags = settings.theme_tags
	local template_events = settings.events
	local store_info = settings.store_info
	local strip_debug = not settings.debug_levels
	local tags_by_level_name_source = fetch_levels_tags_from_metadata(strip_debug)
	local ignored_level_slot_tags = settings.ignored_level_slot_tags
	local slot_tags_by_level_name = table.clone_instance(fetch_levels_slots_data_from_metadata(ignored_level_slot_tags))
	local safe_zone_levels_lookup = settings.safe_zone_levels
	local safe_zone_levels = table.clone_instance(safe_zone_levels_lookup)

	table.sort(safe_zone_levels)

	SEED = table.shuffle(safe_zone_levels, SEED)

	local allowed_dsl_levels = settings.allowed_dsl_levels

	if allowed_dsl_levels and #allowed_dsl_levels > 0 then
		for level_name, tags in pairs(tags_by_level_name_source) do
			if not table.contains(allowed_dsl_levels, level_name) then
				tags_by_level_name_source[level_name] = nil
			end
		end
	end

	local blocked_dsl_levels = settings.blocked_dsl_levels

	if blocked_dsl_levels and #blocked_dsl_levels > 0 then
		for level_name, tags in pairs(tags_by_level_name_source) do
			if table.contains(blocked_dsl_levels, level_name) then
				tags_by_level_name_source[level_name] = nil
			end
		end
	end

	local special_tags_by_level_name = {}
	local special_level_slot_tags = settings.special_level_slot_tags

	if special_level_slot_tags then
		for level_name, level_slots_tags in pairs(slot_tags_by_level_name) do
			if special_tags_by_level_name[level_name] == nil then
				special_tags_by_level_name[level_name] = {}
			end

			for slot_id, tags in pairs(level_slots_tags) do
				local special_tags = {}

				for i = 1, #special_level_slot_tags do
					local special_tag = special_level_slot_tags[i]
					local contains_at_index = table.index_of(tags, special_tag)

					if contains_at_index and contains_at_index > 0 then
						special_tags[#special_tags + 1] = special_tag

						table.remove(tags, contains_at_index)
					end
				end

				if #special_tags > 0 then
					special_tags_by_level_name[level_name][slot_id] = special_tags
				end
			end
		end
	end

	local spawn_tags_by_level_name = {}
	local slot_distribution_by_level_tag = settings.slot_distribution_by_level_tag

	if slot_distribution_by_level_tag then
		for level_name, tags in pairs(tags_by_level_name_source) do
			for slot_distribution_tag, _ in pairs(slot_distribution_by_level_tag) do
				if table.contains(tags, slot_distribution_tag) then
					if not spawn_tags_by_level_name[level_name] then
						spawn_tags_by_level_name[level_name] = {}
					end

					local spawn_tags = spawn_tags_by_level_name[level_name]

					spawn_tags[#spawn_tags + 1] = slot_distribution_tag

					local tag_index = table.index_of(tags, slot_distribution_tag)

					table.remove(tags, tag_index)
				end
			end
		end
	end

	local generated_layout = {}

	generated_layout.seed = seed

	local num_sections = optional_section_amount or settings.default_session_location_amount
	local expedition_level_id = 99
	local connector_levels_by_chunk = {}

	for i = 1, num_sections do
		local levels = {}
		local level_names = table.keys(tags_by_level_name_source)

		table.sort(level_names)

		SEED = table.shuffle(level_names, SEED)

		for _, level_name in ipairs(level_names) do
			local level_tags = tags_by_level_name_source[level_name]

			if table.contains(level_tags, "type_transition") then
				levels[#levels + 1] = level_name
				levels[#levels + 1] = level_name

				if #levels == 2 then
					break
				end
			end
		end

		connector_levels_by_chunk[#connector_levels_by_chunk + 1] = {
			entrance = i > 1 and table.remove(levels, 1),
			exit = i < num_sections and table.remove(levels, 1),
		}
	end

	for i = 1, num_sections do
		local events = circumstance_event_list or {}

		if not circumstance_event_list and template_events then
			local num_events = settings.max_events_per_location or 1
			local template_events_copy = table.clone_instance(template_events)

			for j = 1, num_events do
				if #template_events_copy == 0 then
					break
				end

				local event_index = _random(1, #template_events_copy)

				events[#events + 1] = template_events_copy[event_index]

				table.remove(template_events_copy, event_index)
			end
		end

		local tags_by_level_name = table.clone_instance(tags_by_level_name_source)
		local section_slot_tags_by_level_name = table.clone_instance(slot_tags_by_level_name)
		local location_index = (i - 1) % #location_levels + 1
		local location_level_name = location_levels[location_index]
		local theme_tag = circumstance_theme_tag

		if not theme_tag then
			local theme_index = theme_tags and #theme_tags > 0 and _random(1, #theme_tags)

			theme_tag = theme_index and theme_tags[theme_index]
		end

		local store_pickups = store_info.pickups
		local all_store_products = table.keys(store_pickups)

		table.sort(all_store_products)

		SEED = table.shuffle(all_store_products, SEED)

		local random_store_products_to_spawn = {}

		for _, pickup_name in ipairs(all_store_products) do
			local pickup = store_pickups[pickup_name]

			if pickup.random_spawn then
				random_store_products_to_spawn[#random_store_products_to_spawn + 1] = pickup_name
			end
		end

		SEED = table.shuffle(random_store_products_to_spawn, SEED)

		local levels_data = {}
		local section_instance = {
			events = events,
			location_level_name = location_level_name,
			index = i,
			theme_tag = theme_tag,
			levels_data = levels_data,
			store_info = store_info,
			random_store_products_to_spawn = random_store_products_to_spawn,
		}
		local _add_level

		local function _add_levels_to_spawn(levels_to_spawn, delayed_despawn, parent_level_reference_name)
			for _, level_to_spawn_data in ipairs(levels_to_spawn) do
				local level_slot_id = level_to_spawn_data.level_slot_id
				local level_name = level_to_spawn_data.level_name
				local level_tags = level_to_spawn_data.level_tags
				local consume_level_on_spawn_per_location = level_to_spawn_data.consume_level_on_spawn_per_location
				local consume_level_on_spawn_per_expedition = level_to_spawn_data.consume_level_on_spawn_per_expedition

				if table.contains(level_tags, "type_main_objective") then
					local level_data = _add_level("main_objective_level", level_name, level_slot_id, delayed_despawn, parent_level_reference_name, consume_level_on_spawn_per_location, consume_level_on_spawn_per_expedition)
					local custom_data = level_data.custom_data

					custom_data.level_slot_id = level_slot_id
				elseif table.contains(level_tags, "type_opportunity") then
					local level_data = _add_level("opportunity_level", level_name, level_slot_id, delayed_despawn, parent_level_reference_name, consume_level_on_spawn_per_location, consume_level_on_spawn_per_expedition)
					local custom_data = level_data.custom_data

					custom_data.level_slot_id = level_slot_id
				elseif table.contains(level_tags, "type_extraction") then
					local level_data = _add_level("extraction_level", level_name, level_slot_id, delayed_despawn, parent_level_reference_name, consume_level_on_spawn_per_location, consume_level_on_spawn_per_expedition)
					local custom_data = level_data.custom_data

					custom_data.level_slot_id = level_slot_id
				elseif table.contains(level_tags, "type_arrival") then
					local level_data = _add_level("arrival_level", level_name, level_slot_id, delayed_despawn, parent_level_reference_name, consume_level_on_spawn_per_location, consume_level_on_spawn_per_expedition)
					local custom_data = level_data.custom_data

					custom_data.level_slot_id = level_slot_id
				else
					local level_data = _add_level("traversal_level", level_name, level_slot_id, delayed_despawn, parent_level_reference_name, consume_level_on_spawn_per_location, consume_level_on_spawn_per_expedition)
					local custom_data = level_data.custom_data

					custom_data.level_slot_id = level_slot_id
				end
			end
		end

		function _add_level(template_type, level_name, level_slot_id, delayed_despawn, parent_level_reference_name, remove_on_spawn_location, remove_on_spawn_expedition)
			if ENABLE_LOGS then
				Log.info("[Expedition] - Adding new level to expedition config: ", expedition_level_id .. ", " .. level_name .. ", <" .. template_type .. ">")
			end

			local is_location = template_type == "level"
			local reference_name

			if level_slot_id then
				reference_name = template_type .. "_" .. level_slot_id
			else
				reference_name = template_type
			end

			if parent_level_reference_name then
				reference_name = reference_name .. "[" .. parent_level_reference_name .. "]"
			end

			local tags = tags_by_level_name_source[level_name] and table.clone_instance(tags_by_level_name_source[level_name])
			local random_rotation_degree
			local apply_random_rotation = tags and table.array_contains(tags, "rot_mode_random")

			if apply_random_rotation then
				random_rotation_degree = _random(0, 360)
			end

			local data = {
				parent_level_reference_name = parent_level_reference_name,
				reference_name = reference_name,
				template_type = template_type,
				level_name = level_name,
				delayed_despawn = delayed_despawn,
				expedition_level_id = expedition_level_id,
				themes_delayed_packages = {},
				tags = tags,
				special_tags = special_tags_by_level_name[level_name],
				custom_data = {},
				random_rotation_degree = random_rotation_degree,
			}

			expedition_level_id = expedition_level_id + 1

			if is_location then
				table.insert(levels_data, 1, data)
			else
				levels_data[#levels_data + 1] = data
			end

			if remove_on_spawn_location or remove_on_spawn_expedition then
				tags_by_level_name[level_name] = nil
			end

			if remove_on_spawn_expedition then
				tags_by_level_name_source[level_name] = nil
			end

			local function _run_slot_distribution_for_level(slot_distribution, level_slots, optional_reference_name)
				local only_first_section = slot_distribution.only_first_section
				local never_first_section = slot_distribution.never_first_section
				local only_final_section = slot_distribution.only_final_section
				local never_final_section = slot_distribution.never_final_section
				local is_valid = (not only_final_section or i == num_sections) and (not never_final_section or i ~= num_sections) and (not only_first_section or i == 1) and (not never_first_section or i ~= 1)

				if is_valid then
					local levels_to_spawn = get_levels_by_slot_distribution_config(settings, slot_distribution, level_slots, tags_by_level_name)

					_add_levels_to_spawn(levels_to_spawn, delayed_despawn, optional_reference_name or reference_name)
				end
			end

			local level_slot_tags = section_slot_tags_by_level_name[level_name]

			if level_slot_tags then
				local level_slot_distributions = settings.level_slot_distributions

				for _, level_slot_distribution in ipairs(level_slot_distributions) do
					if table.size(level_slot_tags) == 0 then
						break
					end

					_run_slot_distribution_for_level(level_slot_distribution, level_slot_tags)
				end
			end

			local level_spawn_tags = spawn_tags_by_level_name[level_name]
			local location_level_slot_tags = section_slot_tags_by_level_name[location_level_name]

			if level_spawn_tags and location_level_slot_tags then
				local optional_reference_name = "level"

				for _, spawn_tag in ipairs(level_spawn_tags) do
					if table.size(location_level_slot_tags) == 0 then
						break
					end

					local level_slot_distribution = slot_distribution_by_level_tag[spawn_tag]

					_run_slot_distribution_for_level(level_slot_distribution, location_level_slot_tags, optional_reference_name)
				end
			end

			return data
		end

		local safe_zone_exits_level_slot_ids = {}

		if i < num_sections and #safe_zone_levels > 0 then
			local safe_zone_level_name = table.remove(safe_zone_levels, 1)

			table.insert(safe_zone_levels, safe_zone_level_name)

			section_instance.safe_zone_level_name = safe_zone_level_name

			local safe_zone_level_data = _add_level("safe_zone_level", safe_zone_level_name, nil, true)

			safe_zone_level_data.is_safe_zone = true

			local custom_data = safe_zone_level_data.custom_data

			custom_data.store_info = store_info

			local safe_zone_level_slot_tags = section_slot_tags_by_level_name[safe_zone_level_name]
			local safe_zone_level_slot_ids = table.keys(safe_zone_level_slot_tags)

			table.sort(safe_zone_level_slot_ids)

			SEED = table.shuffle(safe_zone_level_slot_ids, SEED)

			for _, level_slot_id in ipairs(safe_zone_level_slot_ids) do
				local slot_tags = safe_zone_level_slot_tags[level_slot_id]

				if table.contains(slot_tags, "safe_zone_entrance") and not safe_zone_exits_level_slot_ids.entrance then
					safe_zone_exits_level_slot_ids.entrance = level_slot_id
					custom_data.entrance_level_slot_id = level_slot_id
				elseif table.contains(slot_tags, "safe_zone_exit") then
					safe_zone_exits_level_slot_ids.exit = level_slot_id
					custom_data.exit_level_slot_id = level_slot_id
				end
			end
		end

		local available_location_level_slots = section_slot_tags_by_level_name[location_level_name]
		local available_location_level_slots_array = table.keys(available_location_level_slots)

		table.sort(available_location_level_slots_array)

		SEED = table.shuffle(available_location_level_slots_array, SEED)

		if ENABLE_LOGS then
			Log.info("Expedition", "available_level_slots", table.dump(available_location_level_slots, "#####", 2))
			Log.info("Expedition", "available_level_resources", table.dump(tags_by_level_name, "¤¤¤¤", 2))
			Log.info("Expedition", "----------------------------------------------------------------------------")
			Log.info("Expedition", "-------------- SETTING UP DSL SPAWNING FOR LOCATION: " .. i .. " -------------")
			Log.info("Expedition", "----------------------------------------------------------------------------")
		end

		local connector_levels = connector_levels_by_chunk[i]
		local connector_level_entrance = connector_levels.entrance
		local connector_level_exit = connector_levels.exit

		if connector_level_entrance then
			for j = #available_location_level_slots_array, 1, -1 do
				local level_slot_id = available_location_level_slots_array[j]
				local slot_tags = available_location_level_slots[level_slot_id]

				if table.contains(slot_tags, "type_transition") then
					do
						local level_data = _add_level("connector_entrance_level", connector_level_entrance, level_slot_id)
						local custom_data = level_data.custom_data

						custom_data.level_slot_id = level_slot_id
						available_location_level_slots[level_slot_id] = nil

						table.remove(available_location_level_slots_array, j)
					end

					break
				end
			end
		end

		if connector_level_exit then
			for j = #available_location_level_slots_array, 1, -1 do
				local level_slot_id = available_location_level_slots_array[j]
				local slot_tags = available_location_level_slots[level_slot_id]

				if table.contains(slot_tags, "type_transition") then
					do
						local level_data = _add_level("connector_exit_level", connector_level_exit, level_slot_id)
						local custom_data = level_data.custom_data

						custom_data.level_slot_id = level_slot_id
						available_location_level_slots[level_slot_id] = nil

						table.remove(available_location_level_slots_array, j)

						local safe_zone_level_data = _get_level_data_by_reference_name(section_instance, "safe_zone_level")

						safe_zone_level_data.custom_data.connector_level_exit_slot_id = level_slot_id
					end

					local safe_zone_level_slot_id = safe_zone_exits_level_slot_ids.entrance

					if safe_zone_level_slot_id then
						local level_data = _add_level("safe_zone_connector_entrance_level", connector_level_exit, safe_zone_level_slot_id, true)

						level_data.is_safe_zone_connector_entrance_level = true

						local custom_data = level_data.custom_data

						custom_data.level_slot_id = safe_zone_level_slot_id
						available_location_level_slots[safe_zone_level_slot_id] = nil

						table.remove(available_location_level_slots_array, j)
					end

					break
				end
			end
		end

		local future_connector_levels = connector_levels_by_chunk[i + 1]

		if future_connector_levels then
			local future_connector_level_entrance = future_connector_levels.entrance
			local safe_zone_level_slot_id = safe_zone_exits_level_slot_ids.exit

			if safe_zone_level_slot_id then
				local level_data = _add_level("safe_zone_connector_exit_level", future_connector_level_entrance, safe_zone_level_slot_id, true)
				local custom_data = level_data.custom_data

				custom_data.level_slot_id = safe_zone_level_slot_id
				available_location_level_slots[safe_zone_level_slot_id] = nil
			end
		end

		local exit_fillers_level_slot_distribution = {
			complete_conditions = {
				max = 10,
				min = 10,
			},
			phases = {
				{
					{
						max = 10,
						min = 10,
						order_score = 1,
						tags = {
							"type_transition",
						},
						optional_resource_tags = {
							"transition_fake",
						},
					},
				},
			},
		}
		local exit_fillers_to_spawn = get_levels_by_slot_distribution_config(settings, exit_fillers_level_slot_distribution, available_location_level_slots, tags_by_level_name)

		if exit_fillers_to_spawn then
			_add_levels_to_spawn(exit_fillers_to_spawn)
		end

		if table.contains(events, "toxic_gas") then
			local event_settings = ExpeditionEventSettings.toxic_gas
			local level_grid_settings = event_settings.level_grid_settings

			settings.level_grid_settings = level_grid_settings

			local gas_settings_by_depth = event_settings.gas_settings_by_depth
			local grid = LevelGridUtilities.create_level_grid(level_grid_settings)
			local cells_per_depth = grid.cells_per_depth

			for depth, grid_cells in ipairs(cells_per_depth) do
				local gas_settings = gas_settings_by_depth[depth]
				local gas_level_name = gas_settings and gas_settings.level_name

				if gas_level_name then
					for idx, cell in ipairs(grid_cells) do
						local cell_size = cell.size
						local cell_position = cell.position
						local half_cell_width = cell_size[1] * 0.5
						local half_cell_height = cell_size[2] * 0.5
						local delayed_despawn = false
						local template_type = "toxic_gas"
						local reference_name = template_type .. "_" .. #generated_layout + 1 .. "_" .. idx
						local level_data = _add_level(template_type, gas_level_name, reference_name, delayed_despawn)
						local custom_data = level_data.custom_data

						custom_data.position = {
							cell_position[1] + _random(-half_cell_width, half_cell_width),
							cell_position[2] + _random(-half_cell_height, half_cell_height),
							0,
						}
						custom_data.level_grid_cell = cell
					end
				end
			end
		end

		local locaction_level_data = _add_level("level", location_level_name)

		locaction_level_data.is_location = true
		generated_layout[#generated_layout + 1] = section_instance

		if ENABLE_LOGS then
			Log.info("Expedition", "TOTAL AMOUNT OF LEVELS [" .. #levels_data .. "] TO SPAWN FOR SECTION [" .. i .. "]")
		end
	end

	return generated_layout
end

Expedition.parse_data = function (data)
	local parsed_data = {}
	local split1 = string.split(data, ";")
	local mission = split1[1]

	parsed_data.mission = mission

	local level = tonumber(split1[2])

	parsed_data.level = level

	local theme = split1[3]

	parsed_data.theme = theme

	local faction = split1[4]

	parsed_data.faction = faction

	local circumstances = split1[5]
	local split2 = string.split(circumstances, ":")
	local circumstances_entry = {}

	for i = 1, #split2 do
		circumstances_entry[#circumstances_entry + 1] = split2[i]
	end

	parsed_data.circumstances = circumstances_entry

	local modifiers = split1[6]
	local split3 = string.split(modifiers, ":")
	local modifiers_entry = {}

	for i = 1, #split3 do
		local modifier_raw = split3[i]
		local modifier_split = string.split(modifier_raw, ".")
		local modifier_name = NetworkLookup.maelstrom_plus_modifiers[tonumber(modifier_split[1])]
		local modifier_level = tonumber(modifier_split[2])

		modifiers_entry[#modifiers_entry + 1] = {
			name = modifier_name,
			level = modifier_level,
		}
	end

	parsed_data.modifiers = modifiers_entry

	if ENABLE_LOGS then
		Log.info("Expedition", "Parsed --------(%s)-------- D+ data", data)
	end

	local challenge = split1[7]

	parsed_data.challenge = tonumber(challenge)

	local resistance = split1[8]

	parsed_data.resistance = tonumber(resistance)

	return parsed_data
end

return Expedition
