-- chunkname: @scripts/extension_systems/hazard_prop/hazard_prop_system.lua

require("scripts/extension_systems/hazard_prop/hazard_prop_extension")

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local HazardPropSettings = require("scripts/settings/hazard_prop/hazard_prop_settings")
local NetworkLookup = require("scripts/network_lookup/network_lookup")
local HazardPropSystem = class("HazardPropSystem", "ExtensionSystemBase")
local CLIENT_RPCS = {
	"rpc_hazard_prop_set_state",
	"rpc_hazard_prop_set_content",
	"rpc_hazard_prop_hot_join"
}

HazardPropSystem.init = function (self, context, system_init_data, ...)
	HazardPropSystem.super.init(self, context, system_init_data, ...)

	self._hazard_prop_settings = self:_fetch_settings(system_init_data.mission, context.circumstance_name)
	self._seed = system_init_data.level_seed

	if not self._is_server then
		self._network_event_delegate:register_session_events(self, unpack(CLIENT_RPCS))
	end
end

HazardPropSystem._fetch_settings = function (self, mission, circumstance_name)
	local original_settings = mission.hazard_prop_settings
	local circumstance_template = CircumstanceTemplates[circumstance_name]
	local mission_overrides = circumstance_template.mission_overrides
	local circumstance_settings = mission_overrides and mission_overrides.hazard_prop_settings or nil

	return circumstance_settings or original_settings
end

HazardPropSystem.destroy = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_events(unpack(CLIENT_RPCS))
	end
end

HazardPropSystem.hot_join_sync = function (self, sender, channel)
	local unit_to_extension_map = self._unit_to_extension_map

	for unit, extension in pairs(unit_to_extension_map) do
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)
		local state = extension:current_state()
		local state_id = NetworkLookup.hazard_prop_states[state]
		local content = extension:content()
		local content_id = NetworkLookup.hazard_prop_content[content]

		RPC.rpc_hazard_prop_hot_join(channel, level_unit_id, state_id, content_id)
	end
end

HazardPropSystem.rpc_hazard_prop_set_state = function (self, channel_id, level_unit_id, state_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local state = NetworkLookup.hazard_prop_states[state_id]

	extension:set_current_state(state)
end

HazardPropSystem.rpc_hazard_prop_set_content = function (self, channel_id, level_unit_id, content_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local content = NetworkLookup.hazard_prop_content[content_id]

	extension:set_content(content)
end

HazardPropSystem.rpc_hazard_prop_hot_join = function (self, channel_id, level_unit_id, state_id, content_id)
	local unit = Managers.state.unit_spawner:unit(level_unit_id, true)
	local extension = self._unit_to_extension_map[unit]
	local state = NetworkLookup.hazard_prop_states[state_id]
	local content = NetworkLookup.hazard_prop_content[content_id]

	extension:hot_join_sync(state, content)
end

HazardPropSystem.on_gameplay_post_init = function (self, level)
	self:_populate_hazard_props()
end

HazardPropSystem._shuffle = function (self, source)
	local seed = self._seed

	self._seed = table.shuffle(source, seed)
end

HazardPropSystem.re_populate_hazard_props = function (self)
	if not self._is_server then
		return
	end

	local idle_state = HazardPropSettings.hazard_state.idle

	for unit, extension in pairs(self._unit_to_extension_map) do
		extension:set_current_state(idle_state)
	end

	self:_populate_hazard_props()
end

HazardPropSystem._populate_hazard_props = function (self)
	if not self._is_server then
		return
	end

	local props = self._unit_to_extension_map
	local num_props = table.size(props)

	if num_props > 0 then
		local hazard_weight = {}
		local total_weight = 0
		local hazard_prop_settings = self._hazard_prop_settings

		if hazard_prop_settings then
			for hazard_type, value in pairs(hazard_prop_settings) do
				hazard_weight[hazard_type] = value
				total_weight = total_weight + value
			end
		else
			hazard_weight[HazardPropSettings.hazard_content.none] = 1
			total_weight = 1
		end

		local hazard_pool = {}
		local remainder = {}

		for hazard_type, weight in pairs(hazard_weight) do
			local percentage_of_pool = weight / total_weight
			local count = num_props * percentage_of_pool

			for i = 1, count do
				hazard_pool[#hazard_pool + 1] = hazard_type
			end

			remainder[hazard_type] = count % 1
		end

		if num_props > #hazard_pool then
			local fillers = self:_sort_remainders(remainder)

			for i = 1, #fillers do
				if num_props > #hazard_pool then
					hazard_pool[#hazard_pool + 1] = fillers[i]
				else
					break
				end
			end
		end

		self:_shuffle(hazard_pool)

		local i = 1

		for unit, extension in pairs(props) do
			extension:set_content(hazard_pool[i])

			i = i + 1
		end
	end
end

HazardPropSystem._sort_remainders = function (self, input)
	local sorted = {}

	while table.size(input) > 0 do
		local top_key
		local top_rem = -1

		for key, rem in pairs(input) do
			if top_rem < rem then
				top_key = key
				top_rem = rem
			end
		end

		if top_key then
			sorted[#sorted + 1] = top_key
			input[top_key] = nil
		else
			break
		end
	end

	return sorted
end

return HazardPropSystem
