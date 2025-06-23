-- chunkname: @scripts/components/valkyrie_customization.lua

local ValkyrieCustomization = component("ValkyrieCustomization")

ValkyrieCustomization.init = function (self, unit)
	local world = Unit.world(unit)

	self._unit = unit
	self._world = world

	self:_attach_units(unit, world)

	self._body_unit = Unit.get_data(unit, "body_index", 1)

	self:enable(unit)
end

ValkyrieCustomization.editor_validate = function (self, unit)
	return true, ""
end

ValkyrieCustomization._attach_units = function (self, unit, world)
	self:_build_valkyrie(1, unit, world, self:get_data(unit, "body_node"), self:_combine_string(self:get_data(unit, "body")))
	self:_build_valkyrie(2, unit, world, self:get_data(unit, "cockpit_node"), self:_combine_string(self:get_data(unit, "cockpit")))
	self:_build_valkyrie(3, unit, world, self:get_data(unit, "interior_node"), self:_combine_string(self:get_data(unit, "interior")))
	self:_build_valkyrie(4, unit, world, self:get_data(unit, "thruster_node_01"), self:_combine_string(self:get_data(unit, "thruster")))
	self:_build_valkyrie(5, unit, world, self:get_data(unit, "thruster_node_02"), self:_combine_string(self:get_data(unit, "thruster")))
	self:_build_valkyrie(6, unit, world, self:get_data(unit, "floodlight_node"), self:_combine_string(self:get_data(unit, "floodlight")))
	self:_build_valkyrie(7, unit, world, self:get_data(unit, "hatch_node"), self:_combine_string(self:get_data(unit, "hatch")))
	self:_build_valkyrie(8, unit, world, self:get_data(unit, "backhatch_node"), self:_combine_string(self:get_data(unit, "backhatch")))
	self:_build_valkyrie(9, unit, world, self:get_data(unit, "wingflaps_node"), self:_combine_string(self:get_data(unit, "wingflaps")))
	self:_build_valkyrie(10, unit, world, self:get_data(unit, "landinggear_node_01"), self:_combine_string(self:get_data(unit, "landinggear")))
	self:_build_valkyrie(11, unit, world, self:get_data(unit, "landinggear_node_02"), self:_combine_string(self:get_data(unit, "landinggear")))
	self:_build_valkyrie(12, unit, world, self:get_data(unit, "landinggear_node_03"), self:_combine_string(self:get_data(unit, "landinggear")))
	self:_build_valkyrie(13, unit, world, self:get_data(unit, "landinggear_node_04"), self:_combine_string(self:get_data(unit, "landinggear")))
	self:_build_valkyrie(14, unit, world, self:get_data(unit, "sidedoor_node_01"), self:_combine_string(self:get_data(unit, "sidedoor_01")))
	self:_build_valkyrie(15, unit, world, self:get_data(unit, "sidedoor_node_02"), self:_combine_string(self:get_data(unit, "sidedoor_02")))
	self:_build_valkyrie(16, unit, world, self:get_data(unit, "propeller_type_01_01_node"), self:_combine_string(self:get_data(unit, "propeller_type_01")))
	self:_build_valkyrie(17, unit, world, self:get_data(unit, "propeller_type_01_02_node"), self:_combine_string(self:get_data(unit, "propeller_type_01")))
	self:_build_valkyrie(18, unit, world, self:get_data(unit, "propeller_type_01_03_node"), self:_combine_string(self:get_data(unit, "propeller_type_01")))
	self:_build_valkyrie(19, unit, world, self:get_data(unit, "propeller_type_01_04_node"), self:_combine_string(self:get_data(unit, "propeller_type_01")))
	self:_build_valkyrie(20, unit, world, self:get_data(unit, "propeller_type_02_01_node"), self:_combine_string(self:get_data(unit, "propeller_type_02")))
	self:_build_valkyrie(21, unit, world, self:get_data(unit, "propeller_type_02_02_node"), self:_combine_string(self:get_data(unit, "propeller_type_02")))
	self:_build_valkyrie(22, unit, world, self:get_data(unit, "sidearm_node"), self:_combine_string(self:get_data(unit, "sidearm")))
