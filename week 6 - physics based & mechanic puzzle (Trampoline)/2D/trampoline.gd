extends Area2D

@export var kekuatan_pantulan: float = 800.0 

func _on_body_entered(body: Node2D) -> void:
	# 1. Mengecek apakah benda tersebut memiliki fungsi "pantulkan" (Untuk Player)
	if body.has_method("pantulkan"):
		body.pantulkan(kekuatan_pantulan)
		
	# 2. Mengecek apakah benda tersebut adalah Kotak Physics (RigidBody2D)
	elif body is RigidBody2D:
		# Mengubah kecepatan vertikal kotak secara langsung agar terpental ke atas
		# Sama seperti pemain, nilai negatif berarti ke atas di Godot (2D)
		body.linear_velocity.y = -kekuatan_pantulan
