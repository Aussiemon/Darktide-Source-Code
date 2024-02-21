local FixedFrame = require("scripts/utilities/fixed_frame")
local ScannerDisplayViewScanSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_scan_settings")
local Scanning = require("scripts/utilities/scanning")
local UIWidget = require("scripts/managers/ui/ui_widget")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local MinigameScanView = class("MinigameScanView")
local FX_SOURCE_NAME = "_speaker"
local SLOT_NAME = "slot_device"
local WWISE_PARAMETER_NAME_BEEP_VOLUME = "scanner_beep_volume"

MinigameScanView.init = function (self, context)
	self._interactor_extension = ScriptUnit.extension(context.device_owner_unit, "interactor_system")
	self._local_player = nil
	self._device_owner_unit = context.device_owner_unit
	self._skull_widgets = {}
	self._cog_widgets = {}
	self._segments = {}
	self._scanning_intensity = 0
	self._blinking = false
	self._blink_time = 0

	self:_create_skull_widgets()
	self:_create_cog_widgets()
	self:_create_segment_widgets()

	self._wwise_world = context.wwise_world
	local owner_unit = context.device_owner_unit
	local player_visual_loadout_extension = ScriptUnit.extension(owner_unit, "visual_loadout_system")
	local fx_sources = player_visual_loadout_extension:source_fx_for_slot(SLOT_NAME)
	self._player_fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._fx_source_name = fx_sources[FX_SOURCE_NAME]
	local unit_data_extension = ScriptUnit.extension(context.device_owner_unit, "unit_data_system")
	self._scanning_component = unit_data_extension:read_component("scanning")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._first_person_component = unit_data_extension:read_component("first_person")
end

local system_name = "dialogue_system"

MinigameScanView.dialogue_system = function (self)
	local state_managers = Managers.state

	if state_managers then
		local extension_manager = state_managers.extension

		return extension_manager and extension_manager:has_system(system_name) and extension_manager:system(system_name)
	end
end

MinigameScanView.destroy = function (self)
	return
end

local function _calculate_auspex_scanner_hud_view_values(scanning_compomnent, weapon_action_component, first_person_component, t)
	local is_active = scanning_compomnent.is_active
	local line_of_sight = scanning_compomnent.line_of_sight
	local scannable_unit = scanning_compomnent.scannable_unit
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
	local current_action_name = weapon_action_component.current_action_name
	local weapon_actions = weapon_template.actions
	local action_settings = current_action_name and weapon_actions[current_action_name]
	local scan_settings = action_settings and action_settings.scan_settings

	if action_settings and action_settings.kind == "scan_confirm" then
		local progress = Scanning.scan_confirm_progression(scanning_compomnent, weapon_action_component, t)

		return is_active, progress and progress >= 1, progress, 1
	elseif action_settings and action_settings.kind == "scan" then
		local total_score, angle_score, distance_score = nil

		if is_active and line_of_sight then
			distance_score = 1
			angle_score = 1
			total_score = 1
		elseif scan_settings and scannable_unit then
			total_score, angle_score, distance_score = Scanning.calculate_score(scannable_unit, first_person_component, scan_settings)
		end

		return is_active, line_of_sight, angle_score, Scanning.calculate_color_lerp(angle_score or 0)
	end

	return false, false, 0, 0
end

local MAX_SPEED = 10
local ON_SPOT_THRESHOLD = 1

MinigameScanView.update = function (self, dt, t, widgets_by_name)
	local latest_fixed_t = FixedFrame.get_latest_fixed_time()
	local is_active, blinking, progress, color_lerp = _calculate_auspex_scanner_hud_view_values(self._scanning_component, self._weapon_action_component, self._first_person_component, latest_fixed_t)
	self._is_scaning = is_active
	local target = is_active and progress or 0
	local current = self._scanning_intensity
	local to_target = target - current
	local direction = math.sign(to_target)
	local distance = math.abs(to_target)
	local is_target_on_spot = ON_SPOT_THRESHOLD <= target
	local max_speed = MAX_SPEED * (is_target_on_spot and 2 or 1)
	local move = math.clamp(max_speed * direction * dt, -distance, distance)
	self._color_lerp = color_lerp or 0
	self._scanning_intensity = math.clamp01(current + move)
	self._blinking = blinking
	self._blink_time = self._blink_time + dt
	local sfx_source = self._player_fx_extension:sound_source(self._fx_source_name)
	local current_beep = WwiseWorld.get_source_parameter(self._wwise_world, WWISE_PARAMETER_NAME_BEEP_VOLUME, sfx_source)
	local current_beep_normalized = 1 - math.clamp01(current_beep / -48)
	self._intense_blink_alpha = current_beep_normalized > 0.7 and 1 or 0
end

MinigameScanView.set_local_player = function (self, local_player)
	self._local_player = local_player
end

MinigameScanView.draw_widgets = function (self, dt, t, input_service, ui_renderer)
	self:_draw_skulls(ui_renderer)
	self:_draw_segments(ui_renderer)
end

