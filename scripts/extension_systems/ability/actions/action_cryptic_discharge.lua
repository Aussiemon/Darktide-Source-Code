-- chunkname: @scripts/extension_systems/ability/actions/action_cryptic_discharge.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local MinionState = require("scripts/utilities/minion_state")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Toughness = require("scripts/utilities/toughness/toughness")
local Vo = require("scripts/utilities/vo")
local BROADPHASE_RESULTS = {}
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local cryptic_talent_settings = TalentSettings.cryptic
local discharge_ability_talent_settings = cryptic_talent_settings.discharge_ability
local ActionCrypticDischarge = class("ActionCrypticDischarge", "ActionAbilityBase")
local external_properties = {}

ActionCrypticDischarge.init = function (self, action_context, action_params, action_settings)
	ActionCrypticDischarge.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._talent_extension = ScriptUnit.extension(self._player_unit, "talent_system")
end

ActionCrypticDischarge.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionCrypticDischarge.super.start(self, action_settings, t, time_scale, action_start_params)

	local ability_charges_used_at_start = self._ability_charges_used_at_start
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local talent_extension = self._talent_extension
	local vo_tag = action_settings.vo_tag

	Vo.play_combat_ability_event(player_unit, vo_tag)

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	local ability = self._ability

	external_properties.ability_template = ability and ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)

	self._num_hits = 0

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	self._combat_ability_component.active = true

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit
		param_table.ability_charges_used = ability_charges_used_at_start
		param_table.remaining_ability_charges_before_use = self._remaining_ability_charges_before_use_at_start

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	local is_server = self._is_server

	if not is_server then
		return
	end

	local always_give_full_charges_bonus = buff_extension:has_keyword("cryptic_discharge_ability_always_full_charges_bonus")
	local target_num_ability_charges_effect = always_give_full_charges_bonus and 3 or ability_charges_used_at_start
	local base_ability = action_settings.base_ability

	if base_ability then
		local explosion_template = target_num_ability_charges_effect == 1 and ExplosionTemplates.cryptic_discharge_aoe_electrocution_base or target_num_ability_charges_effect == 2 and ExplosionTemplates.cryptic_discharge_aoe_electrocution_base_two or target_num_ability_charges_effect == 3 and ExplosionTemplates.cryptic_discharge_aoe_electrocution_base_three

		Explosion.create_explosion(self._world, self._physics_world, player_position, Quaternion.identity(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, nil, true)
	else
		local explosion_template = ExplosionTemplates.cryptic_discharge_aoe_electrocution

		Explosion.create_explosion(self._world, self._physics_world, player_position, Quaternion.identity(), player_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion, nil, true)

		if target_num_ability_charges_effect >= discharge_ability_talent_settings.two_charge_bonus.num_charges_used_required and talent_extension:has_special_rule("cryptic_discharge_gives_attack_speed") then
			buff_extension:add_internally_controlled_buff("cryptic_discharge_attack_speed_increase", t)
		end

		if talent_extension:has_special_rule("cryptic_discharge_restores_toughness_on_use") then
			Toughness.replenish_percentage(player_unit, discharge_ability_talent_settings.cryptic_discharge_toughness.toughness_percent_on_use, false, "ability_shout")
		end

		if talent_extension:has_special_rule("cryptic_discharge_generates_arcs") then
			self:_trigger_arcs_in_front(target_num_ability_charges_effect)
		end

		if target_num_ability_charges_effect < 2 then
			return
		end

		local weapon_malfunction_explosion_template = ExplosionTemplates.cryptic_discharge_weapon_malfunction

		Explosion.create_explosion(self._world, self._physics_world, player_position + Vector3.up() * 1.5, Quaternion.identity(), player_unit, weapon_malfunction_explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)

		if target_num_ability_charges_effect < 3 then
			return
		end

		buff_extension:add_internally_controlled_buff("cryptic_discharge_weapon_shock_effect", t)
	end
end

ActionCrypticDischarge.finish = function (self, reason, data, t, time_in_action, action_settings)
	self._combat_ability_component.active = false
end

ActionCrypticDischarge._trigger_arcs_in_front = function (self, num_charges_used)
	if not self._is_server or not HEALTH_ALIVE[self._player_unit] then
		return
	end

	local num_arcs_per_charge_used = discharge_ability_talent_settings.cryptic_discharge_arc_bonus.num_arcs_per_charge_used
	local max_num_arcs = math.clamp(num_charges_used * num_arcs_per_charge_used, 0, discharge_ability_talent_settings.cryptic_discharge_arc_bonus.max_arcs)

	if max_num_arcs <= 0 then
		return
	end

	local first_person_component = self._first_person_component
	local player_rotation = first_person_component.rotation
	local player_forward_flat = Vector3.normalize(Vector3.flat(Quaternion.forward(player_rotation)))
	local fx_system = Managers.state.extension:system("fx_system")
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[self._player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local player_position = POSITION_LOOKUP[self._player_unit]
	local arc_source_position = player_position + Vector3.multiply(Vector3.up(), 0.8)
	local broadphase_radius = discharge_ability_talent_settings.cryptic_discharge_arc_bonus.broadphase_radius
	local template_effect_name = "discharge_ability_arc_chain_lightning_source"
	local template_effect = EffectTemplates[template_effect_name]
	local num_arcs_created = 0
	local num_hits = broadphase.query(broadphase, player_position, broadphase_radius, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local unit_data_extension = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local untargetable = breed and breed.is_untargetable

		if HEALTH_ALIVE[enemy_unit] and not untargetable then
			local enemy_position = POSITION_LOOKUP[enemy_unit]
			local is_enemy_in_front = Vector3.dot(Vector3.normalize(enemy_position - player_position), player_forward_flat) > 0.5

			if is_enemy_in_front then
				num_arcs_created = num_arcs_created + 1

				fx_system:start_player_template_effect(template_effect, self._player_unit, enemy_unit, nil, arc_source_position)

				if max_num_arcs <= num_arcs_created then
					break
				end
			end
		end
	end
end

return ActionCrypticDischarge
