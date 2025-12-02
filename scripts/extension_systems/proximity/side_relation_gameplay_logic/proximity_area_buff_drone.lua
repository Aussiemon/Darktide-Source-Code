-- chunkname: @scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_area_buff_drone.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Component = require("scripts/utilities/component")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local JobInterface = require("scripts/managers/unit_job/job_interface")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local STOP_EVENT_TIME_OFFSET = 1
local ProximityAreaBuffDrone = class("ProximityAreaBuffDrone")
local adamant_talent_settings = TalentSettings.adamant
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local special_rules = SpecialRulesSettings.special_rules
local BROADPHASE_RESULTS = {}
local COMPONENT_STATES = table.enum("none", "active", "deployed", "deployed_about_to_expire")
local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"

ProximityAreaBuffDrone.init = function (self, logic_context, init_data, owner_unit_or_nil)
	local unit = logic_context.unit

	self._world = logic_context.world
	self._physics_world = logic_context.physics_world
	self._unit = unit
	self._side_name = logic_context.side_name
	self._units_in_proximity = {}
	self._units_affected_during_lifetime = {}
	self._allies_proximity_enter_time = {}

	local settings = init_data

	self._settings = settings
	self._owner_unit_or_nil = owner_unit_or_nil

	local talent_extension = ScriptUnit.has_extension(owner_unit_or_nil, "talent_system")
	local improved_version = talent_extension:has_special_rule(special_rules.adamant_buff_drone_improved)

	self._buff_to_add = improved_version and settings.improved_buff_to_add or settings.buff_to_add
	self._start_time = nil
	self._current_t = nil
	self._life_time = settings.life_time

	local fx_system = Managers.state.extension:system("fx_system")

	self._fx_system = fx_system

	local has_special_rule = settings.special_rule and talent_extension and talent_extension:has_special_rule(settings.special_rule)

	self._special_rule_buff = has_special_rule and settings.buff_to_add_special_rule
	self._component_state = COMPONENT_STATES.none
end

ProximityAreaBuffDrone.destroy = function (self)
	local units_in_proximity = self._units_in_proximity

	for unit, data in pairs(units_in_proximity) do
		self:_remove_buff_from_unit(unit)
	end

	table.clear(self._units_affected_during_lifetime)
	table.clear(self._allies_proximity_enter_time)

	self._units_affected_during_lifetime = nil
	self._allies_proximity_enter_time = nil

	self:_handle_end_of_lifetime_triggers()
end

ProximityAreaBuffDrone.unit_entered_proximity = function (self, t, unit)
	self._units_in_proximity[unit] = {}

	self:_add_buff_to_unit(t, unit)
end

ProximityAreaBuffDrone.unit_left_proximity = function (self, t, unit)
	self:_remove_buff_from_unit(unit)
end

ProximityAreaBuffDrone.unit_in_proximity_deleted = function (self, unit)
	self._units_in_proximity[unit] = nil

	self:_handle_ally_buffing_time_stats(unit)
end

ProximityAreaBuffDrone.update = function (self, dt, t)
	self._current_t = t

	if not self._drone_components or not self._particle_components then
		self._drone_components = Component.get_components_by_name(self._unit, "AreaBuffDrone")
		self._particle_components = Component.get_components_by_name(self._unit, "GyroscopeParticleEffect")
	end

	if self._component_state == COMPONENT_STATES.none then
		for ii = 1, #self._drone_components do
			Component.trigger_event_on_clients(self._drone_components[ii], "area_buff_drone_set_active")
		end

		if not DEDICATED_SERVER then
			Component.event(self._unit, "area_buff_drone_set_active")
		end

		self._component_state = COMPONENT_STATES.active
	end

	if self._started then
		self:_update_buff_keywords_triggered_effects(t)

		if self._component_state == COMPONENT_STATES.deployed then
			local life_time = self._life_time

			if life_time then
				local about_to_expire = t - self._start_time >= self._life_time - STOP_EVENT_TIME_OFFSET

				if about_to_expire then
					for ii = 1, #self._drone_components do
						Component.trigger_event_on_clients(self._drone_components[ii], "area_buff_drone_stop_deployed_loop")
					end

					if not DEDICATED_SERVER then
						Component.event(self._unit, "area_buff_drone_stop_deployed_loop")
					end

					self._component_state = COMPONENT_STATES.deployed_about_to_expire
				end
			end
		end
	end
