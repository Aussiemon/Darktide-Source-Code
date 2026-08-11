-- chunkname: @scripts/settings/fx/effect_templates/arc_chain_lightning_source/arc_grenade_chain_lightning_source.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local ChainLightning = require("scripts/utilities/action/chain_lightning")
local ChainLightningTarget = require("scripts/utilities/action/chain_lightning_target")
local ChainLightningSourceUtils = require("scripts/settings/fx/effect_templates/arc_chain_lightning_source/arc_chain_lightning_source_utils")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local arc_grenade_talent_settings = TalentSettings.cryptic.arc_grenade
local JUMP_VALIDATION = ChainLightning.jump_validation_functions
local FX_SOURCE_NAME = ChainLightningSourceUtils.FX_SOURCE_NAME
local link_particle_name = "content/fx/particles/abilities/chainlightning/cryptic_arc_chainlightning_attack_looping"
local Quaternion_look = Quaternion.look
local Unit_node = Unit.node
local Unit_world_position = Unit.world_position
local Vector3_direction_length = Vector3.direction_length
local Vector3_flat = Vector3.flat
local Vector3_normalize = Vector3.normalize
local resources = {
	link_particle_name = link_particle_name,
}
local vfx = {
	link_to_source = link_particle_name,
}
local sfx = {}
local chain_settings_spread = {
	extra_angle_stat_buff = "chain_lightning_max_angle",
	jump_time = 0.01,
	jump_time_multiplier_stat_buff = "chain_lightning_jump_time_multiplier",
	max_jumps = 5,
	max_jumps_stat_buff = "chain_lightning_max_jumps",
	max_radius_stat_buff = "chain_lightning_max_radius",
	max_z_diff_stat_buff = "chain_lightning_max_z_diff",
	radius = 12,
	staff = false,
	max_targets = {
		num_targets = 1,
	},
	max_angle = math.degrees_to_radians(135),
}
local jump_target_priority_validation_functions = {
	function (target_unit, breed_or_nil)
		local breed_name = breed_or_nil and breed_or_nil.name or nil

		return breed_name and (breed_name == "chaos_ogryn_executor" or breed_name == "chaos_armored_hound" or breed_name == "renegade_berzerker" or breed_name == "renegade_executor")
	end,
	function (target_unit, breed_or_nil)
		local breed_tags = breed_or_nil and breed_or_nil.tags

		return breed_tags and breed_tags.elite
	end,
	function (target_unit, breed_or_nil)
		return HEALTH_ALIVE[target_unit] and not not breed_or_nil
	end,
}
local arc_chain_damage_settings = {
	damage_profile = DamageProfileTemplates.arc_grenade_chain_jump_damage,
	damage_type = damage_types.arc_chain,
	attack_type = attack_types.arc,
}

local function _on_chain_node_add_func(node, context)
	local target_unit = node:value("unit")
	local start_t = node:value("start_t") or 0

	context.hit_units[target_unit] = true

	if context.is_server then
		local target_buff_extension = ScriptUnit.has_extension(target_unit, "buff_system")

		if target_buff_extension then
			target_buff_extension:add_internally_controlled_buff("arc_grenade_electrocution", start_t, "owner_unit", context.player_unit, "source_item", context.source_item)
			target_buff_extension:add_internally_controlled_buff("arc_grenade_spread_target", start_t, "owner_unit", context.player_unit, "source_item", context.source_item)

			if context.apply_brittleness then
				target_buff_extension:add_internally_controlled_buff_with_stacks("rending_debuff", arc_grenade_talent_settings.rending_stacks_on_minions_hit_by_arc, start_t, "owner_unit", context.player_unit, "source_item", context.source_item)
			end
		end
	end
end

local function _on_chain_node_remove_func(node, context)
	local target_unit = node:value("unit")

	context.hit_units[target_unit] = nil
end

local SOURCE_TARGET_KEY = ChainLightningSourceUtils.SOURCE_TARGET_KEY

