class_name DummyTarget
extends CharacterBody2D

@export var max_health: float = 100
@onready var health_bar: ProgressBar = $HealthBar

var _current_health: float = 0

# Variabel baru yang lebih simpel
var is_being_pulled: bool = false
var black_hole_center: Vector2 = Vector2.ZERO

func _ready() -> void:
	_current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = _current_health

func _process(_delta: float) -> void:
	if _current_health <= 0:
		queue_free()
	health_bar.value = _current_health

func take_damage(damage: float) -> void:
	_current_health -= damage

# Fungsi penerima sinyal sedot
func pull_to(target_pos: Vector2) -> void:
	print("🐸 KODOK TERSEDOT KE ARAH BLACK HOLE!")
	is_being_pulled = true
	black_hole_center = target_pos

func _physics_process(delta: float) -> void:
	if is_being_pulled:
		# Hancurkan hukum gravitasi, ganti dengan tenaga tarikan paksa!
		var direction = global_position.direction_to(black_hole_center)
		velocity = direction * 800
		move_and_slide()
	else:
		# Fisika normal saat sedang santai
		if not is_on_floor():
			velocity.y += 980 * delta
		velocity.x = move_toward(velocity.x, 0, 600 * delta)
		move_and_slide()
		
	# Penting: Matikan status ditarik di akhir frame agar bisa jatuh lagi nanti
	is_being_pulled = false
