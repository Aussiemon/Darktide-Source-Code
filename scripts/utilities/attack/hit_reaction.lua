-- chunkname: @scripts/utilities/attack/hit_reaction.lua

local AlternateFire = require("scripts/utilities/alternate_fire")
local AttackingUnitResolver = require("scripts/utilities/attack/attacking_unit_resolver")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Block = require("scripts/utilities/attack/block")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local DisorientationSettings = require("scripts/settings/damage/disorientation_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local ForceLookRotation = require("scripts/extension_systems/first_person/utilities/force_look_rotation")
local FriendlyFire = require("scripts/utilities/attack/friendly_fire")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stagger = require("scripts/utilities/attack/stagger")
local Stun = require("scripts/utilities/attack/stun")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local stagger_results = AttackSettings.stagger_results
local disorientation_templates = DisorientationSettings.disorientation_templates
local buff_keywords = BuffSettings.keywords
local _minion_hit_reaction, _player_hit_reaction, _toughness_broken_disorient, _toughness_absorbed_disorient, _interrupt_alternate_fire, _interrupt_interaction, _push_or_catapult, _push, _catapult, _force_look, _drop_luggable
local HitReaction = {}

HitReaction.apply = function (damage_profile, damage_profile_lerp_values, target_weapon_template, attacked_breed_or_nil, target_buff_extension, attack_result, attacked_unit, attacking_unit, attack_direction, hit_position, target_settings, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_type, herding_template_or_nil, hit_shield)
	if Breed.is_minion(attacked_breed_or_nil) then
		return _minion_hit_reaction(attack_result, attacked_unit, attacking_unit, damage_profile, damage_profile_lerp_values, target_settings, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_direction, attack_type, herding_template_or_nil, hit_shield)
	elseif Breed.is_player(attacked_breed_or_nil) then
		return _player_hit_reaction(attack_result, damage_profile, target_weapon_template, target_buff_extension, attacked_unit, attacking_unit, attack_direction, hit_position, attack_type)
	end
end

HitReaction.disorient_player = function (attacked_unit, unit_data_extension, disorientation_type, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, weapon_template, is_predicted, toughness_broken)
	local breed = unit_data_extension:breed()
	local breed_hit_reaction_stun_types = breed and breed.hit_reaction_stun_types
	local unit_inventory_component = unit_data_extension:read_component("inventory")
	local target_wielded_slot = unit_inventory_component.wielded_slot
	local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)
	local is_hit_by_melee = attack_type == AttackSettings.attack_types.melee
	local melee_hit_on_ranged = (target_wielded_slot == "slot_secondary" or target_wielded_slot == "slot_grenade_ability") and is_hit_by_melee
	local melee_hit_on_sprinting = is_hit_by_melee and is_sprinting
	local attack_disorientation_template = disorientation_type and disorientation_templates[disorientation_type]
	local attack_have_stun = attack_disorientation_template and attack_disorientation_template.stun and attack_disorientation_template.stun.interrupt_delay ~= nil
	local fumbled = breed_hit_reaction_stun_types and breed_hit_reaction_stun_types.fumbled and (not attack_disorientation_template or not attack_disorientation_template.ignore_fumbled)
	local has_fumbled = (melee_hit_on_ranged or melee_hit_on_sprinting) and attack_have_stun
	local wanted_disorientation_type = has_fumbled and fumbled or disorientation_type
	local disorientation_template = wanted_disorientation_type and disorientation_templates[wanted_disorientation_type]

	if not disorientation_template then
		return
	end

	local stun_settings = disorientation_template.stun
	local trigger_stun = stun_settings and stun_settings.stun_duration and stun_settings.stun_duration > 0

	if stun_allowed and trigger_stun and wanted_disorientation_type then
		Stun.apply(attacked_unit, wanted_disorientation_type, attack_direction, weapon_template, ignore_stun_immunity, is_predicted, toughness_broken)
	end

	local buff_extension = ScriptUnit.extension(attacked_unit, "buff_system")
	local slowdown_immune = buff_extension:has_keyword(buff_keywords.slowdown_immune)
	local stun_immune = buff_extension:has_keyword(buff_keywords.stun_immune)
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")

	if alternate_fire_component.is_active and buff_extension:has_keyword(buff_keywords.ranged_alternate_fire_interrupt_immune) then
		stun_immune = true
	end

	local movement_speed_buff = disorientation_template.movement_speed_buff

	if not slowdown_immune and movement_speed_buff then
		local t = FixedFrame.get_latest_fixed_time()

		buff_extension:add_internally_controlled_buff(movement_speed_buff, t)
	end

	if not stun_immune and disorientation_template then
		local animation_extension = ScriptUnit.extension(attacked_unit, "animation_system")
		local hit_react_anim_1p = disorientation_template.hit_react_anim_1p
		local hit_react_anim_3p = disorientation_template.hit_react_anim_3p

		if hit_react_anim_1p then
			animation_extension:anim_event_1p(hit_react_anim_1p)
		end

		if hit_react_anim_3p then
			animation_extension:anim_event(hit_react_anim_3p)
		end
	end

	local sound_event = disorientation_template.sound_event

	if sound_event then
		local fx_extension = ScriptUnit.extension(attacked_unit, "fx_system")

		fx_extension:trigger_exclusive_wwise_event(sound_event)
	end

	local screen_space_effect = disorientation_template.screen_space_effect

	if screen_space_effect then
		local fx_extension = ScriptUnit.extension(attacked_unit, "fx_system")

		fx_extension:spawn_exclusive_particle(screen_space_effect, Vector3(0, 0, 1))
	end
