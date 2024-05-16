-- chunkname: @scripts/extension_systems/point_of_interest/point_of_interest_target_extension.lua

local PointOfInterestSettings = require("scripts/settings/point_of_interest/point_of_interest_settings")
local PointOfInterestTargetExtension = class("PointOfInterestTargetExtension")

PointOfInterestTargetExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local tag = extension_init_data.tag or ""
	local view_distance = extension_init_data.view_distance or PointOfInterestSettings.default_view_distance
	local is_dynamic = extension_init_data.is_dynamic or false

	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._view_distance_sq = view_distance
	self._is_dynamic = is_dynamic
	self._tag = tag
	self._faction_event = nil
	self._faction_breed_name = ""
	self._unit_node = nil
	self._has_been_seen = false
	self._collision_filter = "filter_look_at_object_ray"
	self._disabled = false

	if Unit.has_node(unit, "j_spine") then
		Unit.node(unit, "j_spine")
	end
end

PointOfInterestTargetExtension.setup_from_component = function (self, view_distance, is_dynamic, tag, faction_event, dialogue_target_filter, faction_breed_name, mission_giver_selected_voice, disabled)
	self._view_distance_sq = view_distance * view_distance
	self._is_dynamic = is_dynamic
	self._tag = tag

	if faction_event ~= "" then
		self._faction_event = faction_event
	end

	self._faction_breed_name = faction_breed_name
	self._dialogue_target_filter = dialogue_target_filter or "none"
	self._mission_giver_selected_voice = mission_giver_selected_voice
	self._disabled = disabled
end

PointOfInterestTargetExtension.is_dynamic = function (self)
	return self._is_dynamic
end

PointOfInterestTargetExtension.center_position = function (self)
	local target_center
	local node = self._unit_node
	local unit = self._unit

	if node then
		target_center = Unit.world_position(unit, node)
	else
		local target_center_matrix = Unit.box(unit)

		target_center = Matrix4x4.translation(target_center_matrix)
	end

	return target_center
end

PointOfInterestTargetExtension.view_distance_sq = function (self)
	return self._view_distance_sq
end

PointOfInterestTargetExtension.tag = function (self)
	return self._tag
end

PointOfInterestTargetExtension.faction_event = function (self)
	return self._faction_event
end

PointOfInterestTargetExtension.faction_breed_name = function (self)
	return self._faction_breed_name
end

PointOfInterestTargetExtension.dialogue_target_filter = function (self)
	return self._dialogue_target_filter
end

PointOfInterestTargetExtension.mission_giver_selected_voice = function (self)
	return self._mission_giver_selected_voice
end

PointOfInterestTargetExtension.set_has_been_seen = function (self)
	self._has_been_seen = true
end

PointOfInterestTargetExtension.set_tag = function (self, tag)
	self._tag = tag
end

PointOfInterestTargetExtension.set_disabled = function (self)
	self._disabled = true
end

PointOfInterestTargetExtension.disabled = function (self)
	return self._disabled
end

PointOfInterestTargetExtension.collision_filter = function (self)
	return self._collision_filter
end

return PointOfInterestTargetExtension
