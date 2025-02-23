shader_type canvas_item;

uniform sampler2D base_texture; // The original texture
uniform sampler2D paint_texture; // The texture where we draw
uniform vec4 brush_color : source_color; // Color of the brush
uniform float brush_size; // Size of the brush
uniform vec2 screen_size; // Screen dimensions

void fragment() {
    vec2 uv = FRAGCOORD.xy / screen_size; // Convert fragment coords to UV
    vec4 base_col = texture(base_texture, uv); // Get base texture color
    vec4 paint_col = texture(paint_texture, uv); // Get paint texture color
    
    if (paint_col.a > 0.0) { // If there's a drawn pixel
        COLOR = mix(base_col, brush_color, paint_col.a); // Blend with base texture
    } else {
        COLOR = base_col; // Keep original texture
    }
}
