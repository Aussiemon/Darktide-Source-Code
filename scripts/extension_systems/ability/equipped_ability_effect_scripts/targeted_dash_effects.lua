-- chunkname: @scripts/extension_systems/ability/equipped_ability_effect_scripts/targeted_dash_effects.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local hit_zone_names = HitZone.hit_zone_names
local SPAWN_POS = Vector3Box(400, 400, 400)
local TargetedDashEffects = class("TargetedDashEffects")

TargetedDashEffects.init = function (self, equipped_ability_effect_scripts_context, ability_template)
	self._world = equipped_ability_effect_scripts_context.world
	self._wwise_world = equipped_ability_effect_scripts_context.wwise_world
	self._ability_template = ability_template

	local equipped_ability_effect_scripts_tweak_data = ability_template.equipped_ability_effect_scripts_tweak_data

	self._targeting_fx = equipped_ability_effect_scripts_tweak_data.targeting_fx
	self._is_local_unit = equipped_ability_effect_scripts_context.is_local_unit

	local unit_data_extension = equipped_ability_effect_scripts_context.unit_data_extension

	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")

	local unit = equipped_ability_effect_scripts_context.unit

	self._unit = unit
	self._fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	self._is_aiming = false
end

TargetedDashEffects.destroy = function (self)
	self:_destroy_effects()
	self:_stop_looping_sound_event()
end

TargetedDashEffects.update = function (self, unit, dt, t)
	local targeting_fx = self._targeting_fx
	local is_local_unit = self._is_local_unit

	if not is_local_unit or not targeting_fx then
		self:_destroy_effects()

		return
	end

	local lunge_character_state_component = self._lunge_character_state_component
	local target_unit = lunge_character_state_component.lunge_target
	local is_aiming = lunge_character_state_component.is_aiming

	if is_aiming and not self._is_aiming then
		self:_start_looping_sound_event()

		self._is_aiming = is_aiming
	elseif not is_aiming and self._is_aiming then
		self:_stop_looping_sound_event()

		self._is_aiming = is_aiming
	end

	if not target_unit or not is_aiming then
		self:_destroy_effects()

		return
	end

	if not self._targeting_effect_id then
		self:_spawn_effects()
	end

	local hit_zone_name = hit_zone_names.center_mass
	local target_position = HitZone.hit_zone_center_of_mass(target_unit, hit_zone_name)

	self:_update_effect_positions(target_position)
end

TargetedDashEffects._spawn_effects = function (self)
	local world = self._world
	local spawn_pos = SPAWN_POS:unbox()
	local targeting_fx = self._targeting_fx
	local effect_id = World.create_particles(world, targeting_fx.effect_name, spawn_pos)

	self._targeting_effect_id = effect_id
end

TargetedDashEffects._destroy_effects = function (self)
	if self._targeting_effect_id then
		World.destroy_particles(self._world, self._targeting_effect_id)

		self._targeting_effect_id = nil
	end
end

TargetedDashEffects._update_effect_positions = function (self, target_position)
	local effect_id = self._targeting_effect_id

	if effect_id then
		World.move_particles(self._world, effect_id, target_position)
	end
end

TargetedDashEffects._start_looping_sound_event = function (self)
	local targeting_fx = self._targeting_fx
	local start_sound_event = targeting_fx and targeting_fx.looping_sound_start_event

	if start_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(start_sound_event, false)
	end
end

TargetedDashEffects._stop_looping_sound_event = function (self)
	local targeting_fx = self._targeting_fx
	local stop_sound_event = targeting_fx and targeting_fx.looping_sound_stop_event

	if stop_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(stop_sound_event, false)
	end
end

return TargetedDashEffects
