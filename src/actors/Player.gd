extends KinematicBody2D


# Variables

const ROTATION_SPEED = 200
const SPEED = 200

var playerX = self.position.x
var playerY = self.position.y

var velocity = Vector2()

onready var rayContainer = $RayContainer
var rayCast = preload("res://src/Ray0.tscn")

signal ray_collision


# Functions

func _ready():
	rotation = PI
	rotation_degrees = 0
	
	playerX = self.position.x
	playerY = self.position.y
	
	var startingAngle = -(GlobalVars.playerFOV / 2)
	for _x in GlobalVars.rayCount:
		rayContainer.add_child(rayCast.instance(), true)
	
	var increment = GlobalVars.playerFOV / (rayContainer.get_child_count() - 1)
	
	for x in rayContainer.get_child_count():
		rayContainer.get_child(x).rotation_degrees = startingAngle
		startingAngle += increment



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
	# Set default size
	GlobalVars.rayColl.resize(rayContainer.get_child_count())
	GlobalVars.rayDist.resize(rayContainer.get_child_count())
	GlobalVars.rayCollider.resize(rayContainer.get_child_count())
	
	# Set default values
	for x in rayContainer.get_child_count():
		GlobalVars.rayDist[x] = 1
		GlobalVars.rayCollider[x] = "Empty"
	
	# Loop through children of $Rays to detect collisions and set appropriate values as well as trigger the Main scene to draw the pixel columns
	for x in rayContainer.get_child_count():
		var ray = get_node("RayContainer/Ray%s" % x)
		if ray.is_colliding():
			GlobalVars.rayColl[x] = "1"
			GlobalVars.rayDist[x] = self.position.distance_to(ray.get_collision_point()) * cos(ray.rotation)
			GlobalVars.rayCollider[x] = ray.get_collider()
			emit_signal("ray_collision")
		else:
			GlobalVars.rayColl[x] = "0"
			GlobalVars.rayDist[x] = 1
			GlobalVars.rayCollider[x] = "Empty"
			emit_signal("ray_collision")
