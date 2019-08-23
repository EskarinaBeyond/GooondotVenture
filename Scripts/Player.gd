extends KinematicBody2D

var gravity = 400
export(int) var speed = 60
export(int) var jumpforce = -150
var up_vector = Vector2(0,-1)
var active = true

var movement = Vector2(0,0)

func get_input():
	
	if Input.is_action_pressed("left"):
		movement.x = -speed
	
	if Input.is_action_pressed("right"):
		movement.x = speed
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		movement.y = jumpforce
	
	if Input.is_action_just_released("jump")  and movement.y < 0:
		movement.y = 0


func check_for_stomp():
	
	for body in $HitBox.get_overlapping_bodies():
		if body.has_method("on_stomp") and body.is_alive:
			body.on_stomp()
			movement.y = jumpforce * 1.2


func getAnimation():
	
	if movement.x < 0:
		$PlayerSprite.flip_h = true
	
	if movement.x > 0:
		$PlayerSprite.flip_h = false
	
	if is_on_floor() == false:
		$AnimationPlayer.play("air")
	
	if is_on_floor() and movement.x != 0:
		$AnimationPlayer.play("walk")
	
	if is_on_floor() and movement.x == 0:
		$AnimationPlayer.play("idle")


func _on_activate_interacter():
	
	active = false


func _on_deactivate_interacter():
	
	active = true


func deactivate_player():
	
	active = true


func _process(delta):
	
	if is_on_floor() or is_on_ceiling():
		movement.y = 0
	
	movement.y += gravity * delta
	movement.x = 0
	
	if active == true:
		
		get_input()
	
	check_for_stomp()
	
	getAnimation()
	
	move_and_slide_with_snap(movement, Vector2(0,1), up_vector)
