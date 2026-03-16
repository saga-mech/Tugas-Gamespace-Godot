class_name Player2D
extends CharacterBody2D

# Player Class
# Player class digunakan untuk mengontrol semua pergerakan dari player. Mulai dari jump, move, dll.
@export var animation: AnimatedSprite2D = null

@export_group("Player Data")
@export var move_speed: float = 0
@export var jump_force: float = 0
@export var friction: float = 0
@export var acceleration: float = 0

@export_group("Movement Multiplier")
@export var gravity_mult: float = 0
@export var speed_mult: float = 0
@export var jump_mult : float = 0

@export_group("Movement Feel")
@export var coyote_time: float = 0
@export var jump_buffer: float = 0

@export_group("Ghost Mechanic")
## Tentukan di layer mana Dinding/Tembok berada (Misal: 2)
@export var wall_collision_layer: int = 2
## Seberapa transparan karakter saat jadi hantu (0.0 = hilang, 1.0 = solid)
@export var ghost_alpha: float = 0.5

var _direction: float = 0
var _coyote_timer: float = 0
var _jump_buffer_timer: float = 0
var is_ghost: bool = false # Status apakah sedang mode hantu atau tidak

func get_direction() -> float:
	return _direction

# Fungsi Process ini digunakan untuk memproses game secara terus menerus tanpa henti
# sampai game dihentikan
func _process(_delta: float) -> void:
	_animation()

# Fungsi Physics Process digunakan untuk memproses game secara terus menerus juga, namun di fungsi ini
# ada tambahan proses fisika (Grivtasi, Velocity, dll)
func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_mult
		_coyote_timer -= delta
	else:
		_coyote_timer = coyote_time

	if Input.is_action_just_pressed("jump")and not TerminalManager.is_open:
		_jump_buffer_timer = jump_buffer

	_jump_buffer_timer -= delta

	_handle_ghost() # Panggil mekanik hantu
	_jump()
	_move()
	
	
	move_and_slide() ## (PENTING !!) fungsi untuk meng eksekusi proses fisika

# Fungsi buatan sendiri yang mengatur mekanik hantu
func _handle_ghost() -> void:
	# Mengaktifkan mode hantu saat tombol ditekan
	if Input.is_action_pressed("Ghost")and not TerminalManager.is_open:
		is_ghost = true
		# Matikan deteksi tabrakan dengan layer dinding
		set_collision_mask_value(wall_collision_layer, false)
		if animation:
			animation.modulate.a = ghost_alpha # Ubah warna karakter jadi transparan
			
	# Mematikan mode hantu saat tombol dilepas
	else:
		is_ghost = false
		# Nyalakan kembali deteksi tabrakan dengan layer dinding
		set_collision_mask_value(wall_collision_layer, true)
		if animation:
			animation.modulate.a = 1.0 # Kembalikan warna ke normal (Solid)

# fungsi buatan sendiri yang mengatur move
func _move() -> void:
	if not TerminalManager.is_open:
		_direction = Input.get_axis("left", "right")
	else:
		_direction = 0
	
	if _direction != 0:
		# velocity itu hasil kali dari arah dan kecepatan
		velocity.x = move_toward(velocity.x, move_speed * _direction * speed_mult, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

# fungsi buatan sendiri yang mengatur jump
func _jump() -> void:
	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		velocity.y = -jump_force * jump_mult
		_jump_buffer_timer = 0
		_coyote_timer = 0

# fungsi buatan sendiri yang mengatur animasi player
func _animation() -> void:
	if not animation: return # Keamanan tambahan jika animasi belum dimasukkan di inspector
	
	if is_on_floor():
		if _direction != 0:
			animation.play("Move")
		else:
			animation.play("Idle")
	else:
		if velocity.y > 0:
			animation.play("Fall")
		elif velocity.y < 0:
			animation.play("Jump")

	_facing_direction()

# fungsi buatan sendiri yang mengatur tatapn animasi karakter
func _facing_direction() -> void:
	if not animation: return
	
	if _direction > 0:
		animation.flip_h = false
	elif _direction < 0:
		animation.flip_h = true
