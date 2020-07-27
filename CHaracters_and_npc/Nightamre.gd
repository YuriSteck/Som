extends KinematicBody2D

const GRAVITY = 25
const UP = Vector2(0, -1)
const WORLD_LIMIT = 10

var speed = 150
var motion = Vector2()
var seePlayer = false

onready var sprite = $Sprite
onready var animationPlayer = $Sprite/AnimationPlayer

func _physics_process(delta):
	if $PlayerCheck.is_colliding():
		seePlayer = true
	else:
		seePlayer = false
	
	movement()
	apply_gravity()
	animate()
	
	move_and_slide(motion, UP) 

func movement():
	if not seePlayer:
		motion.x = 0
	else:
		if not $GroundCheck.is_colliding():
			motion.x = 0
		else:
			if sprite.flip_h == true:
				motion.x = speed
			elif sprite.flip_h == false:
				motion.x = -speed
	

func apply_gravity():
	if position.y > WORLD_LIMIT:
		get_tree().reload_current_scene()
	if is_on_floor() and motion.y > 0:
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += GRAVITY

func animate():
	if motion.x > 0:
		sprite.flip_h = true
	elif motion.x < 0:
		sprite.flip_h = false
	
	if motion.x != 0:
		animationPlayer.play("run")
	else:
		animationPlayer.play("idle")

func _input(event):
	var fire = Input.is_action_just_pressed("fire")
	var attack = Input.is_action_just_pressed("attack")
