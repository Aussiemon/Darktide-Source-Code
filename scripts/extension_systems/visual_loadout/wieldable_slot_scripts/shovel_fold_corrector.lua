local ShovelFoldCorrector = class("ShovelFoldCorrector")

ShovelFoldCorrector.init = function (self, context, slot, weapon_template, fx_sources)
	self._is_server = context.is_server
	self._is_local_unit = context.is_local_unit
	local owner_unit = context.owner_unit
	self._owner_unit = owner_unit
	self._animation_extension = ScriptUnit.extension(owner_unit, "animation_system")
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
end

ShovelFoldCorrector.server_correction_occurred = function (self, unit, from_frame)
	self._trigger_fold = true
end

ShovelFoldCorrector.fixed_update = function (self, unit, dt, t, frame)
	return
end

local activate_anim_event = "activate_mispredict"
local deactivate_anim_event = "deactivate_mispredict"

ShovelFoldCorrector.update = function (self, unit, dt, t)
	if not self._is_server and self._wielded and self._trigger_fold then
		local special_active = self._inventory_slot_component.special_active
		local anim_event = special_active and activate_anim_event or deactivate_anim_event
		local anim_ext = self._animation_extension

		anim_ext:anim_event_with_variable_floats_1p(anim_event)
		anim_ext:anim_event_with_variable_floats(anim_event)
	end

	self._trigger_fold = false
end

ShovelFoldCorrector.wield = function (self)
	self._wielded = true
end

ShovelFoldCorrector.unwield = function (self)
	self._wielded = false
end

ShovelFoldCorrector.update_first_person_mode = function (self, first_person_mode)
	return
end

ShovelFoldCorrector.destroy = function (self)
	return
end

return ShovelFoldCorrector
