-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/galvanic_rifle_spin.lua

local Action = require("scripts/utilities/action/action")
local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local GalvanicRifleSpin = class("GalvanicRifleSpin")
local SPIN_STATES = table.enum("idle", "spin_up", "spin_down")
local IDLE_ROTATION_SPEED = 0.75
local SHOOTING_ROTATION_SPEED = 5
local SPIN_UP_DURATION = 0
local SPIN_DOWN_DURATION = 2.5
local _unit_components

GalvanicRifleSpin.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name

	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._shooting_status_component = unit_data_extension:read_component("shooting_status")
	self._world = context.world
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._ammo_refill_start_time = nil
	self._is_reloading = false
	self._last_clip_size = 0
	self._spin_up_start_t = 0
	self._state_change_rotation_speed = IDLE_ROTATION_SPEED
	self._wanted_rotation_speed = IDLE_ROTATION_SPEED
	self._rotation_speed = IDLE_ROTATION_SPEED
	self._spin_state = SPIN_STATES.idle
	self._material_variable_value = 0
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}

	_unit_components(self._weapon_material_variables_1p, slot.attachments_by_unit_1p[unit_1p])
	_unit_components(self._weapon_material_variables_3p, slot.attachments_by_unit_3p[unit_3p])
	self:_toggle_automatic_spin(false)
end

GalvanicRifleSpin.destroy = function (self)
	return
end

GalvanicRifleSpin.wield = function (self)
	return
end

GalvanicRifleSpin.unwield = function (self)
	return
end

GalvanicRifleSpin.fixed_update = function (self, unit, dt, t, frame)
	return
end

GalvanicRifleSpin.update = function (self, unit, dt, t)
	local weapon_action_component = self._weapon_action_component
	local time_scale = weapon_action_component.time_scale

	self:_update_spin_state(unit, dt, t, time_scale)
	self:_update_spin(unit, dt, t, time_scale)
end

GalvanicRifleSpin._update_spin_state = function (self, unit, dt, t, time_scale)
	local weapon_action_component = self._weapon_action_component
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local is_shooting = action_kind == "shoot" or action_kind == "shoot_hit_scan" or action_kind == "shoot_pellets" or action_kind == "shoot_projectile"

	if is_shooting and self._spin_state ~= SPIN_STATES.spin_up then
		self._spin_up_start_t = t
		self._spin_state = SPIN_STATES.spin_up
		self._state_change_rotation_speed = self._rotation_speed
		self._wanted_rotation_speed = SHOOTING_ROTATION_SPEED
	elseif not is_shooting and self._spin_state == SPIN_STATES.spin_up then
		local time_since_spin_up = t - self._spin_up_start_t

		if time_since_spin_up >= SPIN_UP_DURATION then
			self._spin_down_start_t = t
			self._spin_state = SPIN_STATES.spin_down
			self._state_change_rotation_speed = self._rotation_speed
			self._wanted_rotation_speed = IDLE_ROTATION_SPEED
		end
	elseif not is_shooting and self._spin_state == SPIN_STATES.spin_down then
		local time_since_spin_down = t - self._spin_down_start_t

		if time_since_spin_down >= SPIN_DOWN_DURATION then
			self._spin_state = SPIN_STATES.idle
			self._state_change_rotation_speed = self._rotation_speed
			self._wanted_rotation_speed = IDLE_ROTATION_SPEED
		end
	end
end

GalvanicRifleSpin._update_spin = function (self, unit, dt, t, time_scale)
	local spin_state = self._spin_state
	local state_change_rotation_speed = self._state_change_rotation_speed
	local wanted_rotation_speed = self._wanted_rotation_speed
	local current_rotation_speed = self._rotation_speed
	local new_rotation_speed = IDLE_ROTATION_SPEED

	if spin_state == SPIN_STATES.spin_up then
		local time_since_spin_up = t - self._spin_up_start_t
		local lerp_t = SPIN_UP_DURATION > 0 and math.min(time_since_spin_up, SPIN_UP_DURATION) / SPIN_UP_DURATION or 1

		new_rotation_speed = math.lerp(state_change_rotation_speed, SHOOTING_ROTATION_SPEED, lerp_t)
	elseif spin_state == SPIN_STATES.spin_down then
		local time_since_spin_down = t - self._spin_down_start_t
		local lerp_t = SPIN_DOWN_DURATION > 0 and math.min(time_since_spin_down, SPIN_DOWN_DURATION) / SPIN_DOWN_DURATION or 1

		new_rotation_speed = math.lerp(state_change_rotation_speed, IDLE_ROTATION_SPEED, lerp_t)
	end

	local material_variable_value = self._material_variable_value + dt * new_rotation_speed

	if material_variable_value > 1 then
		material_variable_value = 0
	end

	self._material_variable_value = material_variable_value
	self._rotation_speed = new_rotation_speed

	self:_set_weapon_material_intensity(material_variable_value)
end

GalvanicRifleSpin.update_first_person_mode = function (self, first_person_mode)
	return
end

GalvanicRifleSpin._set_weapon_material_intensity = function (self, intensity)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:set_intensity(intensity, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:set_intensity(intensity, weapon_material_variable.unit)
	end
end

GalvanicRifleSpin._toggle_automatic_spin = function (self, automatic_spin)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:toggle_on_off(automatic_spin, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:toggle_on_off(automatic_spin, weapon_material_variable.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end
end

implements(GalvanicRifleSpin, WieldableSlotScriptInterface)

return GalvanicRifleSpin
