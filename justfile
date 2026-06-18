# DeepMind Lab — native Apple Silicon (macOS) command runner.
# Run `just` to list recipes. Requires: bazelisk, just (brew install bazelisk just).

# The windowed game uses `--define=graphics=sdl`, a different build config from the
# headless agent. Give it its own Bazel output base so switching between `play`
# and `agent` doesn't keep discarding Bazel's analysis cache. The base lives
# OUTSIDE the repo (the macOS build sandbox forbids hardlinks inside the source
# tree, which the asset-packing genrule needs).
sdl_base := "/var/tmp/dmlab-bazel-sdl"

# Show the list of available commands.
default:
    @just --list

# Play a level yourself in a window (keyboard + mouse).
# Controls: W/A/S/D move, mouse look, Space jump, Ctrl crouch, Mouse1/C fire, Esc menu.
# Example: `just play lt_chasm`
play level="nav_maze_static_01":
    bazel --output_base={{sdl_base}} run -c opt //:game --define=graphics=sdl -- \
        --level_script={{level}} --num_episodes=100

# Run a random RL agent headless (no window; GPU-rendered observations).
# Example: `just agent nav_maze_static_01 5000`
agent level="tests/empty_room" steps="1000":
    bazel run -c opt //:python_random_agent -- \
        --level_script={{level}} --length={{steps}} --width=320 --height=240

# Build the headless Python module (deepmind_lab.so).
build:
    bazel build -c opt //:deepmind_lab.so

# Build the playable game binary.
build-game:
    bazel --output_base={{sdl_base}} build -c opt //:game --define=graphics=sdl

# List the levels you can pass to `play` / `agent`.
levels:
    @ls game_scripts/levels/*.lua | sed 's|game_scripts/levels/||;s|\.lua||'

# Remove Bazel build outputs (both the headless and the windowed-game caches).
clean:
    bazel clean
    -bazel --output_base={{sdl_base}} clean
