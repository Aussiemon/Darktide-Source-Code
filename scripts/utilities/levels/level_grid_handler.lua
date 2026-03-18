-- chunkname: @scripts/utilities/levels/level_grid_handler.lua

local LevelGridUtilities = require("scripts/utilities/levels/level_grid")
local CLIENT_RPCS = {}
local SERVER_RPCS = {}
local LevelGridHandler = class("LevelGridHandler")

LevelGridHandler.init = function (self, grid_settings, is_server, network_event_delegate)
	self._grid_settings = grid_settings
	self._grid = LevelGridUtilities.create_level_grid(grid_settings)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._loot_by_player = {}
	self._peer_id_by_pickup_unit = {}
	self._dropped_loot_by_pickup_unit = {}
	self._loot_calculations_dirty = false
	self._total_team_loot_collected = 0
	self._track_players = grid_settings.track_players

	if self._track_players then
		self._grid_cells_with_players = {}
	end

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

LevelGridHandler.grid_cell_by_position = function (self, position, deep_search, optional_grid)
	local grid = optional_grid or self._grid

	for idx, cell in ipairs(grid) do
		local cell_size = cell.size
		local cell_position = cell.position
		local cell_lower_left_corner = {
			cell_position[1] - cell_size[1] * 0.5,
			cell_position[2] - cell_size[2] * 0.5,
		}

		if math.box_overlap_point_radius(cell_lower_left_corner[1], cell_lower_left_corner[2], cell_lower_left_corner[1] + cell_size[1], cell_lower_left_corner[2] + cell_size[2], position.x, position.y, 0.1) then
			local child_grid = cell.child_grid

			if deep_search and child_grid then
				return self:grid_cell_by_position(position, deep_search, child_grid)
			else
				return cell
			end
		end
	end
end

LevelGridHandler.update = function (self, dt, t)
	if self._track_players then
		local cells_with_players = self._grid_cells_with_players

		table.clear(cells_with_players)

		local player_manager = Managers.player
		local players = player_manager:players()

		for _, player in pairs(players) do
			local player_unit = player.player_unit

			if player_unit and Unit.alive(player_unit) then
				local player_position = Unit.local_position(player_unit, 1)
				local deep_search = true
				local cell = self:grid_cell_by_position(player_position, deep_search)

				if cell then
					cells_with_players[cell] = (cells_with_players[cell] or 0) + 1
				end
			end
		end
	end
end

LevelGridHandler.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

return LevelGridHandler
