<?php

$infile  = "osm.xml";
$outfile = "osm-bw.xml";

function reduce_color($results)
{
    if(! preg_match('|#(..)(..)(..)|', $results[0], $matches)) {
        echo "$results[0]\n";
    }

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

  $line = str_replace('symbols/', 'symbols-bw/', $line);

  fwrite($out, $line);
}

fclose($in);
fclose($out);

if (!is_dir("symbols-bw")) {
  mkdir("symbols-bw");
}


chdir("symbols");

$directory = new \RecursiveDirectoryIterator(".");
$iterator = new \RecursiveIteratorIterator($directory);
$files = array();
foreach ($iterator as $info) {
    $path = $info->getPathname();

    if(!is_dir("../symbols-bw/".dirname($path))) {
        mkdir("../symbols-bw/".dirname($path));
    }

    switch (pathinfo($path, PATHINFO_EXTENSION)) {
    case 'png':
        system("convert $path -grayscale average ../symbols-bw/$path");
        break;
    case 'svg':
        $in = fopen($path, "r");
        $out = fopen("../symbols-bw/$path", "w");

        while (!feof($in)) {
            $line = fgets($in);

            $line = preg_replace_callback('|#[0-9a-f]{6}|i', "reduce_color", $line);

            fwrite($out, $line);
        }

        fclose($in);
        fclose($out);
       break;
    }
}





