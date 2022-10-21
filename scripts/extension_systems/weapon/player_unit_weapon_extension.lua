local Action = require("scripts/utilities/weapon/action")
local ActionHandler = require("scripts/utilities/action/action_handler")
local AimAssist = require("scripts/utilities/aim_assist")
local AlternateFire = require("scripts/utilities/alternate_fire")
local Ammo = require("scripts/utilities/ammo")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Overheat = require("scripts/utilities/overheat")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local Stamina = require("scripts/utilities/attack/stamina")
local SwayWeaponModule = require("scripts/extension_systems/weapon/sway_weapon_module")
local Weapon = require("scripts/extension_systems/weapon/weapon")
local WeaponActionHandlerData = require("scripts/settings/equipment/weapon_action_handler_data")
local WeaponActionMovement = require("scripts/extension_systems/weapon/weapon_action_movement")
local WeaponMovementState = require("scripts/extension_systems/weapon/utilities/weapon_movement_state")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local WeaponTweakTemplateSettings = require("scripts/settings/equipment/weapon_templates/weapon_tweak_template_settings")
local buff_target_component_lookups = WeaponTweakTemplateSettings.buff_target_component_lookups
local buff_targets = WeaponTweakTemplateSettings.buff_targets
local inventory_component_data = PlayerCharacterConstants.inventory_component_data
local proc_events = BuffSettings.proc_events
local slot_configuration = PlayerCharacterConstants.slot_configuration
local slot_configuration_by_type = PlayerCharacterConstants.slot_configuration_by_type
local template_types = WeaponTweakTemplateSettings.template_types
local PlayerUnitWeaponExtension = class("PlayerUnitWeaponExtension")

PlayerUnitWeaponExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._player = extension_init_data.player
	local world = extension_init_context.world
	self._world = world
	local wwise_world = extension_init_context.wwise_world
	self._wwise_world = wwise_world
	local physics_world = extension_init_context.physics_world
	self._physics_world = physics_world
	local fp_ext = ScriptUnit.extension(unit, "first_person_system")
	self._first_person_extension = fp_ext
	local input_extension = ScriptUnit.extension(unit, "input_system")
	self._input_extension = input_extension
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._buff_extension = buff_extension
	local unit_data = ScriptUnit.extension(unit, "unit_data_system")
	self._inventory_component = unit_data:read_component("inventory")
	self._first_person_component = unit_data:read_component("first_person")
	self._warp_charge_component = unit_data:read_component("warp_charge")
	local warp_charge_write_component = unit_data:write_component("warp_charge")
	self._default_wielded_slot_name = extension_init_data.default_wielded_slot_name
	local block_component = unit_data:write_component("block")
	block_component.is_blocking = false
	block_component.has_blocked = false
	self._block_component = unit_data:read_component("block")
	local alternate_fire_component = unit_data:write_component("alternate_fire")
	alternate_fire_component.is_active = false
	alternate_fire_component.start_t = 0
	self._alternate_fire_write_component = alternate_fire_component
	self._alternate_fire_read_component = unit_data:read_component("alternate_fire")
	self._stamina_read_component = unit_data:read_component("stamina")
	self._character_state_component = unit_data:read_component("character_state")
	self._stunned_character_state_component = unit_data:read_component("stunned_character_state")
	self._movement_state_component = unit_data:read_component("movement_state")
	self._sprint_character_state_component = unit_data:read_component("sprint_character_state")
	self._weapon_action_component = unit_data:read_component("weapon_action")
	self._spread_control_component = unit_data:write_component("spread_control")
	self._recoil_control_component = unit_data:write_component("recoil_control")
	self._sway_control_component = unit_data:write_component("sway_control")
	local shooting_status_component = unit_data:write_component("shooting_status")
	shooting_status_component.shooting = false
	shooting_status_component.shooting_end_time = 0
	shooting_status_component.num_shots = 0
	self._shooting_status_component = shooting_status_component
	local stamina_component = unit_data:write_component("stamina")
	stamina_component.current_fraction = 1
	stamina_component.regeneration_paused = false
	stamina_component.last_drain_time = 0
	self._stamina_component = stamina_component
	local weapon_lock_view_component = unit_data:write_component("weapon_lock_view")
	weapon_lock_view_component.is_active = false
	weapon_lock_view_component.pitch = 0
	weapon_lock_view_component.yaw = 0
	self._weapon_lock_view_component = weapon_lock_view_component
	local critical_strike_seed = extension_init_data.critical_strike_seed
	local critical_strike_component = unit_data:write_component("critical_strike")
	critical_strike_component.seed = critical_strike_seed
	critical_strike_component.prd_state = nil
	critical_strike_component.is_active = false
	critical_strike_component.num_critical_shots = 0
	self._critical_strike_component = critical_strike_component
	local scanning_component = unit_data:write_component("scanning")
	scanning_component.is_active = false
	scanning_component.line_of_sight = false
	scanning_component.scannable_unit = nil
	self._scanning_component = scanning_component

	self:_init_action_components(unit_data)

	self._unit_data_extension = unit_data
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	local is_server = extension_init_data.is_server
	self._is_server = is_server

	if is_server then
		self._server_buff_indexes = {}
	end

	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit
	self._weapons = {}
	self._base_ammo_by_slot = {}
	self._base_clip_by_slot = {}
	self._weapon_special_context = {
		input_extension = input_extension,
		action_input_extension = ScriptUnit.extension(unit, "action_input_system"),
		player_unit = self._unit,
		warp_charge_component = warp_charge_write_component,
		unit_data_extension = self._unit_data_extension,
		weapon_extension = self,
		weapon_tweak_templates_component = self._weapon_tweak_templates_component,
		is_server = is_server,
		world = world,
		physics_world = physics_world
	}
	self._action_handler = ActionHandler:new(unit, WeaponActionHandlerData)

	self._action_handler:add_component("weapon_action")
	self._action_handler:set_tweak_component("weapon_tweak_templates")

	self._weapon_action_movement = WeaponActionMovement:new(self, unit_data, buff_extension)
	self._sway_weapon_module = SwayWeaponModule:new(unit, unit_data)
	self._last_fixed_t = extension_init_context.fixed_frame_t
	self._wwise_ammo_parameter_value = 0
