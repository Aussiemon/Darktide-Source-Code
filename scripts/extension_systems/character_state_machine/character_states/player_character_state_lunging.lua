-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_lunging.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local ActionAvailability = require("scripts/extension_systems/weapon/utilities/action_availability")
local ActionUtility = require("scripts/extension_systems/weapon/actions/utilities/action_utility")
local Armor = require("scripts/utilities/attack/armor")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local Explosion = require("scripts/utilities/attack/explosion")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local HitMass = require("scripts/utilities/attack/hit_mass")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local Lunge = require("scripts/utilities/player_state/lunge")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local MinionPushFx = require("scripts/utilities/minion_push_fx")
local MinionPushFxTemplates = require("scripts/settings/fx/minion_push_fx_templates")
local MinionState = require("scripts/utilities/minion_state")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stagger = require("scripts/utilities/attack/stagger")
local Toughness = require("scripts/utilities/toughness/toughness")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_types = AttackSettings.attack_types
local proc_events = BuffSettings.proc_events
local DAMAGE_COLLISION_FILTER = "filter_player_character_lunge"
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local LUNGE_ATTACK_POWER_LEVEL = 1000
local HIT_WEAKSPOT = false
local IS_CRITICAL_STRIKE = false
local _max_hit_mass, _record_stat_on_lunge_hit, _record_stat_on_lunge_complete, _apply_buff_to_hit_unit
local broadphase_results = {}
local PlayerCharacterStateLunging = class("PlayerCharacterStateLunging", "PlayerCharacterStateBase")

PlayerCharacterStateLunging.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLunging.super.init(self, character_state_init_context, ...)

	local lunge_character_state_component = character_state_init_context.unit_data:write_component("lunge_character_state")

	lunge_character_state_component.is_lunging = false
	lunge_character_state_component.is_aiming = false
	lunge_character_state_component.distance_left = 0
	lunge_character_state_component.direction = Vector3.zero()
	lunge_character_state_component.lunge_template = "none"
	lunge_character_state_component.lunge_target = nil
	self._lunge_character_state_component = lunge_character_state_component

	local character_state_hit_mass_component = character_state_init_context.unit_data:write_component("character_state_hit_mass")

	character_state_hit_mass_component.used_hit_mass_percentage = 0
	self._character_state_hit_mass_component = character_state_hit_mass_component
	self._locomotion_push_component = character_state_init_context.unit_data:write_component("locomotion_push")
	self._push_sfx_cooldown = 0
	self._hit_enemy_units = {}
	self._last_hit_unit = nil
	self._moving_backwards = nil
	self._has_pushback = nil
	self._played_timing_anims = {}
end

PlayerCharacterStateLunging._play_animation = function (self, animation_extension, anim_event)
	animation_extension:anim_event(anim_event)
	animation_extension:anim_event_1p(anim_event)
end

local stop_action_data = {}

