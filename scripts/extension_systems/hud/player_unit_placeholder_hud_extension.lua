local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local ScriptGui = require("scripts/foundation/utilities/script_gui")
local ScriptViewport = require("scripts/foundation/utilities/script_viewport")
local ScriptWorld = require("scripts/foundation/utilities/script_world")
local WarpCharge = require("scripts/utilities/warp_charge")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Scanning = require("scripts/utilities/scanning")
local buff_keywords = BuffSettings.keywords
local PlayerUnitPlaceholderHudExtension = class("PlayerUnitPlaceholderHudExtension")
local HIT_FADE_DURATION = 0.75
local MAX_NUM_ACTIVE_HIT_MARKERS = 10

PlayerUnitPlaceholderHudExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id)
	self._unit = unit
	local world = extension_init_context.world
	self._world = world

	self:_init_components(unit)

	self._gui = World.create_screen_gui(world, 0, 0, "immediate")
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._is_local = extension_init_data.is_local_unit
	self._player = extension_init_data.player
	self._is_human_controlled = extension_init_data.is_human_controlled
	self._num_hit_markers = 0
	self._hit_markers = Script.new_array(MAX_NUM_ACTIVE_HIT_MARKERS)

	for i = 1, MAX_NUM_ACTIVE_HIT_MARKERS do
		self._hit_markers[i] = {
			fade_time = 0,
			color = {
				g = 255,
				b = 255,
				r = 255
			},
			hit_world_position = Vector3Box(),
			previous_screen_position = Vector3Box()
		}
	end

	self._hit_fade_time = 0
	self._hit_fade_color = {
		g = 255,
		b = 255,
		r = 255
	}
	self._network_event_delegate = extension_init_context.network_event_delegate
	self._is_server = extension_init_context.is_server
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._health_extension = ScriptUnit.extension(unit, "health_system")
end

PlayerUnitPlaceholderHudExtension.destroy = function (self)
	World.destroy_gui(self._world, self._gui)
end

PlayerUnitPlaceholderHudExtension._init_components = function (self, unit)
	local unit_data_ext = ScriptUnit.extension(unit, "unit_data_system")
	self._spread_component = unit_data_ext:read_component("spread")
	self._inventory_component = unit_data_ext:read_component("inventory")
	self._primary_inventory_component = unit_data_ext:read_component("slot_primary")
	self._secondary_inventory_component = unit_data_ext:read_component("slot_secondary")
	self._action_module_charge_component = unit_data_ext:read_component("action_module_charge")
	self._weapon_action_component = unit_data_ext:read_component("weapon_action")
	self._scanning_component = unit_data_ext:read_component("scanning")
	self._warp_charge_component = unit_data_ext:read_component("warp_charge")
end

PlayerUnitPlaceholderHudExtension.update = function (self, unit, dt, t)
	local player = self._player

	if not self._is_local or not player:is_human_controlled() then
		return
	end
end

PlayerUnitPlaceholderHudExtension.post_update = function (self, unit, dt, t)
	local player = self._player

	if not self._is_local or not player:is_human_controlled() then
		return
	end
end

PlayerUnitPlaceholderHudExtension._update_crosshair = function (self, dt)
	local w, h = Application.back_buffer_size()
	local half_res_w = w * 0.5
	local half_res_h = h * 0.5
	local mid_pos = Vector3(half_res_w - 1, half_res_h - 1, 0)
	local gui = self._gui

	self:_update_hit_indicator(dt, gui, w, h, mid_pos)
end

local WEAPON_CHARGE_WIDTH = 50
local WEAPON_CHARGE_HEIGHT = 5
local WEAPON_CHARGE_Y_OFFSET = 50
local WEAPON_CHARGE_X_OFFSET = -WEAPON_CHARGE_WIDTH * 0.5
local WEAPON_CHARGE_BORDER_SIZE = 2

