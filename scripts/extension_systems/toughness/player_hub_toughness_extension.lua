-- chunkname: @scripts/extension_systems/toughness/player_hub_toughness_extension.lua

local PlayerHubToughnessExtension = class("PlayerHubToughnessExtension")

PlayerHubToughnessExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._unit = unit
	self._is_server = extension_init_context.is_server

	local toughness_template = extension_init_data.toughness_template

	self:_initialize_toughness(toughness_template)

	self._toughness_template = toughness_template

	if self._is_server then
		self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	end
end

PlayerHubToughnessExtension._initialize_toughness = function (self, toughness_template)
	local toughness_constant = NetworkConstants.toughness
	local min, max = toughness_constant.min, toughness_constant.max

	self._max_toughness = toughness_template.max
end

PlayerHubToughnessExtension.update = function (self, context, dt, t)
	return
end

PlayerHubToughnessExtension.max_toughness_visual = function (self)
	return self._max_toughness
end

PlayerHubToughnessExtension.max_toughness = function (self)
	return self._max_toughness
end

PlayerHubToughnessExtension.toughness_damage = function (self)
	return 0
end

PlayerHubToughnessExtension.remaining_toughness = function (self)
	return self._max_toughness
end

PlayerHubToughnessExtension.current_toughness_percent_visual = function (self)
	return 1
end

PlayerHubToughnessExtension.current_toughness_percent = function (self)
	return 1
end

PlayerHubToughnessExtension.handle_max_toughness_changes_due_to_buffs = function (self)
	return
end

PlayerHubToughnessExtension.toughness_templates = function (self)
	if self._is_server then
		local weapon_toughness_template = self._weapon_extension:toughness_template()

		return self._toughness_template, weapon_toughness_template
	else
		return self._toughness_template, nil
	end
end

PlayerHubToughnessExtension.recover_toughness = function (self)
	return
end

PlayerHubToughnessExtension.recover_percentage_toughness = function (self)
	return
end

PlayerHubToughnessExtension.recover_flat_toughness = function (self)
	return
end

PlayerHubToughnessExtension.recover_max_toughness = function (self)
	return
end

PlayerHubToughnessExtension.set_toughness_broken_time = function (self)
	return
end

PlayerHubToughnessExtension.time_since_toughness_broken = function (self)
	return math.huge
end

PlayerHubToughnessExtension.set_toughness_regen_delay = function (self)
	return
end

PlayerHubToughnessExtension.add_damage = function (self, damage_amount, attack_result, hit_actor, damage_profile, attack_type, attack_direction, hit_world_position_or_nil)
	return
end

return PlayerHubToughnessExtension
