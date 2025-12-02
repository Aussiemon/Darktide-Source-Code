-- chunkname: @scripts/extension_systems/recoil/player_unit_weapon_recoil_extension.lua

local Recoil = require("scripts/utilities/recoil")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local PlayerUnitWeaponRecoilExtension = class("PlayerUnitWeaponRecoilExtension")

PlayerUnitWeaponRecoilExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_local_unit = extension_init_data.is_local_unit
	self._player = extension_init_data.player

	local initial_seed = extension_init_data.recoil_seed
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._first_person_component = unit_data_extension:read_component("first_person")
	self._inair_state_component = unit_data_extension:read_component("inair_state")
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._movement_state_component = unit_data_extension:read_component("movement_state")
	self._recoil_component = unit_data_extension:write_component("recoil")
	self._recoil_control_component = unit_data_extension:write_component("recoil_control")
	self._weapon_tweak_templates_component = unit_data_extension:write_component("weapon_tweak_templates")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._recoil_control_component.seed = initial_seed

	self:_reset()
end

PlayerUnitWeaponRecoilExtension._reset = function (self)
	local recoil_component = self._recoil_component

	recoil_component.pitch_offset = 0
	recoil_component.yaw_offset = 0
	recoil_component.unsteadiness = 0

	local recoil_control_component = self._recoil_control_component

	recoil_control_component.rise_end_time = 0
	recoil_control_component.shooting = false
	recoil_control_component.num_shots = 0
	recoil_control_component.target_pitch = 0
	recoil_control_component.target_yaw = 0
	recoil_control_component.starting_rotation = Quaternion.identity()
	recoil_control_component.recoiling = false
end

PlayerUnitWeaponRecoilExtension._snap_camera = function (self)
	if not self._is_local_unit then
		return
	end

	local player = self._player
	local orientation = player:get_orientation()
	local recoil_template = self._weapon_extension:recoil_template()
	local pitch_offset, yaw_offset = Recoil.weapon_offset(recoil_template, self._recoil_component, self._movement_state_component, self._locomotion_component, self._inair_state_component)
	local new_yaw = math.mod_two_pi(orientation.yaw + yaw_offset)
	local new_pitch = math.mod_two_pi(orientation.pitch + pitch_offset)

	player:set_orientation(new_yaw, new_pitch, 0)
end

PlayerUnitWeaponRecoilExtension.fixed_update = function (self, unit, dt, t)
	local recoil_component = self._recoil_component
	local recoil_control_component = self._recoil_control_component
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local recoil_template_name = weapon_tweak_templates_component.recoil_template_name

	if recoil_template_name == "none" then
		return
	end

	local movement_state_component = self._movement_state_component
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component
	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component, locomotion_component, inair_state_component)
	local recoil_template = self._weapon_extension:recoil_template()
	local recoil_settings = recoil_template[weapon_movement_state]

	if recoil_control_component.recoiling then
		local decay_done = self:_update_unsteadiness(dt, t, recoil_component, recoil_control_component, recoil_settings)

		if decay_done then
			self:_snap_camera()
			self:_reset()
		end

		self:_update_offset(recoil_component, recoil_control_component, recoil_settings, t)
	end
end

PlayerUnitWeaponRecoilExtension._update_unsteadiness = function (self, dt, t, recoil_component, recoil_control_component, recoil_settings)
	local unsteadiness = recoil_component.unsteadiness
	local rise_end_time = recoil_control_component.rise_end_time
	local decay_grace = recoil_settings.decay_grace or 0
	local stat_buffs = self._buff_extension:stat_buffs()
	local recoil_modifier = stat_buffs.recoil_modifier or 1
	local num_shots = recoil_control_component.num_shots

	if t <= rise_end_time then
		local rise_index = math.min(num_shots, recoil_settings.num_rises)
		local rise_percent = recoil_settings.rise[rise_index]
		local unsteadiness_increase = rise_percent / recoil_settings.rise_duration * dt

		unsteadiness = math.min(unsteadiness + unsteadiness_increase * recoil_modifier, 1)
	else
		local shooting = recoil_control_component.shooting
		local shooting_grace_decay = t <= rise_end_time + decay_grace
		local decay_percent = (shooting or shooting_grace_decay) and recoil_settings.decay.shooting or recoil_settings.decay.idle
		local unsteadiness_decay = decay_percent * dt

		unsteadiness = unsteadiness - unsteadiness_decay * (1 / recoil_modifier)

		if num_shots > 1 and unsteadiness < 0.75 then
			local override_shot_count = math.min(num_shots, math.floor(math.max(unsteadiness, 0) * 5))

			self._recoil_control_component.num_shots = override_shot_count
		end
	end

	unsteadiness = math.min(unsteadiness, 1)

	if unsteadiness < 0 then
		return true
	end

	recoil_component.unsteadiness = unsteadiness
end

PlayerUnitWeaponRecoilExtension._update_offset = function (self, recoil_component, recoil_control_component, recoil_settings, t)
	local unsteadiness = recoil_component.unsteadiness
	local old_pitch_offset = recoil_component.pitch_offset
	local old_yaw_offset = recoil_component.yaw_offset
	local target_pitch = recoil_control_component.target_pitch
	local target_yaw = recoil_control_component.target_yaw
	local rise_end_time = recoil_control_component.rise_end_time
	local influence = recoil_settings.new_influence_percent

	if t > rise_end_time + 0.1 then
		local fp_rotation = self._first_person_component.rotation
		local current_pitch = Quaternion.pitch(fp_rotation)
		local starting_pitch = Quaternion.pitch(recoil_control_component.starting_rotation)
		local pitch_diff = starting_pitch - current_pitch

		if pitch_diff > 0 then
			influence = 0
		end
	end

	local influence_inv = 1 - influence
	local final_pitch_offset = (old_pitch_offset * influence_inv + target_pitch * influence) * unsteadiness
	local final_yaw_offset = (old_yaw_offset * influence_inv + target_yaw * influence) * unsteadiness

	if t <= rise_end_time then
		local new_yaw_offset = target_yaw * influence * unsteadiness

		final_yaw_offset = old_yaw_offset * influence_inv + new_yaw_offset
	end

	recoil_component.pitch_offset = final_pitch_offset
	recoil_component.yaw_offset = final_yaw_offset
end

PlayerUnitWeaponRecoilExtension.reset_recoil = function (self)
	self:_reset()
end

return PlayerUnitWeaponRecoilExtension
