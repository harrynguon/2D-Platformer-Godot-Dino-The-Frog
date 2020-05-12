# Signal handler.

extends Node2D

onready var invisWall = preload("res://InvisWall.tscn")

var currentRoom = 0
var activated_wall = false
	
func tweenIt(start : Vector2, end : Vector2) -> Tween:
	var tween = $Tween
	tween.interpolate_property($Camera2D,\
		"position",\
	 	start, \
		end,\
		0.3,\
		Tween.TRANS_QUAD,\
		Tween.EASE_OUT
	)
	return tween


func _on_RoomDetector_1_body_entered(_body):
	if currentRoom == 1:
		currentRoom = 0
		var tween = tweenIt(Vector2(976, 180), Vector2(320, 180))
		tween.start()


func _on_RoomDetector_2_body_entered(_body):
	if currentRoom == 0:	
		currentRoom = 1
		var tween = tweenIt(Vector2(320, 180), Vector2(976, 180))
		tween.start()
		

func _on_RoomDetector_3_body_entered(_body):
	if currentRoom == 1:	
		currentRoom = 2
		var tween = tweenIt(Vector2(976, 180), Vector2(976, 544))
		tween.start()

func _on_RoomDetector_4_body_entered(_body):
	if not activated_wall and currentRoom == 2:
		$Camera2D.current = false
		$Player/Camera2D.current = true
		var invisWallInstance = invisWall.instance()
		invisWallInstance.position = Vector2(667, 625)
		self.add_child(invisWallInstance)
		activated_wall = true

func _on_Area2D_body_entered(body):
	get_tree().paused = true
	# Victory pop up here
