local Component = require("scripts/utilities/component")
local Interactable = component("Interactable")

Interactable.init = function (self, unit, is_server)
	self._unit = unit
	self._used = false
	self._interactee_extension = nil
	self._is_server = is_server

	if EDITOR or rawget(_G, "EditorApi") then
		return
	end

	self._interactee_extension = ScriptUnit.has_extension(unit, "interactee_system")

	if self._interactee_extension then
		local interaction_type = self:get_data(unit, "interaction_type")
		local ui_interaction_type = self:get_data(unit, "ui_interaction_type")
		local display_start_event = self:get_data(unit, "display_start_event")
		local interaction_length = self:get_data(unit, "interaction_length")
		local interaction_icon = self:get_data(unit, "interaction_icon")
		local shared_interaction = self:get_data(unit, "shared_interaction")
		local only_once = self:get_data(unit, "only_once")
		local start_enabled = self:get_data(unit, "start_enabled")
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

		if not start_enabled then
			self:interactable_disable(unit)
		end

		local interaction_context = {
			duration = interaction_length,
			shared_interaction = shared_interaction,
			only_once = only_once,
			interactor_item_to_equip = interactor_item_to_equip,
			description = description,
			action_text = action_text,
			interaction_icon = interaction_icon ~= "use_template" and interaction_icon or nil,
			ui_interaction_type = ui_interaction_type ~= "use_template" and ui_interaction_type or nil,
			display_start_event = display_start_event
		}

		self._interactee_extension:set_interaction_context(interaction_type, interaction_context)
		self._interactee_extension:set_emissive_material_name(emissive_material_name)

		local has_animation_state_machine = Unit.has_animation_state_machine(unit)
		self._support_simple_animation = self:get_data(unit, "support_simple_animation") and not has_animation_state_machine
		self._support_prop_animation = self:get_data(unit, "support_prop_animation") and not self._support_simple_animation
		self._animation_back_speed_modifier = self:get_data(unit, "animation_back_speed_modifier")
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
				speed = speed
			},
			[states.backward] = {
				time = 0,
				speed = speed
			}
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

Interactable.events.died = function (self)
	if self._is_server then
		self._interactee_extension:set_active(false)
	end
end

Interactable.events.interaction_started = function (self, type, unit)
	if self._support_simple_animation then
		local is_playing_forward = self._is_playing_forward
		is_playing_forward = is_playing_forward == nil and true or not is_playing_forward
		self._is_playing_forward = is_playing_forward
		self._interaction_cancled = false

		self:_play_animation()

		return true
	elseif self._support_prop_animation then
		self._interactee_extension:animation_event("interaction_start")
	end
end

Interactable.events.interaction_canceled = function (self, type, unit)
	if self._support_simple_animation then
		self._is_playing_forward = not self._is_playing_forward
		self._interaction_cancled = true

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
		local speed = anim_data.speed * self._animation_back_speed_modifier

		if state == "forward" then
			if not self._interaction_cancled then
				local interaction_length = self._interaction_length
				local length = interaction_length == 0 and 1 or interaction_length
				speed = (self._anim_length - anim_time) / length
			end
		elseif self._interaction_cancled then
			speed = -speed
		else
			local interaction_length = self._interaction_length
			local length = interaction_length == 0 and 1 or interaction_length
			speed = -(self._anim_length - (self._anim_length - anim_time)) / length
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
	starts_enabled_default = true
}
Interactable.component_data = {
	interaction_type = {
		value = "default",
		ui_type = "combo_box",
		ui_name = "Interaction Type",
		options_keys = {
			"ammunition",
			"body_shop",
			"chest",
			"contracts",
			"decoding",
			"default",
			"door_control_panel",
			"equip_auspex",
			"health_station",
			"health",
			"inbox",
			"luggable_socket",
			"luggable",
			"marks_vendor",
			"moveable_platform",
			"pull_up",
			"remove_net",
			"revive",
			"scanning",
			"servo_skull_activator",
			"servo_skull",
			"setup_decoding",
			"training_ground",
			"vendor",
			"scripted_scenario"
		},
		options_values = {
			"ammunition",
			"body_shop",
			"chest",
			"contracts",
			"decoding",
			"default",
			"door_control_panel",
			"equip_auspex",
			"health_station",
			"health",
			"inbox",
			"luggable_socket",
			"luggable",
			"marks_vendor",
			"moveable_platform",
			"pull_up",
			"remove_net",
			"revive",
			"scanning",
			"servo_skull_activator",
			"servo_skull",
			"setup_decoding",
			"training_ground",
			"vendor",
			"scripted_scenario"
		}
	},
	ui_interaction_type = {
		value = "default",
		ui_type = "combo_box",
		category = "UI",
		ui_name = "UI Interaction Type",
		options_keys = {
			"critical",
			"default",
			"mission",
			"pickup",
			"point_of_interest",
			"use_template"
		},
		options_values = {
			"critical",
			"default",
			"mission",
			"pickup",
			"point_of_interest",
			"use_template"
		}
	},
	interaction_icon = {
		value = "use_template",
		ui_type = "combo_box",
		category = "UI",
		ui_name = "Interaction Icon",
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
			"use_template"
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
			"use_template"
		}
	},
	display_start_event = {
		ui_type = "check_box",
		value = false,
		ui_name = "Show 'Start Event'",
		category = "UI"
	},
	interaction_length = {
		ui_type = "number",
		value = 1,
		ui_name = "Interaction Length (in sec.)",
		step = 0.5
	},
	shared_interaction = {
		ui_type = "check_box",
		value = false,
		ui_name = "Shared Interaction"
	},
	only_once = {
		ui_type = "check_box",
		value = false,
		ui_name = "Only Once"
	},
	start_enabled = {
		ui_type = "check_box",
		value = true,
		ui_name = "Start Enabled"
	},
	hud_description = {
		ui_type = "text_box",
		value = "",
		ui_name = "Override Description",
		category = "UI"
	},
	sub_description = {
		ui_type = "text_box",
		value = "",
		ui_name = "Override Action Text",
		category = "UI"
	},
	support_simple_animation = {
		ui_type = "check_box",
		value = false,
		ui_name = "Support Simple Animation",
		category = "Animation"
	},
	support_prop_animation = {
		ui_type = "check_box",
		value = false,
		ui_name = "Support State Machine",
		category = "Animation"
	},
	animation_back_speed_modifier = {
		ui_type = "number",
		decimals = 1,
		category = "Animation",
		value = 1,
		ui_name = "Animation Back Speed Modifier",
		step = 0.5
	},
	interactor_item_to_equip = {
		ui_type = "resource",
		value = "",
		ui_name = "Interactor Item to Equip (scanner, decoder, ...)",
		filter = "item"
	},
	emissive_material = {
		ui_type = "text_box",
		value = "emissive_interactable_01",
		ui_name = "Emissive Material",
		category = "Emissive"
	},
	inputs = {
		interactable_enable = {
			accessibility = "public",
			type = "event"
		},
		interactable_disable = {
			accessibility = "public",
			type = "event"
		},
		disable_display_start_event = {
			accessibility = "public",
			type = "event"
		}
	}
}

return Interactable
