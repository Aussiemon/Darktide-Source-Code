-- chunkname: @scripts/extension_systems/buff/projectile_unit_buff_extension.lua

require("scripts/extension_systems/buff/buff_extension_base")

local Ailment = require("scripts/utilities/ailment")
local BuffExtensionInterface = require("scripts/extension_systems/buff/buff_extension_interface")
local BuffTemplates = require("scripts/settings/buff/buff_templates")
local BuffExtensionBase = require("scripts/extension_systems/buff/buff_extension_base")
local FixedFrame = require("scripts/utilities/fixed_frame")
local EMPTY_TABLE = {}
local ProjectileUnitBuffExtension = class("ProjectileUnitBuffExtension")

ProjectileUnitBuffExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id)
	local owner_unit = extension_init_data.owner_unit

	self._owner_unit = owner_unit

	local is_server = extension_init_context.is_server

	self._is_server = is_server
	self._stat_buffs = extension_init_data.stat_buffs
	self._keywords = extension_init_data.keywords
end

ProjectileUnitBuffExtension.hot_join_sync = function (self, unit, sender, channel)
	return
end

ProjectileUnitBuffExtension.game_object_initialized = function (self, game_session, game_object_id)
	return
end

ProjectileUnitBuffExtension.update = function (self, unit, dt, t)
	return
end

ProjectileUnitBuffExtension.keywords = function (self)
	if not self._is_server then
		local exception_message = string.format("A non-server is trying to access keywords on a projectile")

		Log.exception("ProjectileUnitBuffExtension", exception_message)
	end

	return self._keywords
end

ProjectileUnitBuffExtension.has_keyword = function (self, keyword)
	if not self._is_server then
		local exception_message = string.format("A non-server is trying to access keywords on a projectile")

		Log.exception("ProjectileUnitBuffExtension", exception_message)
	end

	return not not self._keywords[keyword]
end

ProjectileUnitBuffExtension.stat_buffs = function (self)
	if not self._is_server then
		local exception_message = string.format("A non-server is trying to access stat buffs on a projectile")

		Log.exception("ProjectileUnitBuffExtension", exception_message)
	end

	return self._stat_buffs
end

ProjectileUnitBuffExtension.buffs = function (self)
	return EMPTY_TABLE
end

ProjectileUnitBuffExtension.refresh_duration_of_stacking_buff = function (self, buff_name, t)
	return
end

ProjectileUnitBuffExtension.is_frame_unique_proc = function (self, event, unique_key)
	return
end

ProjectileUnitBuffExtension.current_stacks = function (self, buff_name)
	return 0
end

ProjectileUnitBuffExtension.request_proc_event_param_table = function (self)
	return nil
end

ProjectileUnitBuffExtension.set_frame_unique_proc = function (self, event, unique_key)
	ferror("ProjectileUnitBuffExtension can't proc but triggered set_frame_unique_proc on %s, %s", event, unique_key)
end

ProjectileUnitBuffExtension.add_proc_event = function (self, event, params)
	ferror("ProjectileUnitBuffExtension can't proc but triggered proc event %s", event)
end

ProjectileUnitBuffExtension.add_internally_controlled_buff = function (self, template_name, t, ...)
	ferror("Can't add buffs to ProjectileUnitBuffExtension, tried to add buff %s", template_name)
end

ProjectileUnitBuffExtension.add_externally_controlled_buff = function (self, template_name, t, ...)
	ferror("Can't add buffs to ProjectileUnitBuffExtension, tried to add buff %s", template_name)
end

ProjectileUnitBuffExtension.remove_externally_controlled_buff = function (self, local_index)
	ferror("Can't remove buffs to ProjectileUnitBuffExtension but tried to remove buff with local index %d", local_index)
end

ProjectileUnitBuffExtension._remove_internally_controlled_buff = function (self, local_index)
	ferror("Can't remove buffs to ProjectileUnitBuffExtension but tried to remove buff with local index %d", local_index)
end

ProjectileUnitBuffExtension._remove_buff = function (self, index)
	ferror("Can't remove buffs to ProjectileUnitBuffExtension but tried to remove buff with index %d", index)
end

ProjectileUnitBuffExtension.rpc_add_buff = function (self, ...)
	ferror("Can't add buffs to ProjectileUnitBuffExtension, but tried to add buffs troguh rpc")
end

ProjectileUnitBuffExtension.rpc_remove_buff = function (self, ...)
	ferror("Can't remove buffs to ProjectileUnitBuffExtension, but tried to remove buffs troguh rpc")
end

ProjectileUnitBuffExtension.rpc_buff_proc_set_active_time = function (self, ...)
	ferror("ProjectileUnitBuffExtension can't activate a buff")
end

ProjectileUnitBuffExtension.rpc_buff_set_start_time = function (self, channel_id, game_object_id, server_index, activation_frame)
	ferror("ProjectileUnitBuffExtension can't start a buff")
end

ProjectileUnitBuffExtension.rpc_buff_set_extra_duration = function (self, channel_id, game_object_id, server_index, activation_frame)
	ferror("ProjectileUnitBuffExtension can't add extra duration")
end

implements(ProjectileUnitBuffExtension, BuffExtensionInterface)

return ProjectileUnitBuffExtension
