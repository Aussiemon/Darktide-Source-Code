-- chunkname: @scripts/components/destructible.lua

local Component = require("scripts/utilities/component")
local Destructible = component("Destructible")

Destructible.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server

	local start_enabled = self:get_data(unit, "start_enabled")

	self._enabled = start_enabled

	local prop_identifier = self:get_data(unit, "collectible_type")

	self._identifier = prop_identifier

	local destructible_extension = ScriptUnit.has_extension(unit, "destructible_system")

	if destructible_extension then
		local disable_physics = Unit.get_data(unit, "disable_physics")

		destructible_extension:set_physics_disabled(disable_physics)

		if not disable_physics then
			local start_visible = self:get_data(unit, "start_visible")
			local network_unit = self:get_data(unit, "network_unit")
			local despawn_timer_duration = self:get_data(unit, "despawn_timer_duration")
			local despawn_when_destroyed = self:get_data(unit, "despawn_when_destroyed")
			local collision_actors = self:get_data(unit, "collision_actors")
			local mass = self:get_data(unit, "mass")
			local speed = self:get_data(unit, "speed")
			local direction = self:get_data(unit, "direction")
			local force_direction = self:get_data(unit, "force_direction")
			local is_nav_gate = self:get_data(unit, "is_nav_gate")
			local broadphase_radius = self:get_data(unit, "broadphase_radius")
			local use_health_extension_health = self:get_data(unit, "use_health_extension_health")

			self._damage_material_slot_name = self:get_data(unit, "damage_material_slot_name")
			self._damage_amount_variable_name = self:get_data(unit, "damage_amount_variable_name")

			local destructible_stages = self:get_data(unit, "destructible_stages")

			if destructible_stages and #destructible_stages > 0 then
				table.sort(destructible_stages, function (a, b)
					return a.health_threshold > b.health_threshold
				end)

				local num_destructible_stages = #destructible_stages

				self._destructible_stages = destructible_stages
				self._has_run_first_stage_update = self._is_server
				self._current_health_percent = 1
				self._current_stage_index = 1
				self._was_alive = true
			end

			local collectible_data
			local collectible_type = self:get_data(unit, "collectible_type")

			if collectible_type and collectible_type ~= "none" then
				local collectible_name = self:get_data(unit, "collectible_name")
				local collectible_id = self:get_data(unit, "collectible_id")
				local collectible_section_id = self:get_data(unit, "collectible_section_id")

				collectible_data = {
					name = collectible_name,
					id = collectible_id,
					section_id = collectible_section_id,
				}
			end

			destructible_extension:setup_from_component(despawn_timer_duration, despawn_when_destroyed, collision_actors, mass, speed, direction, force_direction, start_visible, is_nav_gate, broadphase_radius, use_health_extension_health, collectible_data, network_unit)
			destructible_extension:set_enabled_from_component(start_enabled)

			self._destructible_extension = destructible_extension
		end
	end

	local has_stages = not not self._destructible_stages
	local has_damage_material = not not self._damage_material_slot_name and not not self._damage_amount_variable_name

	return has_stages or has_damage_material
end

Destructible.destroy = function (self, unit)
	return
end

Destructible.extensions_ready = function (self, world, unit)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		destructible_extension:setup_stages()
	end

	self._health_extension = ScriptUnit.has_extension(unit, "health_system")

	if self._health_extension and destructible_extension and self._health_extension:create_health_game_object() then
		local should_despawn_with_health_game_object = destructible_extension:despawn_when_destroyed()
	end
end