end

PlayerUnitWeaponExtension._init_action_components = function (self, unit_data_extension)
	local action_sweep = unit_data_extension:write_component("action_sweep")
	action_sweep.sweep_position = Vector3.zero()
	action_sweep.sweep_rotation = Quaternion.identity()
	action_sweep.sweep_aborted = false
	action_sweep.sweep_aborted_t = 0
	action_sweep.sweep_aborted_unit = nil
	action_sweep.sweep_aborted_actor_index = nil
	action_sweep.is_sticky = false
	action_sweep.attack_direction = Vector3.zero()
	local action_shoot = unit_data_extension:write_component("action_shoot")
	action_shoot.fire_state = "shot"
	action_shoot.fire_at_time = 0
	action_shoot.num_shots_fired = 0
	action_shoot.started_from_sprint = false
	action_shoot.shooting_charge_level = 0
	action_shoot.shooting_position = Vector3.zero()
	action_shoot.shooting_rotation = Quaternion.identity()
	local action_shoot_pellets = unit_data_extension:write_component("action_shoot_pellets")
	action_shoot_pellets.num_pellets_fired = 0
	local action_flamer_gas = unit_data_extension:write_component("action_flamer_gas")
	action_flamer_gas.range = 0
	local action_reload = unit_data_extension:write_component("action_reload")
	action_reload.has_refilled_ammunition = false
	action_reload.has_removed_ammunition = false
	action_reload.has_cleared_overheat = false
	local action_unwield = unit_data_extension:write_component("action_unwield")
	action_unwield.slot_to_wield = "none"
	local action_heal_target_over_time = unit_data_extension:write_component("action_heal_target_over_time")
	action_heal_target_over_time.target_unit = nil
	local action_place = unit_data_extension:write_component("action_place")
	action_place.position = Vector3.zero()
	action_place.rotation = Quaternion.identity()
	action_place.can_place = false
	action_place.aiming_place = false
	action_place.placed_on_unit = nil
	action_place.rotation_step = 0
	self._action_place_component = action_place
	local action_push = unit_data_extension:write_component("action_push")
	action_push.has_pushed = false
	local action_aim_projectile = unit_data_extension:write_component("action_aim_projectile")
	action_aim_projectile.direction = Vector3.zero()
	action_aim_projectile.momentum = Vector3.zero()
	action_aim_projectile.rotation = Quaternion.identity()
	action_aim_projectile.position = Vector3.zero()
	action_aim_projectile.speed = 0
	self._action_aim_projectile_component = action_aim_projectile
	local action_module_charge = unit_data_extension:write_component("action_module_charge")
	action_module_charge.charge_complete_time = 0
	action_module_charge.charge_level = 0
	action_module_charge.max_charge = 0
	self._action_module_charge_component = action_module_charge
	local action_module_position_finder = unit_data_extension:write_component("action_module_position_finder")
	action_module_position_finder.position = Vector3.zero()
	action_module_position_finder.normal = Vector3.zero()
	action_module_position_finder.position_valid = false
	self._action_module_position_finder_component = action_module_position_finder
	local action_module_targeting = unit_data_extension:write_component("action_module_targeting")
	action_module_targeting.target_unit_1 = nil
	action_module_targeting.target_unit_2 = nil
	action_module_targeting.target_unit_3 = nil
	self._action_module_targeting_component = action_module_targeting
	local action_throw = unit_data_extension:write_component("action_throw")
	action_throw.thrown = false
	action_throw.slot_to_wield = "none"
	local weapon_tweak_templates = unit_data_extension:write_component("weapon_tweak_templates")
	weapon_tweak_templates.sway_template_name = "none"
	weapon_tweak_templates.spread_template_name = "none"
	weapon_tweak_templates.suppression_template_name = "none"
	weapon_tweak_templates.recoil_template_name = "none"
	weapon_tweak_templates.weapon_handling_template_name = "none"
	weapon_tweak_templates.dodge_template_name = "none"
	weapon_tweak_templates.sprint_template_name = "none"
	weapon_tweak_templates.stamina_template_name = "none"
	weapon_tweak_templates.toughness_template_name = "none"
	weapon_tweak_templates.ammo_template_name = "none"
	weapon_tweak_templates.movement_curve_modifier_template_name = "none"
	weapon_tweak_templates.stagger_duration_modifier_template_name = "none"
	weapon_tweak_templates.charge_template_name = "none"
	weapon_tweak_templates.warp_charge_template_name = "none"
	weapon_tweak_templates.burninating_template_name = "none"
	weapon_tweak_templates.size_of_flame_template_name = "none"
	self._weapon_tweak_templates_component = weapon_tweak_templates
	local aim_assist_ramp = unit_data_extension:write_component("aim_assist_ramp")
	aim_assist_ramp.multiplier = 0
	aim_assist_ramp.decay_end_time = 0
	self._aim_assist_ramp_component = aim_assist_ramp
end

