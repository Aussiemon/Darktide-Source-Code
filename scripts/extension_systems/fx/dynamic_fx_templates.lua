-- chunkname: @scripts/extension_systems/fx/dynamic_fx_templates.lua

local DynamicFXTemplates = {}

DynamicFXTemplates.flow_velocity_parameter = {
	func = function (unit, scratch)
		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local current_velocity = locomotion_extension:current_velocity()
		local current_speed = Vector3.length(current_velocity)
		local max_speed = navigation_extension:max_speed()
		local percentage_fwd = 1

		if current_speed > 1e-06 then
			local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))

			percentage_fwd = Vector3.dot(Vector3.normalize(current_velocity), fwd)
		end

		if current_speed ~= scratch.speed or max_speed ~= scratch.max_speed or percentage_fwd ~= scratch.percentage_fwd then
			scratch.speed = current_speed
			scratch.max_speed = max_speed
			scratch.percentage_fwd = percentage_fwd

			Unit.set_flow_variable(unit, "lua_percentage_speed", max_speed > 0 and math.clamp01(current_speed / max_speed) or 0)
			Unit.set_flow_variable(unit, "lua_speed", current_speed)
			Unit.set_flow_variable(unit, "lua_percentage_velocity_fwd", percentage_fwd)
			Unit.flow_event(unit, "lua_on_velocity_change")
		end
	end,
}

return DynamicFXTemplates
