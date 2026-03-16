# terminal_manager.gd
extends Node
var is_open: bool = false
# Dictionary untuk menyimpan item berdasarkan ID unik jaringan
var network_nodes: Dictionary = {}

# Fungsi untuk item mendaftarkan dirinya ke jaringan
func register_node(network_id: String, node: Node) -> void:
	network_nodes[network_id] = node

# Fungsi untuk menghapus item dari jaringan (saat item sudah diambil/dihancurkan)
func unregister_node(network_id: String) -> void:
	if network_nodes.has(network_id):
		network_nodes.erase(network_id)

# Fungsi yang akan dipanggil oleh UI Terminal kamu
func execute_hack(network_id: String) -> String:
	if network_nodes.has(network_id):
		var target_node = network_nodes[network_id]
		if target_node.has_method("remote_hack"):
			target_node.remote_hack()
			return "SUCCESS: Node " + network_id + " berhasil diakses."
		else:
			return "ERROR: Node tidak memiliki sistem keamanan yang bisa diretas."
	else:
		return "ERROR: Node '" + network_id + "' tidak ditemukan di jaringan."