PlayerUnitPlaceholderHudExtension._update_weapon_charge = function (self)
	local charge_level = self._action_module_charge_component.charge_level

	if charge_level <= 0 then
		return
	end

	local w, h = Application.back_buffer_size()
	local half_res_w = w * 0.5
	local half_res_h = h * 0.5
	local mid_pos = Vector3(half_res_w - 1, half_res_h - 1, 0)
	local gui = self._gui
	local weapon_charge_pos = Vector3(mid_pos.x + WEAPON_CHARGE_X_OFFSET, mid_pos.y + WEAPON_CHARGE_Y_OFFSET, 0)
	local wanted_width = WEAPON_CHARGE_WIDTH * charge_level
	local half_border_size = WEAPON_CHARGE_BORDER_SIZE * 0.5
	local weapon_charge_border_rect_pos = Vector3(mid_pos.x + WEAPON_CHARGE_X_OFFSET - half_border_size, mid_pos.y + WEAPON_CHARGE_Y_OFFSET - half_border_size, 0)

	Gui.rect(gui, weapon_charge_border_rect_pos, Vector2(WEAPON_CHARGE_WIDTH + WEAPON_CHARGE_BORDER_SIZE, WEAPON_CHARGE_HEIGHT + WEAPON_CHARGE_BORDER_SIZE), Color(56, 56, 56))
	Gui.rect(gui, weapon_charge_pos, Vector2(WEAPON_CHARGE_WIDTH, WEAPON_CHARGE_HEIGHT), Color(104, 104, 104))
	Gui.rect(gui, weapon_charge_pos, Vector2(wanted_width, WEAPON_CHARGE_HEIGHT), Color(58, 192, 255))
end

local OVERHEAT_WIDTH = 100
local OVERHEAT_HEIGHT = 10
local OVERHEAT_Y_OFFSET = 75
local OVERHEAT_X_OFFSET = -OVERHEAT_WIDTH * 0.5
local OVERHEAT_BORDER_SIZE = 2
local OVERHEAT_DIVIDER_WIDTH = 1

local function _draw_overheat(gui, heat_level, y_offset)
	if heat_level <= 0 then
		return
	end

	local w, h = Application.back_buffer_size()
	local half_res_w = w * 0.5
	local half_res_h = h * 0.5
	local mid_pos = Vector3(half_res_w - 1, half_res_h - 1, 0)
	local overheat_pos = Vector3(mid_pos.x + OVERHEAT_X_OFFSET, mid_pos.y + OVERHEAT_Y_OFFSET + y_offset, 0)
	local wanted_width = OVERHEAT_WIDTH * heat_level
	local half_border_size = OVERHEAT_BORDER_SIZE * 0.5
	local overheat_border_rect_pos = Vector3(mid_pos.x + OVERHEAT_X_OFFSET - half_border_size, mid_pos.y + OVERHEAT_Y_OFFSET + y_offset - half_border_size, 0)

	Gui.rect(gui, overheat_border_rect_pos, Vector2(OVERHEAT_WIDTH + OVERHEAT_BORDER_SIZE, OVERHEAT_HEIGHT + OVERHEAT_BORDER_SIZE), Color(56, 56, 56))
	Gui.rect(gui, overheat_pos, Vector2(OVERHEAT_WIDTH, OVERHEAT_HEIGHT), Color(104, 104, 104))
	Gui.rect(gui, overheat_pos, Vector2(wanted_width, OVERHEAT_HEIGHT), Color(255, 114, 0))

	local low_threshold_divider_pos = overheat_pos + Vector3(OVERHEAT_WIDTH * 0.3, 0, 0)
	local high_threshold_divider_pos = overheat_pos + Vector3(OVERHEAT_WIDTH * 0.7, 0, 0)
	local critical_threshold_divider_pos = overheat_pos + Vector3(OVERHEAT_WIDTH * 0.9, 0, 0)

	Gui.rect(gui, low_threshold_divider_pos, Vector2(OVERHEAT_DIVIDER_WIDTH, OVERHEAT_HEIGHT), Color(56, 56, 56))
	Gui.rect(gui, high_threshold_divider_pos, Vector2(OVERHEAT_DIVIDER_WIDTH, OVERHEAT_HEIGHT), Color(56, 56, 56))
	Gui.rect(gui, critical_threshold_divider_pos, Vector2(OVERHEAT_DIVIDER_WIDTH, OVERHEAT_HEIGHT), Color(56, 56, 56))