PlayerUnitWeaponExtension.extensions_ready = function (self, world, unit)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	self._visual_loadout_extension = visual_loadout_extension
	local fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._fx_extension = fx_extension
	local ability_extension = ScriptUnit.extension(unit, "ability_system")
	self._ability_extension = ability_extension
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	local first_person_unit = first_person_extension:first_person_unit()
	self._first_person_unit = first_person_unit
	local action_context = {
		first_person_unit = first_person_unit,
		world = self._world,
		physics_world = self._physics_world,
		wwise_world = Managers.world:wwise_world(self._world),
		player_unit = self._unit,
		is_server = self._is_server,
		is_local_unit = self._is_local_unit,
		unit_data_extension = self._unit_data_extension,
		first_person_extension = first_person_extension,
		fx_extension = fx_extension,
		animation_extension = ScriptUnit.extension(unit, "animation_system"),
		weapon_extension = ScriptUnit.extension(unit, "weapon_system"),
		weapon_spread_extension = ScriptUnit.extension(unit, "weapon_spread_system"),
		weapon_recoil_extension = ScriptUnit.extension(unit, "weapon_recoil_system"),
		camera_extension = ScriptUnit.extension(unit, "camera_system"),
		ability_extension = ability_extension,
		visual_loadout_extension = visual_loadout_extension,
		smart_targeting_extension = ScriptUnit.extension(unit, "smart_targeting_system"),
		input_extension = self._input_extension,
		dialogue_input = ScriptUnit.extension_input(unit, "dialogue_system")
	}
	local unit_data_ext = self._unit_data_extension
	action_context.weapon_action_component = self._weapon_action_component
	action_context.first_person_component = unit_data_ext:read_component("first_person")
	action_context.sprint_character_state_component = unit_data_ext:read_component("sprint_character_state")
	action_context.locomotion_component = unit_data_ext:read_component("locomotion")
	action_context.inventory_component = self._inventory_component
	action_context.movement_state_component = unit_data_ext:read_component("movement_state")
	action_context.weapon_lock_view_component = self._weapon_lock_view_component
	action_context.critical_strike_component = self._critical_strike_component

	self._action_handler:set_action_context(action_context)
	self._sway_weapon_module:extensions_ready(world, unit)

	local specialization = unit_data_ext:specialization()
	self._specialization_stamina_template = specialization.stamina
end

PlayerUnitWeaponExtension.on_player_unit_respawn = function (self, respawn_ammo_percentage)
	local unit_data_extension = self._unit_data_extension

	for slot_name, config in pairs(slot_configuration_by_type.weapon) do
		local wieldable_component = unit_data_extension:write_component(slot_name)
		local ammo_reserve = wieldable_component.current_ammunition_reserve
		local respawn_ammo_reserve = math.ceil(ammo_reserve * respawn_ammo_percentage)
		wieldable_component.current_ammunition_reserve = respawn_ammo_reserve
	end
end

PlayerUnitWeaponExtension._wielded_weapon = function (self, inventory_component, weapons)
	local wielded_slot = inventory_component.wielded_slot

	return weapons[wielded_slot]
end

PlayerUnitWeaponExtension.update = function (self, unit, dt, t)
	self._action_handler:update(dt, t)
end

local NO_LERP_VALUES = {}

PlayerUnitWeaponExtension.damage_profile_lerp_values = function (self, damage_profile_name_or_nil)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)

	if not weapon then
		return NO_LERP_VALUES
	end

	local running_action_name = self._action_handler:running_action_name("weapon_action")

	if not running_action_name then
		return NO_LERP_VALUES
	end

	local damage_profile_lerp_values = weapon.damage_profile_lerp_values
	local lerp_values = damage_profile_lerp_values[running_action_name]

	return lerp_values or NO_LERP_VALUES
end

PlayerUnitWeaponExtension.explosion_template_lerp_values = function (self)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)

	if not weapon then
		return NO_LERP_VALUES
	end

	local running_action_name = self._action_handler:running_action_name("weapon_action")

	if not running_action_name then
		return NO_LERP_VALUES
	end

	local explosion_template_lerp_values = weapon.explosion_template_lerp_values
	local lerp_values = explosion_template_lerp_values[running_action_name]

	return lerp_values or NO_LERP_VALUES
end

PlayerUnitWeaponExtension.fixed_update = function (self, unit, dt, t, fixed_frame)
	local inventory = self._inventory_component
	local wielded_slot = inventory.wielded_slot
	local wielded_weapon = self:_wielded_weapon(inventory, self._weapons)
	local weapon_template = wielded_weapon and wielded_weapon.weapon_template
	local alternate_fire_component = self._alternate_fire_write_component

	if AlternateFire.check_exit(alternate_fire_component, weapon_template, self._input_extension, self._stunned_character_state_component, t) then
		AlternateFire.stop(alternate_fire_component, self._weapon_tweak_templates_component, self._animation_extension, weapon_template, false, self._unit)
	end

	if wielded_slot ~= "none" then
		local slot_type = slot_configuration[wielded_slot].slot_type

		if slot_type == "weapon" then
			self:_update_overheat(dt, t)
			self:_update_powered_weapon_intensity(dt, t)
		end
	end

	self:_update_stamina(dt, t, fixed_frame)
	self:_update_ammo()
	self._sway_weapon_module:fixed_update(dt, t)
	self._action_handler:fixed_update(dt, t)

	self._last_fixed_t = t
	local shooting_status_component = self._shooting_status_component
	local movement_state_component = self._movement_state_component
	local weapon_movement_state = WeaponMovementState.translate_movement_state_component(movement_state_component)
	local spread_template = self:spread_template()
	local num_shots_clear_time = 0

	if spread_template then
		local spread_settings = spread_template[weapon_movement_state]
		num_shots_clear_time = spread_settings.immediate_spread.num_shots_clear_time or 0
	end

	if shooting_status_component.num_shots > 0 and not shooting_status_component.shooting and t > shooting_status_component.shooting_end_time + num_shots_clear_time then
		shooting_status_component.num_shots = 0
	end

	AimAssist.update_ramp_multiplier(dt, t, self._aim_assist_ramp_component)
