-- chunkname: @scripts/extension_systems/weapon/actions/action_sweep.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local Action = require("scripts/utilities/action/action")
local ActionSweepSettings = require("scripts/settings/equipment/action_sweep_settings")
local AimAssist = require("scripts/utilities/aim_assist")
local Armor = require("scripts/utilities/attack/armor")
local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Breed = require("scripts/utilities/breed")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local HazardProp = require("scripts/utilities/level_props/hazard_prop")
local Health = require("scripts/utilities/health")
local HitMass = require("scripts/utilities/attack/hit_mass")
local HitZone = require("scripts/utilities/attack/hit_zone")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local MinionDeath = require("scripts/utilities/minion_death")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local Stamina = require("scripts/utilities/attack/stamina")
local SweepSplineExported = require("scripts/extension_systems/weapon/actions/utilities/sweep_spline_exported")
local SweepStickyness = require("scripts/utilities/action/sweep_stickyness")
local Weakspot = require("scripts/utilities/attack/weakspot")
local WieldableSlotScripts = require("scripts/extension_systems/visual_loadout/utilities/wieldable_slot_scripts")
local attack_results = AttackSettings.attack_results
local melee_attack_strengths = AttackSettings.melee_attack_strength
local proc_events = BuffSettings.proc_events
local buff_keywords = BuffSettings.keywords
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local POWERED_WWISE_SWITCH = {
	[false] = "false",
	[true] = "true",
}
local _dot

local function _calculate_attack_direction(action_settings, start_rotation, end_rotation, player_rotation, attack_direction_override, uses_matrix_data)
	local attack_direction

	if attack_direction_override then
		local direction

		if attack_direction_override == "left" then
			direction = -Vector3.right()
		elseif attack_direction_override == "right" then
			direction = Vector3.right()
		elseif attack_direction_override == "up" then
			direction = Vector3.lerp(Vector3.forward(), Vector3.up(), 0.75)
		elseif attack_direction_override == "down" then
			direction = Vector3.lerp(Vector3.forward(), Vector3.down(), 0.25)
		elseif attack_direction_override == "push" then
			direction = Vector3.forward()
		elseif attack_direction_override == "pull" then
			direction = -Vector3.forward()
		end

		attack_direction = Quaternion.rotate(player_rotation, direction)
	else
		local rotation = Quaternion.lerp(start_rotation, end_rotation, 0.5)
		local quaternion_axis = (action_settings.attack_direction or uses_matrix_data) and "forward" or "right"

		attack_direction = Quaternion[quaternion_axis](rotation)
	end

	return action_settings.invert_attack_direction and -attack_direction or attack_direction
end

local function _breed_aborts_attack(action_settings, special_active, target_breed_or_nil)
	if not target_breed_or_nil then
		return false
	end

	local force_abort_breed_tags = special_active and action_settings.force_abort_breed_tags_special_active or action_settings.force_abort_breed_tags

	if not force_abort_breed_tags then
		return false
	end

	local breed_tags = target_breed_or_nil.tags

	if not breed_tags then
		return false
	end

	for i = 1, #force_abort_breed_tags do
		local abort_tag = force_abort_breed_tags[i]

		if breed_tags[abort_tag] then
			return true
		end
	end

	return false
end

local ActionSweep = class("ActionSweep", "ActionWeaponBase")

ActionSweep.init = function (self, action_context, action_params, action_settings)
	ActionSweep.super.init(self, action_context, action_params, action_settings)

	self._sweep_splines, self._all_sweeps_aborted_mask, self._hit_units, self._sweep_process_mode, self._uses_matrix_data = self:_init_splines(action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._action_sweep_component = unit_data_extension:write_component("action_sweep")
	self._weapon_action_component = unit_data_extension:write_component("weapon_action")
	self._dodge_character_state_component = unit_data_extension:write_component("dodge_character_state")
	self._movement_state_component = unit_data_extension:write_component("movement_state")
	self._character_state_component = unit_data_extension:read_component("character_state")
	self._block_component = unit_data_extension:write_component("block")

	for sweep_index = 1, #self._sweep_splines do
		-- Nothing
	end

	self._saved_entries = {}
	self._num_saved_entries = 0
	self._time_before_processing_saved_entries = 0
	self._dealt_sticky_damage = false
	self._current_sticky_armor_type = nil

	local max_num_saved_entries = action_settings.max_num_saved_entries

	if max_num_saved_entries then
		for i = 1, max_num_saved_entries do
			self._saved_entries[i] = {
				hit_distance = 0,
				hit_actor = ActorBox(),
				hit_position = Vector3Box(),
				hit_normal = Vector3Box(),
			}
		end
	end

	local weapon = action_params.weapon

	self._sweep_fx_source_name = weapon.fx_sources._sweep

	local visual_loadout_extension = ScriptUnit.has_extension(self._player_unit, "visual_loadout_system")

	self._wieldable_slot_scripts = visual_loadout_extension:current_wielded_slot_scripts()
end

ActionSweep._init_splines = function (self, action_settings)
	local sweeps = action_settings.sweeps
	local sweep_process_mode = action_settings.sweep_process_mode or ActionSweepSettings.multi_sweep_process_mode.shared
	local hit_units = {
		{},
	}
	local uses_matrix_data = false
	local all_sweeps_aborted_mask = 1
	local sweep_splines = {}

	for sweep_index = 1, #sweeps do
		local matrices_data_location = sweeps[sweep_index].matrices_data_location
		local anchor_point_offset = sweeps[sweep_index].anchor_point_offset

		sweep_splines[sweep_index] = SweepSplineExported:new(action_settings, matrices_data_location, anchor_point_offset)
		uses_matrix_data = true
		all_sweeps_aborted_mask = bit.bor(all_sweeps_aborted_mask, bit.lshift(1, sweep_index - 1))

		if sweep_process_mode == ActionSweepSettings.multi_sweep_process_mode.separate then
			hit_units[sweep_index] = {}
		else
			hit_units[sweep_index] = hit_units[1]
		end
	end

	return sweep_splines, all_sweeps_aborted_mask, hit_units, sweep_process_mode, uses_matrix_data
end

ActionSweep.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionSweep.super.start(self, action_settings, t, time_scale, action_start_params)

	self._weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or self._weapon_template.special_charge_template or "none"
	self._auto_completed = action_start_params.auto_completed

	local is_chain_action = action_start_params.is_chain_action
	local combo_count = action_start_params.combo_count

	self._combo_count = combo_count

	self:_check_for_critical_strike(true, false)

	for i = 1, #self._hit_units do
		table.clear(self._hit_units[i])
	end

	self._num_saved_entries = 0
	self._time_before_processing_saved_entries = 0

	local damage_profile, damage_profile_special_active = self:_hit_mass_damage_profile(1)
	local is_critical_strike = self._critical_strike_component.is_active
	local charge_level = 1
	local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL

	self._max_hit_mass = self:_calculate_max_hit_mass(damage_profile, power_level, charge_level, is_critical_strike)
	self._max_hit_mass_special = self:_calculate_max_hit_mass(damage_profile_special_active, power_level, charge_level, is_critical_strike)
	self._amount_of_mass_hit = 0
	self._target_index = 0
	self._num_hit_enemies = 0
	self._hit_enemies = false
	self._num_killed_enemies = 0
	self._dealt_sticky_damage = false
	self._hit_weakspot = false
	self._current_sticky_armor_type = nil

	self:_reset_sweep_component()

	if action_settings.activate_special_during_sweep then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true)

		self._weapon_action_component.special_active_at_start = true
	end

	local fx_extension = self._fx_extension
	local special_active = self._inventory_slot_component.special_active
	local sweep_fx_source_name = self._sweep_fx_source_name

	if sweep_fx_source_name then
		local sweep_source = fx_extension:sound_source(sweep_fx_source_name)

		WwiseWorld.set_switch(self._wwise_world, "powered", POWERED_WWISE_SWITCH[special_active], sweep_source)
	end

	local is_heavy = damage_profile.melee_attack_strength == melee_attack_strengths.heavy
	local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.is_chain_action = is_chain_action
		param_table.combo_count = combo_count
		param_table.is_heavy = is_heavy
		param_table.is_weapon_special_active = special_active
		param_table.is_auto_completed = self._auto_completed

		buff_extension:add_proc_event(proc_events.on_sweep_start, param_table)
	end

	self._buff_extension = buff_extension

	local weapon_special_implementation = self._weapon.weapon_special_implementation

	if weapon_special_implementation then
		weapon_special_implementation:on_sweep_action_start(t)
	end

	if self._wieldable_slot_scripts then
		WieldableSlotScripts.on_sweep_start(self._wieldable_slot_scripts, t)
	end
