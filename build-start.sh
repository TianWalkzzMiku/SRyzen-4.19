#!/usr/bin/env bash
# Copyright (C) 2020-2022 Oktapra Amtono <oktapra.amtono@gmail.com>
# Docker Kernel Build Script

# Clone kernel source
if [[ "$*" =~ "beta" ]]; then
    git clone --depth=1 https://github.com/TianWalkzzMiku/SRyzen-4.19 -b stable kernel
    cd kernel || exit
fi

# Clone toolchain
if [[ "$*" =~ "clang" ]]; then
    git clone --depth=1 https://gitlab.com/Panchajanya1999/azure-clang clang
elif [[ "$*" =~ "gcc" ]]; then
    git clone --depth=1 https://github.com/okta-10/gcc-arm32.git arm32
    git clone --depth=1 https://github.com/okta-10/gcc-arm64.git arm64
fi

# Clone anykernel3
git clone --depth=1 https://github.com/TianWalkzzMiku/AnyKernel3.git -b whyred ak3-whyred

# Telegram setup
push_message() {
    curl -s -X POST \
        https://api.telegram.org/bot"{$TG_BOT_TOKEN}"/sendMessage \
        -d chat_id="${TG_CHAT_ID}" \
        -d text="$1" \
        -d "parse_mode=html" \
        -d "disable_web_page_preview=true"
}

# Push message to telegram
push_message "
<b>======================================</b>
<b>Start Building :</b> <code>SuperRyzen Kernel</code>
<b>Linux Version :</b> <code>$(make kernelversion | cut -d " " -f5 | tr -d '\n')</code>
<b>Source Branch :</b> <code>$(git rev-parse --abbrev-ref HEAD)</code>
<b>======================================</b> "