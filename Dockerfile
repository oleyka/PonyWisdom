FROM alpine

RUN apk add curl g++ git fortune make pango-dev py-cairo-dev python3 texinfo ttf-freefont --no-cache
WORKDIR /build
RUN git clone https://github.com/erkin/ponysay.git; \
    cd ponysay; \
    python3 setup.py install --freedom=strict

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
RUN echo "#!/bin/sh" > ponysay.sh; \
    echo "fortune | ponysay --wrap 120 > /tmp/pony.ansi" >> ponysay.sh; \
    echo "ansifilter -i /tmp/pony.ansi -o /tmp/pony.pango --pango --font=FreeMono --font-size=44" >> ponysay.sh; \
    echo "convert -background transparent -border 44 pango:@/tmp/pony.pango /tmp/pony.png" >> ponysay.sh; \
    echo "cp /tmp/pony.png /out/pony.png" >> ponysay.sh; \
    chmod +x ./ponysay.sh

VOLUME /out

# ENTRYPOINT ["/bin/sh"]
ENTRYPOINT ["./ponysay.sh"]
