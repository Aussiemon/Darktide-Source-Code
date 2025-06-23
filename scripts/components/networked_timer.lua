-- chunkname: @scripts/components/networked_timer.lua

local NetworkedTimer = component("NetworkedTimer")

NetworkedTimer.init = function (self, unit, is_server)
	self:enable(unit)

	local networked_timer_extension = ScriptUnit.fetch_component_extension(unit, "networked_timer_system")

	if networked_timer_extension then
		local duration = self:get_data(unit, "duration")
		local hud_description = self:get_data(unit, "hud_description")
		local max_speed_modifier = self:get_data(unit, "max_speed_modifier")
		local reset_speed_modifier_on_state_change = self:get_data(unit, "reset_speed_modifier_on_state_change")

		networked_timer_extension:setup_from_component(duration, hud_description, max_speed_modifier, reset_speed_modifier_on_state_change)

		self._networked_timer_extension = networked_timer_extension
	end
end

NetworkedTimer.editor_init = function (self, unit)
	return
end

NetworkedTimer.editor_validate = function (self, unit)
	return true, ""
end

NetworkedTimer.editor_update = function (self, unit, dt, t)
	return
end

NetworkedTimer.enable = function (self, unit)
	return
end

NetworkedTimer.disable = function (self, unit)
	return
end

NetworkedTimer.destroy = function (self, unit)
	return
end

NetworkedTimer.start = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:start()
	end
end

NetworkedTimer.pause = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:pause()
	end
end

NetworkedTimer.stop = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:stop()
	end
end

NetworkedTimer.fast_forward = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:fast_forward()
	end
end

NetworkedTimer.rewind = function (self)
	local networked_timer_extension = self._networked_timer_extension

	if networked_timer_extension then
		networked_timer_extension:rewind()
	end
end

NetworkedTimer.component_data = {
	duration = {
		ui_type = "number",
		value = 1,
		ui_name = "Duration (in sec.)",
		step = 0.01
	},
	hud_description = {
		ui_type = "text_box",
		value = "loc_description",
		ui_name = "HUD Description"
	},
	max_speed_modifier = {
		ui_type = "number",
		value = 1,
		ui_name = "Max Speed Modifier",
		step = 0.01
	},
	reset_speed_modifier_on_state_change = {
		ui_type = "check_box",
		value = true,
		ui_name = "Max Speed Modifier"
	},
	inputs = {
		start = {
			accessibility = "public",
			type = "event"
		},
		pause = {
			accessibility = "public",
			type = "event"
		},
		stop = {
			accessibility = "public",
			type = "event"
		},
		fast_forward = {
			accessibility = "public",
			type = "event"
		},
		rewind = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"NetworkedTimerExtension"
	}
}

return NetworkedTimer