end

ActionSweep._reset_sweep_component = function (self)
	local action_sweep_component = self._action_sweep_component

	action_sweep_component.reference_position = self._first_person_component.position
	action_sweep_component.reference_rotation = self._first_person_component.rotation
	action_sweep_component.sweep_aborted_bit_array = 0
	action_sweep_component.sweep_aborted_t = 0
	action_sweep_component.sweep_aborted_unit = nil
	action_sweep_component.sweep_aborted_actor_index = nil
	action_sweep_component.is_sticky = false
	action_sweep_component.attack_direction = Vector3.zero()
	action_sweep_component.sweep_state = "before_damage_window"
end

ActionSweep._calculate_max_hit_mass = function (self, damage_profile, power_level, charge_level, critical_strike)
	local buff_extension = self._buff_extension
	local fully_charged = self._auto_completed

	if fully_charged then
		local infinite_cleave_keyword = buff_extension:has_keyword(buff_keywords.fully_charged_attacks_infinite_cleave)

		if infinite_cleave_keyword then
			return math.huge
		end
	end

	local infinite_cleave_keyword = buff_extension:has_keyword(buff_keywords.melee_infinite_cleave)

	if infinite_cleave_keyword then
		return math.huge
	end

	local infinite_cleave_critical_strike_keyword = buff_extension:has_keyword(buff_keywords.melee_infinite_cleave_critical_strike)

	if infinite_cleave_critical_strike_keyword and critical_strike then
		return math.huge
	end

	local attack_type = AttackSettings.attack_types.melee
	local player_unit = self._player_unit
	local damage_profile_lerp_values = DamageProfile.lerp_values(damage_profile, player_unit)
	local max_hit_mass_attack, max_hit_mass_impact = DamageProfile.max_hit_mass(damage_profile, power_level, charge_level, damage_profile_lerp_values, critical_strike, player_unit, attack_type)

	return math.max(max_hit_mass_attack, max_hit_mass_impact)
end

ActionSweep.server_correction_occurred = function (self)
	for i = 1, #self._hit_units do
		table.clear(self._hit_units[i])
	end

	self._num_saved_entries = 0
	self._time_before_processing_saved_entries = 0

	local action_settings = self._action_settings
	local power_level = action_settings.power_level or DEFAULT_POWER_LEVEL
	local charge_level = 1
	local damage_profile, damage_profile_special_active = self:_damage_profile(1)

	self._max_hit_mass = self:_calculate_max_hit_mass(damage_profile, power_level, charge_level)
	self._max_hit_mass_special = self:_calculate_max_hit_mass(damage_profile_special_active, power_level, charge_level)
	self._amount_of_mass_hit = 0
	self._target_index = 0
	self._num_hit_enemies = 0
	self._num_killed_enemies = 0
end

ActionSweep.finish = function (self, reason, data, t, time_in_action)
	for i = 1, #self._hit_units do
		table.clear(self._hit_units[i])
	end

	local action_settings = self._action_settings

	if action_settings.activate_special_during_sweep then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false)
	end

	if self._wieldable_slot_scripts then
		WieldableSlotScripts.on_sweep_finish(self._wieldable_slot_scripts)
	end

	local special_active_at_start = self._weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings
	local is_sticky = self:_is_currently_sticky()

	if hit_stickyness_settings and is_sticky then
		self:_stop_hit_stickyness(hit_stickyness_settings, true)
	end

	local action_sweep_component = self._action_sweep_component

	if action_sweep_component.sweep_state == "during_damage_window" then
		self:_exit_damage_window(t, self._num_hit_enemies, self:_any_sweep_aborted())

		if not is_sticky then
			self:_handle_exit_procs()
		end

		action_sweep_component.sweep_state = "after_damage_window"
	end

	local weapon_special_implementation = self._weapon.weapon_special_implementation

	if weapon_special_implementation then
		weapon_special_implementation:on_sweep_action_finish(t, self._num_hit_enemies, self:_any_sweep_aborted())
	end

	self._block_component.is_blocking = false

	ActionSweep.super.finish(self, reason, data, t, time_in_action)
end

ActionSweep.sensitivity_modifier = function (self, t)
	local action_settings = self._action_settings
	local special_active_at_start = self._weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings

	if not hit_stickyness_settings then
		return 1
	end

	if not self:_is_currently_sticky() then
		return 1
	end

	local sensitivity_modifier = hit_stickyness_settings.sensitivity_modifier
	local start_t = self._action_sweep_component.sweep_aborted_t
	local current_t = t - start_t
	local duration = hit_stickyness_settings.duration
	local p = math.min(current_t / duration, 1)

	return math.lerp(sensitivity_modifier, 0.75, p * p)
end

ActionSweep.allow_chain_actions = function (self)
	local is_sticky = self._action_sweep_component.is_sticky
	local action_settings = self._action_settings
	local special_active_at_start = self._weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings
	local disallow_chain_actions = is_sticky and hit_stickyness_settings.disallow_chain_actions

	if disallow_chain_actions then
		return false
	else
		return true
	end
end

ActionSweep.fixed_update = function (self, dt, t, time_in_action)
	local action_settings = self._action_settings

	if self._block_component.is_blocking then
		local is_block_ended = not action_settings.block_duration or time_in_action >= action_settings.block_duration

		if is_block_ended then
			self._block_component.is_blocking = false
		end
	end

	self:_update_sweep(dt, t, time_in_action, action_settings, self._action_sweep_component)
end

ActionSweep._update_sweep = function (self, dt, t, time_in_action, action_settings)
	local time_scale = self._weapon_action_component.time_scale
	local is_within_damage_window, damage_window_t, before_damage_window, damage_window_total_t = self:_is_within_damage_window(time_in_action, action_settings, time_scale)
	local was_within_damage_window, last_damage_window_t = self:_is_within_damage_window(time_in_action - dt, action_settings, time_scale)
	local action_sweep_component = self._action_sweep_component

	if before_damage_window then
		action_sweep_component.reference_position = self._first_person_component.position
		action_sweep_component.reference_rotation = self._first_person_component.rotation
	end

	local is_final_frame = not is_within_damage_window and was_within_damage_window
	local start_reference_pos, start_reference_rot = action_sweep_component.reference_position, action_sweep_component.reference_rotation
	local end_reference_pos, end_reference_rot = self._first_person_component.position, self._first_person_component.rotation
	local should_do_any_overlap = not self:_all_sweeps_aborted() and (is_within_damage_window or was_within_damage_window)

	if should_do_any_overlap then
		local sweep_splines = self._sweep_splines

		for sweep_index = 1, #sweep_splines do
			local sweep_spline = sweep_splines[sweep_index]
			local should_do_overlap = not self:_is_sweep_aborted(sweep_index)

			if should_do_overlap then
				damage_window_t = is_final_frame and 1 or damage_window_t
				action_sweep_component.sweep_state = "during_damage_window"
				last_damage_window_t = was_within_damage_window and last_damage_window_t or 0
				damage_window_t = is_final_frame and 1 or damage_window_t
				action_sweep_component.sweep_state = "during_damage_window"

				local start_position, start_rotation = sweep_spline:position_and_rotation(last_damage_window_t, start_reference_pos, start_reference_rot)
				local end_position, end_rotation = sweep_spline:position_and_rotation(damage_window_t, end_reference_pos, end_reference_rot)

				self:_do_overlap(t, start_position, start_rotation, end_position, end_rotation, is_final_frame, action_settings, sweep_index)
			end
		end

		if is_final_frame or self:_all_sweeps_aborted() then
			self:_exit_damage_window(t, self._num_hit_enemies, self:_any_sweep_aborted())

			if not self:_is_currently_sticky() then
				self:_handle_exit_procs()
			end

			action_sweep_component.sweep_state = "after_damage_window"
		end
	end

	local special_active_at_start = self._weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings

	if hit_stickyness_settings and self:_is_currently_sticky() then
		self:_update_hit_stickyness(dt, t, action_sweep_component, hit_stickyness_settings)
	end

	action_sweep_component.reference_position = end_reference_pos
	action_sweep_component.reference_rotation = end_reference_rot
