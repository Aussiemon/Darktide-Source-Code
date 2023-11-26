-- chunkname: @scripts/extension_systems/shield/prop_shield_extension.lua

local PropShieldExtension = class("PropShieldExtension")

PropShieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	self._shield_actors = {}
end

PropShieldExtension.setup_from_component = function (self, actor_names)
	local unit = self._unit
	local shield_actors = self._shield_actors

	for i = 1, #actor_names do
		shield_actors[Unit.actor(unit, actor_names[i])] = true
	end
end

PropShieldExtension.update = function (self, context, dt, t)
	return
end

PropShieldExtension.set_blocking = function (self, is_blocking)
	ferror("PropShieldExtension does not support set_blocking.")
end

PropShieldExtension.is_blocking = function (self)
	ferror("PropShieldExtension does not support is_blocking.")
end

PropShieldExtension.can_block_from_position = function (self, attacking_unit_position)
	return false
end

PropShieldExtension.can_block_attack = function (self, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor)
	if self._shield_actors[hit_actor] then
		return true
	end

	return false
end

PropShieldExtension.apply_stagger = function (self, unit, damage_profile, stagger_strength, attack_result, stagger_type, duration_scale, length_scale)
	ferror("PropShieldExtension does not support stagger.")
end

return PropShieldExtension
