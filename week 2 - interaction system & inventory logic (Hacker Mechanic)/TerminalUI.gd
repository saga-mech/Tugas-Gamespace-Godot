extends Control

@onready var output_log: Label = $OutputLog
@onready var input_field: LineEdit = $LineEdit

func _ready() -> void:
	# 1. Sembunyikan terminal saat game pertama kali dimulai
	hide()
	
	input_field.text_submitted.connect(_on_input_submitted)
	output_log.text = "Sistem Terminal Siap...\nKetik 'hack [id_item]' untuk meretas."

# 2. Fungsi bawaan Godot untuk mendeteksi tombol keyboard
func _input(event: InputEvent) -> void:
	# Mengecek apakah tombol 'toggle_terminal' ditekan
	if event.is_action_pressed("toggle_terminal"):
		# Balikkan keadaan (kalau tertutup jadi terbuka, kalau terbuka jadi tertutup)
		visible = !visible
		
		TerminalManager.is_open = visible
		
		if visible:
			input_field.grab_focus()
		else:
			input_field.clear()
			input_field.release_focus()
		
		# Jika terminal sedang terbuka, langsung arahkan kursor ke kolom ketikan
		if visible:
			input_field.grab_focus()
		else:
			# Bersihkan kolom ketikan saat terminal ditutup
			input_field.clear()
			input_field.release_focus()

func _on_input_submitted(command: String) -> void:
	# ... (Biarkan kode di dalam fungsi ini sama seperti sebelumnya) ...
	input_field.clear()
	
	output_log.text += "\n\n> " + command
	
	var words = command.split(" ")
	
	if words.size() == 2 and words[0].to_lower() == "hack":
		var target_id = words[1]
		var result = TerminalManager.execute_hack(target_id)
		output_log.text += "\n" + result
	else:
		output_log.text += "\nERROR: Perintah tidak valid. Gunakan format: hack [id_item]"
