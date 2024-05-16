-- chunkname: @scripts/extension_systems/wounds/wounds_extension.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local WoundMaterials = require("scripts/extension_systems/wounds/utilities/wound_materials")
local WoundsTemplates = require("scripts/settings/damage/wounds_templates")
local attack_results = AttackSettings.attack_results
local REUSE_WOUNDS = false
local CLIENT_RPCS = {
	"rpc_minion_add_wounds",
}
local WoundsExtension = class("WoundsExtension")

WoundsExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._breed = extension_init_data.breed
	self._unit = unit
	self._wounds_data, self._max_num_wounds = WoundMaterials.create_data()
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

	local wounds_config = self._breed.wounds_config
	local health_percent_throttle

	if wounds_config then
		health_percent_throttle = wounds_config.health_percent_throttle
	end

	self._next_wound_health_percent = health_percent_throttle and 1 - health_percent_throttle or math.huge

	local is_server = extension_init_context.is_server

	self._is_server = is_server

	if not is_server then
		local network_event_delegate = extension_init_context.network_event_delegate

		self._network_event_delegate = network_event_delegate
		self._game_object_id = nil_or_game_object_id

		network_event_delegate:register_session_unit_events(self, nil_or_game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = true
	end
end

WoundsExtension.destroy = function (self)
	if not self._is_server and self._unit_rpcs_registered then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = false
	end
end

WoundsExtension.game_object_initialized = function (self, game_session, game_object_id)
	self._game_session, self._game_object_id = game_session, game_object_id
end

WoundsExtension.set_unit_local = function (self)
	if not self._is_server then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._unit_rpcs_registered = false
		self._game_object_id = nil
	end

	self._unit_is_local = true
end

WoundsExtension.wounds_data = function (self)
	return self._wounds_data
end

WoundsExtension.add_wounds = function (self, wounds_template, hit_world_position, hit_actor_node_index, attack_result, percent_damage_dealt, damage_type, hit_zone_name_or_nil, override_wound_shape_or_nil)
	local wound_settings_for_attack_result = wounds_template[attack_result]

	if not wound_settings_for_attack_result then
		return
	end

	local wounds_data = self._wounds_data
	local is_killing_blow = attack_result == attack_results.died
	local max_num_wounds = self._max_num_wounds
	local at_max_wounds = wounds_data.num_wounds == max_num_wounds
	local wound_index
	local should_reuse_wounds = REUSE_WOUNDS

	if at_max_wounds then
		if should_reuse_wounds or is_killing_blow then
			wound_index = wounds_data.last_write_index % max_num_wounds + 1
		else
			return
		end
	else
		wound_index = wounds_data.last_write_index + 1
	end

	local wounds_config = self._breed.wounds_config

	if wounds_config then
		if is_killing_blow then
			if at_max_wounds and not should_reuse_wounds and not wounds_config.always_show_killing_blow then
				return
			end
		else
			local thresholds = wounds_config.thresholds

			if thresholds then
				local threshold_for_damage_type = thresholds[damage_type]

				if threshold_for_damage_type then
					if percent_damage_dealt < threshold_for_damage_type then
						return
					end
				elseif wounds_config.apply_threshold_filtering then
					return
				end
			end

			local health_percent_throttle = wounds_config.health_percent_throttle

			if health_percent_throttle then
				local current_health_percent = self._health_extension:current_health_percent()

				if current_health_percent > self._next_wound_health_percent then
					return
				else
					self._next_wound_health_percent = math.max(0, current_health_percent - health_percent_throttle)
				end
			end
		end
	end

	local wound_settings_for_hit_zone = wound_settings_for_attack_result[hit_zone_name_or_nil] or wound_settings_for_attack_result.default
	local wound_shape = override_wound_shape_or_nil or wound_settings_for_hit_zone.default_shape
	local wound_settings = wound_settings_for_hit_zone[wound_shape]
	local unit, hit_actor_bind_pose = self._unit, self._unit_data_extension:node_bind_pose(hit_actor_node_index)
	local t, slot_items = World.time(Unit.world(unit)), self._visual_loadout_extension:slot_items()

	WoundMaterials.calculate(unit, wounds_config, wounds_data, wound_index, wound_settings, wound_shape, hit_actor_node_index, hit_actor_bind_pose, hit_world_position, t)

	local wounds_enabled_locally = Application.user_setting("gore_settings", "minion_wounds_enabled")

	if wounds_enabled_locally == nil then
		wounds_enabled_locally = GameParameters.minion_wounds_enabled
	end

	if not DEDICATED_SERVER and wounds_enabled_locally then
		WoundMaterials.apply(unit, wounds_data, wound_index, slot_items)
	end

	if not at_max_wounds then
		wounds_data.num_wounds = wound_index
	end

	wounds_data.last_write_index = wound_index

	if self._is_server and not self._unit_is_local then
		local wounds_template_id = NetworkLookup.wounds_templates[wounds_template.name]
		local hit_zone_id_or_nil = hit_zone_name_or_nil and NetworkLookup.hit_zones[hit_zone_name_or_nil] or nil
		local override_wounds_shape_id_or_nil = override_wound_shape_or_nil and NetworkLookup.wounds_shapes[override_wound_shape_or_nil] or nil
		local attack_result_id = NetworkLookup.attack_results[attack_result]
		local damage_type_id = NetworkLookup.damage_types[damage_type]

		Managers.state.game_session:send_rpc_clients("rpc_minion_add_wounds", self._game_object_id, wounds_template_id, hit_world_position, hit_actor_node_index, attack_result_id, percent_damage_dealt, damage_type_id, hit_zone_id_or_nil, override_wounds_shape_id_or_nil)

		local slot_name = "slot_flesh"
		local visual_loadout_extension = self._visual_loadout_extension
		local is_flesh_slot_visible = visual_loadout_extension:is_slot_visible(slot_name)

		if not is_flesh_slot_visible then
			visual_loadout_extension:set_slot_visibility(slot_name, true)
		end
	elseif self._unit_is_local then
		local slot_name = "slot_flesh"
		local visual_loadout_extension = self._visual_loadout_extension
		local is_flesh_slot_visible = visual_loadout_extension:is_slot_visible(slot_name)

		if not is_flesh_slot_visible then
			visual_loadout_extension:_set_slot_visibility(slot_name, true)
		end
	end
end

WoundsExtension.rpc_minion_add_wounds = function (self, channel_id, go_id, wounds_template_id, hit_world_position, hit_actor_node_index, attack_result_id, percent_damage_dealt, damage_type_id, hit_zone_id_or_nil, override_wounds_shape_id_or_nil)
	local override_wounds_shape_or_nil = override_wounds_shape_id_or_nil and NetworkLookup.wounds_shapes[override_wounds_shape_id_or_nil]
	local hit_zone_name_or_nil = hit_zone_id_or_nil and NetworkLookup.hit_zones[hit_zone_id_or_nil]
	local wounds_template_name = NetworkLookup.wounds_templates[wounds_template_id]
	local wounds_template = WoundsTemplates[wounds_template_name]
	local damage_type = NetworkLookup.damage_types[damage_type_id]
	local attack_result = NetworkLookup.attack_results[attack_result_id]

	self:add_wounds(wounds_template, hit_world_position, hit_actor_node_index, attack_result, percent_damage_dealt, damage_type, hit_zone_name_or_nil, override_wounds_shape_or_nil)
end

return WoundsExtension
