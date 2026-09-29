-- chunkname: @scripts/components/spillway_boss_tooth.lua

local SpillwayBossTooth = component("SpillwayBossTooth")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local CameraShake = require("scripts/utilities/camera/camera_shake")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local attack_types = AttackSettings.attack_types
local ANIM_SPAWN = "Spawn"
local ANIM_DESPAWN = "Despawn"
local SPAWN_DURATION = 0.9
local DESPAWN_DURATION = 0.9
local KNOCKBACK_TIMING = 0.5666666666666667
local RAISED_Z_OFFSET = 5.6
local LOWERED_Z_OFFSET = -0.5
local KNOCKBACK_RANGE = 3
local RISE_DELAY = EffectTemplates.renegade_wizard_pillar.rise_delay
local PILE_UNIT = "content/environment/artsets/imperial/spillway/props/nurgle/boss_tooth/pile_08"
local PILE_Z_OFFSET = -0.5
local PILE_SCALE_HIDDEN = Vector3Box(0.25, 0.25, 0)
local PILE_SCALE_VISIBLE = Vector3Box(0.9, 0.9, 1)
local PILE_SCALE_DURATION = 0.4
local PILE_GROW_DELAY = 0.26666666666666666
local PILE_SHRINK_DELAY = 0.6666666666666666
local CLIENT_RPCS = {
	"rpc_spillway_boss_tooth_hot_join_sync",
	"rpc_spillway_boss_tooth_set_raised",
}
local SFX = {
	lower = "wwise/events/minions/play_enemy_psyker_cover_down",
	raise = "wwise/events/minions/play_enemy_psyker_cover_up",
}

SpillwayBossTooth.init = function (self, unit, is_server, nav_world)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	self._is_server = is_server
	self._unit = unit

	local init_position = POSITION_LOOKUP[unit]

	self._init_position = Vector3Box(init_position)
	self._to_position = Vector3Box(init_position + Vector3(0, 0, RAISED_Z_OFFSET))

	local from_position = init_position + Vector3(0, 0, LOWERED_Z_OFFSET)

	self._from_position = Vector3Box(from_position)

	local run_update = true
	local look_at_position = Vector3(-383, 75, -11)
	local direction = init_position - look_at_position
	local flat_direction = Vector3.normalize(Vector3.flat(direction))
	local up_vector = Vector3.up()
	local new_rotation = Quaternion.look(flat_direction, up_vector)

	Unit.set_local_rotation(unit, 1, new_rotation)
	Unit.set_local_position(unit, 1, from_position)

	local pile_unit = Managers.state.unit_spawner:spawn_unit(PILE_UNIT, "level_prop", init_position, Quaternion.identity(), nil)

	self._pile_unit = pile_unit
	self._pile_scale_from = Vector3Box(PILE_SCALE_HIDDEN:unbox())

	local random_rotation = Quaternion.axis_angle(Vector3.up(), math.random() * math.pi * 2)

	Unit.set_local_rotation(pile_unit, 1, random_rotation)
	Unit.set_local_position(pile_unit, 1, init_position + Vector3(0, 0, PILE_Z_OFFSET))
	Unit.set_local_scale(pile_unit, 1, PILE_SCALE_HIDDEN:unbox())

	self._is_raised = false
	self._is_moving = false
	self._queued_raise = false

	local should_raise = true

	self:_start_move(should_raise)

	if not is_server then
		local network_event_delegate = Managers.connection:network_event_delegate()

		self._network_event_delegate = network_event_delegate

		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

		if game_object_id then
			self._game_object_id = game_object_id

			network_event_delegate:register_session_unit_events(self, game_object_id, unpack(CLIENT_RPCS))

			self._registered_rpcs = true
		end
	end

	return run_update
end

SpillwayBossTooth.editor_init = function (self, unit)
	return
end

SpillwayBossTooth.enable = function (self, unit)
	return
end

SpillwayBossTooth.disable = function (self, unit)
	return
end

SpillwayBossTooth.destroy = function (self, unit)
	if self._is_server then
		self:stop_pillar_vfx()
		self:disable_nav_cost()
	elseif self._registered_rpcs then
		self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(CLIENT_RPCS))

		self._registered_rpcs = false
	end

	if self._pile_unit then
		Managers.state.unit_spawner:mark_for_deletion(self._pile_unit)

		self._pile_unit = nil
	end
end

SpillwayBossTooth.hot_join_sync = function (self, joining_client, joining_channel)
	if not self._is_server then
		return
	end

	local game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)

	if not game_object_id then
		return
	end

	local is_raised = self._is_raised or self._queued_raise

	RPC.rpc_spillway_boss_tooth_hot_join_sync(joining_channel, game_object_id, is_raised)
