-- chunkname: @scripts/extension_systems/mission_objective/utilities/mission_objective_luggable.lua

require("scripts/extension_systems/mission_objective/utilities/mission_objective_base")

local MissionObjectiveLuggable = class("MissionObjectiveLuggable", "MissionObjectiveBase")

MissionObjectiveLuggable.init = function (self)
	MissionObjectiveLuggable.super.init(self)

	self._show_sockets = false
	self._override_marked_units = {}

	self:set_updated_externally(true)
end

MissionObjectiveLuggable.start_objective = function (self, mission_objective_data, registered_units, synchronizer_unit)
	MissionObjectiveLuggable.super.start_objective(self, mission_objective_data, registered_units, synchronizer_unit)

	local luggable_synchronizer_extension = self:synchronizer_extension()
	local stages = luggable_synchronizer_extension:setup_stages(registered_units)

	self:set_stage_count(stages)
end

MissionObjectiveLuggable.start_stage = function (self, stage)
	MissionObjectiveLuggable.super.start_stage(self, stage)

	local luggable_synchronizer_extension = self:synchronizer_extension()

	self:set_max_increment(luggable_synchronizer_extension:sockets_to_fill())
end

MissionObjectiveLuggable.update_progression = function (self)
	MissionObjectiveLuggable.super.update_progression(self)

	local socket_targets = self:max_incremented_progression()

	if socket_targets > 0 then
		local current_amount = self:incremented_progression()
		local progression = current_amount / socket_targets

		progression = math.clamp(progression, 0, 1)

		self:set_progression(progression)

		if self:max_progression_achieved() then
			self:stage_done()
		end
	end
end

MissionObjectiveLuggable.luggable_picked_up = function (self)
	Unit.flow_event(self._synchronizer_unit, "lua_event_luggable_picked_up")
end

MissionObjectiveLuggable.display_socket_markers = function (self, show_markers)
	if show_markers then
		self._show_sockets = true

		self:_update_override_markers()
	else
		self._show_sockets = false
	end
end

MissionObjectiveLuggable._update_override_markers = function (self)
	local luggable_synchronizer_extension = self:synchronizer_extension()
	local socket_units = luggable_synchronizer_extension:active_socket_units()

	table.clear(self._override_marked_units)

	for i = 1, #socket_units do
		local socket_unit = socket_units[i]
		local socket_extension = ScriptUnit.extension(socket_unit, "luggable_socket_system")

		if not socket_extension:is_occupied() then
			self._override_marked_units[socket_units[i]] = true
		end
	end
end

MissionObjectiveLuggable.add_marker_on_hot_join = function (self, unit)
	if ScriptUnit.has_extension(unit, "luggable_socket_system") then
		return false
	end

	return MissionObjectiveLuggable.super.add_marker_on_hot_join(self, unit)
end

MissionObjectiveLuggable.marked_units = function (self)
	if self._show_sockets then
		return self._override_marked_units
	end

	return MissionObjectiveLuggable.super.marked_units(self)
end

MissionObjectiveLuggable.set_progression = function (self, progression)
	MissionObjectiveLuggable.super.set_progression(self, progression)

	if self._show_sockets then
		self:_update_override_markers()
	end
end

return MissionObjectiveLuggable
