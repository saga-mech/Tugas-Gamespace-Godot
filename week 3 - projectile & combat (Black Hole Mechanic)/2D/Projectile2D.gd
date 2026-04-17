class_name Projectile2D
extends Area2D

var projectile_speed: float = 600.0
var projectile_damage: float = 10.0

# --- VARIABEL TAMENG ORBIT ---
var is_orbiting: bool = false
var orbit_angle: float = 0.0
var orbit_radius: float = 90.0 # Jarak putaran dari pemain
var orbit_speed: float = 20.0   # Kecepatan putaran
var player_target: Node2D = null 

# --- POSISI BARU: Dorongan ke atas agar sejajar dengan badan ---
var orbit_height_offset: float = -60.0 

func _ready() -> void:
	body_entered.connect(_on_body_enter)

# Fungsi untuk memulai putaran
func start_orbit(player_node: Node2D, start_angle: float) -> void:
	is_orbiting = true
	player_target = player_node
	orbit_angle = start_angle

# Fungsi untuk melepaskan peluru dari orbit agar meluncur maju
func release_from_orbit(direction: float) -> void:
	is_orbiting = false
	projectile_speed = 600.0 * direction 

func set_projectile_damage(damage: float) -> void:
	projectile_damage = damage

func _physics_process(delta: float) -> void:
	if is_orbiting and is_instance_valid(player_target):
		# Berputar mengelilingi pemain menggunakan Sin & Cos
		orbit_angle += orbit_speed * delta
		var offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius
		
		# --- POSISI BARU: Terapkan dorongan ke atas di sini ---
		var height_adjustment = Vector2(0, orbit_height_offset)
		global_position = player_target.global_position + height_adjustment + offset
		
	else:
		# Meluncur lurus ke depan
		position.x += projectile_speed * delta

func _on_body_enter(body: Node2D) -> void:
	if (body is TileMapLayer or body is TileMap) and not is_orbiting:
		queue_free() 
	
	if body is DummyTarget:
		if body.has_method("take_damage"):
			body.take_damage(projectile_damage)
		# Hancur setelah mengenai musuh (berfungsi sebagai tameng yang bisa pecah)
		queue_free()
