async = require 'async'

ref = require 'ref'
ffi = require 'ffi'


# types
ModelType = ref.types.void
ModelTypePtr = ref.refType ModelType

TaggerType = ref.types.void
TaggerTypePtr = ref.refType TaggerType

LatticeType = ref.types.void
LatticeTypePtr = ref.refType LatticeType


# libmecab
libMecab = ffi.Library 'libmecab',
  'mecab_model_new2': [ ModelTypePtr, [ 'string' ] ]
  'mecab_model_destroy': [ 'void', [ ModelTypePtr ] ]
  'mecab_model_new_tagger': [ TaggerTypePtr, [ ModelTypePtr ] ]
  'mecab_model_new_lattice': [ LatticeTypePtr, [ ModelTypePtr ] ]
  'mecab_lattice_set_sentence': [ 'void', [ LatticeTypePtr, 'string' ] ]
  'mecab_parse_lattice': [ 'void', [ TaggerTypePtr, LatticeTypePtr ] ]
  'mecab_lattice_tostr': [ 'string', [ LatticeTypePtr ] ]
  'mecab_lattice_clear': [ 'void', [ LatticeTypePtr ] ]
  'mecab_lattice_destroy': [ 'void', [ LatticeTypePtr ] ]
  'mecab_strerror': [ 'string', [ TaggerTypePtr ] ]


# init
modelPtr = libMecab.mecab_model_new2 ''
if modelPtr.isNull()
  return throw new Error 'Failed to create a new model'

taggerPtr = libMecab.mecab_model_new_tagger modelPtr
if taggerPtr.isNull()
  libMecab.mecab_model_destroy modelPtr
  return throw new Error 'Failed to create a new tagger'



class MeCab


parseMeCabOutputString = (outputString) ->
  result = []
  outputString.split('\n').forEach (line) ->
    result.push line.replace('\t', ',').split(',')
  
  result[0...-2]



MeCab.parse = (inputString, callback) ->
  async.waterfall [
    (callback) ->
      libMecab.mecab_model_new_lattice.async modelPtr, (err, latticePtr) ->
        return callback new Error 'Failed to create a new lattice'  if latticePtr.isNull()
        callback err, latticePtr
  ,
    (latticePtr, callback) ->
      libMecab.mecab_lattice_set_sentence.async latticePtr, inputString, (err) -> 
        callback err, latticePtr
  ,
    (latticePtr, callback) ->
      libMecab.mecab_parse_lattice.async taggerPtr, latticePtr, (err) ->
        callback err, latticePtr
  ,
    (latticePtr, callback) ->
      libMecab.mecab_lattice_tostr.async latticePtr, (err, outputString) ->
        callback err, latticePtr, outputString
  ,
    (latticePtr, outputString, callback) ->
      libMecab.mecab_lattice_destroy.async latticePtr, (err) ->
        callback err, outputString

  ], (err, outputString) ->
    return callback err  if err?
    
    callback null, parseMeCabOutputString outputString



MeCab.parseSync = (inputString) ->
  latticePtr = libMecab.mecab_model_new_lattice modelPtr
  return throw new Error 'Failed to create a new lattice'  if latticePtr.isNull()

  libMecab.mecab_lattice_set_sentence latticePtr, inputString
  libMecab.mecab_parse_lattice taggerPtr, latticePtr
  outputString = libMecab.mecab_lattice_tostr latticePtr
  libMecab.mecab_lattice_destroy latticePtr

  parseMeCabOutputString outputString



module.exports = MeCab
