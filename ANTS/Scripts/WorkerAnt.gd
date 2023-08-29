extends CharacterBody2D

# Worker Ant Script

signal imSelectedNow

@onready var myTileMap: TileMap
@onready var speed: float = $NavigationAgent2D.max_speed
@onready var UIconnect: Object = get_parent().get_node("UI_And_Camera_Scene")
@onready var IDLE: bool = true
@onready var myDict: Array = []
@onready var NAVI: NavigationAgent2D = $NavigationAgent2D
@onready var outside: bool = false

@export var myNum: int

var EnemyAnt: Object
var enemyAntArray: Array = []

var isActive: bool = false
var taskComplete: bool = false
var hungry: bool = false
var eating: bool = false
var cameraLocked: bool = false
var enemyInArea: bool = false
var inDefense: bool = false
var defensePos: bool = false
var selfStorageFull: bool = false
var iHaveBody: bool = false
var specialActivity: bool = false
var onAssignment: bool = false

var currentItem: String
var nextActivity: String
var currentActivity: String = "Lazy"
var givenName

var movement: Vector2 = Vector2.ZERO
var destination: Vector2 = Vector2.ZERO
var nextPoint: Vector2 = Vector2.ZERO

var randSpeedMod: float

var health: int = 3
var jobFromMajesty: int
var specialFoodTask: int = 0
var specialWoodTask: int = 0
var specialLeafTask: int = 0

func _ready():
	var tileMap: = NAVI.get_navigation_map()
	print(tileMap)
	randomize()
	if Global.day_time:
		isActive = true
	check_outside()
	randSpeedMod = randf_range(0.5, 0.99)
	if !Global.antColor == null:
		$AntBody.modulate = Global.antColor
		$RadarSprite.modulate = Global.antColor
	else:
		# Used when testing the Worker Ant.
		# You must have a color set.
		$AntBody.modulate = Color.LIGHT_SALMON
		$RadarSprite.modulate = Color.LIGHT_SALMON
	await get_tree().create_timer(1).timeout
	

func _scene_ready():
	$StorageCheckTimer.start(1)
	

func connect_tile_map(myMap):
	myTileMap = myMap
	print(myMap.name, " is my map")

func _connect_my_signals(parentNode: Object, signalName: String, calledFunc: String):
	return parentNode.connect(signalName, Callable(self, calledFunc))
	

func build_my_stats():
	jobFromMajesty = Global.get_job()
	var loc: Vector2 = global_position
	givenName = "Ant " + str(Global.numOfWorkers + 1)
	currentItem = "False"
	currentActivity = "Lazy"
	outside = false
	selfStorageFull = false
	Global.add_new_ant_to_dict(givenName, currentItem, currentActivity, loc, outside, selfStorageFull)
	
	if jobFromMajesty == 1:
		get_food()
	elif jobFromMajesty == 2:
		get_wood()
	elif jobFromMajesty == 3:
		get_leaf()
	else: defend_area()
	
	add_ant_board()
	

func global_build_my_stats(dictNum: int)-> Array:
	return Global.build_worker_ant_dict(dictNum)
	

#	antDict[nodeName] = {
#		"MyName": givenName, 
#		"IHave": currentItem, 
#		"IdoThis": currentActivity, 
#		"IHere": location, 
#		"InOrOut": isOutside
#	}

func day_changed():
	if !Global.day_time:
		isActive = false
		if outside:
			var randAmountX: float = randf_range(-16, 16)
			var randAmountY: float = randf_range(-16, 16)
			NAVI.set_target_position(get_parent().get_node("InsidePos").global_position + Vector2(randAmountX, randAmountY))
			IDLE = false
			$AnimationPlayer.play("Walk")
		else:
			if !selfStorageFull:
				lazy_movement()
	else:
		isActive = true
		resume_task()
	

func set_my_num(idNum: int):
	myNum = idNum
	set_my_dict()
	return myNum
	

