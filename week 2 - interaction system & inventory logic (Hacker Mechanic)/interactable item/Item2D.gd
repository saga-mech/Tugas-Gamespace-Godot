class_name Item2D
extends StaticBody2D # Diubah dari StaticBody3D menjadi 2D

@export var item_data: ItemData = null
@export var sprite: AnimatedSprite2D = null # Menggunakan Sprite2D alih-alih MeshInstance3D
@export var viscue_text: Label = null

# --- Variabel Hacking ---
@export var is_hackable: bool = true
@export var network_id: String = "item_2d_001"
# ------------------------

var item_dict: Dictionary[String, ItemData] = {}

func _ready() -> void:
	item_dict = {
		item_data.name : item_data
	}
	
	undetected()
	
	# Daftarkan ke TerminalManager (Sama persis dengan versi 3D)
	if is_hackable:
		TerminalManager.register_node(network_id, self)

func _exit_tree() -> void:
	# Hapus dari TerminalManager saat hancur/diambil (Sama persis)
	if is_hackable:
		TerminalManager.unregister_node(network_id)

func detected() -> void:
	viscue_text.show()
	viscue_text.text = "E : " + item_data.name
	
	# Efek Visual 2D: Kita gunakan 'modulate' untuk membuatnya tampak lebih terang/menyala
	sprite.modulate = Color(1.5, 1.5, 1.5) 

func undetected() -> void:
	viscue_text.hide()
	
	# Kembalikan warna sprite ke normal
	sprite.modulate = Color(1.0, 1.0, 1.0)

func collect() -> void:
	InventoryManager.add_to_inventory.emit(item_data.name, item_dict)
	queue_free()

# --- Fungsi Hacking Jarak Jauh ---
func remote_hack() -> void:
	# Efek visual saat diretas dari terminal (misal: sprite berkedip hijau)
	sprite.modulate = Color(0.0, 2.0, 0.0) 
	collect()
