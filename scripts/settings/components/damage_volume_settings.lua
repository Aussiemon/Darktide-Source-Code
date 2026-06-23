-- chunkname: @scripts/settings/components/damage_volume_settings.lua

DamageVolumeSettings = DamageVolumeSettings or {}
DamageVolumeSettings.electrical = {
	buff_template_name = "damage_volume_electrical",
}
DamageVolumeSettings.burning = {
	buff_template_name = "damage_volume_burning",
	forbidden_keyword = "damage_volume_burning",
}
DamageVolumeSettings.instakill = {
	buff_template_name = "damage_volume_instakill",
	forbidden_keyword = "damage_volume_instakill",
}

return DamageVolumeSettings
