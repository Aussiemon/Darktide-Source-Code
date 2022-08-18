local Ailment = require("scripts/utilities/ailment")
local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local HitZone = require("scripts/utilities/attack/hit_zone")
local PortableRandom = require("scripts/foundation/utilities/portable_random")
local VisualLoadoutCustomization = require("scripts/extension_systems/visual_loadout/utilities/visual_loadout_customization")
local WoundMaterials = require("scripts/extension_systems/wounds/utilities/wound_materials")
local hit_zone_names = HitZone.hit_zone_names
local HIT_ZONE_FLOW_EVENT_NAME_LOOKUP = {}

for hit_zone_name, _ in pairs(hit_zone_names) do
	HIT_ZONE_FLOW_EVENT_NAME_LOOKUP[hit_zone_name] = string.format("gib_%s", hit_zone_name)
end

local GibbingPower = GibbingSettings.gibbing_power
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local GibbingTypes = GibbingSettings.gibbing_types
local GibPushForceMultipliers = GibbingSettings.gib_push_force_multipliers
local _apply_ailment_material_effect, _apply_material_overrides, _apply_push_forces, _create_inverse_root_node_bind_pose_lookup, _destroy_ragdoll_actors, _disable_hit_zone_actors, _get_gib_unit_overrides, _get_gibbing_template, _parse_gib_template_entry, _play_root_sound, _scale_node, _spawn_gib, _spawn_stump = nil
local INVERSE_ROOT_NODE_BIND_POSE_LOOKUP_BY_BREED_NAME = {}
local MinionGibbing = class("MinionGibbing")

MinionGibbing.init = function (self, unit, breed, world, wwise_world, gib_template, visual_loadout_extension, random_seed, optional_gib_overrides, optional_wounds_extension)
	self._gibs = {}
	self._flesh_gibs = {}
	self._prevented_gibs = {}
	self._inventory_slots_on_gibs = {}
	self._disallowed_hit_zones = {}
	self._world = world
	self._wwise_world = wwise_world
	self._unit = unit
	self._visual_loadout_extension = visual_loadout_extension
	self._gib_overrides = optional_gib_overrides
	self._template = gib_template
	self._portable_random = PortableRandom:new(random_seed)
	self._breed = breed

	if optional_wounds_extension then
		self._wounds_data = optional_wounds_extension:wounds_data()
		local breed_name = breed.name
		local inverse_root_node_bind_pose_lookup = INVERSE_ROOT_NODE_BIND_POSE_LOOKUP_BY_BREED_NAME[breed_name]

		if inverse_root_node_bind_pose_lookup == nil then
			inverse_root_node_bind_pose_lookup = _create_inverse_root_node_bind_pose_lookup(unit, gib_template)
			INVERSE_ROOT_NODE_BIND_POSE_LOOKUP_BY_BREED_NAME[breed_name] = inverse_root_node_bind_pose_lookup
		end

		self._inverse_root_node_bind_pose_lookup = inverse_root_node_bind_pose_lookup
	end
end

local TEMP_GIB_NODE_NAMES = {}

function _parse_gib_template_entry(entry)
	local gib_settings = entry.gib_settings

	if gib_settings then
		local gib_spawn_node_name = gib_settings.gib_spawn_node
		TEMP_GIB_NODE_NAMES[gib_spawn_node_name] = true
	end

	local stump_settings = entry.stump_settings

	if stump_settings then
		local stump_attach_node_name = stump_settings.stump_attach_node
		TEMP_GIB_NODE_NAMES[stump_attach_node_name] = true
	end
end

function _create_inverse_root_node_bind_pose_lookup(unit, gib_template)
	for hit_zone_name, data in pairs(gib_template) do
		if hit_zone_name ~= "name" then
			for gibbing_type, entry in pairs(data) do
				local conditional_entries = entry.conditional

				if conditional_entries then
					for i = 1, #conditional_entries, 1 do
						local entry_to_parse = conditional_entries[i]

						_parse_gib_template_entry(entry_to_parse)
					end
				elseif entry[1] ~= nil then
					for i = 1, #entry, 1 do
						local entry_to_parse = entry[i]

						_parse_gib_template_entry(entry_to_parse)
					end
				else
					_parse_gib_template_entry(entry)
				end
			end
		end
	end

	local root_world_bind_pose = Unit.world_pose(unit, 1)
	local inverse_root_node_bind_pose_lookup = {}

	for node_name, _ in pairs(TEMP_GIB_NODE_NAMES) do
		local node_index = Unit.node(unit, node_name)
		local node_world_bind_pose = Unit.world_pose(unit, node_index)
		local inv_node_world_bind_pose = Matrix4x4.inverse(node_world_bind_pose)
		local inv_root_node_bind_pose = Matrix4x4.multiply(root_world_bind_pose, inv_node_world_bind_pose)
		inverse_root_node_bind_pose_lookup[node_index] = Matrix4x4Box(inv_root_node_bind_pose)
	end

	table.clear(TEMP_GIB_NODE_NAMES)

	return inverse_root_node_bind_pose_lookup
