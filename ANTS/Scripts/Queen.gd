extends CharacterBody2D

# Queens Script

signal queenSelected

var fNode: Object
var wNode: Object
var lNode: Object
var myLookSpot: Object
var destination: Vector2 = Vector2.ZERO
var childCount: int = 0
var haveBaby: bool = false
var outside: bool = false

func _ready():
	myLookSpot = get_parent().get_node("InsidePos")
	fNode = get_parent().get_node("FoodStorage")
	wNode = get_parent().get_node("WoodStorage")
	lNode = get_parent().get_node("LeafStorage")
	modulate = Global.antColor
	set_process(false)
	look_at(myLookSpot.global_position)
	

func _items_checked()-> bool:
	if Global.food_count >= 10:
		if Global.wood_count >= 10:
			if Global.leaf_count >= 10:
				return true
	if haveBaby:
		$StartBabyTimer.start()
	return false
	

func have_ant_baby():
	#251
	if !_items_checked():
		return
	if Global.numOfWorkers < 250:
		$BirthingPos/AnimatedSprite2D.visible = true
		$BirthingPos/AnimatedSprite2D.frame = 0
		$BirthingPos/AnimatedSprite2D.play("default")
		fNode.made_withdraw(10)
		wNode.made_withdraw(10)
		lNode.made_withdraw(10)
	

func _process(_delta):
	destination = Vector2.ZERO
	destination = get_global_mouse_position()
	if destination.y <= 388:
		return
	destination = get_global_mouse_position() - global_position
	set_velocity(destination)
	set_up_direction(Vector2.UP)
	move_and_slide()
	destination = velocity
	look_at(myLookSpot.global_position)
	

func _on_Control_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$Camera2D.set_current(true)
			set_process(true)
	if event is InputEventMouseButton and !event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			get_parent().get_node("Carl").get_node("Camera2D").set_current(true)
			set_process(false)
			look_at(myLookSpot.global_position)
	

func check_outside():
	if outside == Global.cameraOutside:
		show()
	else: hide()
	

func _on_AnimatedSprite_animation_finished():
	$BirthingPos/AnimatedSprite2D.visible = false
	get_parent()._add_worker_ant()
	if haveBaby:
		$StartBabyTimer.start()
	

func get_signals(connectedFrom: Object, signalName: String, calledFunc: String):
	return connectedFrom.connect(signalName, Callable(self, calledFunc))
	

func set_babies(isBaby: bool):
	if isBaby:
		$StartBabyTimer.start()
	haveBaby = isBaby
	return haveBaby
	

func _on_StartBabyTimer_timeout():
	if haveBaby:
		have_ant_baby()
	

func _on_SelectionButton_pressed():
	set_process(true)
	emit_signal("queenSelected", self)
	

func _on_SelectionButton_released():
	emit_signal("queenSelected", get_parent().get_node("Carl"))
	set_process(false)
	
