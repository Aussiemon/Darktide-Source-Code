-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/plasmagun_overheat_effects.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local PlasmagunOverheatEffects = class("PlasmagunOverheatEffects")
local SFX_ALIAS = "weapon_overload"
local LOOPING_SFX_ALIAS = "weapon_overload_loop"
local LOOPING_VFX_ALIAS = "weapon_overload_loop"
local vfx_external_properties = {}
local _sfx_external_properties = {}
local _slot_components, _is_cinematic_active

PlasmagunOverheatEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world
	local owner_unit = context.owner_unit
	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension
	local overheat_configuration = weapon_template.overheat_configuration
	local overheat_fx = overheat_configuration.fx

	self._owner_unit = owner_unit
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._slot = slot
	self._world = context.world
	self._wwise_world = wwise_world
	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._overheat_configuration = overheat_configuration

	local vfx_source_name = fx_sources[overheat_fx.vfx_source_name]

	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(vfx_source_name)
	self._looping_low_threshold_vfx_name = overheat_fx.looping_low_threshold_vfx
	self._looping_high_threshold_vfx_name = overheat_fx.looping_high_threshold_vfx
	self._looping_critical_threshold_vfx_name = overheat_fx.looping_critical_threshold_vfx
	self._vfx_threshold_effect_ids = {}
	self._sfx_threshold_stages = {}
	self._looping_playing_ids = {}
	self._looping_stop_events = {}
	self._overheat_sfx_source_name = fx_sources[overheat_fx.sfx_source_name]
	self._looping_sound_parameter_name = overheat_fx.looping_sound_parameter_name
	self._looping_playing_id = nil
	self._looping_critical_playing_id = nil
	self._on_screen_effect = overheat_fx.on_screen_effect
	self._on_screen_cloud_name = overheat_fx.on_screen_cloud_name
	self._on_screen_variable_name = overheat_fx.on_screen_variable_name
	self._on_screen_effect_id = nil
	self._plasma_coil_components_1p = _slot_components(slot.attachments_1p)
	self._plasma_coil_components_3p = _slot_components(slot.attachments_3p)
	self._material_overheat_percentage = 0
end

PlasmagunOverheatEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PlasmagunOverheatEffects.update = function (self, unit, dt, t)
	local is_playing_cinematics = _is_cinematic_active()

	if is_playing_cinematics then
		self:_stop_all_effects()

		return
	end

	local inventory_slot_component = self._inventory_slot_component
	local overheat_percentage = inventory_slot_component.overheat_current_percentage
	local overheat_configuration = self._overheat_configuration

	self:_update_vfx(overheat_configuration, overheat_percentage)
	self:_update_threshold_sfx(overheat_configuration, overheat_percentage)
	self:_update_looping_sfx(overheat_configuration, overheat_percentage)
	self:_update_material(overheat_percentage)
	self:_update_screenspace(overheat_percentage)
end

PlasmagunOverheatEffects._update_vfx = function (self, overheat_configuration, overheat_percentage)
	local world = self._world
	local vfx_link_unit, vfx_link_node = self._vfx_link_unit, self._vfx_link_node
	local threshold_effect_ids = self._vfx_threshold_effect_ids
	local visual_loadout_extension = self._visual_loadout_extension

	for stage, threshold in pairs(overheat_configuration.thresholds) do
		local current_effect_id = threshold_effect_ids[stage]
		local was_above_threshold = not not current_effect_id
		local is_above_threshold = threshold < overheat_percentage

		if is_above_threshold and not was_above_threshold then
			vfx_external_properties.stage = stage

			local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(LOOPING_VFX_ALIAS, vfx_external_properties)

			if resolved then
				local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())

				World.link_particles(world, new_effect_id, vfx_link_unit, vfx_link_node, Matrix4x4.identity(), "stop")

				threshold_effect_ids[stage] = new_effect_id
			end
		elseif was_above_threshold and not is_above_threshold then
			World.stop_spawning_particles(world, current_effect_id)

			threshold_effect_ids[stage] = nil
		end
	end
end

PlasmagunOverheatEffects._update_threshold_sfx = function (self, overheat_configuration, overheat_percentage)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._overheat_sfx_source_name)
	local threshold_stages = self._sfx_threshold_stages
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	for stage, threshold in pairs(overheat_configuration.thresholds) do
		local was_above_threshold = not not threshold_stages[stage]
		local is_above_threshold = threshold < overheat_percentage

		if not was_above_threshold and is_above_threshold then
			_sfx_external_properties.stage = stage

			local resolved, event_name, has_husk_events = visual_loadout_extension:resolve_gear_sound(SFX_ALIAS, _sfx_external_properties)

			if resolved then
				event_name = should_play_husk_effect and has_husk_events and event_name .. "_husk" or event_name

				WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)
			end
		end

		threshold_stages[stage] = is_above_threshold
	end
end

PlasmagunOverheatEffects._update_looping_sfx = function (self, overheat_configuration, overheat_percentage)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._overheat_sfx_source_name)
	local critical_threshold = overheat_configuration.thresholds.critical

	self:_update_sfx_loop(overheat_percentage, "base", 0)
	self:_update_sfx_loop(overheat_percentage, "critical", critical_threshold)
	WwiseWorld.set_source_parameter(wwise_world, sfx_source_id, self._looping_sound_parameter_name, overheat_percentage)
end

