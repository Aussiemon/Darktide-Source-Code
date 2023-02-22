local AmmoCountEffects = class("AmmoCountEffects")
local WWISE_PARAMETER_NAME = "weapon_ammo_count"

AmmoCountEffects.init = function (self, context, slot, weapon_template, fx_sources)
	local unit_data_extension = context.unit_data_extension
	self._owner_unit = context.owner_unit
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._slot = slot
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._fx_extension = context.fx_extension
	self._muzzle_fx_source_name = fx_sources._muzzle
	self._last_clip_size = 0
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
end

AmmoCountEffects.destroy = function (self)
	return
end

AmmoCountEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

AmmoCountEffects.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local current_clip = inventory_slot_component.current_ammunition_clip

	if self._last_clip_size ~= current_clip then
		local muzzle_source = self._fx_extension:sound_source(self._muzzle_fx_source_name)
		local wwise_world = self._wwise_world
		local max_clip = inventory_slot_component.max_ammunition_clip
		local ammo_percentage = max_clip > 0 and current_clip / max_clip * 100 or 0

		WwiseWorld.set_global_parameter(wwise_world, WWISE_PARAMETER_NAME, ammo_percentage)
		WwiseWorld.set_source_parameter(wwise_world, muzzle_source, WWISE_PARAMETER_NAME, ammo_percentage)

		self._last_clip_size = current_clip
	end
end

AmmoCountEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

AmmoCountEffects.wield = function (self)
	return
end

AmmoCountEffects.unwield = function (self)
	return
end

return AmmoCountEffects