end

function _minion_hit_reaction(attack_result, attacked_unit, attacking_unit, damage_profile, damage_profile_lerp_values, target_settings, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_direction, attack_type, herding_template_or_nil, hit_shield)
	if Stagger.can_stagger(attacked_unit) then
		local applied_stagger, stagger_type = Stagger.apply_stagger(attacked_unit, damage_profile, damage_profile_lerp_values, target_settings, attacking_unit, power_level, charge_level, is_critical_strike, is_backstab, is_flanking, hit_weakspot, dropoff_scalar, attack_direction, attack_type, attack_result, herding_template_or_nil, hit_shield)

		return applied_stagger and stagger_results.stagger or stagger_results.no_stagger, stagger_type
	end
end

function _player_hit_reaction(attack_result, damage_profile, target_weapon_template, target_buff_extension, attacked_unit, attacking_unit, attack_direction, hit_position, attack_type)
	local target_unit_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
	local breed = target_unit_data_extension:breed()
	local hit_reaction_keys = breed.hit_reaction_keys
	local catapulting_template = damage_profile[hit_reaction_keys.catapulting_template]
	local disorientation_type = attack_result == attack_results.toughness_absorbed and damage_profile[hit_reaction_keys.toughness_disorientation_type] or damage_profile[hit_reaction_keys.disorientation_type]
	local force_look_function = damage_profile[hit_reaction_keys.force_look_function]
	local ignore_stun_immunity = damage_profile[hit_reaction_keys.ignore_stun_immunity]
	local interrupt_alternate_fire = damage_profile[hit_reaction_keys.interrupt_alternate_fire]
	local push_template = damage_profile[hit_reaction_keys.push_template]
	local side_system = Managers.state.extension:system("side_system")
	local is_ally = side_system:is_ally(attacking_unit, attacked_unit)
	local stun_allowed = not is_ally or FriendlyFire.is_enabled(attacking_unit, attacked_unit, attack_type)
	local stagger_result = breed.default_stagger_result or stagger_results.stagger
	local uninterruptible = target_buff_extension and target_buff_extension:has_keyword(buff_keywords.uninterruptible)
	local attacking_unit_owner_unit = AttackingUnitResolver.resolve(attacking_unit)

	if attack_result == attack_results.blocked then
		local block_broken = Block.attempt_block_break(attacked_unit, attacking_unit, hit_position, attack_type, attack_direction, target_weapon_template, damage_profile)
		local was_pushed, was_catapulted

		if block_broken then
			if catapulting_template and catapulting_template.catapult_through_block then
				local pushed, catapulted = _push_or_catapult(target_unit_data_extension, attacked_unit, attacking_unit_owner_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)

				was_catapulted = catapulted
				was_pushed = pushed
			end

			if not was_catapulted then
				HitReaction.disorient_player(attacked_unit, target_unit_data_extension, disorientation_type, false, true, attack_direction, attack_type, target_weapon_template, false)
				_interrupt_interaction(attacked_unit, damage_profile, uninterruptible)
				_force_look(target_unit_data_extension, force_look_function, attacked_unit, attack_direction)
			end
		else
			stagger_result = stagger_results.no_stagger
		end

		if not was_catapulted and not was_pushed then
			local push_through_block = push_template and push_template.push_through_block

			if push_through_block then
				_push(target_unit_data_extension, attacked_unit, push_template, attack_direction, attack_type, ignore_stun_immunity)
			end
		end
	elseif attack_result == attack_results.toughness_broken and not damage_profile.ignore_toughness_broken_disorient then
		_drop_luggable(attacked_unit, target_unit_data_extension, attack_type)

		local _, was_catapulted = _push_or_catapult(target_unit_data_extension, attacked_unit, attacking_unit_owner_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)

		if not was_catapulted then
			_toughness_broken_disorient(target_unit_data_extension, target_weapon_template, attacked_unit, attack_direction, attack_type, stun_allowed, ignore_stun_immunity)
			_interrupt_alternate_fire(target_unit_data_extension, target_weapon_template, attacked_unit, interrupt_alternate_fire)
			_interrupt_interaction(attacked_unit, damage_profile, uninterruptible)
			_force_look(target_unit_data_extension, force_look_function, attacked_unit, attack_direction)
		end
	elseif attack_result == attack_results.toughness_absorbed then
		_push_or_catapult(target_unit_data_extension, attacked_unit, attacking_unit_owner_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)

		local override_disorientation_type = damage_profile[hit_reaction_keys.toughness_disorientation_type]

		_toughness_absorbed_disorient(target_unit_data_extension, target_weapon_template, attacked_unit, attack_direction, attack_type, stun_allowed, ignore_stun_immunity, override_disorientation_type)
	elseif attack_result == attack_results.toughness_absorbed_melee then
		_drop_luggable(attacked_unit, target_unit_data_extension, attack_type)

		local _, was_catapulted = _push_or_catapult(target_unit_data_extension, attacked_unit, attacking_unit_owner_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)

		if not was_catapulted then
			local hit_reaction_stun_types = breed.hit_reaction_stun_types
			local melee_toughness_hitreact = hit_reaction_stun_types.toughness_absorbed_melee

			HitReaction.disorient_player(attacked_unit, target_unit_data_extension, melee_toughness_hitreact, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, target_weapon_template, false)
			_interrupt_alternate_fire(target_unit_data_extension, target_weapon_template, attacked_unit, interrupt_alternate_fire)
			_force_look(target_unit_data_extension, force_look_function, attacked_unit, attack_direction)
		end
	elseif attack_result == attack_results.damaged then
		_drop_luggable(attacked_unit, target_unit_data_extension, attack_type)

		local _, was_catapulted = _push_or_catapult(target_unit_data_extension, attacked_unit, attacking_unit_owner_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)

		if not was_catapulted then
			HitReaction.disorient_player(attacked_unit, target_unit_data_extension, disorientation_type, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, target_weapon_template, false)
			_interrupt_alternate_fire(target_unit_data_extension, target_weapon_template, attacked_unit, interrupt_alternate_fire)
			_force_look(target_unit_data_extension, force_look_function, attacked_unit, attack_direction)
		end
	end

	return stagger_result
