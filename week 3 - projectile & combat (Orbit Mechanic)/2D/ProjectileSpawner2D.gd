class_name ProjectileSpawner2D
extends Node

@export var player: Player2D = null
@export var marker: Marker2D = null
@export var projectile_scene: PackedScene = null

# --- VARIABEL ORBIT ---
var orbiting_bullets: Array = []
var max_orbit_bullets: int = 5 # Diubah menjadi maksimal 5 peluru!
var spawn_timer: float = 0.0
var time_between_spawns: float = 0.12 # Sedikit dipercepat agar 5 peluru cepat terkumpul

# --- VARIABEL KLIK vs TAHAN ---
var press_time: float = 0.0
var hold_threshold: float = 0.15 # Batas waktu (detik) untuk membedakan klik dan tahan
var is_holding: bool = false

func _process(delta: float) -> void:
	# Bersihkan memori dari peluru yang mungkin sudah pecah kena musuh
	orbiting_bullets = orbiting_bullets.filter(func(b): return is_instance_valid(b))
	
	# Pastikan letak moncong senjata (marker) selalu sesuai arah hadap karakter
	if player.animation.flip_h:
		marker.position.x = -50
	else:
		marker.position.x = 50

	# JIKA TOMBOL DITEKAN TERUS
	if Input.is_action_pressed("fire"):
		press_time += delta # Mulai menghitung stopwatch
		
		# Jika ditahan lebih dari 0.15 detik, berarti masuk mode ORBIT
		if press_time >= hold_threshold:
			is_holding = true
			spawn_timer -= delta
			
			# Keluarkan peluru satu per satu sampai 5 buah
			if spawn_timer <= 0 and orbiting_bullets.size() < max_orbit_bullets:
				spawn_orbit_bullet()
				spawn_timer = time_between_spawns

	# JIKA TOMBOL DILEPAS
	if Input.is_action_just_released("fire"):
		var dir = -1 if player.animation.flip_h else 1
		
		# Skenario A: Jika tadi sedang menahan (melepas tameng)
		if is_holding or orbiting_bullets.size() > 0:
			for bullet in orbiting_bullets:
				if is_instance_valid(bullet):
					bullet.release_from_orbit(dir)
			orbiting_bullets.clear()
			
		# Skenario B: Jika tadi hanya klik singkat (tembak lurus biasa)
		else:
			spawn_normal_bullet(dir)
		
		# Reset semua waktu untuk tembakan berikutnya
		press_time = 0.0
		spawn_timer = 0.0
		is_holding = false

# Fungsi khusus untuk memunculkan peluru orbit
func spawn_orbit_bullet() -> void:
	var projectile = projectile_scene.instantiate() as Projectile2D
	projectile.set_projectile_damage(player.projectile_damage)
	player.projectile_container.add_child(projectile)
	
	# Menghitung sudut (PI * 2 / 5 peluru = menyebar rata membentuk segilima)
	var start_angle = orbiting_bullets.size() * (PI * 2 / max_orbit_bullets)
	projectile.start_orbit(player, start_angle)
	
	orbiting_bullets.append(projectile)

# Fungsi khusus untuk tembakan klik biasa
func spawn_normal_bullet(dir: float) -> void:
	var projectile = projectile_scene.instantiate() as Projectile2D
	projectile.set_projectile_damage(player.projectile_damage)
	
	# Langsung atur kecepatannya agar meluncur ke depan
	var final_speed = (player.projectile_speed * dir) + player.velocity.x
	projectile.projectile_speed = 600.0 * dir 
	player.projectile_container.add_child(projectile)
	
	# Posisikan peluru tepat di moncong tembakan
	projectile.global_position = marker.global_position
