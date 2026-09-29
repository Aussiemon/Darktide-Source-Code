-- chunkname: @scripts/extension_systems/ability/player_unit_ability_extension.lua

local AbilityActionHandlerData = require("scripts/settings/ability/ability_action_handler_data")
local AbilityTemplates = require("scripts/settings/ability/ability_templates/ability_templates")
local ActionHandler = require("scripts/utilities/action/action_handler")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local EquippedAbilityEffectScripts = require("scripts/extension_systems/ability/utilities/equipped_ability_effect_scripts")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Items = require("scripts/utilities/items")
local MasterItems = require("scripts/backend/master_items")
local PlayerAbilities = require("scripts/settings/ability/player_abilities/player_abilities")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local ability_configuration = PlayerCharacterConstants.ability_configuration
local ability_types = table.keys(PlayerCharacterConstants.ability_configuration)
local buff_keywords = BuffSettings.keywords
local proc_events = BuffSettings.proc_events
local special_rules = SpecialRulesSettings.special_rules
local PlayerUnitAbilityExtension = class("PlayerUnitAbilityExtension")
local RESOURCE_AMOUNT_PRECISION = NetworkConstants.ability_resource_precision
local RESOURCE_AMOUNT_PRECISION_EPSILON = 1 / (RESOURCE_AMOUNT_PRECISION * 100)
local EPSILON = 0.0001
local EPSILON_INVERSE = 1 / (EPSILON * 100)

PlayerUnitAbilityExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	self._unit = unit

	local player = extension_init_data.player

	self._player = player

	local world = extension_init_context.world

	self._world = world

	local physics_world = extension_init_context.physics_world

	self._physics_world = physics_world

	local wwise_world = extension_init_context.wwise_world

	self._wwise_world = wwise_world
	self._initial_fixed_frame_t = extension_init_context.fixed_frame_t

	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")

	self._first_person_extension = first_person_extension
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self:_init_action_components(unit_data_extension)

	self._unit_data_extension = unit_data_extension

	local is_server = extension_init_data.is_server

	self._is_server = is_server

	local is_local_unit = extension_init_data.is_local_unit

	self._is_local_unit = is_local_unit
	self._abilities = {}
	self._equipped_abilities = {}
	self._charge_replenished = {}
	self._previous_num_max_charges = Script.new_map(3)
	self._previous_num_max_ability_resource = Script.new_map(3)
	self._skip_giving_extra_max_charges_player_respawn = Script.new_map(3)
	self._last_num_charges_used = {}

	local action_handler = ActionHandler:new(unit, AbilityActionHandlerData)

	for i = 1, #ability_types do
		action_handler:add_component(ability_types[i] .. "_action")
	end

	self._action_handler = action_handler
	self._item_definitions = MasterItems.get_cached()
	self._equipped_ability_effect_scripts = {}
	self._equipped_ability_effect_scripts_context = {
		world = world,
		physics_world = physics_world,
		wwise_world = wwise_world,
		unit = unit,
		unit_data_extension = unit_data_extension,
		is_local_unit = is_local_unit,
		is_server = is_server
	}

	if GameParameters.destroy_unmanaged_particles then
		local player_particle_group = Managers.state.extension:system("fx_system").unit_to_particle_group_lookup[unit]

		self._equipped_ability_effect_scripts_context.player_particle_group_id = player_particle_group
	end

	if is_server then
		self:_init_sync_data(game_object_data_or_game_session)
	end
end

PlayerUnitAbilityExtension._init_action_components = function (self, unit_data_extension)
	local ability_components = {}
	local equipped_abilities_component = unit_data_extension:write_component("equipped_abilities")

	for i = 1, #ability_types do
		local ability_type = ability_types[i]

		equipped_abilities_component[ability_type] = "none"

		local ability_component = unit_data_extension:write_component(ability_type)

		ability_component.active = false
		ability_component.enabled = true
		ability_component.num_charges = 0
		ability_component.resource = 0
		ability_component.resource_regen_paused = false
		ability_components[ability_type] = ability_component
	end

	local action_module_ability_target_finder = unit_data_extension:write_component("action_module_ability_target_finder")

	action_module_ability_target_finder.target_unit_1 = nil
	action_module_ability_target_finder.target_unit_2 = nil
	action_module_ability_target_finder.target_unit_3 = nil
	self._equipped_abilities_component = equipped_abilities_component
	self._ability_components = ability_components
end

PlayerUnitAbilityExtension._init_sync_data = function (self, game_object_data)
	local init_equipped_value = "not_equipped"
	local init_max_charges_value = 0
	local init_enabled_value = true
	local init_max_resource_value = 0
	local init_charge_max_regen_time = 0
	local ability_max_charges_sync_value = {}
	local ability_max_resource_sync_value = {}
	local ability_charge_max_regen_time_sync_value = {}

	for i = 1, #ability_types do
		local ability_type = ability_types[i]

		game_object_data[ability_type .. "_equipped"] = NetworkLookup.player_abilities[init_equipped_value]
		game_object_data[ability_type .. "_enabled"] = init_enabled_value
		ability_max_charges_sync_value[ability_type] = init_max_charges_value
		ability_max_resource_sync_value[ability_type] = init_max_resource_value
		ability_charge_max_regen_time_sync_value[ability_type] = init_charge_max_regen_time
	end

	self._ability_max_charges_sync_value = ability_max_charges_sync_value
	self._ability_max_resource_sync_value = ability_max_resource_sync_value
	self._ability_charge_max_regen_time_sync_value = ability_charge_max_regen_time_sync_value
end

PlayerUnitAbilityExtension.extensions_ready = function (self, world, unit)
	local action_handler = self._action_handler
	local action_context = {}
	local unit_data_extension = self._unit_data_extension
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local talent_extension = ScriptUnit.extension(unit, "talent_system")

	self._visual_loadout_extension = visual_loadout_extension
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._talent_extension = talent_extension
	self._fx_extension = ScriptUnit.extension(unit, "fx_system")
	action_context.first_person_unit = first_person_unit
	action_context.world = self._world
	action_context.physics_world = self._physics_world
	action_context.wwise_world = Managers.world:wwise_world(self._world)
	action_context.player_unit = self._unit
	action_context.is_server = self._is_server
	action_context.is_local_unit = self._is_local_unit
	action_context.unit_data_extension = unit_data_extension
	action_context.smart_targeting_extension = ScriptUnit.extension(unit, "smart_targeting_system")
	action_context.input_extension = self._input_extension
	action_context.first_person_extension = self._first_person_extension
	action_context.fx_extension = self._fx_extension
	action_context.animation_extension = ScriptUnit.extension(unit, "animation_system")
	action_context.camera_extension = ScriptUnit.extension(unit, "camera_system")
	action_context.ability_extension = self
	action_context.dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")
	action_context.weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	action_context.inventory_component = unit_data_extension:read_component("inventory")
	action_context.visual_loadout_extension = visual_loadout_extension
	action_context.first_person_component = unit_data_extension:read_component("first_person")
	action_context.sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")
	action_context.locomotion_component = unit_data_extension:read_component("locomotion")
	action_context.movement_state_component = unit_data_extension:read_component("movement_state")

	action_handler:extensions_ready(world, unit)
	action_handler:set_action_context(action_context)

	self._pause_cooldown_context = {
		is_server = self._is_server,
		unit = unit,
		unit_data_extension = unit_data_extension,
		inventory_component = unit_data_extension:read_component("inventory"),
		talent_extension = talent_extension,
		buff_extension = ScriptUnit.extension(unit, "buff_system")
	}
