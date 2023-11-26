-- chunkname: @scripts/components/corruptor.lua

local Corruptor = component("Corruptor")

Corruptor.init = function (self, unit)
	local corruptor_extension = ScriptUnit.fetch_component_extension(unit, "corruptor_system")

	if corruptor_extension then
		local use_trigger = self:get_data(unit, "use_trigger")

		corruptor_extension:setup_from_component(use_trigger)

		self._corruptor_extension = corruptor_extension
	end
end

Corruptor.editor_init = function (self, unit)
	return
end

Corruptor.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") and not Unit.has_animation_state_machine(unit) then
		error_message = error_message .. "\nmissing animation state machine"
		success = false
	end

	return success, error_message
end

Corruptor.enable = function (self, unit)
	return
end

Corruptor.disable = function (self, unit)
	return
end

Corruptor.destroy = function (self, unit)
	return
end

Corruptor.events.demolition_segment_start = function (self)
	if self._corruptor_extension then
		self._corruptor_extension:awake()
	end
end

Corruptor.events.demolition_stage_start = function (self)
	if self._corruptor_extension then
		self._corruptor_extension:expose()
	end
end

Corruptor.events.died = function (self)
	if self._corruptor_extension then
		self._corruptor_extension:died()
	end
end

Corruptor.events.add_damage = function (self, damage, hit_actor, attack_direction)
	if self._corruptor_extension then
		self._corruptor_extension:damaged(damage)
	end
end

Corruptor.activate_segment_units = function (self)
	if self._corruptor_extension then
		self._corruptor_extension:activate_segment_units()
	end
end

Corruptor.component_data = {
	use_trigger = {
		ui_type = "check_box",
		value = false,
		ui_name = "Use Trigger"
	},
	inputs = {
		activate_segment_units = {
			accessibility = "private",
			type = "event"
		}
	},
	extensions = {
		"CorruptorExtension"
	}
}

return Corruptor