end

PlayerUnitWeaponExtension.on_wieldable_slot_equipped = function (self, item, slot_name, weapon_unit, fx_sources, t, optional_existing_unit_3p, from_server_correction_occurred)
	local unit_data_ext = ScriptUnit.extension(self._unit, "unit_data_system")
	local inventory_slot_component = unit_data_ext:write_component(slot_name)
	local weapon_template = WeaponTemplate.weapon_template_from_item(item)
	local weapon_trait_overrides = nil
	local weapon_init_data = {
		fx_sources = fx_sources,
		weapon_template = weapon_template,
		inventory_slot_component = inventory_slot_component,
		item = item,
		weapon_special_context = self._weapon_special_context,
		optional_weapon_unit = weapon_unit,
		weapon_trait_overrides = weapon_trait_overrides,
		player_unit = self._unit
	}
	local weapon = Weapon:new(weapon_init_data)
	local weapons = self._weapons
	weapons[slot_name] = weapon
	local config = slot_configuration[slot_name]
	local component_data = inventory_component_data[config.slot_type]
	local base_ammo = {}
	local base_clip = {}

	for key, data in pairs(component_data) do
		if key == "current_ammunition_clip" or key == "max_ammunition_clip" then
			local clip_size = 0
			local template_name = weapon_template.ammo_template or "none"

			if template_name ~= "none" then
				local weapon_tweak_templates = weapon.weapon_tweak_templates
				local templates = weapon_tweak_templates[template_types.ammo]
				local ammo_template = templates[template_name]
				clip_size = math.floor(ammo_template.ammunition_clip or 0)
			end

			base_clip[key] = clip_size
			inventory_slot_component[key] = clip_size
		elseif key == "current_ammunition_reserve" or key == "max_ammunition_reserve" then
			local reserve_size = 0
			local template_name = weapon_template.ammo_template or "none"

			if template_name ~= "none" then
				local weapon_tweak_templates = weapon.weapon_tweak_templates
				local templates = weapon_tweak_templates[template_types.ammo]
				local ammo_template = templates[template_name]
				reserve_size = math.floor(ammo_template.ammunition_reserve or 0)
			end

			base_ammo[key] = reserve_size
			inventory_slot_component[key] = reserve_size
		elseif key == "reload_state" then
			local reload_template = weapon_template.reload_template

			if reload_template then
				ReloadStates.reset(reload_template, inventory_slot_component)
			else
				inventory_slot_component[key] = "none"
			end
		elseif key == "existing_unit_3p" then
			inventory_slot_component[key] = optional_existing_unit_3p
		else
			inventory_slot_component[key] = data.default_value
		end
	end

	self._base_ammo_by_slot[slot_name] = base_ammo
	self._base_clip_by_slot[slot_name] = base_clip
	local buffs = weapon.buffs

	if not from_server_correction_occurred then
		self:_apply_buffs(buffs, buff_targets.on_equip, slot_name, inventory_slot_component, t, item)
		self:_apply_buffs(buffs, buff_targets.on_unwield, slot_name, inventory_slot_component, t, item)
		self:_apply_stat_buffs(inventory_slot_component, config.slot_type)
	end
end

PlayerUnitWeaponExtension.on_wieldable_slot_unequipped = function (self, slot_name, from_server_correction_occurred)
	local weapon = self._weapons[slot_name]
	local inventory_slot_component = weapon.inventory_slot_component

	if not from_server_correction_occurred then
		local buffs = weapon.buffs

		self:_remove_buffs(buffs, buff_targets.on_equip, inventory_slot_component)
		self:_remove_buffs(buffs, buff_targets.on_unwield, inventory_slot_component)
	end

	local config = slot_configuration[slot_name]
	local component_data = inventory_component_data[config.slot_type]

	for key, data in pairs(component_data) do
		inventory_slot_component[key] = data.default_value
	end

	weapon:delete()

	self._weapons[slot_name] = nil
end

PlayerUnitWeaponExtension.on_slot_wielded = function (self, slot_name, t)
	local weapon = self._weapons[slot_name]
	local weapon_item = weapon.item
	local inventory_slot_component = weapon.inventory_slot_component
	local buffs = weapon.buffs

	self:_remove_buffs(buffs, buff_targets.on_unwield, inventory_slot_component)
	self:_apply_buffs(buffs, buff_targets.on_wield, slot_name, inventory_slot_component, t, weapon_item)

	local weapon_template = weapon.weapon_template
	local action_handler = self._action_handler
	local action_name = "action_wield"
	local action_settings = Action.action_settings(weapon_template, action_name)
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	weapon_tweak_templates_component.dodge_template_name = weapon_template.dodge_template or "none"
	weapon_tweak_templates_component.sprint_template_name = weapon_template.sprint_template or "none"
	weapon_tweak_templates_component.stamina_template_name = weapon_template.stamina_template or "none"
	weapon_tweak_templates_component.toughness_template_name = weapon_template.toughness_template or "none"
	weapon_tweak_templates_component.ammo_template_name = weapon_template.ammo_template or "none"
	weapon_tweak_templates_component.recoil_template_name = weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = weapon_template.sway_template or "none"
	weapon_tweak_templates_component.suppression_template_name = weapon_template.suppression_template or "none"
	weapon_tweak_templates_component.spread_template_name = weapon_template.spread_template or "none"
	weapon_tweak_templates_component.movement_curve_modifier_template_name = weapon_template.movement_curve_modifier_template or "none"
	weapon_tweak_templates_component.stagger_duration_modifier_template_name = weapon_template.stagger_duration_modifier_template or "none"
	weapon_tweak_templates_component.charge_template_name = weapon_template.charge_template or "none"
	weapon_tweak_templates_component.warp_charge_template_name = weapon_template.warp_charge_template or "none"
	weapon_tweak_templates_component.burninating_template_name = weapon_template.burninating_template or "none"
	weapon_tweak_templates_component.size_of_flame_template_name = weapon_template.size_of_flame_template or "none"

	action_handler:set_active_template("weapon_action", weapon_template.name)
	self:_start_action(action_name, action_settings, t, false, "on_slot_wielded")
