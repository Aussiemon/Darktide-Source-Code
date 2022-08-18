local Action = require("scripts/utilities/weapon/action")
local ForceStaffAoeTargetingEffects = class("ForceStaffAoeTargetingEffects")
local SPAWN_POS = Vector3Box(400, 400, 400)

ForceStaffAoeTargetingEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world
	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._fx_extension = context.fx_extension
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._action_module_position_finder_component = unit_data_extension:read_component("action_module_position_finder")
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	local source_id = WwiseWorld.make_manual_source(wwise_world, SPAWN_POS:unbox())
	self._decal_unit = nil
	self._effect_id = nil
	self._scaling_effect_id = nil
	self._scale_variable_index = nil
	self._source_id = source_id
	self._targeting_playing_id = nil
end

ForceStaffAoeTargetingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

ForceStaffAoeTargetingEffects.update = function (self, unit, dt, t)
	self:_update_targeting_effects()
end

ForceStaffAoeTargetingEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

ForceStaffAoeTargetingEffects.wield = function (self)
	self:_update_targeting_effects()
end

ForceStaffAoeTargetingEffects.unwield = function (self)
	self:_destroy_effects()
end

ForceStaffAoeTargetingEffects.destroy = function (self)
	self:_destroy_effects()
	WwiseWorld.destroy_manual_source(self._wwise_world, self._source_id)

	self._source_id = nil
end

ForceStaffAoeTargetingEffects._update_targeting_effects = function (self)
	local world = self._world
	local wwise_world = self._wwise_world
	local spawn_pos = SPAWN_POS:unbox()
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local position_finder_fx = action_settings and action_settings.position_finder_fx

	if not position_finder_fx then
		self:_destroy_effects()

		return
	end

	local is_local_unit = self._is_local_unit
	local source_id = self._source_id
	local decal_unit_name = (is_local_unit and position_finder_fx.decal_unit_name) or position_finder_fx.decal_unit_name_3p
	local effect_name = (is_local_unit and position_finder_fx.effect_name) or position_finder_fx.effect_name_3p
	local scaling_effect_name = (is_local_unit and position_finder_fx.scaling_effect_name) or position_finder_fx.scaling_effect_name_3p
	local scale_variable_name = position_finder_fx.scale_variable_name
	local wwise_event = position_finder_fx.wwise_event_start
	local wwise_parameter_name = position_finder_fx.wwise_parameter_name
	local has_husk_events = position_finder_fx.has_husk_events
	local old_decal_unit = self._decal_unit
	local old_effect_id = self._effect_id
	local old_scaling_effect_id = self._scaling_effect_id
	local old_playing_id = self._targeting_playing_id
	local decal_unit, effect_id, scaling_effect_id = nil

	if decal_unit_name and not old_decal_unit then
		decal_unit = World.spawn_unit_ex(world, decal_unit_name, nil, spawn_pos)
		self._decal_unit = decal_unit
	elseif not decal_unit_name and old_decal_unit then
		World.destroy_unit(world, old_decal_unit)

		self._decal_unit = nil
	end

	if effect_name and not old_effect_id then
		effect_id = World.create_particles(world, effect_name, spawn_pos)
		self._effect_id = effect_id
	elseif not effect_name and old_effect_id then
		World.destroy_particles(world, old_effect_id)

		self._effect_id = nil
	end

	if scaling_effect_name and not old_scaling_effect_id then
		scaling_effect_id = World.create_particles(world, scaling_effect_name, spawn_pos)
		self._scaling_effect_id = scaling_effect_id

		if scale_variable_name then
			local variable_index = World.find_particles_variable(world, scaling_effect_name, scale_variable_name)
			self._scale_variable_index = variable_index
		else
			self._scale_variable_index = nil
		end
	elseif not scaling_effect_name and old_scaling_effect_id then
		World.destroy_particles(world, old_scaling_effect_id)

		self._scaling_effect_id = nil
		self._scale_variable_index = nil
	end

	if wwise_event and not old_playing_id then
		local should_use_husk_event = has_husk_events and self._fx_extension:should_play_husk_effect()

		if should_use_husk_event then
			wwise_event = wwise_event .. "_husk" or wwise_event
		end

		local playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, source_id)
		self._targeting_playing_id = playing_id
		local stop_event = position_finder_fx.wwise_event_stop
		self._wwise_event_stop = (should_use_husk_event and stop_event .. "_husk") or stop_event
	elseif not wwise_event and old_playing_id then
		local stop_event = self._wwise_event_stop

		if stop_event then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event, source_id)

			self._wwise_event_stop = nil
		else
			WwiseWorld.stop_event(wwise_world, old_playing_id)
		end

		self._targeting_playing_id = nil
	end

	self:_update_effect_positions(action_settings, self._decal_unit, self._effect_id, self._scaling_effect_id, self._scale_variable_index, self._source_id, wwise_parameter_name)
end

ForceStaffAoeTargetingEffects._update_effect_positions = function (self, action_settings, decal_unit, effect_id, scaling_effect_id, scale_variable_index, source_id, parameter_name)
	if not decal_unit and not effect_id and not source_id then
		return
	end

	local world = self._world
	local wwise_world = self._wwise_world
	local first_person_rotation = self._first_person_component.rotation
	local target_position = self._action_module_position_finder_component.position
	local charge_level = self._action_module_charge_component.charge_level
	local flat_forward_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(first_person_rotation)))
	local rotation = Quaternion.look(flat_forward_direction, Vector3.up())
	local min_scale = action_settings.min_scale
	local max_scale = action_settings.max_scale
	local scale = math.max(charge_level * max_scale, min_scale)

	if decal_unit then
		Unit.set_local_position(decal_unit, 1, target_position)
		Unit.set_local_rotation(decal_unit, 1, rotation)
		Unit.set_local_scale(decal_unit, 1, Vector3(scale, scale, 1))
	end

	if effect_id then
		World.move_particles(world, effect_id, target_position)
	end

	if scaling_effect_id then
		World.move_particles(world, scaling_effect_id, target_position)

		if scale_variable_index then
			World.set_particles_variable(world, scaling_effect_id, scale_variable_index, Vector3(scale, scale, scale))
		end
	end

	if source_id then
		WwiseWorld.set_source_position(wwise_world, source_id, target_position)

		if parameter_name then
			WwiseWorld.set_source_parameter(wwise_world, source_id, parameter_name, charge_level)
		end
	end
end

ForceStaffAoeTargetingEffects._destroy_effects = function (self)
	local world = self._world
	local wwise_world = self._wwise_world

	if self._decal_unit then
		World.destroy_unit(world, self._decal_unit)

		self._decal_unit = nil
	end

	if self._effect_id then
		World.destroy_particles(world, self._effect_id)

		self._effect_id = nil
	end

	if self._scaling_effect_id then
		World.destroy_particles(world, self._scaling_effect_id)

		self._scaling_effect_id = nil
	end

	if self._targeting_playing_id then
		local stop_event = self._wwise_event_stop

		if stop_event then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event, self._source_id)

			self._wwise_event_stop = nil
		else
			WwiseWorld.stop_event(wwise_world, self._targeting_playing_id)
		end

		self._targeting_playing_id = nil
	end
end

return ForceStaffAoeTargetingEffects
