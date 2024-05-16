-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_effects.lua

local Component = require("scripts/utilities/component")
local PlayerCharacterLoopingSoundAliases = require("scripts/settings/sound/player_character_looping_sound_aliases")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PowerWeaponEffects = class("PowerWeaponEffects")
local _set_start_time, _set_stop_time, _unit_components
local sfx_external_properties = {}
local vfx_external_properties = {}
local SPECIAL_ACTIVE_LOOPING_VFX_ALIAS = "weapon_special_loop"
local SPECIAL_ACTIVE_LOOPING_SFX_ALIAS = "weapon_special_loop"
local SPECIAL_ACTIVE_LOOPING_SFX_CONFIG = PlayerCharacterLoopingSoundAliases[SPECIAL_ACTIVE_LOOPING_SFX_ALIAS]
local SPECIAL_OFF_SOUND_ALIAS = "weapon_special_end"
local INVENTORY_EVENT_POWER_OFF = "special_disabled"
local INVENTORY_EVENT_POWER_ON = "special_enabled"
local INVENTORY_EVENT_WIELD = "special_disabled"
local SOUND_PARAMETER_NAME = "power_resource"
local FX_SOURCE_NAME = "_special_active"

PowerWeaponEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local is_husk = context.is_husk
	local owner_unit = context.owner_unit

	self._is_husk = is_husk
	self._is_local_unit = context.is_local_unit
	self._slot_name = slot.name
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
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

	_unit_components(self._weapon_material_variables_1p, slot.attachments_1p)
	_unit_components(self._weapon_material_variables_3p, slot.attachments_3p)
end

PowerWeaponEffects.destroy = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()

	if self._is_playing and not self._is_husk then
		self._fx_extension:trigger_gear_wwise_event_with_source(SPECIAL_OFF_SOUND_ALIAS, nil, self._special_active_fx_source_name, true)
	end
end

PowerWeaponEffects.wield = function (self)
	PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_WIELD)
end

PowerWeaponEffects.unwield = function (self)
	self:_stop_sfx_loop()
	self:_stop_vfx_loop()

	local t = World.time(self._world)

	_set_stop_time(t, self._weapon_material_variables_1p)
	_set_stop_time(t, self._weapon_material_variables_3p)
end

PowerWeaponEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PowerWeaponEffects.update = function (self, unit, dt, t)
	self:_update_active()
end

PowerWeaponEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PowerWeaponEffects._update_active = function (self)
	local is_active = self._is_active
	local special_active = self._inventory_slot_component.special_active
	local fx_extension = self._fx_extension
	local t = World.time(self._world)
	local current_playing_id = self._looping_playing_id
	local should_start = not current_playing_id and not is_active and special_active
	local should_stop = current_playing_id and is_active and not special_active

	if should_start then
		self:_start_sfx_loop()
		self:_start_vfx_loop()
		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_ON)
		_set_start_time(t, self._weapon_material_variables_1p)
		_set_start_time(t, self._weapon_material_variables_3p)
	elseif should_stop then
		self:_stop_sfx_loop()
		self:_stop_vfx_loop()

		if not self._is_husk then
			fx_extension:trigger_gear_wwise_event_with_source(SPECIAL_OFF_SOUND_ALIAS, nil, self._special_active_fx_source_name, true)
		end

		PlayerUnitVisualLoadout.slot_flow_event(self._first_person_extension, self._visual_loadout_extension, self._slot_name, INVENTORY_EVENT_POWER_OFF)
		_set_stop_time(t, self._weapon_material_variables_1p)
		_set_stop_time(t, self._weapon_material_variables_3p)
	end

	if special_active then
		local source = self._fx_extension:sound_source(self._special_active_fx_source_name)

		WwiseWorld.set_source_parameter(self._wwise_world, source, SOUND_PARAMETER_NAME, 20)
	end

	self._is_active = special_active
end

PowerWeaponEffects._start_sfx_loop = function (self)
	local is_husk = self._is_husk
	local is_local_unit = self._is_local_unit
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._special_active_fx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local use_husk_event = is_husk or not is_local_unit
	local start_config = SPECIAL_ACTIVE_LOOPING_SFX_CONFIG.start
	local stop_config = SPECIAL_ACTIVE_LOOPING_SFX_CONFIG.stop
	local start_event_alias = start_config.event_alias
	local stop_event_alias = stop_config.event_alias
	local resolved, has_husk_events, event_name

	resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(start_event_alias, sfx_external_properties)

	if resolved then
		event_name = use_husk_event and has_husk_events and event_name .. "_husk" or event_name

		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_playing_id = new_playing_id
		resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(stop_event_alias, sfx_external_properties)

		if resolved then
			event_name = use_husk_event and has_husk_events and event_name .. "_husk" or event_name
			self._looping_stop_event_name = event_name
		end
	end
end

PowerWeaponEffects._stop_sfx_loop = function (self)
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

PowerWeaponEffects._start_vfx_loop = function (self)
	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(SPECIAL_ACTIVE_LOOPING_VFX_ALIAS, vfx_external_properties)

	if resolved then
		local world = self._world
		local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())
		local vfx_link_unit, vfx_link_node = self._fx_extension:vfx_spawner_unit_and_node(self._special_active_fx_source_name)

		World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

		self._looping_effect_id = new_effect_id
	end
end

PowerWeaponEffects._stop_vfx_loop = function (self, destroy)
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

function _set_start_time(t, weapon_material_variables)
	for ii = 1, #weapon_material_variables do
		local weapon_material_variable = weapon_material_variables[ii]

		weapon_material_variable.component:set_start_time(t, weapon_material_variable.unit)
	end
end

function _set_stop_time(t, weapon_material_variables)
	for ii = 1, #weapon_material_variables do
		local weapon_material_variable = weapon_material_variables[ii]

		weapon_material_variable.component:set_stop_time(t, weapon_material_variable.unit)
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

return PowerWeaponEffects