end

PlayerUnitPlaceholderHudExtension._update_overheat = function (self)
	_draw_overheat(self._gui, self._primary_inventory_component.overheat_current_percentage, 0)
	_draw_overheat(self._gui, self._secondary_inventory_component.overheat_current_percentage, 15)
end

local WARP_CHARGE_WIDTH = 100
local WARP_CHARGE_HEIGHT = 10
local WARP_CHARGE_Y_OFFSET = 75
local WARP_CHARGE_X_OFFSET = -WARP_CHARGE_WIDTH * 0.5
local WARP_CHARGE_BORDER_SIZE = 2
local WARP_CHARGE_DIVIDER_WIDTH = 1

local function _draw_warp_charge(gui, unit, warp_charge_component, y_offset, player)
	local warp_charge_level = warp_charge_component.current_percentage

	if warp_charge_level <= 0 then
		return
	end

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local prevent_overcharge = buff_extension:has_keyword(buff_keywords.psychic_fortress)
	local w, h = Application.back_buffer_size()
	local half_res_w = w * 0.5
	local half_res_h = h * 0.5
	local mid_pos = Vector3(half_res_w - 1, half_res_h - 1, 0)
	local warp_charge_pos = Vector3(mid_pos.x + WARP_CHARGE_X_OFFSET, mid_pos.y + WARP_CHARGE_Y_OFFSET + y_offset, 0)
	local wanted_width = WARP_CHARGE_WIDTH * warp_charge_level
	local half_border_size = WARP_CHARGE_BORDER_SIZE * 0.5
	local warp_charge_border_rect_pos = Vector3(mid_pos.x + WARP_CHARGE_X_OFFSET - half_border_size, mid_pos.y + WARP_CHARGE_Y_OFFSET + y_offset - half_border_size, 0)
	local bar_color = prevent_overcharge and Color(204, 204, 255) or Color(255, 2, 229)

	Gui.rect(gui, warp_charge_border_rect_pos, Vector2(WARP_CHARGE_WIDTH + WARP_CHARGE_BORDER_SIZE, WARP_CHARGE_HEIGHT + WARP_CHARGE_BORDER_SIZE), Color(56, 56, 56))
	Gui.rect(gui, warp_charge_pos, Vector2(WARP_CHARGE_WIDTH, WARP_CHARGE_HEIGHT), Color(104, 104, 104))
	Gui.rect(gui, warp_charge_pos, Vector2(wanted_width, WARP_CHARGE_HEIGHT), bar_color)

	local low_threshold, high_threshold, critical_threshold = WarpCharge.thresholds(player)
	local low_threshold_divider_pos = warp_charge_pos + Vector3(WARP_CHARGE_WIDTH * low_threshold, 0, 0)
	local high_threshold_divider_pos = warp_charge_pos + Vector3(WARP_CHARGE_WIDTH * high_threshold, 0, 0)
	local critical_threshold_divider_pos = warp_charge_pos + Vector3(WARP_CHARGE_WIDTH * critical_threshold, 0, 0)

	Gui.rect(gui, low_threshold_divider_pos, Vector2(WARP_CHARGE_DIVIDER_WIDTH, WARP_CHARGE_HEIGHT), Color(56, 56, 56))
	Gui.rect(gui, high_threshold_divider_pos, Vector2(WARP_CHARGE_DIVIDER_WIDTH, WARP_CHARGE_HEIGHT), Color(56, 56, 56))
	Gui.rect(gui, critical_threshold_divider_pos, Vector2(WARP_CHARGE_DIVIDER_WIDTH, WARP_CHARGE_HEIGHT), Color(56, 56, 56))
end

PlayerUnitPlaceholderHudExtension._update_warp_charge = function (self)
	_draw_warp_charge(self._gui, self._unit, self._warp_charge_component, 40, self._player)
end

