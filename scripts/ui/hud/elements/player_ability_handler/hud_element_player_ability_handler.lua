local Definitions = require("scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler_definitions")
local HudElementPlayerAbility = require("scripts/ui/hud/elements/player_ability/hud_element_player_ability")
local HudElementPlayerSlotItemAbility = require("scripts/ui/hud/elements/player_ability/hud_element_player_slot_item_ability")
local HudElementPlayerAbilityHandlerSettings = require("scripts/ui/hud/elements/player_ability_handler/hud_element_player_ability_handler_settings")
local HudElementPlayerAbilityHandler = class("HudElementPlayerAbilityHandler", "HudElementBase")

HudElementPlayerAbilityHandler.init = function (self, parent, draw_layer, start_scale)
	HudElementPlayerAbilityHandler.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._parent = parent
	self._instance_data_tables = {}
	self._slot_names_array = self:_setup_slot_name_list()
	self._num_slots = 0
	self._max_slots = #self._slot_names_array
	self._scan_delay = HudElementPlayerAbilityHandlerSettings.scan_delay
	self._scan_delay_duration = 0
end

HudElementPlayerAbilityHandler._setup_slot_name_list = function (self)
	local slot_names_array = {}
	local ui_scenegraph = self._ui_scenegraph

	for scenegraph_id, _ in pairs(ui_scenegraph) do
		if scenegraph_id ~= "screen" then
			slot_names_array[#slot_names_array + 1] = scenegraph_id
		end
	end

	return slot_names_array
end

HudElementPlayerAbilityHandler._player_scan = function (self, ui_renderer)
	local scale = ui_renderer.scale
	local draw_layer = self._draw_layer
	local parent = self._parent
	local player = parent:player()
	local instance_data_tables = self._instance_data_tables
	local num_slots = 0
	local extensions = parent:player_extensions()
	local ability_extension = extensions.ability
	local equipped_abilities = ability_extension:equipped_abilities()
	local setup_settings_by_slot = HudElementPlayerAbilityHandlerSettings.setup_settings_by_slot
	local unit = player.player_unit
	local is_player_alive = ALIVE[unit]
	local force_alignment_update = false

	if is_player_alive then
		for ability_id, ability_settings in pairs(equipped_abilities) do
			local slot_id = "slot_" .. ability_id
			local setup_settings = setup_settings_by_slot[slot_id]
			local has_scenegraph = setup_settings ~= nil

			if has_scenegraph then
				local hud_icon = ability_settings.hud_icon
				local ability_name = ability_settings.name
				local instance_data = instance_data_tables[ability_id]
				local name_differs = instance_data and instance_data.ability_name ~= ability_name

				if not instance_data then
					local can_add_abilities = num_slots < self._max_slots

					if can_add_abilities then
						force_alignment_update = true
						local definition_path = setup_settings.definition_path
						local data = {
							synced = true,
							ability_name = ability_name,
							player = player,
							scenegraph_id = slot_id,
							slot_id = slot_id,
							ability_id = ability_id,
							icon = hud_icon,
							definition_path = definition_path
						}
						instance_data_tables[ability_id] = data
						data.instance = HudElementPlayerAbility:new(parent, draw_layer, scale, data)
					end
				elseif not name_differs or instance_data_tables[ability_id].ability_name == ability_name then
					instance_data_tables[ability_id].synced = true
				end

				num_slots = num_slots + 1
			end
		end

		local unit_data = extensions.unit_data
		local visual_loadout_extension = extensions.visual_loadout
		local item_slots = HudElementPlayerAbilityHandlerSettings.item_slots

		for i = 1, #item_slots do
			local slot_id = item_slots[i]
			local setup_settings = setup_settings_by_slot[slot_id]
			local has_scenegraph = setup_settings ~= nil

			if has_scenegraph then
				local inventory_component = unit_data:read_component("inventory")
				local weapon_name = inventory_component[slot_id]
				local weapon_template = weapon_name and visual_loadout_extension:weapon_template_from_slot(slot_id)

				if weapon_template then
					local hud_icon = weapon_template.hud_icon

					if not instance_data_tables[weapon_name] then
						local can_add_abilities = num_slots < self._max_slots

						if can_add_abilities then
							local definition_path = setup_settings.definition_path
							local data = {
								synced = true,
								player = player,
								scenegraph_id = slot_id,
								weapon_name = weapon_name,
								weapon_template = weapon_template,
								slot_id = slot_id,
								icon = hud_icon,
								definition_path = definition_path
							}
							instance_data_tables[weapon_name] = data
							data.instance = HudElementPlayerSlotItemAbility:new(parent, draw_layer, scale, data)
						end
					else
						instance_data_tables[weapon_name].synced = true
					end

					num_slots = num_slots + 1
				end
			end
		end
	end

	local ability_removed = false

	for id, data in pairs(instance_data_tables) do
		if not data.synced then
			local instance = data.instance

			instance:destroy(ui_renderer)

			instance_data_tables[id] = nil
			ability_removed = true
			force_alignment_update = true
		else
			data.synced = false
		end
	end

	if ability_removed then
		self:_on_abilities_removed()
	end

	self:_update_ability_count(num_slots, force_alignment_update)
end

HudElementPlayerAbilityHandler._on_abilities_removed = function (self)
	return
end

HudElementPlayerAbilityHandler._update_ability_count = function (self, new_ability_count, force_alignment_update)
	if new_ability_count ~= self._num_slots or force_alignment_update then
		self._num_slots = new_ability_count

		self:_align_abilities()
	end
end

HudElementPlayerAbilityHandler.set_scenegraph_position = function (self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)
	HudElementPlayerAbilityHandler.super.set_scenegraph_position(self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)

	local instance_data_tables = self._instance_data_tables

	for _, data in pairs(instance_data_tables) do
		if data.scenegraph_id == scenegraph_id then
			local instance = data.instance

			instance:set_scenegraph_position("slot", x, y, z, horizontal_alignment, vertical_alignment)
		end
	end
end

HudElementPlayerAbilityHandler._align_abilities = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local instance_data_tables = self._instance_data_tables

	for _, data in pairs(instance_data_tables) do
		local scenegraph_id = data.scenegraph_id
		local instance = data.instance
		local scenegraph_settings = ui_scenegraph[scenegraph_id]
		local position = scenegraph_settings.position
		local x = position[1]
		local y = position[2]
		local horizontal_alignment = scenegraph_settings.horizontal_alignment
		local vertical_alignment = scenegraph_settings.vertical_alignment

		instance:set_scenegraph_position("slot", x, y, nil, horizontal_alignment, vertical_alignment)
	end
end

HudElementPlayerAbilityHandler.destroy = function (self)
	local instance_data_tables = self._instance_data_tables

	for _, data in pairs(instance_data_tables) do
		local instance = data.instance

		instance:destroy()
	end

	self._instance_data_tables = nil
end

HudElementPlayerAbilityHandler.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	HudElementPlayerAbilityHandler.super.set_visible(self, visible, ui_renderer, use_retained_mode)

	for _, data in pairs(self._instance_data_tables) do
		local instance = data.instance

		if instance.set_visible then
			instance:set_visible(visible, ui_renderer, use_retained_mode)
		end
	end
end

HudElementPlayerAbilityHandler.on_resolution_modified = function (self)
	HudElementPlayerAbilityHandler.super.on_resolution_modified(self)

	for _, data in pairs(self._instance_data_tables) do
		local instance = data.instance

		instance:on_resolution_modified()
	end
end

HudElementPlayerAbilityHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerAbilityHandler.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_player_scan(ui_renderer)

		self._scan_delay_duration = self._scan_delay
	end

	local instance_data_tables = self._instance_data_tables

	for id, data in pairs(instance_data_tables) do
		local instance = data.instance

		instance:update(dt, t, ui_renderer, render_settings, input_service)
	end
end

HudElementPlayerAbilityHandler.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementPlayerAbilityHandler.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	for _, data in pairs(self._instance_data_tables) do
		local instance = data.instance

		instance:draw(dt, t, ui_renderer, render_settings, input_service)
	end
end

return HudElementPlayerAbilityHandler
