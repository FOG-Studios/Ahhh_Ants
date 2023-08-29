extends CharacterBody2D

# Outside Item Script

signal consumed

@onready var fTexture: = $FoodItem
@onready var wTexture: = $WoodItem
@onready var lTexture: = $LeafItem

@export var myTexture: String

var consumerAmount: int = 999
var outside: bool = true

func _ready():
	check_outside()
	

func sub_consumer_amount():
	consumerAmount -= 1
	if consumerAmount <= 0:
		Global.remove_marked_item(myTexture, global_position)
		emit_signal("consumed", myTexture, global_position)
		call_deferred("queue_free")
	$Node2D/AmountLabel.text = str(consumerAmount)

func set_my_texture(stringName: String):
	myTexture = stringName
	if myTexture == "Food":
		$FoodItem.visible = true
	elif myTexture == "Wood":
		$WoodItem.visible = true
	else: $LeafItem.visible = true
	

func return_type()-> String:
	return myTexture
	

func _on_MarkAsButton_pressed():
	$Node2D.visible = true
	$MarkAsTimer.start()
	$Node2D/MarkasLabel.text = "Mark as " + myTexture + "?"
	$Node2D/AmountLabel.text = str(consumerAmount)
	

func _on_YesButton_released():
	if myTexture == "Food":
		$FoodItem/FoodSelected.visible = true
	elif myTexture == "Wood":
		$WoodItem/WoodSelected.visible = true
	else: $LeafItem/LeafSelected.visible = true
	$Node2D.visible = false
	Global.add_marked_items(myTexture, global_position)
	get_parent().mark_item()
	

func _on_NoButton_released():
	if myTexture == "Food":
		$FoodItem/FoodSelected.visible = false
	elif myTexture == "Wood":
		$WoodItem/WoodSelected.visible = false
	else: $LeafItem/LeafSelected.visible = false
	$Node2D.visible = false
	Global.remove_marked_item(myTexture, global_position)
	get_parent().mark_item()
	

func _on_MarkAsTimer_timeout():
	$Node2D.visible = false
	

func check_outside():
	if outside == Global.cameraOutside:
		show()
	else: hide()
	

func connect_to_outside_signal(objectSignal: Object, signalName: String, calledFunc: String):
	return objectSignal.connect(signalName, Callable(self, calledFunc))
	

func reset_marked(itemType: String):
	if itemType == myTexture:
		_on_NoButton_released()
	
