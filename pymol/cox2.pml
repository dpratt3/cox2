# Load your COX-2 enzyme structure
load cox2.pdb

# Create an animation with 60 frames
mset 1 - 60

# Define view at frame 1
view (your_initial_view)

# Define view at frame 60
view (your_final_view)

# Interpolate between views
mview store

# Set up animation parameters
mview action, store, 1
mview action, interpolate, 1, 60

# Specify animation duration and frames per second
mview reinterpolate
mview control, total_duration=10.0
mview control, movie_fps=30

# Render animation frames
ray 800, 600

# Save the animation frames as an image sequence (PNG)
png your_output_frame_directory/frame_####.png

# Convert the image sequence to a video (MP4)
ffmpeg -framerate 30 -i your_output_frame_directory/frame_%04d.png -c:v libx264 -pix_fmt yuv420p your_output_video.mp4

