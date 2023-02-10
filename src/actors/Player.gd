extends KinematicBody2D


# Variables

const ROTATION_SPEED = 200
const SPEED = 200

var playerX = self.position.x
var playerY = self.position.y

var velocity = Vector2()

signal ray_collision


# Functions

func _ready():
	rotation = PI
	rotation_degrees = 0
	
	playerX = self.position.x
	playerY = self.position.y
	


func _physics_process(delta):
	movement(delta)
	rays()


func movement(delta):
	# Forwards and Backwards movement relative to the players rotation
	if Input.is_action_pressed("playerForwards"):
		velocity = Vector2(0, -1).rotated(rotation) * SPEED
	if Input.is_action_pressed("playerBackwards"):
		velocity = Vector2(0, 1).rotated(rotation) * SPEED
	
	# Strafe movement relative to the players rotation
	if Input.is_action_pressed("playerLeft"):
		velocity = Vector2(-1, 0).rotated(rotation) * SPEED
	if Input.is_action_pressed("playerRight"):
		velocity = Vector2(1, 0).rotated(rotation) * SPEED
	
	# Player rotation
	if Input.is_action_pressed("playerRotateLeft"):
		rotation_degrees -= ROTATION_SPEED * delta
	if Input.is_action_pressed("playerRotateRight"):
		rotation_degrees += ROTATION_SPEED * delta
	
	velocity = move_and_slide(velocity)
	velocity = Vector2.ZERO    # Reset the velocity


func rays():
	GlobalVars.rayColl.resize($Rays.get_child_count())
	GlobalVars.rayDist.resize($Rays.get_child_count())
	
	for x in $Rays.get_child_count():
		GlobalVars.rayDist[x] = 1
	
	for x in $Rays.get_child_count():
		var ray = get_node("Rays/Ray%s" % x)
		if ray.is_colliding():
			GlobalVars.rayColl[x] = "1"
			GlobalVars.rayDist[x] = self.position.distance_to(ray.get_collision_point()) * cos(ray.rotation)
			emit_signal("ray_collision")
		else:
			GlobalVars.rayColl[x] = "0"
			GlobalVars.rayDist[x] = 1
			emit_signal("ray_collision")
