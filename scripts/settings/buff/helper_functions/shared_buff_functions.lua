-- chunkname: @scripts/settings/buff/helper_functions/shared_buff_functions.lua

local MasterItems = require("scripts/backend/master_items")
local ProjectileLocomotionSettings = require("scripts/settings/projectile_locomotion/projectile_locomotion_settings")
local WarpCharge = require("scripts/utilities/warp_charge")
local locomotion_states = ProjectileLocomotionSettings.states
local PI = math.pi
local shared_buff_functions = {}

shared_buff_functions.regain_toughness_proc_func = function (params, template_data, template_context)
	local toughness_extension = template_data.toughness_extension

	if not toughness_extension then
		local unit = template_context.unit

		toughness_extension = ScriptUnit.extension(unit, "toughness_system")
		template_data.toughness_extension = toughness_extension
	end

	local buff_template = template_context.template
	local override_data = template_context.template_override_data
	local multiplier = template_data.toughness_regain_multiplier or 1
	local fixed_percentage = (override_data.toughness_fixed_percentage or buff_template.toughness_fixed_percentage) * multiplier
	local ignore_stat_buffs = true

	toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
end

shared_buff_functions.vent_warp_charge_start_func = function (template_data, template_context)
	local unit = template_context.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local warp_charge_component = unit_data_extension:write_component("warp_charge")

	template_data.warp_charge_component = warp_charge_component
	template_data.counter = 0
end

shared_buff_functions.vent_warp_charge_proc_func = function (params, template_data, template_context)
	template_data.proc = true
end

shared_buff_functions.vent_warp_charge_update_func = function (template_data, template_context, dt, t)
	if template_data.proc then
		local warp_charge_component = template_data.warp_charge_component
		local buff_template = template_context.template
		local override_data = template_context.template_override_data
		local remove_percentage = override_data.vent_percentage or buff_template.vent_percentage

		WarpCharge.decrease_immediate(remove_percentage, warp_charge_component, template_context.unit)

		template_data.proc = nil
	end
end

shared_buff_functions.spawn_grenade_at_position = function (owner_unit, owner_side, item_name, projectile_template, position, direction, speed_multiplier)
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local is_critical_strike = false
	local starting_state = locomotion_states.manual_physics
	local unit_position = position + Vector3.up() * 0.1
	local unit_rotation = Quaternion(Vector3.up(), 0)
	local speed = 6 * speed_multiplier
	local max_angular_velocity = math.pi / 10
	local angular_velocity = Vector3(math.random() * max_angular_velocity, math.random() * max_angular_velocity, math.random() * max_angular_velocity)
	local max_offset = 0.1
	local target_direction = direction
	local pitch = (math.random() * (max_offset * 2) - max_offset) * PI
	local pitch_rotation = Quaternion(Vector3.right(), pitch)
	local roll = (math.random() * (max_offset * 2) - max_offset) * PI
	local roll_rotation = Quaternion(Vector3.forward(), roll)
	local randomized_direction = Quaternion.rotate(pitch_rotation, target_direction)

	randomized_direction = Vector3.normalize(Quaternion.rotate(roll_rotation, randomized_direction))

	local unit_template_name = projectile_template.unit_template_name or "item_projectile"

	Managers.state.unit_spawner:spawn_network_unit(nil, unit_template_name, unit_position, unit_rotation, nil, item, projectile_template, starting_state, randomized_direction, speed, angular_velocity, owner_unit, is_critical_strike, nil, nil, nil, nil, nil, nil, owner_side)
end

shared_buff_functions.get_broadphase_and_enemy_side_names = function (source_unit)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[source_unit]
	local enemy_side_names = side:relation_side_names("enemy")

	return broadphase, enemy_side_names
end

shared_buff_functions.get_broadphase_and_allied_side_names = function (source_unit)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[source_unit]
	local enemy_side_names = side:relation_side_names("allied")

	return broadphase, enemy_side_names
end

return shared_buff_functions
