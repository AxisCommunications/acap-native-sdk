# Repository and tag variables
ARG ARCH=armv7hf
ARG VERSION=3.2
ARG TOOLCHAINS_UBUNTU_VERSION=19.10
ARG UBUNTU_VERSION=20.04
ARG REPO=axisecp
ARG PKG_ARCH=cortexa9hf-neon-poky-linux-gnueabi

FROM ${REPO}/acap-api:${VERSION}-${ARCH}-ubuntu${TOOLCHAINS_UBUNTU_VERSION} as api
FROM ${REPO}/acap-toolchain:${VERSION}-${ARCH}-ubuntu${TOOLCHAINS_UBUNTU_VERSION} as toolchain
FROM ubuntu:${UBUNTU_VERSION} as native-api
ARG PKG_ARCH
ARG API_DIR=/opt/axis/sdk/temp/sysroots/${PKG_ARCH}/usr
ARG NATIVE_DIR=/axis/device-api

# APIs included in Native SDK scope from Classic SDK
COPY --from=api ${API_DIR}/include/larod.h ${NATIVE_DIR}/include/
COPY --from=api ${API_DIR}/include/licensekey* ${NATIVE_DIR}/include/
COPY --from=api ${API_DIR}/include/axoverlay.h ${NATIVE_DIR}/include/
# temp removing opencl since it doesn't exist in aarch64
# COPY --from=api ${API_DIR}/include/CL/opencl? ${NATIVE_DIR}/include/
COPY --from=api ${API_DIR}/include/cairo ${NATIVE_DIR}/include/cairo
COPY --from=api ${API_DIR}/include/vdo ${NATIVE_DIR}/include/vdo
COPY --from=api ${API_DIR}/include/axsdk/axevent.h ${NATIVE_DIR}/include/axsdk/axevent.h
COPY --from=api ${API_DIR}/include/axsdk/axevent ${NATIVE_DIR}/include/axsdk/axevent

# Direct dependencies from Classic SDK
COPY --from=api ${API_DIR}/lib/pkgconfig/liblarod.pc \
  ${API_DIR}/lib/pkgconfig/vdostream.pc \
  ${API_DIR}/lib/pkgconfig/axevent.pc \
  ${API_DIR}/lib/pkgconfig/axoverlay.pc\
  ${API_DIR}/lib/pkgconfig/opencl.pc* \
  ${API_DIR}/lib/pkgconfig/cairo.pc ${NATIVE_DIR}/lib/pkgconfig/

COPY --from=api ${API_DIR}/lib/liblarod* \
  ${API_DIR}/lib/libvdostream* \
  ${API_DIR}/lib/libaxevent* \
  ${API_DIR}/lib/liblicensekey* \
  ${API_DIR}/lib/libaxoverlay* \
  ${API_DIR}/lib/libOpenCL* \
  ${API_DIR}/lib/libcairo* ${NATIVE_DIR}/lib/

# AXIS specific dependencies from Classic SDK
COPY --from=api ${API_DIR}/lib/libevent2* \
  ${API_DIR}/lib/libaxpackage* \
  ${API_DIR}/lib/libpolicykit_system* \
  ${API_DIR}/lib/libfido* ${NATIVE_DIR}/lib/

# Standard Linux dependencies from Classic SDK
COPY --from=api ${API_DIR}/include/glib-2.0 ${NATIVE_DIR}/include/glib-2.0
COPY --from=api ${API_DIR}/lib/glib-2.0 ${NATIVE_DIR}/lib/glib-2.0