end

ActionSweep._any_sweep_aborted = function (self)
	local action_sweep_component = self._action_sweep_component

	return action_sweep_component.sweep_aborted_bit_array ~= 0
end

ActionSweep._all_sweeps_aborted = function (self)
	local action_sweep_component = self._action_sweep_component

	return action_sweep_component.sweep_aborted_bit_array == self._all_sweeps_aborted_mask
end

ActionSweep._is_sweep_aborted = function (self, sweep_index)
	local action_sweep_component = self._action_sweep_component
	local bit_array = action_sweep_component.sweep_aborted_bit_array

	return bit.band(bit.rshift(bit_array, sweep_index - 1), 1) == 1
end

ActionSweep._abort_sweep = function (self, sweep_index, t, hit_unit, hit_actor)
	local action_sweep_component = self._action_sweep_component
	local bit_array = action_sweep_component.sweep_aborted_bit_array
	local first_abort = bit_array == 0

	action_sweep_component.sweep_aborted_bit_array = bit.bor(bit_array, bit.lshift(1, sweep_index - 1))

	if first_abort then
		action_sweep_component.sweep_aborted_t = t
		action_sweep_component.sweep_aborted_unit = hit_unit
		action_sweep_component.sweep_aborted_actor_index = HitZone.actor_index(hit_unit, hit_actor)
	end
end

ActionSweep._start_hit_stickyness = function (self, hit_stickyness_settings, t, attack_direction)
	local hit_sticky_duration = hit_stickyness_settings.duration
	local start_anim_event = hit_stickyness_settings.start_anim_event

	if start_anim_event then
		local variable_name = "sticky_time"
		local variable_index = Unit.animation_find_variable(self._first_person_unit, variable_name)

		if variable_index then
			self._animation_extension:anim_event_with_variable_floats_1p(start_anim_event, variable_name, hit_sticky_duration)
			self._animation_extension:anim_event_with_variable_floats(start_anim_event, variable_name, hit_sticky_duration)
		else
			self._animation_extension:anim_event_1p(start_anim_event)
			self._animation_extension:anim_event(start_anim_event)
		end
	end

	local time_left_in_action = Action.time_left(self._weapon_action_component, t)
	local wanted_additional_time = hit_sticky_duration - time_left_in_action

	if wanted_additional_time > 0 then
		self:_increase_action_duration(wanted_additional_time)
	end

	local disallow_dodging = hit_stickyness_settings.disallow_dodging
	local has_dodge_damage_profile = hit_stickyness_settings.damage.dodge_damage_profile

	if disallow_dodging or has_dodge_damage_profile then
		self._movement_state_component.can_jump = false
	end

	local action_sweep_component = self._action_sweep_component

	action_sweep_component.is_sticky = true
	action_sweep_component.attack_direction = attack_direction

	local stick_to_unit = action_sweep_component.sweep_aborted_unit
	local buff_to_add = hit_stickyness_settings.buff_to_add

	if buff_to_add and self._is_server then
		local stick_to_buff_extension = ScriptUnit.has_extension(stick_to_unit, "buff_system")

		if stick_to_buff_extension then
			local attacking_unit = self._player_unit

			stick_to_buff_extension:add_internally_controlled_buff(buff_to_add, t, "owner_unit", attacking_unit)
		end
	end

	self:_add_weapon_blood(stick_to_unit, "full")

	local any_sweep_aborted = self:_any_sweep_aborted()

	self:_exit_damage_window(t, self._num_hit_enemies, any_sweep_aborted)

	if not self:_is_currently_sticky() then
		self:_handle_exit_procs()
	end
end

ActionSweep._stop_hit_stickyness = function (self, hit_stickyness_settings, aborted)
	local stop_anim_event = aborted and hit_stickyness_settings.abort_anim_event or hit_stickyness_settings.stop_anim_event
	local stop_anim_event_3p = aborted and (hit_stickyness_settings.abort_anim_event_3p or hit_stickyness_settings.abort_anim_event) or hit_stickyness_settings.stop_anim_event_3p or stop_anim_event

	if stop_anim_event then
		self._animation_extension:anim_event_1p(stop_anim_event)
		self._animation_extension:anim_event(stop_anim_event_3p)
	end

	self:_handle_exit_procs()

	self._current_sticky_armor_type = nil
	self._action_sweep_component.is_sticky = false
	self._movement_state_component.can_jump = true
end

ActionSweep._is_currently_sticky = function (self)
	return self._action_sweep_component.is_sticky
end

ActionSweep._can_start_stickyness = function (self, hit_stickyness_settings, abort_attack, special_active)
	if not hit_stickyness_settings then
		return false
	end

	if not abort_attack then
		return false
	end

	local always_sticky = hit_stickyness_settings.always_sticky
	local stickyness_is_allowed = always_sticky or special_active

	if not stickyness_is_allowed then
		return false
	end

	local stick_to_unit, stick_to_actor = SweepStickyness.unit_which_aborted_sweep(self._action_sweep_component)

	if not stick_to_unit or not stick_to_actor then
		return false
	end

	local hit_zone_name = HitZone.get_name(stick_to_unit, stick_to_actor)
	local disallowed_hit_zones = hit_stickyness_settings.disallowed_hit_zones

	if disallowed_hit_zones and (not hit_zone_name or table.index_of(disallowed_hit_zones, hit_zone_name) ~= -1) then
		return false
	end

	local unit_data_extension = ScriptUnit.extension(stick_to_unit, "unit_data_system")
	local breed = unit_data_extension:breed()

	if Breed.is_prop(breed) and not breed.tags.objective then
		return false
	end

	local disallowed_armor_types = hit_stickyness_settings.disallowed_armor_types

	if disallowed_armor_types then
		local armor_type = Armor.armor_type(stick_to_unit, breed, hit_zone_name)

		if table.index_of(disallowed_armor_types, armor_type) ~= -1 then
			return false
		end
	end

	return true
end

local stickyness_impact_fx_data = {
	will_be_predicted = true,
	source_parameters = {},
}

