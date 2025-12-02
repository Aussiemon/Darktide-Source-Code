-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/missile_launcher_effects.lua

local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local MissileLauncherEffects = class("MissileLauncherEffects")
local PROP_NAME = "content/weapons/player/ranged/missile_launcher/launcher_prop/launcher_prop"

MissileLauncherEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local unit_data_extension = context.unit_data_extension

	self._slot = slot
	self._world = context.world
	self._owner_unit = context.owner_unit
	self._visual_loadout_extension = context.visual_loadout_extension
	self._weapon_template = weapon_template
	self._grenade_ability_component = unit_data_extension:read_component("grenade_ability")
	self._num_charges = self._grenade_ability_component.num_charges
end

MissileLauncherEffects.fixed_update = function (self, unit, dt, t, frame)
	return
end

MissileLauncherEffects.update = function (self, unit, dt, t)
	if self._num_charges > self._grenade_ability_component.num_charges then
		self._discard_weapon = true
	end

	self._num_charges = self._grenade_ability_component.num_charges
end

MissileLauncherEffects.wield = function (self)
	return
end

MissileLauncherEffects.unwield = function (self)
	if self._discard_weapon then
		self:_spawn_prop()
	end

	self._discard_weapon = false
end

MissileLauncherEffects.destroy = function (self)
	return
end

MissileLauncherEffects._spawn_prop = function (self)
	local slot = self._slot
	local missile_launcher_unit = slot.attachment_map_by_unit_1p[slot.unit_1p].body
	local position = Unit.world_position(missile_launcher_unit, 1)
	local rotation = Unit.world_rotation(missile_launcher_unit, 1)

	World.spawn_unit_ex(self._world, PROP_NAME, nil, position, rotation)
end

implements(MissileLauncherEffects, WieldableSlotScriptInterface)

return MissileLauncherEffects
