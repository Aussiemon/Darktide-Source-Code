-- chunkname: @scripts/extension_systems/ability/actions/action_adamant_shout.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Vo = require("scripts/utilities/vo")
local attack_types = AttackSettings.attack_types
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local stagger_types = StaggerSettings.stagger_types
local ActionAdamantShout = class("ActionAdamantShout", "ActionAbilityBase")
local STARTING_RANGE = 2.5
local RANGE_STEP_MULTIPLIER = 2
local broadphase_results = {}
local external_properties = {}

ActionAdamantShout.init = function (self, action_context, action_params, action_settings)
	ActionAdamantShout.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._combat_ability_component = unit_data_extension:write_component("combat_ability")
end

ActionAdamantShout.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionAdamantShout.super.start(self, action_settings, t, time_scale, action_start_params)

	local buff_extension = self._buff_extension
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local player_position = locomotion_position
	local player_unit = self._player_unit
	local vo_tag = action_settings.vo_tag

	Vo.play_combat_ability_event(player_unit, vo_tag)

	local source_name = action_settings.sound_source or "head"
	local sync_to_clients = action_settings.has_husk_sound
	local include_client = false

	table.clear(external_properties)

	local ability = self._ability

	external_properties.ability_template = ability and ability.ability_template

	self._fx_extension:trigger_gear_wwise_event_with_source("ability_shout", external_properties, source_name, sync_to_clients, include_client)

	local anim = action_settings.anim
	local anim_3p = action_settings.anim_3p or anim

	if anim then
		self:trigger_anim_event(anim, anim_3p)
	end

	local vfx = action_settings.vfx

	if vfx then
		local vfx_pos = player_position + Vector3.up()

		self._fx_extension:spawn_particles(vfx, vfx_pos)
	end

	if not self._is_server then
		return
	end

	local rotation = self._first_person_component.rotation
	local shout_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
	local radius = action_settings.radius
	local shout_target_template_name = self._ability_template_tweak_data.shout_target_template or action_settings.shout_target_template

	ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, locomotion_component, shout_direction)

	local companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
	local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

	if companion_unit then
		local dog_position = Unit.local_position(companion_unit, 1)
		local dog_rotation = Unit.local_rotation(companion_unit, 1)
		local dog_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(dog_rotation)))

		ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, nil, dog_forward, dog_position, dog_rotation)
	end

	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[player_unit]
	local enemy_side_names = side:relation_side_names("enemy")
	local total_hits = {}
	local shout_dot = action_settings.shout_dot
	local total_range = self._ability_template_tweak_data.forward_range
	local damage_profile = action_settings.damage_profile
	local previous_range = 0
	local total_num_hits = 0
	local power_level = action_settings.power_level

	while total_range > 0 do
		local range = previous_range > 0 and previous_range * RANGE_STEP_MULTIPLIER or STARTING_RANGE
		local slice_radius = range - previous_range

		total_range = total_range - range
		previous_range = range

		local position = player_position + shout_direction * range

		table.clear(broadphase_results)

		local num_hits = broadphase.query(broadphase, position, slice_radius, broadphase_results, enemy_side_names)

		total_num_hits = total_num_hits + num_hits

		local target_number = 1

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

			if shout_dot < dot and not total_hits[enemy_unit] then
				local hit_zone_name = "torso"
				local actual_distance = math.sqrt(distance_squared)
				local min_range = 0.5 * total_range
				local scale_factor = 1 - (math.max(actual_distance, min_range) - min_range) / (total_range - min_range)
				local scaled_power_level = power_level * (0.25 + 0.75 * (scale_factor * scale_factor))

				Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", scaled_power_level, "hit_zone_name", hit_zone_name, "damage_type", nil, "attack_type", attack_types.shout, "attacking_unit", player_unit, "target_number", target_number)

				target_number = target_number + 1
				total_hits[enemy_unit] = true

				local has_force_strong_stagger_keyword = buff_extension and buff_extension:has_keyword(buff_keywords.shout_forces_strong_stagger)

				if has_force_strong_stagger_keyword then
					Stagger.force_stagger(enemy_unit, stagger_types.explosion, attack_direction, 4, 1, 4, player_unit)
				end
			end
		end
	end

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = player_unit

		buff_extension:add_proc_event(proc_events.on_combat_ability, param_table)
	end

	self._combat_ability_component.active = true
end

ActionAdamantShout.finish = function (self, reason, data, t, time_in_action, action_settings)
	self._combat_ability_component.active = false
end

return ActionAdamantShout
