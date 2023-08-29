extends Control

# Profile Creator

var parentGone: bool = false
var targetObject: Object
var myName: String
var myJob: String
var carrying: String
var currentArray: Array = []
var fTexture: Texture2D = load("res://Assets/FoodIcon.png")
var lTexture: Texture2D = load("res://Assets/LeafIcon.png")
var wTexture: Texture2D = load("res://Assets/WoodIcon.png")
var dTexture: Texture2D = load("res://Assets/DefenceIcon.png")

func _ready():
	$AntProfile/Anticon.modulate = Global.antColor
	$AntProfile/TextControl/AntFace.modulate = Global.antColor
	$AntProfile/TextControl/LeafButton/WhiteSquare32X32.modulate = Global.antColor
	$AntProfile/TextControl/WoodButton/WhiteSquare32X32.modulate = Global.antColor
	$AntProfile/TextControl/DefendButton/WhiteSquare32X32.modulate = Global.antColor
	$AntProfile/TextControl/FoodButton/WhiteSquare32X32.modulate = Global.antColor
	

func _load_array(newArray: Array):
	currentArray = newArray.duplicate()
	_load_variables()
	

func _load_variables():
	myName = currentArray[0]
	myJob = currentArray[1]
	carrying = currentArray[2]
	$AntProfile/TextControl/NameLabel.text = myName
	if myJob == "Food":
		$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/FoodButton/WhiteSquare32X32.modulate = Global.antColor
		$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = true
	if myJob == "Wood":
		$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/WoodButton/WhiteSquare32X32.modulate = Global.antColor
		$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = true
	if myJob == "Leaf":
		$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/LeafButton/WhiteSquare32X32.modulate = Global.antColor
		$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = true
	if myJob == "InDefense":
		$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
		$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
		$AntProfile/ItemCarryingIcon.texture = dTexture
		$AntProfile/ItemCarryingIcon.visible = true
		$AntProfile/TextControl/DefendButton/WhiteSquare32X32.modulate = Global.antColor
		$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = true
	if carrying == "Food":
		$AntProfile/ItemCarryingIcon.texture = fTexture
		$AntProfile/ItemCarryingIcon.visible = true
	if carrying == "Wood":
		$AntProfile/ItemCarryingIcon.texture = wTexture
		$AntProfile/ItemCarryingIcon.visible = true
	if carrying == "Leaf":
		$AntProfile/ItemCarryingIcon.texture = lTexture
		$AntProfile/ItemCarryingIcon.visible = true
	if !myJob == "InDefense":
		if carrying == "False":
			$AntProfile/ItemCarryingIcon.visible = false
	$AntProfile/MessageLabel.text = AntPhrase._return_ant_phrase()
	
	

func grab_my_body(bodyGrabbed: Object):
	targetObject = bodyGrabbed
	

func _on_FoodButton_button_up():
	targetObject.get_food()
	targetObject.update_my_dict()
	$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = true
	$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
	$AntProfile/ItemCarryingIcon.texture = fTexture
	

func _on_DefendButton_button_up():
	targetObject.defend_area()
	targetObject.update_my_dict()
	$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = true
	$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
	$AntProfile/ItemCarryingIcon.texture = dTexture
	

func _on_WoodButton_button_up():
	targetObject.get_wood()
	targetObject.update_my_dict()
	$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = true
	$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
	$AntProfile/ItemCarryingIcon.texture = wTexture
	

func _on_LeafButton_button_up():
	targetObject.get_leaf()
	targetObject.update_my_dict()
	$AntProfile/TextControl/LeafButton/WhiteSquare32X32.visible = true
	$AntProfile/TextControl/WoodButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/DefendButton/WhiteSquare32X32.visible = false
	$AntProfile/TextControl/FoodButton/WhiteSquare32X32.visible = false
	$AntProfile/ItemCarryingIcon.texture = lTexture
	

func _on_NameLabel_text_entered(new_text):
	targetObject.givenName = new_text
	targetObject.update_my_dict()
	$Timer.start()
	

func _on_Timer_timeout():
#	if !parentGone:
#		_load_array(myParent.return_profile())
#	else: queue_free()
	pass

func _on_NameLabel_focus_entered():
	$Timer.stop()
	

func _on_CloseTimer_timeout():
#	queue_free()
	pass