end

MinionGibbing.update = function (self, breed_name, soft_cap_out_of_bounds_units)
	local unit_spawner_manager = Managers.state.unit_spawner
	local visual_loadout_extension = self._visual_loadout_extension
	local inventory_slots_on_gibs = self._inventory_slots_on_gibs
	local gibs = self._gibs
	local flesh_gibs = self._flesh_gibs

	for hit_zone_name, gib_units in pairs(gibs) do
		for i = #gib_units, 1, -1 do
			local gib_unit = gib_units[i]

			if soft_cap_out_of_bounds_units[gib_unit] then
				Log.info("MinionGibbing", "%s's %s is out-of-bounds, despawning (%s).", breed_name, gib_unit, tostring(Unit.world_position(gib_unit, 1)))

				local slots_attached_to_gib = inventory_slots_on_gibs[hit_zone_name]

				if slots_attached_to_gib then
					for j = 1, #slots_attached_to_gib, 1 do
						local slot = slots_attached_to_gib[j]

						if visual_loadout_extension:can_unequip_slot(slot) then
							visual_loadout_extension:_unequip_slot(slot)
						end
					end

					table.clear(slots_attached_to_gib)
				end

				local gib_flesh_unit = flesh_gibs[gib_unit]

				if gib_flesh_unit then
					unit_spawner_manager:mark_for_deletion(gib_flesh_unit)

					flesh_gibs[gib_unit] = nil
				end

				unit_spawner_manager:mark_for_deletion(gib_unit)
				table.swap_delete(gib_units, i)
			end
		end
	end
end

