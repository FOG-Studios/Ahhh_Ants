extends Control

# Ant Color Selection Scene

var ant_color
var color_selected = false
@onready var buttonGrid: GridContainer = $CenterContainer3/GridContainer

func _ready():
	if !Global.antColor == null:
		$CenterContainer2/AntSprite.self_modulate = Global.antColor
		color_selected = true
		if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
			$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
		$CenterContainer/ColorSelected/GoLabel.visible = true
		
	buttonGrid.get_node("BlueButton").self_modulate = Color.BLUE
	buttonGrid.get_node("BlackButton").self_modulate = Color(0.117647, 0.117647, 0.117647)
	buttonGrid.get_node("PinkButton").self_modulate = Color.PINK
	buttonGrid.get_node("OrangeButton").self_modulate = Color.ORANGE
	buttonGrid.get_node("RedButton").self_modulate = Color(0.541176, 0.062745, 0.062745)

func _on_RedButton_pressed():
	if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
	$CenterContainer/ColorSelected/GoLabel.visible = true
	$CenterContainer2/AntSprite.self_modulate = Color(0.541176, 0.062745, 0.062745)
	Global.antColor = Color(0.541176, 0.062745, 0.062745)
	color_selected = true

func _on_BlueButton_pressed():
	if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
	$CenterContainer/ColorSelected/GoLabel.visible = true
	$CenterContainer2/AntSprite.self_modulate = Color.BLUE
	Global.antColor = Color.BLUE
	color_selected = true

func _on_OrangeButton_pressed():
	if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
	$CenterContainer/ColorSelected/GoLabel.visible = true
	$CenterContainer2/AntSprite.self_modulate = Color.ORANGE
	Global.antColor = Color.ORANGE
	color_selected = true

func _on_BlackButton_pressed():
	$CenterContainer/ColorSelected/GoLabel.visible = true
	if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
	$CenterContainer2/AntSprite.self_modulate = Color(0.117647, 0.117647, 0.117647)
	Global.antColor = Color(0.117647, 0.117647, 0.117647)
	color_selected = true

func _on_PinkButton_pressed():
	if $CenterContainer/ColorSelected/ChooseColorLabel.visible == true:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = false
	$CenterContainer/ColorSelected/GoLabel.visible = true
	$CenterContainer2/AntSprite.self_modulate = Color.PINK
	Global.antColor = Color.PINK
	color_selected = true

func _on_ColorSelected_pressed():
	if !color_selected:
		$CenterContainer/ColorSelected/ChooseColorLabel.visible = true
	if color_selected:
		get_tree().change_scene_to_file("res://Scenes/AntHill.tscn")
