-- chunkname: @scripts/components/interactable.lua

local Component = require("scripts/utilities/component")
local Interactable = component("Interactable")

Interactable.init = function (self, unit, is_server)
	self._unit = unit
	self._used = false
	self._is_server = is_server

	if EDITOR or rawget(_G, "EditorApi") then
		return
	end

	local interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	self._interactee_extension = interactee_extension

	if interactee_extension then
		local interaction_type = self:get_data(unit, "interaction_type")
		local ui_interaction_type = self:get_data(unit, "ui_interaction_type")
		local display_start_event = self:get_data(unit, "display_start_event")
		local require_all_players = self:get_data(unit, "require_all_players")
		local interaction_length = self:get_data(unit, "interaction_length")
		local interaction_icon = self:get_data(unit, "interaction_icon")
		local shared_interaction = self:get_data(unit, "shared_interaction")
		local only_once = self:get_data(unit, "only_once")
		local start_enabled = self:get_data(unit, "start_enabled")
		local start_active = self:get_data(unit, "start_active")
		local interactor_item_to_equip = self:get_data(unit, "interactor_item_to_equip")
		local emissive_material_name = self:get_data(unit, "emissive_material")
		local description = self:get_data(unit, "hud_description")

		if description == "" then
			description = nil
		end

		local action_text = self:get_data(unit, "sub_description")

		if action_text == "" then
			action_text = nil
		end

		local missing_players_text = self:get_data(unit, "missing_players_description")

		if missing_players_text == "" then
			missing_players_text = nil
		end

		if not start_enabled then
			self:interactable_disable(unit)
		end

		local interaction_context = {}

		interaction_context.duration = interaction_length
		interaction_context.shared_interaction = shared_interaction
		interaction_context.only_once = only_once
		interaction_context.interactor_item_to_equip = interactor_item_to_equip
		interaction_context.description = description
		interaction_context.action_text = action_text
		interaction_context.missing_players_text = missing_players_text
		interaction_context.interaction_icon = interaction_icon ~= "use_template" and interaction_icon or nil
		interaction_context.ui_interaction_type = ui_interaction_type ~= "use_template" and ui_interaction_type or nil
		interaction_context.display_start_event = display_start_event

		interactee_extension:set_interaction_context(interaction_type, interaction_context, start_active)
		interactee_extension:set_emissive_material_name(emissive_material_name)

		if require_all_players then
			interactee_extension:set_missing_players(true)
		end

		local has_animation_state_machine = Unit.has_animation_state_machine(unit)

		self._support_simple_animation = self:get_data(unit, "support_simple_animation") and not has_animation_state_machine
		self._support_prop_animation = self:get_data(unit, "support_prop_animation") and not self._support_simple_animation
		self._animation_back_speed_modifier = self:get_data(unit, "animation_back_speed_modifier")
		self._animation_speed_modifier = self:get_data(unit, "animation_speed_modifier") or 1
		self._is_playing_forward = nil
		self._anim_time = 0
		self._anim_length = 0
		self._in_state_a = true
		self._interaction_length = interaction_length

		self:_setup_animation(interaction_length)
	end
end

Interactable.hot_join_sync = function (self, joining_client, joining_channel)
	if self._interactee_extension then
		if self._interactee_extension:active() then
			self:interactable_enable(self._unit)
		else
			self:interactable_disable(self._unit)
		end
	end

	if self._support_simple_animation and not self._in_state_a then
		Component.hot_join_sync_event_to_client(joining_client, joining_channel, self, "hot_join")
	end
end

Interactable.events.hot_join = function (self)
	local anim_data = self._anim_data.forward
	local anim_time_to = anim_data.time

	self:_client_play_animation(0, anim_time_to, 1000)
end

