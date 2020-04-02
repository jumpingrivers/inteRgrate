FROM jumpingrivers/base-image

RUN install2.r -n -1 -d TRUE --error inteRgrate \
    && rm -rf /tmp/downloaded_packages/
