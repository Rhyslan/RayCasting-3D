extends Node2D


# Variables
var notWall = Color(0, 0, 0, 0)

onready var pixelColumnContainer = $PixelColumns/CenterContainer/HBoxContainer
var column = preload("res://src/PixelColumn0.tscn")


# Functions
func _ready():
	for _x in GlobalVars.rayCount:
		pixelColumnContainer.add_child(column.instance(), true)
	
	$PixelColumns/VBoxContainer/Background.rect_min_size = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y / 2)
	$PixelColumns/VBoxContainer/Floor.rect_min_size = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y / 2)


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_Player_ray_collision():
	for x in pixelColumnContainer.get_child_count():
		var pixelColumn = get_node("PixelColumns/CenterContainer/HBoxContainer/PixelColumn%s/ColorRect" % x)
		if GlobalVars.rayColl[x] == "1":
			pixelColumn.color = Color(GlobalVars.wallColours[str(GlobalVars.rayCollider[x])])
		else:
			pixelColumn.color = notWall
		
		pixelColumn.rect_min_size.y = get_viewport_rect().size.y - GlobalVars.rayDist[x] * 1.5
