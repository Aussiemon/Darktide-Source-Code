-- chunkname: @scripts/extension_systems/ability/actions/action_psyker_shout.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local Attack = require("scripts/utilities/attack/attack")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local Vo = require("scripts/utilities/vo")
local WarpCharge = require("scripts/utilities/warp_charge")
local talent_settings = TalentSettings.psyker_2
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local CLOSE_RANGE = 9
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local stagger_types = StaggerSettings.stagger_types
local ActionPsykerShout = class("ActionPsykerShout", "ActionAbilityBase")
local broadphase_results = {}
local external_properties = {}

ActionPsykerShout.init = function (self, action_context, action_params, action_settings)
	ActionPsykerShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._unit_data_extension = unit_data_extension
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
	self._talent_resource_component = unit_data_extension:read_component("talent_resource")
	self._action_settings = action_settings
	self._total_hits = {}
	self._shout_distance_traveled = 0
	self._speed = action_settings.shout_range / action_settings.total_time * 2
	self._attack_direction = Vector3Box(Vector3.zero())
end

ActionPsykerShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionPsykerShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local warp_charge_component = self._unit_data_extension:write_component("warp_charge")
	local warp_charge_percent = warp_charge_component.current_percentage
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local rotation = self._first_person_component.rotation
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))

	self._shout_direction = forward
	self._attack_direction = Vector3Box(forward)
	self._shout_distance_traveled = 0
	self._speed = action_settings.shout_range / action_settings.total_time * 2
	self._shout_range = action_settings.shout_range
	self._combat_ability_component.active = true
	self._warp_charge_component = warp_charge_component
	self._warp_charge_percent = warp_charge_percent
	self._num_hits = 0

	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.on_state)
	end

	local vo_tag = action_settings.vo_tag

	if vo_tag then
		if warp_charge_percent >= 0.75 then
			Vo.play_combat_ability_event(player_unit, vo_tag.high)
		else
			Vo.play_combat_ability_event(player_unit, vo_tag.low)
		end
	end

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	external_properties.ability_template = self._ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	local vfx = action_settings.vfx

	if vfx then
		local vfx_pos = player_position + Vector3.up()

		self._fx_extension:spawn_particles(vfx, vfx_pos, rotation)
	end

	if not self._is_server then
		return
	end

	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")
	local damage_reduction_debuff = talent_extension:has_special_rule(special_rules.psyker_discharge_damage_debuff)

	self._damage_reduction_debuff = damage_reduction_debuff and "psyker_discharge_damage_debuff"

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local target_enemies = action_settings.target_enemies

	if target_enemies then
		self:_handle_enemies(action_settings, side, t, talent_extension)
	end

	local target_allies = action_settings.target_allies

	if target_allies then
		self:_handle_allies(action_settings, side, t, talent_extension)
	end

	local buff_extension = ScriptUnit.extension(player_unit, "buff_system")

	self._buff_extension = buff_extension

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit
		param_table.warp_charge_percent = warp_charge_percent

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	local shout_warp_charge_vent_improved = talent_extension:has_special_rule(special_rules.shout_warp_charge_vent_improved)
	local drain_amount = shout_warp_charge_vent_improved and talent_settings.combat_ability.warpcharge_vent_improved or talent_settings.combat_ability.warpcharge_vent_base

	WarpCharge.decrease_immediate(drain_amount, warp_charge_component, player_unit)
end

ActionPsykerShout.fixed_update = function (self, dt, t, time_in_action)
	local buff_extension = self._buff_extension
	local shout_distance_traveled = self._shout_distance_traveled
	local total_hits = self._total_hits
	local damage_profile = self._damage_profile
	local player_unit = self._player_unit
	local power_level = self._power_level
	local damage_type = self._damage_type
	local attack_type = self._attack_type
	local attack_direction = self._attack_direction:unbox()
	local shout_range = self._shout_range
	local distance_traveled_squared = shout_distance_traveled * shout_distance_traveled

	for unit, distance in pairs(total_hits) do
		if not HEALTH_ALIVE[unit] then
			total_hits[unit] = nil
		elseif distance <= distance_traveled_squared then
			local hit_zone_name = "torso"
			local actual_distance = math.sqrt(distance)
			local min_range = 0.15 * shout_range
			local scale_factor = 1 - (math.max(actual_distance, min_range) - min_range) / (shout_range - min_range)
			local scaled_power_level = power_level * (0.25 + 0.75 * (scale_factor * scale_factor))

			Attack.execute(unit, damage_profile, "attack_direction", attack_direction, "power_level", scaled_power_level, "hit_zone_name", hit_zone_name, "damage_type", damage_type, "attack_type", attack_type, "attacking_unit", player_unit)

			local has_force_strong_stagger_keyword = buff_extension and buff_extension:has_keyword(buff_keywords.shout_forces_strong_stagger)

			if has_force_strong_stagger_keyword then
				Stagger.force_stagger(unit, stagger_types.explosion, attack_direction, 4, 1, 4, player_unit)
			end

			if self._damage_reduction_debuff then
				local enemy_buff_extension = ScriptUnit.has_extension(unit, "buff_system")

				if enemy_buff_extension then
					enemy_buff_extension:add_internally_controlled_buff(self._damage_reduction_debuff, t)
				end
			end

			total_hits[unit] = nil
		end
	end

	self._shout_distance_traveled = shout_distance_traveled + self._speed * dt
