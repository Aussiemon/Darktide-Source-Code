local Action = require("scripts/utilities/weapon/action")
local PsykerSingleTargetEffects = class("PsykerSingleTargetEffects")
local SPAWN_POS = Vector3Box(400, 400, 400)
local SHOW_EFFECT_FOR_ALL = true

PsykerSingleTargetEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local wwise_world = context.wwise_world
	self._world = context.world
	self._wwise_world = wwise_world
	self._weapon_actions = weapon_template.actions
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._action_module_charge_component = unit_data_extension:read_component("action_module_charge")
	self._action_module_targeting_component = unit_data_extension:read_component("action_module_targeting")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	local source_id = WwiseWorld.make_manual_source(wwise_world, SPAWN_POS:unbox())
	self._targeting_effect_id = nil
	self._targeting_source_id = source_id
	self._targeting_playing_id = nil
end

PsykerSingleTargetEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PsykerSingleTargetEffects.update = function (self, unit, dt, t)
	self:_update_targeting_effects()
end

PsykerSingleTargetEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PsykerSingleTargetEffects.wield = function (self)
	self:_update_targeting_effects()
end

PsykerSingleTargetEffects.unwield = function (self)
	self:_destroy_effects()
end

PsykerSingleTargetEffects.destroy = function (self)
	self:_destroy_effects()
	WwiseWorld.destroy_manual_source(self._wwise_world, self._targeting_source_id)

	self._targeting_source_id = nil
end

PsykerSingleTargetEffects._update_targeting_effects = function (self)
	if not self._is_local_unit and not SHOW_EFFECT_FOR_ALL then
		return
	end

	local world = self._world
	local wwise_world = self._wwise_world
	local spawn_pos = SPAWN_POS:unbox()
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local targeting_fx = action_settings and action_settings.targeting_fx
	local target_unit = self._action_module_targeting_component.target_unit_1

	if not targeting_fx or not target_unit then
		self:_destroy_effects()

		return
	end

	local effect_name = targeting_fx.effect_name
	local husk_effect_name = targeting_fx.husk_effect_name or effect_name
	local last_effect_name = self._last_effect_name
	local wwise_event = targeting_fx.wwise_event_start
	local wwise_parameter_name = targeting_fx.wwise_parameter_name
	local has_husk_events = targeting_fx.has_husk_events
	local source_id = self._targeting_source_id
	local old_effect_id = self._targeting_effect_id
	local old_playing_id = self._targeting_playing_id
	local effect_id = nil
	local new_effect_name = effect_name and effect_name ~= last_effect_name

	if effect_name and (new_effect_name or not old_effect_id) then
		effect_id = World.create_particles(world, (not self._is_local_unit or self._is_husk) and husk_effect_name or effect_name, spawn_pos)
		self._targeting_effect_id = effect_id
		self._last_effect_name = effect_name

		if new_effect_name and old_effect_id then
			World.destroy_particles(world, old_effect_id)
		end
	elseif not effect_name and old_effect_id then
		World.destroy_particles(world, old_effect_id)

		self._targeting_effect_id = nil
	end

	if wwise_event and not old_playing_id then
		if not self._is_local_unit or self._is_husk and has_husk_events then
			wwise_event = wwise_event .. "_husk" or wwise_event
		end

		local playing_id = WwiseWorld.trigger_resource_event(wwise_world, wwise_event, source_id)
		self._targeting_playing_id = playing_id
		local stop_event = targeting_fx.wwise_event_stop
		self._wwise_event_stop = (not self._is_local_unit or self._is_husk and has_husk_events) and stop_event .. "_husk" or stop_event
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

	local node = Unit.node(target_unit, "j_head")
	local position = Unit.world_position(target_unit, node)

	self:_update_effect_positions(position, self._targeting_effect_id, self._targeting_source_id, wwise_parameter_name)
end

PsykerSingleTargetEffects._update_effect_positions = function (self, target_position, effect_id, source_id, parameter_name)
	if not effect_id and not source_id then
		return
	end

	local world = self._world
	local wwise_world = self._wwise_world
	local charge_level = self._action_module_charge_component.charge_level

	if effect_id then
		World.move_particles(world, effect_id, target_position)
	end

	if source_id then
		WwiseWorld.set_source_position(wwise_world, source_id, target_position)

		if parameter_name then
			WwiseWorld.set_source_parameter(wwise_world, source_id, parameter_name, charge_level)
		end
	end
end

PsykerSingleTargetEffects._destroy_effects = function (self)
	local world = self._world
	local wwise_world = self._wwise_world

	if self._targeting_decal_unit then
		World.destroy_unit(world, self._targeting_decal_unit)

		self._targeting_decal_unit = nil
	end

	if self._targeting_effect_id then
		World.destroy_particles(world, self._targeting_effect_id)

		self._targeting_effect_id = nil
	end

	if self._targeting_playing_id then
		local stop_event = self._wwise_event_stop

		if stop_event then
			WwiseWorld.trigger_resource_event(wwise_world, stop_event, self._targeting_source_id)

			self._wwise_event_stop = nil
		else
			WwiseWorld.stop_event(wwise_world, self._targeting_playing_id)
		end

		self._targeting_playing_id = nil
	end
end

return PsykerSingleTargetEffects