Interactable._setup_animation = function (self, interaction_length)
	if self._support_simple_animation then
		local unit = self._unit
		local anim_length = Unit.simple_animation_length(unit)

		self._anim_length = anim_length

		local states = table.enum("forward", "backward")
		local speed = 1

		if interaction_length ~= 0 then
			speed = anim_length / interaction_length
		end

		local anim_data = {
			[states.forward] = {
				time = anim_length,
				speed = speed,
			},
			[states.backward] = {
				time = 0,
				speed = speed,
			},
		}

		self._states = states
		self._anim_data = anim_data
		self._anim_length = anim_length
	elseif self._support_prop_animation then
		self._interactee_extension:setup_animation()
	end
end

Interactable.enable = function (self, unit)
	if self._is_server then
		local interactee_extension = self._interactee_extension

		if not interactee_extension:used() then
			interactee_extension:set_active(true)
		end
	end
end

Interactable.disable = function (self, unit)
	if self._is_server then
		self._interactee_extension:set_active(false)
	end
end

Interactable.destroy = function (self, unit)
	return
end

Interactable.interactable_enable = function (self, unit)
	self:enable(unit)
end

Interactable.interactable_disable = function (self, unit)
	self:disable(unit)
end

Interactable.interactable_set_used = function (self, unit)
	local interactee_extension = self._interactee_extension

	if interactee_extension then
		interactee_extension:set_used()
	end
end

Interactable.interactable_disable_local = function (self, unit)
	self:disable(unit, true)

	local interactee_extension = self._interactee_extension

	interactee_extension:set_active(false)
	interactee_extension:disable_active_hotjoin_sync()
end

Interactable.interactable_set_block_text = function (self, text, block_text_context)
	local interactee_extension = self._interactee_extension

	if interactee_extension then
		interactee_extension:set_block_text(text, block_text_context)
	end
end

Interactable.interactable_clear_block = function (self, unit)
	local interactee_extension = self._interactee_extension

	if interactee_extension then
		interactee_extension:set_missing_players(false)
	end
end

Interactable.interactable_missing_players = function (self, unit)
	local interactee_extension = self._interactee_extension

	if interactee_extension then
		interactee_extension:set_missing_players(true)
	end
end

Interactable.events.interactable_enable = function (self, unit)
	self:enable(unit)
end

Interactable.events.interactable_disable = function (self, unit)
	self:disable(unit)
end

Interactable.disable_display_start_event = function (self, unit)
	local interactee_extension = self._interactee_extension

	if interactee_extension then
		interactee_extension:disable_display_start_event(true)
	end
end

Interactable.events.unit_died = function (self)
	if self._is_server then
		self._interactee_extension:set_active(false)
	end
end

Interactable.events.interaction_started = function (self, type, unit)
	if self._support_simple_animation then
		local is_playing_forward = self._is_playing_forward

		is_playing_forward = is_playing_forward == nil and true or not is_playing_forward
		self._is_playing_forward = is_playing_forward
		self._interaction_canceled = false

		self:_play_animation()

		return true
	elseif self._support_prop_animation then
		self._interactee_extension:animation_event("interaction_start")
	end
end

Interactable.events.interaction_canceled = function (self, type, unit)
	if self._support_simple_animation then
		self._is_playing_forward = not self._is_playing_forward
		self._interaction_canceled = true

		self:_play_animation()

		return true
	elseif self._support_prop_animation then
		self._interactee_extension:animation_event("interaction_cancel")
	end
end

Interactable.events.interaction_success = function (self, type, unit)
	self._in_state_a = not self._in_state_a

	if self._support_prop_animation then
		self._interactee_extension:animation_event("interaction_success")
	end
end

