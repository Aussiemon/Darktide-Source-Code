-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_sword_p3_effects.lua

local Component = require("scripts/utilities/component")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local PowerSwordP3Effects = class("PowerSwordP3Effects")
local _unit_components
local _sfx_external_properties = {}
local _vfx_external_properties = {}
local SPECIAL_ACTIVE_LOOPING_VFX_ALIAS = "weapon_special_loop"
local SPECIAL_ACTIVE_LOOPING_SFX_ALIAS = "weapon_special_loop"
local SPECIAL_ACTIVE_LOOPING_EXTRA_VFX_ALIAS = "weapon_special_extra_loop"
local SPECIAL_OFF_VFX_ALIAS = "weapon_special_end"
local SPECIAL_OFF_SFX_ALIAS = "weapon_special_end"
local INVENTORY_EVENT_POWER_OFF = "special_disabled"
local INVENTORY_EVENT_POWER_ON = "special_enabled"
local INVENTORY_EVENT_WIELD = "special_disabled"
local SOUND_PARAMETER_NAME = "power_resource"
local FX_SOURCE_NAME = "_special_active"
local FX_SOURCE_EXTRA_NAME_FORMAT_STRING = "_power_node_%d"

PowerSwordP3Effects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit

	self._is_husk = is_husk
	self._is_local_unit = context.is_local_unit
	self._slot_name = slot.name
	self._world = context.world
	self._wwise_world = context.wwise_world

	if GameParameters.destroy_unmanaged_particles then
		self._particle_group_id = context.player_particle_group_id
	end

	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]

	local emit_fx_source_names = {}
	local found_all_emit_sources
	local index = 1

	repeat
		local fx_source_name = string.format(FX_SOURCE_EXTRA_NAME_FORMAT_STRING, index)
		local fx_source = fx_sources[fx_source_name]

		found_all_emit_sources = fx_source == nil

		if fx_source then
			emit_fx_source_names[index] = fx_source
			index = index + 1
		end
	until found_all_emit_sources

	self._emit_fx_source_names = #emit_fx_source_names > 0 and emit_fx_source_names or nil
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._visual_loadout_extension = context.visual_loadout_extension
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}
	self._is_active = false
	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
	self._looping_effect_id = nil
	self._looping_emit_effect_ids = {}

	_unit_components(self._weapon_material_variables_1p, slot.attachments_by_unit_1p[unit_1p])
	_unit_components(self._weapon_material_variables_3p, slot.attachments_by_unit_3p[unit_3p])
end

PowerSwordP3Effects.destroy = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop(true)
	self:_stop_emit_vfx_loop(true)
end

PowerSwordP3Effects.wield = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_WIELD)
	self:_toggle_on_off(true)
end

PowerSwordP3Effects.unwield = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()
	self:_stop_emit_vfx_loop(true)

	self._is_active = false
end

PowerSwordP3Effects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PowerSwordP3Effects.update = function (self, unit, dt, t)
	self:_update_active()
end

PowerSwordP3Effects.update_first_person_mode = function (self, first_person_mode)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()
	self:_stop_emit_vfx_loop()

	self._is_active = false

	self:_toggle_on_off(true)
	self:_set_charge_level(0)
end

PowerSwordP3Effects._play_single_sfx = function (self, sound_alias, fx_source_name)
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local resolved, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound(sound_alias, _sfx_external_properties)

	if resolved then
		local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

		if has_husk_events and should_play_husk_effect then
			event_name = event_name .. "_husk"
		end

		WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)
	end
end

PowerSwordP3Effects._play_single_vfx = function (self, particle_alias, fx_source_name)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(particle_alias, _vfx_external_properties)

	if resolved then
		local world = self._world
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(fx_source_name)
		local new_effect_id = World.create_particles(world, effect_name, Vector3.zero(), nil, nil, self._particle_group_id)

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")
	end
end