PlayerCharacterStateLunging.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateLunging.super.on_enter(self, unit, dt, t, previous_state, params)

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	self._locomotion_push_component.new_velocity = Vector3.zero()
	self._push_sfx_cooldown = 0
	self._moving_backwards = self._input_extension:get("move").y < -0.1
	self._has_pushback = false

	local lunge_template_name = params.lunge_template_name
	local lunge_template = LungeTemplates[lunge_template_name]

	if lunge_template.disable_minion_collision then
		locomotion_steering.disable_minion_collision = true
	end

	table.clear(stop_action_data)

	local action_settings = self._weapon_extension:running_action_settings()

	if action_settings and not ActionAvailability.available_in_lunge(action_settings) or lunge_template.disable_weapon_actions then
		Interrupt.ability_and_action(t, unit, "lunging", nil)
	end

	Luggable.drop_luggable(t, unit, self._inventory_component, self._visual_loadout_extension, true)

	local lunge_character_state_component = self._lunge_character_state_component
	local lunge_target = lunge_character_state_component.lunge_target
	local has_target = lunge_target ~= nil
	local distance = Lunge.distance(lunge_template, has_target, self._buff_extension)

	if has_target then
		local lunge_target_position = POSITION_LOOKUP[lunge_target]
		local unit_position = POSITION_LOOKUP[unit]
		local distance_to_unit = Vector3.distance(unit_position, lunge_target_position)

		distance = math.min(distance, distance_to_unit)
	end

	local unit_rotation = self._first_person_component.rotation
	local flat_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(unit_rotation)))
	local directional_lunge = lunge_template.directional_lunge

	if directional_lunge then
		local move_input = self._input_extension:get("move")
		local rotation = self._first_person_component.rotation
		local move_direction = Quaternion.rotate(rotation, move_input)

		move_direction = Vector3.flat(move_direction)
		flat_direction = move_direction

		if Vector3.length_squared(move_direction) == 0 and not lunge_template.direction_requires_input then
			local forward_direction = Quaternion.forward(rotation)

			flat_direction = forward_direction
		end
	end

	local wielded_slot = self._visual_loadout_extension:currently_wielded_slot()
	local slot_to_wield = lunge_template.slot_to_wield

	if slot_to_wield and wielded_slot ~= slot_to_wield then
		PlayerUnitVisualLoadout.wield_slot(slot_to_wield, unit, t)
	end

	local anim_settings = lunge_template.anim_settings
	local on_enter_animation = anim_settings and anim_settings.on_enter
	local weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)
	local character_state_anim_events = weapon_template and weapon_template.character_state_anim_events

	if character_state_anim_events then
		local applicable_anim_events = character_state_anim_events[previous_state]

		on_enter_animation = applicable_anim_events and applicable_anim_events.lunging or on_enter_animation
	end

	if on_enter_animation then
		if type(on_enter_animation) ~= "table" then
			self:_play_animation(self._animation_extension, on_enter_animation)
		else
			for ii = 1, #on_enter_animation do
				local anim = on_enter_animation[ii]

				self:_play_animation(self._animation_extension, anim)
			end
		end
	end

	local proc_event_param_table = self._buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.lunging_unit = unit
		proc_event_param_table.last_hit_unit = self._last_hit_unit
		proc_event_param_table.lunge_template_name = self._lunge_character_state_component.lunge_template
		proc_event_param_table.lunge_direction = Vector3Box(flat_direction)

		self._buff_extension:add_proc_event(proc_events.on_lunge_start, proc_event_param_table)
	end

	local character_state_hit_mass_component = self._character_state_hit_mass_component

	lunge_character_state_component.is_lunging = true
	lunge_character_state_component.distance_left = distance
	lunge_character_state_component.direction = flat_direction
	lunge_character_state_component.lunge_template = lunge_template.name
	character_state_hit_mass_component.used_hit_mass_percentage = 0

	local movement_state_component = self._movement_state_component

	movement_state_component.method = "lunging"

	if lunge_template.is_dodging then
		self._movement_state_component.is_dodging = true
	end

	if self._is_server then
		local toughness = lunge_template.restore_toughness

		if toughness then
			local amount = Toughness.replenish_percentage(unit, toughness, true, "lunging")
			local player = Managers.state.player_unit_spawn:owner(unit)

			if amount > 0 and player then
				Managers.stats:record_private("hook_lounge_toughness_regenerated", player, amount)
			end
		end
	end

	local buff = lunge_template.add_buff

	if buff then
		local buff_extension = self._buff_extension

		if type(buff) == "table" then
			for _, buff_name in pairs(buff) do
				buff_extension:add_internally_controlled_buff(buff_name, t)
			end
		else
			buff_extension:add_internally_controlled_buff(buff, t)
		end
	end

	table.clear(self._played_timing_anims)
	table.clear(self._hit_enemy_units)

	self._last_hit_unit = nil

	local target_is_wielding_ranged_weapon
	local visual_loadout_extension = ScriptUnit.has_extension(lunge_target, "visual_loadout_system")

	if visual_loadout_extension then
		local wielded_slot_name = visual_loadout_extension:wielded_slot_name()

		target_is_wielding_ranged_weapon = visual_loadout_extension:is_inventory_slot_ranged(wielded_slot_name)
	end

	Managers.stats:record_private("hook_lunge_start", self._player, has_target, target_is_wielding_ranged_weapon)
