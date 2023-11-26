-- chunkname: @scripts/settings/volume_event/volume_event_functions.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local Attack = require("scripts/utilities/attack/attack")
local PlayerDeath = require("scripts/utilities/player_death")
local volume_event_functions = {}

volume_event_functions.player_instakill = {
	on_enter = function (entering_unit, dt, t, data)
		Log.info("VolumeEventFunctions", "Player (%q) entered kill volume", tostring(entering_unit))

		local reason = "kill_volume"

		PlayerDeath.die(entering_unit, nil, nil, reason)

		local attack_direction = Vector3.down()
		local damage_profile = DamageProfileTemplates.kill_volume_and_off_navmesh

		Attack.execute(entering_unit, damage_profile, "instakill", true, "attack_direction", attack_direction)
	end
}
volume_event_functions.minion_instakill = {
	on_enter = function (entering_unit, dt, t, data)
		Log.info("VolumeEventFunctions", "Minion (%q) entered kill volume", tostring(entering_unit))

		local attack_direction = Vector3.down()
		local damage_profile = DamageProfileTemplates.kill_volume_and_off_navmesh
		local health_extension = ScriptUnit.has_extension(entering_unit, "health_system")
		local last_damaging_unit = health_extension and health_extension:last_damaging_unit()

		Attack.execute(entering_unit, damage_profile, "instakill", true, "attack_direction", attack_direction, "attacking_unit", last_damaging_unit)
	end
}
volume_event_functions.end_zone = {
	on_enter = function (entering_unit, dt, t, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")

		trigger_extension:on_volume_enter(entering_unit, dt, t)
	end,
	on_exit = function (exiting_unit, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")

		trigger_extension:on_volume_exit(exiting_unit)
	end
}
volume_event_functions.trigger = {
	on_enter = function (entering_unit, dt, t, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")

		trigger_extension:on_volume_enter(entering_unit, dt, t)
	end,
	on_exit = function (exiting_unit, data)
		local volume_unit = data.connected_units
		local trigger_extension = ScriptUnit.extension(volume_unit, "trigger_system")

		trigger_extension:on_volume_exit(exiting_unit)
	end
}

return settings("VolumeEventFunctions", volume_event_functions)
