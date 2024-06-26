-- chunkname: @scripts/components/flyer.lua

local Flyer = component("Flyer")

Flyer.init = function (self, unit)
	local flyer_extension = ScriptUnit.fetch_component_extension(unit, "flyer_system")

	self._flyer_extension = flyer_extension

	if flyer_extension then
		local start_free_flight_enabled = self:get_data(unit, "start_free_flight_enabled")

		flyer_extension:setup_from_component(start_free_flight_enabled)
	end
end

Flyer.editor_init = function (self, unit)
	return
end

Flyer.editor_validate = function (self, unit)
	return true, ""
end

Flyer.enable = function (self, unit)
	return
end

Flyer.disable = function (self, unit)
	return
end

Flyer.destroy = function (self, unit)
	return
end

Flyer.free_flight_enable = function (self, unit)
	local flyer_extension = self._flyer_extension

	if flyer_extension then
		flyer_extension:set_active(true)
	end
end

Flyer.free_flight_disable = function (self, unit)
	local flyer_extension = self._flyer_extension

	if flyer_extension then
		flyer_extension:set_active(false)
	end
end

Flyer.component_data = {
	start_free_flight_enabled = {
		ui_name = "Free Flight Enabled",
		ui_type = "check_box",
		value = true,
	},
	inputs = {
		free_flight_enable = {
			accessibility = "public",
			type = "event",
		},
		free_flight_disable = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"FlyerExtension",
	},
}

return Flyer
