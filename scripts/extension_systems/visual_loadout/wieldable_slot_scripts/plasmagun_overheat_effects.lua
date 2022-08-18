local PlasmagunOverheatEffects = class("PlasmagunOverheatEffects")
local _start_or_stop_vfx, _start_or_stop_looping_wise_event, _destroy_vfx = nil

PlasmagunOverheatEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world
	local owner_unit = context.owner_unit
	local overheat_configuration = weapon_template.overheat_configuration
	local overheat_fx = overheat_configuration.fx
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._owner_unit = owner_unit
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._slot = slot
	self._world = context.world
	self._wwise_world = wwise_world
	self._fx_extension = fx_extension
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._overheat_configuration = overheat_configuration
	local vfx_source_name = fx_sources[overheat_fx.vfx_source_name]
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(vfx_source_name)
	self._looping_low_threshold_vfx_name = overheat_fx.looping_low_threshold_vfx
	self._looping_high_threshold_vfx_name = overheat_fx.looping_high_threshold_vfx
	self._looping_critical_threshold_vfx_name = overheat_fx.looping_critical_threshold_vfx
	self._low_threshold_effect_id = nil
	self._high_threshold_effect_id = nil
	self._critical_threshold_effect_id = nil
	local sfx_source_name = fx_sources[overheat_fx.sfx_source_name]
	local sfx_link_unit, sfx_link_node = fx_extension:sfx_spawner_unit_and_node(sfx_source_name)
	self._sfx_source_id = WwiseWorld.make_manual_source(wwise_world, sfx_link_unit, sfx_link_node)
	local has_husk_events = overheat_fx.has_husk_events
	local looping_sound_start_event = overheat_fx.looping_sound_start_event
	self._looping_sound_start_events = {
		["false"] = looping_sound_start_event,
		["true"] = has_husk_events and looping_sound_start_event .. "_husk" or looping_sound_start_event
	}
	local looping_sound_stop_event = overheat_fx.looping_sound_stop_event
	self._looping_sound_stop_events = {
		["false"] = looping_sound_stop_event,
		["true"] = has_husk_events and looping_sound_stop_event .. "_husk" or looping_sound_stop_event
	}
	local looping_sound_critical_start_event = overheat_fx.looping_sound_critical_start_event
	self._looping_sound_critical_start_events = {
		["false"] = looping_sound_critical_start_event,
		["true"] = has_husk_events and looping_sound_critical_start_event .. "_husk" or looping_sound_critical_start_event
	}
	local looping_sound_critical_stop_event = overheat_fx.looping_sound_critical_stop_event
	self._looping_sound_critical_stop_events = {
		["false"] = looping_sound_critical_stop_event,
		["true"] = has_husk_events and looping_sound_critical_stop_event .. "_husk" or looping_sound_critical_stop_event
	}
	self._looping_sound_parameter_name = overheat_fx.looping_sound_parameter_name
	self._low_threshold_sound_event = overheat_fx.low_threshold_sound_event
	self._high_threshold_sound_event = overheat_fx.high_threshold_sound_event
	self._critical_threshold_sound_event = overheat_fx.critical_threshold_sound_event
	self._looping_playing_id = nil
	self._looping_critical_playing_id = nil
	self._material_variable_name = overheat_fx.material_variable_name
	self._material_name = overheat_fx.material_name
	self._on_screen_effect = overheat_fx.on_screen_effect
	self._on_screen_cloud_name = overheat_fx.on_screen_cloud_name
	self._on_screen_variable_name = overheat_fx.on_screen_variable_name
	self._on_screen_effect_id = nil
end

PlasmagunOverheatEffects.destroy = function (self)
	WwiseWorld.set_source_parameter(self._wwise_world, self._sfx_source_id, self._looping_sound_parameter_name, 0)
	self:_destroy_all_vfx()
	self:_stop_all_looping_sfx()
	self:_destroy_screenspace()
end

PlasmagunOverheatEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PlasmagunOverheatEffects.update = function (self, unit, dt, t)
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
	local unit = self._vfx_link_unit
	local node = self._vfx_link_node
	local low_threshold_effect_id = self._low_threshold_effect_id
	local high_threshold_effect_id = self._high_threshold_effect_id
	local critical_threshold_effect_id = self._critical_threshold_effect_id
	local low_threshold = overheat_configuration.low_threshold
	local high_threshold = overheat_configuration.high_threshold
	local critical_threshold = overheat_configuration.critical_threshold
	local should_play_low_effect = not low_threshold_effect_id and low_threshold < overheat_percentage
	local should_play_high_effect = not high_threshold_effect_id and high_threshold < overheat_percentage
	local should_play_critical_effect = not critical_threshold_effect_id and critical_threshold < overheat_percentage
	local should_stop_low_effect = low_threshold_effect_id and overheat_percentage <= low_threshold
	local should_stop_high_effect = high_threshold_effect_id and overheat_percentage <= high_threshold
	local should_stop_critical_effect = critical_threshold_effect_id and overheat_percentage <= critical_threshold
	self._low_threshold_effect_id = _start_or_stop_vfx(world, should_play_low_effect, should_stop_low_effect, low_threshold_effect_id, self._looping_low_threshold_vfx_name, unit, node)
	self._high_threshold_effect_id = _start_or_stop_vfx(world, should_play_high_effect, should_stop_high_effect, high_threshold_effect_id, self._looping_high_threshold_vfx_name, unit, node)
	self._critical_threshold_effect_id = _start_or_stop_vfx(world, should_play_critical_effect, should_stop_critical_effect, critical_threshold_effect_id, self._looping_critical_threshold_vfx_name, unit, node)
end

PlasmagunOverheatEffects._update_threshold_sfx = function (self, overheat_configuration, overheat_percentage)
	local wwise_world = self._wwise_world
	local sfx_source_id = self._sfx_source_id
	local low_threshold_sound_event = self._low_threshold_sound_event
	local high_threshold_sound_event = self._high_threshold_sound_event
	local critical_threshold_sound_event = self._critical_threshold_sound_event
	local low_threshold = overheat_configuration.low_threshold
	local high_threshold = overheat_configuration.high_threshold
	local critical_threshold = overheat_configuration.critical_threshold
	local was_above_low_threshold = self._was_above_low_threshold
	local was_above_high_threshold = self._was_above_high_threshold
	local was_above_critical_threshold = self._was_above_critical_threshold
	local is_above_low_threshold = low_threshold < overheat_percentage
	local is_above_high_threshold = high_threshold < overheat_percentage
	local is_above_critical_threshold = critical_threshold < overheat_percentage

	_play_threshold_wwise_event(wwise_world, was_above_low_threshold, is_above_low_threshold, low_threshold_sound_event, sfx_source_id)
	_play_threshold_wwise_event(wwise_world, was_above_high_threshold, is_above_high_threshold, high_threshold_sound_event, sfx_source_id)
	_play_threshold_wwise_event(wwise_world, was_above_critical_threshold, is_above_critical_threshold, critical_threshold_sound_event, sfx_source_id)

	self._was_above_low_threshold = is_above_low_threshold
	self._was_above_high_threshold = is_above_high_threshold
	self._was_above_critical_threshold = is_above_critical_threshold
end

PlasmagunOverheatEffects._update_looping_sfx = function (self, overheat_configuration, overheat_percentage)
	local wwise_world = self._wwise_world
	local looping_playing_id = self._looping_playing_id
	local looping_critical_playing_id = self._looping_critical_playing_id
	local sfx_source_id = self._sfx_source_id
	local is_husk = self._is_husk and "true" or "false"
	local critical_threshold = overheat_configuration.critical_threshold
	local should_play_loop = not looping_playing_id and overheat_percentage > 0
	local should_play_critical_loop = not looping_critical_playing_id and critical_threshold < overheat_percentage
	local should_stop_loop = looping_playing_id and overheat_percentage <= 0
	local should_stop_critical_loop = looping_critical_playing_id and overheat_percentage <= critical_threshold
	self._looping_playing_id = _start_or_stop_looping_wise_event(wwise_world, should_play_loop, should_stop_loop, looping_playing_id, self._looping_sound_start_events[is_husk], self._looping_sound_stop_events[is_husk], sfx_source_id)
	self._looping_critical_playing_id = _start_or_stop_looping_wise_event(wwise_world, should_play_critical_loop, should_stop_critical_loop, looping_critical_playing_id, self._looping_sound_critical_start_events[is_husk], self._looping_sound_critical_stop_events[is_husk], sfx_source_id)

	WwiseWorld.set_source_parameter(wwise_world, sfx_source_id, self._looping_sound_parameter_name, overheat_percentage)
