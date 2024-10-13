# What

(2024-09/2024-10)

Lua interface for sending data to RGB stripe.

![Image](Images/Stripe.png)

## Lua code example

Excerpt from [MakeTest.lua](MakeTest.lua).

```Lua
local Blue = { Red = 0, Green = 0, Blue = 255 }
local Green = { Red = 0, Green = 255, Blue = 0 }
local Red = { Red = 255, Green = 0, Blue = 0 }

Stripe:SetPixel({ Index = 12, Color = Blue })
Stripe:SetPixel({ Index = 30, Color = Green })
Stripe:SetPixel({ Index = 48, Color = Red })

Stripe:Display()
```

## Design

RGB stripe is connected to Arduino. On Arduino is [firmware][firmware]
(written by me in C++). It has text interface.

Lua is used in two roles here.

* File sender

  Sends `Data.Stripe` to Arduino.

* Data generator

  That's what example code uses. Creates `Data.Stripe` file.


## Files

* [MakeTest.lua](MakeTest.lua) is a basic test.

  It creates data file.

* [MakePlasm.lua](MakePlasm.lua) is a "Plasm" gradient generator.

  I've figured out this algorithm like twenty years ago and implemented
  2D versions in Delphi and QBASIC.

  It creates data file.

  Data file is recompiled to reduce transfer time. It's cool but
  not necessary step.

* [SendData.lua](SendData.lua) is a file sender.

  Sends data file.

  It opens Arduino as device at `/dev/ttyUSB0`. Opens file
  [`Data.Stripe`](Data.Stripe). And sends it line-by-line.


### 1D Plasm

Here is basic idea for 1D version.

We want to generate color for every pixel in stripe.

We're setting border pixels to some random colors.

Then we can just set middle pixel to average color and divide.

But it's boring. We should add some noise.

So we're adding noise. Noise is actually smooth random color function
between first and last pixels. Value range [-1.0, +1.0].

Noise amplitude is dependent of distance between pixels. (Like gravity
is inversely proportional to distance square. Same idea.)

So for first iteration for two border pixels noise amplitude will have
greatest potential. To make it random, we multiply amplitude by
random value in [-1.0, +1.0]:

```
Noise = NoiseAmpl(Distance) * random(-1.0, +1.0)
```

Then we will amplify that noise to max color value and add it to
averaged color of middle pixel and divide. A lot more interesting!

```
ColorComponentNoise = floor(Noise * 0xFF)
```

To have more or less color transitions in our stripe, we're multiplying
distance by scale factor, keeping it in [0.0, 1.0] range:

```
Distance = Clamp(Scale * Distance, 0.0, 1.0)
```

And basically that's it.


#### Noise function

Generated gradient type is determined by noise amplitude function:

```
NoiseAmpl(Distance: [0.0, 1.0]): [-1.0, +1.0]
```

This function sets degree of freedom for given distance. Moreover,
it determines how degree of freedom changes when distance is decreasing.

I've tried several variants. Sine, quarter of circle, power.
You can find them in [MakePlasm.lua](MakePlasm.lua).

Tinkering with this function is fun!


## Requirements

For Lua side it's just Linux, stock Lua 5.3+ and this repo.

For Arduino side you'll need Arduino (lol), WS2812B RGB stripe,
`arduino-cli` framework and [my implementation][firmware].


## See also

* [Server part][firmware]
* [My other repositories][contents]

[firmware]: https://github.com/martin-eden/Embedded-me_RgbStripeConsole
[contents]: https://github.com/martin-eden/contents