Interactable._play_animation = function (self)
	local state = self._is_playing_forward and "forward" or "backward"
	local anim_data = self._anim_data[state]
	local anim_time = self._anim_time
	local anim_time_to = anim_data.time

	if anim_time ~= anim_time_to then
		local speed = anim_data.speed

		if state == "forward" then
			if self._interaction_canceled then
				speed = speed * self._animation_back_speed_modifier
			else
				local interaction_length = self._interaction_length
				local length = interaction_length == 0 and 1 or interaction_length

				speed = (self._anim_length - anim_time) / length * self._animation_speed_modifier
			end
		elseif self._interaction_canceled then
			speed = -speed * self._animation_back_speed_modifier
		else
			local interaction_length = self._interaction_length
			local length = interaction_length == 0 and 1 or interaction_length

			speed = -(self._anim_length - (self._anim_length - anim_time)) / length * self._animation_speed_modifier
		end

		Unit.play_simple_animation(self._unit, anim_time, anim_time_to, false, speed)

		self._anim_speed = speed

		Component.trigger_event_on_clients(self, "client_play_animation", "rpc_animation_play_client", anim_time, anim_time_to, speed)
	end
end

Interactable.update = function (self, unit, dt, t)
	local state = self._is_playing_forward and "forward" or "backward"
	local anim_data = self._anim_data[state]
	local end_time = anim_data.time

	if Unit.is_playing_simple_animation(unit) then
		local anim_speed = self._anim_speed

		self._anim_time = math.clamp(self._anim_time + anim_speed * dt, 0, self._anim_length)

		return true
	else
		self._anim_time = end_time
		self._anim_speed = nil
	end
end

Interactable.editor_update = function (self, unit, dt, t)
	return
end

Interactable.editor_validate = function (self, unit)
	return true, ""
end

Interactable.events.client_play_animation = function (self, anim_time, anim_time_to, speed)
	self:_client_play_animation(anim_time, anim_time_to, speed)
end

Interactable._client_play_animation = function (self, anim_time, anim_time_to, speed)
	if self._support_simple_animation then
		Unit.play_simple_animation(self._unit, anim_time, anim_time_to, false, speed)
	else
		Log.warning("interactable", "Trying to play simple animation on interactable that does not support simple animation")
	end
end

