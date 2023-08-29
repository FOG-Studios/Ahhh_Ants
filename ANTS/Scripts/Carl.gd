extends CharacterBody2D

# Carl Script

signal removeDirt
signal notDirt

@onready var home
@onready var GPS: NavigationAgent2D = $NavigationAgent2D

var cameraLocked: bool = false
var max_speed = 400
var speed = 10
var acceleration = 1200
var moving = false
var destination = Vector2()
var movement = Vector2()
var nextPoint: Vector2 = Vector2.ZERO
var outside = false
var dirtRemoval: Vector2 = Vector2.ZERO
@onready var NAVI: bool = true

func _ready():
	if !Global.antColor == null:
		self.modulate = Global.antColor
	else:
		self.modulate = Color.LIGHT_SALMON
	

func get_movement(moveTo: Vector2):
	moving = true
	destination = moveTo
	GPS.set_target_position(destination)
	look_at(destination)
	$AnimationPlayer.play("Walk")
	

func connect_signals(signalObject: Object, signalName: String, calledFunc: String):
	return signalObject.connect(signalName, Callable(self, calledFunc))
	

func check_outside():
	if cameraLocked:
		return
	if outside == Global.cameraOutside:
		show()
	else: hide()
	

func _physics_process(delta):
	movement_loop(delta)
	

func navi_move()-> Vector2:
	nextPoint = GPS.get_next_path_position()
	look_at(nextPoint)
	return nextPoint
	

func movement_loop(delta):
	destination = navi_move()
	if outside:
		home = get_parent().get_node("InsidePos").global_position
		if Global.day_time:
			$BackArrowWhite.look_at(home)
	if moving == false:
		speed = 0
		$AnimationPlayer.play("Idle")
	else:
		speed = acceleration * delta
		if speed > max_speed:
			speed = max_speed
	movement = position.direction_to(destination) * speed
#	move_direction = rad2deg(destination.angle_to_point(position))
	if position.distance_to(destination) > 5:
		set_velocity(movement)
		move_and_slide()
		movement = velocity
	else:
		moving = false

func _on_DirtDeleteTimer_timeout():
	if $DirtCheck.get_collision_point() == dirtRemoval:
		emit_signal("removeDirt")

func _on_DirtCheckArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("removeDirt", get_global_mouse_position())
	

func lock_self(isLocked: bool):
	if isLocked:
		get_parent().camera_outside(outside)
	cameraLocked = isLocked
	

func _on_OutsideDetection_area_entered(area):
	if area:
		outside = true
		$BackArrowWhite.visible = true
	if cameraLocked:
		get_parent().camera_outside(true)
	

func _on_OutsideDetection_area_exited(area):
	if area:
		outside = false
		$BackArrowWhite.visible = false
	if cameraLocked:
		get_parent().camera_outside(false)
	

#
#
#func _unhandled_input(event):
#	if event.is_action_pressed("walk_to"):
##		if !$DirtCheck.is_colliding():
##			emit_signal("notDirt")
#		moving = true
#		destination = get_global_mouse_position()
#		GPS.set_target_location(destination)
#		if !GPS.is_target_reachable():
#			return
##			GPS.set_target_location(destination)
#		look_at(destination)
#
#		$AnimationPlayer.play("Walk")
#	if event is InputEventScreenTouch and event.pressed:
#		if event.pressed:
#			moving = true
#			destination = get_global_mouse_position()
#			GPS.set_target_location(destination)
#			look_at(destination)
#			$AnimationPlayer.play("Walk")
#



