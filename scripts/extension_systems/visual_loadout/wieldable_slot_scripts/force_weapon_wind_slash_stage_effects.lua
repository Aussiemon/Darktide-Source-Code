-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/force_weapon_wind_slash_stage_effects.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ForceWeaponWindSlashStageEffects = class("ForceWeaponWindSlashStageEffects")
local _set_intensity, _unit_components
local _external_properties = {}
local PARTICLE_STAGE_SCREENSPACE_ALIAS_FX = "wind_slash_stage_screen_space"
local PARTICLE_STAGE_ALIAS_FX = "wind_slash_stage_interfacing"
local PARTICLE_STAGE_LOOP_FX = "wind_slash_stage_loop"
local SOUND_STAGE_ALIAS_FX = "wind_slash_stage_interfacing"
local SOUND_STAGE_LOOP_FX = "wind_slash_stage_loop"
local FX_SOURCE_NAME = "_special_active"
local STAGE_RANKING = {
	high = 3,
	low = 1,
	middle = 2,
}

ForceWeaponWindSlashStageEffects.init = function (self, context, slot, weapon_template, fx_sources)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit

	local unit_data_extension = ScriptUnit.extension(context.owner_unit, "unit_data_system")
	local fx_extension = context.fx_extension

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._visual_loadout_extension = context.visual_loadout_extension
	self._fx_extension = fx_extension

	local fx_source_name = fx_sources[FX_SOURCE_NAME]

	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
	self._fx_source_name = fx_source_name
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}
	self._current_stage = "low"
	self._looping_stage_effect_id = nil
	self._looping_stage_playing_id = nil

	_unit_components(self._weapon_material_variables_3p, slot.attachments_3p)
	_unit_components(self._weapon_material_variables_1p, slot.attachments_1p)
end

ForceWeaponWindSlashStageEffects.destroy = function (self)
	self:_stop_stage_particle_loop(true)
	self:_stop_stage_sound_loop()
end

ForceWeaponWindSlashStageEffects.wield = function (self)
	self:_update_effects(false, true, true)
end

ForceWeaponWindSlashStageEffects.unwield = function (self)
	self:_stop_stage_particle_loop(true)
	self:_stop_stage_sound_loop()

	self._current_stage = "low"
end

ForceWeaponWindSlashStageEffects.fixed_update = function (self, dt, t, frame)
	return
end

ForceWeaponWindSlashStageEffects.update = function (self, dt, t)
	self:_update_effects(true, true, false)
end

ForceWeaponWindSlashStageEffects._update_effects = function (self, update_stage_interfacing, update_loops, force_update)
	local current_stage = self._current_stage
	local num_charges = self._inventory_slot_component.num_special_charges
	local tweak_data = self._weapon_special_tweak_data
	local thresholds = tweak_data.thresholds
	local wanted_stage = "low"

	for ii = #thresholds, 1, -1 do
		if num_charges >= thresholds[ii].threshold then
			wanted_stage = thresholds[ii].name

			break
		end
	end

	local stage_changed = current_stage ~= wanted_stage

	if stage_changed and update_stage_interfacing then
		self:_update_stage_interfacing(current_stage, wanted_stage)
	end

	if stage_changed or force_update then
		self:_update_material_variables(wanted_stage)
	end

	if update_loops then
		self:_update_particle_loop(current_stage, wanted_stage)
		self:_update_sound_loop(current_stage, wanted_stage)
	end

	self._current_stage = wanted_stage
end