end

ProximityAreaBuffDrone._handle_end_of_lifetime_triggers = function (self)
	if not self:is_job_completed() then
		return
	end

	local owner_unit = self._owner_unit_or_nil
	local shock_mine_position = POSITION_LOOKUP[self._unit]
	local explosion_template = ExplosionTemplates.shock_mine_self_destruct
	local explosion_position = shock_mine_position + Vector3.multiply(Vector3.up(), 0.05)

	Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), owner_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
end

ProximityAreaBuffDrone.start_job = function (self, is_job)
	if self:is_job_completed() or self:is_job_canceled() then
		return
	end

	local t = Managers.time:time("gameplay")

	self._start_time = t
	self._current_t = t
	self._started = true

	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		Managers.event:trigger("tg_adamant_on_buff_drone_deployed")
	end

	local units_in_proximity = self._units_in_proximity

	for unit, data in pairs(units_in_proximity) do
		self:_add_buff_to_unit(t, unit)
	end

	if is_job then
		if self._particle_components then
			for ii = 1, #self._particle_components do
				Component.trigger_event_on_clients(self._particle_components[ii], "create_particle")
			end
		end

		if self._drone_components then
			for ii = 1, #self._drone_components do
				Component.trigger_event_on_clients(self._drone_components[ii], "area_buff_drone_deploy")
			end
		end

		if not DEDICATED_SERVER then
			Component.event(self._unit, "create_particle")
			Component.event(self._unit, "area_buff_drone_deploy")
		end

		self._component_state = COMPONENT_STATES.deployed
	end
end

ProximityAreaBuffDrone.is_job_completed = function (self)
	if not self._started then
		return false
	end

	local life_time_expired = false
	local life_time = self._life_time

	if life_time then
		local life_span = self._current_t - self._start_time

		life_time_expired = life_span >= self._life_time
	end

	return life_time_expired
end

ProximityAreaBuffDrone.cancel_job = function (self)
	self._is_canceled = true
end

ProximityAreaBuffDrone.is_job_canceled = function (self)
	return not not self._is_canceled
end

ProximityAreaBuffDrone._add_buff_to_unit = function (self, t, unit)
	if not self._started then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension or not HEALTH_ALIVE[unit] then
		return
	end

	local _, index, component_index

	if self._buff_to_add then
		_, index, component_index = buff_extension:add_externally_controlled_buff(self._buff_to_add, t, "owner_unit", self._owner_unit_or_nil)
		self._allies_proximity_enter_time[unit] = FixedFrame.get_latest_fixed_time()

		self:_handle_buffs_applied_to_unit_stats(unit)
	end

	local special_rule_index, special_rule_component_index

	if self._special_rule_buff then
		_, special_rule_index, special_rule_component_index = buff_extension:add_externally_controlled_buff(self._special_rule_buff, t, "owner_unit", self._owner_unit_or_nil)
	end

	self._units_in_proximity[unit] = {
		buff_extension = buff_extension,
		local_index = index,
		component_index = component_index,
		special_rule_index = special_rule_index,
		special_rule_component_index = special_rule_component_index,
	}
end

ProximityAreaBuffDrone._remove_buff_from_unit = function (self, unit)
	if not self._started then
		self._units_in_proximity[unit] = nil

		return
	end

	local units_in_proximity = self._units_in_proximity
	local unit_settings = units_in_proximity[unit]

	if not unit_settings then
		return
	end

	if HEALTH_ALIVE[unit] then
		local index = unit_settings.local_index
		local buff_extension = unit_settings.buff_extension

		if index and buff_extension then
			local component_index = unit_settings.component_index

			buff_extension:remove_externally_controlled_buff(index, component_index)
		end

		local special_rule_index = unit_settings.special_rule_index

		if special_rule_index and buff_extension then
			local special_rule_component_index = unit_settings.special_rule_component_index

			buff_extension:remove_externally_controlled_buff(special_rule_index, special_rule_component_index)
		end
	end

	units_in_proximity[unit] = nil

	self:_handle_ally_buffing_time_stats(unit)
