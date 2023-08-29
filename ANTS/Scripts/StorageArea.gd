extends CharacterBody2D

# Storage script

signal storageAmountChanged
signal storageSelected

@export var StorageName: String

@onready var item: PackedScene = preload("res://Scenes/Item.tscn")
@onready var fTexture: Resource = preload("res://Assets/FoodItem.png")
@onready var wTexture: Resource = preload("res://Assets/WoodItem.png")
@onready var lTexture: Resource = preload("res://Assets/LeafItem.png")

var subCountAmount: int = 0
var itemCount: int = 0
var speed: float = 0.1
var destination: Vector2 = Vector2.ZERO
var outside: bool = false

func _ready():
	if Global.existingSave:
		global_position = Global.storageSavedLoc[StorageName]
	set_process(false)
	if StorageName == "Food":
		if Global.food_count > 0:
			for i in Global.food_count:
				itemCount += 1
				var fItem: = item.instantiate()
				$NodeHolder.add_child(fItem)
				fItem.rotation_degrees = randf_range(0, 360)
				fItem.position.x = randf_range(-2, 2)
				fItem.position.y = randf_range(-2, 2)
				fItem.texture = fTexture
#				if itemCount == 50:
#					return
	if StorageName == "Leaf":
		if Global.leaf_count > 0:
			for i in Global.leaf_count:
				itemCount += 1
				var lItem: = item.instantiate()
				$NodeHolder.add_child(lItem)
				lItem.rotation_degrees = randf_range(0, 360)
				lItem.position.x = randf_range(-2, 2)
				lItem.position.y = randf_range(-2, 2)
				lItem.texture = lTexture
#				if itemCount == 50:
#					return
	if StorageName == "Wood":
		if Global.wood_count > 0:
			for i in Global.wood_count:
				itemCount += 1
				var wItem: = item.instantiate()
				$NodeHolder.add_child(wItem)
				wItem.rotation_degrees = randf_range(0, 360)
				wItem.position.x = randf_range(-2, 2)
				wItem.position.y = randf_range(-2, 2)
				wItem.texture = wTexture
#				if itemCount == 50:
#					return
	

func made_dump():
	if StorageName == "Leaf":
		
#		if itemCount > 50:
#			itemCount = 50
#			sub_items(1)
		var lItem: = item.instantiate()
		$NodeHolder.add_child(lItem)
		await get_tree().create_timer(0.1).timeout
		lItem.rotation_degrees = randf_range(0, 360)
		lItem.position.x = randf_range(-2, 2)
		lItem.position.y = randf_range(-2, 2)
		lItem.texture = lTexture
		Global.leaf_count += 1
		itemCount += 1
		emit_signal("storageAmountChanged", Global.leaf_count)
		return
	if StorageName == "Food":
		
#		if itemCount > 50:
#			sub_items(1)
#			itemCount = 50
		var fItem: = item.instantiate()
		$NodeHolder.add_child(fItem)
		await get_tree().create_timer(0.1).timeout
		fItem.rotation_degrees = randf_range(0, 360)
		fItem.position.x = randf_range(-2, 2)
		fItem.position.y = randf_range(-2, 2)
		fItem.texture = fTexture
		Global.food_count += 1
		itemCount += 1
		emit_signal("storageAmountChanged", Global.food_count)
		return
	if StorageName == "Wood":
		
#		if itemCount > 50:
#			sub_items(1)
#			itemCount = 50
		var wItem: = item.instantiate()
		$NodeHolder.add_child(wItem)
		await get_tree().create_timer(0.1).timeout
		wItem.rotation_degrees = randf_range(0, 360)
		wItem.position.x = randf_range(-2, 2)
		wItem.position.y = randf_range(-2, 2)
		wItem.texture = wTexture
		Global.wood_count += 1
		itemCount += 1
		emit_signal("storageAmountChanged", Global.wood_count)
		return
	

func sub_items(subAmount: int):
	var subChild: int = 0
	itemCount -= subAmount
	for i in subAmount:
		$NodeHolder.get_child(subChild).queue_free()
		print("removed these kids ", $NodeHolder.get_child(subChild).name, " ", StorageName)
		subChild += 1
	
	

func made_withdraw(subAmount: int):
	subCountAmount = 0
	if StorageName == "Leaf":
		Global.leaf_count -= subAmount
#		if Global.leaf_count < 51:
#			subCountAmount = itemCount - Global.leaf_count
		sub_items(subAmount)
#			print(subCountAmount, " = ", itemCount, " - ", Global.leaf_count)
		emit_signal("storageAmountChanged", Global.leaf_count)
		return
	if StorageName == "Food":
		Global.food_count -= subAmount
#		if Global.food_count < 51:
#			subCountAmount = itemCount - Global.food_count
		sub_items(subAmount)
		emit_signal("storageAmountChanged", Global.food_count)
		return
	if StorageName == "Wood":
		Global.wood_count -= subAmount
#		if Global.wood_count < 51:
#			subCountAmount = itemCount - Global.wood_count
		sub_items(subAmount)
		emit_signal("storageAmountChanged", Global.wood_count)
		return
	

func check_outside():
	if outside == Global.cameraOutside:
		show()
	else: hide()
	

func connect_signals(signalObject: Object, signalName: String, calledFunc: String):
	return signalObject.connect(signalName, Callable(self, calledFunc))
	

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
	

func return_type()-> String:
	return StorageName
	

func _on_MoveStorageButton_pressed():
	set_process(true)
	emit_signal("storageSelected", self)
	

func _on_MoveStorageButton_released():
	emit_signal("storageSelected", get_parent().get_node("Carl"))
	set_process(false)
	Global.save_this_storage_loc(StorageName, global_position)
	get_parent().mark_item()
	
