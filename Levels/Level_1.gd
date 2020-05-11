extends Node2D

func _on_SecondRoomDetector_body_entered(body):
	$Camera2D.current = false
	$Camera2D2.current = true


func _on_FirstRoomDetector_body_entered(body):
	$Camera2D.current = true
	$Camera2D2.current = false
