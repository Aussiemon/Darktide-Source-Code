-- chunkname: @scripts/extension_systems/proximity/side_relation_gameplay_logic/proximity_broker_stimm_field.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local FixedFrame = require("scripts/utilities/fixed_frame")
local HordesBuffsData = require("scripts/settings/buff/hordes_buffs/hordes_buffs_data")
local JobInterface = require("scripts/managers/unit_job/job_interface")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SharedBuffFunctions = require("scripts/settings/buff/helper_functions/shared_buff_functions")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local attack_types = AttackSettings.attack_types
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local ProximityBrokerStimmField = class("ProximityBrokerStimmField")
local ability_settings = TalentSettings.broker.combat_ability.stimm_field
local stimm_talent_settings = TalentSettings.broker_stimm
local buff_keywords = BuffSettings.keywords
local BROADPHASE_RESULTS = {}

ProximityBrokerStimmField.init = function (self, logic_context, init_data, owner_unit_or_nil)
	local unit = logic_context.unit

	self._world = logic_context.world
	self._physics_world = logic_context.physics_world
	self._unit = unit
	self._side_name = logic_context.side_name
	self._units_in_proximity = {}
	self._units_affected_during_lifetime = {}
	self._lingering_units = {}

	local settings = init_data

	self._settings = settings
	self._life_time = settings.life_time

	local ability_extension = ScriptUnit.has_extension(owner_unit_or_nil, "ability_system")

	self._ability_extension = ability_extension

	local owner_talent_extension = ScriptUnit.has_extension(owner_unit_or_nil, "talent_system")

	if owner_talent_extension then
		if owner_talent_extension:has_special_rule("broker_stimm_field_linger") then
			self._linger_time = ability_settings.sub_1_linger_time
			self._life_time = ability_settings.sub_1_life_time
		end

		self._explode_on_death = owner_talent_extension:has_special_rule("broker_stimm_field_explode")
	end

	self._owner_unit_or_nil = owner_unit_or_nil
	self._buffs_to_add = {
		settings.buff_to_add,
	}
	self._skip_talents = false
	self._start_time = nil
	self._current_t = nil
	self._previously_proximate_units = {}
	self._single_application_buffs = {}

	local slot = "slot_pocketable_small"
	local visual_loadout_extension = ScriptUnit.has_extension(owner_unit_or_nil, "visual_loadout_system")
	local weapon_template = visual_loadout_extension:weapon_template_from_slot(slot)
	local keywords = weapon_template and weapon_template.keywords
	local has_syringe = keywords and table.contains(keywords, "syringe")
	local has_broker_syringe = ability_extension and ability_extension:has_ability_type("pocketable_ability")

	if has_syringe and not has_broker_syringe then
		local buff_name = weapon_template.actions.action_use_self.buff_name .. "_stimm_field"

		if BuffTemplates[buff_name].single_application then
			self._single_application_buffs.no_talent = buff_name
		else
			self._buffs_to_add[#self._buffs_to_add + 1] = buff_name
		end

		local consume = ability_settings.consume_pickup_syringe

		if consume then
			local t = Managers.time:time("gameplay")

			PlayerUnitVisualLoadout.unequip_item_from_slot(owner_unit_or_nil, slot, t)
		end
	elseif has_broker_syringe then
		local consume = ability_settings.consume_broker_syringe
		local can_use_ability = true

		if consume then
			local ability = "pocketable_ability"

			can_use_ability = ability_extension and ability_extension:remaining_ability_charges(ability) >= 1

			if can_use_ability then
				ability_extension:use_ability_charge("pocketable_ability")
			else
				self._skip_talents = true
			end
		end

		if can_use_ability then
			local single_application_buff_overrides = BuffTemplates[settings.buff_to_add].single_application_buff_overrides

			for talent_name in pairs(single_application_buff_overrides) do
				if owner_talent_extension:buff_template_tier(talent_name) then
					local buff_name = stimm_talent_settings[talent_name].buff_data.buff_target

					self._single_application_buffs[talent_name] = buff_name
				end
			end
		end
	end

	self._has_syringe = has_syringe or has_broker_syringe
end

ProximityBrokerStimmField.destroy = function (self)
	local units_in_proximity = self._units_in_proximity
	local t = FixedFrame.get_latest_fixed_time()
	local linger_time = self._linger_time

	for unit, data in pairs(units_in_proximity) do
		if linger_time then
			self:_make_linger(unit, t, linger_time)
		else
			self:_remove_buff_from_unit(t, unit)
		end
	end

	table.clear(self._units_affected_during_lifetime)

	self._units_affected_during_lifetime = nil

	self:_handle_end_of_lifetime_triggers()
end

ProximityBrokerStimmField.unit_entered_proximity = function (self, t, unit)
	self._units_in_proximity[unit] = {
		buff_datas = {},
		buff_extension = ScriptUnit.has_extension(unit, "buff_system"),
		enter_time = t,
	}

	self:_add_buff_to_unit(t, unit)
end

ProximityBrokerStimmField.unit_left_proximity = function (self, t, unit)
	self:_remove_buff_from_unit(t, unit)
end

ProximityBrokerStimmField.unit_in_proximity_deleted = function (self, unit)
	self._units_in_proximity[unit] = nil
end

ProximityBrokerStimmField.update = function (self, dt, t)
	self._current_t = t

	if self._started then
		self:_update_buff_keywords_triggered_effects(t)
	end
end

ProximityBrokerStimmField._handle_end_of_lifetime_triggers = function (self)
	if not self:is_job_completed() then
		return
	end

	if not self._explode_on_death then
		return
	end

	local owner_unit = self._owner_unit_or_nil
	local shock_mine_position = POSITION_LOOKUP[self._unit]
	local explosion_position = shock_mine_position + Vector3.multiply(Vector3.up(), 0.05)
	local explosion_template = ExplosionTemplates.broker_stimm_field

	Explosion.create_explosion(self._world, self._physics_world, explosion_position, Vector3.up(), owner_unit, explosion_template, DEFAULT_POWER_LEVEL, 1, attack_types.explosion)
end

ProximityBrokerStimmField.start_job = function (self, is_job)
	if self:is_job_completed() or self:is_job_canceled() then
		return
	end

	local t = Managers.time:time("gameplay")

	self._start_time = t
	self._current_t = t
	self._started = true

	local owner_unit = self._owner_unit_or_nil
	local owner_player = owner_unit and Managers.state.player_unit_spawn:owner(owner_unit)

	if owner_player then
		Managers.stats:record_private("hook_broker_deployed_stimm_field", owner_player)
	end

	local units_in_proximity = self._units_in_proximity

	for unit, data in pairs(units_in_proximity) do
		self:_add_buff_to_unit(t, unit)
	end
end

ProximityBrokerStimmField.is_job_completed = function (self)
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

ProximityBrokerStimmField.cancel_job = function (self)
	self._is_canceled = true
end

ProximityBrokerStimmField.is_job_canceled = function (self)
	return not not self._is_canceled
end

ProximityBrokerStimmField._add_buff_to_unit = function (self, t, unit)
	if not self._started then
		return
	end

	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not buff_extension or not HEALTH_ALIVE[unit] then
		return
	end

	local linger_data = self._lingering_units[unit]

	if linger_data then
		local buff_datas = linger_data.buff_datas

		for i = 1, #buff_datas do
			local template_name = buff_datas[i].template_name
			local previous_local_id = buff_datas[i].local_id
			local reappliable_buff = buff_datas[i].reappliable_buff

			if previous_local_id and reappliable_buff then
				local _, new_local_id = buff_extension:reapply_externally_controlled_lingering_buff(previous_local_id, nil, template_name, t, "owner_unit", self._owner_unit_or_nil)

				buff_datas[i].local_id = new_local_id
				buff_datas[i].lingering = false
			end
		end

		self._units_in_proximity[unit] = linger_data
		self._lingering_units[unit] = nil
		linger_data.enter_time = t

		return
	end

	local proximity_data = self._units_in_proximity[unit]

	proximity_data.buff_extension = buff_extension
	proximity_data.enter_time = t

	local buff_datas = proximity_data.buff_datas

	table.clear(buff_datas)

	for i = 1, #self._buffs_to_add do
		local _, local_id = buff_extension:add_externally_controlled_buff(self._buffs_to_add[i], t, "owner_unit", self._owner_unit_or_nil, "skip_talent", self._skip_talents)

		buff_datas[i] = {
			reappliable_buff = true,
			local_id = local_id,
			template_name = self._buffs_to_add[i],
		}
	end

	if not self._previously_proximate_units[unit] then
		self._previously_proximate_units[unit] = true

		for talent_name, buff_name in pairs(self._single_application_buffs) do
			local _, local_id

			if talent_name == "no_talent" then
				_, local_id = buff_extension:add_externally_controlled_buff(buff_name, t, "owner_unit", self._owner_unit_or_nil, "skip_talent", self._skip_talents)
			else
				_, local_id = buff_extension:add_externally_controlled_buff(buff_name, t, "owner_unit", self._owner_unit_or_nil, "from_talent", talent_name, "skip_talent", self._skip_talents)
			end

			buff_datas[#buff_datas + 1] = {
				reappliable_buff = false,
				local_id = local_id,
			}
		end

		if self._has_syringe then
			local owner_buff_extension = ScriptUnit.extension(unit, "buff_system")
			local param_table = owner_buff_extension:request_proc_event_param_table()

			if param_table then
				owner_buff_extension:add_proc_event(BuffSettings.proc_events.on_syringe_used, param_table)
			end
		end
	end
end

ProximityBrokerStimmField._remove_buff_from_unit = function (self, t, unit)
	if not self._started then
		self._units_in_proximity[unit] = nil

		return
	end

	local units_in_proximity = self._units_in_proximity
	local unit_settings = units_in_proximity[unit]

	if not unit_settings then
		return
	end

	if self._linger_time then
		self:_make_linger(unit, t, self._linger_time)
	else
		if HEALTH_ALIVE[unit] then
			local buff_datas = unit_settings.buff_datas
			local buff_extension = unit_settings.buff_extension

			if buff_datas and buff_extension then
				for i = 1, #buff_datas do
					local local_id = buff_datas[i].local_id

					if local_id then
						buff_extension:remove_externally_controlled_buff(local_id)
					end

					buff_datas[i] = nil
				end
			end
		end

		units_in_proximity[unit] = nil
	end
end

ProximityBrokerStimmField._make_linger = function (self, unit, t, linger_time)
	local buff_data = self._units_in_proximity[unit]

	self._units_in_proximity[unit] = nil
	self._lingering_units[unit] = buff_data

	local buff_extension = buff_data.buff_extension
	local buff_datas = buff_data.buff_datas

	for i = 1, #buff_datas do
		if not buff_datas[i].lingering then
			local local_id = buff_datas[i].local_id

			buff_extension:remove_externally_controlled_buff_with_linger(local_id, nil, t, linger_time)

			buff_datas[i].lingering = true
		end
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

local hordes_aoe_shock_interaval = HordesBuffsData.hordes_buff_broker_stimm_field_shock_on_interval.buff_stats.time.value
local hordes_aoe_shock_range = ability_settings.proximity_radius * 0.6

ProximityBrokerStimmField._update_buff_keywords_triggered_effects = function (self, t)
	local owner_unit = self._owner_unit_or_nil
	local owner_unit_buff_extension = owner_unit and ScriptUnit.has_extension(owner_unit, "buff_system")
	local owner_has_aoe_shock_keyword = owner_unit_buff_extension and owner_unit_buff_extension:has_keyword(buff_keywords.broker_stimm_field_shocks_enemies_in_range)

	if owner_has_aoe_shock_keyword then
		local drone_position = POSITION_LOOKUP[self._unit]
		local trigger_aoe_shock = not self._next_aoe_shock_t or t >= self._next_aoe_shock_t

		if trigger_aoe_shock then
			_trigger_hordes_aoe_shock(owner_unit, drone_position, hordes_aoe_shock_range, t)

			self._next_aoe_shock_t = t + hordes_aoe_shock_interaval
		end
	end
end

implements(ProximityBrokerStimmField, JobInterface)

return ProximityBrokerStimmField