Destructible.update = function (self, unit, dt, t)
	local destructible_stages = self._destructible_stages
	local damage_material_slot_name = self._damage_material_slot_name
	local damage_amount_variable_name = self._damage_amount_variable_name
	local has_damage_material = damage_material_slot_name and damage_amount_variable_name

	if not destructible_stages or not has_damage_material then
		return false
	end

	local health_extension = self._health_extension

	if not health_extension then
		return false
	end

	local last_stage_index = self._current_stage_index
	local last_health_percent = self._current_health_percent
	local current_health_percent = health_extension:current_health_percent()

	if destructible_stages and not self._is_server and not self._has_run_first_stage_update then
		for ii = #destructible_stages, 1, -1 do
			local stage = destructible_stages[ii]
			local next_stage = destructible_stages[ii + 1]
			local within_threshold

			if next_stage then
				within_threshold = current_health_percent <= stage.health_threshold and current_health_percent > next_stage.health_threshold
			else
				within_threshold = current_health_percent <= stage.health_threshold
			end

			if within_threshold then
				local hot_join_event_name = stage.hot_join_event_name

				if hot_join_event_name ~= "" then
					Unit.flow_event(unit, hot_join_event_name)
				end

				self._current_health_percent = current_health_percent
				self._current_stage_index = ii
				last_health_percent = current_health_percent
				last_stage_index = ii

				break
			end
		end

		self._has_run_first_stage_update = true
	end

	if current_health_percent ~= last_health_percent then
		if has_damage_material then
			local material_value = 1 - current_health_percent

			material_value = 0

			Unit.set_scalar_for_material(unit, damage_material_slot_name, damage_amount_variable_name, material_value)
		end

		if destructible_stages then
			for ii = #destructible_stages, 1, -1 do
				local stage = destructible_stages[ii]
				local next_stage = destructible_stages[ii + 1]
				local within_threshold

				if next_stage then
					within_threshold = current_health_percent <= stage.health_threshold and current_health_percent > next_stage.health_threshold
				else
					within_threshold = current_health_percent <= stage.health_threshold
				end

				local stage_lowered = last_stage_index < ii

				if within_threshold and stage_lowered then
					Unit.flow_event(unit, stage.event_name)

					self._current_stage_index = ii
				end
			end
		end

		self._current_health_percent = current_health_percent
	end

	return health_extension:is_alive()
end

Destructible.enable_destructible = function (self, unit)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "destructible_enable")
		end

		self._enabled = true

		destructible_extension:set_enabled_from_component(true)
	end
end

Destructible.disable_destructible = function (self, unit)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "destructible_disable")
		end

		self._enabled = false

		destructible_extension:set_enabled_from_component(false)
	end
end

Destructible.enable_visibility = function (self, unit)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "visibility_enable")
		end

		destructible_extension:set_visibility(true)
	end
end

Destructible.disable_visibility = function (self, unit)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		if self._is_server then
			Component.trigger_event_on_clients(self, "visibility_disable")
		end

		destructible_extension:set_visibility(false)
	end
end

Destructible.enable = function (self, unit)
	return
end

Destructible.disable = function (self, unit)
	return
end

Destructible.editor_init = function (self, unit)
	self:enable(unit)
end

Destructible.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if rawget(_G, "LevelEditor") then
		if Unit.find_actor(unit, "c_destructible") == nil then
			success = false
			error_message = error_message .. "\nCouldn't find actor 'c_destructible'"
		end

		if not Unit.has_visibility_group(unit, "main") then
			success = false
			error_message = error_message .. "\nCouldn't find visibility group 'main'"
		end
	end

	return success, error_message
end

Destructible.events.add_damage = function (self, damage, hit_actor, attack_direction, attacking_unit)
	local destructible_extension = self._destructible_extension
	local prop_identifier = self._identifier

	if prop_identifier ~= "none" then
		Managers.stats:record_team("mission_destructible_destroyed", prop_identifier)
	end

	if destructible_extension and self._enabled then
		destructible_extension:add_damage(damage, hit_actor, attack_direction, attacking_unit)
	end
end

Destructible.events.destructible_enable = function (self, unit)
	self:enable_destructible(unit)
end

Destructible.events.destructible_disable = function (self, unit)
	self:disable_destructible(unit)
end

Destructible.events.visibility_enable = function (self, unit)
	self:enable_visibility(unit)
end

Destructible.events.visibility_disable = function (self, unit)
	self:disable_visibility(unit)
end

Destructible.force_destruct = function (self)
	local destructible_extension = self._destructible_extension

	if destructible_extension then
		destructible_extension:force_destruct()
	end
end