end

PlayerUnitWeaponExtension.on_slot_unwielded = function (self, slot_name, t)
	local weapon = self._weapons[slot_name]
	local weapon_item = weapon.item
	local weapon_template = weapon.weapon_template

	self:stop_action("unwield", nil, t)

	local alternate_fire = self._alternate_fire_write_component

	if alternate_fire.is_active then
		AlternateFire.stop(alternate_fire, self._weapon_tweak_templates_component, self._animation_extension, weapon_template, false, self._unit)
	end

	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	weapon_tweak_templates_component.dodge_template_name = "none"
	weapon_tweak_templates_component.sprint_template_name = "none"
	weapon_tweak_templates_component.stamina_template_name = "none"
	weapon_tweak_templates_component.toughness_template_name = "none"
	weapon_tweak_templates_component.ammo_template_name = "none"
	weapon_tweak_templates_component.recoil_template_name = "none"
	weapon_tweak_templates_component.sway_template_name = "none"
	weapon_tweak_templates_component.suppression_template_name = "none"
	weapon_tweak_templates_component.spread_template_name = "none"
	weapon_tweak_templates_component.movement_curve_modifier_template_name = "none"
	weapon_tweak_templates_component.stagger_duration_modifier_template_name = "none"
	weapon_tweak_templates_component.charge_template_name = "none"
	weapon_tweak_templates_component.warp_charge_template_name = "none"
	weapon_tweak_templates_component.burninating_template_name = "none"
	weapon_tweak_templates_component.size_of_flame_template_name = "none"

	self._action_handler:set_active_template("weapon_action", "none")

	local inventory_slot_component = weapon.inventory_slot_component
	local buffs = weapon.buffs

	self:_remove_buffs(buffs, buff_targets.on_wield, inventory_slot_component)
	self:_apply_buffs(buffs, buff_targets.on_unwield, slot_name, inventory_slot_component, t, weapon_item)
end

PlayerUnitWeaponExtension.can_wield = function (self, slot_name)
	local weapons = self._weapons
	local weapon = weapons[slot_name]

	if not weapon then
		return false
	end

	local weapon_template = weapon.weapon_template

	if not weapon_template then
		return false
	end

	local not_player_wieldable = weapon_template.not_player_wieldable

	if not_player_wieldable then
		return false
	end

	return true
end

local action_params = {}

PlayerUnitWeaponExtension._start_action = function (self, action_name, action_settings, t, used_input, transition_type)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local action_objects = weapon.actions

	table.clear(action_params)

	action_params.weapon = weapon
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot
	local condition_func_params = self:_condition_func_params(wielded_slot)

	self._action_handler:start_action("weapon_action", action_objects, action_name, action_params, action_settings, used_input, t, transition_type, condition_func_params)
end

PlayerUnitWeaponExtension.server_correction_occurred = function (self, unit)
	table.clear(action_params)

	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local action_objects, actions = nil

	if weapon then
		action_params.weapon = weapon
		action_objects = weapon.actions
		actions = weapon.weapon_template.actions
	end

	self._action_handler:server_correction_occurred("weapon_action", action_objects, action_params, actions)
end

PlayerUnitWeaponExtension.start_action = function (self, action_name, t)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local weapon_template = weapon.weapon_template
	local action_settings = Action.action_settings(weapon_template, action_name)
	local used_input = nil
	local transition_type = "forced"

	self:_start_action(action_name, action_settings, t, used_input, transition_type)
end

PlayerUnitWeaponExtension.stop_action = function (self, reason, data, t, allow_reason_chain_action)
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if not allow_reason_chain_action or wielded_slot == "none" then
		self._action_handler:stop_action("weapon_action", reason, data, t)
	else
		local condition_func_params = self:_condition_func_params(wielded_slot)
		local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
		local actions = weapon.weapon_template.actions
		local action_objects = weapon.actions

		table.clear(action_params)

		action_params.weapon = weapon

		self._action_handler:stop_action("weapon_action", reason, data, t, actions, action_objects, action_params, condition_func_params)
	end
end

PlayerUnitWeaponExtension.blocked_attack = function (self, attacking_unit, hit_world_position, block_broken, weapon_template)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local wanted_weapon_template_name = weapon_template.name
	local current_weapon_template_name = weapon.weapon_template.name
	local correct_weapon_wielded = current_weapon_template_name == wanted_weapon_template_name

	if self._block_component.is_blocking and correct_weapon_wielded then
		if not block_broken then
			self._animation_extension:anim_event_1p("parry_hit_reaction")
			self._animation_extension:anim_event("parry_hit_reaction")
		else
			self._animation_extension:anim_event_1p("parry_break")
			self._animation_extension:anim_event("parry_break")
		end
	end

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.block_broken = block_broken
		param_table.attacking_unit = attacking_unit

		buff_extension:add_proc_event(proc_events.on_block, param_table)
	end

	local first_person = self._first_person_component
	local fp_position = first_person.position
	local hit_direction = Vector3.normalize(Vector3.flat(hit_world_position - fp_position))
	local sound_position = fp_position + hit_direction * 0.5
	local fx_sources = weapon.fx_sources
	local block_source = fx_sources._block
	local fx_extension = self._fx_extension
	local external_properties = nil
	local sync_to_clients = true
	local include_client = false

	fx_extension:trigger_gear_wwise_event_with_position("melee_blocked_attack", external_properties, sound_position, sync_to_clients, include_client)

	if block_source then
		fx_extension:spawn_gear_particle_effect_with_source("melee_blocked_attack", external_properties, block_source, true, "stop")
	end
