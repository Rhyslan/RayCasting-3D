extends Node2D


# Variables
var notWall = Color(0, 0, 0, 0)

onready var pixelColumnContainer = $PixelColumnContainer
var column = preload("res://src/PixelColumn0.tscn")


# Functions
func _ready():
	for _x in range(GlobalVars.rayCount):
		pixelColumnContainer.add_child(column.instance(), true)


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_Player_ray_collision():
	for x in pixelColumnContainer.get_child_count():
		var pixelColumn = get_node("PixelColumnContainer/PixelColumn%s/ColorRect" % x)
		if GlobalVars.rayColl[x] == "1":
			pixelColumn.color = Color(GlobalVars.wallColours[str(GlobalVars.rayCollider[x])])
		else:
			pixelColumn.color = notWall
		
		pixelColumn.rect_min_size.y = 1000 - GlobalVars.rayDist[x] * 1.5
