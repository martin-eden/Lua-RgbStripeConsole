# What

(2024-09)

Lua interface for sending data to RGB stripe.

[Image][Images/Stripe.png]


## Design

RGB stripe is connected to Arduino. It has it's own [firmware]
(written by me in C++). It has text interface.

Lua is used in two roles here.

First is file sender. It opens Arduino as file "/dev/ttyUSB0". It opens
text file ["Data.Stripe"][Data.Stripe]. It sends lines from text file
to Arduino.

Second is file generator. Generally it's Lua program that generates
"Data.Stripe" text file.

One implementation is basic test (["MakeTest.lua"][MakeTest.lua]).

Other is "Plasm" gradient generation (["MakePlasm.lua"][MakePlasm.lua]).
I've figured out this algorithm like twenty years ago and implemented
2D versions in Delphi and QBASIC.


### 1D Plasm

Here is basic idea for 1D version.

We want to generate color for every pixel in stripe.

We're setting border pixels to some random colors.

Then we can just set middle pixel to average color and divide.

But it's boring. We should add some noise.

So we're adding noise. Noise is actually smooth random color function
between first and last pixels.

Noise amplitude is dependent of distance between pixels. (Like gravity
is inversely proportional to distance square. Same idea.)

So for first iteration for two border pixels noise amplitude will have
greatest potential. To make it random, we multiply amplitude by
random value in [-1.0, +1.0]:

```
Noise = NoiseFunc(Distance) * random(-1.0, +1.0)
```

Then we just calculate and add that noise value to averaged color of
middle pixel and divide. A lot more interesting!

Also we're adding some static noise. That made things look more
realistic in my 2D implementation. And multiplying by some scale factor
to have more or less color transitions in our stripe.

```
Noise = Scale * NoiseFunc(Distance) * NormalizedRandom() + StaticNoise()
```

Okay, but range of NoiseFunc() should be in [-1.0, +1.0]. So we normalize
it as `NoiseFunc(Distance) / NoiseFunc(MaxDistance)`.

And basically that's it.


#### Noise function

Generated gradient type is determined by NoiseFunc(). This function sets
degree of freedom for given distance.

Variants I've tried:

* Linear: `return Distance`
* Quadratic: `return Distance ^ 2`
* Square root: `return Distance ^ 0.5`
* Logarithmic: `return log(Distance, 2)`

Linear is okay but boring. Quadratic gives too small freedom after
normalization. Square root and logarithmic are okay.

Also I've tried `return 1 / Distance`. This makes noise function
discontinuous at every point and generates star-like gradient.
Weird but worth trying once.


## Requirements

For Lua side it's just Linux and stock Lua 5.3+.

For Arduino side you'll need Arduino (lol), WS2812B RGB stripe,
`arduino-cli` framework and my implementation.


## See also

* ["Server" part][firmware]
* [WS2812B driver](https://github.com/martin-eden/Embedded-me_Ws2812b)
* [My other repositories](https://github.com/martin-eden/contents)

[firmware]: https://github.com/martin-eden/Embedded-me_RgbStripeConsole