end

local temp_hit_units = {}
local external_properties = {}

PlayerCharacterStateLunging.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateLunging.super.on_exit(self, unit, t, next_state)

	local movement_state_component = self._movement_state_component

	movement_state_component.is_dodging = false

	local lunge_character_state_component = self._lunge_character_state_component

	lunge_character_state_component.is_lunging = false
	self._moving_backwards = false
	self._has_pushback = false
	self._locomotion_steering_component.disable_minion_collision = false

	local hit_enemy_units = self._hit_enemy_units

	if next_state == "sprinting" then
		movement_state_component.method = "sprint"
	end

	local lunge_template_name = self._lunge_character_state_component.lunge_template
	local lunge_template = LungeTemplates[lunge_template_name]
	local anim_settings = lunge_template.anim_settings
	local on_exit_anim = anim_settings and anim_settings.on_exit

	if on_exit_anim then
		local wielded_slot = self._visual_loadout_extension:currently_wielded_slot()
		local slot_to_wield = lunge_template.slot_to_wield

		if slot_to_wield and wielded_slot == slot_to_wield then
			if type(on_exit_anim) ~= "table" then
				self:_play_animation(self._animation_extension, on_exit_anim)
			else
				for ii = 1, #on_exit_anim do
					local anim = on_exit_anim[ii]

					self:_play_animation(self._animation_extension, anim)
				end
			end
		end
	end

	local player_position = self._locomotion_component.position
	local rotation = self._first_person_component.rotation
	local on_exit_vfx = lunge_template.on_exit_vfx

	if on_exit_vfx then
		local vfx_pos = player_position + Vector3.up()

		self._fx_extension:spawn_particles(on_exit_vfx, vfx_pos, rotation)
	end

	local lunge_end_camera_shake = lunge_template.lunge_end_camera_shake

	if not self._unit_data_extension.is_resimulating and lunge_end_camera_shake then
		local will_be_predicted = true

		self._camera_extension:trigger_camera_shake(lunge_end_camera_shake, will_be_predicted)
	end

	if next_state ~= "dead" and lunge_template.slot_to_wield and not lunge_template.keep_slot_wielded_on_lunge_end then
		PlayerUnitVisualLoadout.wield_previous_slot(self._inventory_component, unit, t)
	end

	local on_finish_directional_shout = lunge_template.on_finish_directional_shout

	if on_finish_directional_shout then
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local shout_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
		local total_hits = {}
		local shout_dot = on_finish_directional_shout.shout_dot
		local total_range = on_finish_directional_shout.forward_range
		local damage_profile = on_finish_directional_shout.damage_profile
		local power_level = on_finish_directional_shout.power_level
		local hit = false
		local hit_elite_special_monster = false

		table.clear(broadphase_results)

		local num_hits = broadphase.query(broadphase, player_position, total_range, broadphase_results, enemy_side_names)
		local target_number = 1

		for ii = 1, num_hits do
			local enemy_unit = broadphase_results[ii]
			local enemy_unit_position = POSITION_LOOKUP[enemy_unit]
			local attack_direction = Vector3.normalize(Vector3.flat(enemy_unit_position - player_position))

			if Vector3.length_squared(attack_direction) == 0 then
				local player_rotation = locomotion_component.rotation

				attack_direction = Quaternion.forward(player_rotation)
			end

			local dot = Vector3.dot(shout_direction, attack_direction)

			if shout_dot < dot and not total_hits[enemy_unit] then
				local hit_zone_name = "torso"
				local _, _, _, stagger_result, _ = Attack.execute(enemy_unit, damage_profile, "attack_direction", attack_direction, "power_level", power_level, "hit_zone_name", hit_zone_name, "damage_type", nil, "attack_type", attack_types.shout, "attacking_unit", unit, "target_number", target_number)

				if stagger_result == "stagger" then
					hit_enemy_units[enemy_unit] = true
				end

				target_number = target_number + 1
				total_hits[enemy_unit] = true

				local unit_data = ScriptUnit.has_extension(enemy_unit, "unit_data_system")
				local breed = unit_data and unit_data:breed()
				local tags = breed and breed.tags

				if tags and (tags.elite or tags.special or tags.monster or tags.captain or tags.cultist_captain) then
					hit_elite_special_monster = true
				end

				hit = true

				if on_finish_directional_shout.force_stagger_type_if_not_staggered and stagger_result and stagger_result == "no_stagger" and tags and not tags.monster and not tags.captain and not tags.cultist_captain then
					hit_enemy_units[enemy_unit] = true

					local force_stagger_type_if_not_staggered_duration = on_finish_directional_shout.force_stagger_type_if_not_staggered_duration

					Stagger.force_stagger(enemy_unit, on_finish_directional_shout.force_stagger_type_if_not_staggered, attack_direction, force_stagger_type_if_not_staggered_duration, 1, force_stagger_type_if_not_staggered_duration, unit)
				end
			end
		end

		if hit then
			local anim_event_1p = on_finish_directional_shout.anim_event_1p

			if anim_event_1p then
				self._animation_extension:anim_event_1p(anim_event_1p)
			end
		end

		if hit_elite_special_monster then
			local wwise_alias = lunge_template.on_hit_gear_alias

			if wwise_alias then
				local source_name = "head"
				local sync_to_clients = false
				local include_client = false

				table.clear(external_properties)

				external_properties.ability_template = "adamant_charge"

				self._fx_extension:trigger_gear_wwise_event_with_source("ability_bash", external_properties, source_name, sync_to_clients, include_client)
			end
		end
	end

	local direction = lunge_character_state_component.direction
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local proc_event_param_table = buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.lunging_unit = unit
		proc_event_param_table.last_hit_unit = self._last_hit_unit
		proc_event_param_table.lunge_template_name = lunge_template_name
		proc_event_param_table.lunge_direction = Vector3Box(direction)

		buff_extension:add_proc_event(proc_events.on_lunge_end, proc_event_param_table)
	end

	local on_finish_explosion = lunge_template.on_finish_explosion

	if self._is_server and on_finish_explosion then
		local explosion_template = on_finish_explosion.explosion_template
		local forward_offset = on_finish_explosion.forward_offset
		local vertical_offset = on_finish_explosion.vertical_offset or 0
		local position = self._locomotion_component.position
		local impact_normal
		local power_level = 600
		local charge_level, attack_type

		table.clear(temp_hit_units)
		Explosion.create_explosion(self._world, self._physics_world, position + direction * forward_offset + Vector3.up() * vertical_offset, impact_normal, unit, explosion_template, power_level, charge_level, attack_type, nil, nil, nil, nil, temp_hit_units)

		local add_debuff_on_hit = lunge_template.add_debuff_on_hit
		local number_of_stacks = lunge_template.add_debuff_on_hit_stacks or 1

		for hit_unit, _ in pairs(temp_hit_units) do
			if add_debuff_on_hit and not hit_enemy_units[hit_unit] then
				_apply_buff_to_hit_unit(hit_unit, add_debuff_on_hit, number_of_stacks, t, unit)
			end

			hit_enemy_units[hit_unit] = true
		end

		table.clear(temp_hit_units)
	end

	local add_delayed_buff = lunge_template.add_delayed_buff

	if add_delayed_buff then
		local add_buff_delay = lunge_template.add_buff_delay or 0
		local time_in_lunge = t - self._character_state_component.entered_t
		local has_exit_before_delay = time_in_lunge < add_buff_delay

		if has_exit_before_delay then
			local add_delayed_buff_special_rule = lunge_template.add_delayed_buff_special_rule

			if add_delayed_buff_special_rule and self._talent_extension:has_special_rule(lunge_template.special_rule) then
				add_delayed_buff = add_delayed_buff_special_rule
			end

			if type(add_delayed_buff) == "table" then
				for _, buff_name in pairs(add_delayed_buff) do
					buff_extension:add_internally_controlled_buff(buff_name, t)
				end
			else
				buff_extension:add_internally_controlled_buff(add_delayed_buff, t)
			end
		end
	end

	_record_stat_on_lunge_complete(self._player, hit_enemy_units, lunge_template)
	table.clear(self._played_timing_anims)
	table.clear(hit_enemy_units)
