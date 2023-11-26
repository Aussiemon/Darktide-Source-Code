-- chunkname: @scripts/ui/hud/elements/crosshair/hud_element_crosshair.lua

local definition_path = "scripts/ui/hud/elements/crosshair/hud_element_crosshair_definitions"
local Action = require("scripts/utilities/weapon/action")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Hud = require("scripts/utilities/ui/hud")
local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local Recoil = require("scripts/utilities/recoil")
local Suppression = require("scripts/utilities/attack/suppression")
local Sway = require("scripts/utilities/sway")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local attack_results = AttackSettings.attack_results
local damage_efficiencies = AttackSettings.damage_efficiencies
local slot_configuration = PlayerCharacterConstants.slot_configuration
local HudElementCrosshair = class("HudElementCrosshair", "HudElementBase")
local ATTACK_RESULT_PRIORITY = {
	is_critical_strike = 3,
	weakspot = 2,
	[attack_results.died] = 1,
	[attack_results.damaged] = 4,
	[attack_results.blocked] = 5,
	[attack_results.shield_blocked] = 6,
	[attack_results.dodged] = 7,
	[attack_results.toughness_absorbed] = 7,
	[attack_results.toughness_absorbed_melee] = 7,
	[attack_results.toughness_broken] = 7,
	[attack_results.knock_down] = 7,
	[attack_results.friendly_fire] = 7
}

HudElementCrosshair.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	HudElementCrosshair.super.init(self, parent, draw_layer, start_scale, definitions)

	local scenegraph_id = "pivot"

	self._crosshair_templates = {}
	self._crosshair_widget_definitions = {}

	local crosshair_templates = HudElementCrosshairSettings.templates

	for i = 1, #crosshair_templates do
		local template_path = crosshair_templates[i]
		local template = require(template_path)
		local name = template.name

		self._crosshair_templates[name] = template
		self._crosshair_widget_definitions[name] = template.create_widget_defintion(template, scenegraph_id)
	end

	self._crosshair_position_x = 0
	self._crosshair_position_y = 0
	self._hit_report_array = {}

	local event_manager = Managers.event

	event_manager:register(self, "event_crosshair_hit_report", "event_crosshair_hit_report")
	event_manager:register(self, "event_update_forced_dot_crosshair", "event_update_forced_dot_crosshair")

	local save_manager = Managers.save

	if save_manager then
		local account_data = save_manager:account_data()

		self._forced_dot_crosshair = account_data.interface_settings.forced_dot_crosshair_enabled
	end
end

HudElementCrosshair.destroy = function (self, ui_renderer)
	local event_manager = Managers.event

	event_manager:unregister(self, "event_crosshair_hit_report")
	event_manager:unregister(self, "event_update_forced_dot_crosshair")
	HudElementCrosshair.super.destroy(self, ui_renderer)
end

HudElementCrosshair.event_crosshair_hit_report = function (self, hit_weakspot, attack_result, did_damage, hit_world_position, damage_efficiency, is_critical_strike)
	did_damage = did_damage or damage_efficiency == "push"

	local hit_report_array = self._hit_report_array
	local new_result = attack_result == attack_results.damaged and hit_weakspot and "weakspot" or attack_result == attack_results.damaged and is_critical_strike and "is_critical_strike" or attack_result
	local new_prio = ATTACK_RESULT_PRIORITY[new_result] or math.huge
	local last_prio = hit_report_array[8]
	local last_did_damage = hit_report_array[4]

	if last_prio and (last_prio < new_prio or last_prio == new_prio and last_did_damage and not did_damage) then
		return
	end

	table.clear(hit_report_array)

	hit_report_array[1] = HudElementCrosshairSettings.hit_duration
	hit_report_array[2] = hit_weakspot
	hit_report_array[3] = attack_result
	hit_report_array[4] = did_damage
	hit_report_array[5] = damage_efficiency
	hit_report_array[6] = hit_world_position
	hit_report_array[7] = is_critical_strike
	hit_report_array[8] = new_prio
end

HudElementCrosshair.event_update_forced_dot_crosshair = function (self, value)
	self._forced_dot_crosshair = value

	local crosshair_settings = self:_crosshair_settings()

	self:_sync_active_crosshair(crosshair_settings)
end

local hit_indicator_colors = HudElementCrosshairSettings.hit_indicator_colors

