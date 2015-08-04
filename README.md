# node-mecab-ffi

A node.js module for binding MeCab asynchronously using foreign function interface.
This module supports MacOS(surely Unix/Linux) and multi-thread safety.

If you want to use this module for Korean, please read the Korean [README](./README_ko.md)

## Installation

node-mecab-ffi depends on [MeCab](http://mecab.googlecode.com/svn/trunk/mecab/doc/index.html) v0.996 or higher.

Warning: 
To use libmecab in MacOS, you must install the newest gcc, automake and autoconf first and compile MeCab and dictonary with it. 
Refer to [here](http://www.ficksworkshop.com/blog/14-coding/65-installing-gcc-on-mac). Otherwise it could split errors which cannot find dictionary directory or showing abort trap when you try to parse input strings.

Via [npm](https://npmjs.org):
```
$ npm install mecab-ffi
```  

Via git directly:
```
$ npm install git+https://github.com/xissy/node-mecab-ffi.git
```

## Quick Start

### Load in the module

```
var mecab = require('mecab-ffi');
```

### Parse a string

#### Asynchronously

```javascript
//Korean Example
mecab.parse('한글 형태소 분석기를 테스트', function(err, result) {
  console.log (result);
});

//Result
[ [ '한글', 'NNG', '*', 'T', '한글', '*', '*', '*', '*', '*' ],
[ '형태소',
  'NNG',
  '*',
  'F',
  '형태소',
  'Compound',
  '*',
  '*',
  '형태+소',
  '형태/NNG/*/1/1+형태소/Compound/*/0/2+소/NNG/*/1/1' ],
[ '분석기',
  'NNG',
  '*',
  'F',
  '분석기',
  'Compound',
  '*',
  '*',
  '분석+기',
  '분석/NNG/*/1/1+분석기/Compound/*/0/2+기/NNG/*/1/1' ],
[ '를', 'JKO', '*', 'T', '를', '*', '*', '*', '*', '*' ],
[ '테스트', 'NNG', '*', 'F', '테스트', '*', '*', '*', '*', '*' ] ]

//Japaness Example
mecab.parse('ホリエモン市', function(err, result) {
  console.log (result);
});

//Result
[ [ 'ホリエモン', 'SL', '*', '*', '*', '*', '*', '*', '*', '*' ],
  [ '市', 'NNG', '*', 'F', '시', '*', '*', '*', '*', '*' ] ]

```

#### Synchronously
```javascript
result = mecab.parseSync('한글 형태소 분석기를 테스트');
console.log (result);

//Result

[ [ '한글', 'NNG', '*', 'T', '한글', '*', '*', '*', '*', '*' ],
  [ '형태소',
	'NNG',
	'*',
	'F',
	'형태소',
	'Compound',
	'*',
	'*',
	'형태+소',
	'형태/NNG/*/1/1+형태소/Compound/*/0/2+소/NNG/*/1/1' ],
  [ '분석기',
	'NNG',
	'*',
	'F',
	'분석기',
	'Compound',
	'*',
	'*',
	'분석+기',
	'분석/NNG/*/1/1+분석기/Compound/*/0/2+기/NNG/*/1/1' ],
  [ '를', 'JKO', '*', 'T', '를', '*', '*', '*', '*', '*' ],
  [ '테스트', 'NNG', '*', 'F', '테스트', '*', '*', '*', '*', '*' ] ]

```

### Extract nouns

#### Noun list
```javascript
mecab.extractNounMap('한글 형태소 분석기를 테스트', function(err, result) {
	console.log (result);
})

//Result
{ '한글': 1, '한글 형태소': 1, '형태소': 1, '형태소 분석기': 1, '분석기': 1, '테스트': 1 }
```

#### Noun Map
```javascript
var string = "황사바람 부는 거리에서 전경들이 점심을 먹는다.";
mecab.extractNounMap(string, function(err, result) {
	console.log (result);
})

//Result
{ '황사': 1,
  '황사 바람': 1,
  '바람': 1,
  '바람 부': 1,
  '부': 1,
  '거리': 1,
  '전경': 1,
  '점심': 1 }

```

#### Noun list sorted by count
```javascript
var string = "황사바람 부는 거리에서 전경들이 점심을 먹는다.";
mecab.extractSortedNounCounts(string, function(err, result) {
	console.log (result);
});

//Result
[ { noun: '황사', count: 1 },
  { noun: '황사 바람', count: 1 },
  { noun: '바람', count: 1 },
  { noun: '바람 부', count: 1 },
  { noun: '부', count: 1 },
  { noun: '거리', count: 1 },
  { noun: '전경', count: 1 },
  { noun: '점심', count: 1 } ]
```

### Get Dice-Coefficient

#### by two strings
```javascript
var string1 = "황사바람 부는 거리에서 전경들이 점심을 먹는다.";
var string2 = "강풍이 불고 거리에서 전경이 밥을 먹는다.";
mecab.getDiceCoefficientByString(string1, string2, function(err, result) {
	console.log (result);
});

//Result 
2
```

#### by two noun maps
You muse use three Async functions to make two maps and to compare. Without questions, you can use callback as below:
```javascript
var string1 = "황사바람 부는 거리에서 전경들이 점심을 먹는다.",
    string2 = "강풍이 불고 거리에서 전경이 밥을 먹는다.",
    shareData = {};

mecab.extractNounMap(string1, function (err, mapA) {
    shareData["mapA"] = mapA;
    mecab.extractNounMap(string2, function (err, mapB) {
        shareData["mapB"] = mapB;
        mecab.getDiceCoefficientByNounMap(shareData.mapA, shareData.mapB, function(err, result) {
            console.log (result);
	   });
    }); 
});

//Result
2

```
You, however, can use Promise patter, new ara of javascript with ES6 or promise library like bluebird. 
With bluebird, the code is easier to read and understand. 
```javascript
var mecab = require('mecab-ffi'),
  Promise = require('bluebird'),
  join = Promise.join;

var fAsyncExtractNounMap = Promise.promisify(mecab.extractNounMap),
    fAsyncgetDiceCoefficientByNounMap = Promise.promisify(mecab.getDiceCoefficientByNounMap),
    string1 = "황사바람 부는 거리에서 전경들이 점심을 먹는다.",
    string2 = "강풍이 불고 거리에서 전경이 밥을 먹는다.";

var fMap1 = fAsyncExtractNounMap(string1),
    fMap2 = fAsyncExtractNounMap(string2);

join (fMap1, fMap2, function (map1, map2) {
    return fAsyncgetDiceCoefficientByNounMap (map1, map2);
}).then(function (result) {
    console.log (result)
})

//Result
2
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


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/xissy/node-mecab-ffi/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

