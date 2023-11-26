-- chunkname: @scripts/extension_systems/interaction/interactee_extension.lua

local Component = require("scripts/utilities/component")
local Interactions = require("scripts/settings/interaction/interactions")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local MasterItems = require("scripts/backend/master_items")
local InteracteeExtension = class("InteracteeExtension")
local emissive_colors = InteractionSettings.emissive_colors
local interaction_results = InteractionSettings.results

InteracteeExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data, game_object_id)
	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._unit = unit
	self._used = false
	self._is_being_used = false

	local start_active = not extension_init_data.start_inactive

	self._started_active = start_active
	self._active = start_active
	self._spawn_cooldown = extension_init_data.spawn_interaction_cooldown
	self._owner_system = extension_init_context.owner_system
	self._interactions = {}
	self._override_contexts = {}
	self._active_interaction_type = nil
	self._active_interaction_changed = false
	self._emissive_material_name = nil
	self._animation_extension = nil

	if is_server then
		local level_id = Managers.state.unit_spawner:level_index(unit)

		if level_id then
			self._unit_id = level_id
			self._is_level_unit = true
		end
	end

	self:set_interaction_context(extension_init_data.interaction_type, extension_init_data.override_context, true)
end

InteracteeExtension.update = function (self, unit, dt, t)
	local spawn_cooldown = self._spawn_cooldown

	if spawn_cooldown then
		spawn_cooldown = spawn_cooldown - dt

		if spawn_cooldown <= 0 then
			spawn_cooldown = nil
		end

		self._spawn_cooldown = spawn_cooldown
	else
		self._owner_system:disable_update_function(self.__class_name, "update", self._unit, self)
	end
end

InteracteeExtension.hot_join_sync = function (self, unit, sender, channel)
	local is_active = self._active
	local active_type_changed = self._active_interaction_changed

	if is_active ~= self._started_active or active_type_changed or self._used then
		local unit_id, is_level_unit, is_used, active_type_id = self._unit_id, self._is_level_unit, self._used, 0

		if active_type_changed then
			active_type_id = NetworkLookup.interaction_type_strings[self._active_interaction_type]
		end

		RPC.rpc_interaction_hot_join(channel, unit_id, is_level_unit, is_active, is_used, active_type_id)
	end
end

InteracteeExtension.game_object_initialized = function (self, session, game_object_id)
	if not self._is_level_unit then
		self._unit_id, self._is_level_unit = game_object_id, false
	end
end

InteracteeExtension.set_interaction_context = function (self, interaction_type, override_context, set_active)
	if interaction_type then
		local interactions = self._interactions

		if not interactions[interaction_type] then
			local interaction_template = InteractionTemplates[interaction_type]

			if not interaction_template then
				return
			end

			local interaction_class_name = interaction_template.interaction_class_name

			interactions[interaction_type] = Interactions[interaction_class_name]:new(interaction_template)
		end

		local override_contexts = self._override_contexts

		if not override_contexts[interaction_type] then
			override_contexts[interaction_type] = override_context
		end

		if set_active then
			self._active_interaction_type = interaction_type
		end
	end
end

InteracteeExtension.setup_animation = function (self)
	self._animation_extension = ScriptUnit.has_extension(self._unit, "animation_system")
end

InteracteeExtension.animation_event = function (self, anim_event)
	if self._is_server and self._animation_extension then
		self._animation_extension:anim_event(anim_event)
	end
end

InteracteeExtension.can_interact = function (self, interactor_unit)
	if self._spawn_cooldown then
		return false
	end

	if self._used and self._active then
		self._active = false

		self:update_light()

		return false
	end

	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return false
	end

	local active_override_context = self._override_contexts[active_interaction_type]
	local shared_interaction = active_override_context.shared_interaction
	local is_being_used = self._is_being_used and not shared_interaction and interactor_unit ~= self._interactor_unit

	if is_being_used then
		return false
	end

	if active_override_context.block_text then
		return false
	end

	local is_active = self._active

	if not is_active then
		return false
	end

	local interaction = self._interactions[active_interaction_type]

	return interaction:interactee_condition_func(self._unit)
end

InteracteeExtension.show_marker = function (self, interactor_unit)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return false
	end

	local interaction = self._interactions[active_interaction_type]

	return interaction:interactee_show_marker_func(interactor_unit, self._unit)
end

InteracteeExtension.set_active = function (self, is_active)
	if self._is_server then
		local unit_id, is_level_unit = self._unit_id, self._is_level_unit

		Managers.state.game_session:send_rpc_clients("rpc_interaction_set_active", unit_id, is_level_unit, is_active)
	end

	self._active = not not is_active

	self:update_light()
end

InteracteeExtension.set_emissive_material_name = function (self, material_name)
	self._emissive_material_name = material_name

	self:update_light()
end

InteracteeExtension.update_light = function (self)
	if not self._emissive_material_name then
		return
	end

	local color_box

	if self._used then
		color_box = emissive_colors.used
	elseif self._active then
		color_box = emissive_colors.active
	else
		color_box = emissive_colors.inactive
	end

	local color = color_box:unbox()

	Unit.set_vector3_for_material(self._unit, self._emissive_material_name, "emissive_color", color)
end

InteracteeExtension.hot_join_setup = function (self, is_active, is_used, active_type)
	self._active = is_active
	self._used = is_used

	if active_type then
		self._active_interaction_type = active_type
	end

	self:update_light()
	Component.event(self._unit, "interactee_hot_joined")
end

InteracteeExtension.set_used = function (self)
	self._used = true
	self._active = false

	self:update_light()
end

InteracteeExtension.used = function (self)
	return self._used
end

InteracteeExtension.active = function (self)
	return self._active
end

InteracteeExtension.interaction_type = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return "none"
	end

	local interaction = self._interactions[active_interaction_type]

	return interaction:type()
