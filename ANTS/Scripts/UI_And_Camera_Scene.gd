extends CanvasLayer

# UI and Camera

signal babyOn
signal resetItem
signal saveTileMap

@onready var AntBoard: PackedScene = preload("res://Scenes/AntBoardProfile.tscn")
@onready var food_count: int = Global.food_count
@onready var leaf_count: int = Global.leaf_count
@onready var wood_count: int = Global.wood_count
@onready var pharomone_count = $AntPharomoneButton/PharomoneLabel/Time
#onready var default_zoom_size = .3
#onready var world_check: bool = Global.playerOutside
@onready var spacerNode: Control
@onready var validTarget: Object

var targetLocked: bool = false
var profileCount: int = 0
#var pharomone_used = false
#var cooling_down = false
#var cool_down_time = 240
#var pharomone_time = 30
#var label_count = 0

#func _ready():
#
#	lock_target(get_parent().get_node("Carl"))
#	$BabyControl/AddAnt.set_pressed_no_signal(false)
##	if world_check:
##		$AntPharomoneButton.visible = true
##	else:
##		$AntPharomoneButton.visible = false
##	world_check = get_parent()
##
##	if get_parent().name == "AntHill":
##		$AntPharomoneButton.visible = false
#	if !cooling_down:
#		$AntPharomoneButton/PharomoneLabel/Time.text = str("Home")
##	position = get_parent().carl_pos
#	$FoodIcon/FoodLabel/Amount.text = str(food_count).pad_zeros(2)
#	$LeafIcon/LeafLabel/Amount.text = str(leaf_count).pad_zeros(2)
#	$WoodIcon/WoodLabel/Amount.text = str(wood_count).pad_zeros(2)
#	pharomone_count.text = str(pharomone_time)
	
	

func ready_scene():
	lock_target(get_parent().get_node("Carl"))
	$BabyControl/AddAnt.set_pressed_no_signal(false)
	$FoodIcon/FoodLabel/Amount.text = str(Global.food_count)#.pad_zeros(2)
	$LeafIcon/LeafLabel/Amount.text = str(Global.leaf_count)#.pad_zeros(2)
	$WoodIcon/WoodLabel/Amount.text = str(Global.wood_count)#.pad_zeros(2)
	$FakeAntHillLoadScene2.visible = false
	Global.save_items()
	

func set_camera_limits():
	$Camera2D.limit_left = get_parent().get_node("OutsideCameraBottomLeftLimitPos").global_position.x
	$Camera2D.limit_right = get_parent().get_node("OutsideCameraTopRightLimit").global_position.x
	if !Global.cameraOutside:
		$Camera2D.limit_bottom = 1360
		$Camera2D.limit_top = 0
		
	else:
		$Camera2D.limit_top = get_parent().get_node("OutsideCameraTopRightLimit").global_position.y - 2
		$Camera2D.limit_bottom = get_parent().get_node("OutsideCameraBottomLeftLimitPos").global_position.y
	
	camera_process()
	

func camera_process():
	if !targetLocked:
		return
	$Camera2D.global_position = validTarget.global_position
	await get_tree().create_timer(0.1).timeout
	set_camera_limits()
	

func lock_target(target: Object):
	if !validTarget == null:
		if validTarget.has_method("lock_self"):
			validTarget.lock_self(false)
	targetLocked = false
	validTarget = target
	if validTarget.has_method("return_profile"):
		$WorkerAntProfile.grab_my_body(validTarget)
		$WorkerAntProfile._load_array(validTarget.return_profile())
		$WorkerAntProfile.show()
	if validTarget.has_method("lock_self"):
		validTarget.lock_self(true)
	
	var lockingTween: = create_tween()
	lockingTween.tween_property($Camera2D, "global_position", validTarget.global_position, 1).set_trans(Tween.TRANS_LINEAR)
#	lockingTween.start()
	await lockingTween.finished
	set_target()
	

func set_target():
	targetLocked = true
	set_camera_limits()
	

# Connect signals to keep track of amounts in UI
func connect_this_sig(objectIs: Object, signalName: String, callingFunc: String):
	return objectIs.connect(signalName, Callable(self, callingFunc))
	

func show_food_count(foodAmount: int):
	$FoodIcon/FoodLabel/Amount.text = str(Global.food_count)#.pad_zeros(2)
	Global.save_items()
	

func show_wood_count(woodAmount: int):
	$WoodIcon/WoodLabel/Amount.text = str(Global.wood_count)#.pad_zeros(2)
	Global.save_items()
	

func show_leaf_count(leafAmount: int):
	$LeafIcon/LeafLabel/Amount.text = str(Global.leaf_count)#.pad_zeros(2)
	Global.save_items()
	

func show_pharomone_count():
#	pharomone_count.text = str(label_count)
	pass
	