end

PlayerUnitAbilityExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

PlayerUnitAbilityExtension.on_player_unit_spawn = function (self, spawn_grenade_percentage)
	local ability_components = self._ability_components
	local grenade_component = ability_components.grenade_ability
	local num_charges = grenade_component.num_charges
	local num_spawn_charges = math.ceil(num_charges * spawn_grenade_percentage)
	local uses_ability_charges = self:uses_ability_charges("grenade_ability")

	if uses_ability_charges then
		self:set_ability_charges("grenade_ability", num_spawn_charges)
	end
end

PlayerUnitAbilityExtension.on_player_unit_respawn = function (self, respawn_grenade_percentage)
	local ability_components = self._ability_components
	local grenade_component = ability_components.grenade_ability
	local num_charges = grenade_component.num_charges
	local num_respawn_charges = math.ceil(num_charges * respawn_grenade_percentage)
	local uses_ability_charges = self:uses_ability_charges("grenade_ability")

	if uses_ability_charges then
		local grenade_ability_type = "grenade_ability"

		self:set_ability_charges(grenade_ability_type, num_respawn_charges)

		self._skip_giving_extra_max_charges_player_respawn[grenade_ability_type] = true
	end
end

PlayerUnitAbilityExtension.equip_ability = function (self, ability_type, ability, fixed_t)
	self._equipped_abilities_component[ability_type] = ability.name

	self:_equip_ability(ability_type, ability, fixed_t)
end

PlayerUnitAbilityExtension.unequip_ability = function (self, ability_type, fixed_t)
	self._action_input_extension:clear_input_queue_and_sequences_by_ability_type(ability_type)

	local ability = self._equipped_abilities[ability_type]

	self:_unequip_ability(ability_type, ability, fixed_t)

	self._equipped_abilities_component[ability_type] = "none"
end

PlayerUnitAbilityExtension._equip_ability = function (self, ability_type, ability, fixed_t, from_server_correction)
	Log.info("PlayerUnitAbilityExtension", "Equipping ability %q of type %q%s", ability.name, ability_type, from_server_correction and " from server correction" or "")

	self._equipped_abilities[ability_type] = ability

	local inventory_item_name = ability.inventory_item_name

	from_server_correction = not not from_server_correction

	local slot_name = self:get_slot_name(ability_type)

	if ability.inventory_item_name then
		local item = self._item_definitions[inventory_item_name]

		if not from_server_correction then
			PlayerUnitVisualLoadout.equip_item_to_slot(self._unit, item, slot_name, nil, self._initial_fixed_frame_t)
		end
	end

	if ability.ability_template then
		local component_name = ability_type .. "_action"
		local ability_template_name = ability.ability_template
		local ability_template = AbilityTemplates[ability_template_name]

		if not from_server_correction then
			self._action_handler:set_active_template(component_name, ability_template.name, slot_name)
		end

		self._abilities[component_name] = {
			ability_template = ability_template,
			ability_type = ability_type,
			slot_name = slot_name,
			ability = ability,
			actions = {}
		}

		local equipped_ability_effect_scripts = {}

		self._equipped_ability_effect_scripts[ability_type] = equipped_ability_effect_scripts

		local equipped_ability_effect_scripts_context = self._equipped_ability_effect_scripts_context

		EquippedAbilityEffectScripts.create(equipped_ability_effect_scripts_context, equipped_ability_effect_scripts, ability_template, ability_type)
	end

	local max_ability_charges = self:max_ability_charges(ability_type)
	local max_ability_resource = self:max_ability_resource(ability_type)

	self._previous_num_max_charges[ability_type] = max_ability_charges
	self._previous_num_max_ability_resource[ability_type] = max_ability_resource
	self._skip_giving_extra_max_charges_player_respawn[ability_type] = false

	if not from_server_correction then
		local component = self._ability_components[ability_type]

		component.num_charges = self:max_ability_charges(ability_type)
		component.resource = math.round(max_ability_resource * RESOURCE_AMOUNT_PRECISION)
		component.resource_regen_paused = false
	end

	if self._is_server then
		local game_object_field = ability_type .. "_equipped"

		GameSession.set_game_object_field(self._game_session, self._game_object_id, game_object_field, NetworkLookup.player_abilities[ability.name])
	end
end

PlayerUnitAbilityExtension._unequip_ability = function (self, ability_type, ability, fixed_t, from_server_correction)
	Log.info("PlayerUnitAbilityExtension", "Unequipping ability %q of type %q%s", ability.name, ability_type, from_server_correction and " from server correction" or "")

	local inventory_item_name = ability.inventory_item_name

	from_server_correction = not not from_server_correction

	if inventory_item_name then
		local slot_name = self:get_slot_name(ability_type)

		if not from_server_correction then
			PlayerUnitVisualLoadout.unequip_item_from_slot(self._unit, slot_name, fixed_t)
		end
	end

	if ability.ability_template then
		local component_name = ability_type .. "_action"

		if not from_server_correction then
			self._action_handler:set_active_template(component_name, "none", nil)
		end

		self._abilities[component_name] = nil

		local equipped_ability_effect_scripts = self._equipped_ability_effect_scripts[ability_type]

		EquippedAbilityEffectScripts.destroy(equipped_ability_effect_scripts)

		self._equipped_ability_effect_scripts[ability_type] = nil
	end

	self._equipped_abilities[ability_type] = nil
	self._previous_num_max_charges[ability_type] = nil
	self._previous_num_max_ability_resource[ability_type] = nil
	self._skip_giving_extra_max_charges_player_respawn[ability_type] = nil

	if self._is_server then
		local game_object_field = ability_type .. "_equipped"

		GameSession.set_game_object_field(self._game_session, self._game_object_id, game_object_field, NetworkLookup.player_abilities.not_equipped)
	end
end

PlayerUnitAbilityExtension.equipped_abilities = function (self)
	return self._equipped_abilities
end

PlayerUnitAbilityExtension.ability_is_equipped = function (self, ability_type)
	return self._equipped_abilities[ability_type]
end

PlayerUnitAbilityExtension.ability_slot_by_ability_name = function (self, name)
	for ability_type, ability in pairs(self._equipped_abilities) do
		if ability.name == name then
			return self:get_slot_name(ability_type)
		end
	end

	return nil
end

PlayerUnitAbilityExtension.ability_type_by_ability_name = function (self, name)
	for ability_type, ability in pairs(self._equipped_abilities) do
		if ability.name == name then
			return ability_type
		end
	end

	return nil
end

PlayerUnitAbilityExtension.update = function (self, unit, dt, t)
	self._action_handler:update(dt, t)

	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.update(ability_effect_scripts, unit, dt, t)
	end
end

PlayerUnitAbilityExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local condition_func_params = self:_condition_func_params()

	self._action_handler:fixed_update(dt, t, condition_func_params)
	self:_update_ability_resources(t, dt)

	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.fixed_update(ability_effect_scripts, unit, dt, t)
	end
end

PlayerUnitAbilityExtension.post_update = function (self, unit, dt, t, fixed_frame)
	for ability_type, ability_effect_scripts in pairs(self._equipped_ability_effect_scripts) do
		EquippedAbilityEffectScripts.post_update(ability_effect_scripts, unit, dt, t)
	end

	if self._is_server then
		self:_handle_sync()
	end
end

PlayerUnitAbilityExtension._handle_sync = function (self)
	for i = 1, #ability_types do
		local ability_type = ability_types[i]

		if self:ability_is_equipped(ability_type) then
			local max_ability_charges = self:max_ability_charges(ability_type)

			if max_ability_charges ~= self._ability_max_charges_sync_value[ability_type] then
				GameSession.set_game_object_field(self._game_session, self._game_object_id, ability_type .. "_max_charges", max_ability_charges)

				self._ability_max_charges_sync_value[ability_type] = max_ability_charges
			end

			if self:uses_ability_charges(ability_type) then
				local ability_charge_max_regen_time = self:max_regen_time_for_ability_charge(ability_type)

				if ability_charge_max_regen_time ~= self._ability_charge_max_regen_time_sync_value[ability_type] then
					GameSession.set_game_object_field(self._game_session, self._game_object_id, ability_type .. "_charge_max_regen_time", ability_charge_max_regen_time)

					self._ability_charge_max_regen_time_sync_value[ability_type] = ability_charge_max_regen_time
				end
			end

			local max_ability_resource = self:max_ability_resource(ability_type)

			if max_ability_resource ~= self._ability_max_resource_sync_value[ability_type] then
				GameSession.set_game_object_field(self._game_session, self._game_object_id, ability_type .. "_max_resource", max_ability_resource)

				self._ability_max_resource_sync_value[ability_type] = max_ability_resource
			end
		end
	end
end

local action_params = {}

local function _fill_action_params(params, data, component_name, unit_data_extension, ability_components)
	local ability = data.ability
	local ability_type = data.ability_type

	params.ability = ability
	params.ability_type = ability_type
	params.ability_component = ability_components[ability_type]
	params.slot_name = data.slot_name
end

PlayerUnitAbilityExtension.server_correction_occurred = function (self, unit, from_frame, to_frame)
	table.clear(action_params)

	local equipped_abilities_component = self._equipped_abilities_component
	local from_server_correction = true
	local fixed_t = from_frame * Managers.state.game_session.fixed_time_step
	local locally_equipped_abilities = self._equipped_abilities

	for ability_type, _ in pairs(ability_configuration) do
		local server_authoritative_equipped_ability_name = equipped_abilities_component[ability_type]
		local locally_equipped_ability = locally_equipped_abilities[ability_type]
		local locally_equipped_ability_name = locally_equipped_ability and locally_equipped_ability.name or "none"

		if locally_equipped_ability_name ~= server_authoritative_equipped_ability_name then
			if locally_equipped_ability_name ~= "none" then
				self:_unequip_ability(ability_type, locally_equipped_ability, fixed_t, from_server_correction)
			end

			if server_authoritative_equipped_ability_name ~= "none" then
				local ability = PlayerAbilities[server_authoritative_equipped_ability_name]

				self:_equip_ability(ability_type, ability, fixed_t, from_server_correction)
			end
		end
	end

	local ability_components = self._ability_components
	local unit_data_extension = self._unit_data_extension

	for component_name, data in pairs(self._abilities) do
		local action_objects, actions

		action_objects = data.actions
		actions = data.ability_template.actions

		_fill_action_params(action_params, data, component_name, unit_data_extension, ability_components)
		self._action_handler:server_correction_occurred(unit, from_frame, to_frame, component_name, action_objects, action_params, actions)
	end
end

PlayerUnitAbilityExtension.stop_action = function (self, reason, data, t)
	self._action_handler:stop_action("combat_ability_action", reason, data, t)

	local grenade_ability_action_settings = self:running_action_settings("grenade_ability_action")

	if grenade_ability_action_settings and not grenade_ability_action_settings.uninterruptible then
		self._action_handler:stop_action("grenade_ability_action", reason, data, t)
	end
end

local temp_table = {}

PlayerUnitAbilityExtension._condition_func_params = function (self, data)
	table.clear(temp_table)

	temp_table.ability_extension = self
	temp_table.input_extension = self._input_extension
	temp_table.unit_data_extension = self._unit_data_extension
	temp_table.talent_extension = self._talent_extension
	temp_table.slot_name = data and data.slot_name or nil
	temp_table.ability_type = data and data.ability_type or nil

	return temp_table
end

PlayerUnitAbilityExtension.update_ability_actions = function (self, fixed_frame)
	table.clear(action_params)

	local ability_components = self._ability_components
	local abilities, unit_data_extension = self._abilities, self._unit_data_extension

	for component_name, data in pairs(abilities) do
		local component = unit_data_extension:read_component(component_name)

		_fill_action_params(action_params, data, component_name, unit_data_extension, ability_components)

		local template_name = component.template_name

		if template_name ~= "none" then
			local action_objects, actions = data.actions, data.ability_template.actions
			local condition_func_params = self:_condition_func_params(data)

			self._action_handler:update_actions(fixed_frame, component_name, condition_func_params, actions, action_objects, action_params)
		end
	end
end

PlayerUnitAbilityExtension.charge_replenished = function (self, ability_type)
	return self._charge_replenished[ability_type]
end

PlayerUnitAbilityExtension.can_wield = function (self, slot_name, previous_check)
	for ability_type, ability_slot_name in pairs(ability_configuration) do
		if ability_slot_name == slot_name then
			local equipped_abilities = self._equipped_abilities
			local ability = equipped_abilities[ability_type]

			if ability then
				local can_be_wielded_when_depleted = ability.can_be_wielded_when_depleted
				local can_be_previously_wielded_to = not previous_check or ability.can_be_previously_wielded_to
				local can_use_ability = self:can_use_ability(ability_type)

				return can_use_ability and can_be_previously_wielded_to or can_be_wielded_when_depleted and can_be_previously_wielded_to
			end
		end
	end

	return true
end

PlayerUnitAbilityExtension.can_be_scroll_wielded = function (self, slot_name)
	local talent_extension = self._talent_extension

	for _, ability_slot_name in pairs(ability_configuration) do
		if ability_slot_name == slot_name then
			local disable_scroll_wield = talent_extension:has_special_rule(special_rules.zealot_throwing_knives)

			disable_scroll_wield = disable_scroll_wield or talent_extension:has_special_rule(special_rules.adamant_whistle)
			disable_scroll_wield = disable_scroll_wield or talent_extension:has_special_rule(special_rules.quick_flash_grenade)

			if disable_scroll_wield then
				return false
			end
		end
	end

	return true
end

PlayerUnitAbilityExtension.set_ability_enabled = function (self, ability_type, enable)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	component.enabled = enable

	if self._is_server then
		local game_object_field = ability_type .. "_enabled"

		GameSession.set_game_object_field(self._game_session, self._game_object_id, game_object_field, enable)
	end
