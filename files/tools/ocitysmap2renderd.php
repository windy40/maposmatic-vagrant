<?php

/**
 * convert ocitysmap style configuration to renderd.conf 
 */

$conf_file = "/home/maposmatic/.ocitysmap.conf";

$section = false;
foreach (file($conf_file) as $line) {
    if (preg_match('|^\s*\[(\w+)\]\s*$|', $line, $m)) {
        $section = $m[1];
    }
    if (preg_match('|^\s*path\s*=\s*(/.+\.xml)\s*$|', $line, $m)) {
        $path = $m[1];
        echo "[$section]\n";
        echo "URI=/tiles/$section/\n";
        echo "TILEDIR=/var/lib/mod_tile\n";
        echo "XML=$path\n";
        echo "HOST=localhost\n";
        echo "TILESIZE=256\n";
        echo "MAXZOOM=18\n";
        echo "\n";
    }
}