func set_my_dict():
	myDict = global_build_my_stats(myNum)
	if myDict.is_empty():
		build_my_stats()
		return
	givenName = myDict[0]
	currentItem = myDict[1]
	set_current_activity(myDict[2])
	global_position = myDict[3]
	outside = myDict[4]
	selfStorageFull = myDict[5]
	add_ant_board()
	if selfStorageFull:
		resume_task()
		get_node(currentItem).visible = true
	nextActivity = currentActivity
	if currentActivity == "inDefense":
		inDefense = true
	

func update_my_dict():
	Global.update_my_dict(myNum, givenName, currentItem, nextActivity, global_position, outside, selfStorageFull)
	

func storage_moved():
	if !currentItem == "False":
		check_storage()
	


func check_outside():
	if cameraLocked:
		return
	if outside == Global.cameraOutside:
		show()
	else: hide()
	


func set_myName(new_text):
	givenName = new_text
	return givenName
	

func get_food():
	nextActivity = "Food"
	if !selfStorageFull:
		currentItem = nextActivity
		resume_task()
	return currentItem
	

func get_leaf():
	nextActivity = "Leaf"
	if !selfStorageFull:
		currentItem = nextActivity
		resume_task()
	return currentItem
	

func get_wood():
	nextActivity = "Wood"
	if !selfStorageFull:
		currentItem = nextActivity
		resume_task()
	return currentItem
	

func go_eat():
	set_current_activity("Eating")
	var yRandLocInNest: float = randf_range(-32, 32)
	var xRandLocInNest: float = randf_range(-32, 32)
	NAVI.set_target_position(Vector2(global_position.x + xRandLocInNest, global_position.y + yRandLocInNest))
#	if !NAVI.is_target_reachable():
#		$AnimationPlayer.play("Idle")
#		IDLE = true
#		print("I'M STARVING")
#		return go_eat()
	eating = true
	IDLE = false
	$AnimationPlayer.play("Walk")
	print("I'm Hungry")
	

func set_special_activity():
	get_node(currentActivity).visible = true
#	if currentActivity == "Food":
#
#		pass
#	elif currentActivity == "Wood":
#
#		pass
#
#	elif currentActivity == "Leaf":
#
#
#		pass
#	else:
#		return
	onAssignment = true
	
	
	pass

func set_current_activity(newActivity: String):
	currentActivity = newActivity
	return currentActivity
	

func lazy_movement():
	set_current_activity("Lazy")
#	var yRandLocInNest: float = randf_range(400, 2018)
#	var xRandLocInNest: float = randf_range(16, 1120)
	var randInt: int = randi_range(0, (Global.savedAntHillNavis.size() - 1))
	var randVector: Vector2
	randVector = Global.savedAntHillNavis[randInt]
	NAVI.set_target_position(myTileMap.map_to_local(randVector))
#	NAVI.set_target_position(Vector2(xRandLocInNest, yRandLocInNest))
	
#	if !NAVI.is_target_reachable():
#		$AnimationPlayer.play("Idle")
#		IDLE = true
#		$LazyTimer.start()
#		return
	$AnimationPlayer.play("Walk")
	IDLE = false
	

func _on_LazyTimer_timeout():
	lazy_movement()
	

func defend_area():
	inDefense = true
	nextActivity = "InDefense"
	var randX: float = randf_range(randi() % -32 + -8, randi() % 32 + 8)
	var randY: float = randf_range(randi() % -32 + -8, randi() % 32 + 8)
	print(" X ", randX, " Y ",randY)
	
	if !selfStorageFull:
		IDLE = false
		$AnimationPlayer.play("Walk")
		NAVI.set_target_position(Global.defendHere + Vector2(randX, randY))
	

func _complete_task():
	if onAssignment:
		get_node(currentActivity).visible = false
	if eating:
		$EatTimer.start()
		return
	if iHaveBody:
		taskComplete = true
		$TaskCompleteArea.set_deferred("monitoring", true)
		return
	if inDefense:
		defensePos = true
	$StorageCheckTimer.start(1.0)
	
	
	

# 384 - 2018

func resume_task():
	if selfStorageFull:
		check_storage()
		return
	elif hungry and Global.food_count > 0:
