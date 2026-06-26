-- chunkname: @scripts/extension_systems/shield/minion_shield_extension.lua

local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local HitZone = require("scripts/utilities/attack/hit_zone")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Stagger = require("scripts/utilities/attack/stagger")
local attack_results = AttackSettings.attack_results
local stagger_types = StaggerSettings.stagger_types
local MinionShieldExtension = class("MinionShieldExtension")
local IS_BLOCKING_INITIALLY = true
local IS_ALIVE_INITALLY = true

MinionShieldExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local breed = extension_init_data.breed
	local shield_template = breed.shield_template
	local blackboard = BLACKBOARDS[unit]

	self:_init_blackboard_components(blackboard)

	game_object_data.is_blocking = IS_BLOCKING_INITIALLY
	self._blackboard = blackboard
	self._unit = unit
	self._template = shield_template
	self._regen_hit_strength_rate = shield_template.regen_hit_strength_rate
	self._hit_strength = 0
	self._damage_index = 0

	self:_initialize_health(shield_template)

	game_object_data.shield_max_health = self._health
	self._game_object_data = game_object_data
	self._inital_health = self._health
	self._is_invulnerable = shield_template.is_invulnerable

	if self._template.visability_groups then
		self._visability_groups = table.create_copy({}, self._template.visability_groups)
	end

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local shield_item = visual_loadout_extension:slot_item(shield_template.open_up_vfx_slot_name)

	self._shield_item = shield_item
end

MinionShieldExtension._initialize_health = function (self, template)
	local max_health = 0

	if template.health then
		max_health = Managers.state.difficulty:get_table_entry_by_challenge(template.health)
	end

	self._health = max_health
end

MinionShieldExtension._init_blackboard_components = function (self, blackboard)
	local shield_write_component = Blackboard.write_component(blackboard, "shield")

	shield_write_component.is_blocking = IS_BLOCKING_INITIALLY
	shield_write_component.is_alive = IS_ALIVE_INITALLY
	self._shield_component = shield_write_component
	self._stagger_component = blackboard.stagger
end

MinionShieldExtension.game_object_initialized = function (self, session, object_id)
	self._game_session, self._game_object_id = session, object_id
end

MinionShieldExtension.template = function (self)
	return self._template
end

MinionShieldExtension.current_health = function (self)
	return self._health
end

MinionShieldExtension.update = function (self, context, dt, t)
	local is_staggered = self._stagger_component.num_triggered_staggers > 0

	if not is_staggered then
		local regen_hit_strength_rate = self._regen_hit_strength_rate

		self._hit_strength = math.max(self._hit_strength - regen_hit_strength_rate * dt, 0)
	end
end

MinionShieldExtension.set_blocking = function (self, is_blocking)
	self._shield_component.is_blocking = is_blocking

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "is_blocking", is_blocking)
end

MinionShieldExtension.is_blocking = function (self)
	local shield_component = self._shield_component

	return shield_component.is_blocking
end

MinionShieldExtension.can_block_attack = function (self, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_actor)
	if damage_profile.ignore_shield or not attacking_unit then
		return false
	end

	local attacking_owner_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")

	if attacking_owner_unit_data_extension == nil then
		return false
	end

	local unit, attacking_owner_breed = self._unit, attacking_owner_unit_data_extension:breed()
	local side_system = Managers.state.extension:system("side_system")

	if Breed.is_minion(attacking_owner_breed) and side_system:is_ally(unit, attacking_unit_owner_unit) then
		return true
	end

	local hit_zone = hit_actor and HitZone.get(unit, hit_actor)
	local hit_zone_name = hit_zone and hit_zone.name
	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local can_block_from_position = self:can_block_from_position(attacking_unit_position, hit_zone_name)

	if can_block_from_position then
		if self._is_invulnerable then
			return "block_all"
		else
			return "absorb_all"
		end
	end
end

MinionShieldExtension.can_block_from_position = function (self, attacking_unit_position, hit_zone_name)
	local is_blocking = self._shield_component.is_blocking

	if not is_blocking then
		return false
	end

	if hit_zone_name and hit_zone_name == "shield" then
		return true
	end

	return false
end

