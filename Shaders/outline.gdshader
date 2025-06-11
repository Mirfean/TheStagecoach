shader_type canvas_item;
uniform float size;
uniform vec4 outline_color; // Domyślny kolor: żółty
uniform float outline_thickness : hint_range(0.0, 5.0) = 1.0; // Grubość obrysu

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//outline_color = vec4(1.0, 1.0, 0.0, 1.0);
	vec2 uv = UV;
    vec4 color = texture(TEXTURE, uv);

    // Sprawdź sąsiednie piksele, aby znaleźć krawędź
    float alpha_sum = 0.0;
    float pixel_size_x = 1.0 / float(textureSize(TEXTURE, 0).x);
    float pixel_size_y = 1.0 / float(textureSize(TEXTURE, 0).y);

    // Próbkuj piksele wokół aktualnego
    for (float x = -outline_thickness; x <= outline_thickness; x++) {
        for (float y = -outline_thickness; y <= outline_thickness; y++) {
            if (x == 0.0 && y == 0.0) continue; // Pomijamy środkowy piksel

            vec2 offset_uv = uv + vec2(x * pixel_size_x, y * pixel_size_y);
            alpha_sum += texture(TEXTURE, offset_uv).a;
        }
    }

    // Jeśli aktualny piksel jest przezroczysty, ale sąsiednie są widoczne
    if (color.a == 0.0 && alpha_sum > 0.0) {
        COLOR = outline_color; // Użyj koloru obrysu
    } else {
        COLOR = color; // Użyj oryginalnego koloru sprite'a
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
