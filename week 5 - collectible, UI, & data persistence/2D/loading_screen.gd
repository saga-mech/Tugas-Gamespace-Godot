# LoadingScreen.gd
extends Control

@onready var progress_bar = $ProgressBar
var target_path: String

# Tambahkan dua variabel ini untuk memisahkan logika file dan visual
var actual_progress: float = 0.0
var visual_progress: float = 0.0

# Anda bisa mengubah angka ini untuk mengatur berapa lama loading screen tertahan
# Makin kecil angkanya, makin lama loadingnya (contoh: 50.0 butuh sekitar 2 detik)
const LOADING_SPEED: float = 50.0 

func _ready():
	if GameManager.next_scene_path == "":
		target_path = "res://week 5 - collectible, UI, & data persistence/2D/TopDownWorld.tscn"
	else:
		target_path = GameManager.next_scene_path
	
	ResourceLoader.load_threaded_request(target_path)

func _process(delta):
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(target_path, progress)
	
	# 1. Update nilai asli dari sistem ke actual_progress
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		actual_progress = progress[0] * 100.0
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		actual_progress = 100.0
		
	# 2. Animasikan visual_progress agar mengejar actual_progress secara perlahan
	visual_progress = move_toward(visual_progress, actual_progress, LOADING_SPEED * delta)
	progress_bar.value = visual_progress
	
	# 3. KUNCI UTAMA: Pindah scene HANYA JIKA file sudah siap DAN animasi bar sudah sampai 100%
	if status == ResourceLoader.THREAD_LOAD_LOADED and visual_progress >= 100.0:
		set_process(false)
		var new_scene = ResourceLoader.load_threaded_get(target_path)
		get_tree().change_scene_to_packed(new_scene)
