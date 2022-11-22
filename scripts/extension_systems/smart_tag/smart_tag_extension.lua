local SmartTag = require("scripts/extension_systems/smart_tag/smart_tag")
local SmartTagSettings = require("scripts/settings/smart_tag/smart_tag_settings")
local SmartTagExtension = class("SmartTagExtension")

SmartTagExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	local target_type = extension_init_data.target_type

	if target_type then
		self._target_type = target_type

		Unit.set_data(unit, "smart_tag_target_type", target_type)

		self._target_actor = Unit.actor(unit, "smart_tagging")
		self._auto_tag_on_spawn = extension_init_data.auto_tag_on_spawn
	end

	self._owned_tag_ids = {}
	self._tag_id = nil
	self._display_name = nil
	self._replied_tag_ids = {}
end

SmartTagExtension.setup_from_component = function (self, target_type)
	if target_type then
		self._target_type = target_type

		Unit.set_data(self._unit, "smart_tag_target_type", target_type)

		self._target_actor = Unit.actor(self._unit, "smart_tagging")
	end
end

SmartTagExtension.destroy = function (self)
	self._unit = nil
	self._owned_tag_ids = nil
	self._tag_id = nil
	self._replied_tag_ids = nil
end

SmartTagExtension.extensions_ready = function (self, world, unit)
	if self._target_type then
		self:_setup_display_name(unit)
	end
end

SmartTagExtension.game_object_initialized = function (self, session, object_id)
	if self._is_server and self._auto_tag_on_spawn then
		self:_set_tag_on_spawn()
	end
end

SmartTagExtension._set_tag_on_spawn = function (self)
	local tagger_unit = nil
	local tag_template = self:contextual_tag_template(tagger_unit)

	if tag_template then
		local target_unit = self._unit
		local target_location = nil
		local smart_tag_system = Managers.state.extension:system("smart_tag_system")

		smart_tag_system:set_tag(tag_template.name, tagger_unit, target_unit, target_location)
	end
end

SmartTagExtension._setup_display_name = function (self, unit)
	local target_type = self._target_type

	if target_type == "pickup" or target_type == "health_station" then
		local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

		if interactee_extension then
			self._display_name = interactee_extension:description()
		end
	elseif target_type == "breed" then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local breed = unit_data_extension:breed()
		self._breed = breed
		self._display_name = breed.display_name
	end
end

SmartTagExtension.can_tag = function (self, tagger_unit)
	local template_name = self:_contextual_tag_template_name(tagger_unit)

	return template_name ~= nil
end

SmartTagExtension.contextual_tag_template = function (self, tagger_unit)
	local template_name = self:_contextual_tag_template_name(tagger_unit)
	local template = template_name and SmartTagSettings.templates[template_name]

	return template
end

SmartTagExtension._contextual_tag_template_name = function (self, tagger_unit)
	local target_type = self._target_type

	if not target_type then
		return nil
	end

	local unit = self._unit

	if tagger_unit == unit then
		return nil
	end

	local is_valid, _ = SmartTag.validate_target_unit(unit)

	if not is_valid then
		return nil
	end

	if target_type == "pickup" then
		local pickup_name = Unit.get_data(unit, "pickup_type")

		if pickup_name == "small_clip" then
			return "small_clip_over_here"
		elseif pickup_name == "large_clip" then
			return "large_clip_over_here"
		elseif pickup_name == "health_booster" then
			return "health_booster_over_here"
		elseif pickup_name == "small_grenade" then
			return "small_grenade_over_here"
		elseif pickup_name == "battery_01_luggable" then
			return "luggable_battery_over_here"
		elseif pickup_name == "container_01_luggable" then
			return "luggable_container_over_here"
		elseif pickup_name == "container_02_luggable" then
			return "luggable_container_over_here"
		elseif pickup_name == "container_03_luggable" then
			return "luggable_container_over_here"
		elseif pickup_name == "control_rod_01_luggable" then
			return "luggable_control_rod_over_here"
		elseif pickup_name == "medical_crate_pocketable" then
			return "pocketable_medical_crate_over_here"
		elseif pickup_name == "ammo_cache_pocketable" then
			return "pocketable_ammo_cache_over_here"
		elseif pickup_name == "ammo_cache_deployable" then
			return "deployed_ammo_cache_over_here"
		elseif pickup_name == "medical_crate_deployable" then
			return "deployed_medical_crate_over_here"
		elseif pickup_name == "consumable" then
			return "side_mission_consumable_over_here"
		elseif pickup_name == "grimoire" then
			return "side_mission_grimoire_over_here"
		elseif pickup_name == "tome" then
			return "side_mission_tome_over_here"
		elseif pickup_name == "small_metal" then
			return "small_metal_pickup_over_here"
		elseif pickup_name == "large_metal" then
			return "large_metal_pickup_over_here"
		elseif pickup_name == "small_platinum" then
			return "small_platinum_pickup_over_here"
		elseif pickup_name == "large_platinum" then
			return "large_platinum_pickup_over_here"
		end
	elseif target_type == "medical_crate_deployable" then
		return "deployed_medical_crate_over_here"
	elseif target_type == "breed" then
		local side_system = Managers.state.extension:system("side_system")

		if side_system:is_enemy(tagger_unit, unit) then
			return "enemy_over_here"
		end
	elseif target_type == "health_station" then
		local health_station_extension = ScriptUnit.extension(unit, "health_station_system")
		local has_battery = health_station_extension:battery_in_slot()

		if has_battery then
			return "health_station_over_here"
		else
			return "health_station_without_battery_over_here"
		end
	end
end

SmartTagExtension.register_owned_tag = function (self, tag_id)
	local owned_tag_ids = self._owned_tag_ids
	owned_tag_ids[#owned_tag_ids + 1] = tag_id
end

SmartTagExtension.unregister_owned_tag = function (self, tag_id)
	local owned_tag_ids = self._owned_tag_ids
	local remove_index = table.index_of(owned_tag_ids, tag_id)

	table.remove(owned_tag_ids, remove_index)
end

SmartTagExtension.owned_tag_ids = function (self)
	return self._owned_tag_ids
end

SmartTagExtension.register_tag = function (self, tag_id)
	self._tag_id = tag_id
end

SmartTagExtension.unregister_tag = function (self)
	self._tag_id = nil
end

SmartTagExtension.display_name = function (self, tagger_unit)
	if self._display_name then
		return self._display_name
	end

	local template = self:contextual_tag_template(tagger_unit)

	return template and template.display_name or "n/a"
end

SmartTagExtension.register_reply = function (self, tag_id)
	self._replied_tag_ids[tag_id] = true
end

SmartTagExtension.unregister_reply = function (self, tag_id)
	self._replied_tag_ids[tag_id] = nil
end

SmartTagExtension.replied_tag_ids = function (self)
	return self._replied_tag_ids
end

SmartTagExtension.tag_id = function (self)
	return self._tag_id
end

SmartTagExtension.target_actor = function (self)
	return self._target_actor
end

return SmartTagExtension
