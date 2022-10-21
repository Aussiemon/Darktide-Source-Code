local ProtoUI = {}
package.loaded["scripts/ui/proto_ui/proto_ui"] = ProtoUI

dofile("scripts/ui/proto_ui/proto_ui_core")
dofile("scripts/ui/proto_ui/proto_ui_animation")
dofile("scripts/ui/proto_ui/proto_ui_data")
dofile("scripts/ui/proto_ui/proto_ui_behaviour")
dofile("scripts/ui/proto_ui/proto_ui_layout")
dofile("scripts/ui/proto_ui/proto_ui_input")

return ProtoUI