end

PlayerUnitAbilityExtension.ability_enabled = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	return component.enabled
end

PlayerUnitAbilityExtension.can_use_ability = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return false
	end

	local equipped_ability = self._equipped_abilities[ability_type]

	if not equipped_ability then
		return false
	end

	local is_ability_usage_free = self._buff_extension:has_keyword(buff_keywords.free_ability_use)

	if is_ability_usage_free then
		return true
	end

	local uses_charges = self:uses_ability_charges(ability_type)

	if uses_charges then
		if self:max_ability_charges(ability_type) <= 0 then
			return true
		end

		local min_charges_usage_cost = equipped_ability and equipped_ability.min_charges_usage_cost or 1
		local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
		local has_enough_charges = self:has_enough_ability_charge_percentage(target_ability_resource_pool, min_charges_usage_cost)

		if not has_enough_charges then
			return false
		end
	else
		local ability_resource_cost_per_use = self:get_ability_resource_cost_per_use(ability_type)
		local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
		local remaining_ability_resource = self:remaining_ability_resource(target_ability_resource_pool)
		local has_enough_resource = ability_resource_cost_per_use <= remaining_ability_resource

		if not has_enough_resource then
			return false
		end
	end

	local ability_locked_while_active = equipped_ability.ability_locked_while_active
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	if ability_locked_while_active and component.active then
		return false
	end

	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]
	local required_weapon_type = ability.required_weapon_type

	if required_weapon_type and required_weapon_type == "ranged" then
		local item_in_primary_slot = self._visual_loadout_extension:item_in_slot("slot_primary")
		local item_in_secondary_slot = self._visual_loadout_extension:item_in_slot("slot_secondary")
		local has_ranged_weapon = Items.is_weapon_template_ranged(item_in_primary_slot) or Items.is_weapon_template_ranged(item_in_secondary_slot)

		if not has_ranged_weapon then
			return false
		end
	end

	return true
end

PlayerUnitAbilityExtension.has_ability_type = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]
	local has_ability_type = ability and true or false

	return has_ability_type
end

PlayerUnitAbilityExtension.action_input_is_currently_valid = function (self, component_name, action_input, used_input, current_fixed_t)
	local abilities = self._abilities
	local ability_data = abilities[component_name]
	local ability_template = ability_data.ability_template
	local actions = ability_template.actions
	local condition_func_params = self:_condition_func_params(ability_data)

	return self._action_handler:action_input_is_currently_valid(component_name, actions, condition_func_params, current_fixed_t, action_input, used_input)
end

PlayerUnitAbilityExtension.has_enough_ability_charge_percentage = function (self, ability_type, charge_percentage_needed)
	local remaining_ability_resource = self:remaining_ability_resource(ability_type)
	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local remaining_charges_percentage_value = remaining_ability_resource / resource_cost_per_charge

	return charge_percentage_needed <= remaining_charges_percentage_value
end

PlayerUnitAbilityExtension.remaining_ability_charges = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return 0
	end

	local ability_components = self._ability_components
	local component = ability_components[ability_type]
	local charges = component.num_charges

	return charges
end

PlayerUnitAbilityExtension.missing_ability_charges = function (self, ability_type)
	local max_charges = self:max_ability_charges(ability_type)
	local remaining_ability_charges = self:remaining_ability_charges(ability_type)
	local missing_charges = max_charges - remaining_ability_charges

	return missing_charges
end

PlayerUnitAbilityExtension.max_ability_charges = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return 0
	end

	local equipped_abilities = self._equipped_abilities
	local ability = equipped_abilities[ability_type]

	if not ability then
		return 0
	end

	local uses_charges = self:uses_ability_charges(ability_type)

	if not uses_charges then
		return 0
	end

	local buff_extension = self._buff_extension
	local has_extra_charges_keyword = buff_extension:has_keyword(buff_keywords.allow_extra_ability_charges)
	local max_charges = ability.max_charges
	local ability_stat_buff = ability.stat_buff

	if has_extra_charges_keyword and ability_type == "combat_ability" and ability_stat_buff == nil then
		ability_stat_buff = "ability_extra_charges"
	end

	if ability_stat_buff then
		local stat_buffs = self._buff_extension:stat_buffs()
		local buff_amount = stat_buffs[ability_stat_buff]

		max_charges = max_charges + buff_amount
	end

	return max_charges
end