PlayerUnitPlaceholderHudExtension._update_scanning_progressbar = function (self, t)
	local scanning_progression = Scanning.scan_confirm_progression(self._scanning_component, self._weapon_action_component, t)
	local line_of_sight = self._scanning_component.line_of_sight

	if not line_of_sight or not scanning_progression or scanning_progression <= 0 then
		return
	end

	local w, h = Application.back_buffer_size()
	local half_res_w = w * 0.5
	local half_res_h = h * 0.5
	local mid_pos = Vector3(half_res_w - 1, half_res_h - 1, 0)
	local gui = self._gui
	local buff_charge_pos = Vector3(mid_pos.x + BUFF_CHARGE_X_OFFSET, mid_pos.y + BUFF_CHARGE_Y_OFFSET, 0)
	local wanted_width = BUFF_CHARGE_WIDTH * scanning_progression
	local half_border_size = BUFF_CHARGE_BORDER_SIZE * 0.5
	local buff_charge_border_rect_pos = Vector3(mid_pos.x + BUFF_CHARGE_X_OFFSET - half_border_size, mid_pos.y + BUFF_CHARGE_Y_OFFSET - half_border_size, 0)

	Gui.rect(gui, buff_charge_border_rect_pos, Vector2(BUFF_CHARGE_WIDTH + BUFF_CHARGE_BORDER_SIZE, BUFF_CHARGE_HEIGHT + BUFF_CHARGE_BORDER_SIZE), Color(56, 56, 56))
	Gui.rect(gui, buff_charge_pos, Vector2(BUFF_CHARGE_WIDTH, BUFF_CHARGE_HEIGHT), Color(104, 104, 104))
	Gui.rect(gui, buff_charge_pos, Vector2(wanted_width, BUFF_CHARGE_HEIGHT), Color(58, 192, 255))
end

local EDGE_OFFSET = 130
local SIZE = {
	400,
	16
}

PlayerUnitPlaceholderHudExtension._update_wounds = function (self)
	local w = RESOLUTION_LOOKUP.width
	local h = RESOLUTION_LOOKUP.height
	local scale = RESOLUTION_LOOKUP.scale
	local num_wounds = self._health_extension:num_wounds()
	local max_wounds = self._health_extension:max_wounds()
	local divider_interval = SIZE[1] / max_wounds

	for i = 1, max_wounds + 1 do
		if i ~= 1 and i ~= max_wounds + 1 then
			local pos = Vector3((EDGE_OFFSET + divider_interval * (i - 1)) * scale, h - (90 + (i - 1) * 6), 0)

			Gui.rect(self._gui, pos, Vector2(2 * scale, SIZE[2] * 2.5 * scale), Color.ui_orange_dark())
		end
	end

	local wound_pos = Vector3((EDGE_OFFSET + 10 + SIZE[1]) * scale, h - 105, 0)
	local text = string.format("%d/%d", num_wounds, max_wounds)

	Gui.slug_text(self._gui, text, "core/performance_hud/debug", 20 * scale, wound_pos, nil, Color.ui_orange_light())
end

