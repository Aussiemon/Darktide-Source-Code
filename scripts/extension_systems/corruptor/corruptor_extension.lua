local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local CorruptorSettings = require("scripts/settings/corruptor/corruptor_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Explosion = require("scripts/utilities/attack/explosion")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local NavQueries = require("scripts/utilities/nav_queries")
local STATES = table.enum("dormant", "idle", "exposed", "dead")
local CorruptorExtension = class("CorruptorExtension")

CorruptorExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._current_state = STATES.dormant
	self._use_trigger = false
	self._objective_name = "default"
	self._global_effect_id = nil
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world
	self._nav_world = extension_init_context.nav_world
	local position = POSITION_LOOKUP[unit]
	self._root_position = Vector3Box(position)
	self._constraint_target = Unit.animation_find_constraint_target(unit, CorruptorSettings.constraint_name)
	self._hatch_is_open = true
	self._previous_constrain_target = Vector3Box(position + Quaternion.up(Unit.local_rotation(unit, 1)))
	self._eye_is_active = false
	self._effect_template_data = {
		awake = {
			template = EffectTemplates.corruptor_ambience_burrowed
		},
		emerge = {
			template = EffectTemplates.corruptor_ambience
		}
	}
	local unit_level_index = Managers.state.unit_spawner:level_index(unit)
	self._unit_level_index = unit_level_index
end

CorruptorExtension.extensions_ready = function (self, world, unit)
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
end

CorruptorExtension.hot_join_sync = function (self, unit, sender, channel_id)
	if self._eye_is_active then
		RPC.rpc_set_corruptor_eye_active(channel_id, self._unit_level_index, self._eye_is_active)
	end
end

CorruptorExtension.setup_from_component = function (self, use_trigger)
	self._use_trigger = use_trigger
end

CorruptorExtension.destroy = function (self)
	if self._is_server then
		for effect_template_data_name, _ in pairs(self._effect_template_data) do
			self:_stop_effect_template(effect_template_data_name)
		end
	end
end

CorruptorExtension.awake = function (self)
	if self._current_state == STATES.dormant then
		self._current_state = STATES.idle

		self:_start_effect_template("awake")
	end
end

CorruptorExtension.expose = function (self)
	if self._current_state == STATES.idle then
		self._explosion_timer = CorruptorSettings.explosion_timing
		self._emerge_done_timer = CorruptorSettings.emerge_done_timing
		self._current_state = STATES.exposed

		self._animation_extension:anim_event("emerge")
		self:set_eye_activated(true)
	end
end

CorruptorExtension.damaged = function (self, damage)
	if self._current_state == STATES.exposed then
		Unit.flow_event(self._unit, "lua_corruptor_damaged")
		self._animation_extension:anim_event("hit_reaction")

		local max_health = self._health_extension:max_health()
		local damage_percent = damage / max_health
		local anim_event = (damage_percent >= 0.1 and "hit_reaction") or "hit_reaction_light"

		self._animation_extension:anim_event(anim_event)
	end
end

CorruptorExtension.died = function (self)
	local animation_extension = self._animation_extension

	animation_extension:anim_event("die")
	animation_extension:anim_event("look_at_off")

	for effect_template_data_name, _ in pairs(self._effect_template_data) do
		self:_stop_effect_template(effect_template_data_name)
	end

	self._current_state = STATES.dead

	Unit.flow_event(self._unit, "lua_corruptor_dead")

	local unit = self._unit
	local liquid_node_name = CorruptorSettings.liquid_node_name
	local node_index = Unit.node(unit, liquid_node_name)
	local world_rotation = Unit.world_rotation(unit, node_index)
	local world_position = Unit.world_position(unit, node_index)
	local liquid_goo_distance = CorruptorSettings.liquid_goo_distance
	local forward = Vector3.normalize(Quaternion.right(world_rotation))
	local sample_position = world_position + forward * liquid_goo_distance + Vector3.down()
	local above = CorruptorSettings.liquid_above
	local below = CorruptorSettings.liquid_below
	local horizontal = CorruptorSettings.liquid_horizontal
	local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(self._nav_world, nil, sample_position, above, below, horizontal)

	if position_on_navmesh then
		local liquid_area_template = CorruptorSettings.liquid_area_template

		LiquidArea.try_create(position_on_navmesh, forward, self._nav_world, liquid_area_template, unit)
	end
end

CorruptorExtension.activate_segment_units = function (self)
	local target_extension = self._mission_objective_target_extension
	self._objective_name = target_extension:objective_name()

	target_extension:set_ui_target_type("demolition")

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(self._objective_name)

	fassert(synchronizer_unit, "No synchronizer found")

	local synchronizer_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

	synchronizer_extension:activate_units()
end

CorruptorExtension.update = function (self, unit, dt, t)
	local closest_target, closest_distance = self:_update_closest_target()

	if self._is_server then
		self:_update_explosion(unit, dt)
		self:_update_exposed(dt, t, closest_target, closest_distance)
	end

	self:_update_eye_constraint(unit, dt, closest_target, closest_distance)
end

CorruptorExtension.use_trigger = function (self)
	return self._use_trigger
end

CorruptorExtension._start_effect_template = function (self, effect_template_data_name)
	local effect_template_data = self._effect_template_data[effect_template_data_name]
	local optional_unit, optional_node = nil
	local position = self._root_position:unbox()
	local fx_system = Managers.state.extension:system("fx_system")
	local template = effect_template_data.template
	local global_effect_id = fx_system:start_template_effect(template, optional_unit, optional_node, position)
	effect_template_data.global_effect_id = global_effect_id
end

CorruptorExtension._stop_effect_template = function (self, effect_template_data_name)
	local effect_template_data = self._effect_template_data[effect_template_data_name]
	local global_effect_id = effect_template_data.global_effect_id

	if global_effect_id then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:stop_template_effect(global_effect_id)

		effect_template_data.global_effect_id = nil
	end
end

CorruptorExtension._update_explosion = function (self, unit, dt)
	if not self._explosion_timer then
		return
	end

	self._explosion_timer = self._explosion_timer - dt

	if self._explosion_timer > 0 then
		return
	end

	local power_level = CorruptorSettings.explosion_power_level
	local charge_level = 1
	local explosion_template = CorruptorSettings.emerge_explosion_template
	local attack_type = AttackSettings.attack_types.explosion
	local up = Quaternion.up(Unit.local_rotation(unit, 1))
	local explosion_position = self._root_position:unbox() + up

	Explosion.create_explosion(self._world, self._physics_world, explosion_position, up, unit, explosion_template, power_level, charge_level, attack_type)

	self._explosion_timer = nil
end

CorruptorExtension._update_closest_target = function (self)
	if not self._eye_is_active then
		return
	end

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name(CorruptorSettings.target_side_name)
	local target_units = side.valid_player_units
	local position = self._root_position:unbox()
	local closest_distance = math.huge
	local closest_target = nil

	for i = 1, #target_units, 1 do
		local target_unit = target_units[i]
		local target_unit_position = POSITION_LOOKUP[target_unit]
		local distance = Vector3.distance(position, target_unit_position)

		if distance < closest_distance then
			closest_distance = distance
			closest_target = target_unit
		end
	end

	return closest_target, closest_distance
end

CorruptorExtension._update_eye_constraint = function (self, unit, dt, closest_target, closest_distance)
	if not self._eye_is_active or not closest_target then
		return
	end

	if self._is_server and self._current_state == STATES.exposed then
		local is_looking = self._looking_at_target

		if is_looking and CorruptorSettings.look_at_leave_distance < closest_distance then
			self._animation_extension:anim_event("look_at_off")

			self._looking_at_target = false
		elseif not is_looking and closest_distance < CorruptorSettings.look_at_enter_distance then
			self._animation_extension:anim_event("look_at_on")

			self._looking_at_target = true
		end
	end

	if CorruptorSettings.look_at_leave_distance < closest_distance then
		return closest_target, closest_distance
	end

	local eye_node = Unit.node(unit, CorruptorSettings.eye_node_name)
	local eye_position = Unit.world_position(unit, eye_node)
	local look_at_node = Unit.node(closest_target, CorruptorSettings.look_at_node)
	local target_position = Unit.world_position(closest_target, look_at_node)
	local aim_direction_normalized = Vector3.normalize(target_position - eye_position)
	local eye_rotation = Unit.local_rotation(unit, 1)
	local up = Quaternion.up(eye_rotation)
	local aim_target = nil
	local dot = Vector3.dot(up, aim_direction_normalized)
	local dot_threshold = CorruptorSettings.contrain_dot_threshold

	if dot < dot_threshold then
		local forward = Quaternion.forward(eye_rotation)
		local right = Quaternion.right(eye_rotation)
		local up_to_forward_dot = Vector3.dot(forward, aim_direction_normalized)
		local up_to_right_dot = Vector3.dot(right, aim_direction_normalized)
		local direction_projected_forward = up_to_forward_dot * forward
		local direction_projected_right = up_to_right_dot * right
		local lerp_amount = CorruptorSettings.constrain_lerp_amount
		local projected_direction = Vector3.normalize(direction_projected_forward + direction_projected_right)
		local final_direction = Vector3.lerp(projected_direction, up, lerp_amount)
		aim_target = eye_position + final_direction
	else
		aim_target = eye_position + aim_direction_normalized
	end

	local previous_constrain_target = self._previous_constrain_target:unbox()
	local lerp_t = math.min(dt * CorruptorSettings.constrain_aim_speed, 1)
	aim_target = Vector3.lerp(previous_constrain_target, aim_target, lerp_t)

	self._previous_constrain_target:store(aim_target)
	Unit.animation_set_constraint_target(unit, self._constraint_target, aim_target)
end

CorruptorExtension._update_exposed = function (self, dt, t, closest_target, closest_distance)
	if self._current_state ~= STATES.exposed then
		return
	end

	if self._emerge_done_timer then
		self._emerge_done_timer = self._emerge_done_timer - dt

		if self._emerge_done_timer <= 0 then
			self:_stop_effect_template("awake")
			self:_start_effect_template("emerge")
			self._health_extension:set_invulnerable(false)

			self._emerge_done_timer = nil
		else
			return
		end
	end

	if not closest_target or not closest_distance then
		return
	end

	local open_hatch_distance = CorruptorSettings.open_hatch_distance
	local close_hatch_distance = CorruptorSettings.close_hatch_distance

	if not self._hatch_is_open and closest_distance <= open_hatch_distance then
		self._hatch_is_open = true

		self._animation_extension:anim_event("open")
	elseif self._hatch_is_open and close_hatch_distance < closest_distance then
		self._hatch_is_open = false

		self._animation_extension:anim_event("close")
	end

	if self._hatch_is_open then
		if not self._next_damage_tick then
			self._next_damage_tick = t + CorruptorSettings.tick_frequency
		end

		if self._next_damage_tick <= t then
			local position = self._root_position:unbox()
			local attack_direction = Vector3.normalize(POSITION_LOOKUP[closest_target] - position)

			Attack.execute(closest_target, CorruptorSettings.tick_damage_profile, "power_level", CorruptorSettings.tick_power_level, "attacking_unit", self._unit, "attack_direction", attack_direction, "hit_zone_name", "torso", "damage_type", CorruptorSettings.tick_damage_type)

			self._next_damage_tick = t + CorruptorSettings.tick_frequency
		end
	end
end

CorruptorExtension.set_eye_activated = function (self, activated)
	if self._is_server then
		Managers.state.game_session:send_rpc_clients("rpc_set_corruptor_eye_active", self._unit_level_index, activated)
	end

	self._eye_is_active = activated
end

return CorruptorExtension
