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
volume_event_functions.minion_instakill_with_gibbing = {
	on_enter = function (entering_unit, dt, t, data)
		Log.info("VolumeEventFunctions", "Minion (%q) entered kill volume", tostring(entering_unit))

		local random_x = math.random() * 2 - 1
		local random_y = math.random() * 2 - 1
		local random_z = math.random() * 2 - 1
		local attack_direction = Vector3(random_x, random_y, random_z)
		local damage_profile = DamageProfileTemplates.kill_volume_with_gibbing
		local health_extension = ScriptUnit.has_extension(entering_unit, "health_system")
		local last_damaging_unit = health_extension and health_extension:last_damaging_unit()

		Attack.execute(entering_unit, damage_profile, "instakill", true, "attack_direction", attack_direction, "attacking_unit", last_damaging_unit, "hit_zone_name", "center_mass")

		local fx_system = Managers.state.extension:system("fx_system")
		local position = POSITION_LOOKUP[entering_unit]

		if position then
			local wwise_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"

			fx_system:trigger_wwise_event(wwise_event, position)
		end

		local connected_units = data.connected_units
		local num_connected_units = #connected_units

		if num_connected_units > 0 then
			for i = 1, num_connected_units do
				local unit = connected_units[i]

				Unit.flow_event(unit, "lua_connected_volume_minion_kill")
			end
		end
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