end

local temp_table = {}

PlayerUnitWeaponExtension._condition_func_params = function (self, wielded_slot)
	table.clear(temp_table)

	local inventory_slot_component = self._weapons[wielded_slot].inventory_slot_component
	temp_table.ability_extension = self._ability_extension
	temp_table.visual_loadout_extension = self._visual_loadout_extension
	temp_table.weapon_extention = self
	temp_table.action_place_component = self._action_place_component
	temp_table.alternate_fire_component = self._alternate_fire_read_component
	temp_table.block_component = self._block_component
	temp_table.inventory_read_component = self._inventory_component
	temp_table.inventory_slot_component = inventory_slot_component
	temp_table.stamina_read_component = self._stamina_read_component
	temp_table.warp_charge_component = self._warp_charge_component
	temp_table.sprint_character_state_component = self._sprint_character_state_component
	temp_table.movement_state_component = self._movement_state_component
	temp_table.weapon_action_component = self._weapon_action_component
	temp_table.action_module_charge_component = self._action_module_charge_component
	temp_table.action_module_position_finder_component = self._action_module_position_finder_component
	temp_table.action_module_targeting_component = self._action_module_targeting_component

	return temp_table
end

PlayerUnitWeaponExtension.update_weapon_actions = function (self, fixed_frame)
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot == "none" then
		return
	end

	local condition_func_params = self:_condition_func_params(wielded_slot)
	local weapon = self:_wielded_weapon(inventory_component, self._weapons)
	local actions = weapon.weapon_template.actions
	local action_objects = weapon.actions

	table.clear(action_params)

	action_params.weapon = weapon
	action_params.player_unit = self._unit
	local fixed_time_step = GameParameters.fixed_time_step
	local dt = fixed_time_step
	local t = fixed_frame * fixed_time_step

	self:_update_weapon_special(weapon, dt, t)
	self._action_handler:update_actions(fixed_frame, "weapon_action", condition_func_params, actions, action_objects, action_params)
end

PlayerUnitWeaponExtension._update_weapon_special = function (self, weapon, dt, t)
	local special_implementation = weapon.special_implementation

	if not special_implementation then
		return
	end

	special_implementation:update(dt, t)
end

