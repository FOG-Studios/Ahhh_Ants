extends Control

# Splash Scene Script

@export var next_path: NodePath = "res://Scenes/AntColorSelectScene.tscn"
@export var wait_time: float

func _ready():
	if !wait_time == 0:
		$NextSceneTimer.start(wait_time)

# Quick scene change that sets new scene
# to get_tree().current_scene and
# queue_free() this scene when ready.
func _on_NextSceneTimer_timeout():
	return get_tree().change_scene_to_file(next_path)
