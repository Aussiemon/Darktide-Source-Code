-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/dual_wielded_idling_effects.lua

require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wielded_idling_effects")

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local DualWieldedIdlingEffects = class("DualWieldedIdlingEffects", "WieldedIdlingEffects")
local LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local LEFT_REFERENCE_ATTACHMENT_NAME = "left"
local RIGHT_REFERENCE_ATTACHMENT_NAME = "right"

DualWieldedIdlingEffects._init_looping_variables = function (self)
	self._current_looping_playing_ids = {}
	self._current_looping_stop_event_names = {}
	self._current_looping_effect_ids = {}

	self:_set_looping_playing_id(nil, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_set_looping_stop_event_name(nil, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_set_looping_effect_id(nil, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_set_looping_playing_id(nil, RIGHT_REFERENCE_ATTACHMENT_NAME)
	self:_set_looping_stop_event_name(nil, RIGHT_REFERENCE_ATTACHMENT_NAME)
	self:_set_looping_effect_id(nil, RIGHT_REFERENCE_ATTACHMENT_NAME)
end

DualWieldedIdlingEffects.destroy = function (self)
	self:_stop_sfx_loop(true, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_vfx_loop(true, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_sfx_loop(true, RIGHT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_vfx_loop(true, RIGHT_REFERENCE_ATTACHMENT_NAME)
end

DualWieldedIdlingEffects.wield = function (self)
	self:_start_sfx_loop(LOOPING_SOUND_ALIAS, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_start_sfx_loop(LOOPING_SOUND_ALIAS, RIGHT_REFERENCE_ATTACHMENT_NAME)
	self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS, RIGHT_REFERENCE_ATTACHMENT_NAME)
end

DualWieldedIdlingEffects.unwield = function (self)
	self:_stop_sfx_loop(nil, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_vfx_loop(nil, LEFT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_sfx_loop(nil, RIGHT_REFERENCE_ATTACHMENT_NAME)
	self:_stop_vfx_loop(nil, RIGHT_REFERENCE_ATTACHMENT_NAME)
end

DualWieldedIdlingEffects.update = function (self, unit, dt, t)
	if not self:_looping_playing_id(LEFT_REFERENCE_ATTACHMENT_NAME) then
		self:_start_sfx_loop(LOOPING_SOUND_ALIAS, LEFT_REFERENCE_ATTACHMENT_NAME)
	end

	if not self:_looping_effect_id(LEFT_REFERENCE_ATTACHMENT_NAME) then
		self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS, LEFT_REFERENCE_ATTACHMENT_NAME)
	end

	if not self:_looping_playing_id(RIGHT_REFERENCE_ATTACHMENT_NAME) then
		self:_start_sfx_loop(LOOPING_SOUND_ALIAS, RIGHT_REFERENCE_ATTACHMENT_NAME)
	end

	if not self:_looping_effect_id(RIGHT_REFERENCE_ATTACHMENT_NAME) then
		self:_start_vfx_loop(LOOPING_PARTICLE_ALIAS, RIGHT_REFERENCE_ATTACHMENT_NAME)
	end
end

DualWieldedIdlingEffects.update_first_person_mode = function (self, first_person_mode)
	if self._first_person_mode ~= first_person_mode then
		self:_stop_sfx_loop(true, LEFT_REFERENCE_ATTACHMENT_NAME)
		self:_stop_vfx_loop(true, LEFT_REFERENCE_ATTACHMENT_NAME)
		self:_stop_sfx_loop(true, RIGHT_REFERENCE_ATTACHMENT_NAME)
		self:_stop_vfx_loop(true, RIGHT_REFERENCE_ATTACHMENT_NAME)

		self._first_person_mode = first_person_mode
	end
end

DualWieldedIdlingEffects._looping_playing_id = function (self, optional_reference_attachment_name)
	return self._current_looping_playing_ids[optional_reference_attachment_name]
end

DualWieldedIdlingEffects._looping_stop_event_name = function (self, optional_reference_attachment_name)
	return self._current_looping_stop_event_names[optional_reference_attachment_name]
end

DualWieldedIdlingEffects._looping_effect_id = function (self, optional_reference_attachment_name)
	return self._current_looping_effect_ids[optional_reference_attachment_name]
end

DualWieldedIdlingEffects._set_looping_playing_id = function (self, looping_playing_id, optional_reference_attachment_name)
	self._current_looping_playing_ids[optional_reference_attachment_name] = looping_playing_id
end

DualWieldedIdlingEffects._set_looping_stop_event_name = function (self, looping_stop_event_name, optional_reference_attachment_name)
	self._current_looping_stop_event_names[optional_reference_attachment_name] = looping_stop_event_name
end

DualWieldedIdlingEffects._set_looping_effect_id = function (self, looping_effect_id, optional_reference_attachment_name)
	self._current_looping_effect_ids[optional_reference_attachment_name] = looping_effect_id
end

implements(DualWieldedIdlingEffects, WieldableSlotScriptInterface)

return DualWieldedIdlingEffects