end

SpillwayBossTooth._start_move = function (self, should_raise)
	if not should_raise then
		self:stop_pillar_vfx()
	end

	if not self._is_moving and self._is_raised == should_raise then
		return
	end

	local t = Managers.time:time("gameplay")

	self._is_raised = should_raise
	self._is_moving = true
	self._knockback_applied = false
	self._knockback_t = should_raise and t + KNOCKBACK_TIMING or nil
	self._move_end_t = t + (should_raise and SPAWN_DURATION or DESPAWN_DURATION)

	if should_raise then
		self:_start_pile_scale(t, true, PILE_GROW_DELAY)
	else
		self:_start_pile_scale(t, false, PILE_SHRINK_DELAY)
	end

	Unit.animation_event(self._unit, should_raise and ANIM_SPAWN or ANIM_DESPAWN)

	if not self._is_server then
		return
	end

	local fx_system = Managers.state.extension:system("fx_system")

	fx_system:trigger_wwise_event(should_raise and SFX.raise or not should_raise and SFX.lower, nil, self._unit)
end

SpillwayBossTooth.rpc_spillway_boss_tooth_hot_join_sync = function (self, channel_id, game_object_id, is_raised)
	local unit = self._unit

	self._is_moving = false
	self._is_raised = is_raised

	if is_raised then
		Unit.set_local_position(unit, 1, self._to_position:unbox())
		Unit.animation_event(unit, ANIM_SPAWN)
		self:_set_collision_enabled(true)
	else
		Unit.set_local_position(unit, 1, self._from_position:unbox())
		Unit.animation_event(unit, ANIM_DESPAWN)
		self:_set_collision_enabled(false)
	end
end

SpillwayBossTooth.enable_nav_cost = function (self)
	local is_server = self._is_server

	if is_server and not self._nav_cost_map_volume_id then
		local radius = 2
		local cost = 20
		local nav_cost_map_name = "daemonhost"
		local nav_cost_map_id = Managers.state.nav_mesh:nav_cost_map_id(nav_cost_map_name)
		local nav_cost_map_volume_id = Managers.state.nav_mesh:add_nav_cost_map_sphere_volume(self._init_position:unbox(), radius, cost, nav_cost_map_id)

		self._nav_cost_map_volume_id = nav_cost_map_volume_id
		self._nav_cost_map_id = nav_cost_map_id
	end
end

SpillwayBossTooth.disable_nav_cost = function (self)
	local is_server = self._is_server

	if is_server then
		local nav_cost_map_id = self._nav_cost_map_id
		local nav_cost_map_volume_id = self._nav_cost_map_volume_id

		if nav_cost_map_volume_id then
			Managers.state.nav_mesh:remove_nav_cost_map_volume(nav_cost_map_volume_id, nav_cost_map_id)

			self._nav_cost_map_volume_id = nil
			self._nav_cost_map_id = nil
		end
	end
end

SpillwayBossTooth.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	return success, error_message
end

SpillwayBossTooth.update = function (self, unit, dt, t)
	if rawget(_G, "LevelEditor") or rawget(_G, "UnitEditor") then
		return
	end

	if self._queued_raise and t >= self._queued_raise_t then
		self._queued_raise = false
		self._queued_raise_t = nil

		self:_start_move(true)
	end

	self:_update_pile_scale(t)

	if self._is_moving then
		self:_move_update(t)
	end

	local run_update = true

	return run_update
end

SpillwayBossTooth.set_raised = function (self, raised)
	if self._is_server then
		local game_object_id = Managers.state.unit_spawner:game_object_id(self._unit)

		if game_object_id then
			Managers.state.game_session:send_rpc_clients("rpc_spillway_boss_tooth_set_raised", game_object_id, raised)
		end
	end

	self:_apply_raised_state(raised)
end

SpillwayBossTooth.rpc_spillway_boss_tooth_set_raised = function (self, channel_id, game_object_id, raised)
	self:_apply_raised_state(raised)
end

SpillwayBossTooth._apply_raised_state = function (self, raised)
	if raised then
		if self._is_raised or self._queued_raise then
			return
		end

		self._queued_raise = true
		self._queued_raise_t = Managers.time:time("gameplay") + RISE_DELAY
	else
		self._queued_raise = false
		self._queued_raise_t = nil

		self:stop_pillar_vfx()
		self:_start_move(false)
	end
end