COPY --from=api ${API_DIR}/lib/pkgconfig/glib-2.0.pc \
  ${API_DIR}/lib/pkgconfig/libpcre* \
  ${API_DIR}/lib/pkgconfig/gio-2.0.pc \
  ${API_DIR}/lib/pkgconfig/gobject-2.0.pc \
  ${API_DIR}/lib/pkgconfig/gio-unix-2.0.pc \
  ${API_DIR}/lib/pkgconfig/libffi.pc \
  ${API_DIR}/lib/pkgconfig/gmodule-no-export-2.0.pc \
  ${API_DIR}/lib/pkgconfig/zlib.pc \
  ${API_DIR}/lib/pkgconfig/libsystemd* \
  ${API_DIR}/lib/pkgconfig/pixman-1.pc \
  ${API_DIR}/lib/pkgconfig/fontconfig.pc \
  ${API_DIR}/lib/pkgconfig/freetype2.pc \
  ${API_DIR}/lib/pkgconfig/libpng.pc \
  ${API_DIR}/lib/pkgconfig/uuid.pc \
  ${API_DIR}/lib/pkgconfig/expat.pc ${NATIVE_DIR}/lib/pkgconfig/

COPY --from=api ${API_DIR}/lib/libglib-2.0* \
  ${API_DIR}/lib/libpcre* \
  ${API_DIR}/lib/libpthread* \
  ${API_DIR}/lib/libgobject* \
  ${API_DIR}/lib/libxmlnode* \
  ${API_DIR}/lib/libglib-utils* \
  ${API_DIR}/lib/libsystemd* \
  ${API_DIR}/lib/libgio-2.0* \
  ${API_DIR}/lib/libconfutils* \
  ${API_DIR}/lib/libexpat* \
  ${API_DIR}/lib/libffi* \
  ${API_DIR}/lib/librt* \
  ${API_DIR}/lib/libcap* \
  ${API_DIR}/lib/libgmodule-2.0* \
  ${API_DIR}/lib/libz* \
  ${API_DIR}/lib/libresolv* \
  ${API_DIR}/lib/libdl* \
  ${API_DIR}/lib/libcrypto* \
  ${API_DIR}/lib/libpixman-1* \
  ${API_DIR}/lib/libfontconfig* \
  ${API_DIR}/lib/libfreetype* \
  ${API_DIR}/lib/libpng* \
  ${API_DIR}/lib/libuuid* \
  ${API_DIR}/lib/libexpat* \
  ${API_DIR}/lib/libjansson* \
  ${API_DIR}/lib/libGLESv2* \
  ${API_DIR}/lib/libEGL* \
  ${API_DIR}/lib/libGAL* \
  ${API_DIR}/lib/libVSC* ${NATIVE_DIR}/lib/

FROM ubuntu:${UBUNTU_VERSION}
ARG PKG_ARCH
ENV DEBIAN_FRONTEND=noninteractive

# Install packages needed for interactive users and some additional libraries
# - curl, iputils-ping: required by eap-install.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
  crossbuild-essential-armhf \
  crossbuild-essential-arm64 \
  make \
  pkg-config \
  python3-pip \
  python3-jsonschema \
  curl \
  iputils-ping \
  xz-utils \
  git \
  less \
  vim

# Copy and install the tools and scripts from toolchain container
COPY --from=toolchain /opt/axis/sdk/temp /opt/axis/acapsdk
COPY --from=toolchain /opt/axis/tools /opt/axis/tools
RUN apt-get install -y /opt/axis/tools/axis-acap-manifest-tools*.deb && \
  pip3 install /opt/axis/tools/Larodconverter*.whl && \
  rm -rf /opt/axis/tools

# Update paths in environment-setup script
RUN sed -i 's:/opt/axis/sdk:/opt/axis/acapsdk:g' /opt/axis/acapsdk/environment-setup*

# Copy the lib, include, .pc from API container
COPY --from=native-api /axis/device-api/ /opt/axis/acapsdk/sysroots/${PKG_ARCH}/usr/

# Make the environment sourced for interactive Bash users
RUN printf "\n# Source SDK for all users\n. /opt/axis/acapsdk/environment-*\n" >> /etc/bash.bashrc

# Set workdir
WORKDIR /opt/app