end

function _toughness_broken_disorient(unit_data_extension, target_weapon_template, attacked_unit, attack_direction, attack_type, stun_allowed, ignore_stun_immunity)
	local breed = unit_data_extension:breed()
	local hit_reaction_stun_types = breed.hit_reaction_stun_types
	local fumbled = hit_reaction_stun_types.fumbled
	local toughness_broken = true

	HitReaction.disorient_player(attacked_unit, unit_data_extension, fumbled, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, target_weapon_template, false, toughness_broken)
end

function _toughness_absorbed_disorient(unit_data_extension, target_weapon_template, attacked_unit, attack_direction, attack_type, stun_allowed, ignore_stun_immunity, override_disorientation_type)
	local breed = unit_data_extension:breed()
	local hit_reaction_stun_types = breed.hit_reaction_stun_types
	local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	local is_sprinting = Sprint.is_sprinting(sprint_character_state_component)

	if attack_type == AttackSettings.attack_types.ranged and is_sprinting then
		local ranged_sprinting = hit_reaction_stun_types.toughness_absorbed_ranged_sprinting

		HitReaction.disorient_player(attacked_unit, unit_data_extension, ranged_sprinting, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, target_weapon_template, false)
	else
		local stun_type = override_disorientation_type or hit_reaction_stun_types.toughness_absorbed_default

		HitReaction.disorient_player(attacked_unit, unit_data_extension, stun_type, stun_allowed, ignore_stun_immunity, attack_direction, attack_type, target_weapon_template, false)
	end