end

ValkyrieCustomization._combine_string = function (self, unit_name)
	local base_path = ""

	if unit_name == nil then
		return
	end

	return base_path .. unit_name
end

ValkyrieCustomization._build_socket = function (self, unit, world, spawned, landinggear_index)
	local lgi = "0" .. tostring(landinggear_index)
	local socket_node = Unit.node(unit, "anim_valkyrie_" .. lgi .. "_landinggear_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_valkyrie_01_landinggear_01"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_landinggear_" .. lgi .. "_piston_01_bottom_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_landinggear_01_piston_01_bottom"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_landinggear_" .. lgi .. "_piston_02_bottom_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_landinggear_01_piston_02_bottom"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_valkyrie_" .. lgi .. "_landinggear_foot_01_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_valkyrie_01_landinggear_foot_01"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_valkyrie_" .. lgi .. "_landinggear_foot_02_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_valkyrie_01_landinggear_foot_02"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_landinggear_" .. lgi .. "_piston_01_top_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_landinggear_01_piston_01_top"), unit, socket_node, World.LINK_MODE_MAP_NAME)

	socket_node = Unit.node(unit, "anim_landinggear_" .. lgi .. "_piston_02_top_node")

	World.link_unit(world, spawned, Unit.node(spawned, "anim_landinggear_01_piston_02_top"), unit, socket_node, World.LINK_MODE_MAP_NAME)
end

ValkyrieCustomization._build_valkyrie = function (self, index, unit, world, node_name, unit_name)
	if unit_name == nil then
		return
	end

	local socket_node = Unit.node(unit, node_name)
	local socket_pos = Unit.world_position(unit, socket_node)
	local socket_rot = Unit.world_rotation(unit, socket_node)
	local scale = Unit.local_scale(unit, 1)

	if Unit.has_node(unit, "op_scale") then
		local valk_scale = self:get_data(unit, "valkyrie_scale")

		scale = Vector3(valk_scale, valk_scale, valk_scale)

		local node_index = Unit.node(unit, "op_scale")

		Unit.set_local_scale(unit, node_index, scale)

		node_index = Unit.node(unit, "anim_global")

		Unit.set_local_scale(unit, node_index, scale)
	end

	local pose = Matrix4x4.from_quaternion_position_scale(socket_rot, socket_pos, scale)
	local spawned = World.spawn_unit_ex(world, unit_name, nil, pose)

	if string.find(node_name, "backhatch") then
		self._backhatch = spawned
	end

	Unit.set_data(unit, "attached_items", index, spawned)

	if string.find(node_name, self:get_data(unit, "body_node")) then
		Unit.set_data(unit, "body_index", 1, spawned)
	end

	if string.find(node_name, "ap_valkyrie_landinggear_01") then
		World.link_unit(world, spawned, 1, unit, socket_node, World.LINK_MODE_NODE_NAME)
	elseif string.find(node_name, "landinggear") then
		World.link_unit(world, spawned, 1, unit, socket_node, World.LINK_MODE_MAP_NAME)

		if string.find(node_name, "2") then
			self:_build_socket(unit, world, spawned, 2)
		elseif string.find(node_name, "3") then
			self:_build_socket(unit, world, spawned, 3)
		elseif string.find(node_name, "4") then
			self:_build_socket(unit, world, spawned, 4)
		end
	elseif string.find(node_name, "backhatch") then
		World.link_unit(world, spawned, 1, unit, socket_node, World.LINK_MODE_NODE_NAME)
	else
		World.link_unit(world, spawned, 1, unit, socket_node, World.LINK_MODE_NODE_NAME)
	end
end

ValkyrieCustomization.enable = function (self, unit)
	return
end

ValkyrieCustomization.disable = function (self, unit)
	return
end

ValkyrieCustomization.destroy = function (self, unit)
	local world = self._world
	local unit_alive, unit_get_data, unit_set_data = Unit.alive, Unit.get_data, Unit.set_data

	for i = 1, Unit.data_table_size(unit, "attached_items") do
		if unit_alive(unit_get_data(unit, "attached_items", i)) ~= false then
			World.destroy_unit(world, unit_get_data(unit, "attached_items", i))
			unit_set_data(unit, "attached_items", i, nil)
		end
	end
end

ValkyrieCustomization.VFX_off = function (self)
	Unit.flow_event(self._body_unit, "VFX_off")
end

ValkyrieCustomization.VFX_vtol_thrusters_on = function (self)
	Unit.flow_event(self._body_unit, "VFX_vtol_thrusters_on")
end

ValkyrieCustomization.VFX_vtol_thrusters_off = function (self)
	Unit.flow_event(self._body_unit, "VFX_vtol_thrusters_off")
end

ValkyrieCustomization.VFX_thrusters_on = function (self)
	Unit.flow_event(self._body_unit, "VFX_thrusters_on")
end

ValkyrieCustomization.VFX_thrusters_off = function (self)
	Unit.flow_event(self._body_unit, "VFX_thrusters_off")
end

ValkyrieCustomization.VFX_ignition_on = function (self)
	Unit.flow_event(self._body_unit, "VFX_ignition_on")
end

ValkyrieCustomization.VFX_ignition_off = function (self)
	Unit.flow_event(self._body_unit, "VFX_ignition_off")
end

ValkyrieCustomization.SFX_lift = function (self)
	Unit.flow_event(self._body_unit, "SFX_lift")
end

ValkyrieCustomization.SFX_land = function (self)
	Unit.flow_event(self._body_unit, "SFX_land")
end

ValkyrieCustomization.SFX_land_finish = function (self)
	Unit.flow_event(self._body_unit, "SFX_land_finish")
end

ValkyrieCustomization.SFX_idle = function (self)
	Unit.flow_event(self._body_unit, "SFX_idle")
end

ValkyrieCustomization.SFX_jets = function (self)
	Unit.flow_event(self._body_unit, "SFX_jets")
end

ValkyrieCustomization.SFX_intro_gen = function (self)
	Unit.flow_event(self._body_unit, "SFX_intro_gen")
end

ValkyrieCustomization.SFX_lascannon_charge = function (self)
	Unit.flow_event(self._body_unit, "SFX_lascannon_charge")
end

ValkyrieCustomization.SFX_lascannon_fire = function (self)
	Unit.flow_event(self._body_unit, "SFX_lascannon_fire")
end

ValkyrieCustomization.SFX_rocket_launch = function (self)
	Unit.flow_event(self._body_unit, "SFX_rocket_launch")
end

ValkyrieCustomization.SFX_off = function (self)
	Unit.flow_event(self._body_unit, "SFX_off")
end

ValkyrieCustomization.fx_takeoff = function (self)
	Unit.flow_event(self._body_unit, "fx_takeoff")
end

ValkyrieCustomization.fx_takeoff_intro = function (self)
	Unit.flow_event(self._body_unit, "fx_takeoff_intro")
end

ValkyrieCustomization.fx_lift = function (self)
	Unit.flow_event(self._body_unit, "fx_lift")
end

ValkyrieCustomization.fx_idle = function (self)
	Unit.flow_event(self._body_unit, "fx_idle")
end

ValkyrieCustomization.fx_thrusters_off = function (self)
	Unit.flow_event(self._body_unit, "fx_thrusters_off")
end

ValkyrieCustomization.fx_land = function (self)
	Unit.flow_event(self._body_unit, "fx_land")
end

ValkyrieCustomization.fx_landed = function (self)
	Unit.flow_event(self._body_unit, "fx_landed")
end

ValkyrieCustomization.lights_enter = function (self)
	Unit.flow_event(self._backhatch, "lights_enter")
end

ValkyrieCustomization.lights_exit = function (self)
	Unit.flow_event(self._backhatch, "lights_exit")
end

ValkyrieCustomization.lights_off = function (self)
	Unit.flow_event(self._backhatch, "lights_off")
end

ValkyrieCustomization.component_data = {
	body = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "content/environment/artsets/imperial/global/props/machinery/valkyrie/valkyrie_01",
		ui_name = "Body",
		filter = "unit"
	},
	body_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_01",
		ui_name = "Body Node",
		category = "Parts"
	},
	cockpit = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Cockpit",
		filter = "unit"
	},
	cockpit_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_cockpit_01",
		ui_name = "Cockpit Node",
		category = "Parts"
	},
	interior = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Interior",
		filter = "unit"
	},
	interior_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_interior_01",
		ui_name = "Interior Node",
		category = "Parts"
	},
	thruster = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Thruster",
		filter = "unit"
	},
	thruster_node_01 = {
		ui_type = "text_box",
		value = "ap_valkyrie_thruster_01_01",
		ui_name = "Thruster Node 01",
		category = "Parts"
	},
	thruster_node_02 = {
		ui_type = "text_box",
		value = "ap_valkyrie_thruster_01_02",
		ui_name = "Thruster Node 02",
		category = "Parts"
	},
	floodlight = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Floodlight",
		filter = "unit"
	},
	floodlight_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_floodlight_01",
		ui_name = "Floodlight Node",
		category = "Parts"
	},
	hatch = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Hatch",
		filter = "unit"
	},
	hatch_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_hatch_01",
		ui_name = "Hatch Node",
		category = "Parts"
	},
	backhatch = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Back Hatch",
		filter = "unit"
	},
	backhatch_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_backhatch_01",
		ui_name = "Back Hatch Node",
		category = "Parts"
	},
	wingflaps = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "content/environment/artsets/imperial/global/props/machinery/valkyrie/valkyrie_wingflaps_01",
		ui_name = "Wingflaps",
		filter = "unit"
	},
	wingflaps_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_wingflaps_01",
		ui_name = "Wingflaps Node",
		category = "Parts"
	},
	landinggear = {
		ui_type = "resource",
		preview = true,
		category = "Landing Gear",
		value = "",
		ui_name = "Landing Gear",
		filter = "unit"
	},
	not_used = {
		ui_type = "check_box",
		value = false,
		ui_name = "Landing Gears are special, ask a TA/Coder.",
		category = "Landing Gear"
	},
	landinggear_node_01 = {
		ui_type = "text_box",
		value = "ap_valkyrie_landinggear_01",
		ui_name = "Landing Gear Node 01",
		category = "Landing Gear"
	},
	landinggear_node_02 = {
		ui_type = "text_box",
		value = "ap_valkyrie_landinggear_02",
		ui_name = "Landing Gear Node 02",
		category = "Landing Gear"
	},
	landinggear_node_03 = {
		ui_type = "text_box",
		value = "ap_valkyrie_landinggear_03",
		ui_name = "Landing Gear Node 03",
		category = "Landing Gear"
	},
	landinggear_node_04 = {
		ui_type = "text_box",
		value = "ap_valkyrie_landinggear_04",
		ui_name = "Landing Gear Node 04",
		category = "Landing Gear"
	},
	sidedoor_01 = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Side Door Left",
		filter = "unit"
	},
	sidedoor_node_01 = {
		ui_type = "text_box",
		value = "ap_side_door_01",
		ui_name = "Side Door Left Node",
		category = "Parts"
	},
	sidedoor_02 = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Side Door Right",
		filter = "unit"
	},
	sidedoor_node_02 = {
		ui_type = "text_box",
		value = "ap_side_door_02",
		ui_name = "Side Door Right Node",
		category = "Parts"
	},
	propeller_type_01 = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Propeller Type 01",
		filter = "unit"
	},
	propeller_type_01_01_node = {
		ui_type = "text_box",
		value = "ap_propeller_01_01",
		ui_name = "Propeller Type 01 Node",
		category = "Parts"
	},
	propeller_type_01_02_node = {
		ui_type = "text_box",
		value = "ap_propeller_01_02",
		ui_name = "Propeller Type 01 Node",
		category = "Parts"
	},
	propeller_type_01_03_node = {
		ui_type = "text_box",
		value = "ap_propeller_01_03",
		ui_name = "Propeller Type 01 Node",
		category = "Parts"
	},
	propeller_type_01_04_node = {
		ui_type = "text_box",
		value = "ap_propeller_01_04",
		ui_name = "Propeller Type 01 Node",
		category = "Parts"
	},
	propeller_type_02 = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Propeller Type 02",
		filter = "unit"
	},
	propeller_type_02_01_node = {
		ui_type = "text_box",
		value = "ap_propeller_02_01",
		ui_name = "Propeller Type 02 Node",
		category = "Parts"
	},
	propeller_type_02_02_node = {
		ui_type = "text_box",
		value = "ap_propeller_02_02",
		ui_name = "Propeller Type 02 Node",
		category = "Parts"
	},
	sidearm = {
		ui_type = "resource",
		preview = true,
		category = "Parts",
		value = "",
		ui_name = "Side Arm",
		filter = "unit"
	},
	sidearm_node = {
		ui_type = "text_box",
		value = "ap_valkyrie_sidearm_01",
		ui_name = "Side Arm Node",
		category = "Parts"
	},
	valkyrie_scale = {
		ui_type = "number",
		decimals = 2,
		value = 1,
		ui_name = "Valkyrie Scale (Only use on op_base_platform)",
		step = 0.01
	},
	inputs = {
		VFX_off = {
			accessibility = "public",
			type = "event"
		},
		VFX_vtol_thrusters_on = {
			accessibility = "public",
			type = "event"
		},
		VFX_vtol_thrusters_off = {
			accessibility = "public",
			type = "event"
		},
		VFX_thrusters_on = {
			accessibility = "public",
			type = "event"
		},
		VFX_thrusters_off = {
			accessibility = "public",
			type = "event"
		},
		VFX_ignition_on = {
			accessibility = "public",
			type = "event"
		},
		VFX_ignition_off = {
			accessibility = "public",
			type = "event"
		},
		SFX_lift = {
			accessibility = "public",
			type = "event"
		},
		SFX_land = {
			accessibility = "public",
			type = "event"
		},
		SFX_land_finish = {
			accessibility = "public",
			type = "event"
		},
		SFX_idle = {
			accessibility = "public",
			type = "event"
		},
		SFX_jets = {
			accessibility = "public",
			type = "event"
		},
		SFX_intro_gen = {
			accessibility = "public",
			type = "event"
		},
		SFX_lascannon_charge = {
			accessibility = "public",
			type = "event"
		},
		SFX_lascannon_fire = {
			accessibility = "public",
			type = "event"
		},
		SFX_rocket_launch = {
			accessibility = "public",
			type = "event"
		},
		SFX_off = {
			accessibility = "public",
			type = "event"
		},
		fx_takeoff = {
			accessibility = "public",
			type = "event"
		},
		fx_takeoff_intro = {
			accessibility = "public",
			type = "event"
		},
		fx_lift = {
			accessibility = "public",
			type = "event"
		},
		fx_idle = {
			accessibility = "public",
			type = "event"
		},
		fx_thrusters_off = {
			accessibility = "public",
			type = "event"
		},
		fx_land = {
			accessibility = "public",
			type = "event"
		},
		fx_landed = {
			accessibility = "public",
			type = "event"
		},
		lights_enter = {
			accessibility = "public",
			type = "event"
		},
		lights_exit = {
			accessibility = "public",
			type = "event"
		},
		lights_off = {
			accessibility = "public",
			type = "event"
		}
	}
}

return ValkyrieCustomization
