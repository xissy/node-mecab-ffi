# node-mecab-ffi

A node.js module for binding MeCab asynchronously using foreign function interface.

This module supports MacOS(surely Unix/Linux) and multi-thread safety.


## Installation

node-mecab-ffi depends on [MeCab](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html) v0.994 or higher.

Warning: To use libmecab in MacOS, you should install the newest gcc first and compile MeCab with it. Refer to [here](http://www.ficksworkshop.com/blog/14-coding/65-installing-gcc-on-mac). Otherwise it could split errors which cannot find dictionary directory or showing abort trap when you try to parse input strings.

Via [npm](https://npmjs.org):

    $ npm install mecab-ffi
  

## Quick Start

### Load in the module

    var mecab = require('mecab-ffi');

### Parse asynchronously
```javascript
  mecab.parse('test input string', function(err, result) {
    ...
  });
```

### Parse synchronously
```javascript
  result = mecab.parseSync('test input string');
```

## License

Released under the MIT License

Copyright (c) 2013 Taeho Kim <xissysnd@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
