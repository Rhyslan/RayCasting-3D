extends Node2D


# Variables
var wallX = Color(255, 255, 255, 255)
var wallY = Color(168, 168, 168, 255)
var notWall = Color(0, 0, 0, 0)


# Functions
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_Player_ray_collision():
	for x in $PixelColumns.get_child_count():
		var pixelColumn = get_node("PixelColumns/PixelColumn%s/ColorRect" % x)
		if GlobalVars.rayColl[x] == "1":
			pixelColumn.color = wallX
		else:
			pixelColumn.color = notWall
		
		pixelColumn.rect_min_size.y = 1000 - GlobalVars.rayDist[x] * 1.5
