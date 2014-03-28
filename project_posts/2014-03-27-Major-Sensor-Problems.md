Always read the data sheets carefully is the lesson we learned here!

We seem to have ordered sensors that don't output in full range. We are putting 5V in but only getting mV readings out.

The Arduinos analog to digital inputs and convert only have a certain resolution(0-1023) is what we have found out. We have tried to use AREF to rescale the inputs, we have also tried to use analogReadResolution(), but can't seem to get any resolution that works.

We even tried to purchase OPAMPs but quickly found out that doesn't work either. What we seem to need is differential amps. We could build a circuit for that, or order them, or just return these sensors and get the correct ones.

Again we have learned the all important lesson of READ YO DATA SHEETZ!

Fail fast, fail often ... but never give up!