PowerSwordP3Effects._update_active = function (self)
	local is_active = self._is_active
	local special_active = self._inventory_slot_component.special_active
	local current_playing_id = self._looping_playing_id
	local should_start = not current_playing_id and not is_active and special_active
	local should_stop = current_playing_id and is_active and not special_active

	if not self._emit_fx_running then
		self:_start_emit_vfx_loop()
	end

	if should_start then
		self:_start_sfx_loop()
		self:_start_vfx_loop()
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_ON)
		self:_set_charge_level(1)
	elseif should_stop then
		self:_stop_sfx_loop()
		self:_stop_vfx_loop()
		self:_play_single_sfx(SPECIAL_OFF_SFX_ALIAS, self._special_active_fx_source_name)
		self:_play_single_vfx(SPECIAL_OFF_VFX_ALIAS, self._special_active_fx_source_name)
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
		self:_set_charge_level(0)
	end

	if special_active then
		local source = self._fx_extension:sound_source(self._special_active_fx_source_name)

		WwiseWorld.set_source_parameter(self._wwise_world, source, SOUND_PARAMETER_NAME, 20)
	end

	self._is_active = special_active
end

PowerSwordP3Effects._start_sfx_loop = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(SPECIAL_ACTIVE_LOOPING_SFX_ALIAS, should_play_husk_effect, _sfx_external_properties)

	if resolved then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_playing_id = new_playing_id

		if resolved_stop then
			self._looping_stop_event_name = stop_event_name
		end
	end
end

PowerSwordP3Effects._stop_sfx_loop = function (self)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local current_playing_id = self._looping_playing_id
	local stop_event_name = self._looping_stop_event_name

	if stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_playing_id = nil
	self._looping_stop_event_name = nil
end

PowerSwordP3Effects._start_vfx_loop = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVE_LOOPING_VFX_ALIAS, _vfx_external_properties)

	if resolved then
		local world = self._world
		local fx_extension = self._fx_extension
		local new_effect_id = fx_extension:spawn_particles_local(effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = fx_extension:vfx_spawner_unit_and_node(self._special_active_fx_source_name)

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_id = new_effect_id
	end
end

PowerSwordP3Effects._start_emit_vfx_loop = function (self)
	local emit_fx_source_names = self._emit_fx_source_names

	if not emit_fx_source_names then
		return
	end

	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVE_LOOPING_EXTRA_VFX_ALIAS, _vfx_external_properties)

	if resolved then
		local world = self._world
		local fx_extension = self._fx_extension

		for ii = 1, #emit_fx_source_names do
			local new_effect_id = fx_extension:spawn_particles_local(effect_name, Vector3.zero())
			local vfx_link_unit, vfx_link_node = fx_extension:vfx_spawner_unit_and_node(emit_fx_source_names[ii])

			World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_emit_effect_ids[ii] = new_effect_id
		end

		self._emit_fx_running = true
	end
end

PowerSwordP3Effects._stop_vfx_loop = function (self, destroy)
	local current_effect_id = self._looping_effect_id

	if current_effect_id then
		if destroy then
			World.destroy_particles(self._world, current_effect_id)
		else
			World.stop_spawning_particles(self._world, current_effect_id)
		end
	end

	self._looping_effect_id = nil
end

PowerSwordP3Effects._stop_emit_vfx_loop = function (self, destroy)
	local looping_emit_effect_ids = self._looping_emit_effect_ids

	for ii = 1, #looping_emit_effect_ids do
		local current_effect_id = looping_emit_effect_ids[ii]

		if destroy then
			World.destroy_particles(self._world, current_effect_id)
		else
			World.stop_spawning_particles(self._world, current_effect_id)
		end
	end

	self._emit_fx_running = nil

	table.clear(looping_emit_effect_ids)
end

PowerSwordP3Effects._set_charge_level = function (self, _level)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:set_charge_level(_level, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:set_charge_level(_level, weapon_material_variable.unit)
	end
end

PowerSwordP3Effects._toggle_on_off = function (self, is_on)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
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

implements(PowerSwordP3Effects, WieldableSlotScriptInterface)

return PowerSwordP3Effects