PlayerUnitWeaponExtension._apply_buffs = function (self, buffs, buff_target, slot_name, inventory_slot_component, t, weapon_item)
	local player_unit = self._unit
	local buff_list = buffs[buff_target]
	local num_buffs = #buff_list

	if num_buffs == 0 then
		return
	end

	local lookup = buff_target_component_lookups[buff_target]
	local buff_extension = self._buff_extension

	for i = 1, num_buffs do
		local buff_template_name = buff_list[i]

		if buff_template_name ~= "description_values" then
			local client_tried_adding_rpc_buff, local_index, component_index = buff_extension:add_externally_controlled_buff(buff_template_name, t, "item_slot_name", slot_name, "owner_unit", player_unit, "source_item", weapon_item)
			local component_name = lookup[i]

			if not client_tried_adding_rpc_buff then
				if component_index then
					inventory_slot_component[component_name] = component_index
				else
					local server_buff_indexes = self._server_buff_indexes[buff_target]

					if not server_buff_indexes then
						server_buff_indexes = {}
						self._server_buff_indexes[buff_target] = server_buff_indexes
					end

					server_buff_indexes[#server_buff_indexes + 1] = local_index
				end
			end
		end
	end
end

PlayerUnitWeaponExtension._remove_buffs = function (self, buffs, buff_target, inventory_slot_component)
	local buff_list = buffs[buff_target]
	local num_buffs = #buff_list

	if num_buffs == 0 then
		return
	end

	local lookup = buff_target_component_lookups[buff_target]
	local num_buff_slots = #lookup
	local buff_extension = self._buff_extension

	for i = 1, num_buff_slots do
		local component_name = lookup[i]
		local component_index = inventory_slot_component[component_name]

		if component_index ~= -1 then
			buff_extension:remove_externally_controlled_buff(nil, component_index)
		end
	end

	local server_buff_indexes = self._server_buff_indexes and self._server_buff_indexes[buff_target]

	if server_buff_indexes then
		for i = 1, #server_buff_indexes do
			local local_index = server_buff_indexes[i]

			buff_extension:remove_externally_controlled_buff(local_index, nil)
		end

		self._server_buff_indexes[buff_target] = nil
	end
end

PlayerUnitWeaponExtension._apply_stat_buffs = function (self, inventory_slot_component, slot_type)
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension:stat_buffs()

	if slot_type == "weapon" then
		local capacity_modifier = stat_buffs.ammo_reserve_capacity
		local clip_size_modifier = stat_buffs.clip_size_modifier
		local ammo_hard_limit = NetworkConstants.ammunition.max
		inventory_slot_component.current_ammunition_reserve = math.clamp(math.floor(inventory_slot_component.current_ammunition_reserve * capacity_modifier), 0, ammo_hard_limit)
		inventory_slot_component.max_ammunition_reserve = math.clamp(math.floor(inventory_slot_component.max_ammunition_reserve * capacity_modifier), 0, ammo_hard_limit)
		inventory_slot_component.max_ammunition_clip = math.clamp(math.floor(inventory_slot_component.max_ammunition_clip * clip_size_modifier), 0, ammo_hard_limit)
		inventory_slot_component.current_ammunition_clip = math.clamp(math.floor(inventory_slot_component.current_ammunition_clip * clip_size_modifier), 0, ammo_hard_limit)
	end
end

PlayerUnitWeaponExtension._update_overheat = function (self, dt, t)
	for _, slot in pairs(self._weapons) do
		Overheat.update(dt, t, slot.inventory_slot_component, slot.weapon_template.overheat_configuration, self._unit, self._first_person_unit)
	end
end

PlayerUnitWeaponExtension._update_stamina = function (self, dt, t, fixed_frame)
	Stamina.update(t, dt, self._stamina_component, self._specialization_stamina_template, self._unit, fixed_frame)
end

PlayerUnitWeaponExtension._update_ammo = function (self)
	local weapons = self._weapons

	for slot_name, slot in pairs(weapons) do
		local base_ammo = self._base_ammo_by_slot[slot_name]

		if base_ammo then
			local base_current_ammo = base_ammo.current_ammunition_reserve
			local base_max_ammo = base_ammo.max_ammunition_reserve

			if base_current_ammo and base_max_ammo then
				local inventory_slot_component = slot.inventory_slot_component
				local max_ammo_reserve = inventory_slot_component.max_ammunition_reserve
				local stat_buffs = self._buff_extension:stat_buffs()
				local capacity_modifier = stat_buffs.ammo_reserve_capacity
				local new_max_ammo = math.floor(base_max_ammo * capacity_modifier)
				local ammo_hard_limit = NetworkConstants.ammunition.max
				local clamped_new_max_ammo = math.clamp(new_max_ammo, 0, ammo_hard_limit)

				if max_ammo_reserve ~= clamped_new_max_ammo then
					local current_ammo_reserve = inventory_slot_component.current_ammunition_reserve
					local current_ammo_percent = current_ammo_reserve / max_ammo_reserve
					local new_current_ammo = math.floor(base_current_ammo * capacity_modifier * current_ammo_percent)
					inventory_slot_component.current_ammunition_reserve = new_current_ammo
					inventory_slot_component.max_ammunition_reserve = clamped_new_max_ammo
				end
			end
		end

		local base_clip = self._base_clip_by_slot[slot_name]

		if base_clip then
			local base_current_clip = base_clip.current_ammunition_clip
			local base_max_clip = base_clip.max_ammunition_clip

			if base_current_clip and base_max_clip then
				local inventory_slot_component = slot.inventory_slot_component
				local clip_size = inventory_slot_component.max_ammunition_clip
				local stat_buffs = self._buff_extension:stat_buffs()
				local clip_size_capacity_modifier = stat_buffs.clip_size_modifier
				local new_clip_size = math.floor(base_max_clip * clip_size_capacity_modifier)
				local ammo_hard_limit = NetworkConstants.ammunition.max
				local clamped_new_clip_size = math.clamp(new_clip_size, 0, ammo_hard_limit)

				if clip_size ~= clamped_new_clip_size then
					local current_clip = inventory_slot_component.current_ammunition_clip
					local current_clip_percent = current_clip / clip_size
					local new_current_clip = math.floor(current_clip_percent * clamped_new_clip_size)
					inventory_slot_component.current_ammunition_clip = new_current_clip
					inventory_slot_component.max_ammunition_clip = clamped_new_clip_size
				end
			end
		end
	end

	local wielded_slot = self._inventory_component.wielded_slot

	if wielded_slot == "slot_secondary" then
		local wielded_weapon = weapons[wielded_slot]
		local inventory_slot_component = wielded_weapon.inventory_slot_component
		self._wwise_ammo_parameter_value = Ammo.set_weapon_ammo_count_wwise_parameter(self._wwise_ammo_parameter_value, self._wwise_world, inventory_slot_component)
	end
end

local INTENSITY_DECAY_SPEED = 1

PlayerUnitWeaponExtension._update_powered_weapon_intensity = function (self, dt, t)
	local wielded_weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local inventory_slot_component = wielded_weapon.inventory_slot_component

	if not wielded_weapon then
		return
	end

	local weapon_action_component = self._weapon_action_component
	local action_settings = self._action_handler:running_action_settings("weapon_action")
	local powered_weapon_intensity = action_settings and action_settings.powered_weapon_intensity
	local total_intensity = nil

	if powered_weapon_intensity then
		local start_t = weapon_action_component.start_t
		local action_t = t - start_t
		local start_mod = powered_weapon_intensity.start_intensity
		local p1 = start_mod
		local p2 = 1
		local segment_progress = 0

		for i = 1, #powered_weapon_intensity do
			local segment = powered_weapon_intensity[i]
			local segment_t = segment.t

			if action_t <= segment_t then
				p2 = segment.intensity
				segment_progress = segment_t == 0 and 1 or action_t / segment_t

				break
			else
				local intensity = segment.intensity
				p1 = intensity
				p2 = intensity
			end
		end

		total_intensity = math.lerp(p1, p2, segment_progress)
	else
		local current_intensity = inventory_slot_component.powered_weapon_intensity
		total_intensity = math.max(current_intensity - INTENSITY_DECAY_SPEED * dt, 0)
	end

	inventory_slot_component.powered_weapon_intensity = total_intensity
end

PlayerUnitWeaponExtension.move_speed_modifier = function (self, t)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)
	local weapon_template = weapon and weapon.weapon_template
	local alternate_fire_is_active = self._alternate_fire_read_component.is_active
	local alternate_fire_speed_mod = 1

	if alternate_fire_is_active then
		alternate_fire_speed_mod = AlternateFire.movement_speed_modifier(self._alternate_fire_read_component, weapon_template, t, self)
	end

	local weapon_action_speed_mod = self._weapon_action_movement:move_speed_modifier(t)
	local modifier = alternate_fire_speed_mod * weapon_action_speed_mod
	local static_speed_reduction_mod = weapon_template and weapon_template.static_speed_reduction_mod

	if static_speed_reduction_mod then
		local mod_dif = 1 - static_speed_reduction_mod
		local buff_extension = self._buff_extension
		local stat_buffs = buff_extension:stat_buffs()
		local multiplier = stat_buffs.static_movement_reduction_multiplier
		mod_dif = mod_dif * multiplier
		local new_static_modifier = 1 - mod_dif
		modifier = modifier * new_static_modifier
	end

	return modifier
