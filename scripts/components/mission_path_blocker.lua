-- chunkname: @scripts/components/mission_path_blocker.lua

local MissionPathBlocker = component("MissionPathBlocker")

MissionPathBlocker.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	self._enabled = true
end

MissionPathBlocker.editor_validate = function (self, unit)
	return true, ""
end

MissionPathBlocker.destroy = function (self, unit)
	return
end

MissionPathBlocker.enable = function (self, unit)
	if self._enabled then
		return
	end

	if self._is_server then
		local nav_graph_extension = ScriptUnit.fetch_component_extension(unit, "nav_graph_system")

		nav_graph_extension:add_nav_graphs_to_database()

		local nav_block_extension = ScriptUnit.fetch_component_extension(unit, "nav_block_system")

		nav_block_extension:set_block("g_volume_block", true)
	end

	Unit.set_unit_visibility(unit, true)

	for i = 1, Unit.num_actors(unit) do
		local actor = Unit.actor(unit, i)

		Unit.create_actor(unit, actor)
	end

	self._enabled = true
end

MissionPathBlocker.disable = function (self, unit)
	if not self._enabled then
		return
	end

	if self._is_server then
		local nav_graph_extension = ScriptUnit.fetch_component_extension(unit, "nav_graph_system")

		nav_graph_extension:remove_nav_graphs_from_database()

		local nav_block_extension = ScriptUnit.fetch_component_extension(unit, "nav_block_system")

		nav_block_extension:set_block("g_volume_block", false)
	end

	Unit.set_unit_visibility(unit, false)

	for i = 1, Unit.num_actors(unit) do
		local actor = Unit.actor(unit, i)

		Unit.destroy_actor(unit, actor)
	end

	self._enabled = false
end

MissionPathBlocker.mission_path_blocker_closed = function (self)
	self:enable(self._unit)
end

MissionPathBlocker.mission_path_blocker_open = function (self)
	self:disable(self._unit)
end

MissionPathBlocker.component_data = {
	inputs = {
		mission_path_blocker_open = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {}
}

return MissionPathBlocker
