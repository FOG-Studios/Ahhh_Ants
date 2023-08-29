extends TileMap

# New Tilemap

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_cell(0, local_to_map(get_global_mouse_position()), 0, Vector2i(5, 3))#, 0)
			
			pass