end

PlayerCharacterStateLunging.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local lunge_character_state_component = self._lunge_character_state_component
	local time_in_lunge = t - self._character_state_component.entered_t
	local lunge_template_name = lunge_character_state_component.lunge_template
	local lunge_template = LungeTemplates[lunge_template_name]

	if not lunge_template.disable_weapon_actions then
		self._weapon_extension:update_weapon_actions(fixed_frame)
	end

	self._ability_extension:update_ability_actions(fixed_frame)

	local max_mass_hit = false
	local damage_settings = lunge_template and lunge_template.damage_settings

	if damage_settings and not self._unit_data_extension.is_resimulating then
		max_mass_hit = self:_update_enemy_hit_detection(unit, lunge_template)
	end

	local still_lunging

	if lunge_template then
		still_lunging = self:_update_lunge(unit, dt, time_in_lunge, lunge_template)
	end

	local add_delayed_buff = lunge_template and lunge_template.add_delayed_buff

	if add_delayed_buff then
		local add_buff_delay = lunge_template.add_buff_delay or 0
		local is_within_trigger_time = ActionUtility.is_within_trigger_time(time_in_lunge, dt, add_buff_delay)

		if is_within_trigger_time then
			local buff_extension = self._buff_extension
			local add_delayed_buff_special_rule = lunge_template.add_delayed_buff_special_rule

			if add_delayed_buff_special_rule and self._talent_extension:has_special_rule(lunge_template.special_rule) then
				add_delayed_buff = add_delayed_buff_special_rule
			end

			if type(add_delayed_buff) == "table" then
				for _, buff_name in pairs(add_delayed_buff) do
					buff_extension:add_internally_controlled_buff(buff_name, t)
				end
			else
				buff_extension:add_internally_controlled_buff(add_delayed_buff, t)
			end
		end
	end

	local anim_settings = lunge_template and lunge_template.anim_settings
	local timing_anims = anim_settings and anim_settings.timing_anims

	if timing_anims then
		self:_update_timing_anims(timing_anims, time_in_lunge)
	end

	return self:_check_transition(unit, t, self._input_extension, next_state_params, max_mass_hit, still_lunging, lunge_template, time_in_lunge)
