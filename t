{ command -v magick 1>/dev/null && command -v ffmpeg 1>/dev/null && ls $PREFIX/libexec/termux-api 1>/dev/null 2>/dev/null ; } || pkg install ffmpeg imagemagick termux-api