MinigameScanView._draw_skulls = function (self, ui_renderer)
	local mission_objective_zone_system = Managers.state.extension:system("mission_objective_zone_system")
	local zone_scan_extension = mission_objective_zone_system:current_active_zone()

	if zone_scan_extension then
		local scanned_objects = zone_scan_extension:num_objets_banked()
		local max_scannable_per_player = zone_scan_extension:num_scannables_in_zone()
		local skull_widgets = self._skull_widgets
		local cog_widgets = self._cog_widgets

		for i = 1, max_scannable_per_player do
			if i <= scanned_objects then
				local skull_widget = skull_widgets[i]

				UIWidget.draw(skull_widget, ui_renderer)
			end

			local cog_widget = cog_widgets[i]

			UIWidget.draw(cog_widget, ui_renderer)
		end
	end
end

MinigameScanView._draw_segments = function (self, ui_renderer)
	local segments = self._segments
	local scanning_instensity = math.clamp01(self._scanning_intensity)
	local max_segments = math.floor(scanning_instensity * (#segments - 1)) + 1
	local is_scaning = self._is_scaning
	local intence_blinking = self._blinking
	local intense_blink_alpha = self._intense_blink_alpha
	local color = is_scaning and Color.lerp(Color.red(), Color.green(), self._color_lerp) or Color.green()
	local _, r, g, b = Quaternion.to_elements(color)

	for i = 1, max_segments do
		local segment_widget = segments[i]
		local segement_color = segment_widget.style.segment.color
		segement_color[2] = r
		segement_color[3] = g
		segement_color[4] = b

		if i == max_segments then
			segement_color[1] = intense_blink_alpha * 255
		else
			segement_color[1] = (intence_blinking and intense_blink_alpha or 1) * 255
		end

		UIWidget.draw(segment_widget, ui_renderer)
	end
end

MinigameScanView._create_skull_widgets = function (self)
	self:_create_wallet_widgets("scanner_scan_skull", "skull_", "skull", self._skull_widgets)
end

MinigameScanView._create_cog_widgets = function (self)
	self:_create_wallet_widgets("scanner_scan_cog", "cog_", "cog", self._cog_widgets)
end

MinigameScanView._create_wallet_widgets = function (self, material_name, widget_name_prefix, style_id, widgets)
	local num_skulls_columns = ScannerDisplayViewScanSettings.scan_num_skulls_columns
	local num_skulls_rows = ScannerDisplayViewScanSettings.scan_num_skulls_rows
	local start_offset = ScannerDisplayViewScanSettings.scan_skulls_start_offset
	local spacing = ScannerDisplayViewScanSettings.scan_skulls_spacing
	local scenegraph_id = "center_pivot"
	local material_path = "content/ui/materials/backgrounds/scanner/"
	local widget_size = ScannerDisplayViewScanSettings.scan_skull_widget_size

	table.clear(widgets)

	for i = 1, num_skulls_rows do
		for j = 1, num_skulls_columns do
			local widget_name = widget_name_prefix .. tostring(i)
			local widget_offset = {
				start_offset[1] + j * widget_size[1] + spacing[1] * j,
				start_offset[2] + i * widget_size[2] + spacing[2] * i,
				start_offset[3]
			}
			local widget_definition = UIWidget.create_definition({
				{
					pass_type = "texture",
					value = material_path .. material_name,
					style_id = style_id,
					style = {
						hdr = true,
						color = {
							255,
							0,
							255,
							0
						},
						offset = widget_offset
					}
				}
			}, scenegraph_id, nil, widget_size)
			local widget = UIWidget.init(widget_name, widget_definition)
			widgets[#widgets + 1] = widget
		end
	end
end

MinigameScanView._create_segment_widgets = function (self)
	local scenegraph_id = "segments_center_pivot"
	local num_segments = ScannerDisplayViewScanSettings.scan_num_segments
	local widget_size = ScannerDisplayViewScanSettings.scan_segment_widget_size
	local widget_offset = ScannerDisplayViewScanSettings.scan_segment_widget_offset
	local widget_pivot = ScannerDisplayViewScanSettings.scan_segment_widget_pivot
	local material_path = "content/ui/materials/backgrounds/scanner/scanner_scan_segment"
	local widget_name_prefix = "segment_"
	local angle = ScannerDisplayViewScanSettings.scan_segment_half_angle
	local angle_step = angle * 2 / num_segments
	local segments = self._segments

	table.clear(segments)

	for i = 1, num_segments do
		local widget_name = widget_name_prefix .. tostring(i)
		local widget_definition = UIWidget.create_definition({
			{
				style_id = "segment",
				pass_type = "rotated_texture",
				value = material_path,
				style = {
					vertical_alignment = "bottom",
					horizontal_alignment = "center",
					hdr = true,
					offset = widget_offset,
					size = widget_size,
					angle = angle,
					color = {
						255,
						0,
						255,
						0
					},
					pivot = widget_pivot
				}
			}
		}, scenegraph_id, nil, widget_size)
		local widget = UIWidget.init(widget_name, widget_definition)
		segments[#segments + 1] = widget
		angle = angle - angle_step
	end
end

return MinigameScanView
