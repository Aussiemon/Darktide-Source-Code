-- chunkname: @scripts/utilities/expeditions/expedition_objectives_handler.lua

local function _log(...)
	Log.info("ExpeditionObjectivesHandler", ...)
end

local RADIUS_BY_LEVEL_TAG = {
	level_size_16 = 8,
	level_size_32 = 16,
	level_size_48 = 24,
	level_size_64 = 32,
}
local MARGIN_BY_LEVEL_TAG = {
	level_size_16 = 10,
	level_size_32 = 10,
	level_size_48 = 10,
	level_size_64 = 10,
}
local CLIENT_RPCS = {}
local SERVER_RPCS = {}
local ExpeditionObjectivesHandler = class("ExpeditionObjectivesHandler")

ExpeditionObjectivesHandler.init = function (self, expedition_template, is_server, network_event_delegate, expedition)
	self._expedition = expedition
	self._expedition_template = expedition_template
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._expedition_level_data_by_objective = {}

	if self._is_server then
		network_event_delegate:register_session_events(self, unpack(SERVER_RPCS))
	else
		network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end

	local event_manager = Managers.event

	event_manager:register(self, "event_mission_objective_start", "event_mission_objective_start")
	event_manager:register(self, "event_remove_mission_objective", "event_remove_mission_objective")
end

ExpeditionObjectivesHandler.on_gameplay_init = function (self)
	return
end

ExpeditionObjectivesHandler._is_level_data_valid = function (self, level_data)
	if level_data then
		local level_template_type = level_data.template_type

		if level_template_type == "opportunity_level" or level_template_type == "traversal_level" then
			return true
		end
	end
end

ExpeditionObjectivesHandler.event_remove_mission_objective = function (self, objective)
	self._expedition_level_data_by_objective[objective] = nil
end

ExpeditionObjectivesHandler.event_mission_objective_start = function (self, objective, locally_added, on_add_callback)
	local group_id = objective:group_id()
	local level_data = self:level_data_by_level_id(group_id)

	if objective:use_hud() and self:_is_level_data_valid(level_data) then
		self._expedition_level_data_by_objective[objective] = level_data
	end
end

ExpeditionObjectivesHandler.hot_join_sync = function (self, channel_id)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")

	if mission_objective_system then
		local active_objectives = mission_objective_system:active_objectives()

		for objective, _ in pairs(active_objectives) do
			local group_id = objective:group_id()
			local level_data = self:level_data_by_level_id(group_id)

			if objective:use_hud() and self:_is_level_data_valid(level_data) then
				self._expedition_level_data_by_objective[objective] = level_data
			end
		end
	end
end

ExpeditionObjectivesHandler.update = function (self, dt, t)
	local local_player = Managers.player:local_player(1)

	if not local_player or not local_player:unit_is_alive() then
		return
	end

	local player_position = Unit.local_position(local_player.player_unit, 1)
	local expedition = self._expedition

	if expedition then
		local _expedition_level_data_by_objective = self._expedition_level_data_by_objective
		local mission_objective_system = Managers.state.extension:system("mission_objective_system")

		if mission_objective_system then
			for objective, level_data in pairs(_expedition_level_data_by_objective) do
				local position = level_data.position:unbox()
				local tags = level_data.tags

				if tags then
					local radius, margin = self:_get_first_available_radius_by_tags(tags)
					local flattened_player_position = Vector3(player_position.x, player_position.y, 0)
					local flattened_level_position = Vector3(position.x, position.y, 0)
					local distance = Vector3.distance(flattened_level_position, flattened_player_position)

					if not objective:use_hud() and distance < radius then
						objective:set_use_ui(true)
					elseif objective:use_hud() and distance > radius + margin then
						objective:set_use_ui(false)
					end
				end
			end
		end
	end
end

ExpeditionObjectivesHandler.destroy = function (self)
	if self._is_server then
		self._network_event_delegate:unregister_events(unpack(SERVER_RPCS))
	else
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end

	local event_manager = Managers.event

	event_manager:unregister(self, "event_mission_objective_start")
	event_manager:unregister(self, "event_remove_mission_objective")
end

ExpeditionObjectivesHandler._get_first_available_radius_by_tags = function (self, tags)
	for _, tag in ipairs(tags) do
		local radius, margin = RADIUS_BY_LEVEL_TAG[tag], MARGIN_BY_LEVEL_TAG[tag]

		if radius then
			return radius, margin
		end
	end
end

ExpeditionObjectivesHandler.level_data_by_level_id = function (self, level_id)
	local expedition = self._expedition

	if expedition then
		for _, section in ipairs(expedition) do
			local levels_data = section.levels_data

			for _, level_data in ipairs(levels_data) do
				local level = level_data.level

				if level and level_data.spawned then
					local server_level_id = Level.get_data(level, "server_level_id")

					if server_level_id == level_id then
						return level_data
					end
				end
			end
		end
	end
end

return ExpeditionObjectivesHandler
