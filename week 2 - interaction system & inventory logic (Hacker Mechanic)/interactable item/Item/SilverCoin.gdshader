shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.6); 
uniform float shine_speed = 2.0; 
uniform float shine_width = 0.05; 

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float shine = step(1.0 - shine_width, sin(UV.x - UV.y + (TIME * shine_speed)));
    
    // Menambahkan efek kilauan hanya pada bagian sprite yang memiliki warna (tidak transparan)
    COLOR = tex_color + (shine_color * shine * tex_color.a);
}
