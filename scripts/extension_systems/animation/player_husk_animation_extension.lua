-- chunkname: @scripts/extension_systems/animation/player_husk_animation_extension.lua

local PlayerUnitAnimationState = require("scripts/extension_systems/animation/utilities/player_unit_animation_state")
local PlayerHuskAnimationExtension = class("PlayerHuskAnimationExtension")

PlayerHuskAnimationExtension.init = function (self, extension_init_context, unit, extension_init_data)
	self._unit = unit

	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()

	self._first_person_unit = first_person_unit
	self._anim_variable_ids_third_person = {}
	self._anim_variable_ids_first_person = {}

	PlayerUnitAnimationState.cache_anim_variable_ids(unit, first_person_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
end

PlayerHuskAnimationExtension.anim_event = function (self, event_name)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_with_variable_float = function (self, event_name, variable_name, variable_value)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_with_variable_floats = function (self, event_name, ...)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_with_variable_int = function (self, event_name, ...)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_1p = function (self, event_name)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_with_variable_float_1p = function (self, event_name, variable_name, variable_value)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.anim_event_with_variable_floats_1p = function (self, event_name, ...)
	error("Not allowed to play animations on husk.")
end

PlayerHuskAnimationExtension.inventory_slot_wielded = function (self, weapon_template)
	local unit, first_person_unit, is_local_unit = self._unit, self._first_person_unit, false

	PlayerUnitAnimationState.set_anim_state_machine(unit, first_person_unit, weapon_template, is_local_unit, self._anim_variable_ids_third_person, self._anim_variable_ids_first_person)
end

PlayerHuskAnimationExtension.anim_variable_id = function (self, anim_variable)
	return self._anim_variable_ids_third_person[anim_variable]
end

PlayerHuskAnimationExtension.anim_variable_id_1p = function (self, anim_variable)
	return self._anim_variable_ids_first_person[anim_variable]
end

PlayerHuskAnimationExtension.destroy = function (self)
	return
end

return PlayerHuskAnimationExtension
