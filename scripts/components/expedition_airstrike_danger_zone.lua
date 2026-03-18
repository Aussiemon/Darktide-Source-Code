-- chunkname: @scripts/components/expedition_airstrike_danger_zone.lua

local ExpeditionAirstrikeDangerZone = component("ExpeditionAirstrikeDangerZone")

ExpeditionAirstrikeDangerZone.init = function (self, unit, is_server)
	local proximity_distance = self:get_data(unit, "proximity_distance")

	if Managers and Managers.event then
		Managers.event:trigger("event_register_danger_zone", unit, Unit.local_position(unit, 1), proximity_distance)
	end

	local run_update = false

	return run_update
end

ExpeditionAirstrikeDangerZone.editor_init = function (self, unit)
	return
end

ExpeditionAirstrikeDangerZone.editor_validate = function (self, unit)
	return true, ""
end

ExpeditionAirstrikeDangerZone._play_sfx = function (self, event)
	local wwise_world = self._wwise_world

	WwiseWorld.trigger_resource_event(wwise_world, event, self._source_id)
end

ExpeditionAirstrikeDangerZone.update = function (self, unit, dt, t)
	return true
end

ExpeditionAirstrikeDangerZone.events.add_damage = function (self, damage, hit_actor, attack_direction)
	return
end

ExpeditionAirstrikeDangerZone.enable = function (self, unit)
	return
end

ExpeditionAirstrikeDangerZone.disable = function (self, unit)
	return
end

ExpeditionAirstrikeDangerZone.destroy = function (self, unit)
	if Managers and Managers.event then
		Managers.event:trigger("event_unregister_danger_zone", unit)
	end
end

ExpeditionAirstrikeDangerZone.component_data = {
	proximity_distance = {
		decimals = 0,
		step = 1,
		ui_name = "Proximity Distance",
		ui_type = "number",
		value = 30,
	},
	inputs = {
		detonate = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ExpeditionAirstrikeDangerZone
