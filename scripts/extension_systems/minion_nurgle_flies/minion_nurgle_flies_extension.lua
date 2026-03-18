-- chunkname: @scripts/extension_systems/minion_nurgle_flies/minion_nurgle_flies_extension.lua

local FixedFrame = require("scripts/utilities/fixed_frame")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local VFX_NAME = "content/fx/particles/enemies/nurgle_flies"
local FIZZLE_OUT_VFX_NAME = "content/fx/particles/enemies/nurgle_flies_dissipate"
local SFX_LOOP_NAME = "wwise/events/minions/play_nurgle_flies_loop"
local HUSK_SFX_LOOP_NAME = "wwise/events/minions/play_nurgle_flies_swarm_enter_husk"
local HUSK_SFX_LOOP_STOP_NAME = "wwise/events/minions/play_nurgle_flies_swarm_exit_husk"
local MinionNurgleFliesExtension = class("MinionNurgleFliesExtension")

MinionNurgleFliesExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local game_session = Managers.state.game_session:game_session()
	local breed = extension_init_data.breed

	self._breed = breed
	self._chase_target_template = breed.chase_target_template
	self._game_session = game_session
	self._game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	self._spawn_time = extension_init_data.spawn_time
	self._nav_world = extension_init_context.nav_world
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server
	self._unit = unit
end

MinionNurgleFliesExtension.extensions_ready = function (self, world, unit)
	self._start_t = FixedFrame.get_latest_fixed_time()
	self._fizzle_out_start_t = self._start_t + self._chase_target_template.lifetime
	self._fizzle_out_end_t = self._fizzle_out_start_t + self._chase_target_template.fizzle_out_duration

	self:_spawn_effects(unit)
end

MinionNurgleFliesExtension._game_world = function (self)
	local world_name = "level_world"
	local world = Managers.world:world(world_name)
	local wwise_world = Managers.world:wwise_world(world)

	return world, wwise_world
end

MinionNurgleFliesExtension.destroy = function (self)
	self:_destroy_effects()
end

MinionNurgleFliesExtension.update = function (self, context, dt, t)
	self:_update_player_hit_by_nurgle_flies(t)
	self:_update_effect_positions(t, dt)

	if self:_lifetime_over(t) and not self._hit_player_data then
		self:_despawn()
	end
end

MinionNurgleFliesExtension._update_player_hit_by_nurgle_flies = function (self, t)
	if self._hit_player_data then
		local buff_ext = self._hit_player_data.buff_ext
		local has_debuff = buff_ext and buff_ext:has_keyword(buff_keywords.nurgle_flies)

		if not has_debuff then
			self._fizzle_out_start_t = t
			self._fizzle_out_end_t = self._fizzle_out_start_t + self._chase_target_template.fizzle_out_duration
			self._hit_player_data = nil
		end
	else
		local player_manager = Managers.player
		local players = player_manager:players()

		for _, player in pairs(players) do
			local player_unit = player.player_unit
			local buff_ext = ScriptUnit.has_extension(player_unit, "buff_system")

			if buff_ext and buff_ext:has_keyword(buff_keywords.nurgle_flies) then
				self:_attach_to_hit_player(player, buff_ext)
			end
		end
	end
end

MinionNurgleFliesExtension._spawn_effects = function (self, unit)
	local world, wwise_world = self:_game_world()
	local vfx_pos = POSITION_LOOKUP[self._unit]

	self._vfx_pos = Vector3Box(vfx_pos)
	self._effect_id = World.create_particles(world, VFX_NAME, vfx_pos)
	self._vfx_velocity = Vector3Box(Vector3.forward())
	self._sfx_source_id = WwiseWorld.make_manual_source(wwise_world, unit, 1)
	self._sfx_id = WwiseWorld.trigger_resource_event(wwise_world, SFX_LOOP_NAME, self._sfx_source_id)
end

MinionNurgleFliesExtension._switch_to_fizzle_out_vfx = function (self)
	local world = self:_game_world()

	if self._effect_id then
		World.destroy_particles(world, self._effect_id)

		local vfx_offset = Vector3.up() * self._chase_target_template.vfx_ground_offset
		local vfx_pos = self._vfx_pos:unbox() + vfx_offset

		self._effect_id = World.create_particles(world, FIZZLE_OUT_VFX_NAME, vfx_pos)
		self._vfx_switched = true
	end
end

