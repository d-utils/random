# random

[![DUB Package](https://img.shields.io/dub/v/dutils-random.svg)](https://code.dlang.org/packages/dutils-random)
[![Posix Build Status](https://travis-ci.org/d-utils/random.svg?branch=master)](https://travis-ci.org/d-utils/random)

Various safer random functions (currently runs on Linux only)

## example

    import dutils.random : randomUUID;

    auto id = randomUUID();
