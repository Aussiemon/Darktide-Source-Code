local volume_event_filters = {
	end_zone = function (filter_unit, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")
		local conditions_fulfilled = trigger_extension:filter_passed(filter_unit)

		return conditions_fulfilled
	end,
	trigger = function (filter_unit, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")
		local conditions_fulfilled = trigger_extension:filter_passed(filter_unit)

		return conditions_fulfilled
	end
}

return settings("VolumeEventFilters", volume_event_filters)
