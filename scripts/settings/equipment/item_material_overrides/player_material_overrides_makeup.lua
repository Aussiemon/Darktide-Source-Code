-- chunkname: @scripts/settings/equipment/item_material_overrides/player_material_overrides_makeup.lua

local material_overrides = {
	empty_makeup = {
		texture_overrides = {
			makeup_bca = {
				resource = "content/characters/player/human/attachments_base/makeup/default_makeup_bca"
			},
			makeup_rmss = {
				resource = "content/textures/camo_patterns/primary"
			}
		}
	},
	face_makeup_01 = {
		texture_overrides = {
			makeup_bca = {
				resource = "content/characters/player/human/attachments_base/makeup/face_makeup_01/face_makeup_01_bca"
			},
			makeup_rmss = {
				resource = "content/characters/player/human/attachments_base/makeup/face_makeup_01/face_makeup_01_rmss"
			}
		}
	}
}

return material_overrides
