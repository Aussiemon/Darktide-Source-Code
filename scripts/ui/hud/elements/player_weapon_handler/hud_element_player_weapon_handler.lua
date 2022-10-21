local definition_path = "scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_definitions"
local HudElementPlayerWeapon = require("scripts/ui/hud/elements/player_weapon/hud_element_player_weapon")
local HudElementPlayerWeaponHandlerSettings = require("scripts/ui/hud/elements/player_weapon_handler/hud_element_player_weapon_handler_settings")
local ItemSlotSettings = require("scripts/settings/item/item_slot_settings")
local HudElementPlayerWeaponHandler = class("HudElementPlayerWeaponHandler", "HudElementBase")

HudElementPlayerWeaponHandler.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	HudElementPlayerWeaponHandler.super.init(self, parent, draw_layer, start_scale, definitions)

	self._parent = parent
	self._player_weapons = {}
	self._player_weapons_array = {}
	self._num_weapons = 0
	local slots_settings = HudElementPlayerWeaponHandlerSettings.slots_settings
	local max_slots = table.size(slots_settings)
	self._max_slots = max_slots

	for slot_name, slot_settings in pairs(slots_settings) do
		if slot_settings.default_wield_slot then
			self._default_wield_slot = slot_name

			break
		end
	end

	self._scan_delay = HudElementPlayerWeaponHandlerSettings.scan_delay
	self._scan_delay_duration = 0
end

local function sort_weapon_entries_by_order(a, b)
	return a.index < b.index
end

