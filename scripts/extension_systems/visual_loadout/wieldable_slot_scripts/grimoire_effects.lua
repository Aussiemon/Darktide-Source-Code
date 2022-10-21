local Action = require("scripts/utilities/weapon/action")
local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local GrimoireEffects = class("GrimoireEffects")
local EQUIPPED_LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local EQUIPPED_LOOPING_PARTICLE = "equipped_item_passive"
local DESTROY_PARTICLE_ALIAS = "grimoire_destroy"
local DISCARD_START_SOUND_ALIAS = "windup_start"
local DISCARD_STOP_SOUND_ALIAS = "windup_stop"
local SOURCE_NAME = "_passive"
local DESTROY_TIME = 0.2
local EXTERNAL_PROPERTIES = {}

GrimoireEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit
	local is_husk = context.is_husk
	self._world = context.world
	self._weapon_actions = weapon_template.actions
	self._slot = slot
	self._is_husk = is_husk
	self._playing_id = nil
	self._destroy_particle_id = nil
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension
	self._fx_extension = fx_extension
	self._visual_loadout_extension = visual_loadout_extension
	self._weapon_extension = ScriptUnit.has_extension(owner_unit, "weapon_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	if not is_husk then
		local looping_sound_component_name = PlayerUnitData.looping_sound_component_name(EQUIPPED_LOOPING_SOUND_ALIAS)
		self._looping_sound_component = unit_data_extension:read_component(looping_sound_component_name)
	end

	local fx_source_name = fx_sources[SOURCE_NAME]
	self._fx_source_name = fx_source_name
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_source_name)
end

GrimoireEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

GrimoireEffects.update = function (self, unit, dt, t)
	self:_update_effects()
end

GrimoireEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

GrimoireEffects.wield = function (self)
	self:_start_effects()
end

GrimoireEffects.unwield = function (self)
	self:_update_effects()
	self:_destroy_effects()
end

GrimoireEffects.destroy = function (self)
	self:_update_effects()
	self:_destroy_effects()
end

GrimoireEffects._update_effects = function (self)
	local weapon_action_component = self._weapon_action_component
	local time_in_action = Managers.time:time("gameplay") - weapon_action_component.start_t
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)

	self:_update_discard(time_in_action, action_settings)
	self:_update_destroy(time_in_action, action_settings)
end

GrimoireEffects._update_discard = function (self, time_in_action, action_settings)
	if not action_settings or self._is_husk then
		return
	end

	local fx_extension = self._fx_extension
	local source_name = self._fx_source_name
	local sync_to_clients = false
	local include_client = false
	local action_kind = action_settings.kind

	if action_kind == "windup" and not self._playing_id then
		self._playing_id = fx_extension:trigger_gear_wwise_event_with_source(DISCARD_START_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)
	elseif action_kind ~= "windup" and self._playing_id then
		fx_extension:trigger_gear_wwise_event_with_source(DISCARD_STOP_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)

		self._playing_id = nil
	end
end

GrimoireEffects._update_destroy = function (self, time_in_action, action_settings)
	if not action_settings then
		return
	end

	local fx_extension = self._fx_extension
	local source_name = self._fx_source_name
	local action_kind = action_settings.kind

	if action_kind == "discard" and DESTROY_TIME < time_in_action and not self._destroy_particle_id then
		self:_destroy_effects()

		self._destroy_particle_id = fx_extension:spawn_gear_particle_effect_with_source(DESTROY_PARTICLE_ALIAS, EXTERNAL_PROPERTIES, source_name, true, "stop")
		local unit_1p = self._slot.parent_unit_1p
		local unit_3p = self._slot.parent_unit_3p

		Unit.set_unit_visibility(unit_1p, false, true)
		Unit.set_unit_visibility(unit_3p, false, true)
	end
end

GrimoireEffects._start_effects = function (self)
	if not self._looping_effect_id then
		local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(EQUIPPED_LOOPING_PARTICLE, EXTERNAL_PROPERTIES)

		if resolved then
			local world = self._world
			local effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, effect_id, self._vfx_link_unit, self._vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_effect_id = effect_id
		end
	end

	if self._is_husk then
		return
	end

	local fx_source_name = self._fx_source_name
	local sound_started = self._looping_sound_component.is_playing

	if not sound_started then
		self._fx_extension:trigger_looping_wwise_event(EQUIPPED_LOOPING_SOUND_ALIAS, fx_source_name)
	end
end

GrimoireEffects._destroy_effects = function (self)
	if self._looping_effect_id then
		World.destroy_particles(self._world, self._looping_effect_id)

		self._looping_effect_id = nil
	end

	if self._is_husk then
		return
	end

	local sound_started = self._looping_sound_component.is_playing

	if sound_started then
		self._fx_extension:stop_looping_wwise_event(EQUIPPED_LOOPING_SOUND_ALIAS)
	end

	self._destroy_particle_id = nil
end

return GrimoireEffects