ActionSweep._update_hit_stickyness = function (self, dt, t, action_sweep_component, hit_stickyness_settings)
	local is_server = self._is_server
	local stick_to_unit = action_sweep_component.sweep_aborted_unit
	local sticky_target_unit_alive = ALIVE[stick_to_unit]
	local stick_to_position = SweepStickyness.stick_to_position(action_sweep_component) or Unit.world_position(self._first_person_unit, 1)
	local actor_index = action_sweep_component.sweep_aborted_actor_index
	local stick_to_actor

	if sticky_target_unit_alive then
		stick_to_actor = actor_index and Unit.actor(stick_to_unit, actor_index)
	end

	local is_resimulating = self._unit_data_extension.is_resimulating

	self:_handle_stickyness(stick_to_position)

	local start_t = action_sweep_component.sweep_aborted_t
	local damage = hit_stickyness_settings.damage

	if not is_resimulating and damage and stick_to_actor then
		local num_damage_instances_this_frame, is_last_damage_instance, is_first_damage_instance = SweepStickyness.num_damage_instances_this_frame(hit_stickyness_settings, start_t, t)

		if num_damage_instances_this_frame > 0 then
			local normal_damage_profile = damage.damage_profile
			local last_damage_profile = damage.last_damage_profile or normal_damage_profile
			local damage_type = damage.damage_type
			local is_critical_strike = self._critical_strike_component.is_active
			local attacking_unit = self._player.player_unit
			local hit_zone_name = HitZone.get_name(stick_to_unit, stick_to_actor)
			local node_index = Actor.node(stick_to_actor)
			local hit_world_position = Unit.world_position(stick_to_unit, node_index)
			local attack_type = AttackSettings.attack_types.melee
			local fp_position = self._first_person_component.position
			local attack_direction_override = hit_stickyness_settings.damage.attack_direction_override or self._action_settings.attack_direction_override or nil
			local player_rotation = self._first_person_component.rotation
			local attack_direction = action_sweep_component.attack_direction or Vector3.normalize(Vector3.flat(fp_position - hit_world_position))

			if attack_direction_override then
				attack_direction = _calculate_attack_direction(self._action_settings, nil, nil, player_rotation, attack_direction_override, self._uses_matrix_data)
			end

			local action_settings = self._action_settings
			local herding_template = damage.herding_template or action_settings.herding_template
			local wounds_shape

			if is_first_damage_instance or is_last_damage_instance then
				wounds_shape = action_settings.wounds_shape_special_active
			end

			for i = 1, num_damage_instances_this_frame do
				local damage_profile

				if is_last_damage_instance and i == num_damage_instances_this_frame then
					damage_profile = last_damage_profile

					if hit_stickyness_settings.damage_override_anim then
						local damage_override_anim = hit_stickyness_settings.damage_override_anim

						if damage_override_anim then
							self._animation_extension:anim_event_1p(damage_override_anim)
						end
					end
				else
					damage_profile = normal_damage_profile
				end

				local damage_dealt, attack_result, damage_efficiency, _, hit_weakspot = Attack.execute(stick_to_unit, damage_profile, "power_level", DEFAULT_POWER_LEVEL, "target_index", 1, "target_number", 1, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "hit_zone_name", hit_zone_name, "attacking_unit", attacking_unit, "hit_actor", stick_to_actor, "attack_type", attack_type, "herding_template", herding_template, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "item", self._weapon.item, "wounds_shape", wounds_shape)

				if attack_result == attack_results.died then
					self._num_killed_enemies = self._num_killed_enemies + 1
				end

				self._hit_weakspot = self._hit_weakspot or hit_weakspot

				if i == 1 then
					local hit_normal

					ImpactEffect.play(stick_to_unit, stick_to_actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, hit_normal, attack_direction, self._player.player_unit, stickyness_impact_fx_data, nil, nil, damage_efficiency, damage_profile)
				end

				local buff_to_add_tick = hit_stickyness_settings.buff_to_add_tick

				if buff_to_add_tick and is_server then
					local stick_to_buff_extension = ScriptUnit.has_extension(stick_to_unit, "buff_system")

					if stick_to_buff_extension then
						stick_to_buff_extension:add_internally_controlled_buff(buff_to_add_tick, t, "owner_unit", attacking_unit)
					end
				end
			end
		end

		if is_last_damage_instance then
			local buff_to_add_last = hit_stickyness_settings.buff_to_add_last

			if buff_to_add_last and is_server then
				local stick_to_buff_extension = ScriptUnit.has_extension(stick_to_unit, "buff_system")

				if stick_to_buff_extension then
					local attacking_unit = self._player_unit

					stick_to_buff_extension:add_internally_controlled_buff(buff_to_add_last, t, "owner_unit", attacking_unit)
				end
			end
		end
	end

	local character_state_component = self._character_state_component
	local state_name = character_state_component.state_name
	local is_in_dodge_state = state_name == "dodging"
	local is_in_jump_state = state_name == "jumping"
	local state_enter_time = character_state_component.entered_t
	local exit_because_of_state = (is_in_dodge_state or is_in_jump_state) and start_t < state_enter_time
	local player_unit = self._player.player_unit
	local is_in_stealth = self._buff_extension:has_keyword(buff_keywords.invisible)
	local sticky_t = t - start_t
	local duration = hit_stickyness_settings.duration
	local extra_duration = hit_stickyness_settings.extra_duration or 0
	local min_sticky_time = hit_stickyness_settings.min_sticky_time or 0.5
	local is_time_up = sticky_target_unit_alive and sticky_t >= duration + extra_duration
	local is_target_dead = not sticky_target_unit_alive and sticky_t >= duration * min_sticky_time

	if is_time_up or is_target_dead or is_in_stealth and sticky_t > 0.05 or exit_because_of_state then
		local dodge_exit_damage_profile = damage.dodge_damage_profile

		if dodge_exit_damage_profile and exit_because_of_state and is_in_dodge_state and stick_to_unit and stick_to_actor then
			if not is_resimulating then
				local damage_type = damage.damage_type
				local is_critical_strike = self._critical_strike_component.is_active
				local hit_zone_name = HitZone.get_name(stick_to_unit, stick_to_actor)
				local node_index = Actor.node(stick_to_actor)
				local hit_world_position = Unit.world_position(stick_to_unit, node_index)
				local attack_type = AttackSettings.attack_types.melee
				local action_settings = self._action_settings
				local wounds_shape = action_settings.wounds_shape_special_active
				local player_rotation = self._first_person_component.rotation
				local attack_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(player_rotation)))
				local damage_dealt, attack_result, damage_efficiency, _, _ = Attack.execute(stick_to_unit, damage.dodge_damage_profile, "power_level", DEFAULT_POWER_LEVEL, "target_index", 1, "target_number", 1, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "hit_zone_name", hit_zone_name, "attacking_unit", player_unit, "hit_actor", stick_to_actor, "attack_type", attack_type, "herding_template", nil, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "item", self._weapon.item, "wounds_shape", wounds_shape)
				local hit_normal

				ImpactEffect.play(stick_to_unit, stick_to_actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, hit_normal, attack_direction, player_unit, stickyness_impact_fx_data, nil, nil, damage_efficiency, damage.dodge_damage_profile)
			end

			local stamina_drain_percentage = hit_stickyness_settings.dodge_stamina_drain_percentage or 0.6

			Stamina.drain_pecentage_of_base_stamina(player_unit, stamina_drain_percentage, t)
		end

		self:_stop_hit_stickyness(hit_stickyness_settings, exit_because_of_state)
	end
end

ActionSweep._handle_stickyness = function (self, stick_to_position)
	local first_person_unit = self._first_person_unit
	local fp_position = Unit.world_position(first_person_unit, 1)
	local stuck_direction = Vector3.normalize(stick_to_position - fp_position)
	local rot = Unit.local_rotation(first_person_unit, 1)
	local up_dot, right_dot = _dot(stuck_direction, rot)

	up_dot = math.clamp(up_dot * -1, -1, 1)
	right_dot = math.clamp(right_dot * -1, -1, 1)

	local hit_stop_delta_x = Unit.animation_find_variable(first_person_unit, "hit_stop_delta_x")

	if hit_stop_delta_x then
		Unit.animation_set_variable(first_person_unit, hit_stop_delta_x, right_dot)
	end

	local hit_stop_delta_y = Unit.animation_find_variable(first_person_unit, "hit_stop_delta_y")

	if hit_stop_delta_y then
		Unit.animation_set_variable(first_person_unit, hit_stop_delta_y, up_dot)
	end
end

ActionSweep._is_within_damage_window = function (self, time_in_action, action_settings, time_scale)
	local damage_window_start = action_settings.damage_window_start
	local damage_window_end = action_settings.damage_window_end

	if not damage_window_start and not damage_window_end then
		Log.debug("ActionSweep", "No damage window specified in action, skipping damage.")

		return false
	end

	local action_time_offset = action_settings.action_time_offset or 0

	damage_window_start = damage_window_start / time_scale
	damage_window_end = damage_window_end / time_scale
	action_time_offset = action_time_offset / time_scale
	time_in_action = time_in_action + action_time_offset

	local after_start = damage_window_start <= time_in_action
	local before_end = time_in_action <= damage_window_end
	local in_damage_window = after_start and before_end
	local damage_window_t = 0
	local before_damage_window = false
	local damage_window_max = damage_window_end - damage_window_start

	if in_damage_window then
		local current_time = time_in_action - damage_window_start

		damage_window_t = current_time / damage_window_max
	else
		before_damage_window = time_in_action < damage_window_start
	end

	local damage_window_total_t = damage_window_end - damage_window_start

	return in_damage_window, damage_window_t, before_damage_window, damage_window_total_t
end

ActionSweep._exit_damage_window = function (self, t, num_hit_enemies, aborted)
	local weapon_special_implementation = self._weapon.weapon_special_implementation

	if weapon_special_implementation then
		weapon_special_implementation:on_exit_damage_window(t, num_hit_enemies, aborted)
	end

	if self._wieldable_slot_scripts then
		WieldableSlotScripts.on_exit_damage_window(self._wieldable_slot_scripts)
	end
end

ActionSweep._handle_exit_procs = function (self)
	local buff_extension = self._buff_extension
	local damage_profile = self:_hit_mass_damage_profile()
	local is_heavy = damage_profile.melee_attack_strength == melee_attack_strengths.heavy
	local num_hit_enemies = self._num_hit_enemies
	local num_killed_enemies = self._num_killed_enemies
	local hit_weakspot = self._hit_weakspot
	local combo_count = self._combo_count
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.num_hit_units = num_hit_enemies
		param_table.hit_weakspot = hit_weakspot
		param_table.is_heavy = is_heavy
		param_table.combo_count = combo_count

		buff_extension:add_proc_event(proc_events.on_sweep_finish, param_table)
	end

	Managers.stats:record_private("hook_sweep_finished", self._player, num_hit_enemies, num_killed_enemies, combo_count, hit_weakspot, is_heavy)
