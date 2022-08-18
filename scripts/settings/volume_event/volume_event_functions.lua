local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionDeath = require("scripts/utilities/minion_death")
local PlayerDeath = require("scripts/utilities/player_death")
local volume_event_functions = {
	player_instakill = {
		on_enter = function (entering_unit, dt, t, data)
			Log.info("VolumeEventFunctions", "Player (%q) entered kill volume", tostring(entering_unit))
			PlayerDeath.die(entering_unit)
		end
	},
	minion_instakill = {
		on_enter = function (entering_unit, dt, t, data)
			Log.info("VolumeEventFunctions", "Minion (%q) entered kill volume", tostring(entering_unit))

			local attack_direction = Vector3.down()
			local damage_profile = DamageProfileTemplates.minion_instakill

			MinionDeath.die(entering_unit, nil, attack_direction, nil, damage_profile, nil, nil, nil, nil)
		end
	}
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
