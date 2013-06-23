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