end

ActionSweep._do_overlap = function (self, t, start_position, start_rotation, end_position, end_rotation, is_final_frame, action_settings, sweep_index)
	PhysicsWorld.start_reusing_sweep_tables()

	local use_sphere_sweep = action_settings.use_sphere_sweep
	local sweep_results, num_sweep_results

	if use_sphere_sweep then
		sweep_results, num_sweep_results = self:_run_sphere_sweeps(start_position, end_position, action_settings)
	else
		sweep_results, num_sweep_results = self:_run_sweeps(start_position, start_rotation, end_position, end_rotation, action_settings)
	end

	local player_rotation = self._first_person_component.rotation
	local attack_direction_override = action_settings.attack_direction_override
	local attack_direction = _calculate_attack_direction(action_settings, start_rotation, end_rotation, player_rotation, attack_direction_override, self._uses_matrix_data)
	local should_save_sweeps = self:_should_save_sweeps(action_settings, t, is_final_frame, num_sweep_results, self._num_saved_entries)

	if should_save_sweeps then
		self:_save_sweep_results(sweep_results, num_sweep_results, t, action_settings, self._num_saved_entries)
	else
		local num_saved_entries = self._num_saved_entries

		if num_saved_entries > 0 then
			sweep_results, num_sweep_results = self:_merge_saved_entries(sweep_results, num_sweep_results, self._saved_entries, num_saved_entries)
		end

		if num_sweep_results > 0 then
			self:_process_sweep_results(t, sweep_results, num_sweep_results, action_settings, attack_direction, sweep_index)
		end
	end

	PhysicsWorld.stop_reusing_sweep_tables()
end

ActionSweep._should_save_sweeps = function (self, action_settings, t, is_final_frame, num_new_entries, num_saved_entries)
	local num_frames_before_process = action_settings.num_frames_before_process

	if num_frames_before_process and num_frames_before_process > 0 then
		if is_final_frame then
			return false
		end

		if num_saved_entries > 0 and t >= self._time_before_processing_saved_entries then
			return false
		end

		local max_num_saved_entries = action_settings.max_num_saved_entries

		if max_num_saved_entries <= num_saved_entries + num_new_entries then
			return false
		end

		return true
	else
		return false
	end
end

ActionSweep._save_sweep_results = function (self, sweep_results, num_sweep_results, t, action_settings, num_saved_entries)
	local saved_entries = self._saved_entries

	if num_saved_entries == 0 then
		local num_frames_before_process = action_settings.num_frames_before_process

		self._time_before_processing_saved_entries = t + num_frames_before_process * Managers.state.game_session.fixed_time_step
	end

	for i = 1, num_sweep_results do
		local result = sweep_results[i]
		local hit_actor = result.actor
		local hit_position = result.position
		local hit_normal = result.normal
		local hit_distance = result.distance

		num_saved_entries = num_saved_entries + 1

		local entry = saved_entries[num_saved_entries]

		entry.hit_actor:store(hit_actor)
		entry.hit_position:store(hit_position)
		entry.hit_normal:store(hit_normal)

		entry.hit_distance = hit_distance
	end

	self._num_saved_entries = num_saved_entries
end

local merged_results = {}

ActionSweep._merge_saved_entries = function (self, sweep_results, num_sweep_results, saved_entries, num_saved_entries)
	table.clear(merged_results)

	local num_merged_results = 0

	for i = 1, num_saved_entries do
		repeat
			local saved_entry = saved_entries[i]
			local actor = saved_entry.hit_actor:unbox()

			if not actor then
				break
			end

			local hit_position = saved_entry.hit_position:unbox()
			local hit_normal = saved_entry.hit_normal:unbox()
			local hit_distance = saved_entry.hit_distance

			saved_entry.actor = actor
			saved_entry.position = hit_position
			saved_entry.normal = hit_normal
			saved_entry.distance = hit_distance
			num_merged_results = num_merged_results + 1
			merged_results[num_merged_results] = saved_entry
		until true
	end

	for i = 1, num_sweep_results do
		num_merged_results = num_merged_results + 1
		merged_results[num_merged_results] = sweep_results[i]
	end

	return merged_results, num_merged_results
end

ActionSweep._process_sweep_results = function (self, t, sweep_results, num_sweep_results, action_settings, attack_direction, sweep_index)
	local hit_units = self._hit_units[sweep_index]
	local unit_best_result, actor_to_unit = self:_pick_best_sweep_result_per_unit(sweep_results, num_sweep_results, hit_units)
	local ordered_units = self:_order_by_significance(unit_best_result, sweep_results, actor_to_unit, action_settings)
	local num_ordered_units = #ordered_units
	local already_partially_aborted = self:_any_sweep_aborted()
	local abort_attack, armor_aborted_attack = false, false

	for i = 1, num_ordered_units do
		local result = ordered_units[i]
		local hit_actor = result.actor
		local hit_unit = actor_to_unit[hit_actor]
		local hit_position = result.position
		local hit_normal = result.normal
		local hit_zone_name
		local hit_zone = HitZone.get(hit_unit, hit_actor)

		if hit_zone then
			hit_zone_name = hit_zone.name
		end

		abort_attack, armor_aborted_attack = self:_process_hit(t, hit_unit, hit_actor, hit_units, action_settings, hit_position, attack_direction, hit_zone_name, hit_normal, sweep_index)

		if abort_attack then
			self:_abort_sweep(sweep_index, t, hit_unit, hit_actor)

			break
		end
	end

	local special_active_at_start = self._weapon_action_component.special_active_at_start
	local hit_stickyness_settings = special_active_at_start and action_settings.hit_stickyness_settings_special_active or action_settings.hit_stickyness_settings

	if self:_can_start_stickyness(hit_stickyness_settings, abort_attack or already_partially_aborted, special_active_at_start) then
		self:_start_hit_stickyness(hit_stickyness_settings, t, attack_direction)
	elseif not already_partially_aborted then
		self:_play_hit_animations(action_settings, abort_attack, armor_aborted_attack, special_active_at_start)

		if self._wieldable_slot_scripts then
			WieldableSlotScripts.on_sweep_hit(self._wieldable_slot_scripts)
		end
	end
end

local unit_best_result = {}
local actor_to_unit = {}

ActionSweep._pick_best_sweep_result_per_unit = function (self, sweep_results, num_sweep_results, hit_units)
	table.clear(unit_best_result)
	table.clear(actor_to_unit)

	local first_person_extension, action_settings = self._first_person_extension, self._action_settings
	local default_hit_zone_priority = ActionSweepSettings.default_hit_zone_priority
	local hit_zone_priority = action_settings.hit_zone_priority or default_hit_zone_priority
	local hit_zone_priority_functions = ActionSweepSettings.hit_zone_priority_functions
	local player_position = POSITION_LOOKUP[self._player_unit]
	local ALIVE = ALIVE

	for i = 1, num_sweep_results do
		repeat
			local result = sweep_results[i]
			local hit_actor = result.actor
			local hit_unit = Actor.unit(hit_actor)
			local hit_position = result.position

			if hit_units[hit_unit] then
				break
			end

			if not ALIVE[hit_unit] then
				break
			end

			local in_view = first_person_extension:is_within_default_view(hit_position)

			if not in_view then
				break
			end

			actor_to_unit[hit_actor] = hit_unit

			local previous_result_id = unit_best_result[hit_unit]

			if previous_result_id then
				do
					local hit_zone = HitZone.get(hit_unit, hit_actor)

					if not hit_zone then
						break
					end

					local new_hit_zone_name = hit_zone.name
					local new_hit_zone_prio, new_hit_zone_priority_function = hit_zone_priority[new_hit_zone_name], hit_zone_priority_functions[new_hit_zone_name]

					if new_hit_zone_priority_function then
						new_hit_zone_prio = new_hit_zone_priority_function(hit_unit, player_position, new_hit_zone_prio)
					end

					local previous_result = sweep_results[previous_result_id]
					local prev_actor = previous_result.actor
					local prev_hit_zone_prio = math.huge
					local prev_hit_zone = HitZone.get(hit_unit, prev_actor)

					if prev_hit_zone then
						local prev_hit_zone_name = prev_hit_zone.name

						prev_hit_zone_prio = hit_zone_priority[prev_hit_zone_name]

						local prev_hit_zone_priority_function = hit_zone_priority_functions[prev_hit_zone_name]

						if prev_hit_zone_priority_function then
							prev_hit_zone_prio = prev_hit_zone_priority_function(hit_unit, player_position, prev_hit_zone_prio)
						end
					end

					local disregarded_result = result

					if new_hit_zone_prio < prev_hit_zone_prio then
						unit_best_result[hit_unit] = i
						disregarded_result = previous_result
					end
				end

				break
			end

			unit_best_result[hit_unit] = i
		until true
	end

	return unit_best_result, actor_to_unit