MinionShieldExtension.add_damage = function (self, damage_amount, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	if self._is_invulnerable then
		return
	end

	if self._health == 0 then
		return
	end

	self._health = math.clamp(self._health - damage_amount, 0, self._inital_health)

	GameSession.set_game_object_field(self._game_session, self._game_object_id, "shield_health", self._health)

	if self._health <= 0 then
		self:_change_visability_group()
		self:_set_destroyed(attack_direction)
	else
		self:_change_visability_group()

		return damage_amount, true
	end
end

MinionShieldExtension.destroy = function (self)
	local unit = self._unit
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local can_drop = visual_loadout_extension:can_drop_slot("slot_shield")

	if can_drop then
		visual_loadout_extension:drop_slot("slot_shield")
	end
end

MinionShieldExtension._change_visability_group = function (self)
	local visability_groups = self._visability_groups

	if not visability_groups then
		return
	end

	local health_percentage = self._health / self._inital_health * 100
	local target_state = 0

	for i = #visability_groups, 1, -1 do
		local data = visability_groups[i]

		if health_percentage <= data.amount then
			target_state = i

			break
		end
	end

	if target_state > 0 then
		local unit = self._unit
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		visual_loadout_extension:update_unit_mesh_states("slot_shield", target_state)
	end
end

MinionShieldExtension._set_destroyed = function (self, attack_direction)
	self:_set_linked_actor_active("c_shield", false)
	self:set_blocking(false)

	local unit = self._unit
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local can_drop = visual_loadout_extension:can_drop_slot("slot_shield")

	if can_drop then
		visual_loadout_extension:drop_slot("slot_shield")
	end

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event("to_melee")

	local template = self._template
	local destroyed_settings = template.destroyed_settings
	local stagger_type = destroyed_settings.stagger_type

	Stagger.force_stagger(unit, stagger_type, attack_direction, 1, 1, 1)

	local sfx_event = destroyed_settings.sfx_event

	if sfx_event then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_local_unit_wwise_event(sfx_event, unit)
	end
end

MinionShieldExtension._set_linked_actor_active = function (self, linked_actor_name, active)
	local unit = self._unit
	local actor_id = Unit.find_actor(unit, linked_actor_name)
	local actor = Unit.actor(unit, actor_id)

	Actor.set_collision_enabled(actor, active)
	Actor.set_scene_query_enabled(actor, active)
end

MinionShieldExtension._check_for_ignore_override = function (self, stagger_type)
	local always_override_stagger_type = self._template.always_override_stagger_type

	if always_override_stagger_type and self:current_health() > 0 then
		stagger_type = always_override_stagger_type
	end

	local duration_scale, length_scale = 1, 1

	return stagger_type, duration_scale, length_scale
end

local DEFAULT_MULTIPLIER = 1
local IGNORED_DAMAGE_KEYWORDS = {
	arc_chain = true,
	bleeding = true,
	burning = true,
	toxin = true,
	warpfire = true,
}

MinionShieldExtension.apply_stagger = function (self, unit, damage_profile, stagger_strength, attack_result, stagger_type, duration_scale, length_scale, attack_type, damage_type)
	if damage_type and IGNORED_DAMAGE_KEYWORDS[damage_type] then
		stagger_type, duration_scale, length_scale = nil, 0, 0

		return stagger_type, duration_scale, length_scale
	end

	local is_blocking = self._shield_component.is_blocking

	if not is_blocking or damage_profile.ignore_shield then
		local stagger_component = self._stagger_component
		local in_open_up_stagger = stagger_component.num_triggered_staggers > 0 and stagger_component.type == stagger_types.shield_heavy_block

		if in_open_up_stagger then
			stagger_type, duration_scale, length_scale = stagger_types.shield_broken, 1, 1
			self._hit_strength = 0
		end

		stagger_type, duration_scale, length_scale = self:_check_for_ignore_override(stagger_type)

		return stagger_type, duration_scale, length_scale
	end

	local override_multiplier = damage_profile.shield_multiplier or DEFAULT_MULTIPLIER

	stagger_strength = override_multiplier * (stagger_strength or 0)

	local template = self._template
	local default_min_stagger_strength = template.attack_type_min_stagger_strength and template.attack_type_min_stagger_strength[attack_type] or 0

	stagger_strength = math.max(stagger_strength, default_min_stagger_strength)

	local override_stagger_strength = damage_profile.shield_override_stagger_strength

	if override_stagger_strength then
		stagger_strength = override_stagger_strength
	end

	local open_up_threshold = template.open_up_threshold
	local quarter_open_up_threshold = open_up_threshold / 20
	local hit_strength = self._hit_strength

	hit_strength = math.min(hit_strength + stagger_strength, open_up_threshold)
	self._hit_strength = hit_strength

	if attack_result == attack_results.damaged then
		stagger_type, duration_scale, length_scale = self:_check_for_ignore_override(stagger_type)

		return stagger_type, duration_scale or 0, length_scale
	elseif hit_strength == open_up_threshold then
		stagger_type, duration_scale, length_scale = stagger_types.shield_heavy_block, 1, 1

		local skip_open_up_vfx = self._template.skip_open_up_vfx

		if not skip_open_up_vfx then
			local fx_system = Managers.state.extension:system("fx_system")
			local shield_item = self._shield_item
			local fx_source_name = template.open_up_vfx_node
			local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(shield_item, fx_source_name)
			local source_position = Unit.world_position(attachment_unit, node)
			local source_rotation = Unit.world_rotation(attachment_unit, node)

			fx_system:trigger_vfx(template.open_up_vfx, source_position, source_rotation)
		end

		self._hit_strength = 0
	elseif quarter_open_up_threshold < hit_strength then
		stagger_type, duration_scale, length_scale = stagger_types.shield_block, 1, 1
	else
		stagger_type, duration_scale, length_scale = nil, 0, 0
	end

	return stagger_type, duration_scale, length_scale
end

return MinionShieldExtension