#		if currentActivity == "Food":
#			set_current_activity("Eating")
#			$TaskCompleteArea.set_deferred("monitoring", true)
#			return
#		elif !currentActivity == "Eating":
		set_current_activity("Eating")
		NAVI.set_target_position(Global.storageSavedLoc["Food"])
		
		print("I'm checking for food ", Global.day_time)
	elif !isActive:
		lazy_movement()
	elif nextActivity == "Food":
		currentItem = "Food"
		set_current_activity("Food")
		if Global.foodMarked:
			NAVI.set_target_position(Global.currentFoodLoc)
		else:
			lazy_movement()
	elif nextActivity == "Wood":
		set_current_activity("Wood")
		currentItem = "Wood"
		if Global.woodMarked:
			NAVI.set_target_position(Global.currentWoodLoc)
		else:
			lazy_movement()
	elif nextActivity == "Leaf":
		set_current_activity("Leaf")
		currentItem = "Leaf"
		if Global.leafMarked:
			NAVI.set_target_position(Global.currentLeafLoc)
		else:
			lazy_movement()
	elif nextActivity == "InDefense":
		set_current_activity("InDefense")
		if !enemyInArea:
			var randNegY: float = randf_range(-1, 1)
			var randNegX: float = randf_range(-1, 1)
			if randNegX < 0:
				randNegX = -1
			else: randNegX = 1
			if randNegY < 0:
				randNegY = -1
			else: randNegY = 1
			
			var randX: float = randf_range(8, 16)
			var randY: float = randf_range(8, 16)
			print(" X ", randX, " Y ",randY)
			NAVI.set_target_position(Global.defendHere + Vector2(randX * randNegX, randY * randNegY))
	
	IDLE = false
	$AnimationPlayer.play("Walk")
	

func check_storage():
	if currentActivity == "Food":
		$Food.visible = true
		dump_food()
	if currentActivity == "Wood":
		$Wood.visible = true
		dump_wood()
	if currentActivity == "Leaf":
		$Leaf.visible = true
		dump_leaf()
	

func _on_TaskCompleteArea_body_entered(body):
	if specialActivity:
		if currentActivity == "Food":
			if body.has_method("made_withdraw"):
				if Global.food_count > 0:
					body.made_withdraw(1)
					NAVI.set_target_position(Global.defendHere)
					set_special_activity()
					taskComplete = false
					$TaskCompleteArea.set_deferred("monitoring", false)
					IDLE = false
					$AnimationPlayer.play("Walk")
					return
				
		if currentActivity == "Wood":
			if body.has_method("made_withdraw"):
				if Global.wood_count > 0:
					body.made_withdraw(1)
					NAVI.set_target_position(Global.defendHere)
					set_special_activity()
					taskComplete = false
					$TaskCompleteArea.set_deferred("monitoring", false)
					IDLE = false
					$AnimationPlayer.play("Walk")
					return
		if currentActivity == "Leaf":
			if body.has_method("made_withdraw"):
				if Global.leaf_count > 0:
					body.made_withdraw(1)
					NAVI.set_target_position(Global.defendHere)
					set_special_activity()
					taskComplete = false
					$TaskCompleteArea.set_deferred("monitoring", false)
					IDLE = false
					$AnimationPlayer.play("Walk")
					return
	elif currentActivity == "Eating":
		if body.has_method("made_withdraw"):
			if Global.food_count > 0:
				body.made_withdraw(1)
				go_eat()
				$Food.visible = true
				taskComplete = false
				$TaskCompleteArea.set_deferred("monitoring", false)
				return
			else:
				set_current_activity(nextActivity)
				return
				
	elif !currentActivity == "Lazy" or !currentActivity == "InDefense":
		if body.has_method("sub_consumer_amount"):
			body.sub_consumer_amount()
			selfStorageFull = true
			get_node(currentItem).visible = true
			
		elif body.has_method("made_dump"):
			selfStorageFull = false
			get_node(currentItem).visible = false
			body.made_dump()
	$StorageCheckTimer.start(1.0)
	taskComplete = false
	$TaskCompleteArea.set_deferred("monitoring", false)
	

func _on_BodyNameFinder_body_entered(body):
	if currentActivity == "Eating":
		if body.return_type() == "Food":
			iHaveBody = true
	elif body.return_type() == currentActivity:
		iHaveBody = true
	

