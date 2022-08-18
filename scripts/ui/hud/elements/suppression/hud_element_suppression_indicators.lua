local HudElementSuppressionIndicators = class("HudElementSuppressionIndicators")

HudElementSuppressionIndicators.init = function (self, parent, draw_layer, start_scale, definitions)
	self._active_markers = {}
	local event_manager = Managers.event

	event_manager:register(self, "event_unit_suppression", "_event_unit_suppression")
end

HudElementSuppressionIndicators.destroy = function (self)
	local event_manager = Managers.event
	local active_markers = self._active_markers

	for _, existing_marker_id in pairs(active_markers) do
		if existing_marker_id then
			event_manager:trigger("remove_world_marker", existing_marker_id)
		end
	end

	self._active_markers = nil

	event_manager:unregister(self, "event_unit_suppression")
end

HudElementSuppressionIndicators._event_unit_suppression = function (self, unit, is_suppressed)
	if is_suppressed then
		self:_add_suppression_marker(unit)
	else
		self:_remove_suppression_marker(unit)
	end
end

HudElementSuppressionIndicators._add_suppression_marker = function (self, unit)
	local event_manager = Managers.event
	local marker_created_callback = callback(self, "_cb_suppression_marker_created", unit)
	local marker_type = "suppression_indicator"

	event_manager:trigger("add_world_marker_unit", marker_type, unit, marker_created_callback)
end

HudElementSuppressionIndicators._remove_suppression_marker = function (self, unit)
	local active_markers = self._active_markers
	local existing_marker_id = active_markers[unit]

	if existing_marker_id then
		local event_manager = Managers.event

		event_manager:trigger("remove_world_marker", existing_marker_id)
	end

	active_markers[unit] = nil
end

HudElementSuppressionIndicators._cb_suppression_marker_created = function (self, unit, id)
	local active_markers = self._active_markers
	local existing_marker_id = active_markers[unit]

	if existing_marker_id then
		self:_remove_suppression_marker(unit)
	end

	fassert(not active_markers[unit], "overwriting existing marker linked to unit: %s", tostring(unit))

	active_markers[unit] = id
end

return HudElementSuppressionIndicators
