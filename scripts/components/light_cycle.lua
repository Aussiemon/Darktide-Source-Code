-- chunkname: @scripts/components/light_cycle.lua

local LightCycle = component("LightCycle")

LightCycle.init = function (self, unit)
	if self:get_data(unit, "start_enabled") then
		self:start(unit)
	else
		self:stop(unit)
	end
end

LightCycle.editor_init = function (self, unit)
	self:init(unit)
	self:editor_update_gizmo(unit)
end

LightCycle.editor_property_changed = function (self, unit)
	self:editor_update_gizmo(unit)
end

LightCycle.enable = function (self, unit)
	return
end

LightCycle.disable = function (self, unit)
	return
end

LightCycle.destroy = function (self, unit)
	return
end

LightCycle.editor_validate = function (self, unit)
	return true, ""
end

LightCycle.editor_update_gizmo = function (self, unit)
	local distance = self:get_data(unit, "distance")

	Unit.set_local_position(unit, Unit.node(unit, "g_gizmo_end"), Vector3(0, distance, 0))
end

LightCycle.start = function (self, unit)
	local distance = self:get_data(unit, "distance")

	Unit.set_local_scale(unit, Unit.node(unit, "ap_scl_01"), Vector3(1, distance, 1))

	local speed = self:get_data(unit, "speed")
	local animation_speed = 1 / distance

	Unit.set_flow_variable(unit, "lua_anim_speed", animation_speed * speed)
	Unit.flow_event(unit, "lua_anim_play")
end

LightCycle.stop = function (self, unit)
	Unit.set_local_scale(unit, Unit.node(unit, "ap_scl_01"), Vector3(1, 0.001, 1))
	Unit.flow_event(unit, "lua_anim_stop")
end

LightCycle.component_data = {
	distance = {
		ui_type = "slider",
		min = 0,
		step = 1,
		decimals = 1,
		value = 1,
		ui_name = "Distance (Meters)",
		max = 100
	},
	speed = {
		ui_type = "number",
		decimals = 1,
		value = 1,
		ui_name = "Speed (Meters per Second)",
		step = 1
	},
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Enabled"
	},
	inputs = {
		start = {
			accessibility = "public",
			type = "event"
		},
		stop = {
			accessibility = "public",
			type = "event"
		}
	}
}

return LightCycle