PlayerUnitAbilityExtension._update_ability_resources = function (self, t, dt)
	table.clear(self._charge_replenished)

	local ability_components = self._ability_components
	local equipped_abilities = self._equipped_abilities
	local pause_cooldown_context = self._pause_cooldown_context
	local stat_buffs = self._buff_extension:stat_buffs()

	for ability_type, ability in pairs(equipped_abilities) do
		local ability_component = ability_components[ability_type]
		local usage_cost_type = ability.usage_cost_type or "charges"
		local uses_charges = usage_cost_type == "charges"
		local uses_resource = usage_cost_type == "resource"
		local max_ability_resource = self:max_ability_resource(ability_type)

		if uses_charges then
			local max_ability_charges = self:max_ability_charges(ability_type)
			local remaining_ability_charges = self:remaining_ability_charges(ability_type)
			local previous_num_max_charges = self._previous_num_max_charges[ability_type] or max_ability_charges
			local num_max_charges_dif = max_ability_charges - previous_num_max_charges

			if num_max_charges_dif > 0 and not self._skip_giving_extra_max_charges_player_respawn[ability_type] then
				local skip_restored_proc_event = true

				self:restore_ability_charge(ability_type, num_max_charges_dif, skip_restored_proc_event)
			elseif num_max_charges_dif < 0 and max_ability_charges <= remaining_ability_charges then
				self:set_ability_charges(ability_type, max_ability_charges)
			end

			self._skip_giving_extra_max_charges_player_respawn[ability_type] = false
			self._previous_num_max_charges[ability_type] = max_ability_charges
		elseif uses_resource then
			local remaining_ability_resource = self:remaining_ability_resource(ability_type)
			local previous_num_max_ability_resource = self._previous_num_max_ability_resource[ability_type] or max_ability_resource
			local num_max_resource_dif = max_ability_resource - previous_num_max_ability_resource

			if num_max_resource_dif > 0 and not self._skip_giving_extra_max_charges_player_respawn[ability_type] then
				local ignore_stat_buffs = true
				local skip_restored_proc_event = true

				self:restore_ability_resource(ability_type, num_max_resource_dif, ignore_stat_buffs, skip_restored_proc_event)
			elseif num_max_resource_dif < 0 and max_ability_resource <= remaining_ability_resource then
				self:set_ability_resource(ability_type, max_ability_resource)
			end

			self._skip_giving_extra_max_charges_player_respawn[ability_type] = false
			self._previous_num_max_ability_resource[ability_type] = max_ability_resource
		end

		if self:missing_ability_resource(ability_type) < 0 then
			self:set_ability_resource(ability_type, max_ability_resource)
		end

		local is_ability_resource_regen_paused = self:is_ability_resource_regen_paused(ability_type)

		if is_ability_resource_regen_paused then
			local pause_cooldown_settings = ability.pause_cooldown_settings
			local pause_fulfilled_func = pause_cooldown_settings and pause_cooldown_settings.pause_fulfilled_func

			if pause_fulfilled_func and pause_fulfilled_func(pause_cooldown_context, ability_component) then
				self:resume_ability_resource_regen(ability_type)

				is_ability_resource_regen_paused = false
			end
		end

		local should_update_regen = ability and not ability.only_uses_charges

		if should_update_regen then
			local should_update_ability_regen = self:should_update_ability_regen(ability_type)

			if should_update_ability_regen then
				local current_resource_amount = self:remaining_ability_resource(ability_type)
				local base_resource_regen_per_second = 0

				if not is_ability_resource_regen_paused then
					local base_flat_regen_per_second = ability.resource_regen_per_second or 0
					local base_percent_regen_per_second = max_ability_resource * (ability.resource_regen_percent_per_second or 0)

					base_resource_regen_per_second = base_flat_regen_per_second + base_percent_regen_per_second
				end

				local ability_resource_flat_regen_stat_buff = stat_buffs[ability_type .. "_resource_flat_regen"] or 0
				local ability_resource_regen_modifier_stat_buff = stat_buffs[ability_type .. "_resource_regen_modifier"] or 1
				local resource_regen_per_second = (base_resource_regen_per_second + ability_resource_flat_regen_stat_buff) * ability_resource_regen_modifier_stat_buff
				local resource_cost_per_second = self:get_ability_resource_cost_per_second(ability_type)
				local resource_amount_to_regen_per_second = resource_regen_per_second - resource_cost_per_second
				local resource_amount_to_regen = resource_amount_to_regen_per_second * dt
				local new_resource_amount = math.clamp(current_resource_amount + resource_amount_to_regen, 0, max_ability_resource)

				ability_component.resource = math.round((new_resource_amount + RESOURCE_AMOUNT_PRECISION_EPSILON) * RESOURCE_AMOUNT_PRECISION)

				if uses_charges then
					local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
					local max_ability_charges = self:max_ability_charges(ability_type)
					local remaining_ability_resource = self:remaining_ability_resource(ability_type)
					local new_num_charges = math.clamp(math.floor(remaining_ability_resource / resource_cost_per_charge), 0, max_ability_charges)
					local ability_charges_restored = new_num_charges - ability_component.num_charges

					ability_component.num_charges = new_num_charges

					if ability_charges_restored > 0 then
						self._charge_replenished[ability_type] = true

						self:_proc_ability_charge_replenished_event(ability_type, ability_charges_restored)
						self:_record_ability_charge_gained_stat(ability_type, ability_charges_restored)
					end
				end
			end
		end
	end
end

PlayerUnitAbilityExtension.set_ability_charges = function (self, ability_type, num_charges)
	local ability_component = self._ability_components[ability_type]
	local max_ability_charges = self:max_ability_charges(ability_type)
	local new_num_charges = math.clamp(num_charges, 0, max_ability_charges)

	ability_component.num_charges = new_num_charges

	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local new_resource_amount = new_num_charges * resource_cost_per_charge
	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)

	self:set_ability_resource(target_ability_resource_pool, new_resource_amount)
end

PlayerUnitAbilityExtension.set_ability_resource = function (self, ability_type, resource_value)
	local ability_components = self._ability_components
	local ability_component = ability_components[ability_type]

	ability_component.resource = math.round((resource_value + RESOURCE_AMOUNT_PRECISION_EPSILON) * RESOURCE_AMOUNT_PRECISION)
end

PlayerUnitAbilityExtension.consume_ability_usage_cost = function (self, ability_type, optional_usage_cost_override, optional_usage_cost_multiplier, optional_telemetry_ability_name)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0, 0
	end

	local equipped_abilities_component = self._equipped_abilities_component
	local ability_name = equipped_abilities_component[ability_type]
	local reporter = Managers.telemetry_reporters:reporter(ability_type)

	if reporter then
		local telemetry_ability_name = optional_telemetry_ability_name or ability_name

		reporter:register_event(self._player, telemetry_ability_name)
	end

	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._player
		param_table.ability_type = ability_type

		self._buff_extension:add_proc_event(proc_events.on_ability_used, param_table)
	end

	if self._is_server then
		Managers.stats:record_private("hook_ability_used", self._player, ability_type)
	end

	local usage_cost_multiplier = optional_usage_cost_multiplier or 1
	local usage_cost_type = ability.usage_cost_type or "charges"

	if usage_cost_type == "charges" then
		local is_charge_percentage, num_charges_to_deduct = self:get_num_ability_charges_to_use(ability_type, optional_usage_cost_override)
		local is_ability_usage_free = self._buff_extension:has_keyword(buff_keywords.free_ability_use)

		if is_ability_usage_free then
			if self._is_server then
				Managers.stats:record_private("hook_ability_charges_consumed_from_ability_use", self._player, ability_type, num_charges_to_deduct)
			end

			return num_charges_to_deduct, 0
		end

		local target_num_charges_used, actual_num_charges_used

		if is_charge_percentage then
			target_num_charges_used, actual_num_charges_used = self:consume_ability_charge_percentage(ability_type, num_charges_to_deduct * usage_cost_multiplier)
		else
			target_num_charges_used, actual_num_charges_used = self:consume_ability_charge(ability_type, num_charges_to_deduct * usage_cost_multiplier)
		end

		if self._is_server then
			Managers.stats:record_private("hook_ability_charges_consumed_from_ability_use", self._player, ability_type, target_num_charges_used)
		end

		return target_num_charges_used, actual_num_charges_used
	elseif usage_cost_type == "resource" then
		local target_resource_consumption = self:get_ability_resource_cost_per_use(ability_type, optional_usage_cost_override)
		local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
		local is_ability_usage_free = self._buff_extension:has_keyword(buff_keywords.free_ability_use)

		if is_ability_usage_free then
			local remaining_ability_resource = self:remaining_ability_resource(target_ability_resource_pool)

			return target_resource_consumption, 0, remaining_ability_resource
		end

		return self:consume_ability_resource(target_ability_resource_pool, target_resource_consumption * usage_cost_multiplier)
	else
		ferror("Trying to use usage cost type that is not supported: %s", usage_cost_type)
	end
end

PlayerUnitAbilityExtension.consume_ability_charge_percentage = function (self, ability_type, charge_cost_percentage_to_consume)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0, 0
	end

	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
	local _, actual_resource_consumed, new_resource_amount = self:consume_ability_resource(target_ability_resource_pool, resource_cost_per_charge * charge_cost_percentage_to_consume)
	local actual_charge_percentage_consumed = math.floor(actual_resource_consumed / resource_cost_per_charge + EPSILON)

	return charge_cost_percentage_to_consume, actual_charge_percentage_consumed, new_resource_amount
end

