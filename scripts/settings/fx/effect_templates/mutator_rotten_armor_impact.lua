-- chunkname: @scripts/settings/fx/effect_templates/mutator_rotten_armor_impact.lua

local HitZone = require("scripts/utilities/attack/hit_zone")
local Unit_has_node = Unit.has_node
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Unit_world_rotation = Unit.world_rotation
local VFX = "content/fx/particles/enemies/rotten_armor_leak"
local resources = {}
local _create_particles, _destroy_particles
local effect_template = {
	name = "mutator_rotten_armor_impact",
	resources = resources,
	start = function (template_data, template_context)
		_create_particles(template_data, template_context)
	end,
	update = function (template_data, template_context, dt, t)
		return
	end,
	stop = function (template_data, template_context)
		_destroy_particles(template_data, template_context)
	end,
}

function _create_particles(template_data, template_context)
	local world = template_context.world
	local unit = template_data.unit
	local node = template_data.node
	local position = template_data.position
	local hit_zone_name = NetworkLookup.hit_zones[node]
	local node_names = HitZone.get_actor_names(unit, hit_zone_name)
	local node_index = Unit_node(unit, node_names[1])
	local unit_position = Unit_world_position(unit, node_index)
	local rotation = Quaternion.look(position)
	local effect_id = World.create_particles(world, VFX, unit_position)
	local orphaned_policy = "destroy"

	World.link_particles(world, effect_id, unit, node_index, Matrix4x4.identity(), orphaned_policy)

	template_data.effect_id = effect_id
end

function _destroy_particles(template_data, template_context)
	local world = template_context.world
	local effect_id = template_data.effect_id

	if effect_id then
		World.destroy_particles(world, effect_id)

		template_data.effect_id = nil
	end
end

return effect_template
