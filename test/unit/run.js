
var tape = require('tape');
var common = {};

var tests = [
  require('./controller/index'),
  require('./controller/suggest'),
  require('./sanitiser/suggest'),
  require('./query/indeces'),
  require('./query/suggest')
];

tests.map(function(t) {
  t.all(tape, common);
});