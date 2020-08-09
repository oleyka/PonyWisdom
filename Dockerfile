FROM alpine:3.9

RUN apk add curl g++ git fortune make pango-dev py-cairo-dev python3 texinfo ttf-freefont --no-cache
WORKDIR /build
RUN git clone https://github.com/erkin/ponysay.git; \
    cd ponysay; \
    python3 setup.py install --freedom=partial

RUN git clone https://gitlab.com/saalen/ansifilter.git; \
    cd ansifilter; \
    make; \
    make install

RUN curl https://imagemagick.org/download/ImageMagick.tar.gz > ImageMagick.tar.gz; \
    tar zxvf ImageMagick.tar.gz; \
    cd ImageMagick-*; \
    ./configure --with-pango; \
    make; \
    make install

RUN apk del curl g++ git make --no-cache; \
    rm -rf /build

WORKDIR /root
COPY ponysay.sh ponysay.sh

VOLUME /out

ENTRYPOINT ["./ponysay.sh"]
