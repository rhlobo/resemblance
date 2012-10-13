#!/bin/bash 

function encode() { echo -n $@ | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'; }
function goo() { google-chrome http://www.google.com/search?hl=en#q="`encode $@`" ;}