end

ActionPsykerShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionPsykerShout.super.finish(self, reason, data, t, time_in_action)

	local wwise_state = action_settings.wwise_state

	if wwise_state then
		Wwise.set_state(wwise_state.group, wwise_state.off_state)
	end

	local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.num_hits = self._num_hits

		buff_extension:add_proc_event(proc_events.on_psyker_shout_finish, param_table)
	end

	self._combat_ability_component.active = false

	table.clear(self._total_hits)
end

local STARTING_RANGE = 2.5
local RANGE_STEP_MULTIPLIER = 2

ActionPsykerShout._handle_enemies = function (self, action_settings, side, t, talent_extension)
	local enemy_side_names = side:relation_side_names("enemy")
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local damage_type = action_settings.damage_type
	local attack_type = action_settings.attack_type
	local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL

	power_level = power_level * (1 + self._warp_charge_percent)

	local damage_per_warp_charge = talent_extension:has_special_rule(special_rules.psyker_discharge_damage_per_warp_charge)
	local damage_profile = damage_per_warp_charge and action_settings.damaging_damage_profile or action_settings.damage_profile

	self._damage_profile = damage_profile
	self._player_position = player_position
	self._power_level = power_level
	self._damage_type = damage_type
	self._attack_type = attack_type

	local shout_shape = action_settings.shout_shape

	if shout_shape and shout_shape == "cone" then
		local shout_dot = action_settings.shout_dot
		local shout_range = action_settings.shout_range
		local shout_direction = self._shout_direction
		local total_hits = self._total_hits
		local total_range = shout_range
		local previous_range = 0
		local total_num_hits = 0

		while total_range > 0 do
			local range = previous_range > 0 and previous_range * RANGE_STEP_MULTIPLIER or STARTING_RANGE
			local slice_radius = range - previous_range

			total_range = total_range - range
			previous_range = range

			local position = player_position + shout_direction * range

			table.clear(broadphase_results)

			local num_hits = broadphase.query(broadphase, position, slice_radius, broadphase_results, enemy_side_names)

			total_num_hits = total_num_hits + num_hits

			for ii = 1, num_hits do
				local enemy_unit = broadphase_results[ii]
				local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
				local distance_squared = Vector3.distance_squared(enemy_unit_position, player_position)
				local attack_direction = Vector3.normalize(Vector3.flat(enemy_unit_position - player_position))

				if Vector3.length_squared(attack_direction) == 0 then
					local player_rotation = locomotion_component.rotation

					attack_direction = Quaternion.forward(player_rotation)
				end

				local dot = Vector3.dot(shout_direction, attack_direction)

				if (shout_dot < dot or distance_squared < CLOSE_RANGE) and not total_hits[enemy_unit] then
					self._num_hits = self._num_hits + 1
					total_hits[enemy_unit] = distance_squared
				end
			end
		end
	end
end

local function _ally_hit_by_shout(origin_player_unit, ally_unit)
	local buff_extension = ScriptUnit.extension(origin_player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.ally_unit = ally_unit

		buff_extension:add_proc_event(proc_events.on_psyker_shout_hit_ally, param_table)
	end
end

ActionPsykerShout._handle_allies = function (self, action_settings, side, t, talent_extension)
	local ally_side_name = side:name()
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_unit = self._player_unit
	local player_position = locomotion_position
	local player_rotation = locomotion_component.rotation
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local shout_shape = action_settings.shout_shape

	if shout_shape and shout_shape == "cone" then
		local shout_dot = action_settings.shout_dot
		local shout_range = action_settings.shout_range
		local shout_direction = self._shout_direction
		local allies_hit = {}
		local total_range = shout_range
		local previous_range = 0
		local total_num_hits = 0

		while total_range > 0 do
			local range = previous_range > 0 and previous_range * RANGE_STEP_MULTIPLIER or STARTING_RANGE
			local slice_radius = range - previous_range

			total_range = total_range - range
			previous_range = range

			local position = player_position + shout_direction * range

			table.clear(broadphase_results)

			local num_hits = broadphase.query(broadphase, position, slice_radius, broadphase_results, ally_side_name)

			total_num_hits = total_num_hits + num_hits

			for ii = 1, num_hits do
				local ally_unit = broadphase_results[ii]

				if ally_unit ~= player_unit then
					local ally_unit_position = POSITION_LOOKUP[ally_unit]
					local distance_squared = Vector3.distance_squared(ally_unit_position, player_position)
					local attack_direction = Vector3.normalize(Vector3.flat(ally_unit_position - player_position))

					if Vector3.length_squared(attack_direction) == 0 then
						attack_direction = Quaternion.forward(player_rotation)
					end

					local dot = Vector3.dot(shout_direction, attack_direction)

					if (shout_dot < dot or distance_squared < CLOSE_RANGE) and not allies_hit[ally_unit] then
						_ally_hit_by_shout(player_unit, ally_unit)

						allies_hit[ally_unit] = true
					end
				end
			end
		end
	end
end

return ActionPsykerShout
