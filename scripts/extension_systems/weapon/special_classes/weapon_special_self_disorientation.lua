local WeaponSpecialInterface = require("scripts/extension_systems/weapon/special_classes/weapon_special_interface")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local HitReaction = require("scripts/utilities/attack/hit_reaction")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local WeaponSpecial = require("scripts/utilities/weapon_special")
local attack_types = AttackSettings.attack_types
local WeaponSpecialSelfDisorientation = class("WeaponSpecialSelfDisorientation")

WeaponSpecialSelfDisorientation.init = function (self, context, init_data)
	self._input_extension = context.input_extension
	self._player_unit = context.player_unit
	local unit_data_extension = context.unit_data_extension
	self._unit_data_extension = unit_data_extension
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
	self._inventory_slot_component = init_data.inventory_slot_component
	self._weapon_template = init_data.weapon_template
	local tweak_data = init_data.tweak_data
	self._tweak_data = tweak_data
	self._player_unit = context.player_unit
	self._buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
end

WeaponSpecialSelfDisorientation.update = function (self, dt, t)
	WeaponSpecial.update_active(t, self._tweak_data, self._inventory_slot_component, self._buff_extension, self._input_extension)
end

WeaponSpecialSelfDisorientation.process_hit = function (self, t, weapon, action_settings, num_hit_enemies, target_is_alive, target_unit, hit_position, attack_direction)
	local special_active = self._inventory_slot_component.special_active

	if special_active and target_is_alive then
		self._inventory_slot_component.special_active = false
		self._inventory_slot_component.num_special_activations = 0
		local direction = Vector3.normalize(POSITION_LOOKUP[self._player_unit] - POSITION_LOOKUP[target_unit])

		HitReaction.disorient_player(self._player_unit, self._unit_data_extension, self._tweak_data.disorientation_type, true, true, direction, attack_types.melee, self._weapon_template)
		Push.add(self._player_unit, self._locomotion_push_component, direction, self._tweak_data.push_template, attack_types.melee)
	end
end

WeaponSpecialSelfDisorientation.on_action_start = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialSelfDisorientation.on_action_finish = function (self, t, num_hit_enemies)
	return
end

WeaponSpecialSelfDisorientation.on_exit_damage_window = function (self, t, num_hit_enemies)
	return
end

implements(WeaponSpecialSelfDisorientation, WeaponSpecialInterface)

return WeaponSpecialSelfDisorientation
