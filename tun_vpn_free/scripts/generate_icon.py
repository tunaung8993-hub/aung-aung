"""
Generate app icon for Tun VPN Free
Creates a 1024x1024 PNG with shield + checkmark design
"""
from PIL import Image, ImageDraw, ImageFilter
import math
import os

def create_vpn_icon(size=1024):
    # Create image with dark background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Background circle
    margin = size * 0.04
    draw.ellipse(
        [margin, margin, size - margin, size - margin],
        fill=(26, 26, 46, 255)  # Dark navy
    )
    
    # Shield path points (scaled to size)
    def scale(x, y):
        return (x * size, y * size)
    
    # Draw shield glow
    shield_points = [
        scale(0.5, 0.08),
        scale(0.88, 0.22),
        scale(0.88, 0.54),
        scale(0.88, 0.76),
        scale(0.72, 0.90),
        scale(0.5, 0.95),
        scale(0.28, 0.90),
        scale(0.12, 0.76),
        scale(0.12, 0.54),
        scale(0.12, 0.22),
    ]
    
    # Draw outer glow (multiple layers)
    for glow_size in [20, 14, 8]:
        glow_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        glow_draw = ImageDraw.Draw(glow_img)
        glow_draw.polygon(shield_points, fill=(0, 200, 83, 40))
        glow_img = glow_img.filter(ImageFilter.GaussianBlur(glow_size))
        img = Image.alpha_composite(img, glow_img)
    
    draw = ImageDraw.Draw(img)
    
    # Shield gradient fill (simulate with multiple polygons)
    # Dark green to lighter green
    shield_colors = [
        (0, 160, 64, 255),   # Dark green
        (0, 180, 72, 255),
        (0, 200, 83, 255),   # Primary green
    ]
    
    # Main shield fill
    draw.polygon(shield_points, fill=(0, 180, 72, 255))
    
    # Inner highlight
    inner_points = [
        scale(0.5, 0.14),
        scale(0.82, 0.27),
        scale(0.82, 0.54),
        scale(0.82, 0.73),
        scale(0.68, 0.85),
        scale(0.5, 0.89),
        scale(0.32, 0.85),
        scale(0.18, 0.73),
        scale(0.18, 0.54),
        scale(0.18, 0.27),
    ]
    draw.polygon(inner_points, fill=(0, 200, 83, 200))
    
    # Shield border
    draw.polygon(shield_points, outline=(0, 230, 100, 255), width=int(size * 0.025))
    
    # Top highlight on shield
    highlight_points = [
        scale(0.5, 0.08),
        scale(0.88, 0.22),
        scale(0.88, 0.35),
        scale(0.5, 0.28),
        scale(0.12, 0.35),
        scale(0.12, 0.22),
    ]
    draw.polygon(highlight_points, fill=(255, 255, 255, 25))
    
    # Draw checkmark
    check_color = (255, 255, 255, 255)
    line_width = int(size * 0.065)
    
    # Checkmark points
    p1 = scale(0.30, 0.54)
    p2 = scale(0.46, 0.68)
    p3 = scale(0.72, 0.40)
    
    # Draw checkmark with rounded caps
    draw.line([p1, p2], fill=check_color, width=line_width)
    draw.line([p2, p3], fill=check_color, width=line_width)
    
    # Round the line joints
    cap_r = line_width // 2
    for point in [p1, p2, p3]:
        draw.ellipse(
            [point[0] - cap_r, point[1] - cap_r,
             point[0] + cap_r, point[1] + cap_r],
            fill=check_color
        )
    
    return img

def main():
    output_dir = os.path.join(os.path.dirname(__file__), '..', 'assets', 'images')
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate main app icon
    icon = create_vpn_icon(1024)
    icon_path = os.path.join(output_dir, 'app_icon.png')
    icon.save(icon_path, 'PNG')
    print(f"Saved app icon: {icon_path}")
    
    # Generate foreground icon (for adaptive icons)
    fg_icon = create_vpn_icon(1024)
    fg_path = os.path.join(output_dir, 'app_icon_fg.png')
    fg_icon.save(fg_path, 'PNG')
    print(f"Saved foreground icon: {fg_path}")
    
    # Generate smaller preview
    preview = icon.resize((256, 256), Image.LANCZOS)
    preview_path = os.path.join(output_dir, 'icon_preview.png')
    preview.save(preview_path, 'PNG')
    print(f"Saved preview: {preview_path}")

if __name__ == '__main__':
    main()