func _on_PharomoneTimer_timeout():
#	if cooling_down:
#		$AntPharomoneButton/PharomoneLabel.text = str("Cooling Down")
#		cool_down_time -= 1
#		label_count = cool_down_time
#		if cool_down_time <= 0:
#			$AntPharomoneButton/PharomoneLabel.text = str("Home")
#			label_count = cool_down_time 
#			cooling_down = false
#			cool_down_time = 240
#			$PharomoneTimer.stop()
#			label_count = str("30")
#		else:
#			$PharomoneTimer.start(1)
#	elif !cooling_down and pharomone_used:
#		pharomone_time -= 1
#		label_count = pharomone_time
#		if pharomone_time <= 0:
#			var dir_arrow = get_parent().get_node("Carl/BackArrowWhite")
#			dir_arrow.visible = false
#			pharomone_used = false
#			cooling_down = true
#			label_count = cool_down_time
#			$PharomoneTimer.start(1)
#	show_pharomone_count()
	pass
	

func _on_AntPharomoneButton_pressed():
#	if world_check == true and pharomone_used == false and !cooling_down:
#		var dir_arrow = get_parent().get_node("Carl/BackArrowWhite")
#		dir_arrow.visible = true
#		$AntPharomoneButton/PharomoneLabel/Time.text = str("Catching Pharomone")
#		pharomone_time = 30
#		pharomone_used = true
#		$PharomoneTimer.start(1)
#	else:
#		return
#
	pass
	

func _on_UI_And_Camera_Scene_tree_exiting():
	targetLocked = false
	Global.save_items()
	

func add_ant_to_board(antBody: Object, antArray: Array):
	check_for_spacer()
	profileCount += 1
	var antBoard: Object
	antBoard = AntBoard.instantiate()
	$AntProfileControl/ScrollContainer/ProfileGridControl.add_child(antBoard)
	antBoard.connect_to_parent(antBody)
	antBoard.get_my_stats(antArray)
#	yield(get_tree(), "idle_frame")
	
	if profileCount > 4:
		add_spacer()
	$ScrollSetDelayTimer.start()
	

func _on_ScrollSetDelayTimer_timeout():
	$AntProfileControl/ScrollContainer.set_v_scroll(100 + $AntProfileControl/ScrollContainer.scroll_vertical) # set_follow_focus(true)
	

func check_for_spacer():
	if profileCount < $AntProfileControl/ScrollContainer/ProfileGridControl.get_child_count():
		delete_spacer()
	

func delete_spacer():
	$AntProfileControl/ScrollContainer/ProfileGridControl.get_child($AntProfileControl/ScrollContainer/ProfileGridControl.get_child_count()-1).queue_free()
	

func add_spacer():
	spacerNode = Control.new()
	$AntProfileControl/ScrollContainer/ProfileGridControl.add_child(spacerNode)
	

func _on_MinimizeAntBoard_toggled(button_pressed):
	if button_pressed:
		$AntProfileControl.visible = true
	else:
		$AntProfileControl.visible = false
	

func _on_HaveBabyControl_toggled(button_pressed):
	if button_pressed:
		$BabyControl/BabyControlTimer.start()
		$BabyControl/AddAnt.visible = true
	else:
		$BabyControl/BabyControlTimer.stop()
		$BabyControl/AddAnt.visible = false
	

func _on_AddAnt_toggled(button_pressed):
	emit_signal("babyOn", button_pressed)
	

func _on_OpenReset_toggled(button_pressed):
	
	if button_pressed:
		$ResetItemsControl/ResetTimer.start()
		$ResetItemsControl/MarkedButtonControl.visible = true
	else:
		$ResetItemsControl/ResetTimer.stop()
		$ResetItemsControl/MarkedButtonControl.visible = false
	

func _on_FoodSelected_pressed():
	emit_signal("resetItem", "Food")
	

func _on_WoodSelected_pressed():
	emit_signal("resetItem", "Wood")
	

func _on_TextureButton_pressed():
	emit_signal("resetItem", "Leaf")
	

func _on_ResetTimer_timeout():
	$ResetItemsControl/OpenReset.button_pressed = false
	_on_OpenReset_toggled(false)
	

func _on_BabyControlTimer_timeout():
	$BabyControl/HaveBabyControl.button_pressed = false
	_on_HaveBabyControl_toggled(false)
	

func _on_TargetButton_pressed():
	lock_target(get_parent().get_node("GrassMap/MarkDefenseSpot"))
	get_parent().camera_outside(true)
	

func _on_ZoomIn_pressed():
	if !Global.camera == 1:
		$Camera2D.zoom += Vector2(1, 1)
		Global.camera -= 1
	

func _on_ZoomOut_pressed():
	if !Global.camera == 3:
		$Camera2D.zoom -= Vector2(1, 1)
		Global.camera += 1
	

func _on_XButton_button_up():
	$WorkerAntProfile.hide()
	lock_target(get_parent().get_node("Carl"))
	


func _on_build_mode_toggled(button_pressed):
	emit_signal("saveTileMap")
	
