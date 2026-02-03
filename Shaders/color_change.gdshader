shader_type canvas_item;

uniform vec4 color_tint : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Kolor
uniform float brightness : hint_range(0.0, 1.0) = 1.0;            // Jasność
uniform float tint_strength : hint_range(0.0, 1.0) = 0.0;        // Intensywność koloru

void fragment() {
    // Pobieramy kolor aktualnego piksela tekstury
    vec4 tex_color = texture(TEXTURE, UV);

    // Mieszamy oryginalny kolor z wybranym kolorem tintu
    vec3 mixed_color = mix(tex_color.rgb, color_tint.rgb, tint_strength);

    // Nakładamy jasność (przyciemnianie)
    vec3 final_color = mixed_color * brightness;

    // Zwracamy wynikowy kolor z zachowaniem oryginalnej przezroczystości (alfa)
    COLOR = vec4(final_color, tex_color.a);
}