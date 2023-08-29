extends Node2D

# Small Day Cycle Icon

signal change_day_cycle

@onready var icon_cycle_seeker = Global.icon_cycle_seeker
@export var isTimeKeeper: bool = false

func _ready():
	if isTimeKeeper:
		$OvalBg.visible = true
	$AnimationPlayer.seek(icon_cycle_seeker, true)
	

func call_signal():
	if isTimeKeeper:
		Global.day_time = !Global.day_time
		emit_signal("change_day_cycle")
	

func _on_DayCycleIcon_tree_exiting():
	Global.icon_cycle_seeker = $AnimationPlayer.current_animation_position
	
