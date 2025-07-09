-- chunkname: @scripts/settings/fx/effect_templates/mutator_rotten_armor_stages.lua

local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local Unit_has_node = Unit.has_node
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local VFX = {
	"content/fx/particles/enemies/rotten_armor_ambient",
	"content/fx/particles/enemies/rotten_armor_ambient_lvl2",
	"content/fx/particles/enemies/rotten_armor_ambient_lvl3",
	"content/fx/particles/enemies/rotten_armor_ambient_lvl4",
}
local ogryn_node_names = {
	"j_rightarm",
	"j_leftarm",
}
local server_fallback_names = {}
local resources = {}
local _create_particles, _destroy_particles, _effect_id_length
local damage_thresholds = {
	0.75,
	0.5,
	0.25,
}
local effect_template = {
	name = "mutator_rotten_armor_stages",
	resources = resources,
	start = function (template_data, template_context)
		local unit = template_data.unit
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()

		template_data.health_extension = ScriptUnit.extension(unit, "health_system")
		template_data.current_damage_index = 1
		template_data.tags = breed.tags

		if template_data.tags.ogryn then
			template_data.effect_nodes = 2
		else
			template_data.effect_nodes = 1
		end

		template_data.vfx_particle_ids = {}
		template_data.intial_spawn = true
	end,
	update = function (template_data, template_context, dt, t)
		local world = template_context.world
		local current_health_percent = template_data.health_extension:current_health_percent()
		local current_damage_threshold = damage_thresholds[template_data.current_damage_index]

		if not current_damage_threshold then
			return
		end

		if template_data.intial_spawn or current_health_percent < current_damage_threshold then
			if not template_data.intial_spawn then
				_destroy_particles(template_data, template_context)
			end

			local num_effect_nodes = template_data.effect_nodes

			for i = 1, num_effect_nodes do
				_create_particles(template_data, template_context, i)
			end

			if not template_data.intial_spawn then
				template_data.current_damage_index = template_data.current_damage_index + 1
			end

			template_data.intial_spawn = false
		end
	end,
	stop = function (template_data, template_context)
		_destroy_particles(template_data, template_context)
	end,
}

function _create_particles(template_data, template_context, index)
	local world = template_context.world
	local unit = template_data.unit
	local effect_nodes
	local tags = template_data.tags
	local unit_position, node_index

	if not DEDICATED_SERVER then
		if tags.ogryn then
			node_index = Unit_node(unit, ogryn_node_names[index])
			unit_position = Unit_world_position(unit, node_index)
		else
			node_index = Unit_node(unit, "c_hips")
			unit_position = Unit_world_position(unit, node_index)
		end
	end

	if DEDICATED_SERVER then
		unit_position = Unit_world_position(unit, 1)
		node_index = 1
	end

	local effect_id = World.create_particles(world, VFX[template_data.current_damage_index], unit_position)
	local orphaned_policy = "destroy"

	World.link_particles(world, effect_id, unit, node_index, Matrix4x4.identity(), orphaned_policy)
	table.insert(template_data.vfx_particle_ids, effect_id)
end

function _destroy_particles(template_data, template_context)
	local world = template_context.world
	local vfx_particle_ids = template_data.vfx_particle_ids

	for i = 1, #vfx_particle_ids do
		local vfx_particle_id = vfx_particle_ids[i]

		World.stop_spawning_particles(world, vfx_particle_id)

		vfx_particle_id = nil
	end
end

return effect_template
