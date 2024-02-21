local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local attack_results = AttackSettings.attack_results
local stagger_types = StaggerSettings.stagger_types
local MinionShieldExtension = class("MinionShieldExtension")
local IS_BLOCKING_INITIALLY = true

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
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local shield_item = visual_loadout_extension:slot_item(shield_template.open_up_vfx_slot_name)
	self._shield_item = shield_item
end

MinionShieldExtension._init_blackboard_components = function (self, blackboard)
	local shield_write_component = Blackboard.write_component(blackboard, "shield")
	shield_write_component.is_blocking = IS_BLOCKING_INITIALLY
	self._shield_component = shield_write_component
	self._stagger_component = blackboard.stagger
end

MinionShieldExtension.game_object_initialized = function (self, session, object_id)
	self._game_object_id = object_id
	self._game_session = session
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

MinionShieldExtension.can_block_attack = function (self, damage_profile, attacking_unit, attacking_unit_owner_unit, hit_zone_name)
	if damage_profile.ignore_shield or not attacking_unit then
		return false
	end

	local attacking_owner_unit_data_extension = ScriptUnit.has_extension(attacking_unit_owner_unit, "unit_data_system")

	if attacking_owner_unit_data_extension == nil then
		return false
	end

	local breed = attacking_owner_unit_data_extension:breed()

	if Breed.is_minion(breed) then
		return true
	end

	local perception_component = self._blackboard.perception
	local is_aggroed = perception_component.aggro_state == "aggroed"

	if not is_aggroed then
		return false
	end

	local attacking_unit_position = POSITION_LOOKUP[attacking_unit]
	local can_block_from_position = self:can_block_from_position(attacking_unit_position)

	return can_block_from_position
end

MinionShieldExtension.can_block_from_position = function (self, attacking_unit_position, hit_zone_name)
	local is_blocking = self._shield_component.is_blocking

	if not is_blocking then
		return false
	end

	if hit_zone_name and hit_zone_name == "shield" then
		return true
	end

	local blocking_angle = self._template.blocking_angle
	local unit = self._unit
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local unit_position = POSITION_LOOKUP[unit]
	local to_attacking_unit = Vector3.normalize(attacking_unit_position - unit_position)
	local angle = Vector3.angle(unit_forward, to_attacking_unit)
	local is_within_blocking_angle = angle < blocking_angle

	return is_within_blocking_angle
end

local DEFAULT_MULTIPLIER = 1

MinionShieldExtension.apply_stagger = function (self, unit, damage_profile, stagger_strength, attack_result, stagger_type, duration_scale, length_scale, attack_type)
	local is_blocking = self._shield_component.is_blocking

	if not is_blocking or damage_profile.ignore_shield then
		local stagger_component = self._stagger_component
		local in_open_up_stagger = stagger_component.num_triggered_staggers > 0 and stagger_component.type == stagger_types.shield_heavy_block

		if in_open_up_stagger then
			length_scale = 1
			duration_scale = 1
			stagger_type = stagger_types.shield_broken
			self._hit_strength = 0
		end

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
		return stagger_type, duration_scale, length_scale
	elseif hit_strength == open_up_threshold then
		length_scale = 1
		duration_scale = 1
		stagger_type = stagger_types.shield_heavy_block
		local fx_system = Managers.state.extension:system("fx_system")
		local shield_item = self._shield_item
		local fx_source_name = template.open_up_vfx_node
		local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(shield_item, fx_source_name)
		local source_position = Unit.world_position(attachment_unit, node)
		local source_rotation = Unit.world_rotation(attachment_unit, node)

		fx_system:trigger_vfx(template.open_up_vfx, source_position, source_rotation)

		self._hit_strength = 0
	elseif quarter_open_up_threshold < hit_strength then
		length_scale = 1
		duration_scale = 1
		stagger_type = stagger_types.shield_block
	else
		length_scale = 0
		duration_scale = 0
		stagger_type = nil
	end

	return stagger_type, duration_scale, length_scale
end

return MinionShieldExtension
