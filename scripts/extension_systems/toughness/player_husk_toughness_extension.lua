local PlayerUnitData = require("scripts/extension_systems/unit_data/utilities/player_unit_data")
local PlayerHuskToughnessExtension = class("PlayerHuskToughnessExtension")
local _max_toughness_and_toughness_damage = nil

PlayerHuskToughnessExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._unit = unit
	self._game_session = game_session
	self._game_object_id = game_object_id
	self._world = extension_init_context.world
	self._wwise_world = Wwise.wwise_world(self._world)
	self._fx_extension = ScriptUnit.extension(unit, "fx_system")
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local toughness_template = extension_init_data.toughness_template

	fassert(toughness_template, "Missing toughness_template in extension_init_data for PlayerHuskToughnessExtension")

	self._toughness_template = toughness_template
	local is_local_unit = extension_init_data.is_local_unit
	self._is_local_unit = is_local_unit

	if is_local_unit then
		local component_name = PlayerUnitData.looping_sound_component_name("toughness_loop")
		self._looping_sound_component = unit_data_extension:read_component(component_name)
	end
end

PlayerHuskToughnessExtension.update = function (self, context, dt, t)
	return

	local max_toughness, toughness_damage = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	if not max_toughness or not toughness_damage then
		return
	end

	if not self._is_local_unit then
		return
	end

	if toughness_damage > 0 and not self._toughness_effect then
		self._toughness_effect = World.create_particles(self._world, "content/fx/particles/screenspace/toughness", Vector3(0, 0, 1))

		self._fx_extension:trigger_looping_wwise_event("toughness_loop", "head")
	elseif self._toughness_effect and toughness_damage <= 0 then
		World.destroy_particles(self._world, self._toughness_effect)

		self._toughness_effect = nil

		if self._looping_sound_component.is_playing then
			self._fx_extension:stop_looping_wwise_event("toughness_loop")
		end
	end

	if toughness_damage > 0 and self._toughness_effect then
		local toughness_id = World.find_particles_variable(self._world, "content/fx/particles/screenspace/toughness", "size")
		local modifier = 1 - toughness_damage / max_toughness
		local min_x = 68
		local min_y = 40
		local max_x = min_x * 3.5
		local max_y = min_y * 3.5
		local x = math.lerp(min_x, max_x, modifier)
		local y = math.lerp(min_y, max_y, modifier)

		World.set_particles_variable(self._world, self._toughness_effect, toughness_id, Vector3(x, y, 0))
		WwiseWorld.set_global_parameter(self._wwise_world, "player_experience_toughness", modifier * 100)
	end
end

PlayerHuskToughnessExtension.toughness_templates = function (self)
	return self._toughness_template, nil
end

PlayerHuskToughnessExtension.toughness_damage = function (self)
	local _, toughness_damage = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return toughness_damage
end

PlayerHuskToughnessExtension.max_toughness = function (self)
	local max_toughness, _ = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return max_toughness
end

PlayerHuskToughnessExtension.current_toughness_percent = function (self)
	local max_toughness, toughness_damage = _max_toughness_and_toughness_damage(self._game_session, self._game_object_id)

	return 1 - toughness_damage / max_toughness
end

function _max_toughness_and_toughness_damage(game_session, game_object_id)
	local max_toughness = GameSession.game_object_field(game_session, game_object_id, "toughness")
	local toughness_damage = GameSession.game_object_field(game_session, game_object_id, "toughness_damage")

	return max_toughness, toughness_damage
end

return PlayerHuskToughnessExtension
