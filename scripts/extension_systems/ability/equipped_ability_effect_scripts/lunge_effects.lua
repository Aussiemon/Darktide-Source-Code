-- chunkname: @scripts/extension_systems/ability/equipped_ability_effect_scripts/lunge_effects.lua

local BuffSettings = require("scripts/settings/buff/buff_settings")
local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local buff_keywords = BuffSettings.keywords
local LungeEffects = class("LungeEffects")

LungeEffects.init = function (self, equipped_ability_effect_scripts_context, ability_template)
	self._is_local_unit = equipped_ability_effect_scripts_context.is_local_unit
	self._ability_template = ability_template

	local unit_data_extension = equipped_ability_effect_scripts_context.unit_data_extension

	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._is_effect_active = false

	local unit = equipped_ability_effect_scripts_context.unit

	self._unit = unit
	self._fx_extension = ScriptUnit.has_extension(unit, "fx_system")
	self._world = equipped_ability_effect_scripts_context.world
	self._buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	self._active_looping_vfx_ids = {}
	self._player_particle_group_id = equipped_ability_effect_scripts_context.player_particle_group_id
end

LungeEffects.extensions_ready = function (self, world, unit)
	self._buff_extension = ScriptUnit.has_extension(unit, "buff_system")
end

LungeEffects.destroy = function (self)
	if self._is_effect_active then
		self:_stop_effects()
		self:_destroy_looping_effects()
		self:_reset_wwise_state()
	end
end

LungeEffects.update = function (self, unit, dt, t)
	local lunge_character_state_component = self._lunge_character_state_component
	local is_lunging = lunge_character_state_component.is_lunging
	local is_effect_active = self._is_effect_active

	if is_lunging and not is_effect_active then
		self._is_effect_active = true

		local lunge_template_name = lunge_character_state_component.lunge_template

		self._lunge_template = LungeTemplates[lunge_template_name]

		self:_start_effects()
		self:_start_looping_conditional_effects()
		self:_set_wwise_state()
	elseif not is_lunging and is_effect_active then
		self._is_effect_active = false

		self:_stop_effects()
		self:_stop_looping_effects()
		self:_reset_wwise_state()
	end
end

LungeEffects._start_effects = function (self)
	local lunge_template = self._lunge_template
	local start_sound_event = lunge_template and lunge_template.start_sound_event

	if start_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(start_sound_event, false)
	end
end

LungeEffects._stop_effects = function (self)
	local lunge_template = self._lunge_template
	local stop_sound_event = lunge_template and lunge_template.stop_sound_event

	if stop_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(stop_sound_event, false)
	end
end

LungeEffects._start_looping_conditional_effects = function (self)
	local active_looping_vfx_ids = self._active_looping_vfx_ids
	local world = self._world
	local unit = self._unit
	local buff_extension = self._buff_extension
	local start_fire_trail_effect = buff_extension and buff_extension:has_keyword(buff_keywords.fire_trail_on_lunge)

	if start_fire_trail_effect then
		local fire_trail_particle_effect = "content/fx/particles/player_buffs/buff_fire_trail_01"
		local effect_position = POSITION_LOOKUP[unit]
		local orphaned_policy = "destroy"
		local rotation = Matrix4x4.rotation(Matrix4x4.identity())
		local right_trail_pose = Matrix4x4.from_quaternion_position(rotation, Vector3(0.3, 0, 0))
		local left_tril_pose = Matrix4x4.from_quaternion_position(rotation, Vector3(-0.3, 0, 0))
		local right_effect_id = World.create_particles(world, fire_trail_particle_effect, effect_position, nil, nil, self._player_particle_group_id)

		World.link_particles(world, right_effect_id, unit, 1, right_trail_pose, orphaned_policy)
		table.insert(active_looping_vfx_ids, right_effect_id)

		local left_effect_id = World.create_particles(world, fire_trail_particle_effect, effect_position, nil, nil, self._player_particle_group_id)

		World.link_particles(world, left_effect_id, unit, 1, left_tril_pose, orphaned_policy)
		table.insert(active_looping_vfx_ids, left_effect_id)
	end
end

LungeEffects._stop_looping_effects = function (self)
	local world = self._world
	local effect_ids = self._active_looping_vfx_ids
	local num_active_effects = #effect_ids

	for i = 1, num_active_effects do
		local effect_id = effect_ids[i]

		World.stop_spawning_particles(world, effect_id)

		effect_ids[i] = nil
	end
end

LungeEffects._destroy_looping_effects = function (self)
	local world = self._world
	local effect_ids = self._active_looping_vfx_ids
	local num_active_effects = #effect_ids

	for i = 1, num_active_effects do
		local effect_id = effect_ids[i]

		World.destroy_particles(world, effect_id)

		effect_ids[i] = nil
	end
end

LungeEffects._set_wwise_state = function (self)
	local lunge_template = self._lunge_template
	local wwise_state = lunge_template and lunge_template.wwise_state

	if wwise_state and self._is_local_unit then
		Wwise.set_state(wwise_state.group, wwise_state.on_state)
	end
end

LungeEffects._reset_wwise_state = function (self)
	local lunge_template = self._lunge_template
	local wwise_state = lunge_template and lunge_template.wwise_state

	if wwise_state and self._is_local_unit then
		Wwise.set_state(wwise_state.group, wwise_state.off_state)
	end
end

return LungeEffects