local function _init_chain(chain_lightning_data, template_context, is_server, player_unit, chain_settings, chain_damage_settings)
	chain_lightning_data.chain_settings = chain_settings
	chain_lightning_data.chain_damage_settings = chain_damage_settings
	chain_lightning_data.is_server = template_context.is_server
	chain_lightning_data.physics_world = template_context.physics_world
	chain_lightning_data.player = Managers.state.player_unit_spawn:owner(player_unit)
	chain_lightning_data.player_unit = player_unit
	chain_lightning_data.chain_lightning_jump_function_name = "targeted_jump"
	chain_lightning_data.jump_target_priority_validation_functions_or_nil = jump_target_priority_validation_functions
	chain_lightning_data.chain_jump_validation_function_or_nil = JUMP_VALIDATION.target_alive
	chain_lightning_data.on_chain_node_add_func = _on_chain_node_add_func
	chain_lightning_data.on_chain_node_remove_func = _on_chain_node_remove_func
	chain_lightning_data.visual_chain_jump_validation_function_or_nil = JUMP_VALIDATION.target_alive_and_arc_grenade_electrocuted
	chain_lightning_data.has_found_visual_chain_root_target = false
	chain_lightning_data.link_particle_ids = {}
	chain_lightning_data.chain_lightning_hit_units = {}
	chain_lightning_data.chain_lightning_temp_targets = {}

	chain_lightning_data.chain_jump_on_add_func = function (node, func_context)
		_on_chain_node_add_func(node, func_context)
	end

	local buff_extension = ScriptUnit.has_extension(player_unit, "buff_system")
	local talent_extension = ScriptUnit.has_extension(player_unit, "talent_system")

	chain_lightning_data.func_context = {
		buff_extension = buff_extension,
		hit_units = chain_lightning_data.chain_lightning_hit_units,
		player_unit = player_unit,
		is_server = is_server,
		apply_brittleness = talent_extension:has_special_rule("cryptic_arc_grenade_gives_brittleness"),
	}

	local depth, use_random = 0, false
	local chain_root_node = ChainLightningTarget:new(chain_settings, depth, use_random, nil, "unit", player_unit)

	chain_root_node:set_max_num_children(1)
	chain_root_node:set_value(SOURCE_TARGET_KEY, false)

	chain_lightning_data.chain_root_node = chain_root_node
end

local effect_template = {
	name = "arc_grenade_chain_lightning_source",
	resources = resources,
	start = function (template_data, template_context)
		local t = Managers.time:time("gameplay")
		local is_server = template_context.is_server
		local world = template_context.world
		local unit = template_data.unit
		local particle_group = template_data.particle_group
		local player_owner_unit = template_data.player_owner_unit
		local node_index = Unit.node(unit, FX_SOURCE_NAME)
		local unit_position = Unit.world_position(unit, node_index)
		local attack_origin_pos = template_data.position

		if not attack_origin_pos then
			return
		end

		local attack_direction = Vector3.normalize(attack_origin_pos - unit_position)

		template_data.chain_direction = Vector3Box(attack_direction)
		template_data.attack_origin_pos = Vector3Box(attack_origin_pos)

		local chain_lightning_data = {}

		_init_chain(chain_lightning_data, template_context, is_server, player_owner_unit, chain_settings_spread, arc_chain_damage_settings)
		ChainLightningSourceUtils.start_chain_from_unit(chain_lightning_data, is_server, player_owner_unit, unit, attack_origin_pos, attack_direction, chain_settings_spread, t)

		template_data.chain_lightning_data = chain_lightning_data
		template_data.effect_lifetime_end_t = t + 1
	end,
	update = function (template_data, template_context, dt, t)
		local world = template_context.world
		local chain_lightning_data = template_data.chain_lightning_data
		local chain_root_target = chain_lightning_data[SOURCE_TARGET_KEY]
		local attack_origin_pos, root_target_unit_position = ChainLightningSourceUtils.get_positions(chain_root_target, template_data)

		if template_context.is_server and not attack_origin_pos or not HEALTH_ALIVE[chain_root_target] or t >= template_data.effect_lifetime_end_t then
			return true
		end

		if DEDICATED_SERVER then
			return false
		end

		local has_found_visual_chain_root_target = chain_lightning_data.has_found_visual_chain_root_target

		if not has_found_visual_chain_root_target then
			local buff_extension = ScriptUnit.has_extension(chain_root_target, "buff_system")

			if buff_extension and HEALTH_ALIVE[chain_root_target] and buff_extension:has_keyword("electrocuted_arc_grenade") then
				chain_lightning_data.has_found_visual_chain_root_target = true

				if not template_context.is_server then
					ChainLightningSourceUtils.add_root_target(chain_lightning_data, t, chain_root_target)
					ChainLightningSourceUtils.find_new_targets(chain_lightning_data, attack_origin_pos, template_data.chain_direction:unbox(), "jump", chain_lightning_data.visual_chain_jump_validation_function_or_nil, nil, t)
				end

				ChainLightningSourceUtils.spawn_linking_effects(chain_lightning_data, vfx, template_data, template_context, t)
			end
		end

		return false
	end,
	stop = function (template_data, template_context)
		local world = template_context.world
		local chain_lightning_data = template_data.chain_lightning_data
		local link_particle_ids = chain_lightning_data.link_particle_ids

		for _, link_particle_id in pairs(link_particle_ids) do
			if World.are_particles_playing(world, link_particle_id) then
				World.destroy_particles(world, link_particle_id)
			end
		end

		ChainLightningSourceUtils.reset_chain_lightning(template_data.chain_lightning_data, template_data, template_context)
	end,
}

return effect_template
