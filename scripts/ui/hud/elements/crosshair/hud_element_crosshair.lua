local definition_path = "scripts/ui/hud/elements/crosshair/hud_element_crosshair_definitions"
local Action = require("scripts/utilities/weapon/action")
local HudElementCrosshairSettings = require("scripts/ui/hud/elements/crosshair/hud_element_crosshair_settings")
local Recoil = require("scripts/utilities/recoil")
local Sway = require("scripts/utilities/sway")
local Suppression = require("scripts/utilities/attack/suppression")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local HudElementCrosshair = class("HudElementCrosshair", "HudElementBase")

HudElementCrosshair.init = function (self, parent, draw_layer, start_scale, definitions)
	local definitions = require(definition_path)

	HudElementCrosshair.super.init(self, parent, draw_layer, start_scale, definitions)

	local scenegraph_id = "pivot"
	self._crosshair_templates = {}
	self._crosshair_widget_definitions = {}
	local crosshair_templates = HudElementCrosshairSettings.templates

	for i = 1, #crosshair_templates, 1 do
		local template_path = crosshair_templates[i]
		local template = require(template_path)
		local name = template.name
		self._crosshair_templates[name] = template
		self._crosshair_widget_definitions[name] = template:create_widget_defintion(scenegraph_id)
	end

	self._crosshair_position_x = 0
	self._crosshair_position_y = 0
	self._hit_report_array = {}
	local event_manager = Managers.event

	event_manager:register(self, "event_crosshair_hit_report", "event_crosshair_hit_report")
end

HudElementCrosshair.destroy = function (self)
	local event_manager = Managers.event

	event_manager:unregister(self, "event_crosshair_hit_report")
	HudElementCrosshair.super.destroy(self)
end

HudElementCrosshair.event_crosshair_hit_report = function (self, hit_weakspot, attack_result, did_damage, hit_world_position)
	local hit_report_array = self._hit_report_array

	table.clear(hit_report_array)

	hit_report_array[1] = HudElementCrosshairSettings.hit_duration
	hit_report_array[2] = hit_weakspot
	hit_report_array[3] = attack_result
	hit_report_array[4] = did_damage
	hit_report_array[5] = hit_world_position
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
		local color = nil

		if attack_result == AttackSettings.attack_results.blocked or not did_damage then
			color = hit_indicator_colors.blocked
		elseif attack_result == AttackSettings.attack_results.damaged then
			if hit_weakspot then
				color = hit_indicator_colors.damage_weakspot
			else
				color = hit_indicator_colors.damage_normal
			end
		elseif attack_result == AttackSettings.attack_results.died then
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
		local yaw, pitch = nil

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
	local yaw = 0
	local pitch = 0

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
	local hit_report_deration = hit_report_array[1]

	if hit_report_deration then
		if hit_report_deration > 0 then
			hit_report_deration = hit_report_deration - dt
			hit_report_array[1] = hit_report_deration
		else
			table.clear(hit_report_array)
		end
	end

	self:_sync_active_crosshair()

	local crosshair_type = self._crosshair_type

	if crosshair_type then
		local template = self._crosshair_templates[crosshair_type]
		local update_function = template and template.update_function

		if update_function then
			update_function(self, ui_renderer, self._widget, template, dt, t)
		end
	end
end

HudElementCrosshair._get_current_crosshair_type = function (self)
	local crosshair_type = nil
	local parent = self._parent
	local player_extensions = parent:player_extensions()

	if player_extensions then
		local unit_data_extension = player_extensions.unit_data
		local weapon_action_component = unit_data_extension and unit_data_extension:read_component("weapon_action")

		if weapon_action_component then
			local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

			if weapon_template then
				local current_action_name, action_settings = Action.current_action(weapon_action_component, weapon_template)
				local alternate_fire_component = unit_data_extension:read_component("alternate_fire")
				local alternate_fire_settings = weapon_template.alternate_fire_settings

				if current_action_name ~= "none" then
					crosshair_type = action_settings.crosshair_type
				elseif alternate_fire_component.is_active and alternate_fire_settings and alternate_fire_settings.crosshair_type then
					crosshair_type = alternate_fire_settings.crosshair_type
				end

				crosshair_type = crosshair_type or weapon_template.crosshair_type
			end
		end
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

HudElementCrosshair._sync_active_crosshair = function (self)
	local crosshair_type = self:_get_current_crosshair_type()

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
	local target_x = 0
	local target_y = 0
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
		local abs_target_x = screen_aim_position.x
		local abs_target_y = screen_aim_position.y
		local pivot_position = self:scenegraph_world_position("pivot", ui_renderer_scale)
		local pivot_x = pivot_position[1]
		local pivot_y = pivot_position[2]
		target_x = abs_target_x - pivot_x
		target_y = abs_target_y - pivot_y
	end

	local current_x = self._crosshair_position_x * ui_renderer_scale
	local current_y = self._crosshair_position_y * ui_renderer_scale
	local ui_renderer_inverse_scale = ui_renderer.inverse_scale
	local lerp_t = math.min(CROSSHAIR_POSITION_LERP_SPEED * dt, 1)
	local x = math.lerp(current_x, target_x, lerp_t) * ui_renderer_inverse_scale
	local y = math.lerp(current_y, target_y, lerp_t) * ui_renderer_inverse_scale
	self._crosshair_position_y = y
	self._crosshair_position_x = x

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
