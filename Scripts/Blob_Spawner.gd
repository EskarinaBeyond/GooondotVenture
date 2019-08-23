extends Node2D

var counter = 0

func _ready():
	pass

func spawn():
	var scene = load("res://Scenes/Blob.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("Blob" + str(counter))
	add_child(scene_instance)
	counter += 1

func _process(delta):
	if Input.is_action_just_pressed("dostuff"):
		spawn()
