local CONSUMED_EFFECT_UNIT = "content/characters/enemy/chaos_beast_of_nurgle/swallow/swallow_nurgle_symbol"
local STOMACH_UNIT = "content/characters/enemy/chaos_beast_of_nurgle/swallow/stomach"
local resources = {
	consumed_effect_unit = CONSUMED_EFFECT_UNIT,
	stomach_unit = STOMACH_UNIT
}
local NODE_NAME = "j_spine"
local effect_template = {
	name = "chaos_beast_of_nurgle_consumed_effect",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local unit = template_data.unit
		local game_session = Managers.state.game_session:game_session()
		local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
		template_data.game_object_id = game_object_id
		template_data.game_session = game_session
		local effect_unit = World.spawn_unit_ex(world, CONSUMED_EFFECT_UNIT)
		template_data.effect_unit = effect_unit
		local stomach_unit = World.spawn_unit_ex(world, STOMACH_UNIT)
		template_data.stomach_unit = stomach_unit

		Unit.set_unit_visibility(unit, false)
	end
}

effect_template.update = function (template_data, template_context, dt, t)
	local player = Managers.player:local_player(1)

	if player then
		local effect_unit = template_data.effect_unit
		local effect_unit_position = Unit.world_position(effect_unit, 1)
		local camera_position = Managers.state.camera:camera_position(player.viewport_name)
		local direction_to_camera = Vector3.normalize(camera_position - effect_unit_position)
		local rotation = Quaternion.look(direction_to_camera)

		Unit.set_local_rotation(effect_unit, 1, rotation)

		local unit = template_data.unit
		local position = Unit.world_position(unit, Unit.node(unit, NODE_NAME))

		Unit.set_local_position(effect_unit, 1, position)

		local stomach_unit = template_data.stomach_unit
		local unit_rotation = Unit.local_rotation(unit, 1)

		Unit.set_local_position(stomach_unit, 1, position)
		Unit.set_local_rotation(stomach_unit, 1, unit_rotation)
	end
end

effect_template.stop = function (template_data, template_context)
	local world = template_context.world
	local effect_unit = template_data.effect_unit

	World.destroy_unit(world, effect_unit)

	local stomach_unit = template_data.stomach_unit

	World.destroy_unit(world, stomach_unit)

	local unit = template_data.unit

	Unit.set_unit_visibility(unit, true)
end

return effect_template
