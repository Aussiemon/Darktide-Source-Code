require("scripts/extension_systems/weapon/actions/action_weapon_base")

local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Suppression = require("scripts/utilities/attack/suppression")
local WarpCharge = require("scripts/utilities/warp_charge")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local proc_events = BuffSettings.proc_events
local buff_keywords = BuffSettings.keywords
local hit_zone_names = HitZone.hit_zone_names
local ActionDamageTarget = class("ActionDamageTarget", "ActionWeaponBase")

ActionDamageTarget.init = function (self, action_context, action_params, action_settings)
	ActionDamageTarget.super.init(self, action_context, action_params, action_settings)

	self._action_settings = action_settings
	local unit_data_extension = action_context.unit_data_extension
	self._warp_charge_component = unit_data_extension:write_component("warp_charge")
	self._action_module_charge_component = unit_data_extension:write_component("action_module_charge")
	self._action_module_targeting_component = unit_data_extension:write_component("action_module_targeting")
end

ActionDamageTarget.start = function (self, action_settings, t, time_scale, start_params)
	ActionDamageTarget.super.start(self, action_settings, t, time_scale, start_params)

	self._dealt_damage = false
	local last_action_warp_charge_percent = start_params.starting_warp_charge_percent

	if last_action_warp_charge_percent then
		local base_warp_charge_template = WarpCharge.archetype_warp_charge_template(self._player)
		local extreme_warp_charge_threshold = base_warp_charge_template.extreme_threshold
		local dif = 1 - extreme_warp_charge_threshold
		local stat_buffs = self._buff_extension:stat_buffs()
		local warp_charge_reduction = stat_buffs.warp_charge_amount or 1
		local new_dif = dif * warp_charge_reduction
		extreme_warp_charge_threshold = 1 - new_dif
		local empowered_grenade = self._buff_extension:has_keyword(buff_keywords.psyker_empowered_grenade)

		if empowered_grenade or last_action_warp_charge_percent < extreme_warp_charge_threshold then
			self._prevent_explosion = true
		end
	end
end

ActionDamageTarget.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings
	local prevent_explosion = self._prevent_explosion
	local targeting_component = self._action_module_targeting_component
	local fire_time = action_settings.fire_time or 0
	local should_fire = ActionUtility.is_within_trigger_time(time_in_action, dt, fire_time)
	local target_unit = targeting_component.target_unit_1

	if should_fire then
		local charge_level = self:_consume_charge_level()

		if target_unit then
			local dealt_damage = self:_deal_damage(charge_level)

			if prevent_explosion and dealt_damage then
				self:_pay_warp_charge_cost_immediate(t, charge_level)
			else
				self._charge_level = charge_level
				self._dealt_damage = dealt_damage
			end
		end

		self:_play_particles()
	end

	if not prevent_explosion then
		local warp_charge_time = action_settings.pay_warp_charge_time or 0.5
		local should_add_warp_charge = ActionUtility.is_within_trigger_time(time_in_action, dt, warp_charge_time)

		if self._dealt_damage and should_add_warp_charge then
			self:_pay_warp_charge_cost_immediate(t, self._charge_level, true)
		end
	end
end

ActionDamageTarget._consume_charge_level = function (self)
	if not self._action_settings.use_charge_level then
		return 1
	end

	local action_module_charge_component = self._action_module_charge_component
	local charge_level = action_module_charge_component.charge_level
	action_module_charge_component.charge_level = 0

	return charge_level
end

ActionDamageTarget._deal_damage = function (self, charge_level)
	local action_settings = self._action_settings
	local player_unit = self._player_unit
	local targeting_component = self._action_module_targeting_component
	local damage_profile = action_settings.damage_profile
	local damage_type = action_settings.damage_type
	local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL
	local target_unit = targeting_component.target_unit_1

	if not HEALTH_ALIVE[target_unit] then
		return false
	end

	local hit_unit_pos = POSITION_LOOKUP[target_unit]
	local player_pos = POSITION_LOOKUP[player_unit]
	local attack_direction = Vector3.normalize(hit_unit_pos - player_pos)
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed = target_unit_data_extension and target_unit_data_extension:breed()
	local hit_world_position = hit_unit_pos
	local hit_zone_name, hit_actor = nil

	if target_breed then
		local hit_zone_weakspot_types = target_breed.hit_zone_weakspot_types
		local preferred_hit_zone_name = "head"
		local hit_zone = hit_zone_weakspot_types and (hit_zone_weakspot_types[preferred_hit_zone_name] and preferred_hit_zone_name or next(hit_zone_weakspot_types)) or hit_zone_names.center_mass
		local actors = HitZone.get_actor_names(target_unit, hit_zone)
		local hit_actor_name = actors[1]
		hit_zone_name = hit_zone
		hit_actor = Unit.actor(target_unit, hit_actor_name)
		local actor_node = Actor.node(hit_actor)
		hit_world_position = Unit.world_position(target_unit, actor_node)
	end

	if self._is_server then
		local suppression_settings = action_settings.suppression_settings

		if suppression_settings then
			Suppression.apply_area_minion_suppression(player_unit, suppression_settings, hit_unit_pos)
		end
	end

	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = self._player_unit
		param_table.target_unit = target_unit
		param_table.damage_type = damage_type

		self._buff_extension:add_proc_event(proc_events.on_action_damage_target, param_table)
	end

	local herding_template = action_settings.herding_template
	local damage_dealt, attack_result, damage_efficiency = Attack.execute(target_unit, damage_profile, "power_level", power_level, "charge_level", charge_level, "hit_world_position", hit_world_position, "hit_zone_name", hit_zone_name, "hit_actor", hit_actor, "attacking_unit", player_unit, "attack_direction", attack_direction, "herding_template", herding_template, "attack_type", AttackSettings.attack_types.ranged, "damage_type", damage_type, "item", self._weapon.item)

	ImpactEffect.play(target_unit, hit_actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, nil, attack_direction, player_unit, nil, nil, nil, damage_efficiency, damage_profile)

	return true
end

ActionDamageTarget.finish = function (self, reason, data, t, time_in_action)
	local action_settings = self._action_settings

	if not self._prevent_explosion and self._dealt_damage then
		local warp_charge_time = action_settings.pay_warp_charge_time or 0.5

		if time_in_action < warp_charge_time then
			self:_pay_warp_charge_cost_immediate(t, self._charge_level or 1)
		end
	end

	ActionDamageTarget.super.finish(self, reason, data, t, time_in_action)

	self._action_module_targeting_component.target_unit_1 = nil
	self._prevent_explosion = nil
end

ActionDamageTarget._play_particles = function (self)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local fx = self._action_settings.fx

	if not fx then
		return
	end

	local effect_name = fx.vfx_effect

	if not effect_name then
		return
	end

	local spawner_name = fx.fx_source
	local fx_extension = self._fx_extension
	local link = true
	local orphaned_policy = "stop"
	local position_offset = fx.fx_position_offset and fx.fx_position_offset:unbox()
	local rotation_offset = fx.fx_rotation_offset and fx.fx_rotation_offset:unbox()

	fx_extension:spawn_unit_particles(effect_name, spawner_name, link, orphaned_policy, position_offset, rotation_offset)
end

return ActionDamageTarget
