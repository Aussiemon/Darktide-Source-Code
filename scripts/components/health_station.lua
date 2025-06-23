-- chunkname: @scripts/components/health_station.lua

local HealthStation = component("HealthStation")

HealthStation.init = function (self, unit, is_server)
	self._unit = unit

	local health_station_extension = ScriptUnit.fetch_component_extension(unit, "health_station_system")

	if health_station_extension then
		local start_charge_amount = self:get_data(unit, "available_charges")
		local health_per_charge = self:get_data(unit, "health_per_charge")
		local battery_spawning_mode = self:get_data(unit, "battery_spawning_mode")
		local use_distribution_pool = self:get_data(unit, "use_distribution_pool")
		local socket_prop = self:get_data(unit, "socket_prop")

		health_station_extension:setup_from_component(start_charge_amount, health_per_charge, use_distribution_pool, socket_prop, battery_spawning_mode)

		self._health_station_extension = health_station_extension

		if battery_spawning_mode == "pickup_location" or battery_spawning_mode == "none" then
			Unit.set_scalar_for_materials(self._unit, "increase_color", -0.95)
		end
	end
end

HealthStation.enable = function (self, unit)
	return
end

HealthStation.disable = function (self, unit)
	return
end

HealthStation.destroy = function (self, unit)
	return
end

HealthStation.spawn_battery = function (self, unit)
	if self._health_station_extension then
		self._health_station_extension:spawn_battery()
	end
end

HealthStation.unspawn_battery = function (self, unit)
	if self._health_station_extension then
		self._health_station_extension:unspawn_battery()
	end
end

HealthStation.component_data = {
	battery_spawning_mode = {
		value = "plugged",
		ui_type = "combo_box",
		ui_name = "Battery Spawning",
		options_keys = {
			"Battery Unplugged",
			"Battery Spawned at pickup_location",
			"Battery always Plugged on Spawn",
			"Battery Plugged only with Distributed Charge"
		},
		options_values = {
			"none",
			"pickup_location",
			"plugged",
			"plugged_with_charge"
		}
	},
	available_charges = {
		ui_type = "number",
		min = 0,
		decimals = 0,
		max = 4,
		value = 4,
		ui_name = "Available Charges",
		step = 1
	},
	health_per_charge = {
		ui_type = "number",
		min = 0,
		decimals = 0,
		max = 100,
		value = 0,
		ui_name = "Health per Charge (0 == full health)",
		step = 1
	},
	use_distribution_pool = {
		ui_type = "check_box",
		value = true,
		ui_name = "Use Health Charge Distribution Pool (see mission_templates.lua)"
	},
	socket_prop = {
		value = "luggable_socket",
		ui_type = "combo_box",
		ui_name = "Socket Prop (see 'settings/level_prop')",
		options_keys = {
			"socket_luggable_battery_01"
		},
		options_values = {
			"luggable_socket"
		}
	},
	inputs = {
		spawn_battery = {
			accessibility = "public",
			type = "event"
		},
		unspawn_battery = {
			accessibility = "public",
			type = "event"
		}
	}
}

return HealthStation