HudElementCrosshair.hit_indicator = function (self)
	local hit_report_array = self._hit_report_array
	local duration = hit_report_array[1]

	if duration then
		local progress = math.clamp(duration / HudElementCrosshairSettings.hit_duration, 0, 1)
		local hit_weakspot = hit_report_array[2]
		local attack_result = hit_report_array[3]
		local did_damage = hit_report_array[4]
		local damage_efficiency = hit_report_array[5]
		local is_critical_strike = hit_report_array[7]
		local color

		if attack_result == attack_results.blocked or not did_damage then
			color = hit_indicator_colors.blocked
		elseif attack_result == attack_results.damaged then
			if hit_weakspot then
				color = hit_indicator_colors.damage_weakspot
			else
				color = hit_indicator_colors.damage_normal
			end
		elseif attack_result == attack_results.died then
			color = hit_indicator_colors.death
		else
			progress = 0
		end

		local anim_progress = math.easeOutCubic(progress)

		return anim_progress, color
	end

	return nil, nil
end

HudElementCrosshair.hit_report_array = function (self)
	return self._hit_report_array
end

HudElementCrosshair._spread_yaw_pitch = function (self)
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local buff_extension = player_extensions.buff
		local yaw, pitch

		if unit_data_extension then
			local spread_component = unit_data_extension:read_component("spread")
			local suppression_component = unit_data_extension:read_component("suppression")

			yaw = spread_component.yaw
			pitch = spread_component.pitch

			if buff_extension then
				local stat_buffs = buff_extension:stat_buffs()
				local modifier = stat_buffs.spread_modifier or 1

				yaw = yaw * modifier
				pitch = pitch * modifier
			end

			pitch, yaw = Suppression.apply_suppression_offsets_to_spread(suppression_component, pitch, yaw)
		end

		return yaw, pitch
	end
end

HudElementCrosshair._recoil_yaw_pitch = function (self, player_extensions)
	local yaw, pitch = 0, 0

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data

		if unit_data_extension then
			local weapon_extension = player_extensions.weapon
			local recoil_template = weapon_extension:recoil_template()
			local recoil_component = unit_data_extension:read_component("recoil")
			local movement_state_component = unit_data_extension:read_component("movement_state")

			yaw, pitch = Recoil.weapon_offset(recoil_template, recoil_component, movement_state_component)
		end
	end

	return yaw, pitch
end

HudElementCrosshair.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementCrosshair.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local hit_report_array = self._hit_report_array
	local hit_report_duration = hit_report_array[1]

	if hit_report_duration then
		if hit_report_duration > 0 then
			hit_report_duration = hit_report_duration - dt
			hit_report_array[1] = hit_report_duration
		else
			table.clear(hit_report_array)
		end
	end

	local crosshair_settings = self:_crosshair_settings()

	self:_sync_active_crosshair(crosshair_settings)

	local crosshair_type = self._crosshair_type

	if crosshair_type then
		local template = self._crosshair_templates[crosshair_type]
		local update_function = template and template.update_function

		if update_function then
			update_function(self, ui_renderer, self._widget, template, crosshair_settings, dt, t)
		end
	end
end

HudElementCrosshair._crosshair_settings = function (self)
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")

		if weapon_action_component then
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

			if weapon_template then
				local _, action_settings = Action.current_action(weapon_action_component, weapon_template)
				local crosshair_settings

				if action_settings then
					crosshair_settings = action_settings.crosshair
				end

				if not crosshair_settings then
					local alternate_fire_component = unit_data_extension:read_component("alternate_fire")
					local alternate_fire_settings = weapon_template.alternate_fire_settings

					if alternate_fire_component.is_active and alternate_fire_settings then
						crosshair_settings = alternate_fire_settings.crosshair
					end
				end

				return crosshair_settings or weapon_template.crosshair
			end
		end
	end
end

