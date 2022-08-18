local NpcAnimation = component("NpcAnimation")

NpcAnimation.init = function (self, unit)
	self._bone_lod_id = nil

	if self:get_data(unit, "editor_only") then
		return
	end

	self:enable(unit)

	if DEDICATED_SERVER then
		Unit.disable_animation_state_machine(unit)
	elseif not rawget(_G, "AnimationEditor") and not rawget(_G, "UnitEditor") then
		self:_override_animation(unit)

		if not rawget(_G, "LevelEditor") or not not rawget(_G, "UnitEditor") then
			local use_bone_lod = self:get_data(unit, "use_bone_lod")

			if Managers and Managers.state and Managers.state.bone_lod and use_bone_lod then
				local bone_lod_radius = self:get_data(unit, "bone_lod_radius")
				self._bone_lod_id = Managers.state.bone_lod:register_unit(unit, bone_lod_radius, true)
			end
		else
			Log.info("NpcAnimation", "BoneLod system is not initialized in Editors.")
		end
	end
end

NpcAnimation.enable = function (self, unit)
	return
end

NpcAnimation.disable = function (self, unit)
	return
end

NpcAnimation.destroy = function (self, unit)
	if self._bone_lod_id ~= nil then
		Managers.state.bone_lod:unregister_unit(self._bone_lod_id)

		self._bone_lod_id = nil
	end
end

NpcAnimation._override_animation = function (self, unit)
	local state_machine_resource = self:get_data(unit, "state_machine_override")

	if state_machine_resource ~= nil and state_machine_resource ~= "" then
		Unit.set_animation_state_machine(unit, state_machine_resource)
		Unit.enable_animation_state_machine(unit)

		local init_event = self:get_data(unit, "state_machine_init_event")

		if Unit.has_animation_event(unit, init_event) then
			Unit.animation_event(unit, init_event)
		end
	end

	local bone_mode = self:get_data(unit, "anim_bone_mode")

	if bone_mode ~= "default" then
		Unit.set_animation_bone_mode(unit, bone_mode)
	end
end

NpcAnimation.component_data = {
	editor_only = {
		ui_type = "check_box",
		value = false,
		ui_name = "Editor Only",
		category = "Settings"
	},
	state_machine_override = {
		ui_type = "resource",
		category = "Animation",
		value = "",
		ui_name = "State Machine Override",
		filter = "state_machine"
	},
	state_machine_init_event = {
		ui_type = "text_box",
		value = "",
		ui_name = "State Machine Init Event",
		category = "Animation"
	},
	anim_bone_mode = {
		value = "default",
		ui_type = "combo_box",
		category = "Animation",
		ui_name = "Bone Mode",
		options_keys = {
			"Default",
			"Position and Rotation",
			"Ignore",
			"Transform",
			"Position",
			"Rotation",
			"Scale",
			"Position and Scale",
			"Rotation and Scale"
		},
		options_values = {
			"default",
			"position_and_rotation",
			"ignore",
			"transform",
			"position",
			"rotation",
			"scale",
			"position_and_scale",
			"rotation_and_scale"
		}
	},
	use_bone_lod = {
		ui_type = "check_box",
		value = false,
		ui_name = "Use Bone LOD",
		category = "Bone LOD"
	},
	bone_lod_radius = {
		ui_type = "number",
		decimals = 2,
		category = "Bone LOD",
		value = 0.88,
		ui_name = "Bone LOD Radius",
		step = 0.01
	}
}

return NpcAnimation