end

InteracteeExtension.interaction_length = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return 0
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.duration or interaction:duration()
end

InteracteeExtension.set_missing_players = function (self, is_missing)
	if is_missing then
		self:set_block_text("loc_action_interaction_generic_missing_players")
	else
		self:set_block_text(nil)
	end

	if self._is_server then
		local unit_id, is_level_unit = self._unit_id, self._is_level_unit

		Managers.state.game_session:send_rpc_clients("rpc_interaction_set_missing_player", unit_id, is_level_unit, is_missing)
	end
end

InteracteeExtension.display_start_event = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return false
	end

	local override_context = self._override_contexts[active_interaction_type]

	return override_context.display_start_event or false
end

InteracteeExtension.disable_display_start_event = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]

	override_context.display_start_event = false
end

InteracteeExtension.interaction_priority = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.interaction_priority or interaction:interaction_priority()
end

InteracteeExtension.interaction_input = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.interaction_input or interaction:interaction_input()
end

InteracteeExtension.ui_interaction_type = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.ui_interaction_type or interaction:ui_interaction_type()
end

InteracteeExtension.interaction_icon = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.interaction_icon or interaction:interaction_icon()
end

InteracteeExtension.set_action_text = function (self, text)
	local active_interaction_type = self._active_interaction_type

	if active_interaction_type then
		local override_context = self._override_contexts[active_interaction_type]

		override_context.action_text = text
	end
end

InteracteeExtension.action_text = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.action_text or interaction:action_text()
end

InteracteeExtension.set_description = function (self, description)
	local active_interaction_type = self._active_interaction_type

	if active_interaction_type then
		local override_context = self._override_contexts[active_interaction_type]

		override_context.description = description
	end
end

InteracteeExtension.set_duration = function (self, duration)
	local active_interaction_type = self._active_interaction_type

	if active_interaction_type then
		local override_context = self._override_contexts[active_interaction_type]

		override_context.duration = duration
	end
end

InteracteeExtension.description = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.description or interaction:description()
end

InteracteeExtension.set_block_text = function (self, text, block_text_context)
	local active_interaction_type = self._active_interaction_type

	if active_interaction_type then
		local override_context = self._override_contexts[active_interaction_type]

		override_context.block_text = text
		override_context.block_text_context = block_text_context
	end
end

InteracteeExtension.block_text = function (self, interactor_unit)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return
	end

	local override_context = self._override_contexts[active_interaction_type]
	local is_being_used = self._is_being_used and not override_context.shared_interaction and interactor_unit ~= self._interactor_unit

	if is_being_used then
		return "loc_action_interaction_already_in_use"
	end

	if not override_context.block_text then
		return
	end

	return override_context.block_text, override_context.block_text_context
end

InteracteeExtension.hold_required = function (self)
	return self:interaction_length() > 0
end

InteracteeExtension.interactor_item_to_equip = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return nil
	end

	local override_context = self._override_contexts[active_interaction_type]
	local item_to_equip = override_context.interactor_item_to_equip

	if item_to_equip and item_to_equip ~= "" then
		local item = MasterItems.get_item(item_to_equip)

		if not item then
			Log.error("InteracteeExtension", "missing inventory item: %s for interaction: %s", item, active_interaction_type)

			return MasterItems.find_fallback_item("slot_device")
		end

		return item
	end

	return nil
end

InteracteeExtension.ui_interaction = function (self)
	local active_interaction_type = self._active_interaction_type

	if not active_interaction_type then
		return nil
	end

	local override_context = self._override_contexts[active_interaction_type]
	local interaction = self._interactions[active_interaction_type]

	return override_context.ui_view_name or interaction:ui_view_name()
end

InteracteeExtension.started = function (self, interactor_unit)
	if self._is_server then
		local unit_id, is_level_unit = self._unit_id, self._is_level_unit
		local interactor_object_id = Managers.state.unit_spawner:game_object_id(interactor_unit)

		Managers.state.game_session:send_rpc_clients("rpc_interaction_started", unit_id, is_level_unit, interactor_object_id)
	end

	self._is_being_used = true
	self._interactor_unit = interactor_unit

	Unit.set_flow_variable(self._unit, "lua_interactor_unit", interactor_unit)
	self:_trigger_flow_event("lua_interaction_start")
end

InteracteeExtension.stopped = function (self, result)
	if self._is_server then
		local unit_id, is_level_unit = self._unit_id, self._is_level_unit
		local result_id = NetworkLookup.interaction_result[result]

		Managers.state.game_session:send_rpc_clients("rpc_interaction_stopped", unit_id, is_level_unit, result_id)
	end

	if result == interaction_results.success then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(self._interactor_unit)

		if player and not player.remote then
			self:_trigger_flow_event("lua_interaction_success_local")
		end

		self:_trigger_flow_event("lua_interaction_success_network_synced")

		local active_interaction_type = self._active_interaction_type

		if active_interaction_type then
			local override_context = self._override_contexts[active_interaction_type]
			local interaction = self._interactions[active_interaction_type]
			local only_once = override_context.only_once or interaction:only_once()

			if only_once then
				self:set_used()
			end
		end
	else
		self:_trigger_flow_event("lua_interaction_cancelled")
	end

	self._interactor_unit = nil
	self._is_being_used = false
end

InteracteeExtension._trigger_flow_event = function (self, event_name)
	Unit.flow_event(self._unit, event_name)
end

InteracteeExtension.activate_interaction = function (self, interaction_type)
	self._active_interaction_type = interaction_type
	self._active_interaction_changed = true

	if not self._interactions[self._active_interaction_type] or not self._override_contexts[self._active_interaction_type] then
		self._active_interaction_type = nil
	end
end

return InteracteeExtension
