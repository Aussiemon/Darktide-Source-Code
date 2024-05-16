-- chunkname: @scripts/settings/fx/effect_templates/netted.lua

local Unit_has_node = Unit.has_node
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local VFX = "content/fx/particles/player_buffs/player_netted_idle"
local NODE_NAME = "j_spine"
local resources = {}
local effect_template = {
	name = "netted",
	resources = resources,
	start = function (template_data, template_context)
		local world = template_context.world
		local unit = template_data.unit

		if not Unit_has_node(unit, NODE_NAME) then
			return
		end

		local node_index = Unit_node(unit, NODE_NAME)
		local node_position = Unit_world_position(unit, node_index)
		local effect_id = World.create_particles(world, VFX, node_position)
		local orphaned_policy = "destroy"

		World.link_particles(world, effect_id, unit, node_index, Matrix4x4.identity(), orphaned_policy)

		template_data.effect_id = effect_id
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local effect_id = template_data.effect_id

		World.stop_spawning_particles(world, effect_id)
	end,
}

return effect_template
