-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_overheat_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local PowerWeaponOverheatEffects = class("PowerWeaponOverheatEffects")
local STAGE_INTERFACING_SFX_ALIAS = "power_weapon_overload"
local PARTICLE_STAGE_LOOP_FX_ALIAS = "weapon_overload_loop"
local LOCKOUT_LOOPING_SFX_ALIAS = "weapon_overload_lockout_loop"
local FX_SOURCE_NAME = "_special_active"
local LOCKOUT_LOOP_SOUND_PARAMETER_NAME = "overload_level"
local _sfx_external_properties = {}
local _vfx_external_properties = {}
local THRESHOLDS = {
	critical = 0.9,
	high = 0.7,
	low = 0.3,
}
local STAGE_RANKING = {
	critical = 3,
	high = 2,
	low = 1,
}

PowerWeaponOverheatEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension

	self._owner_unit = owner_unit
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._visual_loadout_extension = visual_loadout_extension
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_sources[FX_SOURCE_NAME])
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
end

PowerWeaponOverheatEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PowerWeaponOverheatEffects.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local overheat_percentage = inventory_slot_component.overheat_current_percentage
	local overheat_state = inventory_slot_component.overheat_state
	local special_active = inventory_slot_component.special_active
	local wants_fx = overheat_state ~= "idle" or special_active

	if wants_fx then
		local thresholds = THRESHOLDS
		local current_overheat = self._current_overheat
		local current_stage = self._current_stage
		local num_charges = self._inventory_slot_component.num_special_charges

		if overheat_state == "idle" and current_overheat ~= overheat_percentage then
			local wanted_stage

			wanted_stage = overheat_percentage >= thresholds.critical and "critical" or overheat_percentage >= thresholds.high and "high" or "low"

			local stage_changed = current_stage ~= wanted_stage

			if stage_changed then
				self:_update_stage_loop(unit, dt, t, current_stage, wanted_stage)
			end

			if wanted_stage == "critical" and self._current_stage == "high" then
				self:_trigger_critical_sfx()
			end

			self._current_stage = wanted_stage
		elseif overheat_state == "lockout" then
			local wanted_stage = "critical"

			self:_update_stage_loop(unit, dt, t, current_stage, wanted_stage)

			self._current_stage = wanted_stage
		end

		self._current_overheat = num_charges
	else
		self:_stop_stage_loop()
	end

	self:_update_lockout_sfx_loop(overheat_state)
end

PowerWeaponOverheatEffects._update_stage_loop = function (self, unit, dt, t, current_stage, wanted_stage)
	if current_stage == wanted_stage then
		return
	end

	local trigger_fx = STAGE_RANKING[wanted_stage] > 1
	local stop_fx = STAGE_RANKING[wanted_stage] <= 1

	if trigger_fx then
		self:_stop_stage_loop()

		local visual_loadout_extension = self._visual_loadout_extension

		_vfx_external_properties.stage = wanted_stage

		local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(PARTICLE_STAGE_LOOP_FX_ALIAS, _vfx_external_properties)

		if resolved then
			local world = self._world
			local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, new_effect_id, self._vfx_link_unit, self._vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_stage_effect_id = new_effect_id
		end
	elseif stop_fx then
		self:_stop_stage_loop()
	end
end

PowerWeaponOverheatEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PowerWeaponOverheatEffects.destroy = function (self)
	self:_stop_stage_loop(true)
end

PowerWeaponOverheatEffects.wield = function (self)
	return
end

PowerWeaponOverheatEffects.unwield = function (self)
	self:_stop_stage_loop(true)
	self:_stop_lockout_sfx_loop()
end

PowerWeaponOverheatEffects._stop_stage_loop = function (self, force_stop)
	local looping_stage_effect_id = self._looping_stage_effect_id

	if not looping_stage_effect_id then
		return
	end

	if force_stop then
		World.destroy_particles(self._world, looping_stage_effect_id)
	else
		World.stop_spawning_particles(self._world, looping_stage_effect_id)
	end

	self._looping_stage_effect_id = nil
end

PowerWeaponOverheatEffects._update_lockout_sfx_loop = function (self, overheat_state)
	local looping_lockout_playing_id = self._looping_lockout_playing_id
	local start_loop = overheat_state == "lockout" and not looping_lockout_playing_id
	local stop_loop = overheat_state ~= "lockout" and looping_lockout_playing_id

	if start_loop then
		self:_start_lockout_sfx_loop()
	elseif stop_loop then
		self:_stop_lockout_sfx_loop()
	end

	if looping_lockout_playing_id then
		local source = self._fx_extension:sound_source(self._special_active_fx_source_name)
		local inventory_slot_component = self._inventory_slot_component
		local overheat_percentage = inventory_slot_component.overheat_current_percentage

		WwiseWorld.set_source_parameter(self._wwise_world, source, LOCKOUT_LOOP_SOUND_PARAMETER_NAME, overheat_percentage)
	end
end

PowerWeaponOverheatEffects._start_lockout_sfx_loop = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	if should_play_husk_effect then
		return
	end

	table.clear(_sfx_external_properties)

	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(LOCKOUT_LOOPING_SFX_ALIAS, should_play_husk_effect, _sfx_external_properties)

	if resolved then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_lockout_playing_id = new_playing_id

		if resolved_stop then
			self._looping_lockout_stop_event_name = stop_event_name
		end
	end
end

PowerWeaponOverheatEffects._stop_lockout_sfx_loop = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local current_playing_id = self._looping_lockout_playing_id
	local stop_event_name = self._looping_lockout_stop_event_name

	if stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_lockout_playing_id = nil
	self._looping_lockout_stop_event_name = nil
end

PowerWeaponOverheatEffects._trigger_critical_sfx = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	if should_play_husk_effect then
		return
	end

	local visual_loadout_extension = self._visual_loadout_extension

	table.clear(_sfx_external_properties)

	_sfx_external_properties.stage = "critical"

	local resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(STAGE_INTERFACING_SFX_ALIAS, _sfx_external_properties)

	if resolved then
		event_name = should_play_husk_effect and has_husk_events and event_name .. "_husk" or event_name

		WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)
	end
end

implements(PowerWeaponOverheatEffects, WieldableSlotScriptInterface)

return PowerWeaponOverheatEffects
