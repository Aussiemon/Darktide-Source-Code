local LevelEventSettings = require("scripts/settings/level_event/level_event_settings")
local MissionObjectiveZoneScannableExtension = class("MissionObjectiveZoneScannableExtension")

MissionObjectiveZoneScannableExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._is_active = false
	self._world = extension_init_context.world
	local box = Unit.box(unit, false)
	local center_position = Matrix4x4.translation(box)
	self._center_poisition_box = Vector3Box(center_position)
	self._has_outline = false
	self._has_highlight = false
end

MissionObjectiveZoneScannableExtension.on_gameplay_post_init = function (self, level)
	if self._is_server then
		local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")

		mission_objective_zone_system:register_scannable_unit(self._unit)
	end
end

MissionObjectiveZoneScannableExtension.hot_join_sync = function (self, unit, sender, channel)
	local active = self._is_active
	local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

	RPC.rpc_mission_objective_zone_scannable_hot_join_sync(channel, level_unit_id, active)
end

MissionObjectiveZoneScannableExtension.set_active = function (self, active)
	self._is_active = active

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(self._unit)

		Managers.state.game_session:send_rpc_clients("rpc_mission_objective_zone_scannable_set_active", level_unit_id, active)
	end
end

MissionObjectiveZoneScannableExtension.set_scanning_highlight = function (self, active)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system then
		local outline_system = Managers.state.extension:system("outline_system")

		if active and not self._has_outline then
			outline_system:add_outline(self._unit, "scanning_confirm")

			self._has_outline = true
		elseif not active and self._has_outline then
			outline_system:remove_outline(self._unit, "scanning_confirm")

			self._has_outline = false
		end
	end
end

MissionObjectiveZoneScannableExtension.set_scanning_outline = function (self, active)
	local has_outline_system = Managers.state.extension:has_system("outline_system")

	if has_outline_system then
		local outline_system = Managers.state.extension:system("outline_system")

		if active and not self._has_highlight then
			outline_system:add_outline(self._unit, "scanning")

			self._has_highlight = true
		elseif not active and self._has_highlight then
			outline_system:remove_outline(self._unit, "scanning")

			self._has_highlight = false
		end
	end
end

MissionObjectiveZoneScannableExtension.is_active = function (self)
	return self._is_active
end

MissionObjectiveZoneScannableExtension.center_poisition = function (self)
	local center_poisition_box = self._center_poisition_box

	return center_poisition_box and center_poisition_box:unbox()
end

return MissionObjectiveZoneScannableExtension
