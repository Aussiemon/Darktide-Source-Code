-- chunkname: @scripts/settings/fx/effect_templates/zealot_relic_blessed.lua

local Unit_has_node = Unit.has_node
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local VFX = "content/fx/particles/player_buffs/buff_preacher_holy_light"
local NODE_NAME = "j_spine"
local resources = {}
local _create_particles, _destroy_particles
local effect_template = {
	name = "zealot_relic_blessed",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
		local is_in_first_person_mode = first_person_extension:is_in_first_person_mode()

		template_data.first_person_extension = first_person_extension
		template_data.is_in_first_person_mode = is_in_first_person_mode

		_create_particles(template_data, template_context)
	end,
	update = function (template_data, template_context, dt, t)
		local was_in_first_person_mode = template_data.is_in_first_person_mode
		local is_in_first_person_mode = template_data.first_person_extension:is_in_first_person_mode()

		template_data.is_in_first_person_mode = is_in_first_person_mode

		if not was_in_first_person_mode and is_in_first_person_mode then
			_destroy_particles(template_data, template_context)
		end

		if was_in_first_person_mode and not is_in_first_person_mode then
			_create_particles(template_data, template_context)
		end
	end,
	stop = function (template_data, template_context)
		_destroy_particles(template_data, template_context)
	end
}

function _create_particles(template_data, template_context)
	local world = template_context.world
	local unit = template_data.unit

	if not Unit_has_node(unit, NODE_NAME) then
		return
	end

	if template_data.effect_id then
		return
	end

	if template_data.is_in_first_person_mode then
		return
	end

	local node_index = Unit_node(unit, NODE_NAME)
	local node_position = Unit_world_position(unit, node_index)
	local effect_id = World.create_particles(world, VFX, node_position)
	local orphaned_policy = "destroy"

	World.link_particles(world, effect_id, unit, node_index, Matrix4x4.identity(), orphaned_policy)

	template_data.effect_id = effect_id
end

function _destroy_particles(template_data, template_context)
	local world = template_context.world
	local effect_id = template_data.effect_id

	if effect_id then
		World.stop_spawning_particles(world, effect_id)

		template_data.effect_id = nil
	end
end

return effect_template
