-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/tox_grenade_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local FixedFrame = require("scripts/utilities/fixed_frame")
local ToxGrenadeEffects = class("ToxGrenadeEffects")
local IDLE_ALIAS = "equipped_item_passive"
local SFX_SOURCE_NAME = "_cap"
local IDLE_SFX_ALIAS = "equipped_item_passive_loop"
local STARTUP_DELAY = 0.5
local EXTERNAL_PROPERTIES = {}

ToxGrenadeEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._world = context.world
	self._physics_world = context.physics_world
	self._wwise_world = context.wwise_world
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	self._is_husk = context.is_husk
	self._is_server = context.is_server

	local owner_unit = context.owner_unit

	self._owner_unit = owner_unit
	self._unit_1p = unit_1p
	self._unit_3p = unit_3p
	self._sfx_source_name = fx_sources[SFX_SOURCE_NAME]
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._visual_loadout_extension = context.visual_loadout_extension
end

ToxGrenadeEffects.fixed_update = function (self, unit, dt, t, frame)
	if self._start_t then
		if t > self._start_t then
			self._start_t = nil

			self:_start_vfx_loop()
		else
			self:_stop_vfx_loop()
		end
	end

	if self._stop_t and t > self._stop_t then
		self._start_t = nil
		self._stop_t = nil

		self:_stop_vfx_loop()
	end
end

ToxGrenadeEffects.update = function (self, unit, dt, t)
	return
end

ToxGrenadeEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode

	if self._sfx_loop_id then
		self:_stop_vfx_loop(true)
		self:_start_vfx_loop()
	end
end

ToxGrenadeEffects.wield = function (self)
	self._start_t = STARTUP_DELAY + FixedFrame.get_latest_fixed_time()
end

ToxGrenadeEffects.unwield = function (self)
	self._start_t = nil

	self:_stop_vfx_loop(true)
end

ToxGrenadeEffects.on_action = function (self, action_settings, t)
	if action_settings.kind == "throw_grenade" then
		self._on_action_frame = FixedFrame.to_fixed_frame(t)
		self._stop_t = t + action_settings.spawn_at_time
	end
end

ToxGrenadeEffects.server_correction_occurred = function (self, unit, from_frame)
	if self._on_action_frame and from_frame < self._on_action_frame then
		self._stop_t = nil
		self._on_action_frame = nil
	end
end

ToxGrenadeEffects.destroy = function (self)
	self:_stop_vfx_loop(true)
end

ToxGrenadeEffects._start_vfx_loop = function (self)
	local resolved_vfx, vfx_name = self._visual_loadout_extension:resolve_gear_particle(IDLE_ALIAS, EXTERNAL_PROPERTIES)

	if resolved_vfx then
		local world = self._world

		self._vfx_loop_id = self._fx_extension:spawn_particles_local(vfx_name, Vector3.zero())

		local node_unit = self._is_in_first_person and self._unit_1p or self._unit_3p

		World.link_particles(world, self._vfx_loop_id, node_unit, 1, Matrix4x4.identity(), "stop")
	end

	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()
	local resolved_sfx, sfx_name, resolved_stop, stop_event_name = self._visual_loadout_extension:resolve_looping_gear_sound(IDLE_SFX_ALIAS, should_play_husk_effect, EXTERNAL_PROPERTIES)

	if resolved_sfx then
		local wwise_world = self._wwise_world
		local source_id = self._fx_extension:sound_source(self._sfx_source_name)
		local playing_id = WwiseWorld.trigger_resource_event(wwise_world, sfx_name, source_id)

		self._sfx_loop_id = playing_id

		if resolved_stop then
			self._stop_event_name = stop_event_name
		end
	end
end

ToxGrenadeEffects._stop_vfx_loop = function (self, destroy)
	if self._vfx_loop_id then
		if destroy then
			World.destroy_particles(self._world, self._vfx_loop_id)
		else
			World.stop_spawning_particles(self._world, self._vfx_loop_id)
		end

		self._vfx_loop_id = nil
	end

	local looping_passive_playing_id = self._sfx_loop_id

	if looping_passive_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._sfx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_passive_playing_id)
		end

		self._sfx_loop_id = nil
		self._stop_event_name = nil
	end
end

implements(ToxGrenadeEffects, WieldableSlotScriptInterface)

return ToxGrenadeEffects
