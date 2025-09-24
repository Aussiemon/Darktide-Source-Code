-- chunkname: @scripts/settings/components/damage_volume_settings.lua

DamageVolumeSettings = DamageVolumeSettings or {}
DamageVolumeSettings.electrical = {
	buff_template_name = "damage_volume_electrical",
	forbidden_keyword = "damage_volume_electrical",
}
DamageVolumeSettings.radioactive = {
	buff_template_name = "damage_volume_radioactive",
	forbidden_keyword = "damage_volume_radioactive",
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
