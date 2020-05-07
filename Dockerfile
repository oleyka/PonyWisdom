FROM alpine

RUN apk add curl g++ git fortune make pango-dev py-cairo-dev python3 ttf-freemono --no-cache
RUN git clone https://github.com/erkin/ponysay.git; \
    cd ponysay; \
    python3 setup.py install --freedom=partial; \
    cd /; \
    rm -rf /ponysay; \
    which ponysay

RUN git clone https://gitlab.com/saalen/ansifilter.git; \
    cd ansifilter; \
    make; \
    make install; \
    cd /; \
    rm -rf /ansifilter; \
    which ansifilter

RUN curl https://imagemagick.org/download/ImageMagick.tar.gz > /ImageMagick.tar.gz; \
    tar zxvf /ImageMagick.tar.gz; \
    cd /ImageMagick-*; \
    ./configure --with-pango; \
    make; \
    make install; \
    cd /; \
    rm -rf ImageMagick*; \
    magick -version

RUN apk del curl g++ git make --no-cache

ARG SCRIPT=/root/ponysay.sh
RUN echo "#!/bin/sh" > $SCRIPT; \
    echo "fortune | ponysay --wrap 96 > /tmp/pony.ansi" >> $SCRIPT; \
    echo "ansifilter -i /tmp/pony.ansi -o /tmp/pony.pango --pango --font=FreeMono --font-size=44" >> $SCRIPT; \
    echo "convert -background -border 44 transparent pango:@/tmp/pony.pango /tmp/pony.png" >> $SCRIPT; \
    chmod +x $SCRIPT

VOLUME /out

ENTRYPOINT ["/bin/sh"]
# ENTRYPOINT ["/root/ponysay.sh"]
# NOTE do I need texinfo?
