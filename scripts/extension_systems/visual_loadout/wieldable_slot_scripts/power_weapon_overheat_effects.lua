-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/power_weapon_overheat_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local PowerWeaponOverheatEffects = class("PowerWeaponOverheatEffects")
local PARTICLE_STAGE_LOOP_FX = "weapon_overload_loop"
local FX_SOURCE_NAME = "_special_active"
local THRESHOLDS = {
	high = 0.7,
	critical = 0.9,
	low = 0.3
}
local STAGE_RANKING = {
	high = 2,
	critical = 3,
	low = 1
}
local _external_properties = {}

PowerWeaponOverheatEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = context.unit_data_extension
	local fx_extension = context.fx_extension
	local visual_loadout_extension = context.visual_loadout_extension

	self._owner_unit = owner_unit
	self._world = context.world
	self._visual_loadout_extension = visual_loadout_extension
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._special_active_fx_source_name = fx_sources[FX_SOURCE_NAME]
	self._vfx_link_unit, self._vfx_link_node = fx_extension:vfx_spawner_unit_and_node(fx_sources[FX_SOURCE_NAME])
end

PowerWeaponOverheatEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

PowerWeaponOverheatEffects.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local overheat_percentage = inventory_slot_component.overheat_current_percentage
	local overheat_state = inventory_slot_component.overheat_state
	local special_active = inventory_slot_component.special_active
	local wants_fx = overheat_state ~= "idle" or special_active

	if wants_fx then
		local thresholds = THRESHOLDS
		local current_overheat = self._current_overheat
		local current_stage = self._current_stage
		local num_charges = self._inventory_slot_component.num_special_charges

		if overheat_state == "idle" and current_overheat ~= overheat_percentage then
			local wanted_stage

			wanted_stage = overheat_percentage >= thresholds.critical and "critical" or overheat_percentage >= thresholds.high and "high" or "low"

			local stage_changed = current_stage ~= wanted_stage

			if stage_changed then
				self:_update_stage_loop(unit, dt, t, current_stage, wanted_stage)
			end

			self._current_stage = wanted_stage
		elseif overheat_state == "lockout" then
			local wanted_stage = "critical"

			self:_update_stage_loop(unit, dt, t, current_stage, wanted_stage)

			self._current_stage = wanted_stage
		end

		self._current_overheat = num_charges
	else
		self:_stop_stage_loop()
	end
end

PowerWeaponOverheatEffects._update_stage_loop = function (self, unit, dt, t, current_stage, wanted_stage)
	if current_stage == wanted_stage then
		return
	end

	local trigger_fx = STAGE_RANKING[wanted_stage] > 1
	local stop_fx = STAGE_RANKING[wanted_stage] <= 1

	if trigger_fx then
		self:_stop_stage_loop()

		local visual_loadout_extension = self._visual_loadout_extension

		_external_properties.stage = wanted_stage

		local resolved, effect_name = visual_loadout_extension:resolve_gear_particle(PARTICLE_STAGE_LOOP_FX, _external_properties)

		if resolved then
			local world = self._world
			local new_effect_id = World.create_particles(world, effect_name, Vector3.zero())

			World.link_particles(world, new_effect_id, self._vfx_link_unit, self._vfx_link_node, Matrix4x4.identity(), "stop")

			self._looping_stage_effect_id = new_effect_id
		end
	elseif stop_fx then
		self:_stop_stage_loop()
	end
end

PowerWeaponOverheatEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

PowerWeaponOverheatEffects.destroy = function (self)
	self:_stop_stage_loop(true)
end

PowerWeaponOverheatEffects.wield = function (self)
	return
end

PowerWeaponOverheatEffects.unwield = function (self)
	self:_stop_stage_loop(true)
end

PowerWeaponOverheatEffects._stop_stage_loop = function (self, force_stop)
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

implements(PowerWeaponOverheatEffects, WieldableSlotScriptInterface)

return PowerWeaponOverheatEffects
