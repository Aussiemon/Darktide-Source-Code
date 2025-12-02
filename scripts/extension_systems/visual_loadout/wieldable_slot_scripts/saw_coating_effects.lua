-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/saw_coating_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local SawCoatingEffects = class("SawCoatingEffects")
local VFX_LOOP_ALIASES = {
	cloud_alias = "weapon_special_custom",
	slash_drips_alias = "weapon_special_custom_sweep",
}
local FX_IDLE_SOURCE_NAME = "_idle_drips"
local FX_SLASH_SOURCE_NAME = "_slash_drips"
local WIELD_STARTUP_DELAY = 0.3
local SLASH_DRIPS_DURATION = 0.6
local SLASH_DRIPS_STARTUP_DELAY = 0.2
local COLOR_TRANSITION_DELAY = 0.3
local COLOR_TRANSITION_DURATION = 0.53
local EXTERNAL_PROPERTIES = {}

SawCoatingEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
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
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._visual_loadout_extension = context.visual_loadout_extension

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name

	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._weapon_actions = weapon_template.actions
	self._fx_sources = fx_sources
	self._color_transition_state = "idle"
	self._color_start_value = 0
	self._color_target_value = 1
	self._color_transition_value = 0
	self._color_transition_start_time = 0
	self._loop_ids = {}
	self._loop_start_t = {}
end

SawCoatingEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

SawCoatingEffects.update = function (self, unit, dt, t)
	self._t = t

	self:_update_weapon_special(dt, t)
	self:_update_coating_color(dt, t)
end

SawCoatingEffects._update_coating_color = function (self, dt, t)
	if self._color_transition_state == "waiting" then
		if t >= self._color_transition_start_time then
			self._color_transition_state = "transitioning"
			self._color_transition_start_time = t
		end
	elseif self._color_transition_state == "transitioning" then
		local time = (t - self._color_transition_start_time) / COLOR_TRANSITION_DURATION
		local include_children = true

		if time >= 1 then
			time = 1
			self._color_transition_state = "idle"
		end

		self._color_transition_value = self._color_start_value + (self._color_target_value - self._color_start_value) * time

		Unit.set_scalar_for_materials(self._unit_1p, "color_transition_mask", self._color_transition_value, include_children)
		Unit.set_scalar_for_materials(self._unit_3p, "color_transition_mask", self._color_transition_value, include_children)
	end
end

SawCoatingEffects.update_first_person_mode = function (self, first_person_mode)
	self._is_in_first_person = first_person_mode
	self._restart_vfx_t = self._t
end

SawCoatingEffects.wield = function (self)
	self:_reset_coating_color()

	self._is_special_active = self._inventory_slot_component.special_active
	self._restart_vfx_t = WIELD_STARTUP_DELAY + Managers.time:time("gameplay")

	local t = Managers.time:time("gameplay")

	self:_start_vfx_loop(VFX_LOOP_ALIASES.cloud_alias, FX_IDLE_SOURCE_NAME, t)
end

SawCoatingEffects.unwield = function (self)
	if self._color_transition_state == "transitioning" then
		self._color_transition_state = "idle"
		self._color_transition_value = self._color_target_value

		Unit.set_scalar_for_materials(self._unit_1p, "color_transition_mask", self._color_transition_value, true)
		Unit.set_scalar_for_materials(self._unit_3p, "color_transition_mask", self._color_transition_value, true)

		local invert_transition = self._is_special_active and 0 or 1

		Unit.set_scalar_for_materials(self._unit_1p, "color_transition_invert", invert_transition, true)
		Unit.set_scalar_for_materials(self._unit_3p, "color_transition_invert", invert_transition, true)
	end

	for _, alias in pairs(VFX_LOOP_ALIASES) do
		if self._loop_ids[alias] then
			self:_stop_vfx_loop(true, self._loop_ids[alias])
		end
	end
end

SawCoatingEffects.server_correction_occurred = function (self, unit, from_frame)
	local fixed_t = from_frame * Managers.state.game_session.fixed_time_step

	for loop_id, t in pairs(self._loop_start_t) do
		if fixed_t <= t then
			self:_stop_vfx_loop(true, loop_id)
		end
	end
end

SawCoatingEffects.on_sweep_start = function (self, t)
	local slash_drips_alias = VFX_LOOP_ALIASES.slash_drips_alias

	if self._loop_ids[slash_drips_alias] then
		self:_stop_vfx_loop(false, self._loop_ids[slash_drips_alias])
	end

	self._start_slash_drips_at_t = t + SLASH_DRIPS_STARTUP_DELAY
	self._slash_drips_end_t = self._t + SLASH_DRIPS_DURATION
end

SawCoatingEffects.on_sweep_finish = function (self)
	local slash_drips_alias = VFX_LOOP_ALIASES.slash_drips_alias

	if self._loop_ids[slash_drips_alias] then
		self:_stop_vfx_loop(false, self._loop_ids[slash_drips_alias])
	end
end

SawCoatingEffects.on_sweep_hit = function (self)
	if self._slash_drips_end_t then
		self._slash_drips_end_t = self._t + SLASH_DRIPS_DURATION
	end
end

