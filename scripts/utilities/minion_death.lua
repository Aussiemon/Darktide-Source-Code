local AttackSettings = require("scripts/settings/damage/attack_settings")
local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local attack_results = AttackSettings.attack_results
local damage_efficiencies = AttackSettings.damage_efficiencies
local MinionDeath = {}
local _gib, _push_ragdoll = nil

MinionDeath.die = function (unit, attacking_unit_or_nil, attack_direction, hit_zone_name_or_nil, damage_profile, attack_type_or_nil, herding_template_or_nil, is_critical_strike_or_nil, damage_type_or_nil)
	Managers.state.minion_death:die(unit, attacking_unit_or_nil, attack_direction, hit_zone_name_or_nil, damage_profile, attack_type_or_nil, herding_template_or_nil, damage_type_or_nil)
	_gib(unit, hit_zone_name_or_nil, attack_direction, damage_profile, is_critical_strike_or_nil)
end

MinionDeath.set_dead = function (unit, attack_direction, hit_zone_name, damage_profile_name, do_ragdoll_push, herding_template_name_or_nil)
	local unit_id = Managers.state.unit_spawner:game_object_id(unit)
	local minion_death_manager = Managers.state.minion_death

	minion_death_manager:set_dead(unit, attack_direction, hit_zone_name, damage_profile_name, do_ragdoll_push, herding_template_name_or_nil)

	local hit_zone_id = hit_zone_name and NetworkLookup.hit_zones[hit_zone_name] or nil
	local damage_profile_id = NetworkLookup.damage_profile_templates[damage_profile_name]
	local herding_template_id = herding_template_name_or_nil and NetworkLookup.herding_templates[herding_template_name_or_nil] or nil

	Managers.state.game_session:send_rpc_clients("rpc_minion_set_dead", unit_id, attack_direction, hit_zone_id, damage_profile_id, do_ragdoll_push == true, herding_template_id)
end

local IMPACT_FX_DATA = {
	local_only = true
}

MinionDeath.attack_ragdoll = function (ragdoll_unit, attack_direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_world_position_or_nil, attacking_unit_or_nil, hit_actor_or_nil, herding_template_or_nil, critical_strike_or_nil)
	if not DEDICATED_SERVER then
		local attack_ragdolls_enabled_locally = Application.user_setting("gore_settings", "attack_ragdolls_enabled")

		if attack_ragdolls_enabled_locally == nil then
			attack_ragdolls_enabled_locally = DefaultGameParameters.attack_ragdolls_enabled
		end

		if not attack_ragdolls_enabled_locally then
			return
		end

		local hit_zone_name = hit_zone_name_or_nil or "center_mass"

		_push_ragdoll(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, herding_template_or_nil)
		_gib(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, critical_strike_or_nil)

		local damage = 1
		local attack_result = attack_results.damaged
		local hit_normal = nil
		local attack_was_stopped = false
		local damage_efficiency = damage_efficiencies.full

		ImpactEffect.play(ragdoll_unit, hit_actor_or_nil, damage, damage_type, hit_zone_name, attack_result, hit_world_position_or_nil, hit_normal, attack_direction, attacking_unit_or_nil, IMPACT_FX_DATA, attack_was_stopped, nil, damage_efficiency, nil)
	end
end

function _push_ragdoll(ragdoll_unit, hit_zone_name, attack_direction, damage_profile, herding_template_or_nil)
	local minion_death_manager = Managers.state.minion_death
	local minion_ragdoll = minion_death_manager:minion_ragdoll()
	local on_dead_ragdoll = true

	minion_ragdoll:push_ragdoll(ragdoll_unit, attack_direction, damage_profile, hit_zone_name, herding_template_or_nil, on_dead_ragdoll)
end

function _gib(ragdoll_unit, hit_zone_name_or_nil, attack_direction, damage_profile, is_critical_strike_or_nil)
	local visual_loadout_extension = ScriptUnit.extension(ragdoll_unit, "visual_loadout_system")

	if visual_loadout_extension:can_gib(hit_zone_name_or_nil) then
		visual_loadout_extension:gib(hit_zone_name_or_nil, attack_direction, damage_profile, is_critical_strike_or_nil)
	end
end

return MinionDeath
