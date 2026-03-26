-- chunkname: @scripts/extension_systems/expedition_loot_converter/expedition_loot_converter_extension.lua

local Pickups = require("scripts/settings/pickup/pickups")
local ExpeditionLootConverterExtension = class("ExpeditionLootConverterExtension")

ExpeditionLootConverterExtension.init = function (self, extension_init_context, unit)
	self._unit = unit
	self._world = extension_init_context.world
	self._is_server = extension_init_context.is_server
	self._animation_extension = nil
	self._first_frame_setup = false
	self._point_of_interest_extension = nil
	self._interactee_extension = nil
	self._can_interact = self._is_server and true or false
end

ExpeditionLootConverterExtension.destroy = function (self)
	self:despawn_loot_unit()
end

ExpeditionLootConverterExtension.setup_from_component = function (self)
	local unit = self._unit

	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._point_of_interest_extension = ScriptUnit.extension(unit, "point_of_interest_system")
	self._interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	if self._is_server then
		self:play_anim("up")
	end
end

ExpeditionLootConverterExtension.hot_join_sync = function (self, can_interact)
	self._can_interact = can_interact
end

ExpeditionLootConverterExtension.fixed_update = function (self, unit, dt, t)
	if self._is_server then
		if not self._first_frame_setup then
			self._first_frame_setup = true
		else
			self:_update_current_anim(dt)
		end
	end
end

ExpeditionLootConverterExtension._spawn_loot_unit = function (self, unit_name, node_name)
	local unit = self._unit
	local socket_node = Unit.node(unit, node_name)
	local socket_position = Unit.world_position(unit, socket_node)
	local socket_rotation = Unit.world_rotation(unit, socket_node)
	local world = self._world

	self._loot_dummy_unit = World.spawn_unit_ex(world, unit_name, nil, socket_position, socket_rotation)

	World.link_unit(world, self._loot_dummy_unit, 1, unit, socket_node)

	self._spawned_luggable_unit_name = unit_name
end

ExpeditionLootConverterExtension.despawn_loot_unit = function (self)
	if self._is_server then
		local loot_converter_level_id = Managers.state.unit_spawner:level_index(self._unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_expedition_loot_converter_despawn_loot_unit", loot_converter_level_id)
	end

	local luggable_dummy_unit = self._loot_dummy_unit

	if luggable_dummy_unit then
		local world = self._world

		World.unlink_unit(world, luggable_dummy_unit)
		World.destroy_unit(world, self._loot_dummy_unit)

		self._loot_dummy_unit = nil
		self._spawned_luggable_unit_name = nil
	end
end

ExpeditionLootConverterExtension.anim_state = function (self)
	return self._anim_state
end

ExpeditionLootConverterExtension.start_converting = function (self)
	return
end

ExpeditionLootConverterExtension.set_anim_state = function (self, anim_state)
	self._anim_time = nil

	local previous_state = self._anim_state

	if anim_state then
		if anim_state == "down" then
			self:play_anim("up_idle")
			self:play_anim("down")

			self._anim_time = 2
		elseif anim_state == "process" then
			self:play_anim("down_idle")
			self:play_anim("process")
			self:despawn_loot_unit()

			self._anim_time = 2
		elseif anim_state == "up" then
			self:play_anim("processed")
			self:play_anim("up")

			self._anim_time = 2
		end
	end

	self._anim_state = anim_state
end

ExpeditionLootConverterExtension._update_current_anim = function (self, dt)
	local anim_time = self._anim_time

	if not anim_time then
		return
	end

	anim_time = anim_time - dt

	local anim_complete = anim_time <= 0

	self._anim_time = anim_time

	if anim_complete then
		local anim_state = self._anim_state

		if anim_state == "down" then
			self:set_anim_state("process")
		elseif anim_state == "process" then
			self:set_anim_state("up")
		elseif anim_state == "up" then
			self:set_anim_state(nil)
			self:convertion_completed()
		end
	end
end

ExpeditionLootConverterExtension.stop_converting = function (self, success, interactor_unit, pickup_name)
	if success then
		local loot_converter_level_id = Managers.state.unit_spawner:level_index(self._unit)
		local game_session_manager = Managers.state.game_session
		local pickup_id = NetworkLookup.pickup_names[pickup_name]

		game_session_manager:send_rpc_clients("rpc_expedition_loot_converter_use", loot_converter_level_id, pickup_id)
		self:begin_convertion(pickup_name)

		local pickup_data = pickup_name and Pickups.by_name[pickup_name]
		local loot_data = pickup_data and pickup_data.loot_data
		local loot_type = loot_data.type
		local loot_tier = loot_data.tier

		Managers.event:trigger("event_expedition_convert_and_collect", interactor_unit, loot_type, loot_tier)

		local player = Managers.state.player_unit_spawn:owner(interactor_unit)

		if player then
			Managers.stats:record_team("hook_loot_team_luggable_delivered")
			Managers.achievements:unlock_achievement(player, "expeditions_use_loot_converter")
		end

		self:set_anim_state("down")
	else
		self:despawn_loot_unit()
	end
end

ExpeditionLootConverterExtension.begin_convertion = function (self, pickup_name)
	local pickup_data = pickup_name and Pickups.by_name[pickup_name]
	local pickup_unit_name = pickup_data.unit_name
	local interaction_type = pickup_data.interaction_type
	local node_name

	node_name = interaction_type == "pocketable" and "ap_expedition_loot_converter_01_pocketable" or "ap_expedition_loot_converter_01_luggable"

	self:_spawn_loot_unit(pickup_unit_name, node_name)

	self._can_interact = false
end

ExpeditionLootConverterExtension.convertion_completed = function (self)
	if self._is_server then
		local loot_converter_level_id = Managers.state.unit_spawner:level_index(self._unit)
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_expedition_loot_converter_convertion_complete", loot_converter_level_id)
	end

	self._can_interact = true
end

ExpeditionLootConverterExtension.can_interact = function (self)
	return self._can_interact or false
end

ExpeditionLootConverterExtension._set_block_text = function (self, text)
	if self._interactee_extension then
		self._interactee_extension:set_block_text(text)
	end
end

ExpeditionLootConverterExtension.play_anim = function (self, anim_event)
	self._animation_extension:anim_event(anim_event)
end

ExpeditionLootConverterExtension._update_indicators = function (self)
	local is_converting = false

	if not is_converting then
		Unit.set_scalar_for_materials(self._unit, "increase_color", -0.95)
	else
		local min_indicator_material = -1
		local max_indicator_material = 0.01
		local alpha = 1
		local indicator_level = math.lerp(min_indicator_material, max_indicator_material, alpha)

		Unit.set_scalar_for_materials(self._unit, "increase_color", indicator_level)
	end
end

return ExpeditionLootConverterExtension