end

PlasmagunOverheatEffects._update_material = function (self, overheat_percentage)
	local material_variable_name = self._material_variable_name
	local material_name = self._material_name
	local slot = self._slot
	local attachments_1p = slot.attachments_1p
	local attachments_3p = slot.attachments_3p

	for i = 1, #attachments_1p do
		local attachment_unit = attachments_1p[i]

		Unit.set_scalar_for_material(attachment_unit, material_name, material_variable_name, math.lerp(0, 0.2, overheat_percentage))
	end

	for i = 1, #attachments_3p do
		local attachment_unit = attachments_3p[i]

		Unit.set_scalar_for_material(attachment_unit, material_name, material_variable_name, math.lerp(0, 0.2, overheat_percentage))
	end
end

PlasmagunOverheatEffects._update_screenspace = function (self, overheat_percentage)
	local overheat_configuration = self._overheat_configuration
	local low_threshold = overheat_configuration.low_threshold

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

PlasmagunOverheatEffects._destroy_all_vfx = function (self)
	local world = self._world

	_destroy_vfx(world, self._low_threshold_effect_id)
	_destroy_vfx(world, self._high_threshold_effect_id)
	_destroy_vfx(world, self._critical_threshold_effect_id)

	self._low_threshold_effect_id = nil
	self._high_threshold_effect_id = nil
	self._critical_threshold_effect_id = nil
end

PlasmagunOverheatEffects._stop_all_looping_sfx = function (self)
	local wwise_world = self._wwise_world
	local is_husk = self._is_husk and "true" or "false"
	self._looping_playing_id = _start_or_stop_looping_wise_event(wwise_world, false, true, self._looping_playing_id, self._looping_sound_start_events[is_husk], self._looping_sound_stop_events[is_husk])
	self._looping_critical_playing_id = _start_or_stop_looping_wise_event(wwise_world, false, true, self._looping_critical_playing_id, self._looping_sound_critical_start_events[is_husk], self._looping_sound_critical_stop_events[is_husk])
end

PlasmagunOverheatEffects._destroy_screenspace = function (self)
	if self._on_screen_effect_id then
		World.destroy_particles(self._world, self._on_screen_effect_id)
	end

	self._on_screen_effect_id = nil
end

PlasmagunOverheatEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PlasmagunOverheatEffects.wield = function (self)
	return
end

PlasmagunOverheatEffects.unwield = function (self)
	WwiseWorld.set_source_parameter(self._wwise_world, self._sfx_source_id, self._looping_sound_parameter_name, 0)
	self:_destroy_all_vfx()
	self:_stop_all_looping_sfx()
	self:_destroy_screenspace()
end

function _start_or_stop_vfx(world, should_play, should_stop, current_effect_id, effect_name, unit, node)
	if should_play then
		local effect_id = World.create_particles(world, effect_name, Vector3.zero())

		World.link_particles(world, effect_id, unit, node, Matrix4x4.identity(), "stop")

		return effect_id
	elseif should_stop and current_effect_id then
		World.stop_spawning_particles(world, current_effect_id)

		return nil
	end

	return current_effect_id
end

function _start_or_stop_looping_wise_event(wwise_world, should_play, should_stop, current_playing_id, start_event_name, stop_event_name, source_id)
	if should_play then
		local playing_id = WwiseWorld.trigger_resource_event(wwise_world, start_event_name, source_id)

		return playing_id
	elseif should_stop and current_playing_id then
		if stop_event_name and source_id then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(wwise_world, current_playing_id)
		end

		return nil
	end

	return current_playing_id
end

function _play_threshold_wwise_event(wwise_world, was_above_threshold, is_above_threshold, event_name, source_id)
	if event_name and not was_above_threshold and is_above_threshold then
		WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)
	end
end

function _destroy_vfx(world, current_effect_id)
	if current_effect_id then
		World.destroy_particles(world, current_effect_id)
	end
end

return PlasmagunOverheatEffects
