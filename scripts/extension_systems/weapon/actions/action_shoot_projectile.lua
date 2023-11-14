local AimProjectile = require("scripts/utilities/aim_projectile")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local MasterItems = require("scripts/backend/master_items")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local proc_events = BuffSettings.proc_events
local locomotion_states = ProjectileLocomotionSettings.states
local ActionShootProjectile = class("ActionShootProjectile", "ActionShoot")

ActionShootProjectile.init = function (self, action_context, action_params, action_settings)
	ActionShootProjectile.super.init(self, action_context, action_params, action_settings)

	local weapon = action_params.weapon
	self._weapon = weapon
	self._weapon_unit = weapon.weapon_unit
	self._weapon_template = weapon.weapon_template
	self._inventory_slot_component = weapon.inventory_slot_component
	self._item_definitions = MasterItems.get_cached()
	local unit_data_extension = action_context.unit_data_extension
	self._action_aim_projectile_component = unit_data_extension:read_component("action_aim_projectile")
	self._side_system = Managers.state.extension:system("side_system")
end

ActionShootProjectile._shoot = function (self)
	local item = self:_get_projectile_item()
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration
	local projectile_template = fire_config.projectile
	local locomotion_template = projectile_template.locomotion_template
	local buff_extension = ScriptUnit.extension(self._player_unit, "buff_system")
	local action_component = self._action_component
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.attacking_unit = self._player_unit
		param_table.projectile_template_name = projectile_template.name
		param_table.num_shots_fired = action_component.num_shots_fired
		param_table.combo_count = self._combo_count

		buff_extension:add_proc_event(proc_events.on_shoot_projectile, param_table)
	end

	local owner_unit = self._player_unit
	local material = nil
	local weapon_item = self._weapon.item
	local skip_aiming = fire_config and fire_config.skip_aiming
	local shoot_position = action_component.shooting_position
	local shoot_rotation = action_component.shooting_rotation
	local position, rotation, direction, speed, momentum = AimProjectile.get_spawn_parameters_from_current_aim(action_settings, shoot_position, shoot_rotation, locomotion_template)

	if not skip_aiming then
		local aim_position = position
		local aim_direction = direction
		position, rotation, direction, speed, momentum = AimProjectile.get_spawn_parameters_from_aim_component(self._action_aim_projectile_component)
		position = aim_position
		direction = aim_direction
	end

	local trajectory_parameters = locomotion_template and locomotion_template.trajectory_parameters and locomotion_template.trajectory_parameters.throw
	local starting_state = trajectory_parameters and trajectory_parameters.locomotion_state or locomotion_states.manual_physics
	local is_critical_strike = self._critical_strike_component.is_active
	local origin_item_slot = self._inventory_component.wielded_slot

	if self._is_server then
		local owner_side = self._side_system.side_by_unit[self._player_unit]
		local owner_side_name = owner_side and owner_side:name()
		local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(nil, "item_projectile", position, rotation, material, item, projectile_template, starting_state, direction, speed, momentum, owner_unit, is_critical_strike, origin_item_slot, nil, nil, nil, weapon_item, nil, owner_side_name)
	end
end

ActionShootProjectile._get_projectile_item = function (self)
	local action_settings = self._action_settings
	local fire_config = action_settings.fire_configuration
	local inventory_item_name = fire_config.inventory_item_name
	local item = self._item_definitions[inventory_item_name]

	return item
end

return ActionShootProjectile
