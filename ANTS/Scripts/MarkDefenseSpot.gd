extends Area2D

# Marked Defensive Position Node

var controllingDefPos: bool = false

func _ready():
	Global.defendHere = global_position
	

func _process(delta):
	if !controllingDefPos:
		return
	global_position = get_global_mouse_position()
	

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			controllingDefPos = true
	else:
		if event is InputEventMouseButton and !event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
				Global.defendHere = global_position
				controllingDefPos = false
				get_parent().get_parent().get_node("UI_And_Camera_Scene").lock_target(get_parent().get_parent().get_node("Carl"))
	

func _on_MarkDefenseSpot_tree_exiting():
	# Global markedDefensePos.... save global_position
	Global.defendHere = global_position
	
