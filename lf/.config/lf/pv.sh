#!/bin/sh
# lf previewer. Arguments: file width height x y mode

file="$1"
width="$2"
height="$3"
x="$4"
y="$5"
mode="$6"

# Which terminal is attached. Inside tmux the environment describes the tmux
# server rather than the client, so ask tmux for the client's terminal.
if [ -n "$TMUX" ]; then
    termname=$(tmux display-message -p '#{client_termname}')
else
    termname="$TERM"
fi

# How images are drawn. "kitty" and "iterm" are real pixels written straight to
# the terminal, "sixels" is real pixels rendered by lf itself, "symbols" is
# colored character art that works anywhere. Override with LF_IMAGE_FORMAT.
case "${LF_IMAGE_FORMAT:-auto}" in
    auto)
        case "$termname" in
            *ghostty*|*kitty*) format=kitty ;;
            *) format=symbols ;;
        esac
        ;;
    *) format="$LF_IMAGE_FORMAT" ;;
esac

# lf can only render sixel itself, so kitty and iterm images go directly to the
# terminal, positioned over the preview pane. Exiting non-zero tells lf not to
# cache the preview, which is what makes it call the cleaner and re-run this
# script on the next selection.
draw_over_pane() {
    if [ "$mode" = preload ]; then
        exit 1
    fi
    printf '\033[%d;%dH' "$((y + 1))" "$((x + 1))" > /dev/tty
    chafa -f "$format" -s "${width}x${height}" \
        --animate off --polite on --passthrough auto -- "$file" > /dev/tty
    exit 1
}

ext=$(printf '%s' "${file##*.}" | tr '[:upper:]' '[:lower:]')

case "$ext" in
    png|jpg|jpeg|gif|webp|bmp|tif|tiff|svg|avif|heic)
        case "$format" in
            kitty|iterm) draw_over_pane ;;
            *) chafa -f "$format" -s "${width}x${height}" \
                   --animate off --polite on --passthrough auto -- "$file" ;;
        esac
        ;;
    pdf)
        pdftotext -l 10 -nopgbrk -q -- "$file" -
        ;;
    zip)
        unzip -l -- "$file"
        ;;
    tar|tgz|tbz|txz)
        tar tf "$file"
        ;;
    *)
        cat -- "$file"
        ;;
esac
