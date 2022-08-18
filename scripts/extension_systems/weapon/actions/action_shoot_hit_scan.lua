require("scripts/extension_systems/weapon/actions/action_shoot")

local HitScan = require("scripts/utilities/attack/hit_scan")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local RangedAction = require("scripts/utilities/action/ranged_action")
local proc_events = BuffSettings.proc_events
local ActionShootHitScan = class("ActionShootHitScan", "ActionShoot")
local IMPACT_FX_DATA = {
	will_be_predicted = true
}
local ALL_HITS = {}
local INDEX_DISTANCE = 2
local _hit_sort_function = nil

ActionShootHitScan._shoot = function (self, position, rotation, power_level, charge_level)
	local debug_drawer = self._debug_drawer
	local is_local_unit = self._is_local_unit
	local is_server = self._is_server
	local physics_world = self._physics_world
	local player = self._player
	local player_unit = self._player_unit
	local world = self._world
	local weapon_item = self._weapon.item
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration
	local hit_scan_template = fire_config.hit_scan_template
	local max_distance = hit_scan_template.range
	local is_critical_strike = self._critical_strike_component.is_active
	local direction = Quaternion.forward(rotation)
	local instakill = false
	local end_position = nil
	local rewind_ms = self:_rewind_ms(is_local_unit, player, position, direction, max_distance)
	local collision_tests = hit_scan_template.collision_tests

	if collision_tests then
		table.clear(ALL_HITS)

		for i = 1, #collision_tests, 1 do
			local config = collision_tests[i]
			local test = config.test
			local against = config.against
			local collision_filter = config.collision_filter

			if test == "ray" then
				local hits = HitScan.raycast(physics_world, position, direction, max_distance, against, collision_filter, rewind_ms, is_local_unit, player, is_server)

				if hits then
					table.append(ALL_HITS, hits)
				end
			elseif test == "sphere" then
				local hits = HitScan.sphere_sweep(physics_world, position, direction, max_distance, against, collision_filter, rewind_ms)

				if hits then
					table.append(ALL_HITS, hits)
				end
			end
		end

		table.sort(ALL_HITS, _hit_sort_function)

		end_position = HitScan.process_hits(is_server, world, physics_world, player_unit, fire_config, ALL_HITS, position, direction, power_level, charge_level, IMPACT_FX_DATA, max_distance, debug_drawer, is_local_unit, player, instakill, is_critical_strike, weapon_item)
	else
		local hits = HitScan.raycast(physics_world, position, direction, max_distance, nil, nil, rewind_ms, is_local_unit, player, is_server)
		end_position = HitScan.process_hits(is_server, world, physics_world, player_unit, fire_config, hits, position, direction, power_level, charge_level, IMPACT_FX_DATA, max_distance, debug_drawer, is_local_unit, player, instakill, is_critical_strike, weapon_item)
	end

	local attacker_buff_extension = ScriptUnit.extension(player_unit, "buff_system")
	local param_table = attacker_buff_extension:request_proc_event_param_table()
	param_table.attacking_unit = player_unit

	attacker_buff_extension:add_proc_event(proc_events.on_shoot, param_table)

	end_position = end_position or position + direction * max_distance
	local fx_settings = action_settings.fx
	local line_effect = fx_settings and fx_settings.line_effect

	self:_play_line_fx(line_effect, position, end_position)
end

function _hit_sort_function(entry_1, entry_2)
	local distance_1 = entry_1.distance or entry_1[INDEX_DISTANCE]
	local distance_2 = entry_2.distance or entry_2[INDEX_DISTANCE]

	return distance_1 < distance_2
end

return ActionShootHitScan