end

function _interrupt_alternate_fire(unit_data_extension, target_weapon_template, attacked_unit, interrupt_alternate_fire)
	local alternate_fire = unit_data_extension:write_component("alternate_fire")
	local alternate_fire_settings = target_weapon_template and target_weapon_template.alternate_fire_settings
	local always_interrupt_alternate_fire, uninterruptible

	always_interrupt_alternate_fire = alternate_fire_settings and alternate_fire_settings.always_interrupt
	uninterruptible = alternate_fire_settings and alternate_fire_settings.uninterruptible

	local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
	local has_buff = buff_extension:has_keyword(buff_keywords.stun_immune)

	if (interrupt_alternate_fire or always_interrupt_alternate_fire) and alternate_fire.is_active and not has_buff then
		local weapon_tweak_templates_component = unit_data_extension:write_component("weapon_tweak_templates")
		local animation_extension = ScriptUnit.has_extension(attacked_unit, "animation_system")

		if not uninterruptible then
			local weapon_extension = ScriptUnit.extension(attacked_unit, "weapon_system")
			local action_settings = weapon_extension:running_action_settings()
			local hard_stop_alternate_fire = true

			if action_settings then
				local t = FixedFrame.get_latest_fixed_time()

				Interrupt.action(t, attacked_unit, "alternate_fire_interrupt")

				local action_settings_after_interrupt = weapon_extension:running_action_settings()

				if action_settings_after_interrupt then
					hard_stop_alternate_fire = false
				elseif not alternate_fire.is_active then
					hard_stop_alternate_fire = false
				end
			end

			if hard_stop_alternate_fire then
				local peeking_component = unit_data_extension:write_component("peeking")
				local first_person_extension = ScriptUnit.extension(attacked_unit, "first_person_system")

				AlternateFire.stop(alternate_fire, peeking_component, first_person_extension, weapon_tweak_templates_component, animation_extension, target_weapon_template, attacked_unit, false)
			end
		end
	end
end

function _interrupt_interaction(attacked_unit, damage_profile, uninterruptible)
	if uninterruptible then
		return
	end

	local interactor_extension = ScriptUnit.has_extension(attacked_unit, "interactor_system")
	local is_interacting = interactor_extension and interactor_extension:is_interacting()

	if is_interacting then
		local t = Managers.time:time("gameplay")

		interactor_extension:cancel_interaction(t)
	end
end

