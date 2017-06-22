use v6;
use Test;

# This test file tests the following set operators:
#   (-)     set difference (Texas)
#   ∖       set difference

# special case empties (with an empty internal hash)
my $esh  = do { my $sh = <a>.SetHash; $sh<a>:delete; $sh };
my $ebh  = do { my $bh = <a>.BagHash; $bh<a>:delete; $bh };
my $emh  = do { my $mh = <a>.MixHash; $mh<a>:delete; $mh };

my @triplets =

  # result should be a Set
  set(),                        set(),             set(),
  SetHash.new,                  SetHash.new,       set(),
  $esh,                         $esh,              set(),
  <a b>.Set,                    set(),             <a b>.Set,
  <a b>.SetHash,                set(),             <a b>.Set,
  <a b>.Set,                    <a b>.Set,         set(),
  <a b>.SetHash,                <a b>.SetHash,     set(),
  <a b>.Set,                    <c d>.Set,         <a b>.Set,
  <a b c>.Set,                  <b c d>.Set,       <a>.Set,
  <a b>.SetHash,                <c d>.SetHash,     <a b>.Set,
  <a b c>.SetHash,              <b c d>.SetHash,   <a>.Set,

  # result should be a Bag
  bag(),                        bag(),             bag(),
  BagHash.new,                  BagHash.new,       bag(),
  $ebh,                         $ebh,              bag(),
  <a b b>.Bag,                  bag(),             <a b b>.Bag,
  <a b b>.BagHash,              bag(),             <a b b>.Bag,
  <a b b>.Bag,                  <a b>.Bag,         <b>.Bag,
  <a b b>.BagHash,              <a b>.BagHash,     <b>.Bag,
  <a b b>.Bag,                  <c d>.Bag,         <a b b>.Bag,
  <a b b c>.Bag,                <b c d>.Bag,       <a b>.Bag,
  <a b b>.BagHash,              <c d>.BagHash,     <a b b>.Bag,
  <a b b c>.BagHash,            <b c d>.BagHash,   <a b>.Bag,

  # result should be a Mix
  mix(),                        mix(),             mix(),
  MixHash.new,                  MixHash.new,       mix(),
  $emh,                         $emh,              mix(),
  (a=>pi,b=>tau).Mix,           mix(),             (a=>pi,b=>tau).Mix,
  (a=>pi,b=>tau).MixHash,       mix(),             (a=>pi,b=>tau).Mix,
#  (a=>pi,b=>tau).Mix,           <a b>.Mix,         <a b>.Mix,
#  (a=>pi,b=>tau).MixHash,       <a b>.MixHash,     <a b>.Mix,
#  (a=>pi,b=>tau).Mix,           <c d>.Mix,         mix(),
#  (a=>pi,b=>tau).Mix,           <b c>.Mix,         <b>.Mix,
#  (a=>pi,b=>tau).MixHash,       <c d>.MixHash,     mix(),
#  (a=>pi,b=>tau).MixHash,       <b c>.MixHash,     <b>.Mix,

  # coercions
#  <a b>.Set,                    <a b b>.Bag,       <a b>.Bag,
#  <a b>.SetHash,                <a b b>.BagHash,   <a b>.Bag,

#  <a b>.Bag,                    <a b b>.Mix,       <a b>.Mix,
#  <a b>.BagHash,                <a b b>.MixHash,   <a b>.Mix,

#  <a b c>.Set,                  <a b c d>,         <a b c>.Set,
#  <a b c>.Bag,                  <a b c d>,         <a b c>.Bag,
#  <a b c>.Mix,                  <a b c d>,         <a b c>.Mix,

#  <a b c>,                      <c d e>,           <c>.Set,
#  (:42a,:0b),                   (:c,:42d,"e"),     set(),
#  (:42a,:0b),                   (:a,:42d,"e"),     <a>.Set,
#  {:42a,:0b},                   {:a,:c,:42d},      <a>.Set,
#  :{42=>"a",666=>""},           :{55=>"c",66=>1},  set(),
#  :{42=>"a",666=>""},           :{55=>"c",666=>1}, set(),
#  :{42=>"a",666=>""},           :{42=>"c",666=>1}, 42.Set,
#  :{42=>"a",666=>""},           {:c,:42d},         set(),
#  :{a=>42,666=>""},             {:a,:42d},         <a>.Set,
#  {:42a,:0b},                   <c d e>,           set(),
#  {:42a,:0b},                   <a d e>,           <a>.Set,
#  :{42=>"a",666=>""},           <a b c>,           set(),
#  :{a=>42,666=>""},             <a b c>,           <a>.Set,
#  42,                           666,               set(),
;

plan 2 * (2 * @triplets/3);

# difference
for
  &infix:<∖>,     "∖",
  &infix:<(-)>, "(-)"
-> &op, $name {
    for @triplets -> $left, $right, $result {
        is-deeply op($left,$right), $result,
          "$left.gist() $name $right.gist()";
    }
}

for
  &infix:<R∖>,     "R∖",
  &infix:<R(-)>, "R(-)"
-> &op, $name {
    for @triplets -> $left, $right, $result {
        is-deeply op($right,$left), $result,
          "$right.gist() $name $left.gist()";
    }
}

# vim: ft=perl6
