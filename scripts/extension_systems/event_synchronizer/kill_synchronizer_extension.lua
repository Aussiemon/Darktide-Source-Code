-- chunkname: @scripts/extension_systems/event_synchronizer/kill_synchronizer_extension.lua

local KillSynchronizerExtension = class("KillSynchronizerExtension", "EventSynchronizerBaseExtension")

KillSynchronizerExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	KillSynchronizerExtension.super.init(self, extension_init_context, unit, extension_init_data, ...)

	self._objective_name = "default"
	self._progression = 0
	self._registered_units = {}
	self._num_registered_units = 0
	self._check_unit_condition_timer = 0
	self._check_unit_condition_interval = 0.2
end

KillSynchronizerExtension.setup_from_component = function (self, objective_name, auto_start)
	self._objective_name = objective_name
	self._auto_start = auto_start
	self._group_id = self._mission_objective_system:register_objective_synchronizer(objective_name, nil, self._unit)
end

KillSynchronizerExtension.fixed_update = function (self, unit, dt, t)
	if self._mission_active and self._is_server and self._num_registered_units > 0 then
		local check_unit_condition_timer = self._check_unit_condition_timer

		if check_unit_condition_timer > 0 then
			check_unit_condition_timer = math.max(check_unit_condition_timer - dt, 0)
		else
			local registered_units = self._registered_units
			local health_progress = 0

			for minion_unit, _ in pairs(registered_units) do
				local health_extension = ScriptUnit.has_extension(minion_unit, "health_system")

				if health_extension then
					health_progress = health_progress + health_extension:current_health_percent()
				end
			end

			health_progress = 1 - health_progress / self._num_registered_units
			health_progress = math.clamp(health_progress, 0, 1)
			self._progression = health_progress
			check_unit_condition_timer = self._check_unit_condition_interval
		end

		self._check_unit_condition_timer = check_unit_condition_timer
	end
end

KillSynchronizerExtension.register_minion_unit = function (self, unit)
	local registered_units = self._registered_units

	registered_units[unit] = true
	self._registered_units = registered_units
	self._num_registered_units = self._num_registered_units + 1
end

KillSynchronizerExtension.progression = function (self)
	return self._progression
end

return KillSynchronizerExtension
