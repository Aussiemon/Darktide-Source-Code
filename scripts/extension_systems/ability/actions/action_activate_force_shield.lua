-- chunkname: @scripts/extension_systems/ability/actions/action_activate_force_shield.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MasterItems = require("scripts/backend/master_items")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Vo = require("scripts/utilities/vo")
local ActionActivateForceShield = class("ActionActivateForceShield", "ActionAbilityBase")
local attack_types = AttackSettings.attack_types
local special_rules = SpecialRulesSettings.special_rules
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local PEROSNAL_FORCE_FIELD_UNIT = "content/characters/player/human/attachments_combat/cryptic_force_field/cryptic_force_field_personal_functional"

ActionActivateForceShield.init = function (self, action_context, action_params, action_settings)
	ActionActivateForceShield.super.init(self, action_context, action_params, action_settings)

	self._talent_extension = ScriptUnit.has_extension(self._player_unit, "talent_system")
end

ActionActivateForceShield.start = function (self, action_settings, t, ...)
	ActionActivateForceShield.super.start(self, action_settings, t, ...)

	if not self._is_server then
		return
	end

	local player_unit = self._player_unit
	local material

	self._shield_unit, self._shield_game_object_id = Managers.state.unit_spawner:spawn_network_unit(PEROSNAL_FORCE_FIELD_UNIT, "cryptic_personal_force_field", self._first_person_component.position, Quaternion.identity(), material, PEROSNAL_FORCE_FIELD_UNIT, player_unit, action_settings.total_time)
	self._game_session = Managers.state.game_session:game_session()

	local trigger_explosion_at_half_time = self._talent_extension:has_special_rule(special_rules.cryptic_force_field_increased_duration_and_extra_explosion)

	self._trigger_explosion_at_time = trigger_explosion_at_half_time and t + action_settings.total_time * 0.5 or nil

	local player_position = POSITION_LOOKUP[player_unit]
	local explosion_template = ExplosionTemplates.cryptic_force_field_explosion

	Explosion.create_explosion(self._world, self._physics_world, player_position, Quaternion.identity(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)

	local buff_to_add = self._ability_template_tweak_data.buff_to_add

	if buff_to_add then
		local _, buff_id = self._buff_extension:add_externally_controlled_buff(buff_to_add, t)

		self._buff_id = buff_id
	end

	local vo_tag = action_settings.vo_tag

	if vo_tag then
		Vo.play_combat_ability_event(player_unit, vo_tag)
	end
end

ActionActivateForceShield.fixed_update = function (self, dt, t, time_in_action)
	if self._trigger_explosion_at_time and t >= self._trigger_explosion_at_time then
		self._trigger_explosion_at_time = nil

		local player_unit = self._player_unit
		local player_position = POSITION_LOOKUP[player_unit]
		local explosion_template = ExplosionTemplates.cryptic_force_field_explosion

		Explosion.create_explosion(self._world, self._physics_world, player_position, Quaternion.identity(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
	end
end

ActionActivateForceShield.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionActivateForceShield.super.finish(self, reason, data, t, time_in_action, action_settings)

	if not self._is_server then
		return
	end

	local shield_game_object_exists = GameSession.game_object_exists(self._game_session, self._shield_game_object_id)

	if shield_game_object_exists then
		GameSession.set_game_object_field(self._game_session, self._shield_game_object_id, "expired", true)
	end

	local player_unit = self._player_unit

	if not HEALTH_ALIVE[player_unit] then
		return
	end

	local player_position = POSITION_LOOKUP[player_unit]
	local explosion_template = ExplosionTemplates.cryptic_force_field_explosion

	Explosion.create_explosion(self._world, self._physics_world, player_position, Quaternion.identity(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)

	local leave_liquid_area = self._buff_extension:has_keyword("cryptic_force_field_liquid_area_when_expired")

	if leave_liquid_area then
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[player_unit]
		local player_side_name = side and side:name() or side
		local nav_world = Managers.state.nav_mesh:nav_world()
		local liquid_area_position = POSITION_LOOKUP[player_unit]
		local liquid_area_template = LiquidAreaTemplates.fire_grenade

		LiquidArea.try_create(liquid_area_position, Vector3.down(), nav_world, liquid_area_template, player_unit, nil, nil, nil, player_side_name)
	end

	self._buff_extension:remove_externally_controlled_buff(self._buff_id)
end

return ActionActivateForceShield