function _push_or_catapult(unit_data_extension, attacked_unit, attacking_unit, push_template, catapulting_template, force_look_function, attack_direction, attack_type, hit_position, ignore_stun_immunity)
	local was_pushed, was_catapulted

	if catapulting_template then
		_catapult(unit_data_extension, catapulting_template, force_look_function, attacking_unit, attacked_unit, hit_position)

		was_catapulted = true
	else
		_push(unit_data_extension, attacked_unit, push_template, attack_direction, attack_type, ignore_stun_immunity)

		was_pushed = true
	end

	return was_pushed, was_catapulted
end

function _push(unit_data_extension, attacked_unit, push_template, attack_direction, attack_type, ignore_stun_immunity)
	if push_template then
		local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
		local has_buff = not push_template.ignore_stun_immunity and buff_extension:has_keyword(buff_keywords.stun_immune)

		if ignore_stun_immunity or not has_buff then
			local locomotion_push_component = unit_data_extension:write_component("locomotion_push")

			Push.add(attacked_unit, locomotion_push_component, attack_direction, push_template, attack_type)
		end
	end
end

function _catapult(attacked_unit_data_extension, catapulting_settings, force_look_function, attacking_unit_or_nil, attacked_unit, hit_position)
	local catapult_source_position

	if catapulting_settings.use_hit_position then
		catapult_source_position = hit_position
	else
		local attacking_unit_position = POSITION_LOOKUP[attacking_unit_or_nil]

		if attacking_unit_position then
			catapult_source_position = attacking_unit_position
		else
			catapult_source_position = hit_position
		end
	end

	local node = Unit.node(attacked_unit, catapulting_settings.direction_from_node)
	local catapult_position = Unit.world_position(attacked_unit, node)
	local direction = Vector3.normalize(catapult_position - catapult_source_position)
	local catapult_force = catapulting_settings.force
	local catapult_z_force = catapulting_settings.z_force
	local velocity = direction * catapult_force

	velocity.z = catapult_z_force

	local catapulted_state_input = attacked_unit_data_extension:write_component("catapulted_state_input")

	Catapulted.apply(catapulted_state_input, velocity)

	local force_look_direction = Vector3.normalize(velocity)

	_force_look(attacked_unit_data_extension, force_look_function, attacked_unit, force_look_direction)
end

function _force_look(unit_data_extension, force_look_function, attacked_unit, force_look_direction)
	local character_state_component = unit_data_extension:read_component("character_state")
	local buff_extension = ScriptUnit.has_extension(attacked_unit, "buff_system")
	local has_buff = buff_extension:has_keyword(buff_keywords.stun_immune)

	if PlayerUnitStatus.is_disabled(character_state_component) or has_buff then
		return
	end

	local force_look_rotation_component = unit_data_extension:write_component("force_look_rotation")
	local forcing_look_rotation = force_look_rotation_component.use_force_look_rotation

	if force_look_function and not forcing_look_rotation then
		local extra_timing = 0
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(attacked_unit)

		if player and player.remote then
			extra_timing = player:lag_compensation_rewind_s()
		end

		local t = FixedFrame.get_latest_fixed_time()
		local first_person_component = unit_data_extension:write_component("first_person")
		local rotation = first_person_component.rotation
		local pitch, yaw, duration = force_look_function(rotation, force_look_direction)

		ForceLookRotation.start(force_look_rotation_component, rotation, pitch, yaw, t + extra_timing, duration)
	end
end

function _drop_luggable(unit, unit_data_extension, attack_type)
	if attack_type == attack_types.buff then
		return
	end

	local t = FixedFrame.get_latest_fixed_time()
	local inventory_component = unit_data_extension:read_component("inventory")
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_template = visual_loadout_extension:weapon_template_from_slot("slot_luggable")

	if not weapon_template or weapon_template.retain_luggable_when_damaged then
		return
	end

	local enable_physics = true

	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, enable_physics)
end

return HitReaction
