extends KinematicBody2D

var gravity = 400
var speed = 15
var jumpforce = -130
var up_vector = Vector2(0,-1)

var is_alive = true
var jump_x = 0
var direction = 1

var movement = Vector2(speed,0)

onready var sprite = $AnimatedSprite
onready var ray_left = $RayCastLeft
onready var ray_right = $RayCastRight


func _ready():
	$AnimatedSprite.play("walk")


func on_stomp():
	
	sprite.play("die")


func jump():
	
	sprite.play("jump")
	movement.y = jumpforce
	movement.x = speed * direction * 4
	jump_x = floor(position.x)


func on_landing():
	sprite.play("walk")
	movement.x /= 3
	if floor(position.x) == jump_x:
		turn()


func turn():
	direction *= -1
	movement.x = speed * direction
	sprite.flip_h = not sprite.flip_h

func is_over_abyss():
	if movement.x < 0:
		ray_left.force_raycast_update()
		return ray_left.get_collider() == null
	else: 
		ray_right.force_raycast_update()
		return ray_right.get_collider() == null
	


func _physics_process(delta):
	
	if is_alive == false:
		return
	
	if is_on_ceiling():
		movement.y = 0
	
	if is_on_floor():
	
		if sprite.animation=="jump":
			on_landing()
		else:
			movement.y = 0
			if is_on_wall() or is_over_abyss():
				jump()
				
	
	movement.y += gravity * delta
	
	move_and_slide_with_snap(movement, Vector2(0,1), up_vector)


func _on_AnimatedSprite_animation_finished():
	
	if sprite.animation == "die":
		queue_free()
