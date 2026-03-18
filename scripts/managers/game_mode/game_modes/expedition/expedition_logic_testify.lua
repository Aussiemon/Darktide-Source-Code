-- chunkname: @scripts/managers/game_mode/game_modes/expedition/expedition_logic_testify.lua

local GameModeExpeditionTestify = {
	expedition_location_path = function (expedition_logic)
		local coordinates = {}

		local function add_coordinate(position)
			coordinates[#coordinates + 1] = {
				x = position.x,
				y = position.y,
				z = position.z + 2,
			}
		end

		local location_index = expedition_logic._current_section_index
		local location = expedition_logic._expedition[location_index]
		local arrival_unit = location.arrival_unit

		if arrival_unit then
			add_coordinate(Unit.world_position(arrival_unit, 1))
		else
			local connector_entrance_unit = location.connector_entrance_unit

			if connector_entrance_unit then
				add_coordinate(Unit.world_position(connector_entrance_unit, 1))
			end
		end

		local connector_exit_unit = location.connector_exit_unit

		if connector_exit_unit then
			add_coordinate(Unit.world_position(connector_exit_unit, 1))
		else
			local extraction_unit = location.extraction_unit

			if extraction_unit then
				add_coordinate(Unit.world_position(extraction_unit, 1))
			end
		end

		return coordinates
	end,
	expedition_store_path = function (expedition_logic)
		local coordinates = {}

		local function add_coordinate(position)
			coordinates[#coordinates + 1] = {
				x = position.x,
				y = position.y,
				z = position.z + 2,
			}
		end

		local location_index = expedition_logic._current_section_index

		if location_index > 1 then
			local old_location = expedition_logic._expedition[location_index - 1]
			local safe_zone_entrance_slot_unit = old_location.safe_zone_entrance_slot_unit

			add_coordinate(Unit.world_position(safe_zone_entrance_slot_unit, 1))

			local safe_zone_exit_slot_unit = old_location.safe_zone_exit_slot_unit

			if safe_zone_exit_slot_unit then
				add_coordinate(Unit.world_position(safe_zone_exit_slot_unit, 1))
			else
				add_coordinate(Vector3.zero())
			end
		end

		return coordinates
	end,
	expedition_is_on_last_location = function (expedition_logic)
		return expedition_logic._current_section_index >= #expedition_logic._expedition
	end,
	expedition_wait_until_location_ready = function (expedition_logic)
		if expedition_logic._server_level_state ~= "idle" then
			return Testify.RETRY
		end
	end,
	expedition_start_next_location = function (expedition_logic)
		expedition_logic:debug_teleport_players_to_safe_zone()
	end,
	expedition_get_layout_seed = function (expedition_logic)
		local mechanism_manager = Managers.mechanism
		local mechanism = mechanism_manager:current_mechanism()
		local mechanism_data = mechanism:mechanism_data()

		return mechanism_data.layout_seed
	end,
}

return GameModeExpeditionTestify