func _on_BodyNameFinder_body_exited(body):
	if body:
		iHaveBody = false
	

func _on_StorageCheckTimer_timeout():
	resume_task()
	

func _on_AttackAntArea_body_entered(body):
	if body:
		defensePos = false
		enemyInArea = true
		$RadarSprite.visible = true
		$RadarSprite.play("Radar")
		for i in $AttackAntArea.get_overlapping_bodies():
			if body.return_life():
				if !enemyAntArray.has(i.name):
					enemyAntArray.append(i.name)
		fight_enemy()
	

func _on_AttackAntArea_body_exited(body):
	if body:
		if !inDefense:
			defensePos = false
			enemyInArea = false
			$RadarSprite.visible = false
			$RadarSprite.stop()
			resume_task()
		else:
			if !enemyAntArray.is_empty():
				fight_enemy()
	

func fight_enemy():
	IDLE = false
	var enemyLoc: Vector2 = Vector2.ZERO
	enemyLoc = get_parent().get_node(enemyAntArray[0]).global_position
	defensePos = false
	$AnimationPlayer.play("Walk")
	NAVI.set_target_position(enemyLoc)
	

func dump_food():
	NAVI.set_target_position(Global.storageSavedLoc["Food"])
	IDLE = false
	$AnimationPlayer.play("Walk")
	

func dump_leaf():
	NAVI.set_target_position(Global.storageSavedLoc["Leaf"])
	IDLE = false
	$AnimationPlayer.play("Walk")
	

func dump_wood():
	NAVI.set_target_position(Global.storageSavedLoc["Wood"])
	IDLE = false
	$AnimationPlayer.play("Walk")
	

func move_to_loc()-> Vector2:
	update_my_dict()
	if NAVI.is_navigation_finished():
		look_at(destination)
		_complete_task()
		IDLE = true
		$AnimationPlayer.play("Idle")
#		print("Position reached")
		return nextPoint
	nextPoint = NAVI.get_next_path_position()
	return nextPoint
	

func _physics_process(delta: float)-> void:
	
	movement_loop()
	


func movement_loop():
	if IDLE:
		return
	destination = move_to_loc()
	movement = position.direction_to(destination)
	NAVI.set_velocity(movement)
#	_move(movement)

func _move(moveTo: Vector2):
	set_velocity(moveTo* (NAVI.max_speed - randSpeedMod))
	set_up_direction(Vector2.UP)
	move_and_slide()
	movement = velocity
	look_at(destination)
	

func _on_SetTask_pressed():
	emit_signal("imSelectedNow", self)
#	var myProfiler: Object = profiler.instance()
#	get_parent().add_child(myProfiler)
#	myProfiler._load_array(return_profile())
#	myProfiler.grab_my_body(self)
#	if global_position.y > 312:
#		myProfiler.global_position = global_position
#	else:
#		myProfiler.global_position = Vector2((1152/2), (864/2))
	

func return_profile()-> Array:
	var myProArray: Array = []
	myProArray.append(givenName)
	myProArray.append(nextActivity)
	myProArray.append(currentItem)
	return myProArray
	

func add_ant_board():
	UIconnect.add_ant_to_board(self, return_profile())
	

func _on_NavigationAgent2D_velocity_computed(safe_velocity):
	_move(safe_velocity)
	

func _on_HungerCountTimer_timeout():
	health -= 1
	hungry = true
	if health < 0:
		print("Died")
	

func _on_EatTimer_timeout():
	if eating:
		$Food.visible = false
		eating = false
		health += 1
		if health > 2:
			hungry = false
	resume_task()
	

func lock_self(isLocked: bool):
	if isLocked:
		get_parent().camera_outside(outside)
	cameraLocked = isLocked
	

func _on_OutsideDetectionArea_area_entered(area):
	if area:
		outside = true
		if cameraLocked:
			get_parent().camera_outside(true)
		if outside == Global.cameraOutside:
			show()
		else:
			hide()
	

func _on_OutsideDetectionArea_area_exited(area):
	if area:
		outside = false
		if cameraLocked:
			get_parent().camera_outside(false)
		if outside == Global.cameraOutside:
			show()
		else:
			hide()
	
	