end

PlayerUnitWeaponExtension.has_running_action = function (self)
	return self._action_handler:has_running_action("weapon_action")
end

PlayerUnitWeaponExtension.running_action_settings = function (self)
	return self._action_handler:running_action_settings("weapon_action")
end

PlayerUnitWeaponExtension.weapon_template = function (self)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)

	if not weapon then
		return
	end

	local template = weapon.weapon_template

	return template
end

PlayerUnitWeaponExtension._weapon_tweak_template = function (self, template_type, template_name)
	local weapon = self:_wielded_weapon(self._inventory_component, self._weapons)

	if not weapon then
		return
	end

	local weapon_tweak_templates = weapon.weapon_tweak_templates
	local templates = weapon_tweak_templates[template_type]
	local template = templates[template_name]

	return template
end

PlayerUnitWeaponExtension.recoil_template = function (self)
	local template_name = self._weapon_tweak_templates_component.recoil_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.recoil, template_name)
end

PlayerUnitWeaponExtension.sway_template = function (self)
	local template_name = self._weapon_tweak_templates_component.sway_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.sway, template_name)
end

PlayerUnitWeaponExtension.spread_template = function (self)
	local template_name = self._weapon_tweak_templates_component.spread_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.spread, template_name)
end

PlayerUnitWeaponExtension.suppression_template = function (self)
	local template_name = self._weapon_tweak_templates_component.suppression_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.suppression, template_name)
end

PlayerUnitWeaponExtension.weapon_handling_template = function (self)
	local template_name = self._weapon_tweak_templates_component.weapon_handling_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.weapon_handling, template_name)
end

PlayerUnitWeaponExtension.dodge_template = function (self)
	local template_name = self._weapon_tweak_templates_component.dodge_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.dodge, template_name)
end

PlayerUnitWeaponExtension.movement_curve_modifier_template = function (self)
	local template_name = self._weapon_tweak_templates_component.movement_curve_modifier_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.movement_curve_modifier, template_name)
end

PlayerUnitWeaponExtension.stagger_duration_modifier_template = function (self)
	local template_name = self._weapon_tweak_templates_component.stagger_duration_modifier_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.stagger_duration_modifier, template_name)
end

PlayerUnitWeaponExtension.charge_template = function (self)
	local template_name = self._weapon_tweak_templates_component.charge_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.charge, template_name)
end

PlayerUnitWeaponExtension.warp_charge_template = function (self)
	local template_name = self._weapon_tweak_templates_component.warp_charge_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.warp_charge, template_name)
end

PlayerUnitWeaponExtension.sprint_template = function (self)
	local template_name = self._weapon_tweak_templates_component.sprint_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.sprint, template_name)
end

PlayerUnitWeaponExtension.stamina_template = function (self)
	local template_name = self._weapon_tweak_templates_component.stamina_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.stamina, template_name)
end

PlayerUnitWeaponExtension.toughness_template = function (self)
	local template_name = self._weapon_tweak_templates_component.toughness_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.toughness, template_name)
end

PlayerUnitWeaponExtension.ammo_template = function (self)
	local template_name = self._weapon_tweak_templates_component.ammo_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.ammo, template_name)
end

PlayerUnitWeaponExtension.burninating_template = function (self)
	local template_name = self._weapon_tweak_templates_component.burninating_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.burninating, template_name)
end

PlayerUnitWeaponExtension.size_of_flame_template = function (self)
	local template_name = self._weapon_tweak_templates_component.size_of_flame_template_name

	if template_name == "none" then
		return
	end

	return self:_weapon_tweak_template(template_types.size_of_flame, template_name)
end

PlayerUnitWeaponExtension.sensitivity_modifier = function (self)
	return self._action_handler:sensitivity_modifier("weapon_action", self._last_fixed_t)
end

PlayerUnitWeaponExtension.rotation_contraints = function (self)
	return self._action_handler:rotation_contraints("weapon_action", self._last_fixed_t)
end

PlayerUnitWeaponExtension.block_actions = function (self)
	self._action_handler:block_actions()
end

PlayerUnitWeaponExtension.unblock_actions = function (self)
	self._action_handler:unblock_actions()
end

PlayerUnitWeaponExtension.action_input_is_currently_valid = function (self, component_name, action_input, used_input, current_fixed_t)
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot == "none" then
		return false
	end

	local weapon = self:_wielded_weapon(inventory_component, self._weapons)
	local actions = weapon.weapon_template.actions
	local condition_func_params = self:_condition_func_params(wielded_slot)

	return self._action_handler:action_input_is_currently_valid(component_name, actions, condition_func_params, current_fixed_t, action_input, used_input)
end

return PlayerUnitWeaponExtension
