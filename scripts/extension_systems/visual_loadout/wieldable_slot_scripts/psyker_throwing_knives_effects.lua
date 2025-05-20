-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/psyker_throwing_knives_effects.lua

local Component = require("scripts/utilities/component")
local Vo = require("scripts/utilities/vo")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local _components
local RECOVER_SOUND_ALIAS = "charge_ready_indicator"
local LOOPING_SOUND_ALIAS = "equipped_item_passive_loop"
local LOOPING_PARTICLE_ALIAS = "equipped_item_passive"
local SFX_SOURCE_NAME = "_right"
local ATTACHMENT_NAMES = {
	"shard_01",
	"shard_02",
	"shard_03",
	"shard_04",
}
local _external_properties = {}
local PsykerThrowingKnivesEffects = class("PsykerThrowingKnivesEffects")

PsykerThrowingKnivesEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit

	self._owner_unit = owner_unit
	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._sfx_source_name = fx_sources[SFX_SOURCE_NAME]
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension
	self._ability_extension = ScriptUnit.extension(owner_unit, "ability_system")
	self._fx_sources = fx_sources
	self._t = 0
	self._first_person_mode = true
	self._remaining_ability_charges = 0

	local visible_knives = {}

	for ii = 1, #ATTACHMENT_NAMES do
		visible_knives[ATTACHMENT_NAMES[ii]] = false
	end

	self._visible_knives = visible_knives
	self._components_1p = {}
	self._components_3p = {}
	self._components_lookup_1p = {}
	self._components_lookup_3p = {}

	_components(self._components_1p, self._components_lookup_1p, slot.attachments_by_unit_1p[unit_1p], slot.attachment_map_by_unit_1p[unit_1p])
	_components(self._components_3p, self._components_lookup_3p, slot.attachments_by_unit_3p[unit_3p], slot.attachment_map_by_unit_3p[unit_3p])

	if self._components_1p[1] then
		local num_visibility_groups = self._components_1p[1].component:num_visibility_groups()

		for ii = 1, #ATTACHMENT_NAMES do
			self._components_1p[ii].component:set_visibility_group_index(ii)
			self._components_3p[ii].component:set_visibility_group_index(ii)
		end
	end
end

PsykerThrowingKnivesEffects.fixed_update = function (self, unit, dt, t)
	return
end

PsykerThrowingKnivesEffects.update = function (self, unit, dt, t, frame)
	self._remaining_ability_charges = self._ability_extension:remaining_ability_charges("grenade_ability")
	self._t = t

	local any_visible = self:_update_ammo_count(t)

	if any_visible then
		self:_create_passive_sfx()
	else
		self:_destroy_passive_sfx()
	end
end

PsykerThrowingKnivesEffects.update_first_person_mode = function (self, first_person_mode)
	self._first_person_mode = first_person_mode

	self:_hide_all_ammo()
	self:_update_ammo_count(self._t)
end

PsykerThrowingKnivesEffects.wield = function (self)
	Vo.play_combat_ability_event(self._owner_unit, "ability_gunslinger")
	self:_hide_all_ammo()
	self:_update_ammo_count(self._t)
end

PsykerThrowingKnivesEffects.unwield = function (self)
	self:_hide_all_ammo()
end

PsykerThrowingKnivesEffects.destroy = function (self)
	return
end

PsykerThrowingKnivesEffects._update_ammo_count = function (self, t)
	local remaining_ability_charges = self._remaining_ability_charges
	local components_lookup = self._first_person_mode and self._components_lookup_1p or self._components_lookup_3p
	local visible_knives = self._visible_knives
	local any_visible = false
	local _, effect_name, event_name

	for ii = #ATTACHMENT_NAMES, 1, -1 do
		local attachment_name = ATTACHMENT_NAMES[ii]
		local is_visible = visible_knives[attachment_name]
		local should_be_visible = ii <= remaining_ability_charges

		if is_visible and not should_be_visible then
			components_lookup[attachment_name].component:hide()
		elseif not is_visible and should_be_visible then
			if not event_name and not effect_name then
				table.clear(_external_properties)

				_external_properties.indicator_type = "psyker_throwing_knives_single"
				_, effect_name = self._visual_loadout_extension:resolve_gear_particle(LOOPING_PARTICLE_ALIAS, _external_properties)
				_, event_name = self._visual_loadout_extension:resolve_gear_sound(RECOVER_SOUND_ALIAS, _external_properties)
			end

			local scale = ii == 1 and 0.95 or 0.7

			components_lookup[attachment_name].component:show(t, effect_name, event_name, scale)
		end

		visible_knives[attachment_name] = should_be_visible
		any_visible = any_visible or should_be_visible
	end

	return any_visible
end

PsykerThrowingKnivesEffects._hide_all_ammo = function (self)
	local components_1p = self._components_1p

	for ii = 1, #components_1p do
		components_1p[ii].component:hide()
	end

	local components_3p = self._components_3p

	for ii = 1, #components_3p do
		components_3p[ii].component:hide()
	end

	local visible_knives = self._visible_knives

	for ii = 1, #ATTACHMENT_NAMES do
		visible_knives[ATTACHMENT_NAMES[ii]] = false
	end

	self:_destroy_passive_sfx()
end

PsykerThrowingKnivesEffects._create_passive_sfx = function (self)
	local visual_loadout_extension = self._visual_loadout_extension
	local fx_extension = self._fx_extension
	local sfx_source_name = self._sfx_source_name
	local should_play_husk_effect = self._fx_extension:should_play_husk_effect()

	if not self._looping_passive_playing_id then
		local resolved, event_name, resolved_stop, stop_event_name = visual_loadout_extension:resolve_looping_gear_sound(LOOPING_SOUND_ALIAS, should_play_husk_effect, _external_properties)

		if resolved then
			local wwise_world = self._wwise_world
			local source_id = fx_extension:sound_source(sfx_source_name)
			local playing_id = WwiseWorld.trigger_resource_event(wwise_world, event_name, source_id)

			self._looping_passive_playing_id = playing_id

			if resolved_stop then
				self._stop_event_name = stop_event_name
			end
		end
	end
end

PsykerThrowingKnivesEffects._destroy_passive_sfx = function (self)
	local looping_passive_playing_id = self._looping_passive_playing_id

	if looping_passive_playing_id then
		local stop_event_name = self._stop_event_name

		if stop_event_name then
			local source_id = self._fx_extension:sound_source(self._sfx_source_name)

			WwiseWorld.trigger_resource_event(self._wwise_world, stop_event_name, source_id)
		else
			WwiseWorld.stop_event(self._wwise_world, looping_passive_playing_id)
		end

		self._looping_passive_playing_id = nil
		self._stop_event_name = nil
	end
end

function _components(destination, destination_lookup, attachments, attachment_name_lookup)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "RandomizedThrowingShardUnit")

		for _, component in ipairs(components) do
			local lookup_name = attachment_name_lookup[attachment_unit]
			local data = {
				unit = attachment_unit,
				lookup_name = lookup_name,
				component = component,
			}

			destination[#destination + 1] = data
			destination_lookup[lookup_name] = data
		end
	end
end

implements(PsykerThrowingKnivesEffects, WieldableSlotScriptInterface)

return PsykerThrowingKnivesEffects
