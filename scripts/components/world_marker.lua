-- chunkname: @scripts/components/world_marker.lua

local WorldMarker = component("WorldMarker")

WorldMarker.init = function (self, unit)
	self._marker_id = nil
	self._unit = unit

	Managers.event:register(self, "event_on_hud_created", "_on_hud_created")
end

WorldMarker.editor_init = function (self, unit)
	self._should_debug_draw = false
end

WorldMarker.enable = function (self, unit)
	return
end

WorldMarker.disable = function (self, unit)
	return
end

WorldMarker.destroy = function (self, unit)
	Managers.event:unregister(self, "event_on_hud_created")

	if self._marker_id then
		local event_manager = Managers.event

		event_manager:trigger("remove_world_marker", self._marker_id)
	end
end

WorldMarker.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

WorldMarker._on_beacon_marker_spawned = function (self, unit, id)
	self._marker_id = id
end

WorldMarker._on_hud_created = function (self)
	return
end

WorldMarker.component_data = {
	marker_type = {
		ui_name = "Marker Type",
		ui_type = "combo_box",
		value = "interaction",
		options_keys = {
			"beacon",
			"chat_bubble",
			"damage_indicator",
			"health_bar",
			"hub_objective",
			"interaction",
			"location_attention",
			"location_ping",
			"location_threat",
			"nameplate",
			"nameplate_party",
			"nameplate_party_hud",
			"objective",
			"player_assistance",
			"suppression_indicator",
			"training_grounds",
			"unit_threat",
			"unit_threat_veteran",
			"unit_threat_adamant",
		},
		options_values = {
			"beacon",
			"chat_bubble",
			"damage_indicator",
			"health_bar",
			"hub_objective",
			"interaction",
			"location_attention",
			"location_ping",
			"location_threat",
			"nameplate",
			"nameplate_party",
			"nameplate_party_hud",
			"objective",
			"player_assistance",
			"suppression_indicator",
			"training_grounds",
			"unit_threat",
			"unit_threat_veteran",
			"unit_threat_adamant",
		},
	},
}

return WorldMarker
