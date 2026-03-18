-- chunkname: @scripts/components/hostile_area_checker.lua

local BreedSettings = require("scripts/settings/breed/breed_settings")
local Component = require("scripts/utilities/component")
local HostileAreaChecker = component("HostileAreaChecker")
local MINION_BREED_TYPE = BreedSettings.types.minion

HostileAreaChecker.init = function (self, unit)
	self._unit = unit

	return true
end

HostileAreaChecker.editor_init = function (self, unit)
	return
end

HostileAreaChecker.enable = function (self, unit)
	if self._broadphase then
		return
	end

	local volume_points = Unit.volume_points(unit, "c_volume")
	local volume_height = Unit.volume_height(unit, "c_volume")
	local center = Vector3(0, 0, 0)
	local points = 0

	for _, point in pairs(volume_points) do
		center = center + point
		points = points + 1
	end

	center = center / points

	local furthest_distance = 0

	for _, point in pairs(volume_points) do
		local distance = Vector3.distance(center, point + Vector3.up() * volume_height)

		if furthest_distance < distance then
			furthest_distance = distance
		end
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")

	self._broadphase = broadphase_system.broadphase
	self._broadphase_check_position = Vector3Box(center)
	self._broadphase_check_radius = furthest_distance
end

HostileAreaChecker.disable = function (self, unit)
	return
end

HostileAreaChecker.destroy = function (self, unit)
	return
end

HostileAreaChecker.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

local broadphase_results = {}

HostileAreaChecker._check_hostile_onboard = function (self)
	local unit = self._unit
	local check_radius = self._broadphase_check_radius
	local check_position = self._broadphase_check_position:unbox()
	local broadphase = self._broadphase
	local num_results = Broadphase.query(broadphase, check_position, check_radius, broadphase_results, MINION_BREED_TYPE)

	for i = 1, num_results do
		local hostile_unit = broadphase_results[i]
		local hostile_position = Unit.world_position(hostile_unit, 1)

		if Unit.is_point_inside_volume(unit, "c_volume", hostile_position) then
			return true
		end
	end

	return false
end

HostileAreaChecker.update = function (self, unit, dt, t)
	if self:_check_hostile_onboard() then
		return true
	end

	Component.trigger_event_on_clients(self, "area_clear")
	Component.event(unit, "area_clear")

	return false
end

HostileAreaChecker.events.area_clear = function (self)
	Unit.flow_event(self._unit, "lua_area_clear")
end

HostileAreaChecker.editor_update = function (self, unit, dt, t)
	return
end

HostileAreaChecker.component_data = {
	starts_enabled = {
		ui_name = "Start Enabled",
		ui_type = "check_box",
		value = false,
	},
}

return HostileAreaChecker
