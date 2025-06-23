-- chunkname: @scripts/components/toxic_gas_corals.lua

local Component = require("scripts/utilities/component")
local ToxicGasFog = component("ToxicGasFog")
local ToxicGasCorals = component("ToxicGasCorals")

ToxicGasCorals.init = function (self, unit, is_server, nav_world)
	self._unit = unit

	local run_update = false

	self._is_server = is_server

	if rawget(_G, "LevelEditor") then
		run_update = true
	end

	return run_update
end

ToxicGasCorals.destroy = function (self, unit)
	self:disable(unit)
end

ToxicGasCorals.enable = function (self, unit)
	if not self._particle_created then
		Unit.flow_event(unit, "create_particle")

		self._particle_created = true
	end
end

ToxicGasCorals.disable = function (self, unit)
	if self._particle_created then
		Unit.flow_event(unit, "destroy_particle")

		self._particle_created = nil
	end
end

ToxicGasCorals.events.visibility_enable = function (self, unit)
	return
end

ToxicGasCorals.events.visibility_disable = function (self, unit)
	return
end

ToxicGasCorals.events.create_low_gas = function (self)
	if not self._low_gas_created then
		Unit.flow_event(self._unit, "create_low_gas")

		self._low_gas_created = true
	end
end

ToxicGasCorals.events.despawn_low_gas = function (self)
	if self._low_gas_created then
		Unit.flow_event(self._unit, "despawn_low_gas")

		self._low_gas_created = nil
	end
end

ToxicGasCorals.events.create_trigger_gas = function (self)
	Unit.flow_event(self._unit, "create_trigger_gas")
end

ToxicGasCorals.hot_join_sync = function (self, joining_client, joining_channel)
	if self._volume_enabled then
		Component.hot_join_sync_event_to_client(joining_client, joining_channel, self, "visibility_enable")
	elseif self._volume_disabled then
		Component.hot_join_sync_event_to_client(joining_client, joining_channel, self, "visibility_disable")
	end
end

local function _sort_func(a, b)
	return a.distance < b.distance
end

local function _add_data_script_data(object, component_guid, section_id, id)
	local script_data_to_update = {}
	local script_data = {}

	script_data.components = script_data.components or {}
	script_data.components[component_guid] = script_data.components[component_guid] or {}
	script_data.components[component_guid].component_data = script_data.components[component_guid].component_data or {}

	if not script_data.components[component_guid].component_data.section_id or script_data.components[component_guid].component_data.section_id ~= section_id then
		script_data.components[component_guid].component_data.section_id = section_id
	end

	if not script_data.components[component_guid].component_data.id or script_data.components[component_guid].component_data.id ~= id then
		script_data.components[component_guid].component_data.id = id
	end

	script_data_to_update[#script_data_to_update + 1] = {
		id = object.id,
		script_data = script_data
	}

	Application.console_send({
		type = "update_script_data",
		data = script_data_to_update
	})
end

ToxicGasCorals.editor_init = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	local dont_automatically_set_ids = self:get_data(unit, "dont_automatically_set_ids")

	if not dont_automatically_set_ids then
		self._update_script_data = true
	end

	return true
end

ToxicGasCorals.editor_toggle_visibility_state = function (self, visible)
	return
end

ToxicGasCorals.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

ToxicGasCorals.editor_destroy = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

local CLOSEST_CLOUD = {}

ToxicGasCorals.editor_update = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end

	if self._update_script_data then
		local fog_clouds = ToxicGasFog._fog_clouds

		if not fog_clouds or #fog_clouds == 0 then
			return
		end

		local level = LevelEditor:get_current_active_level()

		if LevelEditor:is_level_loaded(level) then
			local level_object_id = Unit.get_data(unit, "LevelEditor", "object_id")

			if LevelEditor:is_existing_level_object(level, level_object_id) then
				table.clear(CLOSEST_CLOUD)

				for i = 1, #fog_clouds do
					local fog_unit = fog_clouds[i].unit
					local distance = Vector3.distance(Unit.world_position(unit, 1), Unit.world_position(fog_unit, 1))

					CLOSEST_CLOUD[#CLOSEST_CLOUD + 1] = {
						distance = distance,
						fog_unit = fog_unit,
						component = fog_clouds[i].component
					}
				end

				if #CLOSEST_CLOUD == 0 then
					return
				end

				local level_object = LevelEditor:get_level_object(level, level_object_id)
				local current_id = self:get_data(unit, "id")
				local current_section_id = self:get_data(unit, "section_id")

				table.sort(CLOSEST_CLOUD, _sort_func)

				local closest_cloud = CLOSEST_CLOUD[1]
				local closest_fog_unit = closest_cloud.fog_unit
				local component = closest_cloud.component
				local id = component:get_data(closest_fog_unit, "id")
				local section_id = component:get_data(closest_fog_unit, "section")

				if current_id == id and current_section_id == section_id then
					self._update_script_data = false

					return true
				end

				Log.info("ToxicGasCorals", "Automatically set Toxic Fog Corals Section ID: %d and ID: %d", section_id, id)
				_add_data_script_data(level_object, self.guid, section_id, id)

				self._update_script_data = false
			end
		end
	end

	return true
end

ToxicGasCorals.editor_property_changed = function (self, unit)
	if not rawget(_G, "LevelEditor") then
		return
	end
end

ToxicGasCorals._editor_debug_draw = function (self, unit)
	return
end

ToxicGasCorals.component_data = {
	id = {
		ui_type = "number",
		min = 1,
		step = 1,
		value = 0,
		ui_name = "ID",
		max = 100
	},
	section_id = {
		ui_type = "number",
		min = 1,
		step = 1,
		value = 0,
		ui_name = "Section ID",
		max = 50
	},
	dont_automatically_set_ids = {
		ui_type = "check_box",
		value = false,
		ui_name = "Dont Automatically Set IDs"
	}
}

return ToxicGasCorals