SawCoatingEffects.on_exit_damage_window = function (self)
	return
end

SawCoatingEffects.on_weapon_special_toggle = function (self)
	self._color_start_value = 0
	self._color_target_value = 1
	self._color_transition_start_time = Managers.time:time("gameplay") + COLOR_TRANSITION_DELAY
	self._color_transition_state = "waiting"

	local invert_transition = self._is_special_active and 1 or 0

	Unit.set_scalar_for_materials(self._unit_1p, "color_transition_invert", invert_transition, true)
	Unit.set_scalar_for_materials(self._unit_3p, "color_transition_invert", invert_transition, true)
	Unit.set_scalar_for_materials(self._unit_1p, "color_transition_mask", self._color_start_value, true)
	Unit.set_scalar_for_materials(self._unit_3p, "color_transition_mask", self._color_start_value, true)
end

SawCoatingEffects.on_weapon_special_toggle_finished = function (self, reason)
	if reason ~= "action_complete" then
		self:_reset_coating_color()

		self._color_transition_state = "idle"
	end
end

SawCoatingEffects._reset_coating_color = function (self)
	self._color_transition_state = "idle"
	self._color_target_value = 1
	self._color_transition_value = 0
	self._color_transition_start_time = 0
	self._color_start_value = 0

	Unit.set_scalar_for_materials(self._unit_1p, "color_transition_mask", self._color_target_value, true)
	Unit.set_scalar_for_materials(self._unit_3p, "color_transition_mask", self._color_target_value, true)

	local invert_transition = self._is_special_active and 0 or 1

	Unit.set_scalar_for_materials(self._unit_1p, "color_transition_invert", invert_transition, true)
	Unit.set_scalar_for_materials(self._unit_3p, "color_transition_invert", invert_transition, true)
end

SawCoatingEffects._reset_cloud = function (self)
	local cloud_alias = VFX_LOOP_ALIASES.cloud_alias

	if self._loop_ids[cloud_alias] then
		self:_stop_vfx_loop(true, self._loop_ids[cloud_alias])
	end

	self:_start_vfx_loop(cloud_alias, FX_IDLE_SOURCE_NAME, self._t)
end

SawCoatingEffects.destroy = function (self)
	for _, alias in pairs(VFX_LOOP_ALIASES) do
		if self._loop_ids[alias] then
			self:_stop_vfx_loop(true, self._loop_ids[alias])
		end
	end
end

SawCoatingEffects._update_weapon_special = function (self, dt, t)
	local restart = self._restart_vfx_t and t > self._restart_vfx_t
	local slash_drips_alias = VFX_LOOP_ALIASES.slash_drips_alias
	local is_special_active = self._inventory_slot_component.special_active

	if self._is_special_active ~= is_special_active then
		self._is_special_active = is_special_active

		self:_reset_coating_color()
		self:_reset_cloud()
	end

	if self._start_slash_drips_at_t and t > self._start_slash_drips_at_t and not self._loop_ids[slash_drips_alias] then
		self:_start_vfx_loop(slash_drips_alias, FX_SLASH_SOURCE_NAME, t)

		self._start_slash_drips_at_t = nil
	end

	if self._slash_drips_end_t and t > self._slash_drips_end_t and self._loop_ids[slash_drips_alias] then
		self:_stop_vfx_loop(false, self._loop_ids[slash_drips_alias])

		self._slash_drips_end_t = nil
	end

	if restart then
		self:_reset_cloud()

		self._restart_vfx_t = false
	end
end

SawCoatingEffects._start_vfx_loop = function (self, particle_alias, fx_source_name, t)
	table.clear(EXTERNAL_PROPERTIES)

	self._is_special_active = self._inventory_slot_component.special_active
	EXTERNAL_PROPERTIES.special_active = self._is_special_active and "true" or "false"

	local resolved, effect_name = self._visual_loadout_extension:resolve_gear_particle(particle_alias, EXTERNAL_PROPERTIES)

	if resolved then
		local world = self._world
		local fx_extension = self._fx_extension
		local new_effect_id = fx_extension:spawn_particles_local(effect_name, Vector3.zero())
		local node_unit_1p, node_1p, node_unit_3p, node_3p = fx_extension:vfx_spawner_unit_and_node(self._fx_sources[fx_source_name])
		local node_unit = self._is_in_first_person and node_unit_1p or node_unit_3p
		local node = self._is_in_first_person and node_1p or node_3p

		World.link_particles(world, new_effect_id, node_unit, node, Matrix4x4.identity(), "stop")

		self._loop_ids[particle_alias] = new_effect_id
		self._loop_start_t[new_effect_id] = t

		return new_effect_id
	end
end

SawCoatingEffects._stop_vfx_loop = function (self, destroy, loop_id)
	if loop_id then
		if destroy then
			World.destroy_particles(self._world, loop_id)
		else
			World.stop_spawning_particles(self._world, loop_id)
		end
	end

	self._loop_start_t[loop_id] = nil

	for alias, id in pairs(self._loop_ids) do
		if id == loop_id then
			self._loop_ids[alias] = nil
		end
	end
end

implements(SawCoatingEffects, WieldableSlotScriptInterface)

return SawCoatingEffects
