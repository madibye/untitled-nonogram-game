class_name Game
extends Control

# The origin scene. Manages scene changes.
var current_scene

func _ready():
	change_scene(Resources.title_scene.instantiate())
	
func change_scene(scene):
	if current_scene: remove_child(current_scene)
	current_scene = scene
	add_child(current_scene)