ForceWeaponWindSlashStageEffects._update_stage_interfacing = function (self, current_stage, wanted_stage)
	local trigger_fx = STAGE_RANKING[wanted_stage] > STAGE_RANKING[current_stage]

	if trigger_fx then
		local visual_loadout_extension = self._visual_loadout_extension
		local world = self._world

		_external_properties.stage = wanted_stage

		local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(PARTICLE_STAGE_ALIAS_FX, _external_properties)

		if resolved then
			local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, new_effect_id, self._vfx_link_unit, self._vfx_link_node, Matrix4x4.identity(), "stop")
		end

		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

		if not should_play_husk_effect then
			local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(PARTICLE_STAGE_SCREENSPACE_ALIAS_FX, _external_properties)

			if resolved then
				World.create_particles(world, effect_name, Vector3(0, 0, 1), Quaternion.identity(), Vector3.one())
			end
		end

		local resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(SOUND_STAGE_ALIAS_FX, _external_properties)

		if resolved then
			local wwise_world = self._wwise_world

			event_name = should_play_husk_effect and has_husk_events and event_name .. "_husk" or event_name

			local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)

			WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)
		end
	end
end

ForceWeaponWindSlashStageEffects._update_particle_loop = function (self, current_stage, wanted_stage)
	local looping_stage_effect_id = self._looping_stage_effect_id
	local trigger_fx = STAGE_RANKING[wanted_stage] > 1 and not looping_stage_effect_id
	local stop_fx = STAGE_RANKING[wanted_stage] <= 1 and looping_stage_effect_id

	if trigger_fx then
		self:_stop_stage_particle_loop()

		_external_properties.stage = nil

		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(PARTICLE_STAGE_LOOP_FX, _external_properties)

		if resolved then
			local world = self._world
			local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, new_effect_id, self._vfx_link_unit, self._vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_stage_effect_id = new_effect_id
		end
	elseif stop_fx then
		self:_stop_stage_particle_loop()
	end
end

ForceWeaponWindSlashStageEffects._update_sound_loop = function (self, current_stage, wanted_stage)
	local looping_stage_playing_id = self._looping_stage_playing_id
	local trigger_fx = STAGE_RANKING[wanted_stage] > 1 and not looping_stage_playing_id
	local stop_fx = STAGE_RANKING[wanted_stage] <= 1 and looping_stage_playing_id

	if trigger_fx then
		local visual_loadout_extension = self._visual_loadout_extension

		_external_properties.stage = nil

		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
		local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(SOUND_STAGE_LOOP_FX, should_play_husk_effect, _external_properties)
		local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)

		if resolved then
			local new_playing_id = WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)

			self._looping_stage_playing_id = new_playing_id

			if resolved_stop then
				self._looping_stage_stop_event = stop_event_name
			end
		end
	elseif stop_fx then
		self:_stop_stage_sound_loop()
	end
end

ForceWeaponWindSlashStageEffects._stop_stage_particle_loop = function (self, force_stop)
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

ForceWeaponWindSlashStageEffects._stop_stage_sound_loop = function (self, force_stop)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._fx_source_name)
	local current_playing_id = self._looping_stage_playing_id
	local stop_event_name = self._looping_stage_stop_event

	if not force_stop and stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	elseif current_playing_id then
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_stage_playing_id = nil
	self._looping_stage_stop_event = nil
end

local _stage_to_intensity = {
	high = 1,
	low = 0,
	middle = 0.3333333333333333,
}

ForceWeaponWindSlashStageEffects._update_material_variables = function (self, wanted_stage)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p
	local percentage = _stage_to_intensity[wanted_stage]

	_set_intensity(percentage, variables_1p)
	_set_intensity(percentage, variables_3p)
end

ForceWeaponWindSlashStageEffects.update_first_person_mode = function (self, first_person_mode)
	self:_stop_stage_particle_loop(true)
	self:_stop_stage_sound_loop(true)

	self._current_stage = "low"
end

function _set_intensity(charge_level, weapon_material_variables)
	for ii = 1, #weapon_material_variables do
		local weapon_material_variable = weapon_material_variables[ii]

		weapon_material_variable.component:set_intensity(charge_level, weapon_material_variable.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end
end

implements(ForceWeaponWindSlashStageEffects, WieldableSlotScriptInterface)

return ForceWeaponWindSlashStageEffects
