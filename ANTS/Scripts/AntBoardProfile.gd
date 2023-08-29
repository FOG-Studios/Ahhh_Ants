extends Control

# Ant Board Profile

var myName: String
var myJob: String
var myParent: Object
var myParentStats: Array = []

func get_my_stats(myStats: Array):
	myParentStats = myStats.duplicate()
	myName = myStats[0]
	myJob = myStats[1]
	$AntNameLabel.text = str(myName)
	if myJob == "":
		myJob = myStats[2]
	if myJob == "Food":
		$gFood.button_pressed = (true)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "Wood":
		$gFood.set_pressed_no_signal(false)
		$gWood.button_pressed = (true)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "Leaf":
		$gFood.set_pressed_no_signal(false)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.button_pressed = (true)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "InDefense":
		$gFood.set_pressed_no_signal(false)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.button_pressed = (true)
	


func connect_to_parent(newParent: Object):
	myParent = newParent
	


func _on_AntNameLabel_text_entered(new_text):
	myName = new_text
	myParent.set_myName(new_text)
	$Timer.start()
	$AntNameLabel.release_focus()
	


func _on_gFood_toggled(_button_pressed):
	myParent.get_food()
	$gFood.release_focus()
	


func _on_gWood_toggled(_button_pressed):
	myParent.get_wood()
	$gWood.release_focus()
	


func _on_gLeaf_toggled(_button_pressed):
	myParent.get_leaf()
	$gLeaf.release_focus()
	


func _on_inDefense_toggled(_button_pressed):
	myParent.defend_area()
	$inDefense.release_focus()
	update_my_stats()
	


func update_my_stats():
	myParentStats = myParent.return_profile()
	myName = myParentStats[0]
	myJob = myParentStats[1]
	$AntNameLabel.text = str(myName)
	if myJob == "":
		myJob = myParentStats[2]
	if myJob == "Food":
		$gFood.button_pressed = (true)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "Wood":
		$gFood.set_pressed_no_signal(false)
		$gWood.button_pressed = (true)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "Leaf":
		$gFood.set_pressed_no_signal(false)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.button_pressed = (true)
		$inDefense.set_pressed_no_signal(false)
	if myJob == "inDefense":
		$gFood.set_pressed_no_signal(false)
		$gWood.set_pressed_no_signal(false)
		$gLeaf.set_pressed_no_signal(false)
		$inDefense.button_pressed = (true)
	
	


func _on_Timer_timeout():
	update_my_stats()
	


func _on_AntNameLabel_focus_entered():
	$Timer.stop()
	















