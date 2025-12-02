-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_interacting.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interacting = require("scripts/extension_systems/character_state_machine/character_states/utilities/interacting")
local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateInteracting = class("PlayerCharacterStateInteracting", "PlayerCharacterStateBase")
local DEFAULT_ITEM_SLOT_TO_WIELD = "slot_unarmed"
local EXTERNAL_PROPERTIES = {}
local LOOPING_SOUND_ALIAS = "interact_loop"

PlayerCharacterStateInteracting.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateInteracting.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local interacting_character_state_component = unit_data_extension:write_component("interacting_character_state")

	interacting_character_state_component.interaction_template = "none"
	self._interacting_character_state_component = interacting_character_state_component
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
end

PlayerCharacterStateInteracting.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateInteracting.super.on_enter(self, unit, dt, t, previous_state, params)

	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Interrupt.ability_and_action(t, unit, "interacting", nil)
	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)

	local interaction_component = self._interaction_component
	local interactee_unit = interaction_component.target_unit
	local interaction_template_name = interaction_component.type
	local template = InteractionTemplates[interaction_template_name]

	self._interacting_character_state_component.interaction_template = interaction_template_name

	local start_anim_event, start_anim_event_3p
	local start_anim_event_func = template.start_anim_event_func

	if start_anim_event_func then
		start_anim_event, start_anim_event_3p = start_anim_event_func(interactee_unit, unit)
	else
		start_anim_event = template.start_anim_event
		start_anim_event_3p = template.start_anim_event_3p or start_anim_event
	end

	local anim_duration_variable_name = template.anim_duration_variable_name
	local anim_duration_variable_name_3p = template.anim_duration_variable_name_3p or anim_duration_variable_name
	local template_wield_slot = template.wield_slot
	local wield_slot = template_wield_slot or DEFAULT_ITEM_SLOT_TO_WIELD
	local interactee_extension = ScriptUnit.extension(interactee_unit, "interactee_system")
	local duration = interactee_extension:interaction_length()

	if template_wield_slot then
		local movement_state_component = self._movement_state_component
		local locomotion_component = self._locomotion_component
		local inair_state_component = self._inair_state_component
		local is_crouching = self._movement_state_component.is_crouching

		if is_crouching then
			local first_person_extension = self._first_person_extension
			local animation_extension = self._animation_extension
			local weapon_extension = self._weapon_extension
			local sway_control_component = self._sway_control_component
			local sway_component = self._sway_component
			local spread_control_component = self._spread_control_component

			Crouch.exit(unit, first_person_extension, animation_extension, weapon_extension, movement_state_component, locomotion_component, inair_state_component, sway_control_component, sway_component, spread_control_component, t)
		end

		local item = interactee_extension:interactor_item_to_equip()

		PlayerUnitVisualLoadout.equip_item_to_slot(self._unit, item, "slot_device", nil, t)
	end

	PlayerUnitVisualLoadout.wield_slot(wield_slot, self._unit, t)

	local has_duration = duration > 0

	if has_duration then
		local animation_extension = self._animation_extension
		local animation_duration = math.min(duration, 10)

		if start_anim_event and anim_duration_variable_name then
			animation_extension:anim_event_with_variable_float_1p(start_anim_event, anim_duration_variable_name, animation_duration)
		elseif start_anim_event then
			animation_extension:anim_event_1p(start_anim_event)
		end

		if start_anim_event_3p and anim_duration_variable_name_3p then
			animation_extension:anim_event_with_variable_float(start_anim_event_3p, anim_duration_variable_name_3p, animation_duration)
		elseif start_anim_event then
			animation_extension:anim_event(start_anim_event_3p)
		end
	end

	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.velocity_wanted = Vector3.zero()

	local interactee_position = Unit.local_position(interactee_unit, 1)
	local interactor_position = Unit.local_position(unit, 1)
	local direction = interactee_position - interactor_position

	direction = Vector3.normalize(Vector3.flat(direction))

	local force_rotation = Quaternion.look(direction)
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, force_rotation, t, 0)
	table.clear(EXTERNAL_PROPERTIES)

	EXTERNAL_PROPERTIES.interaction_type = interaction_template_name

	local is_third_person = template.is_third_person

	if is_third_person then
		FirstPersonView.exit(t, self._first_person_mode_component)
	end
end

PlayerCharacterStateInteracting.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateInteracting.super.on_exit(self, unit, t, next_state)

	local interacting_character_state = self._interacting_character_state_component
	local interaction_component = self._interaction_component
	local interactee_unit = interaction_component.target_unit
	local interaction_template_name = interacting_character_state.interaction_template
	local template = InteractionTemplates[interaction_template_name]

	interacting_character_state.interaction_template = "none"

	local stop_anim_event, stop_anim_event_3p
	local stop_anim_event_func = template.stop_anim_event_func

	if stop_anim_event_func then
		stop_anim_event, stop_anim_event_3p = stop_anim_event_func(interactee_unit, unit)
	else
		stop_anim_event = template.stop_anim_event
		stop_anim_event_3p = template.stop_anim_event_3p or stop_anim_event
	end

	local interrupt_anim_event, interrupt_anim_event_3p
	local interrupt_anim_event_func = template.interrupt_anim_event_func

	if interrupt_anim_event_func then
		interrupt_anim_event, interrupt_anim_event_3p = interrupt_anim_event_func(interactee_unit, unit)
	else
		interrupt_anim_event = template.interrupt_anim_event
		interrupt_anim_event_3p = template.interrupt_anim_event_3p or interrupt_anim_event
	end

	local was_interrupted = next_state == "stunned"
	local animation_extension = self._animation_extension
	local anim_event = was_interrupted and interrupt_anim_event or stop_anim_event

	if anim_event then
		animation_extension:anim_event_1p(anim_event)
	end

	local anim_event_3p = was_interrupted and interrupt_anim_event_3p or stop_anim_event_3p

	if anim_event_3p then
		animation_extension:anim_event(anim_event_3p)
	end

	if next_state ~= "dead" then
		local inventory_component = self._inventory_component
		local template_wield_slot = template.wield_slot

		if template_wield_slot and PlayerUnitVisualLoadout.slot_equipped(inventory_component, self._visual_loadout_extension, "slot_device") then
			PlayerUnitVisualLoadout.unequip_item_from_slot(unit, "slot_device", t)
		end

		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	ForceRotation.stop(locomotion_force_rotation_component)

	local is_third_person = template.is_third_person

	if is_third_person then
		local first_person_mode_component = self._first_person_mode_component
		local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

		FirstPersonView.enter(t, first_person_mode_component, rewind_ms)
	end
end

PlayerCharacterStateInteracting.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	self._fx_extension:run_looping_sound(LOOPING_SOUND_ALIAS, nil, nil, fixed_frame)

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateInteracting._check_transition = function (self, unit, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		return "falling"
	end

	if not Interacting.check(self._interaction_component) then
		return "walking"
	end

	return nil
end

return PlayerCharacterStateInteracting
