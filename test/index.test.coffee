should = require 'should'
async = require 'async'

mecab = require '../lib/index'


describe 'mecab', ->
  inputString = '안녕하세요.테스트데이터입니다.'

  describe '.parse(...)', ->
    it 'should be done', (done) ->
      mecab.parse inputString, (err, result) ->
        should.not.exist err
        should.exist result
        done()


  describe '.parseSync(...)', ->
    it 'should be done', (done) ->
      result = mecab.parseSync inputString
      should.exist result
      done()


  describe 'muptiple parse(...)', ->
    it 'should be done', (done) ->
      async.forEach [1..100]
      ,
        (i, callback) ->
          mecab.parse "#{i}", callback
      ,
        (err) ->
          should.not.exist err
          done()


  describe 'getDiceCoefficientByString(...)', ->
    it 'should be done', (done) ->
      strA = '한국이 국제축구연맹(FIFA) 터키 20세 이하 월드컵 16강에 진출했다.'
      strB = '국제축구연맹(FIFA) 20세 이하 월드컵에 나선 어린 태극전사들이 16강 직행티켓을 놓쳤다.'
      
      mecab.getDiceCoefficientByString strA, strB, (err, result) ->
        should.not.exist err
        should.exist result
        done()
