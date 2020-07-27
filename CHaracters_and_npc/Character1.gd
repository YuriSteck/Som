extends KinematicBody2D
const JUMP = 400
const GRAVITY = 25
const UP = Vector2(0, -1)
const WORLD_LIMIT = 10

var speed = 150
var motion = Vector2()

onready var sprite = $Sprite
onready var animationPlayer = $Sprite/AnimationPlayer

func _physics_process(delta):
	movement()
	apply_gravity()
	animate()
	
	move_and_slide(motion, UP) 

func movement():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_pressed("jump")
	var dash = Input.is_action_pressed("dash")
	
	if right and not left:
		motion.x = speed
	elif left and not right:
		motion.x = -speed
	else:
		motion.x = 0
	
	if jump and is_on_floor():
		motion.y = -JUMP

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
		sprite.flip_h = false
	elif motion.x < 0:
		sprite.flip_h = true
	
	if motion.x != 0:
		animationPlayer.play("run")
	else:
		animationPlayer.play("idle")

func _input(event):
	var fire = Input.is_action_just_pressed("fire")
	var attack = Input.is_action_just_pressed("attack")

