local volume_event_filters = {
	players_in_end_zone = function (unit_inside_filter, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")
		local volume_id = trigger_extension:volume_id()
		local volume_event_system = Managers.state.extension:system("volume_event_system")
		local conditions_fulfilled = volume_event_system:end_zone_conditions_fulfilled(volume_id)

		return conditions_fulfilled
	end
}

return settings("VolumeEventFilters", volume_event_filters)
