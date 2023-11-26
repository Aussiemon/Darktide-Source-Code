-- chunkname: @scripts/extension_systems/weakspot/weakspot_extension.lua

local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local WeakspotExtension = class("WeakspotExtension")

WeakspotExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._breed = extension_init_data.breed
	self._weakspot_config = self._breed.weakspot_config
	self._unit = unit
end

WeakspotExtension.weakspot_attacked = function (self, attacking_unit, attack_result, damage_dealt, damage_efficiency, hit_zone_name, hit_world_position, attack_direction)
	local config = self._weakspot_config
	local impact_fx = config.impact_fx

	if impact_fx then
		local hit_actor, hit_normal, impact_fx_data, attack_was_stopped, damage_profile, attack_type
		local damage_type = impact_fx.damage_type

		ImpactEffect.play(self._unit, hit_actor, damage_dealt, damage_type, hit_zone_name, attack_result, hit_world_position, hit_normal, attack_direction, attacking_unit, impact_fx_data, attack_was_stopped, attack_type, damage_efficiency, damage_profile)
	end
end

return WeakspotExtension