end

PlayerCharacterStateLunging._check_transition = function (self, unit, t, input_extension, next_state_params, max_mass_hit, still_lunging, lunge_template, time_in_lunge)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local weapon_action_component = self._weapon_action_component
	local start_t = weapon_action_component.start_t or t
	local time_in_action = t - start_t
	local block_cancel_valid = false

	if time_in_action < time_in_lunge then
		block_cancel_valid = true
	end

	local block_input_cancel_time_threshold = lunge_template and lunge_template.block_input_cancel_time_threshold or 0
	local block_cancel = lunge_template and lunge_template.block_input_cancel and input_extension:get("action_two_hold") and block_cancel_valid and block_input_cancel_time_threshold < time_in_lunge

	if block_cancel then
		return "walking"
	end

	if self._moving_backwards and not (input_extension:get("move").y < -0.1) then
		self._moving_backwards = false
	end

	local move_back_cancel_valid = not self._moving_backwards
	local move_back_cancel_time_threshold = lunge_template and lunge_template.move_back_cancel_time_threshold or 0
	local move_back_cancel = lunge_template and lunge_template.move_back_cancel and move_back_cancel_valid and input_extension:get("move").y < -0.1 and move_back_cancel_time_threshold < time_in_lunge

	if move_back_cancel then
		return "walking"
	end

	if max_mass_hit then
		return "walking"
	end

	local cancel_on_unwield = lunge_template and lunge_template.cancel_on_unwield

	if cancel_on_unwield then
		local wielded_slot = self._visual_loadout_extension:currently_wielded_slot()
		local slot_to_wield = lunge_template.slot_to_wield

		if slot_to_wield and wielded_slot ~= slot_to_wield then
			return "walking"
		end
	end

	if not still_lunging then
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local wants_sprint = Sprint.check(t, unit, self._movement_state_component, self._sprint_character_state_component, input_extension, self._locomotion_component, weapon_action_component, self._combat_ability_action_component, self._alternate_fire_component, weapon_template, self._constants, self._buff_extension)

		if wants_sprint then
			next_state_params.disable_sprint_start_slowdown = true

			return "sprinting"
		else
			return "walking"
		end
	end