HudElementPlayerWeaponHandler._weapon_scan = function (self, extensions, ui_renderer)
	local scale = ui_renderer.scale
	local draw_layer = self._draw_layer
	local parent = self._parent
	local my_player = parent:player()
	local unit = my_player.player_unit
	local active = ALIVE[unit]

	if not active then
		return
	end

	local player_weapons = self._player_weapons
	local player_weapons_array = self._player_weapons_array
	local num_weapons = 0
	local visual_loadout_extension = extensions.visual_loadout
	local unit_data = extensions.unit_data
	local inventory_component = unit_data:read_component("inventory")
	local ability_extension = extensions.ability
	local force_update_positions = false

	for slot_id, settings in pairs(HudElementPlayerWeaponHandlerSettings.slots_settings) do
		local default_icon = settings.default_icon
		local slot_component = unit_data:read_component(slot_id)
		local item_slot_settings = ItemSlotSettings[slot_id]
		local weapon_name = inventory_component[slot_id]
		local slot_data = player_weapons[slot_id]
		local weapon_template = weapon_name and visual_loadout_extension:weapon_template_from_slot(slot_id)
		local item = weapon_name and visual_loadout_extension:item_from_slot(slot_id)

		if slot_data and slot_data.weapon_name ~= weapon_name then
			local weapon = slot_data.weapon

			weapon:destroy(ui_renderer)

			local array_index = table.index_of(player_weapons_array, slot_data)

			table.remove(player_weapons_array, array_index)

			player_weapons[slot_id] = nil
			force_update_positions = true
		end

		if weapon_template and not player_weapons[slot_id] then
			local can_add_weapons = num_weapons < self._max_slots

			if can_add_weapons then
				local ability_type = item_slot_settings.ability_type
				local ability = ability_type and ability_extension:ability_is_equipped(ability_type)
				local order_index = settings.order_index
				local data = {
					synced = true,
					player = my_player,
					slot_id = slot_id,
					item = item,
					icon = weapon_template.hud_icon,
					inventory_component = inventory_component,
					ability_extension = ability_extension,
					ability = ability,
					ability_type = ability_type,
					slot_component = slot_component,
					weapon_template = weapon_template,
					weapon_name = weapon_name,
					index = order_index
				}
				player_weapons[slot_id] = data
				player_weapons_array[#player_weapons_array + 1] = data
				data.weapon = HudElementPlayerWeapon:new(parent, draw_layer, scale, data)
				force_update_positions = true
			end
		end

		if player_weapons[slot_id] then
			num_weapons = num_weapons + 1
		end
	end

	if force_update_positions then
		table.sort(player_weapons_array, sort_weapon_entries_by_order)
	end

	self:_update_weapon_count(num_weapons, force_update_positions)
end

HudElementPlayerWeaponHandler._update_weapon_count = function (self, new_weapon_count, force_update)
	if force_update or new_weapon_count ~= self._num_weapons then
		self._num_weapons = new_weapon_count

		self:_set_wielded_slot(self._wielded_slot)
		self:_align_weapon_scenegraphs()
	end
end

HudElementPlayerWeaponHandler.set_scenegraph_position = function (self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)
	HudElementPlayerWeaponHandler.super.set_scenegraph_position(self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)
	self:_align_weapon_scenegraphs()
end

HudElementPlayerWeaponHandler._align_weapon_scenegraphs = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local scenegraph_id = "weapon_pivot"
	local scenegraph_settings = ui_scenegraph[scenegraph_id]
	local horizontal_alignment = scenegraph_settings.horizontal_alignment
	local vertical_alignment = scenegraph_settings.vertical_alignment
	local pivot_position = scenegraph_settings.position
	local start_x = pivot_position[1]
	local start_y = pivot_position[2]
	local offset_x = 0
	local offset_y = 0
	local weapon_spacing = HudElementPlayerWeaponHandlerSettings.weapon_spacing
	local player_weapons_array = self._player_weapons_array

	for _, data in ipairs(player_weapons_array) do
		local index = data.index
		local weapon = data.weapon
		index = 1
		offset_y = -(index - 1) * (HudElementPlayerWeaponHandlerSettings.size_small[2] + weapon_spacing[2])
		local x = start_x + offset_x
		local y = start_y + offset_y

		weapon:set_scenegraph_position("weapon", x, y, nil, horizontal_alignment, vertical_alignment)
	end
end

HudElementPlayerWeaponHandler.destroy = function (self, ui_renderer)
	local player_weapons = self._player_weapons

	for _, data in pairs(player_weapons) do
		local weapon = data.weapon

		weapon:destroy(ui_renderer)
	end

	self._player_weapons = nil
	self._player_weapons_array = nil
end

HudElementPlayerWeaponHandler.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	HudElementPlayerWeaponHandler.super.set_visible(self, visible)

	for _, data in ipairs(self._player_weapons_array) do
		local weapon = data.weapon

		if weapon.set_visible then
			weapon:set_visible(visible, ui_renderer, use_retained_mode)
		end
	end
end

HudElementPlayerWeaponHandler.on_resolution_modified = function (self)
	HudElementPlayerWeaponHandler.super.on_resolution_modified(self)

	for _, data in ipairs(self._player_weapons_array) do
		local weapon = data.weapon

		weapon:on_resolution_modified()
	end
end

HudElementPlayerWeaponHandler._set_wielded_slot = function (self, wielded_slot)
	self._wielded_slot = wielded_slot
	self._wield_anim_progress = 0
end

HudElementPlayerWeaponHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerWeaponHandler.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	local wield_anim_speed = HudElementPlayerWeaponHandlerSettings.wield_anim_speed
	local weapon_spacing = HudElementPlayerWeaponHandlerSettings.weapon_spacing

	if self._wield_anim_progress ~= 1 then
		local anim_progress = math.min((self._wield_anim_progress or 0) + dt * wield_anim_speed, 1)
		local wielded_slot = self._wielded_slot
		local player_weapons_array = self._player_weapons_array
		local height_offset = 0

		for _, data in ipairs(player_weapons_array) do
			local slot_id = data.slot_id
			local weapon = data.weapon
			local wield_progress = data.wield_progress or 0
			local wielded = wielded_slot == slot_id

			if wielded then
				wield_progress = math.min(wield_progress + dt * wield_anim_speed, 1)
			else
				wield_progress = math.max(wield_progress - dt * wield_anim_speed, 0)
			end

			if wield_progress ~= data.wield_progress then
				data.wield_progress = wield_progress
			end

			local size = HudElementPlayerWeaponHandlerSettings.size
			local size_small = HudElementPlayerWeaponHandlerSettings.size_small
			local width_difference = size[1] - size_small[1]
			local height_difference = size[2] - size_small[2]
			local extra_width = width_difference * wield_progress
			local extra_height = height_difference * wield_progress
			local width = size_small[1] + extra_width
			local height = size_small[2] + extra_height

			weapon:set_size(width, height)
			weapon:set_height_offset(-height_offset)
			weapon:set_wield_anim_progress(wield_progress)

			height_offset = height_offset + height + weapon_spacing[2]
		end

		for slot_id, data in pairs(self._player_weapons) do
			-- Nothing
		end

		self._wield_anim_progress = anim_progress
	end

	local parent = self._parent
	local extensions = parent:player_extensions()

	if not extensions then
		return
	end

	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_weapon_scan(extensions, ui_renderer)

		self._scan_delay_duration = self._scan_delay
	end

	local unit_data = extensions.unit_data
	local inventory_component = unit_data:read_component("inventory")
	local wielded_slot = inventory_component.wielded_slot
	local slots_settings = HudElementPlayerWeaponHandlerSettings.slots_settings
	self._wielding_none_weapon_slot = not slots_settings[wielded_slot]

	if self._wielding_none_weapon_slot then
		wielded_slot = self._wielded_slot or self._default_wield_slot
	end

	if wielded_slot ~= self._wielded_slot then
		self:_set_wielded_slot(wielded_slot)
	end

	local player_weapons_array = self._player_weapons_array

	for _, data in ipairs(player_weapons_array) do
		local slot_id = data.slot_id

		if slot_id then
			local weapon = data.weapon

			weapon:update(dt, t, ui_renderer, render_settings, input_service)
		else
			self:_weapon_scan(extensions, ui_renderer)

			break
		end
	end
end

HudElementPlayerWeaponHandler.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerWeaponHandler.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	for _, data in pairs(self._player_weapons) do
		local weapon = data.weapon

		weapon:draw(dt, t, ui_renderer, render_settings, input_service)
	end
end

return HudElementPlayerWeaponHandler