PlayerUnitAbilityExtension.consume_ability_charge = function (self, ability_type, num_charges_to_consume)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0
	end

	if ability_type == "grenade_ability" then
		local param_table = self._buff_extension:request_proc_event_param_table()

		if param_table then
			param_table.unit = self._player

			self._buff_extension:add_proc_event(proc_events.on_grenade_thrown, param_table)
		end
	end

	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
	local ability_components = self._ability_components
	local ability_component = ability_components[target_ability_resource_pool]
	local actual_num_charges_used = math.min(ability_component.num_charges, num_charges_to_consume)
	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)

	self:consume_ability_resource(target_ability_resource_pool, actual_num_charges_used * resource_cost_per_charge)

	self._last_num_charges_used[ability_type] = num_charges_to_consume

	return num_charges_to_consume, actual_num_charges_used
end

PlayerUnitAbilityExtension.consume_ability_resource_percentage = function (self, ability_type, resource_percent_to_consume)
	local max_ability_resource = self:max_ability_resource(ability_type)
	local resource_amount_to_consume = resource_percent_to_consume * max_ability_resource

	return self:consume_ability_resource(ability_type, resource_amount_to_consume)
end

PlayerUnitAbilityExtension.consume_ability_resource = function (self, ability_type, resource_amount_to_consume)
	local abilities = self._equipped_abilities
	local ability_components = self._ability_components
	local ability_component = ability_components[ability_type]
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0
	end

	local stat_buffs = self._buff_extension:stat_buffs()
	local max_ability_resource = self:max_ability_resource(ability_type)
	local remaining_ability_resource = self:remaining_ability_resource(ability_type)
	local ability_resource_flat_consumed_stat_buff = stat_buffs[ability_type .. "_resource_flat_consumed"] or 0
	local ability_resource_consumed_modifier_stat_buff = stat_buffs[ability_type .. "_resource_consumed_modifier"] or 1
	local target_resource_consumption = (resource_amount_to_consume + ability_resource_flat_consumed_stat_buff) * ability_resource_consumed_modifier_stat_buff
	local actual_resource_consumed = math.clamp(target_resource_consumption, 0, remaining_ability_resource)
	local new_resource_amount = math.clamp(remaining_ability_resource - target_resource_consumption, 0, max_ability_resource)

	self:set_ability_resource(ability_type, new_resource_amount)

	if target_resource_consumption > 0 then
		self:_proc_ability_resource_consumed_event(ability_type, target_resource_consumption, actual_resource_consumed)
	end

	local uses_ability_charges = self:uses_ability_charges(ability_type)

	if uses_ability_charges then
		local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
		local max_charges = self:max_ability_charges(ability_type)
		local remaining_ability_charges = self:remaining_ability_charges(ability_type)
		local new_num_charges = math.clamp(math.floor(new_resource_amount / resource_cost_per_charge + EPSILON), 0, max_charges)
		local ability_charges_consumed = remaining_ability_charges - new_num_charges

		ability_component.num_charges = new_num_charges

		if ability_charges_consumed > 0 then
			self:_proc_ability_charge_consumed_event(ability_type, ability_charges_consumed)
		end
	end

	return target_resource_consumption, actual_resource_consumed, new_resource_amount
end

PlayerUnitAbilityExtension.restore_ability_charge_percentage = function (self, ability_type, charge_cost_percentage_to_consume, skip_proc_event)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0
	end

	local uses_ability_charges = self:uses_ability_charges(ability_type)
	local resource_cost_per_charge

	if uses_ability_charges then
		resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	else
		resource_cost_per_charge = self:get_ability_resource_cost_per_use(ability_type)
	end

	local ignore_stat_buffs = true
	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
	local _, _, new_resource_amount = self:restore_ability_resource(target_ability_resource_pool, resource_cost_per_charge * charge_cost_percentage_to_consume, ignore_stat_buffs, skip_proc_event)

	return charge_cost_percentage_to_consume, new_resource_amount
end

PlayerUnitAbilityExtension.restore_ability_charge = function (self, ability_type, num_charges_to_restore, skip_proc_event)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local ignore_stat_buffs = true
	local _, _, ability_charges_restored = self:restore_ability_resource(ability_type, resource_cost_per_charge * num_charges_to_restore, ignore_stat_buffs, skip_proc_event)

	return num_charges_to_restore, ability_charges_restored
end

PlayerUnitAbilityExtension.restore_ability_resource_percentage = function (self, ability_type, resource_percent_to_restore, ignore_stat_buffs, skip_proc_event)
	local max_ability_resource = self:max_ability_resource(ability_type)
	local resource_amount_to_restore = resource_percent_to_restore * max_ability_resource

	return self:restore_ability_resource(ability_type, resource_amount_to_restore, ignore_stat_buffs, skip_proc_event)
end

PlayerUnitAbilityExtension.restore_ability_resource = function (self, ability_type, resource_amount_to_restore, ignore_stat_buffs, skip_proc_event)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0
	end

	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
	local remaining_ability_resource = self:remaining_ability_resource(target_ability_resource_pool)
	local max_ability_resource = self:max_ability_resource(target_ability_resource_pool)
	local target_resource_amount_to_restore = resource_amount_to_restore

	if not ignore_stat_buffs then
		local stat_buffs = self._buff_extension:stat_buffs()
		local ability_resource_flat_restored_stat_buff = stat_buffs[ability_type .. "_resource_flat_restored"] or 0
		local ability_resource_restored_modifier_stat_buff = stat_buffs[ability_type .. "_resource_restored_modifier"] or 1

		target_resource_amount_to_restore = (resource_amount_to_restore + ability_resource_flat_restored_stat_buff) * ability_resource_restored_modifier_stat_buff
	end

	target_resource_amount_to_restore = math.max(0, target_resource_amount_to_restore)

	local target_ability_component = self._ability_components[target_ability_resource_pool]
	local new_resource_amount = math.clamp(remaining_ability_resource + target_resource_amount_to_restore, 0, max_ability_resource)
	local actual_resource_amount_restored = new_resource_amount - remaining_ability_resource

	target_ability_component.resource = math.round((new_resource_amount + RESOURCE_AMOUNT_PRECISION_EPSILON) * RESOURCE_AMOUNT_PRECISION)

	if target_resource_amount_to_restore > 0 and not skip_proc_event then
		self:_proc_ability_resource_restored_event(ability_type, target_resource_amount_to_restore, actual_resource_amount_restored)
	end

	local uses_ability_charges = self:uses_ability_charges(target_ability_resource_pool)

	if uses_ability_charges then
		local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
		local max_charges = self:max_ability_charges(target_ability_resource_pool)
		local new_num_charges = math.clamp(math.floor(new_resource_amount / resource_cost_per_charge + EPSILON), 0, max_charges)
		local ability_charges_restored = new_num_charges - target_ability_component.num_charges

		target_ability_component.num_charges = new_num_charges

		if ability_charges_restored > 0 then
			self._charge_replenished[ability_type] = true

			if not skip_proc_event then
				self:_proc_ability_charge_replenished_event(ability_type, ability_charges_restored)
				self:_record_ability_charge_gained_stat(ability_type, ability_charges_restored)
			end
		end

		return target_resource_amount_to_restore, actual_resource_amount_restored, ability_charges_restored
	end

	return target_resource_amount_to_restore, actual_resource_amount_restored
end

PlayerUnitAbilityExtension.is_ability_active = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	return component.active
end