PlayerUnitPlaceholderHudExtension.report_hit = function (self, hit_weakspot, attack_result, did_damage, hit_world_position)
	if self._is_human_controlled and self._is_local then
		local hit_markers = self._hit_markers
		local num_active_markers = self._num_hit_markers
		local next_index = nil

		if MAX_NUM_ACTIVE_HIT_MARKERS < num_active_markers + 1 then
			local oldest_index = 1
			local oldest_time = hit_markers[1].fade_time

			for i = 2, num_active_markers do
				local fade_time = hit_markers[i].fade_time

				if fade_time < oldest_time then
					oldest_index = i
					oldest_time = fade_time
				end
			end

			next_index = oldest_index
		else
			next_index = num_active_markers + 1
			num_active_markers = num_active_markers + 1
		end

		self._num_hit_markers = num_active_markers
		local hit_marker = hit_markers[next_index]
		local hit_fade_time = Managers.time:time("ui") + HIT_FADE_DURATION
		local r, g, b = nil

		if attack_result == AttackSettings.attack_results.blocked or not did_damage then
			r = 72
			g = 123.75
			b = 191.25
		elseif attack_result == AttackSettings.attack_results.damaged then
			r = 255
			g = hit_weakspot and 165 or 255
			b = hit_weakspot and 0 or 255
		elseif attack_result == AttackSettings.attack_results.died then
			r = 255
			g = 0
			b = 0
		else
			hit_fade_time = 0
		end

		hit_marker.fade_time = hit_fade_time
		hit_marker.color.r = r
		hit_marker.color.g = g
		hit_marker.color.b = b

		if hit_world_position then
			hit_marker.hit_world_position:store(hit_world_position)

			local viewport = ScriptWorld.viewport(self._world, self._player.viewport_name)
			local camera = ScriptViewport.camera(viewport)
			local screen_pos, distance = Camera.world_to_screen(camera, hit_world_position)

			hit_marker.previous_screen_position:store(screen_pos)
		end

		self._hit_fade_time = hit_fade_time
		self._hit_fade_color.r = r
		self._hit_fade_color.g = g
		self._hit_fade_color.b = b
	end
end

local dirs = {
	-1,
	-1,
	1,
	1,
	-1,
	1,
	1,
	-1
}

local function _draw_marker(gui, position, length, alpha_multiplier, hit_fade_color, offset_scale)
	for i = 1, 4 do
		local offset = Vector3(dirs[i * 2 - 1], dirs[i * 2], 0)
		local p1 = position + offset * offset_scale + offset * length
		local p2 = position + offset * offset_scale

		ScriptGui.hud_line(gui, p1, p2, 100, 2, Color(alpha_multiplier * 255, hit_fade_color.r, hit_fade_color.g, hit_fade_color.b))
	end
end

PlayerUnitPlaceholderHudExtension._update_hit_indicator = function (self, dt, gui, w, h)
	local hit_markers = self._hit_markers
	local num_hit_markers = self._num_hit_markers

	if num_hit_markers <= 0 then
		return
	end

	local t = Managers.time:time("ui")
	local wielded_weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)
	local multiple_markers = wielded_weapon_template and wielded_weapon_template.hit_marker_type == "multiple"
	local center_marker = wielded_weapon_template and wielded_weapon_template.hit_marker_type == "center"
	local viewport = ScriptWorld.viewport(self._world, self._player.viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local index = 1

	while num_hit_markers >= index do
		local hit_marker = hit_markers[index]
		local hit_fade_time = hit_marker.fade_time
		local hit_fade_color = hit_marker.color
		local alpha_multiplier = (hit_fade_time - t) / HIT_FADE_DURATION

		if alpha_multiplier > 0 then
			local hit_world_position = hit_marker.hit_world_position:unbox()
			local previous_screen_position = hit_marker.previous_screen_position:unbox()
			local screen_pos, distance = Camera.world_to_screen(camera, hit_world_position)

			hit_marker.previous_screen_position:store(screen_pos)

			screen_pos = Vector3.lerp(previous_screen_position, screen_pos, dt)

			if multiple_markers then
				_draw_marker(gui, screen_pos, 3, alpha_multiplier, hit_fade_color, 4)
			end

			index = index + 1
		else
			hit_markers[index].fade_time = hit_markers[num_hit_markers].fade_time
			hit_markers[index].color = hit_markers[num_hit_markers].color

			hit_markers[index].hit_world_position:store(hit_markers[num_hit_markers].hit_world_position:unbox())

			num_hit_markers = num_hit_markers - 1
		end
	end

	self._num_hit_markers = num_hit_markers
	local mid_pos = Vector3(w / 2, h / 2, 0)
	local hit_fade_time = self._hit_fade_time
	local hit_fade_color = self._hit_fade_color
	local alpha_multiplier = (hit_fade_time - t) / HIT_FADE_DURATION

	if alpha_multiplier > 0 and center_marker then
		_draw_marker(gui, mid_pos, 4, alpha_multiplier, hit_fade_color, 25)
	end
end

return PlayerUnitPlaceholderHudExtension
