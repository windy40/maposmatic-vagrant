#! /usr/bin/php
<?php

if ($argc != 2) {
        die("Usage: ".$argv[0]." some-file-xml\n");
}

$doc = new DOMDocument();
$doc->load($argv[1]);

$xpath = new DOMXpath($doc);

/* 
   comp-op filter operations enforce bitmap output format
   even when the actual output format is PDF and SVG we'd
   still end up with PDF or SVG files that just contain
   one single PNG bitmap object instead of vectorized data

$comp_op = $xpath->query("//*[@comp-op]");
if (!is_null($comp_op)) {
        foreach ($comp_op as $tag) {
                echo ".";
    $tag->removeAttribute("comp-op");
  }
 }
*/



/*
   Some fonts are known to not be available on all 
   platforms. As this causes Mapnik warnings about unknown
   fonts we remove those fonts that are know to not be
   available on Ubuntu
*/


# list of unknown fonts created with
#
# journalctl  -u maposmatic-render.service | grep face-name | grep -v ", " | sed -e 's/.*face-name//g' -e 's/in FontSet.*/,/g' | sort | uniq


$nofonts = [
 'Arundina Sans Bold',
 'Arundina Sans Italic',
 'Arundina Sans Regular',
 'DejaVu Sans Bold Italic',
 'DejaVu Sans Italic',
 'Droid Sans Bold',
 'Droid Sans Italic',
 'Droid Sans Regular',
 'gargi Medium',
 'HanaMinA Regular',
 'HanaMinB Regular',
 'Mallige Bold',
 'Mallige Normal',
 'Mallige NormalItalic',
 'Mukti Narrow Bold',
 'Mukti Narrow Regular',
 'Noto Emoji Regular',
 'Noto Sans UI Bold',
 'Noto Sans UI Italic',
 'Noto Sans UI Regular',
 'Open Sans Oblique',
 'Tibetan Machine Uni Regular',
 'unifont Medium',
 ];

$fontsets = $xpath->query("//FontSet");

if (!is_null($fontsets)) {
  foreach ($fontsets as $fontset) {
    $remove = [];
    foreach ($fontset->childNodes as $child) {
      if ($child->nodeType === XML_ELEMENT_NODE) {
        $facelist = preg_split('/,\s+/', $child->getAttribute("face-name"));

        if (count($facelist) > 1) {
          $remove[] = $child;
          foreach ($facelist as $face) {
            $face = trim($face);
            if (!in_array($face, $nofonts)) {
              $new_node = $child->cloneNode();
              $new_node->setAttribute("face-name", $face);
              $ws = $child->previousSibling->cloneNode();
              $fontset->appendChild($new_node);
              if ($ws->nodeType === XML_TEXT_NODE) {
                $fontset->appendChild($ws);
              }
            }
          }
        } else {
          if (in_array($facelist[0], $nofonts)) {
            $remove[] = $child;
          }
        }
      }
    }

    foreach ($remove as $child) {
      $ws = $child->previousSibling;
      if ($ws->nodeType === XML_TEXT_NODE) {
        $fontset->removeChild($ws);
      }
      $fontset->removeChild($child);
    }
  }
 }





file_put_contents($argv[1], $doc->saveXML());