end

PlayerCharacterStateLunging._update_lunge = function (self, unit, dt, time_in_lunge, lunge_template)
	local lunge_character_state_component = self._lunge_character_state_component
	local locomotion_steering_component = self._locomotion_steering_component
	local prev_wanted_velocity = locomotion_steering_component.velocity_wanted
	local velocity_current = self._locomotion_component.velocity_current

	if not self._has_pushback then
		local lunge_direction = self._lunge_character_state_component.direction
		local dot = Vector3.dot(lunge_direction, Vector3.normalize(velocity_current))

		if dot < 0 then
			self._has_pushback = true
		end
	end

	local prev_velocity_wanted_flat = Vector3.flat(prev_wanted_velocity)
	local velocity_current_flat = Vector3.flat(velocity_current)
	local prev_length_sq = Vector3.length_squared(prev_velocity_wanted_flat)
	local current_length_sq = Vector3.length_squared(velocity_current_flat)
	local amount_progressed_from_wanted = current_length_sq / prev_length_sq
	local velocity_time_in_lunge = self._has_pushback and 1 or 0.3

	if amount_progressed_from_wanted < 0.1 and velocity_time_in_lunge < time_in_lunge then
		return false
	end

	if lunge_character_state_component.distance_left <= 0 then
		return false
	end

	local start_point = 1
	local lunge_speed_at_times = lunge_template.lunge_speed_at_times
	local current_speed_setting_index = Lunge.find_speed_settings_index(time_in_lunge, start_point, lunge_speed_at_times)
	local speed = Lunge.find_current_lunge_speed(time_in_lunge, current_speed_setting_index, lunge_speed_at_times)
	local direction = lunge_character_state_component.direction
	local lunge_target = lunge_character_state_component.lunge_target

	if lunge_target then
		local lunge_target_position = POSITION_LOOKUP[lunge_target]
		local unit_position = POSITION_LOOKUP[unit]
		local remaining_distance_to_target = Vector3.distance_squared(unit_position, lunge_target_position)

		if remaining_distance_to_target < 2 then
			return false
		end

		direction = Vector3.flat(Vector3.normalize(lunge_target_position - unit_position))
	elseif lunge_template.allow_steering then
		local target_rotation = locomotion_steering_component.target_rotation

		direction = Quaternion.forward(target_rotation)
	end

	locomotion_steering_component.velocity_wanted = direction * speed

	local move_delta = speed * dt

	lunge_character_state_component.distance_left = math.max(lunge_character_state_component.distance_left - move_delta, 0)

	Managers.stats:record_private("hook_lunge_distance", self._player, move_delta)

	return true
end