PlasmagunOverheatEffects._update_sfx_loop = function (self, overheat_percentage, stage, threshold)
	local current_playing_id = self._looping_playing_ids[stage]
	local should_play = not current_playing_id and threshold < overheat_percentage
	local should_stop = current_playing_id and overheat_percentage <= threshold

	if should_play then
		self:_start_sfx_loop(stage)
	elseif should_stop and current_playing_id then
		self:_stop_sfx_loop(stage)
	end
end

PlasmagunOverheatEffects._update_material = function (self, overheat_percentage)
	local components_1p = self._plasma_coil_components_1p
	local components_3p = self._plasma_coil_components_3p
	local material_overheat_percentage = self._material_overheat_percentage
	local min = math.min(material_overheat_percentage, overheat_percentage)
	local max = math.max(material_overheat_percentage, overheat_percentage)
	local lerp_t = 1 - math.abs(overheat_percentage - material_overheat_percentage) / 1

	material_overheat_percentage = math.lerp(min, max, lerp_t)

	for ii = 1, #components_1p do
		local plasma_coil = components_1p[ii]
		local unit = plasma_coil.unit

		plasma_coil.component:set_overheat(unit, material_overheat_percentage * 0.25)
	end

	for ii = 1, #components_3p do
		local plasma_coil = components_3p[ii]
		local unit = plasma_coil.unit

		plasma_coil.component:set_overheat(unit, material_overheat_percentage * 0.25)
	end

	self._material_overheat_percentage = material_overheat_percentage
end

PlasmagunOverheatEffects._update_screenspace = function (self, overheat_percentage)
	local overheat_configuration = self._overheat_configuration
	local low_threshold = overheat_configuration.thresholds.low

	if self._is_local_unit and not self._on_screen_effect_id and low_threshold < overheat_percentage then
		self._on_screen_effect_id = World.create_particles(self._world, self._on_screen_effect, Vector3(0, 0, 1))
	elseif self._on_screen_effect_id and overheat_percentage <= low_threshold then
		World.destroy_particles(self._world, self._on_screen_effect_id)

		self._on_screen_effect_id = nil
	end

	if self._on_screen_effect_id and self._on_screen_cloud_name and self._on_screen_variable_name then
		local scalar = overheat_percentage * 0.9

		World.set_particles_material_scalar(self._world, self._on_screen_effect_id, self._on_screen_cloud_name, self._on_screen_variable_name, scalar)
	end
end

PlasmagunOverheatEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self:_stop_all_effects(true)

		self._first_person_mode = first_person_mode
	end
end

PlasmagunOverheatEffects.wield = function (self)
	return
end

PlasmagunOverheatEffects.unwield = function (self)
	self:_stop_all_effects()
end

PlasmagunOverheatEffects.destroy = function (self)
	self:_stop_all_effects()
end

PlasmagunOverheatEffects._start_sfx_loop = function (self, stage)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._overheat_sfx_source_name)
	local visual_loadout_extension = self._visual_loadout_extension
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	_sfx_external_properties.stage = stage

	local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(LOOPING_SFX_ALIAS, should_play_husk_effect, _sfx_external_properties)

	if resolved then
		local new_playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, sfx_source_id)

		self._looping_playing_ids[stage] = new_playing_id

		if resolved_stop then
			self._looping_stop_events[stage] = stop_event_name
		end
	end
end

PlasmagunOverheatEffects._stop_sfx_loop = function (self, stage, force_stop)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._fx_extension:sound_source(self._overheat_sfx_source_name)
	local current_playing_id = self._looping_playing_ids[stage]
	local stop_event_name = self._looping_stop_events[stage]

	if not force_stop and stop_event_name and sfx_source_id then
		WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, sfx_source_id)
	else
		WwiseWorld.stop_event(wwise_world, current_playing_id)
	end

	self._looping_playing_ids[stage] = nil
	self._looping_stop_events[stage] = nil
end

PlasmagunOverheatEffects._stop_all_effects = function (self, force_stop)
	local sfx_source_id = self._fx_extension:sound_source(self._overheat_sfx_source_name)

	WwiseWorld.set_source_parameter(self._wwise_world, sfx_source_id, self._looping_sound_parameter_name, 0)

	local world = self._world
	local vfx_threshold_effect_ids = self._vfx_threshold_effect_ids

	for _, effect_id in pairs(vfx_threshold_effect_ids) do
		World.destroy_particles(world, effect_id)
	end

	table.clear(vfx_threshold_effect_ids)

	if self._on_screen_effect_id then
		World.destroy_particles(self._world, self._on_screen_effect_id)
	end

	self._on_screen_effect_id = nil

	self:_stop_sfx_loop("base", force_stop)
	self:_stop_sfx_loop("critical", force_stop)
end

function _slot_components(attachments)
	local component_list = {}

	for ii = 1, #attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "PlasmaCoil")

		for _, component in ipairs(components) do
			Unit.set_unit_objects_visibility(attachment_unit, true, false)

			component_list[#component_list + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	return component_list
end

function _is_cinematic_active()
	local extension_manager = Managers.state.extension
	local cinematic_scene_system = extension_manager:system("cinematic_scene_system")
	local cinematic_scene_system_active = cinematic_scene_system:is_active()
	local cinematic_manager = Managers.state.cinematic
	local cinematic_manager_active = cinematic_manager:active()

	return cinematic_scene_system_active or cinematic_manager_active
end

implements(PlasmagunOverheatEffects, WieldableSlotScriptInterface)

return PlasmagunOverheatEffects