end

local ordered_unit_table = {}

ActionSweep._order_by_significance = function (self, sweep_units, sweep_results, actor_to_unit_map, action_settings)
	table.clear(ordered_unit_table)

	local num_units = 0

	for unit, entry_id in pairs(sweep_units) do
		num_units = num_units + 1
		ordered_unit_table[num_units] = sweep_results[entry_id]
	end

	if action_settings.context_aware_order then
		ordered_unit_table = self:_context_aware_sweep_order(ordered_unit_table, sweep_units, actor_to_unit_map)
	else
		ordered_unit_table = self:_sweep_order(ordered_unit_table, sweep_units, actor_to_unit_map)
	end

	return ordered_unit_table
end

ActionSweep._sweep_order = function (self, unit_table, sweep_units, actor_to_unit_map)
	local function sort_func(entry_1, entry_2)
		local unit_1 = actor_to_unit_map[entry_1.actor]
		local unit_2 = actor_to_unit_map[entry_2.actor]
		local entry_id_1 = sweep_units[unit_1]
		local entry_id_2 = sweep_units[unit_2]

		return entry_id_1 < entry_id_2
	end

	table.sort(unit_table, sort_func)

	return unit_table
end

local unit_utility = {}

ActionSweep._context_aware_sweep_order = function (self, unit_table, sweep_units, actor_to_unit_map)
	table.clear(unit_utility)

	local first_person_component = self._first_person_component
	local fp_position = first_person_component.position
	local fp_rotation = first_person_component.rotation
	local fp_right = Quaternion.right(fp_rotation)
	local fp_up = Quaternion.up(fp_rotation)

	for i = 1, #unit_table do
		local result = unit_table[i]
		local hit_actor = result.actor
		local hit_position = result.position
		local distance = Vector3.length_squared(hit_position - fp_position)
		local unit = actor_to_unit_map[hit_actor]
		local _, half_extents = Unit.box(unit)
		local half_width = half_extents.x
		local half_height = half_extents.z
		local unit_center_pos = Unit.world_position(unit, 1) + Vector3(0, 0, half_height)
		local hit_offset = hit_position + unit_center_pos
		local x_diff = math.abs(Vector3.dot(hit_offset, fp_right))
		local y_diff = math.abs(Vector3.dot(hit_offset, fp_up))
		local epsilon = 0.01
		local direct_hit = x_diff <= half_width + epsilon and y_diff <= half_height + epsilon
		local utility

		if direct_hit then
			utility = math.huge
		else
			local angle_width = math.atan(half_width / distance)
			local angle_height = math.atan(half_height / distance)
			local angle_x_diff = math.atan(x_diff / distance)
			local angle_y_diff = math.atan(y_diff / distance)
			local x_offset = math.max(angle_x_diff - angle_width, epsilon) / math.log(angle_width)
			local y_offset = math.max(angle_y_diff - angle_height, epsilon) / math.log(angle_width)

			utility = 1 / (x_offset * y_offset)
		end

		unit_utility[unit] = utility
	end

	local function sort_func(entry_1, entry_2)
		local unit_1 = actor_to_unit_map[entry_1.actor]
		local unit_2 = actor_to_unit_map[entry_2.actor]
		local utility_1 = unit_utility[unit_1]
		local utility_2 = unit_utility[unit_2]

		return utility_1 < utility_2
	end

	table.sort(unit_table, sort_func)

	return unit_table
end

ActionSweep._current_max_hit_mass = function (self, weapon_action_component)
	if weapon_action_component.special_active_at_start then
		return self._max_hit_mass_special
	else
		return self._max_hit_mass
	end
end

local attack_intensities = {
	ranged = 15,
}

ActionSweep._process_hit = function (self, t, hit_unit, hit_actor, hit_units, action_settings, hit_position, attack_direction, hit_zone_name_or_nil, hit_normal, sweep_index)
	hit_units[hit_unit] = true

	local critical_strike_component = self._critical_strike_component
	local weapon = self._weapon
	local is_server = self._is_server
	local target_index = self._target_index
	local num_hit_enemies = self._num_hit_enemies
	local player_unit = self._player_unit
	local weapon_special_implementation = self._weapon.weapon_special_implementation
	local wielded_slot = self._inventory_component.wielded_slot
	local current_amount_of_mass_hit = self._amount_of_mass_hit
	local buff_extension = self._buff_extension
	local weapon_action_component = self._weapon_action_component
	local is_special_active = weapon_action_component.special_active_at_start
	local is_critical_strike = critical_strike_component.is_active
	local hit_unit_data_extension = ScriptUnit.has_extension(hit_unit, "unit_data_system")
	local target_breed_or_nil = hit_unit_data_extension and hit_unit_data_extension:breed()
	local target_is_alive = HEALTH_ALIVE[hit_unit]
	local target_is_level_unit = Unit.level(hit_unit) ~= nil
	local target_is_character = Breed.is_character(target_breed_or_nil) or Breed.count_as_character(target_breed_or_nil)
	local target_is_environment = not target_is_character

	target_index = target_index + 1
	num_hit_enemies = num_hit_enemies + 1

	local use_reduced_hit_mass = buff_extension:has_keyword(buff_keywords.use_reduced_hit_mass)
	local ignore_armor_aborts_attack = is_critical_strike and buff_extension:has_keyword(buff_keywords.ignore_armor_aborts_attack_critical_strike) or buff_extension:has_keyword(buff_keywords.ignore_armor_aborts_attack) or use_reduced_hit_mass
	local attack_type = AttackSettings.attack_types.melee
	local hit_weakspot = Weakspot.hit_weakspot(target_breed_or_nil, hit_zone_name_or_nil, player_unit)
	local target_hit_mass = HitMass.target_hit_mass(player_unit, hit_unit, hit_weakspot, is_critical_strike, attack_type)
	local target_armor = Armor.armor_type(hit_unit, target_breed_or_nil, hit_zone_name_or_nil, attack_type)
	local action_armor_hit_mass_mod = action_settings.action_armor_hit_mass_mod and action_settings.action_armor_hit_mass_mod[target_armor]
	local amount_of_mass_hit
	local is_ogryn = target_breed_or_nil and target_breed_or_nil.tags and target_breed_or_nil.tags.ogryn
	local melee_infinite_cleave_on_headshot_non_ogryn = buff_extension:has_keyword(buff_keywords.melee_infinite_cleave_on_headshot) and not is_ogryn

	amount_of_mass_hit = current_amount_of_mass_hit + target_hit_mass * (action_armor_hit_mass_mod or 1)

	local aim_assist_ramp_template = action_settings.aim_assist_ramp_template

	if amount_of_mass_hit > 0 and aim_assist_ramp_template and aim_assist_ramp_template.reset_on_attack then
		AimAssist.reset_ramp_multiplier(self._aim_assist_ramp_component)
	end

	local max_hit_mass = self:_current_max_hit_mass(weapon_action_component)
	local hit_ragdoll = Health.is_ragdolled(hit_unit)
	local armor_aborts_attack = not ignore_armor_aborts_attack and not hit_ragdoll and target_is_alive and Armor.aborts_attack(hit_unit, target_breed_or_nil, hit_zone_name_or_nil)
	local breed_aborts_attack = not hit_ragdoll and target_is_alive and _breed_aborts_attack(action_settings, is_special_active, target_breed_or_nil)
	local max_mass_hit = max_hit_mass <= amount_of_mass_hit
	local abort_attack = max_mass_hit or armor_aborts_attack or breed_aborts_attack
	local damage_profile, special_damage_profile, damage_profile_on_abort, special_damage_profile_on_abort = self:_damage_profile(sweep_index)
	local damage_type, damage_type_special_active, damage_type_on_abort, damage_type_special_active_on_abort = self:_damage_type(sweep_index)

	if is_special_active then
		damage_profile = abort_attack and special_damage_profile_on_abort or special_damage_profile
		damage_type = abort_attack and damage_type_special_active_on_abort or damage_type_special_active
	else
		damage_profile = abort_attack and damage_profile_on_abort or damage_profile
		damage_type = abort_attack and damage_type_on_abort or damage_type
	end

	if type(damage_type) == "table" then
		damage_type = damage_type[target_index] or damage_type.default
	end

	local damage, result, damage_efficiency, stagger_result

	if not self._unit_data_extension.is_resimulating then
		local is_damagable = Health.is_damagable(hit_unit)
		local target_is_hazard_prop, hazard_prop_is_active = HazardProp.status(hit_unit)
		local deal_damage = is_damagable and (not target_is_hazard_prop or target_is_hazard_prop and hazard_prop_is_active)

		if deal_damage then
			damage, result, damage_efficiency, stagger_result, hit_weakspot = self:_do_damage_to_unit(damage_profile, hit_unit, hit_actor, hit_position, hit_normal, attack_direction, target_index, num_hit_enemies, hit_zone_name_or_nil, abort_attack, amount_of_mass_hit, damage_type, is_special_active)
		elseif hit_ragdoll then
			local herding_template = action_settings.herding_template

			MinionDeath.attack_ragdoll(hit_unit, attack_direction, damage_profile, damage_type, hit_zone_name_or_nil, hit_position, player_unit, hit_actor, herding_template, is_critical_strike)
		end

		if not target_is_environment then
			self:_play_hit_effects(hit_unit, damage_profile, hit_position, attack_direction, damage, result, damage_efficiency)
		end
	end

	if self._num_killed_enemies <= 2 and result == "died" and hit_weakspot and melee_infinite_cleave_on_headshot_non_ogryn then
		amount_of_mass_hit = current_amount_of_mass_hit
		abort_attack = false
	elseif target_is_character and target_is_alive then
		self._target_index = target_index
	end

	if target_is_character and target_is_alive then
		self._num_hit_enemies = num_hit_enemies
	end

	if target_is_alive then
		self._hit_enemies = true
	end

	if is_server and not hit_ragdoll then
		AttackIntensity.add_intensity(player_unit, attack_intensities)
	end

	if weapon_special_implementation then
		weapon_special_implementation:process_hit(t, weapon, action_settings, num_hit_enemies, target_is_alive, hit_unit, damage, result, damage_efficiency, stagger_result, hit_position, attack_direction, abort_attack, wielded_slot, damage_profile)
	end

	local weapon_template = self._weapon_template
	local weapon_special_tweak_data = weapon_template and weapon_template.weapon_special_tweak_data
	local weapon_special_extra_time = weapon_special_tweak_data and weapon_special_tweak_data.special_active_hit_extra_time

	if is_special_active and weapon_special_extra_time then
		self:_increase_action_duration(weapon_special_extra_time)
	end

	self:_add_weapon_blood(hit_unit, "default")

	if target_is_character and target_is_alive and result == attack_results.died then
		self._num_killed_enemies = self._num_killed_enemies + 1
	end

	self._amount_of_mass_hit = amount_of_mass_hit
	self._hit_weakspot = self._hit_weakspot or hit_weakspot

	return abort_attack, armor_aborts_attack