MinionNurgleFliesExtension._switch_to_husk_sfx = function (self)
	local _, wwise_world = self:_game_world()

	if self._sfx_source_id then
		WwiseWorld.stop_event(wwise_world, self._sfx_id)

		self._sfx_id = WwiseWorld.trigger_resource_event(wwise_world, HUSK_SFX_LOOP_NAME, self._sfx_source_id)
	end

	self._switched_to_husk_sfx = true
end

MinionNurgleFliesExtension._attach_to_hit_player = function (self, player, buff_ext)
	local is_local_player = player:peer_id() == Network.peer_id()

	self._hit_player_data = {
		player_unit = player.player_unit,
		is_local_player = is_local_player,
		buff_ext = buff_ext,
	}

	if is_local_player then
		self:_destroy_effects()
	elseif not is_local_player and self._sfx_id then
		self:_switch_to_husk_sfx()
	end
end

MinionNurgleFliesExtension._destroy_effects = function (self)
	local world, wwise_world = self:_game_world()

	if self._effect_id then
		World.destroy_particles(world, self._effect_id)

		self._effect_id = nil
	end

	if self._sfx_source_id then
		WwiseWorld.stop_event(wwise_world, self._sfx_id)
		WwiseWorld.destroy_manual_source(wwise_world, self._sfx_source_id)

		self._sfx_source_id = nil
	end
end

MinionNurgleFliesExtension._update_effect_positions = function (self, t, dt)
	local effect_id = self._effect_id
	local world, wwise_world = self:_game_world()

	if not self._vfx_switched and self:is_fizzling_out(t) then
		self:_switch_to_fizzle_out_vfx()
	end

	if self._switched_to_husk_sfx and self:is_fizzling_out(t) then
		self._sfx_id = WwiseWorld.trigger_resource_event(wwise_world, HUSK_SFX_LOOP_STOP_NAME, self._sfx_source_id)
		self._switched_to_husk_sfx = nil
	end

	local should_update = effect_id and HEALTH_ALIVE[self._unit]

	if not should_update then
		return
	end

	local new_pos

	if self._hit_player_data and not self._hit_player_data.is_local_player then
		local player_unit = self._hit_player_data.player_unit

		new_pos = player_unit and Unit.local_position(player_unit, 1) or Vector3.zero()
	elseif not self._hit_player_data then
		local unit_pos = Unit.local_position(self._unit, 1)
		local vfx_pos = self._vfx_pos:unbox()
		local follow_speed = self._chase_target_template.vfx_follow_speed * self:speed_modifier(t)
		local alpha = math.clamp(follow_speed * dt, 0, 1)

		new_pos = Vector3.lerp(vfx_pos, unit_pos, alpha)
	end

	self._vfx_pos:store(new_pos)

	local vfx_offset = self._chase_target_template.vfx_ground_offset
	local offset_pos = new_pos + Vector3(0, 0, vfx_offset)

	World.move_particles(world, effect_id, offset_pos)
	World.set_particles_material_vector3(world, effect_id, "flies_base_ccw", "center", offset_pos)
	World.set_particles_material_vector3(world, effect_id, "flies_base_cw", "center", offset_pos)

	if self._sfx_source_id and self._sfx_id then
		WwiseWorld.set_source_position(wwise_world, self._sfx_source_id, offset_pos)
	end
end

MinionNurgleFliesExtension.vfx_pos = function (self)
	return self._vfx_pos
end

MinionNurgleFliesExtension.speed_modifier = function (self, t)
	local alpha = 1

	if self:is_fizzling_out(t) then
		alpha = 1 - math.ilerp(self._fizzle_out_start_t, self._fizzle_out_end_t, t)
	end

	return alpha
end

MinionNurgleFliesExtension.about_to_despawn = function (self, t)
	return t > self._fizzle_out_end_t or self._hit_player_data or self._vfx_switched
end

MinionNurgleFliesExtension.is_fizzling_out = function (self, t)
	return t > self._fizzle_out_start_t
end

MinionNurgleFliesExtension._lifetime_over = function (self, t)
	return t > self._fizzle_out_end_t
end

MinionNurgleFliesExtension._despawn = function (self)
	if not self._is_server then
		return
	end

	local navigation_ext = ScriptUnit.has_extension(self._unit, "navigation_system")
	local minion_spawn_manager = Managers.state.minion_spawn

	navigation_ext:stop()
	minion_spawn_manager:despawn_minion(self._unit)
end

return MinionNurgleFliesExtension
