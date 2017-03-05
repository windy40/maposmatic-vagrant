<?php

$infile  = "osm.xml";
$outfile = "osm-bw.xml";

function reduce_color($results)
{
  preg_match('|#(..)(..)(..)|', $results[0], $matches);

  $r = hexdec($matches[1]);
  $g = hexdec($matches[2]);
  $b = hexdec($matches[3]);

  $avg = (int)(($r + $g + $b) / 3); 
  # $avg = (int)(0.21*$r + 0.72*$g + 0.07*$b);
  # $avg = (int)((max($r,$g,$b)+min($r, $g, $b))/2);

  return sprintf("#%02x%02x%02x", $avg, $avg, $avg);
}

$in  = fopen($infile,  "r");
$out = fopen($outfile, "w");

while (!feof($in)) {
  $line = fgets($in);

  $line = preg_replace_callback('|#[0-9a-f]+|i', "reduce_color", $line);

  fwrite($out, $line);
}

?>

