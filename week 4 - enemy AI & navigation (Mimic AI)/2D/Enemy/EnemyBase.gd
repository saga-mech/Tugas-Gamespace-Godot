class_name EnemyBase
extends CharacterBody2D

## Kecepatan jalan musuh.
@export var speed: float = 200.0 
@export var weapon: WeaponComponent = null
@export var health_component: HealthComponent = null
@export var nav_agent: NavigationAgent2D = null

var player: PlayerTD = null 
var last_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	add_to_group("enemy")
	if health_component:
		health_component.died.connect(_on_died)
		
	# Pastikan grup di sini sesuai dengan yang ada di PlayerTD ("Player" dengan P besar)
	player = get_tree().get_first_node_in_group("Player") as PlayerTD
	
	# Hubungkan sinyal serangan
	if is_instance_valid(player):
		player.player_attacked.connect(_on_player_attacked)

func _physics_process(delta: float) -> void:
	last_pos = global_position
	
	if is_instance_valid(player):
		# 1. PERGERAKAN CERMIN (Berlawanan Arah)
		# Menambahkan tanda minus (-) membalikkan arah velocity pemain
		var mirror_direction = -player.velocity.normalized()
		velocity = mirror_direction * speed
		
		# 2. ROTASI SENJATA CERMIN
		if weapon and weapon.has_method("update_rotation"):
			# Hitung arah kursor mouse pemain
			var player_aim_dir = (get_global_mouse_position() - player.global_position).normalized()
			
			# Balikkan arahnya dengan tanda minus (-) agar pedang berhadapan
			var mirror_aim_dir = -player_aim_dir
			weapon.update_rotation(mirror_aim_dir, delta)

	move_and_slide()

# 3. SERANGAN CERMIN
# 3. SERANGAN CERMIN DENGAN DELAY
func _on_player_attacked() -> void:
	print("B: Musuh mendeteksi sinyal serangan dari pemain!")
	
	# Pengecekan 1: Apakah Node senjata musuh sudah dimasukkan?
	if weapon == null:
		print("ERROR: Variabel 'weapon' di musuh KOSONG! Anda belum memasukkan Node Weapon ke Inspector Musuh.")
		return
		
	# Tunggu 0.05 detik
	await get_tree().create_timer(0.05).timeout
	print("C: Delay 0.05 detik selesai, musuh bersiap menyerang...")
	
	if is_instance_valid(self) and is_instance_valid(weapon):
		if weapon.has_method("attack"):
			weapon.attack()
			print("D: Sukses memanggil weapon.attack()")
		else:
			print("ERROR: Node senjata musuh tidak memiliki fungsi bernama 'attack' atau 'shoot'!")

func take_damage(amount: float) -> void:
	if health_component:
		health_component.take_damage(amount)

func _on_died() -> void:
	velocity = Vector2.ZERO 
	GameManager.register_killed_enemy(name)
	GameManager.spawn_coin.emit(last_pos)
	queue_free()