PlayerUnitAbilityExtension.should_update_ability_regen = function (self, ability_type)
	local missing_ability_resource = self:missing_ability_resource(ability_type)

	if missing_ability_resource > 0 then
		return true
	end

	local resource_cost_per_second = self:get_ability_resource_cost_per_second(ability_type)

	return resource_cost_per_second > 0
end

PlayerUnitAbilityExtension.pause_ability_resource_regen = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	component.resource_regen_paused = true
end

PlayerUnitAbilityExtension.resume_ability_resource_regen = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	component.resource_regen_paused = false
end

PlayerUnitAbilityExtension.is_ability_resource_regen_paused = function (self, ability_type)
	local enabled = self:ability_enabled(ability_type)

	if not enabled then
		return true
	end

	local ability_components = self._ability_components
	local component = ability_components[ability_type]

	return component.resource_regen_paused
end

PlayerUnitAbilityExtension.missing_ability_resource = function (self, ability_type)
	local remaining_ability_resource = self:remaining_ability_resource(ability_type) or 0
	local max_ability_resource = self:max_ability_resource(ability_type)

	return max_ability_resource - remaining_ability_resource
end

PlayerUnitAbilityExtension.remaining_ability_resource = function (self, ability_type)
	local ability_components = self._ability_components
	local component = ability_components[ability_type]
	local resource_network_value = component.resource

	return resource_network_value / RESOURCE_AMOUNT_PRECISION
end

PlayerUnitAbilityExtension.remaining_ability_resource_percentage = function (self, ability_type)
	local remaining_ability_resource = self:remaining_ability_resource(ability_type) or 0
	local max_ability_resource = self:max_ability_resource(ability_type)

	if max_ability_resource <= 0 then
		return 0
	end

	return remaining_ability_resource / max_ability_resource
end

PlayerUnitAbilityExtension.missing_ability_resource_until_next_charge = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0, 0
	end

	local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
	local max_ability_resource = self:max_ability_resource(target_ability_resource_pool)
	local remaining_ability_resource = self:remaining_ability_resource(target_ability_resource_pool)

	if max_ability_resource <= remaining_ability_resource then
		return 0, 0
	end

	local uses_ability_charges = self:uses_ability_charges(ability_type)

	if not uses_ability_charges then
		local missing_ability_resource = self:missing_ability_resource(ability_type)
		local missing_ability_resource_percentage = missing_ability_resource / max_ability_resource

		return missing_ability_resource, missing_ability_resource_percentage
	end

	local only_uses_charges = ability.only_uses_charges

	if only_uses_charges then
		return 0, 0
	end

	local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local remaining_ability_charges = self:remaining_ability_charges(target_ability_resource_pool)
	local remaining_ability_resource_for_current_charge = remaining_ability_resource - remaining_ability_charges * resource_cost_per_charge
	local missing_ability_resource_for_charge = math.clamp(resource_cost_per_charge - remaining_ability_resource_for_current_charge, 0, resource_cost_per_charge)
	local missing_ability_resource_for_charge_percentage = missing_ability_resource_for_charge / resource_cost_per_charge

	return missing_ability_resource_for_charge, missing_ability_resource_for_charge_percentage
end

PlayerUnitAbilityExtension.max_regen_time_for_ability_charge = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local uses_ability_charges = self:uses_ability_charges(ability_type)

	if not uses_ability_charges then
		return 0
	end

	local only_uses_charges = ability.only_uses_charges

	if only_uses_charges then
		return 0
	end

	local ability_resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)
	local base_resource_regen_per_second = ability.resource_regen_per_second or ability_resource_cost_per_charge * ability.resource_regen_percent_per_second

	return ability_resource_cost_per_charge / base_resource_regen_per_second
end

PlayerUnitAbilityExtension.max_ability_resource = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local stat_buffs = self._buff_extension:stat_buffs()
	local max_resource
	local uses_ability_charges = self:uses_ability_charges(ability_type)

	if uses_ability_charges then
		local max_charges = self:max_ability_charges(ability_type)
		local resource_cost_per_charge = self:get_ability_resource_cost_per_charge(ability_type)

		max_resource = max_charges * resource_cost_per_charge
	else
		local base_max_resource = ability.max_resource
		local ability_max_resource_stat_buff = stat_buffs[ability_type .. "_max_resource"] or 0
		local ability_max_resource_modifier_stat_buff = stat_buffs[ability_type .. "_max_resource_modifier"] or 1

		max_resource = (base_max_resource + ability_max_resource_stat_buff) * ability_max_resource_modifier_stat_buff
	end

	return max_resource
end

PlayerUnitAbilityExtension.uses_ability_charges = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return false
	end

	local usage_cost_type = ability.usage_cost_type or "charges"

	return usage_cost_type == "charges"
end

PlayerUnitAbilityExtension.get_target_ability_resource_pool = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return ability_type
	end

	local target_ability_resource_pool = ability_type
	local resource_pool_override = ability.resource_pool_override

	if resource_pool_override and abilities[resource_pool_override] then
		target_ability_resource_pool = resource_pool_override
	end

	return target_ability_resource_pool
end

PlayerUnitAbilityExtension.get_ability_resource_cost_per_second = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local stat_buffs = self._buff_extension:stat_buffs()
	local is_ability_active = self:is_ability_active(ability_type)
	local max_ability_resource = self:max_ability_resource(ability_type)
	local ability_resource_flat_cost_per_second_stat_buff = stat_buffs[ability_type .. "_resource_flat_cost_per_second"] or 0
	local resource_cost_per_second = ability_resource_flat_cost_per_second_stat_buff
	local base_resource_cost_per_second_while_active = ability.resource_cost_per_second_while_active or ability.resource_cost_percent_per_second_while_active and max_ability_resource * ability.resource_cost_percent_per_second_while_active or 0
	local resource_cost_per_second_while_active = is_ability_active and base_resource_cost_per_second_while_active or 0
	local ability_resource_flat_cost_while_active_stat_buff = stat_buffs[ability_type .. "_resource_flat_cost_while_active"] or 0
	local ability_resource_cost_while_active_modifier_stat_buff = stat_buffs[ability_type .. "_resource_cost_while_active_modifier"] or 1

	resource_cost_per_second_while_active = (resource_cost_per_second_while_active + ability_resource_flat_cost_while_active_stat_buff) * ability_resource_cost_while_active_modifier_stat_buff

	return resource_cost_per_second + resource_cost_per_second_while_active
end

PlayerUnitAbilityExtension.get_ability_resource_cost_per_use = function (self, ability_type, optional_usage_cost_override)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local target_resource_consumption = 0
	local resource_cost_per_use = ability.resource_cost_per_use
	local resource_cost_percent_per_use = ability.resource_cost_percent_per_use

	if resource_cost_per_use then
		target_resource_consumption = optional_usage_cost_override or resource_cost_per_use
	elseif resource_cost_percent_per_use then
		local max_ability_resource = self:max_ability_resource(ability_type)
		local resource_percent_to_consume = optional_usage_cost_override or resource_cost_percent_per_use

		target_resource_consumption = resource_percent_to_consume * max_ability_resource
	else
		ferror("Trying to consume ability usage cost for [%s] without any cost per use setup", ability.name)
	end

	local stat_buffs = self._buff_extension:stat_buffs()
	local ability_resource_flat_cost_per_use_stat_buff = stat_buffs[ability_type .. "_resource_flat_cost_per_use"] or 0
	local ability_resource_cost_per_use_modifier_stat_buff = stat_buffs[ability_type .. "_resource_cost_per_use_modifier"] or 1

	target_resource_consumption = (target_resource_consumption + ability_resource_flat_cost_per_use_stat_buff) * ability_resource_cost_per_use_modifier_stat_buff

	return math.max(0, target_resource_consumption)