end

ProximityAreaBuffDrone._handle_buffs_applied_to_unit_stats = function (self, buffed_unit)
	local owner_unit = self._owner_unit_or_nil
	local side_system = Managers.state.extension:system("side_system")
	local unit_was_buffed_before = self._units_affected_during_lifetime[buffed_unit]

	if unit_was_buffed_before or not ALIVE[owner_unit] or not owner_unit or not side_system then
		return
	end

	self._units_affected_during_lifetime[buffed_unit] = true

	local is_enemy_unit = side_system:is_enemy(buffed_unit, self._owner_unit_or_nil)
	local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)
	local stat_hook_name = string.format("hook_adamant_%s_affected_by_buff_drone", is_enemy_unit and "enemy" or "ally")

	if owner_player then
		Managers.stats:record_private(stat_hook_name, owner_player)
	end
end

ProximityAreaBuffDrone._handle_ally_buffing_time_stats = function (self, ally_unit)
	local owner_unit = self._owner_unit_or_nil
	local allies_in_proximity_enter_time = self._allies_proximity_enter_time
	local buffing_start_time = allies_in_proximity_enter_time[ally_unit]

	allies_in_proximity_enter_time[ally_unit] = nil

	if not buffing_start_time or not ALIVE[owner_unit] or not owner_unit then
		return
	end

	local current_time = FixedFrame.get_latest_fixed_time()
	local time_buffed = math.round(current_time - buffing_start_time)
	local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)

	if owner_player then
		Managers.stats:record_private("hook_adamant_time_ally_buffed_by_buff_drone", owner_player, time_buffed)
	end
end

local function _trigger_hordes_aoe_shock(owner_unit, drone_position, shock_range, t)
	local broadphase, enemy_side_names = SharedBuffFunctions.get_broadphase_and_enemy_side_names(owner_unit)
	local num_hits = broadphase.query(broadphase, drone_position, shock_range, BROADPHASE_RESULTS, enemy_side_names)

	for i = 1, num_hits do
		local enemy_unit = BROADPHASE_RESULTS[i]
		local buff_extension = ScriptUnit.has_extension(enemy_unit, "buff_system")

		if buff_extension then
			buff_extension:add_internally_controlled_buff("hordes_ailment_shock", t, "owner_unit", owner_unit)
		end
	end

	local fx_system = Managers.state.extension:system("fx_system")

	fx_system:trigger_wwise_event("wwise/events/player/play_horde_mode_buff_electric_shock", drone_position)
	fx_system:trigger_vfx("content/fx/particles/player_buffs/buff_electricity_grenade_01", drone_position)
end

local hordes_aoe_shock_interaval = HordesBuffsData.hordes_buff_adamant_drone_stun.buff_stats.time.value
local hordes_aoe_shock_range = adamant_talent_settings.blitz_ability.drone.range * 0.6

ProximityAreaBuffDrone._update_buff_keywords_triggered_effects = function (self, t)
	local owner_unit = self._owner_unit_or_nil
	local owner_unit_buff_extension = owner_unit and ScriptUnit.has_extension(owner_unit, "buff_system")
	local owner_has_aoe_shock_keyword = owner_unit_buff_extension and owner_unit_buff_extension:has_keyword(buff_keywords.adamant_drone_shocks_enemies_in_range)

	if owner_has_aoe_shock_keyword then
		local drone_position = POSITION_LOOKUP[self._unit]
		local trigger_aoe_shock = not self._next_aoe_shock_t or t >= self._next_aoe_shock_t

		if trigger_aoe_shock then
			_trigger_hordes_aoe_shock(owner_unit, drone_position, hordes_aoe_shock_range, t)

			self._next_aoe_shock_t = t + hordes_aoe_shock_interaval
		end
	end
end

implements(ProximityAreaBuffDrone, JobInterface)

return ProximityAreaBuffDrone
