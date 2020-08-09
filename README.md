# Pony Wisdom coming out of the little docker stable

## To build:

```
docker build -t oleyka/ponysay .
```

## To push:

```
docker push oleyka/ponysay
```

## To run:

```
docker run -v$(pwd):/out oleyka/ponysay
```

This drops a random pony fortune into file `pony.png` in your current directory.

### Additional parameters:

The following optional parameters can be passed to the shell script:

```
-c|--count <number>:   amount of ponies to generate (default: 1)
-f|--font <fontname>:  use a custom font (default: FreeMono)
-q|--quote <phrase>:   phrase for pony to say (default: unset, use fortune)
-s|--size <number>:    specify a font size (default: 44)
                       font sizes affect the image size and the quality of a resulting image
                       known good values for the default font are: 14, 15, 44, 45, 46, 48
-w|--wrap <number>:    wrap text at a certain number of characters (default: 120)
```

