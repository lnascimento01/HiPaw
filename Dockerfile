FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk \
    cmake ninja-build pkg-config libgtk-3-dev \
    clang build-essential wget \
    android-sdk-platform-tools-common \
    && rm -rf /var/lib/apt/lists/*

ENV ANDROID_SDK_ROOT=/usr/lib/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    curl -O https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    unzip commandlinetools-linux-11076708_latest.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools/tmp && \
    mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/tmp/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ && \
    rm -rf ${ANDROID_SDK_ROOT}/cmdline-tools/tmp && \
    rm commandlinetools-linux-11076708_latest.zip

RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --update && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
        "platform-tools" \
        "cmdline-tools;latest" \
        "platforms;android-31" "build-tools;31.0.0" \
        "platforms;android-33" "build-tools;33.0.2" \
        "platforms;android-34" "build-tools;34.0.0"

RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz && \
    tar xf flutter_linux_3.24.5-stable.tar.xz -C /opt && \
    rm flutter_linux_3.24.5-stable.tar.xz

RUN rm -rf /root/.gradle/caches

RUN git config --global --add safe.directory /opt/flutter

RUN flutter --version
RUN flutter doctor

RUN rm -rf /root/.gradle/caches /root/.gradle/daemon

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /app
CMD ["bash"]
