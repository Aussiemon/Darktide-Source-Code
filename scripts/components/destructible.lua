local Component = require("scripts/utilities/component")
local Destructible = component("Destructible")

Destructible.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	self._enabled = self:get_data(unit, "start_enabled")
	local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

	if destructible_extension then
		local disable_physics = Unit.get_data(unit, "disable_physics")

		destructible_extension:set_disable_physics(disable_physics)

		if not disable_physics then
			local start_visible = self:get_data(unit, "start_visible")
			local depawn_timer_duration = self:get_data(unit, "depawn_timer_duration")
			local despawn_when_destroyed = self:get_data(unit, "despawn_when_destroyed")
			local mass = self:get_data(unit, "mass")
			local speed = self:get_data(unit, "speed")
			local force_direction = self:get_data(unit, "force_direction")
			local is_nav_gate = self:get_data(unit, "is_nav_gate")
			local broadphase_radius = self:get_data(unit, "broadphase_radius")

			destructible_extension:setup_from_component(depawn_timer_duration, despawn_when_destroyed, mass, speed, force_direction, start_visible, is_nav_gate, broadphase_radius)
			destructible_extension:set_enabled(self._enabled)

			self._destructible_extension = destructible_extension
		end
	end
end

Destructible.destroy = function (self, unit)
	return
end

Destructible.extensions_ready = function (self, world, unit)
	if self._destructible_extension then
		self._destructible_extension:setup_stages()
	end
end

Destructible.enable_destructible = function (self, unit)
	if self._destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "destructible_enable")
		end

		self._enabled = true

		self._destructible_extension:set_enabled(true)
	end
end

Destructible.disable_destructible = function (self, unit)
	if self._destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "destructible_disable")
		end

		self._enabled = false

		self._destructible_extension:set_enabled(false)
	end
end

Destructible.enable_visibility = function (self, unit)
	if self._destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "visibility_enable")
		end

		self._destructible_extension:set_visibility(true)
	end
end

Destructible.disable_visibility = function (self, unit)
	if self._destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "visibility_disable")
		end

		self._destructible_extension:set_visibility(false)
	end
end

Destructible.enable = function (self, unit)
	return
end

Destructible.disable = function (self, unit)
	return
end

Destructible.editor_init = function (self, unit)
	self:enable(unit)
end

Destructible.events.add_damage = function (self, damage, hit_actor, attack_direction)
	if self._destructible_extension and self._enabled then
		self._destructible_extension:add_damage(damage, hit_actor, attack_direction)
	end
end

Destructible.events.destructible_enable = function (self, unit)
	self:enable_destructible(unit)
end

Destructible.events.destructible_disable = function (self, unit)
	self:disable_destructible(unit)
end

Destructible.events.visibility_enable = function (self, unit)
	self:enable_visibility(unit)
end

Destructible.events.visibility_disable = function (self, unit)
	self:disable_visibility(unit)
end

Destructible.force_destruct = function (self)
	if self._destructible_extension then
		self._destructible_extension:force_destruct()
	end
end

Destructible.component_data = {
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start enabled"
	},
	start_visible = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start visible"
	},
	despawn_when_destroyed = {
		ui_type = "check_box",
		value = true,
		ui_name = "Despawn when Destroyed"
	},
	depawn_timer_duration = {
		ui_type = "number",
		min = 0,
		decimals = 0,
		value = 6,
		ui_name = "Depawn Timer Duration (sec.)",
		step = 5
	},
	mass = {
		ui_type = "number",
		min = 0,
		max = 100,
		category = "Force on Destroy",
		value = 1,
		decimals = 0,
		ui_name = "Mass (kg)",
		step = 1
	},
	speed = {
		ui_type = "number",
		min = 0,
		max = 1200,
		category = "Force on Destroy",
		value = 700,
		decimals = 0,
		ui_name = "Speed (m/s)",
		step = 10
	},
	force_direction = {
		value = "random_direction",
		ui_type = "combo_box",
		category = "Force on Destroy",
		ui_name = "Direction",
		options_keys = {
			"Random Direction",
			"Attack Direction"
		},
		options_values = {
			"random_direction",
			"attack_direction"
		}
	},
	is_nav_gate = {
		ui_type = "check_box",
		value = false,
		ui_name = "Is Nav Gate"
	},
	broadphase_radius = {
		ui_type = "number",
		min = 10,
		max = 100,
		decimals = 0,
		value = 40,
		ui_name = "Broadphase Radius (in m)",
		step = 1
	},
	inputs = {
		force_destruct = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"DestructibleExtension"
	}
}

return Destructible