HudElementCrosshair._get_current_crosshair_type = function (self, crosshair_settings)
	local crosshair_type

	if crosshair_settings then
		local parent = self._parent
		local player_extensions = parent:player_extensions()

		if player_extensions then
			local unit_data_extension = player_extensions.unit_data
			local inventory_comp = unit_data_extension:read_component("inventory")
			local wielded_slot = inventory_comp.wielded_slot
			local slot_type = slot_configuration[wielded_slot].slot_type
			local is_special_active = false

			if slot_type == "weapon" then
				local inventory_slot_component = unit_data_extension:read_component(wielded_slot)

				is_special_active = inventory_slot_component.special_active
			end

			crosshair_type = is_special_active and crosshair_settings.crosshair_type_special_active or crosshair_settings.crosshair_type
		end
	end

	if self._forced_dot_crosshair and (not crosshair_type or crosshair_type == "none") then
		crosshair_type = "dot"
	end

	return crosshair_type or "none"
end

HudElementCrosshair._get_current_charge_level = function (self)
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local action_module_charge_component = unit_data_extension:read_component("action_module_charge")
		local charge_level = action_module_charge_component.charge_level

		return charge_level
	end
end

HudElementCrosshair._sync_active_crosshair = function (self, crosshair_settings)
	local crosshair_type = self:_get_current_crosshair_type(crosshair_settings)

	if crosshair_type ~= self._crosshair_type then
		if self._widget and self._crosshair_type then
			self:_unregister_widget_name(self._crosshair_type)

			self._widget = nil
		end

		local widget_definition = self._crosshair_widget_definitions[crosshair_type]

		if widget_definition then
			self._widget = self:_create_widget(crosshair_type, widget_definition)

			local template = self._crosshair_templates[crosshair_type]
			local on_enter = template.on_enter

			if on_enter then
				on_enter(self._widget, template)
			end
		end

		self._crosshair_type = crosshair_type
	end
end

local CROSSHAIR_POSITION_LERP_SPEED = 35

HudElementCrosshair._crosshair_position = function (self, dt, t, ui_renderer)
	local target_x, target_y = 0, 0
	local ui_renderer_scale = ui_renderer.scale
	local parent = self._parent
	local player_extensions = parent:player_extensions()
	local weapon_extension = player_extensions and player_extensions.weapon
	local player_camera = parent:player_camera()

	if weapon_extension and player_camera then
		local unit_data_extension = player_extensions.unit_data
		local first_person_extention = player_extensions.first_person
		local first_person_unit = first_person_extention:first_person_unit()
		local shoot_rotation = Unit.world_rotation(first_person_unit, 1)
		local shoot_position = Unit.world_position(first_person_unit, 1)
		local recoil_template = weapon_extension:recoil_template()
		local recoil_component = unit_data_extension:read_component("recoil")
		local movement_state_component = unit_data_extension:read_component("movement_state")

		shoot_rotation = Recoil.apply_weapon_recoil_rotation(recoil_template, recoil_component, movement_state_component, shoot_rotation)

		local sway_component = unit_data_extension:read_component("sway")
		local sway_template = weapon_extension:sway_template()

		shoot_rotation = Sway.apply_sway_rotation(sway_template, sway_component, movement_state_component, shoot_rotation)

		local range = 50
		local shoot_direction = Quaternion.forward(shoot_rotation)
		local world_aim_position = shoot_position + shoot_direction * range
		local screen_aim_position = Camera.world_to_screen(player_camera, world_aim_position)
		local abs_target_x, abs_target_y = screen_aim_position.x, screen_aim_position.y
		local pivot_position = self:scenegraph_world_position("pivot", ui_renderer_scale)
		local pivot_x, pivot_y = pivot_position[1], pivot_position[2]

		target_x = abs_target_x - pivot_x
		target_y = abs_target_y - pivot_y
	end

	local current_x, current_y = self._crosshair_position_x * ui_renderer_scale, self._crosshair_position_y * ui_renderer_scale
	local ui_renderer_inverse_scale = ui_renderer.inverse_scale
	local lerp_t = math.min(CROSSHAIR_POSITION_LERP_SPEED * dt, 1)
	local x = math.lerp(current_x, target_x, lerp_t) * ui_renderer_inverse_scale
	local y = math.lerp(current_y, target_y, lerp_t) * ui_renderer_inverse_scale

	self._crosshair_position_x, self._crosshair_position_y = x, y

	return x, y
end

HudElementCrosshair._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	local x, y = self:_crosshair_position(dt, t, ui_renderer)

	HudElementCrosshair.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)

	local widget = self._widget

	if widget then
		local widget_offset = widget.offset

		widget_offset[1] = x
		widget_offset[2] = y

		UIWidget.draw(widget, ui_renderer)
	end
end

return HudElementCrosshair