MinionGibbing.gib = function (self, hit_zone_name_or_nil, attack_direction, damage_profile, override_gib_type, optional_override_gib_forces, optional_is_critical_strike)
	if hit_zone_name_or_nil and self._disallowed_hit_zones[hit_zone_name_or_nil] then
		return false
	end

	local gibbing_power = damage_profile.gibbing_power or GibbingPower.light
	local gibbing_type = override_gib_type or damage_profile.gibbing_type or GibbingTypes.default

	if optional_is_critical_strike then
		local critical_strike_settings = damage_profile.critical_strike

		if critical_strike_settings then
			gibbing_power = critical_strike_settings.gibbing_power or gibbing_power
		end

		if critical_strike_settings then
			gibbing_type = critical_strike_settings.gibbing_type or gibbing_type
		end
	end

	local gibs = self._gibs
	local hit_zone_gib_template = _get_gibbing_template(self._template, gibs, hit_zone_name_or_nil, gibbing_type, self._portable_random, self._gib_overrides)

	if not hit_zone_gib_template then
		return false
	end

	local gibbing_threshold = hit_zone_gib_template.gibbing_threshold or GibbingThresholds.light

	if gibbing_power < gibbing_threshold then
		return false
	end

	local hit_zone_name = hit_zone_gib_template.override_hit_zone_name or hit_zone_name_or_nil
	local prevented_gibs = self._prevented_gibs

	if gibs[hit_zone_name] or prevented_gibs[hit_zone_name] then
		return false
	end

	local minion_unit = self._unit
	local flow_event_name = HIT_ZONE_FLOW_EVENT_NAME_LOOKUP[hit_zone_name]

	Unit.flow_event(minion_unit, flow_event_name)

	local visual_loadout_extension = self._visual_loadout_extension
	local hit_zone_gibs = {}
	local ailment_effect = visual_loadout_extension:ailment_effect()
	local world = self._world
	local wwise_world = self._wwise_world
	local wounds_data = self._wounds_data
	local inverse_root_node_bind_pose_lookup = self._inverse_root_node_bind_pose_lookup
	local stump_settings = hit_zone_gib_template.stump_settings

	if stump_settings then
		local stump_unit, stump_attach_node = _spawn_stump(minion_unit, stump_settings, world)
		hit_zone_gibs[#hit_zone_gibs + 1] = stump_unit

		_play_gib_fx(stump_unit, stump_settings, world, wwise_world)

		local slot_material_override_names = hit_zone_gib_template.material_overrides

		if slot_material_override_names then
			for i = 1, #slot_material_override_names, 1 do
				local slot_material_override_name = slot_material_override_names[i]

				_apply_material_overrides(stump_unit, visual_loadout_extension, slot_material_override_name)
			end
		end

		if ailment_effect then
			_apply_ailment_material_effect(stump_unit, ailment_effect)
		end

		if wounds_data then
			local inverse_root_node_bind_pose = inverse_root_node_bind_pose_lookup[stump_attach_node]:unbox()

			WoundMaterials.apply(stump_unit, wounds_data, nil, nil, inverse_root_node_bind_pose)
		end
	end

	_play_root_sound(minion_unit, hit_zone_gib_template, wwise_world)

	local gib_settings = hit_zone_gib_template.gib_settings

	if gib_settings then
		local gib_unit, gib_node, gib_flesh_unit = _spawn_gib(minion_unit, gib_settings, world)
		hit_zone_gibs[#hit_zone_gibs + 1] = gib_unit

		if gib_flesh_unit then
			self._flesh_gibs[gib_unit] = gib_flesh_unit
		end

		_play_gib_fx(gib_unit, gib_settings, world, wwise_world)

		if not damage_profile.ignore_gib_push and gib_settings.gib_actor then
			local optional_override_push_force = gib_settings.override_push_force
			local gib_actor = Unit.actor(gib_unit, gib_settings.gib_actor)

			_apply_push_forces(gib_actor, attack_direction, damage_profile, hit_zone_name, optional_override_gib_forces, optional_override_push_force)
		end

		local slot_material_override_names = hit_zone_gib_template.material_overrides

		if slot_material_override_names then
			for i = 1, #slot_material_override_names, 1 do
				local slot_material_override_name = slot_material_override_names[i]

				_apply_material_overrides(gib_unit, visual_loadout_extension, slot_material_override_name)
			end
		end

		if ailment_effect then
			_apply_ailment_material_effect(gib_unit, ailment_effect)
		end

		if wounds_data then
			local inverse_root_node_bind_pose = inverse_root_node_bind_pose_lookup[gib_node]:unbox()

			WoundMaterials.apply(gib_unit, wounds_data, nil, nil, inverse_root_node_bind_pose)
		end

		local attach_inventory_slots_to_gib = gib_settings.attach_inventory_slots_to_gib

		if attach_inventory_slots_to_gib then
			for i = 1, #attach_inventory_slots_to_gib, 1 do
				local slot_name = attach_inventory_slots_to_gib[i]

				if visual_loadout_extension:can_unequip_slot(slot_name) then
					visual_loadout_extension:_attach_slot_to_gib(slot_name, gib_unit)
				end
			end

			self._inventory_slots_on_gibs[hit_zone_name] = attach_inventory_slots_to_gib
		end
	end

	local unequip_inventory_slot = hit_zone_gib_template.unequip_inventory_slot

	if unequip_inventory_slot and visual_loadout_extension:can_unequip_slot(unequip_inventory_slot) then
		visual_loadout_extension:_unequip_slot(unequip_inventory_slot)
	end

	gibs[hit_zone_name] = hit_zone_gibs
	local extra_hit_zone_gibs = hit_zone_gib_template.extra_hit_zone_gibs

	if extra_hit_zone_gibs then
		for i = 1, #extra_hit_zone_gibs, 1 do
			local extra_hit_zone = extra_hit_zone_gibs[i]
			local extra_hit_zone_gib_push_forces = hit_zone_gib_template.extra_hit_zone_gib_push_forces

			self:gib(extra_hit_zone, attack_direction, damage_profile, GibbingTypes.default, extra_hit_zone_gib_push_forces)
		end
	end

	local prevents_other_gibs = hit_zone_gib_template.prevents_other_gibs

	if prevents_other_gibs then
		for _, gib_to_prevent in pairs(prevents_other_gibs) do
			prevented_gibs[gib_to_prevent] = true
		end
	end

	_scale_node(minion_unit, hit_zone_gib_template)
	_destroy_ragdoll_actors(minion_unit, self._breed, hit_zone_name)
	_disable_hit_zone_actors(minion_unit, self._breed, hit_zone_name, hit_zone_gib_template)

	return true
end

MinionGibbing.delete_gibs = function (self)
	local unit_spawner_manager = Managers.state.unit_spawner
	local flesh_gibs = self._flesh_gibs

	for _, gib_flesh_unit in pairs(flesh_gibs) do
		unit_spawner_manager:mark_for_deletion(gib_flesh_unit)
	end

	table.clear(flesh_gibs)

	local gibs = self._gibs

	for hit_zone_name, gib_units in pairs(gibs) do
		for i = 1, #gib_units, 1 do
			local gib_unit = gib_units[i]

			unit_spawner_manager:mark_for_deletion(gib_unit)
		end
	end

	table.clear(gibs)
end

MinionGibbing.allow_gib_for_hit_zone = function (self, hit_zone, allowed)
	self._disallowed_hit_zones[hit_zone] = not allowed
end

function _get_gibbing_template(gib_template, gibs, hit_zone_name, gibbing_type, portable_random, optional_gib_overrides)
	local hit_zone_gib_template = (gib_template[hit_zone_name] and (gib_template[hit_zone_name][gibbing_type] or gib_template[hit_zone_name].default)) or (gib_template.fallback_hit_zone and (gib_template.fallback_hit_zone[gibbing_type] or gib_template.fallback_hit_zone.default))

	if not hit_zone_gib_template then
		return false
	end

	if optional_gib_overrides then
		hit_zone_gib_template = _get_gib_unit_overrides(hit_zone_gib_template, hit_zone_name, gibbing_type, optional_gib_overrides)
	end

	local conditional_gibbing = hit_zone_gib_template.conditional

	if conditional_gibbing then
		for i = 1, #conditional_gibbing, 1 do
			local template = conditional_gibbing[i]
			local condition = template.condition
			local already_gibbed_condition = condition.already_gibbed
			local conditional_template = nil

			if already_gibbed_condition then
				if gibs[already_gibbed_condition] ~= nil then
					conditional_template = template
				end
			elseif condition.always_true then
				conditional_template = template
			end

			if conditional_template then
				return conditional_template
			end
		end
	end

	local num_entries = #hit_zone_gib_template

	if num_entries > 0 then
		local index = portable_random:random_range(1, num_entries)
		hit_zone_gib_template = hit_zone_gib_template[index]
	end

	return hit_zone_gib_template
end

function _get_gib_unit_overrides(hit_zone_gib_template, hit_zone_name, gibbing_type, gib_overrides)
	local hit_zone_gib_overrides = (gib_overrides[hit_zone_name] and (gib_overrides[hit_zone_name][gibbing_type] or gib_overrides[hit_zone_name].default)) or (gib_overrides.fallback_hit_zone and (gib_overrides.fallback_hit_zone[gibbing_type] or gib_overrides.fallback_hit_zone.default))

	if hit_zone_gib_overrides then
		hit_zone_gib_template = table.clone(hit_zone_gib_template)

		if hit_zone_gib_template.gib_settings and hit_zone_gib_overrides.override_gib_unit then
			hit_zone_gib_template.gib_settings.gib_unit = hit_zone_gib_overrides.override_gib_unit
		end

		if hit_zone_gib_template.stump_settings and hit_zone_gib_overrides.override_stump_unit then
			hit_zone_gib_template.stump_settings.stump_unit = hit_zone_gib_overrides.override_stump_unit
		end

		local conditional_gibbing = hit_zone_gib_template.conditional
		local conditional_overrides = hit_zone_gib_overrides.conditional

		if conditional_gibbing and conditional_overrides then
			for i = 1, #conditional_gibbing, 1 do
				if conditional_gibbing[i].gib_settings and conditional_overrides[i].override_gib_unit then
					conditional_gibbing[i].gib_settings.gib_unit = conditional_overrides[i].override_gib_unit
				end

				if conditional_gibbing[i].stump_settings and conditional_overrides[i].override_stump_unit then
					conditional_gibbing[i].stump_settings.stump_unit = conditional_overrides[i].override_stump_unit
				end
			end
		end
	end

	return hit_zone_gib_template
end

function _spawn_stump(minion_unit, stump_settings, world)
	local stump_unit_name = stump_settings.stump_unit
	local stump_attach_node_name = stump_settings.stump_attach_node
	local stump_attach_node = Unit.node(minion_unit, stump_attach_node_name)
	local stump_pose = Unit.world_pose(minion_unit, stump_attach_node)
	local stump_unit = Managers.state.unit_spawner:spawn_unit(stump_unit_name, stump_pose)
	local map_nodes = true

	World.link_unit(world, stump_unit, 1, minion_unit, stump_attach_node, map_nodes)

	return stump_unit, stump_attach_node
end

function _spawn_gib(minion_unit, gib_settings, world)
	local gib_unit_name = gib_settings.gib_unit
	local gib_spawn_node_name = gib_settings.gib_spawn_node
	local gib_node = Unit.node(minion_unit, gib_spawn_node_name)
	local gib_position = Unit.world_position(minion_unit, gib_node)
	local gib_rotation = Unit.world_rotation(minion_unit, gib_node)
	local gib_unit = Managers.state.unit_spawner:spawn_unit(gib_unit_name, gib_position, gib_rotation)
	local gib_flesh_unit = nil
	local gib_flesh_unit_name = gib_settings.gib_flesh_unit

	if gib_flesh_unit_name then
		gib_flesh_unit = Managers.state.unit_spawner:spawn_unit(gib_flesh_unit_name, gib_position, gib_rotation)

		World.link_unit(world, gib_flesh_unit, 1, gib_unit, 1, true, false)

		local gib_lod_group = Unit.has_lod_group(gib_unit, "lod") and Unit.lod_group(gib_unit, "lod")

		if gib_lod_group and Unit.has_lod_object(gib_flesh_unit, "lod") then
			local gib_flesh_lod_object = Unit.lod_object(gib_flesh_unit, "lod")

			LODGroup.add_lod_object(gib_lod_group, gib_flesh_lod_object)

			local bv_mesh = Unit.mesh(gib_unit, "b_culling_volume")
			local bv = Mesh.bounding_volume(bv_mesh)

			LODGroup.override_bounding_volume(gib_lod_group, bv)
		end
	end

	return gib_unit, gib_node, gib_flesh_unit
end

function _scale_node(unit, hit_zone_gib_template)
	local scale_node_name = hit_zone_gib_template.scale_node

	if scale_node_name then
		if type(scale_node_name) == "table" then
			for i = 1, #scale_node_name, 1 do
				local scale_node = Unit.node(unit, scale_node_name[i])

				Unit.set_local_scale(unit, scale_node, Vector3(0.01, 0.01, 0.01))
			end
		else
			local scale_node = Unit.node(unit, scale_node_name)

			Unit.set_local_scale(unit, scale_node, Vector3(0.01, 0.01, 0.01))
		end
	end
end

function _apply_material_overrides(unit, visual_loadout_extension, slot_material_override_name)
	local apply_to_parent, material_overrides = visual_loadout_extension:slot_material_override(slot_material_override_name)

	if material_overrides then
		for _, material_override in pairs(material_overrides) do
			VisualLoadoutCustomization.apply_material_override(unit, unit, apply_to_parent, material_override, false)
		end
	end
end

local DEFAULT_PUSH_FORCE = 15
local MAX_FORCE_PER_MASS_UNIT = 50

function _apply_push_forces(gib_actor, attack_direction, damage_profile, hit_zone_name, optional_override_gib_forces, optional_override_force)
	local push_force = DEFAULT_PUSH_FORCE

	if damage_profile.ragdoll_push_force then
		push_force = damage_profile.ragdoll_push_force

		if type(push_force) == "table" then
			push_force = math.random_range(push_force[1], push_force[2])
		end
	end

	local gib_force_multiplier = (optional_override_gib_forces and optional_override_gib_forces[hit_zone_name]) or optional_override_force or GibPushForceMultipliers[hit_zone_name]

	if type(gib_force_multiplier) == "table" then
		gib_force_multiplier = math.random_range(gib_force_multiplier[1], gib_force_multiplier[2])
	end

	local mass = math.max(Actor.mass(gib_actor), 0.05)
	local max_force = MAX_FORCE_PER_MASS_UNIT * mass
	local final_force = math.min(push_force / mass * gib_force_multiplier, max_force)
	local final_force_vector = attack_direction * final_force

	Actor.add_impulse(gib_actor, final_force_vector)

	local left = -Vector3.cross(attack_direction, Vector3.up())

	Actor.add_torque_impulse(gib_actor, left * 0.5)
end

function _disable_hit_zone_actors(unit, breed, hit_zone_name, hit_zone_gib_template)
	local actor_names = HitZone.get_actor_names(unit, hit_zone_name)

	for i = 1, #actor_names, 1 do
		local actor_name = actor_names[i]
		local actor = Unit.actor(unit, actor_name)

		Actor.set_collision_enabled(actor, false)
		Actor.set_scene_query_enabled(actor, false)
	end

	local extra_hit_zone_actors_to_destroy = hit_zone_gib_template.extra_hit_zone_actors_to_destroy

	if extra_hit_zone_actors_to_destroy then
		for i = 1, #extra_hit_zone_actors_to_destroy, 1 do
			local extra_hit_zone_name = extra_hit_zone_actors_to_destroy[i]
			local extra_actor_names = HitZone.get_actor_names(unit, extra_hit_zone_name)

			for j = 1, #extra_actor_names, 1 do
				local extra_actor_name = extra_actor_names[j]
				local actor = Unit.actor(unit, extra_actor_name)

				Actor.set_collision_enabled(actor, false)
				Actor.set_scene_query_enabled(actor, false)
			end

			_destroy_ragdoll_actors(unit, breed, extra_hit_zone_name)
		end
	end
end

function _destroy_ragdoll_actors(unit, breed, hit_zone_name)
	local hit_zone_ragdoll_actors = breed.hit_zone_ragdoll_actors

	if not hit_zone_ragdoll_actors then
		return
	end

	local ragdoll_actor_names = hit_zone_ragdoll_actors[hit_zone_name]

	if ragdoll_actor_names then
		for i = 1, #ragdoll_actor_names, 1 do
			local actor_name = ragdoll_actor_names[i]
			local actor = Unit.actor(unit, actor_name)

			if actor ~= nil then
				Unit.destroy_actor(unit, actor_name)
			end
		end
	end
end

function _play_gib_fx(gib_unit, settings, world, wwise_world)
	local vfx = settings.vfx

	if vfx then
		local particle_effect = vfx.particle_effect

		if type(particle_effect) == "table" then
			local index = math.random(1, #particle_effect)
			particle_effect = particle_effect[index]
		end

		local node = (vfx.node_name and Unit.node(gib_unit, vfx.node_name)) or 1
		local world_pose = Unit.world_pose(gib_unit, node)
		local position = Matrix4x4.translation(world_pose)
		local rotation = Matrix4x4.rotation(world_pose)
		local effect_id = World.create_particles(world, particle_effect, position, rotation)

		if vfx.linked then
			local orphaned_policy = vfx.orphaned_policy or "destroy"
			local pose = Matrix4x4.identity()

			World.link_particles(world, effect_id, gib_unit, node, pose, orphaned_policy)
		end
	end

	local sfx = settings.sfx

	if sfx then
		local source = nil

		if sfx.node_name then
			local node = Unit.node(gib_unit, sfx.node_name)
			source = WwiseWorld.make_auto_source(wwise_world, gib_unit, node)
		else
			source = WwiseWorld.make_auto_source(wwise_world, gib_unit)
		end

		local sound_event = sfx.sound_event

		WwiseWorld.trigger_resource_event(wwise_world, sound_event, source)
	end
end

function _play_root_sound(root_unit, hit_zone_gib_template, wwise_world)
	local root_sound_event = hit_zone_gib_template.root_sound_event

	if root_sound_event then
		local source = WwiseWorld.make_auto_source(wwise_world, root_unit)

		WwiseWorld.trigger_resource_event(wwise_world, root_sound_event, source)
	end
end

function _apply_ailment_material_effect(gib_unit, ailment_effect)
	local include_children = true
	local custom_duration = 0
	local custom_offset_time = 0

	Ailment.play_ailment_effect_template(gib_unit, ailment_effect, include_children, custom_duration, custom_offset_time)
end

return MinionGibbing
