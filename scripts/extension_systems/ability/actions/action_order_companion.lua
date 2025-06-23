-- chunkname: @scripts/extension_systems/ability/actions/action_order_companion.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local AttackSettings = require("scripts/settings/damage/attack_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local ShoutAbilityImplementation = require("scripts/extension_systems/ability/utilities/shout_ability_implementation")
local ActionOrderCompanion = class("ActionOrderCompanion", "ActionAbilityBase")

ActionOrderCompanion.init = function (self, action_context, action_params, action_settings)
	ActionOrderCompanion.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._unit_data_extension = unit_data_extension
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._triggered = false
	self._trigger_time = action_settings.trigger_time or 0

	local player_unit = self._player_unit
	local companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
	local companion_unit = companion_spawner_extension and companion_spawner_extension:companion_unit()

	self._companion_unit = companion_unit
	self._fx_system = Managers.state.extension:system("fx_system")
end

ActionOrderCompanion.start = function (self, action_settings, t, ...)
	ActionOrderCompanion.super.start(self, action_settings, t, ...)

	local anim = "ability_point"

	if anim then
		self:trigger_anim_event("ability_point")
	end

	local companion_unit = self._companion_unit

	if self._is_server and not self._fx_system:has_running_template_of_name(companion_unit, EffectTemplates.companion_dog_bark.name) then
		local template_effect_id = self._fx_system:start_template_effect(EffectTemplates.companion_dog_bark, companion_unit)

		self._template_effect_id = template_effect_id
	end
end

ActionOrderCompanion.fixed_update = function (self, dt, t, time_in_action)
	if self._is_server and not self._triggered and time_in_action >= self._trigger_time then
		local player_unit = self._player_unit
		local companion_unit = self._companion_unit

		if self._is_server and companion_unit then
			local radius = 5
			local shout_target_template_name = "adamant_shout"
			local dog_position = Unit.local_position(companion_unit, 1)
			local dog_rotation = Quaternion.identity()
			local dog_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(dog_rotation)))

			ShoutAbilityImplementation.execute(radius, shout_target_template_name, player_unit, t, nil, dog_forward, dog_position, dog_rotation)

			local vfx = "content/fx/particles/abilities/adamant/adamant_shout"
			local vfx_pos = dog_position + Vector3.up()

			self._fx_extension:spawn_particles(vfx, vfx_pos, nil, nil, nil, nil, true)

			local power_level = 500
			local attack_type = AttackSettings.attack_types.explosion
			local explosion_template = ExplosionTemplates.adamant_whistle_explosion

			Explosion.create_explosion(self._world, self._physics_world, dog_position, Vector3.up(), player_unit, explosion_template, power_level, 1, attack_type)
		end

		self._triggered = true
	end
end

ActionOrderCompanion.finish = function (self, reason, data, t, time_in_action, action_settings)
	ActionOrderCompanion.super.finish(self, reason, data, t, time_in_action, action_settings)

	self._triggered = false

	if self._is_server and self._template_effect_id and self._fx_system:has_running_template_of_name(self._companion_unit, EffectTemplates.companion_dog_bark.name) then
		self._fx_system:stop_template_effect(self._template_effect_id)

		self._template_effect_id = nil
	end
end

return ActionOrderCompanion