end

local impact_fx_data = {
	will_be_predicted = true,
	source_parameters = {
		hit_mass_percentage = 0,
		num_melee_hits = 0,
	},
}

ActionSweep._do_damage_to_unit = function (self, damage_profile, hit_unit, hit_actor, hit_position, hit_normal, attack_direction, target_index, num_hit_enemies, hit_zone_name_or_nil, abort_attack, amount_of_mass_hit, damage_type, is_special_active)
	local power_level = self._action_settings.power_level or DEFAULT_POWER_LEVEL
	local player_unit = self._player_unit
	local instakill = false
	local source_parameters = impact_fx_data.source_parameters
	local max_hit_mass = self:_current_max_hit_mass(self._weapon_action_component)
	local hit_mass_percentage = max_hit_mass == 0 and 1 or 1 - math.clamp01(amount_of_mass_hit / max_hit_mass)

	source_parameters.hit_mass_percentage = hit_mass_percentage
	source_parameters.num_melee_hits = math.min(target_index, 10)

	local action_settings = self._action_settings
	local herding_template = action_settings.herding_template
	local is_critical_strike = self._critical_strike_component.is_active
	local auto_completed_action = self._auto_completed
	local wounds_shape

	if is_special_active then
		wounds_shape = action_settings.wounds_shape_special_active
	else
		wounds_shape = action_settings.wounds_shape
	end

	local attack_type = AttackSettings.attack_types.melee
	local damage, result, damage_efficiency, stagger_result, hit_weakspot = Attack.execute(hit_unit, damage_profile, "target_index", target_index, "target_number", num_hit_enemies, "power_level", power_level, "hit_world_position", hit_position, "attack_direction", attack_direction, "hit_zone_name", hit_zone_name_or_nil, "instakill", instakill, "attacking_unit", player_unit, "hit_actor", hit_actor, "attack_type", attack_type, "herding_template", herding_template, "damage_type", damage_type, "is_critical_strike", is_critical_strike, "auto_completed_action", auto_completed_action, "item", self._weapon.item, "wounds_shape", wounds_shape)

	ImpactEffect.play(hit_unit, hit_actor, damage, damage_type, hit_zone_name_or_nil, result, hit_position, hit_normal, attack_direction, player_unit, impact_fx_data, abort_attack, attack_type, damage_efficiency, damage_profile)

	return damage, result, damage_efficiency, stagger_result, hit_weakspot
end

ActionSweep._modify_sweep_position = function (self, position, rotation, weapon_half_extents, action_settings)
	local dir, distance

	if self._uses_matrix_data then
		distance = weapon_half_extents.z
		dir = Quaternion.up(rotation)
	else
		distance = weapon_half_extents.y
		dir = Quaternion.forward(rotation)
	end

	return position + dir * distance
end

ActionSweep._run_sphere_sweeps = function (self, start_position, end_position, action_settings)
	local radius = action_settings.sphere_radius
	local max_hits = 20
	local collision_filter = "filter_player_character_melee_sweep"
	local results = PhysicsWorld.linear_sphere_sweep(self._physics_world, start_position, end_position, radius, max_hits, "collision_filter", collision_filter, "report_initial_overlap")
	local num_results = 0

	if results then
		num_results = #results
	end

	return results, num_results
end

local SWEEP_RESULTS = {}