end

PlayerUnitAbilityExtension.get_ability_resource_cost_per_charge = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local only_uses_charges = ability.only_uses_charges
	local resource_cost_per_charge = only_uses_charges and 1 or ability.resource_cost_per_charge

	if type(resource_cost_per_charge) == "table" then
		local min, max = resource_cost_per_charge.min, resource_cost_per_charge.max

		resource_cost_per_charge = ability.resource_cost_per_charge_lerp_func(self._player:profile(), min, max)
	end

	local stat_buffs = self._buff_extension:stat_buffs()
	local target_ability_resource_flat_cost_per_use = stat_buffs[ability_type .. "_resource_flat_cost_per_use"] or 0
	local target_ability_resource_cost_per_use_modifier = stat_buffs[ability_type .. "_resource_cost_per_use_modifier"] or 1

	resource_cost_per_charge = (resource_cost_per_charge + target_ability_resource_flat_cost_per_use) * target_ability_resource_cost_per_use_modifier
	resource_cost_per_charge = math.round((resource_cost_per_charge + EPSILON) * EPSILON_INVERSE) / EPSILON_INVERSE

	return resource_cost_per_charge
end

PlayerUnitAbilityExtension.get_ability_resource_regen_progress = function (self, ability_type)
	local abilities = self._equipped_abilities
	local ability = abilities[ability_type]

	if not ability then
		return 0
	end

	local usage_cost_type = ability.usage_cost_type or "charges"

	if usage_cost_type == "charges" then
		local _, missing_ability_resource_until_next_charge_percentage = self:missing_ability_resource_until_next_charge(ability_type)

		return 1 - missing_ability_resource_until_next_charge_percentage
	elseif usage_cost_type == "resource" then
		local target_ability_resource_pool = self:get_target_ability_resource_pool(ability_type)
		local max_ability_resource = self:max_ability_resource(target_ability_resource_pool)
		local missing_ability_resource = self:missing_ability_resource(target_ability_resource_pool)

		return 1 - math.clamp(missing_ability_resource / max_ability_resource, 0, 1)
	end
end

PlayerUnitAbilityExtension.get_num_ability_charges_to_use = function (self, ability_type, optional_num_charges)
	local equipped_ability = self._equipped_abilities[ability_type]

	if optional_num_charges then
		local is_charge_percentage = true

		return is_charge_percentage, optional_num_charges
	end

	local current_charges = self:remaining_ability_charges(ability_type)
	local min_charges_usage_cost = equipped_ability and equipped_ability.min_charges_usage_cost or 1
	local max_charges_usage_cost = equipped_ability and equipped_ability.max_charges_usage_cost or min_charges_usage_cost
	local is_charge_percentage = false
	local min_charges_percent_usage_cost = equipped_ability and equipped_ability.min_charges_percent_usage_cost
	local max_charges_percent_usage_cost = equipped_ability and equipped_ability.max_charges_percent_usage_cost or min_charges_percent_usage_cost

	if min_charges_percent_usage_cost and max_charges_percent_usage_cost then
		min_charges_usage_cost = min_charges_percent_usage_cost
		max_charges_usage_cost = max_charges_percent_usage_cost
		is_charge_percentage = true
	end

	local num_charges_to_use = math.clamp(current_charges, min_charges_usage_cost, max_charges_usage_cost)

	return is_charge_percentage, num_charges_to_use
end

PlayerUnitAbilityExtension.ability_charges_used_on_activation = function (self, ability_type)
	return self._last_num_charges_used[ability_type] or 1
end

PlayerUnitAbilityExtension.running_action_settings = function (self, target_ability_type)
	return self._action_handler:running_action_settings(target_ability_type or "combat_ability_action")
end

PlayerUnitAbilityExtension.wanted_character_state_transition = function (self)
	return self._action_handler:wanted_character_state_transition()
end

PlayerUnitAbilityExtension.get_slot_name = function (self, ability_type)
	return ability_configuration[ability_type]
end

PlayerUnitAbilityExtension.get_current_ability_name = function (self)
	local name = self._equipped_abilities.combat_ability.name

	return name
end

PlayerUnitAbilityExtension.get_current_grenade_ability_name = function (self)
	local grenade_ability = self._equipped_abilities.grenade_ability
	local name = grenade_ability and grenade_ability.name

	return name
end

PlayerUnitAbilityExtension.ability_name = function (self, ability_type)
	local ability = self._equipped_abilities[ability_type]

	return ability.name
end

PlayerUnitAbilityExtension.ability_pause_cooldown_settings = function (self, ability_type)
	local ability = self._equipped_abilities[ability_type]

	if not ability then
		return nil
	end

	return ability.pause_cooldown_settings
end

PlayerUnitAbilityExtension._proc_ability_charge_replenished_event = function (self, ability_type, num_charges_gained)
	local proc_event = string.format("on_%s_charge_replenished", ability_type)
	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._unit
		param_table.num_charges_gained = num_charges_gained

		self._buff_extension:add_proc_event(proc_event, param_table)
	end
end

PlayerUnitAbilityExtension._proc_ability_charge_consumed_event = function (self, ability_type, num_charges_used)
	local proc_event = string.format("on_%s_charge_consumed", ability_type)
	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._unit
		param_table.num_charges_consumed = num_charges_used

		self._buff_extension:add_proc_event(proc_event, param_table)
	end
end

PlayerUnitAbilityExtension._proc_ability_resource_restored_event = function (self, ability_type, target_resource_to_restore, actual_resource_restored)
	local proc_event = string.format("on_%s_resource_restored", ability_type)
	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._unit
		param_table.target_resource_to_restore = target_resource_to_restore
		param_table.actual_resource_restored = actual_resource_restored

		self._buff_extension:add_proc_event(proc_event, param_table)
	end
end

PlayerUnitAbilityExtension._proc_ability_resource_consumed_event = function (self, ability_type, target_resource_consumption, actual_resource_consumed)
	local proc_event = string.format("on_%s_resource_consumed", ability_type)
	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.unit = self._unit
		param_table.target_resource_consumption = target_resource_consumption
		param_table.actual_resource_consumed = actual_resource_consumed

		self._buff_extension:add_proc_event(proc_event, param_table)
	end
end

PlayerUnitAbilityExtension._record_ability_charge_gained_stat = function (self, ability_type, num_charges_gained)
	if not self._is_server then
		return
	end

	Managers.stats:record_private("hook_ability_charges_gained", self._player, ability_type, num_charges_gained)
end

return PlayerUnitAbilityExtension
