#!/usr/local/bin/perl

use strict;

use warnings;
use feature qw(say);
use Test::More;

is( min_flips('101100101',3), 1 );
is( min_flips('10110111', 4), 2 );
is( min_flips('100101100',3), 1 );
is( min_flips('101100100100101',3), 2 );
is( min_flips('101101',3), 0 );
is( min_flips('0000000100100011010001010110011110001001101010111100110111101111',4), 32 );

done_testing();

##  As the first problem was a good one for applying "Golfing"
##  techniques to it - I thought I would play along and try the
##  second one....
##  Notes
##
##  This was to use this to serve as an example of perl idioms
##  that other programmers may find it difficult to understand
##  - and so I tried to put as many of them in relatively short
##  function.... a discussion thread on the Perl programmers
##  facebook group.
##
##  * One statement functions are a "lovely" perl concept - even if
##    they can get a bit difficult to read....
##
##  * In perl there are special variables which give you information
##    about the current process, or allow us to alter the
##    functionality. To avoid creating variables I use these in the
##    function. If you change these you can change how the code works -
##    but here we use "local" copies - so that when we return from the
##    function (block) they revert to their normal values - so we
##    don't introduce any side-effects of our code
##
##    * $/ - normally the input record separator - we will use for
##           the minimum value
##
##    * $\ - normally the output record separator - we will use for
##           the number of chunks
##
##  * @_ - the list of parameters passed to a function - in this case
##         $_[0] is the string and $_[1] is the block size
##
##  * Chained maps - we can simplify the maps by chaining them
##    together, here we break it down into 5 separate stages -
##    remember we have to read the code backwards. So we will look
##    at the separate blocks of code working upwards...
##
##    * 0..$\-1 - this returns a list of indices for the substrings
##
##    * map { $_*$_[1] } - this converts those indices into start
##        locations ($_ is the value of the element of variable that
##        the map function is processing
##
##    * map { [ $_, substr$_[0],$_,$_[1] ] } - this grabs the
##        substring for the nth block - but keeps the start location
##        as we will need it later... Here we see a map returning an
##        arrayref - in subsequent requests - $_->[0] is the start
##        offset of the block and $_->[1] is the property we are
##        munging in this case the substring.
##
##        You have to be careful here as $_[0] and $_->[0] look similar
##        but are different
##
##    * map { [ $_->[0], $_->[1] x $\ ] } - this maps the string we
##        just have to have the same length as our original string -
##        by performing a perl "string multiplication" x
##
##    * map { [ $_->[0], ( $_[0] ^ $_->[1] ) =~ y/\1/\1/ ] } -
##        count the flips. Two perlisms here - we can use xor operator
##        ^ on strings to xor the binary values of each string.
##        y/../../ - the translate operator returns the number of
##        substitutions it makes - in this case we are substituting
##        the ASCII character with decimal a hex value of "01"... when
##        the strings are same the byte value of the xor is 0 or as
##        a character "\0" and when they are different the value is 1
##        or as a characther "\1"
##
##    * map { $/ = !$_->[0] || $_->[1] < $/ ? $_->[1] : $/ } - finally
##        we keep the running total of the minimum value - Now this is
##        why we kept the start of the block around - as the first
##        time through the loop we have to define the minimum - if
##        $_->[0] is zero then we assign $_->[1] to $/ - we could have
##        used the List::Util function min - but I try and avoid using
##        external modules if I can...
##
##  * The list is the running minimums so we have to get the last
##    element off the list - we do this with by wrapping the list
##    in [ ] to make it an arrayref and then taking its last value
##    [{list}]->[-1] perl indexes the last element as -1.
##
##  * And we return this value.


sub min_flips {
  ## Golf mode on...
  [
    local$/,
    local$\=length($_[0])/$_[1],
    map{$/=!$_->[0]||$_->[1]<$/?$_->[1]:$/}
    map{[$_->[0],($_[0]^$_->[1])=~y/\1/\1/]}
    map{[$_->[0],$_->[1]x$\]}
    map{[$_,substr$_[0],$_,$_[1]]}
    map{$_*$_[1]}
    0..$\-1
  ]->[-1]
}

## Now as a one liner [all 213 cha....

sub mf_1{[local$/,local$\=length($_[0])/$_[1],map{$/=!$_->[0]||$_->[1]<$/?$_->[1]:$/}map{[$_->[0],($_[0]^$_->[1])=~y/\1/\1/]}map{[$_->[0],$_->[1]x$\]}map{[$_,substr$_[0],$_,$_[1]]}map{$_*$_[1]}0..$\-1]->[-1]}

sub mf_1wrap{[local$/,local$\=length($_[0])/$_[1],map{$/=!$_->[0]||$_->
[1]<$/?$_->[1]:$/}map{[$_->[0],($_[0]^$_->[1])=~y/\1/\1/]}map{[$_->[0],
$_->[1]x$\]}map{[$_,substr$_[0],$_,$_[1]]}map{$_*$_[1]}0..$\-1]->[-1]}

## With the white space back in..

sub min_flips_more_readable {
  return [
    local $/,                                            # Accumulator for min value
    local $\ = length($_[0]) / $_[1],                    # No of blocks

    map { $/ = !$_->[0] || $_->[1] < $/ ? $_->[1] : $/ } # Update min if first block OR value < min
    map { [ $_->[0], ( $_[0] ^ $_->[1] ) =~ y/\1/\1/ ] } # Get number of flipped letters
    map { [ $_->[0], $_->[1] x $\                    ] } # Repeat sub-block so same length as string
    map { [ $_,      substr $_[0], $_, $_[1]         ] } # Get "nth" sub-block
    map { $_ * $_[1]                                   } # Convert index to start location
    0 .. $\ - 1                                          # Block indexes...
  ]->[ -1 ];                                             # Get last value from list {minimum}
}