Interactable.component_config = {
	disable_event_public = false,
	enable_event_public = false,
	starts_enabled_default = true,
}
Interactable.component_data = {
	interaction_type = {
		ui_name = "Interaction Type",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"ammunition",
			"body_shop",
			"chest",
			"contracts",
			"crafting",
			"decoding",
			"default",
			"door_control_panel",
			"equip_auspex",
			"gamemode_havoc",
			"health_station",
			"health",
			"inbox",
			"luggable_socket",
			"luggable",
			"marks_vendor",
			"mission_board",
			"moveable_platform",
			"penance_collectible",
			"penances",
			"premium_vendor",
			"cosmetics_vendor",
			"pull_up",
			"remove_net",
			"revive",
			"scanning",
			"servo_skull_activator",
			"servo_skull",
			"setup_breach_charge",
			"setup_decoding",
			"training_ground",
			"vendor",
			"scripted_scenario",
		},
		options_values = {
			"ammunition",
			"body_shop",
			"chest",
			"contracts",
			"crafting",
			"decoding",
			"default",
			"door_control_panel",
			"equip_auspex",
			"gamemode_havoc",
			"health_station",
			"health",
			"inbox",
			"luggable_socket",
			"luggable",
			"marks_vendor",
			"mission_board",
			"moveable_platform",
			"penance_collectible",
			"penances",
			"premium_vendor",
			"cosmetics_vendor",
			"pull_up",
			"remove_net",
			"revive",
			"scanning",
			"servo_skull_activator",
			"servo_skull",
			"setup_breach_charge",
			"setup_decoding",
			"training_ground",
			"vendor",
			"scripted_scenario",
		},
	},
	ui_interaction_type = {
		category = "UI",
		ui_name = "UI Interaction Type",
		ui_type = "combo_box",
		value = "default",
		options_keys = {
			"critical",
			"default",
			"mission",
			"pickup",
			"point_of_interest",
			"puzzle",
			"use_template",
		},
		options_values = {
			"critical",
			"default",
			"mission",
			"pickup",
			"point_of_interest",
			"puzzle",
			"use_template",
		},
	},
	interaction_icon = {
		category = "UI",
		ui_name = "Interaction Icon",
		ui_type = "combo_box",
		value = "use_template",
		options_keys = {
			"ammunition",
			"default",
			"environment_alert",
			"environment_generic",
			"help",
			"inbox",
			"objective_main",
			"objective_secondary",
			"objective_side",
			"speak",
			"use_template",
		},
		options_values = {
			"content/ui/materials/hud/interactions/icons/ammunition",
			"content/ui/materials/hud/interactions/icons/default",
			"content/ui/materials/hud/interactions/icons/environment_alert",
			"content/ui/materials/hud/interactions/icons/environment_generic",
			"content/ui/materials/hud/interactions/icons/help",
			"content/ui/materials/hud/interactions/icons/inbox",
			"content/ui/materials/hud/interactions/icons/objective_main",
			"content/ui/materials/hud/interactions/icons/objective_secondary",
			"content/ui/materials/hud/interactions/icons/objective_side",
			"content/ui/materials/hud/interactions/icons/speak",
			"use_template",
		},
	},
	start_enabled = {
		ui_name = "Start Enabled",
		ui_type = "check_box",
		value = true,
	},
	interaction_length = {
		step = 0.5,
		ui_name = "Interaction Length (in sec.)",
		ui_type = "number",
		value = 1,
	},
	shared_interaction = {
		ui_name = "Shared Interaction",
		ui_type = "check_box",
		value = false,
	},
	only_once = {
		ui_name = "Only Once",
		ui_type = "check_box",
		value = false,
	},
	start_active = {
		ui_name = "Start Active (don't touch)",
		ui_type = "check_box",
		value = true,
	},
	interactor_item_to_equip = {
		filter = "item",
		ui_name = "Interactor Item to Equip (scanner, decoder, ...)",
		ui_type = "resource",
		value = "",
	},
	require_all_players = {
		category = "UI",
		ui_name = "Show 'Require All Players'",
		ui_type = "check_box",
		value = false,
	},
	display_start_event = {
		category = "UI",
		ui_name = "Show 'Start Event'",
		ui_type = "check_box",
		value = false,
	},
	hud_description = {
		category = "UI",
		ui_name = "Override Description",
		ui_type = "text_box",
		value = "",
	},
	sub_description = {
		category = "UI",
		ui_name = "Override Action Text",
		ui_type = "text_box",
		value = "",
	},
	missing_players_description = {
		category = "UI",
		ui_name = "Override Missing Players Text",
		ui_type = "text_box",
		value = "",
	},
	support_simple_animation = {
		category = "Animation",
		ui_name = "Support Simple Animation",
		ui_type = "check_box",
		value = false,
	},
	support_prop_animation = {
		category = "Animation",
		ui_name = "Support State Machine",
		ui_type = "check_box",
		value = false,
	},
	animation_back_speed_modifier = {
		category = "Animation",
		decimals = 1,
		step = 0.5,
		ui_name = "Animation Back Speed Modifier",
		ui_type = "number",
		value = 1,
	},
	animation_speed_modifier = {
		category = "Animation",
		decimals = 1,
		step = 0.5,
		ui_name = "Animation Speed Modifier",
		ui_type = "number",
		value = 1,
	},
	emissive_material = {
		category = "Emissive",
		ui_name = "Emissive Material",
		ui_type = "text_box",
		value = "emissive_interactable_01",
	},
	inputs = {
		interactable_enable = {
			accessibility = "public",
			type = "event",
		},
		interactable_disable = {
			accessibility = "public",
			type = "event",
		},
		interactable_set_used = {
			accessibility = "public",
			type = "event",
		},
		interactable_clear_block = {
			accessibility = "public",
			type = "event",
		},
		interactable_missing_players = {
			accessibility = "public",
			type = "event",
		},
		disable_display_start_event = {
			accessibility = "public",
			type = "event",
		},
	},
}

return Interactable
