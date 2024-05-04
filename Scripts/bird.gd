extends CharacterBody2D

class_name Bird

signal game_started

@export var gravity = 900.0
@export var jump_force: int = -300
@onready var animation_player = $AnimatedSprite2D

var animation_locked = 2

var max_speed = 400
var rotation_speed = 2

var is_started = false
var should_process_input = true

func _ready():
	velocity = Vector2.ZERO
	animation_player.play("idle")

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && should_process_input:
		animation_player.play("flap_wings")
		if !is_started: 
			game_started.emit()
			is_started = true
		jump()
		
	if !is_started:
		return
	
	velocity.y += gravity * delta
	
	if velocity.y > max_speed:
		velocity.y = max_speed
	
	move_and_collide(velocity * delta)
	rotate_bird()
	
	
func jump():
	velocity.y = jump_force
	rotation = deg_to_rad(-30)
			

func rotate_bird():
	if velocity.y > 0:
		if animation_locked == 2:
			animation_player.play('flap_wings_down')
			animation_locked = 1
		if rad_to_deg(rotation) < 90:
			rotation += rotation_speed * deg_to_rad(1)
	
	if velocity.y < 0:
		if animation_locked == 1:
			animation_player.play('flap_wings_up')
			animation_locked = 2
		if rad_to_deg(rotation) > -30:
			rotation -= rotation_speed * deg_to_rad(1)



func kill():
	should_process_input = false
	
func stop():
	animation_player.stop()
	gravity = 0
	velocity = Vector2.ZERO
