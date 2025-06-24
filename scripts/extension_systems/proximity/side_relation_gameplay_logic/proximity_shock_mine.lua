-- chunkname: @scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_shock_mine.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Component = require("scripts/utilities/component")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local JobInterface = require("scripts/managers/unit_job/job_interface")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local talent_settings = TalentSettings.adamant
local ProximityShockMine = class("ProximityShockMine")
local COMPONENT_STATES = table.enum("none", "arming", "deployed")

ProximityShockMine.init = function (self, logic_context, init_data, owner_unit_or_nil)
	self._world = logic_context.world
	self._physics_world = logic_context.physics_world
	self._unit = logic_context.unit

	local side_name = logic_context.side_name
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name(side_name)
	local enemy_side_names = side:relation_side_names("enemy")

	self._side_name = side_name
	self._enemy_side_names = enemy_side_names
	self._units_in_proximity = {}

	local settings = init_data

	self._settings = settings
	self._owner_unit_or_nil = owner_unit_or_nil
	self._start_time = nil
	self._current_t = nil
	self._arming_time = settings.arming_time
	self._trigger_interval = settings.trigger_interval
	self._buff_trigger_t = 0
	self._life_time = settings.life_time + settings.arming_time
	self._buff_to_add = settings.buff_to_add
	self._num_targets_per_trigger = settings.num_targets_per_trigger

	local fx_system = Managers.state.extension:system("fx_system")
	local broadphase_system = Managers.state.extension:system("broadphase_system")

	self._fx_system = fx_system
	self._broadphase = broadphase_system.broadphase
	self._component_state = COMPONENT_STATES.none
end

ProximityShockMine.destroy = function (self)
	self:_handle_end_of_lifetime_triggers()
end

ProximityShockMine.unit_entered_proximity = function (self, t, unit)
	local health_extension = ScriptUnit.has_extension(unit, "health_system")

	if not health_extension or not HEALTH_ALIVE[unit] then
		return
	end

	self._units_in_proximity[unit] = health_extension
end

ProximityShockMine.unit_left_proximity = function (self, unit)
	self._units_in_proximity[unit] = nil
end

ProximityShockMine.unit_in_proximity_deleted = function (self, unit)
	self._units_in_proximity[unit] = nil
end

ProximityShockMine.update = function (self, dt, t)
	self._current_t = t

	if not self._started then
		return
	end

	if t < self._start_time + self._arming_time then
		return
	end

	if self._component_state == COMPONENT_STATES.arming then
		local components = self._components

		for ii = 1, #components do
			Component.trigger_event_on_clients(components[ii], "shock_mine_deploy")
		end

		self._components = components

		if not DEDICATED_SERVER then
			Component.event(self._unit, "shock_mine_deploy")
		end

		self._component_state = COMPONENT_STATES.deployed
	end

	self:_apply_buffs(t)
end

local HARD_CODED_RADIUS = talent_settings.blitz_ability.shock_mine.range
local _broadphase_results = {}

ProximityShockMine._apply_buffs = function (self, t)
	if t < self._buff_trigger_t then
		return
	end

	table.clear(_broadphase_results)

	local broadphase = self._broadphase
	local num_results = broadphase.query(broadphase, POSITION_LOOKUP[self._unit], HARD_CODED_RADIUS, _broadphase_results, self._enemy_side_names)

	table.shuffle(_broadphase_results)

	local num_added_buffs = 0
	local result_index = 0
	local buff_to_add = self._buff_to_add
	local started = false
	local stop = false

	while not stop do
		result_index = result_index + 1

		local target_unit = _broadphase_results[result_index]

		if HEALTH_ALIVE[target_unit] then
			local buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

			started = true

			if buff_extension then
				local target_is_electrocuted = buff_extension:has_keyword(buff_keywords.electrocuted)

				if not target_is_electrocuted then
					buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", self._owner_unit_or_nil)

					num_added_buffs = num_added_buffs + 1
				end
			end
		end

		stop = num_added_buffs > self._num_targets_per_trigger or num_results < result_index
	end

	if started and not self._started_dealing_damage then
		self._started_dealing_damage = true
		self._start_time = t
		self._life_time = talent_settings.blitz_ability.shock_mine.duration
	end

	self._buff_trigger_t = t + self._trigger_interval
end

ProximityShockMine._handle_end_of_lifetime_triggers = function (self)
	if not self:is_job_completed() then
		return
	end

	local owner_unit = self._owner_unit_or_nil
	local shock_mine_position = POSITION_LOOKUP[self._unit]
	local owner_unit_buff_extension = owner_unit and ScriptUnit.has_extension(owner_unit, "buff_system")
	local has_bigger_explosion_buff = owner_unit_buff_extension and owner_unit_buff_extension:has_keyword(buff_keywords.adamant_mine_explode_on_finish)
	local explosion_template = has_bigger_explosion_buff and ExplosionTemplates.frag_grenade or ExplosionTemplates.shock_mine_self_destruct
	local explosion_position = shock_mine_position + Vector3.multiply(Vector3.up(), 0.05)

	Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), owner_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
end

ProximityShockMine.start_job = function (self)
	if self:is_job_completed() or self:is_job_canceled() then
		return
	end

	local t = Managers.time:time("gameplay")

	self._start_time = t
	self._current_t = t
	self._buff_trigger_t = t + self._arming_time
	self._started = true

	local components = Component.get_components_by_name(self._unit, "ShockMine")

	for ii = 1, #components do
		Component.trigger_event_on_clients(components[ii], "shock_mine_start_arming")
	end

	self._components = components
	self._component_state = COMPONENT_STATES.arming

	if not DEDICATED_SERVER then
		Component.event(self._unit, "shock_mine_start_arming")
	end
end

ProximityShockMine.is_job_completed = function (self)
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

ProximityShockMine.cancel_job = function (self)
	self._is_canceled = true
end

ProximityShockMine.is_job_canceled = function (self)
	return not not self._is_canceled
end

implements(ProximityShockMine, JobInterface)

return ProximityShockMine