Destructible.component_data = {
	damage_material_slot_name = {
		category = "Destruction Stages",
		ui_name = "Material Slot Name",
		ui_type = "text_box",
		value = "",
	},
	damage_amount_variable_name = {
		category = "Destruction Stages",
		ui_name = "Damage Variable Name",
		ui_type = "text_box",
		value = "damage_amount",
	},
	destructible_stages = {
		category = "Destruction Stages",
		ui_name = "Health Flow Callbacks",
		ui_type = "struct_array",
		definition = {
			event_name = {
				ui_name = "Callback",
				ui_type = "text_box",
				value = "",
			},
			hot_join_event_name = {
				ui_name = "Hot-Join Callback",
				ui_type = "text_box",
				value = "",
			},
			health_threshold = {
				decimals = 3,
				max = 1,
				min = 0,
				ui_name = "Threshold",
				ui_type = "number",
				value = 1,
			},
		},
		control_order = {
			"event_name",
			"hot_join_event_name",
			"health_threshold",
		},
	},
	start_enabled = {
		ui_name = "Start enabled",
		ui_type = "check_box",
		value = true,
	},
	start_visible = {
		ui_name = "Start visible",
		ui_type = "check_box",
		value = true,
	},
	network_unit = {
		ui_name = "Is Network Unit",
		ui_type = "check_box",
		value = false,
	},
	despawn_when_destroyed = {
		ui_name = "Despawn When Destroyed",
		ui_type = "check_box",
		value = true,
	},
	despawn_timer_duration = {
		decimals = 0,
		min = 0,
		step = 5,
		ui_name = "Despawn Timer Duration",
		ui_type = "number",
		value = 6,
	},
	collision_actors = {
		size = 0,
		ui_name = "Collision Actors to Remove",
		ui_type = "text_box_array",
		values = {},
	},
	is_nav_gate = {
		ui_name = "Is Nav Gate",
		ui_type = "check_box",
		value = false,
	},
	broadphase_radius = {
		decimals = 0,
		max = 100,
		min = 10,
		step = 1,
		ui_name = "Broadphase Radius",
		ui_type = "number",
		value = 40,
	},
	mass = {
		category = "Force on Destroy",
		decimals = 0,
		max = 100,
		min = 0,
		step = 1,
		ui_name = "Mass",
		ui_type = "number",
		value = 1,
	},
	speed = {
		category = "Force on Destroy",
		decimals = 0,
		max = 1200,
		min = 0,
		step = 10,
		ui_name = "Speed",
		ui_type = "number",
		value = 120,
	},
	direction = {
		category = "Force on Destroy",
		step = 0.1,
		ui_name = "Direction",
		ui_type = "vector",
		value = Vector3Box(0, 0, 0),
	},
	force_direction = {
		category = "Force on Destroy",
		ui_name = "Direction Source",
		ui_type = "combo_box",
		value = "random_direction",
		options_keys = {
			"Random Direction",
			"Attack Direction",
			"Relative - Provided Direction",
			"World space - Provided Direction",
		},
		options_values = {
			"random_direction",
			"attack_direction",
			"provided_direction_relative",
			"provided_direction_world",
		},
	},
	use_health_extension_health = {
		category = "DO NOT USE - IS HACK",
		ui_name = "use_health_extension_health",
		ui_type = "check_box",
		value = false,
	},
	collectible_id = {
		category = "Collectibles",
		decimals = 0,
		min = 0,
		ui_name = "Collectible ID",
		ui_type = "number",
		value = 1,
	},
	collectible_section_id = {
		category = "Collectibles",
		decimals = 0,
		min = 0,
		ui_name = "Collectible Section ID",
		ui_type = "number",
		value = 1,
	},
	collectible_type = {
		category = "Collectibles",
		ui_name = "Collectible Type",
		ui_type = "combo_box",
		value = "none",
		options_keys = {
			"None",
			"Heretic Idol",
		},
		options_values = {
			"none",
			"heretic_idol",
		},
	},
	inputs = {
		force_destruct = {
			accessibility = "public",
			type = "event",
		},
	},
	extensions = {
		"DestructibleExtension",
	},
}

return Destructible