SpillwayBossTooth._move_update = function (self, t)
	if self._is_raised and not self._knockback_applied and t >= self._knockback_t then
		self._knockback_applied = true

		self:_apply_knockback()
	end

	if t < self._move_end_t then
		return
	end

	self._is_moving = false

	if self._is_raised then
		self:_set_collision_enabled(true)

		if self._is_server then
			self:enable_nav_cost()
		end
	else
		self:_set_collision_enabled(false)

		if self._is_server then
			self:disable_nav_cost()
		end
	end
end

SpillwayBossTooth._start_pile_scale = function (self, t, visible, delay)
	local pile_unit = self._pile_unit

	if not pile_unit then
		return
	end

	self._pile_scale_from:store(Unit.local_scale(pile_unit, 1))

	self._pile_scale_visible = visible
	self._pile_scale_start_t = t + delay
	self._pile_scale_end_t = t + delay + PILE_SCALE_DURATION
end

SpillwayBossTooth._update_pile_scale = function (self, t)
	local end_t = self._pile_scale_end_t

	if not end_t then
		return
	end

	local start_t = self._pile_scale_start_t

	if t < start_t then
		return
	end

	local progress = math.clamp01(math.ilerp(start_t, end_t, t))
	local to_scale = self._pile_scale_visible and PILE_SCALE_VISIBLE or PILE_SCALE_HIDDEN
	local scale = Vector3.lerp(self._pile_scale_from:unbox(), to_scale:unbox(), progress)

	Unit.set_local_scale(self._pile_unit, 1, scale)

	if progress >= 1 then
		self._pile_scale_start_t = nil
		self._pile_scale_end_t = nil
	end
end

SpillwayBossTooth._set_collision_enabled = function (self, enabled)
	local unit = self._unit
	local num_actors = Unit.num_actors(unit)

	for i = 1, num_actors do
		local actor = Unit.actor(unit, i)

		if actor then
			Actor.set_collision_enabled(actor, enabled)
			Actor.set_scene_query_enabled(actor, enabled)
		end
	end
end

SpillwayBossTooth.is_raised = function (self)
	return self._is_raised or self._queued_raise or false
end

SpillwayBossTooth.set_pillar_effect_id = function (self, effect_id)
	self._pillar_effect_id = effect_id
end

SpillwayBossTooth.stop_pillar_vfx = function (self)
	if not self._is_server then
		return
	end

	local effect_id = self._pillar_effect_id

	if not effect_id then
		return
	end

	local fx_system = Managers.state.extension:system("fx_system")

	if fx_system:has_running_template_effect_with_global_effect_id(effect_id) then
		fx_system:stop_template_effect(effect_id)
	end

	self._pillar_effect_id = nil
end

SpillwayBossTooth.despawn = function (self)
	self:stop_pillar_vfx()
	self:set_raised(false)
end

SpillwayBossTooth.mark_for_deletion = function (self)
	self:stop_pillar_vfx()

	local unit = self._unit

	self.already_marked_for_deletion = true

	Managers.state.unit_spawner:mark_for_deletion(unit)
end

SpillwayBossTooth._apply_knockback = function (self)
	if not self._is_server then
		return
	end

	local unit = self._unit
	local tooth_position_flat = Vector3.flat(self._init_position:unbox())
	local knockback_range_sq = KNOCKBACK_RANGE * KNOCKBACK_RANGE
	local damage_profile = DamageProfileTemplates.spillway_wizard_dance_wall_knockback
	local players = Managers.state.player_unit_spawn:alive_players()
	local hit_any_player = false

	for i = 1, #players do
		local player_unit = players[i].player_unit

		if HEALTH_ALIVE[player_unit] then
			local to_player = Vector3.flat(POSITION_LOOKUP[player_unit]) - tooth_position_flat
			local distance_sq = Vector3.length_squared(to_player)

			if distance_sq < knockback_range_sq then
				local direction

				if distance_sq > 0.0001 then
					direction = Vector3.normalize(to_player)
				else
					direction = Quaternion.forward(Unit.local_rotation(player_unit, 1))
				end

				local hit_world_position = Unit.world_position(player_unit, 1)

				Attack.execute(player_unit, damage_profile, "power_level", 250, "attacking_unit", unit, "attack_type", attack_types.explosion, "attack_direction", direction, "hit_world_position", hit_world_position, "damage_type", "minion_charge")

				hit_any_player = true
			end
		end
	end

	if hit_any_player then
		local tooth_position = self._init_position:unbox()
		local near_distance = KNOCKBACK_RANGE
		local far_distance = KNOCKBACK_RANGE * 2

		CameraShake.camera_shake_by_distance("breach_charge_explosion", tooth_position, near_distance, far_distance, 1, 0.5)
	end
end

SpillwayBossTooth.component_data = {}

return SpillwayBossTooth