PlayerCharacterStateLunging._update_enemy_hit_detection = function (self, unit, lunge_template)
	local side_system = Managers.state.extension:system("side_system")
	local damage_settings = lunge_template.damage_settings
	local damage_profile = damage_settings.damage_profile
	local damage_type = damage_settings.damage_type
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local t = Managers.time:time("gameplay")
	local use_armor_type = not not lunge_template.stop_armor_types
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local radius = damage_settings.radius
	local actors, num_actors = PhysicsWorld.immediate_overlap(self._physics_world, "shape", "sphere", "position", locomotion_position, "size", radius, "collision_filter", DAMAGE_COLLISION_FILTER, "rewind_ms", rewind_ms)
	local character_state_hit_mass_component = self._character_state_hit_mass_component
	local max_hit_mass = _max_hit_mass(damage_settings, lunge_template, unit)
	local used_hit_mass_percentage = character_state_hit_mass_component.used_hit_mass_percentage
	local current_mass_hit = max_hit_mass >= math.huge and 0 or max_hit_mass * used_hit_mass_percentage
	local should_stop = false
	local fp_position = self._first_person_component.position
	local lunge_direction = self._lunge_character_state_component.direction
	local lunge_dir_right = Vector3.cross(lunge_direction, Vector3.up())
	local forward, right = Vector3.forward(), Vector3.right()
	local lunge_rotation = Quaternion.look(lunge_direction)
	local left_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward - right))
	local right_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward + right))
	local hit_enemy_units = self._hit_enemy_units

	for ii = 1, num_actors do
		local hit_actor = actors[ii]
		local hit_unit = Actor.unit(hit_actor)

		if side_system:is_enemy(unit, hit_unit) and not hit_enemy_units[hit_unit] then
			self._last_hit_unit = hit_unit

			local hit_position = POSITION_LOOKUP[hit_unit]
			local hit_direction = Vector3.normalize(Vector3.flat(hit_position - fp_position))
			local attack_direction
			local dot = Vector3.dot(hit_direction, lunge_dir_right)

			if dot > 0 then
				attack_direction = right_attack_direction
			else
				attack_direction = left_attack_direction
			end

			local hit_world_position = Actor.position(hit_actor)
			local behaviour_extension = ScriptUnit.has_extension(hit_unit, "behavior_system")
			local hit_unit_action = behaviour_extension and behaviour_extension:running_action()
			local attack_type = AttackSettings.attack_types.melee
			local damage_dealt, attack_result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", LUNGE_ATTACK_POWER_LEVEL, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type)

			ImpactEffect.play(hit_unit, hit_actor, damage_dealt, damage_type, nil, attack_result, hit_world_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

			if t >= self._push_sfx_cooldown and self._is_server then
				MinionPushFx.play_sfx_for_clients_except(hit_unit, MinionPushFxTemplates.lunge_push, self._player)

				self._push_sfx_cooldown = t + math.random_range(0, 0.2)
			end

			local add_debuff_on_hit = lunge_template.add_debuff_on_hit

			if add_debuff_on_hit and attack_result ~= "died" then
				local number_of_stacks = lunge_template.add_debuff_on_hit_stacks or 1

				_apply_buff_to_hit_unit(hit_unit, add_debuff_on_hit, number_of_stacks, t, unit)
			end

			hit_enemy_units[hit_unit] = true

			_record_stat_on_lunge_hit(self._player, hit_unit, attack_result, hit_unit_action, lunge_template)

			current_mass_hit = current_mass_hit + HitMass.target_hit_mass(unit, hit_unit, HIT_WEAKSPOT, IS_CRITICAL_STRIKE, attack_type)

			if use_armor_type then
				local hit_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
				local hit_unit_breed = hit_unit_data_extension:breed()
				local armor_type = Armor.armor_type(unit, hit_unit_breed)
				local stop_armor_types = lunge_template.stop_armor_types

				for jj = 1, #stop_armor_types do
					if armor_type == stop_armor_types[jj] then
						local hit_dot_check = lunge_template.hit_dot_check

						if hit_dot_check then
							do
								local hit_dot = Vector3.dot(lunge_direction, hit_direction)

								if hit_dot_check < hit_dot then
									should_stop = true
								end
							end

							break
						end

						should_stop = true

						break
					end
				end
			end

			local stop_tags = lunge_template.stop_tags

			if not should_stop and stop_tags then
				local unit_data = ScriptUnit.has_extension(hit_unit, "unit_data_system")
				local breed = unit_data and unit_data:breed()
				local tags = breed and breed.tags

				if tags then
					for tag, _ in pairs(tags) do
						if stop_tags[tag] then
							should_stop = true

							local damage_profile_stop = damage_settings.damage_profile_damage

							if damage_profile_stop then
								local damage_dealt, attack_result, damage_efficiency = Attack.execute(hit_unit, damage_profile_stop, "power_level", LUNGE_ATTACK_POWER_LEVEL, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type)
							end

							Managers.state.blood:play_screen_space_blood(self._fx_extension)

							local anim_event_1p_on_damage = damage_settings.anim_event_1p_on_damage

							if anim_event_1p_on_damage then
								self._animation_extension:anim_event_1p(anim_event_1p_on_damage)
							end

							break
						end
					end
				end
			end
		end
	end

	character_state_hit_mass_component.used_hit_mass_percentage = math.clamp(max_hit_mass > 0 and current_mass_hit / max_hit_mass or 0, 0, 1)

	return should_stop
end

PlayerCharacterStateLunging._update_timing_anims = function (self, timing_anims, time_in_lunge)
	local played_timing_anims = self._played_timing_anims
	local anim_extension = self._animation_extension

	for time, anim in pairs(timing_anims) do
		local time_to_play = time <= time_in_lunge
		local already_played = played_timing_anims[time]

		if time_to_play and not already_played then
			played_timing_anims[time] = true

			self:_play_animation(anim_extension, anim)
		end
	end
end

local NO_LERP_VALUES = {}

function _max_hit_mass(damage_settings, lunge_template, unit)
	local charge_level = 1
	local damage_profile = damage_settings.damage_profile
	local critical_strike = false
	local power_level = lunge_template.lunge_power_level or DEFAULT_POWER_LEVEL
	local max_hit_mass_attack, max_hit_mass_impact = DamageProfile.max_hit_mass(damage_profile, power_level, charge_level, NO_LERP_VALUES, critical_strike, unit)
	local max_hit_mass = math.max(max_hit_mass_attack, max_hit_mass_impact)

	return max_hit_mass
end

local function _was_charging_plague_ogryn_that_is_now_staggered(unit, optional_action)
	if not unit then
		return false
	end

	local unit_data = ScriptUnit.has_extension(unit, "unit_data_system")
	local target_breed = unit_data and unit_data:breed()

	if not target_breed then
		return false
	end

	local breed_name = target_breed.name

	if breed_name ~= "chaos_plague_ogryn" then
		return false
	end

	if optional_action ~= "charge" then
		return false
	end

	if not MinionState.is_staggered(unit) then
		return false
	end

	return true
end

function _record_stat_on_lunge_hit(player, enemy_unit, attack_result, optional_action, lunge_template)
	local archetype_name = player:archetype_name()

	if archetype_name == "ogryn" and _was_charging_plague_ogryn_that_is_now_staggered(enemy_unit, optional_action) then
		Managers.achievements:unlock_achievement(player, "ogryn_2_bull_rushed_charging_ogryn")
	end
end

function _record_stat_on_lunge_complete(player, hit_units, lunge_template)
	local number_of_hit_units = 0
	local number_of_hit_ogryns = 0
	local number_of_hit_ranged = 0
	local number_of_hit_elites = 0
	local number_of_hit_specials = 0

	for hit_unit, _ in pairs(hit_units) do
		number_of_hit_units = number_of_hit_units + 1

		local unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()

		if breed and breed.tags.ogryn then
			number_of_hit_ogryns = number_of_hit_ogryns + 1
		end

		if breed and breed.tags.elite then
			number_of_hit_elites = number_of_hit_elites + 1
		end

		if breed and breed.tags.special then
			number_of_hit_specials = number_of_hit_specials + 1
		end

		if breed and breed.ranged then
			number_of_hit_ranged = number_of_hit_ranged + 1
		end
	end

	Managers.stats:record_private("hook_lunge_stop", player, number_of_hit_units, number_of_hit_ranged, number_of_hit_ogryns, number_of_hit_elites, number_of_hit_specials)
end

function _apply_buff_to_hit_unit(hit_unit, buff_to_apply, number_of_stacks, t, origin_unit)
	local buff_extension = ScriptUnit.has_extension(hit_unit, "buff_system")
	local toughness_extension = ScriptUnit.has_extension(hit_unit, "toughness_system")
	local has_toughness = toughness_extension and toughness_extension:current_toughness_percent() > 0

	if HEALTH_ALIVE[hit_unit] and buff_extension and not has_toughness then
		buff_extension:add_internally_controlled_buff_with_stacks(buff_to_apply, number_of_stacks, t, "owner_unit", origin_unit)
	end
end

return PlayerCharacterStateLunging