ActionSweep._run_sweeps = function (self, start_position, start_rotation, end_position, end_rotation, action_settings)
	local weapon_half_extents = self:_weapon_half_extents(self._weapon_template, action_settings)
	local weapon_half_length = weapon_half_extents.z
	local modified_start_position = self:_modify_sweep_position(start_position, start_rotation, weapon_half_extents, action_settings)
	local modified_end_position = self:_modify_sweep_position(end_position, end_rotation, weapon_half_extents, action_settings)
	local weapon_cross_section = Vector3(weapon_half_extents.x, weapon_half_extents.y, 0.0001)
	local collision_filter = "filter_player_character_melee_sweep"
	local physics_world = self._physics_world
	local start_rotation_up_dir = Quaternion.up(start_rotation)
	local sweep_1_start = modified_start_position - start_rotation_up_dir * weapon_half_length
	local sweep_1_end = modified_start_position + start_rotation_up_dir * weapon_half_length
	local sweep_1_extents = weapon_cross_section
	local sweep_1_rot = start_rotation
	local max_num_hits1 = 5
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local sweep_results1 = PhysicsWorld.linear_obb_sweep(physics_world, sweep_1_start, sweep_1_end, sweep_1_extents, sweep_1_rot, max_num_hits1, "collision_filter", collision_filter, "rewind_ms", rewind_ms, "report_initial_overlap")
	local sweep_2_start = modified_start_position
	local sweep_2_end = modified_end_position
	local sweep_2_extents = weapon_half_extents
	local sweep_2_rot = start_rotation
	local max_num_hits2 = 20
	local sweep_results2 = PhysicsWorld.linear_obb_sweep(physics_world, sweep_2_start, sweep_2_end, sweep_2_extents, sweep_2_rot, max_num_hits2, "collision_filter", collision_filter, "rewind_ms", rewind_ms, "report_initial_overlap")
	local sweep_3_start = modified_start_position
	local sweep_3_end = modified_end_position
	local sweep_3_extents = weapon_half_extents
	local sweep_3_rot = end_rotation
	local max_num_hits3 = 20
	local sweep_results3 = PhysicsWorld.linear_obb_sweep(physics_world, sweep_3_start, sweep_3_end, sweep_3_extents, sweep_3_rot, max_num_hits3, "collision_filter", collision_filter, "rewind_ms", rewind_ms, "report_initial_overlap")
	local num_results1 = 0
	local num_results2 = 0
	local num_results3 = 0

	if sweep_results1 then
		num_results1 = #sweep_results1

		for i = 1, num_results1 do
			SWEEP_RESULTS[i] = sweep_results1[i]
		end
	end

	if sweep_results2 then
		for i = 1, #sweep_results2 do
			local info = sweep_results2[i]
			local this_actor = info.actor
			local found

			for j = 1, num_results1 do
				if SWEEP_RESULTS[j].actor == this_actor then
					found = true
				end
			end

			if not found then
				num_results2 = num_results2 + 1
				SWEEP_RESULTS[num_results1 + num_results2] = info
			end
		end
	end

	if sweep_results3 then
		for i = 1, #sweep_results3 do
			local info = sweep_results3[i]
			local this_actor = info.actor
			local found

			for j = 1, num_results1 + num_results2 do
				if SWEEP_RESULTS[j].actor == this_actor then
					found = true
				end
			end

			if not found then
				num_results3 = num_results3 + 1
				SWEEP_RESULTS[num_results1 + num_results2 + num_results3] = info
			end
		end
	end

	local num_results = num_results1 + num_results2 + num_results3

	for i = num_results + 1, #SWEEP_RESULTS do
		SWEEP_RESULTS[i] = nil
	end

	return SWEEP_RESULTS, num_results
end

ActionSweep._weapon_half_extents = function (self, weapon_template, action_settings)
	local width_mod = action_settings.width_mod and action_settings.width_mod * ActionSweepSettings.sweep_width_mod or ActionSweepSettings.sweep_width_mod
	local height_mod = action_settings.height_mod and action_settings.height_mod * ActionSweepSettings.sweep_height_mod or ActionSweepSettings.sweep_height_mod
	local range_mod = action_settings.range_mod and action_settings.range_mod * ActionSweepSettings.sweep_range_mod or ActionSweepSettings.sweep_range_mod
	local weapon_box = action_settings.weapon_box or weapon_template.weapon_box
	local _, weapon_half_extents = nil, Vector3(weapon_box[1], weapon_box[2], weapon_box[3])

	if self._uses_matrix_data then
		weapon_half_extents.x = weapon_half_extents.x * width_mod
		weapon_half_extents.y = weapon_half_extents.y * height_mod
		weapon_half_extents.z = weapon_half_extents.z * range_mod
	else
		weapon_half_extents.x = weapon_half_extents.x * width_mod
		weapon_half_extents.y = weapon_half_extents.y * range_mod
		weapon_half_extents.z = weapon_half_extents.z * height_mod
	end

	return weapon_half_extents
end

ActionSweep._play_hit_animations = function (self, action_settings, abort_attack, armor_aborts_attack, special_active)
	local first_person_hit_anim, third_person_hit_anim

	if special_active and action_settings.no_hit_stop_on_active then
		return
	end

	if abort_attack and special_active and armor_aborts_attack then
		first_person_hit_anim = action_settings.special_active_hit_stop_armor_anim or action_settings.hit_stop_armor_anim or action_settings.special_active_hit_stop_anim or action_settings.hit_stop_anim
		third_person_hit_anim = action_settings.special_active_hit_stop_armor_anim_3p or action_settings.hit_stop_armor_anim or action_settings.special_active_hit_stop_anim_3p or action_settings.hit_stop_anim
	elseif abort_attack and special_active then
		first_person_hit_anim = action_settings.special_active_hit_stop_anim or action_settings.hit_stop_anim
		third_person_hit_anim = action_settings.special_active_hit_stop_anim_3p or action_settings.hit_stop_anim
	elseif armor_aborts_attack then
		first_person_hit_anim = action_settings.hit_armor_anim
		third_person_hit_anim = action_settings.hit_stop_anim
	elseif abort_attack then
		first_person_hit_anim = action_settings.first_person_hit_stop_anim or action_settings.hit_stop_anim
		third_person_hit_anim = action_settings.hit_stop_anim
	else
		first_person_hit_anim = action_settings.first_person_hit_anim
	end

	local anim_ext = self._animation_extension

	if first_person_hit_anim then
		anim_ext:anim_event_1p(first_person_hit_anim)
	end

	if third_person_hit_anim then
		anim_ext:anim_event(third_person_hit_anim)
	end
end

local external_properties = {}

ActionSweep._play_hit_effects = function (self, hit_unit, damage_profile, hit_position, attack_direction, damage, result, damage_efficiency)
	local is_heavy = damage_profile.melee_attack_strength == melee_attack_strengths.heavy
	local sweep_hit_alias = is_heavy and "melee_heavy_sweep_hit" or "melee_sweep_hit"
	local crit_hit_alias = is_heavy and "melee_heavy_sweep_hit_crit" or "melee_sweep_hit_crit"
	local sync_to_clients = false
	local sweep_fx_source_name = self._sweep_fx_source_name

	if sweep_fx_source_name then
		table.clear(external_properties)

		external_properties.is_critical_strike = self._critical_strike_component.is_active and "true" or "false"
		external_properties.special_active = self._weapon_action_component.special_active_at_start and "true" or "false"

		self._fx_extension:trigger_gear_wwise_event_with_source(sweep_hit_alias, external_properties, sweep_fx_source_name, sync_to_clients, false)
		self._fx_extension:trigger_gear_wwise_event_with_source(crit_hit_alias, external_properties, sweep_fx_source_name, sync_to_clients, false)
	end

	if damage and damage > 0 and not Breed.is_objective_prop(Breed.unit_breed_or_nil(hit_unit)) then
		Managers.state.blood:play_screen_space_blood(self._fx_extension)
	end
end

ActionSweep._damage_profile = function (self, sweep_index)
	local damage_profile, special_damage_profile, damage_profile_on_abort, special_damage_profile_on_abort = Action.damage_template(self._action_settings, sweep_index)

	special_damage_profile = special_damage_profile or damage_profile
	damage_profile_on_abort = damage_profile_on_abort or damage_profile
	special_damage_profile_on_abort = special_damage_profile_on_abort or special_damage_profile

	return damage_profile, special_damage_profile, damage_profile_on_abort, special_damage_profile_on_abort
end

ActionSweep._hit_mass_damage_profile = function (self)
	return self:_damage_profile(1)
end

ActionSweep._damage_type = function (self, sweep_index)
	local damage_type, damage_type_on_abort, damage_type_special_active, damage_type_special_active_on_abort
	local action_settings = self._action_settings

	damage_type = action_settings.damage_type
	damage_type_on_abort = action_settings.damage_type_on_abort or damage_type
	damage_type_special_active = action_settings.damage_type_special_active or damage_type
	damage_type_special_active_on_abort = action_settings.damage_type_special_active_on_abort or damage_type_special_active

	if action_settings.sweeps then
		local sweep = action_settings.sweeps[sweep_index]

		damage_type = sweep.damage_type or damage_type
		damage_type_on_abort = sweep.damage_type_on_abort or damage_type_on_abort or damage_type
		damage_type_special_active = sweep.damage_type_special_active or damage_type_special_active or damage_type
		damage_type_special_active_on_abort = sweep.damage_type_special_active_on_abort or damage_type_special_active_on_abort or damage_type_special_active
	end

	return damage_type, damage_type_special_active, damage_type_on_abort, damage_type_special_active_on_abort
end

function _dot(direction, rotation)
	local up = Quaternion.up(rotation)
	local right = Quaternion.right(rotation)

	return Vector3.dot(direction, up), Vector3.dot(direction, right)
end

return ActionSweep
