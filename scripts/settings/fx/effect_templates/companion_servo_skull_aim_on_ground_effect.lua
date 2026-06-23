-- chunkname: @scripts/settings/fx/effect_templates/companion_servo_skull_aim_on_ground_effect.lua

local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local CompanionServoSkullAimOnGroundEffectSettings = require("scripts/settings/companion/companion_servo_skull_aim_on_ground_effect_settings")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local special_rules = SpecialRulesSettings.special_rules
local servo_skull_flamethrower_types = CompanionServoSkullSettings.FLAMETHROWER_TYPES
local vfx = CompanionServoSkullAimOnGroundEffectSettings.vfx
local _spawn_effects, _destroy_effects, _update_effect_positions, _get_target_position, _select_aim_on_ground_effect
local resources = {
	resources_vfx = vfx,
}
local effect_template = {
	name = "companion_servo_skull_aim_on_ground_effect",
	resources = resources,
	start = function (template_data, template_context)
		if DEDICATED_SERVER then
			return
		end

		local unit = template_data.unit
		local player = Managers.state.player_unit_spawn:owner(unit)
		local is_local_unit = not player.remote

		template_data.is_local_unit = is_local_unit

		if not is_local_unit then
			return
		end

		local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

		if not fx_extension then
			return
		end

		local player_owner = Managers.state.player_unit_spawn:owner(unit)
		local player_unit = player_owner and player_owner.player_unit

		if not player_unit then
			return
		end

		template_data._player_unit = player_unit

		local fx_system = Managers.state.extension:system("fx_system")

		template_data.fx_system = fx_system

		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

		template_data._unit_data_extension = unit_data_extension
		template_data._input_extension = ScriptUnit.extension(player_unit, "input_system")
		template_data._talent_extension = ScriptUnit.extension(player_unit, "talent_system")
		template_data._ability_extension = ScriptUnit.extension(player_unit, "ability_system")
		template_data._companion_spawner_extension = ScriptUnit.extension(player_unit, "companion_spawner_system")
		template_data._position_finder_component = unit_data_extension:read_component("action_module_position_finder")
		template_data._action_module_target_finder_component = unit_data_extension:read_component("action_module_ability_target_finder")
		template_data._combat_ability_action_component = unit_data_extension:read_component("combat_ability_action")
		template_data._grenade_ability_action_component = unit_data_extension:read_component("grenade_ability_action")
		template_data._world = template_context.world
	end,
	update = function (template_data, template_context, dt, t)
		if DEDICATED_SERVER or not template_data.is_local_unit then
			return
		end

		local position_finder_component = template_data._position_finder_component
		local target_finder_component = template_data._action_module_target_finder_component
		local position_valid = position_finder_component.position_valid
		local combat_ability_action_component = template_data._combat_ability_action_component
		local grenade_ability_action_component = template_data._grenade_ability_action_component
		local current_combat_action_name = combat_ability_action_component.current_action_name
		local current_grenade_action_name = grenade_ability_action_component.current_action_name
		local target_unit_1 = target_finder_component.target_unit_1

		if CompanionServoSkullAbility.effect_validate_target_func(template_data._unit_data_extension, target_unit_1, template_data._ability_extension, template_data._companion_spawner_extension, template_data._input_extension, template_data._talent_extension) then
			local targeting_fx_name = vfx.medicae_particle

			if template_data._targeting_fx_name ~= targeting_fx_name then
				_destroy_effects(template_data)
			end

			if not template_data._targeting_effect_id then
				_spawn_effects(template_data, targeting_fx_name)
			end

			if ALIVE[template_data._player_unit] and template_data._targeting_effect_id then
				_update_effect_positions(template_data)
			end
		else
			local targeting_fx_name = _select_aim_on_ground_effect(template_data._talent_extension, template_data._companion_spawner_extension)

			if not targeting_fx_name then
				_destroy_effects(template_data)

				return
			end

			if template_data._targeting_fx_name ~= targeting_fx_name then
				_destroy_effects(template_data)
			end

			if position_valid and not template_data._targeting_effect_id and CompanionServoSkullAbility.can_aim_on_ground(template_data._unit_data_extension, template_data._ability_extension, template_data._companion_spawner_extension, template_data._input_extension, template_data._talent_extension) then
				_spawn_effects(template_data, targeting_fx_name)
			elseif template_data._targeting_effect_id and (not position_valid or current_combat_action_name ~= "action_aim" and current_grenade_action_name ~= "action_aim") then
				_destroy_effects(template_data)
			end

			if ALIVE[template_data._player_unit] and template_data._targeting_effect_id then
				_update_effect_positions(template_data)
			end
		end
	end,
	stop = function (template_data, template_context)
		if DEDICATED_SERVER or not template_data.is_local_unit then
			return
		end

		_destroy_effects(template_data)
	end,
}

function _spawn_effects(template_data, targeting_fx_name)
	local world = template_data._world
	local spawn_pos = _get_target_position(template_data)
	local effect_id = World.create_particles(world, targeting_fx_name, spawn_pos)

	template_data._targeting_effect_id = effect_id
	template_data._targeting_fx_name = targeting_fx_name
end

function _destroy_effects(template_data)
	if template_data._targeting_effect_id then
		World.destroy_particles(template_data._world, template_data._targeting_effect_id)

		template_data._targeting_effect_id = nil
	end
end

function _update_effect_positions(template_data)
	local effect_id = template_data._targeting_effect_id

	if effect_id then
		local target_position = _get_target_position(template_data)
		local unit_position = POSITION_LOOKUP[template_data._player_unit]
		local direction = Vector3.normalize(Vector3.flat(target_position - unit_position))
		local rotation = Quaternion.look(direction)

		World.move_particles(template_data._world, effect_id, target_position, rotation)
	end
end

function _get_target_position(template_data)
	local position_finder_component = template_data._position_finder_component
	local target_finder_component = template_data._action_module_target_finder_component

	if HEALTH_ALIVE[target_finder_component.target_unit_1] then
		return POSITION_LOOKUP[target_finder_component.target_unit_1]
	else
		return position_finder_component.position
	end
end

function _select_aim_on_ground_effect(talent_extension, companion_spawner_extension)
	if not talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) then
		return nil
	end

	local companion_unit = companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_flamethrower)

	if not companion_unit then
		return
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(companion_unit)
	local current_flamethrower_type = GameSession.game_object_field(game_session, game_object_id, "flamethrower_type")

	if talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) and current_flamethrower_type == servo_skull_flamethrower_types.circle then
		return vfx.flame_circle_particle
	elseif talent_extension:has_special_rule(special_rules.cryptic_servo_skull_flamethrower) and current_flamethrower_type == servo_skull_flamethrower_types.cone then
		return vfx.flame_cone_particle
	end
end

return effect_template
