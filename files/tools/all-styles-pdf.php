<?php
$ini = parse_ini_file("../.ocitysmap.conf", true, INI_SCANNER_RAW);

$styles = explode(",", $ini["rendering"]["available_stylesheets"]);

$style_groups = ["default" => []];

foreach ($styles as $style) {
  $attr = $ini[$style];

  $group = $attr['group'] ?? "default";

  if (!isset($style_groups[$group])) {
    $style_groups[$group] = [];
  }

  $style_groups[$group][$style] = $attr;
}



$overlays = explode(",", $ini["rendering"]["available_overlays"]);

$overlay_groups = ["default" => []];

foreach ($overlays as $style) {
  $attr = $ini[$style];

  $group = $attr['group'] ?? "default";

  if (!isset($overlay_groups[$group])) {
    $overlay_groups[$group] = [];
  }

  $overlay_groups[$group][$style] = $attr;
}


ob_start();
?>
\documentclass{article}

\usepackage{graphics}
\usepackage{pdfpages}
\usepackage{pdflscape}

\begin{document}
<?php

foreach ($style_groups as $name => $group) {
  foreach ($group as $style) {
    $pdf = "/vagrant/test/test-base-".$style["name"]."-pdf.pdf";
    if (file_exists($pdf)) {
      echo "\\includepdf{".$pdf."}\n";
    }
  }
}

foreach ($overlay_groups as $name => $group) {
  foreach ($group as $style) {
    $pdf = "/vagrant/test/test-overlay-".str_replace('_','-',$style["name"])."-pdf.pdf";
    if (file_exists($pdf)) {
      echo "\\includepdf{".$pdf."}\n";
    }
  }
}

?>
\end{document}
<?php
file_put_contents("/vagrant/test/all-styles.tex", ob_get_clean());

$style_files = [];
foreach ($style_groups as $name => $group) {
  $style_files[] = "/vagrant/test/test-overlay-".str_replace('_','-',$style["name"])."-pdf.pdf";
}

$cmd = "pdfjam --suffix nup --quiet --nup 5x5 --papersize '{594mm,841mm}' --outfile all-styles-poster.pdf " . join(" ", $style_files);

system($cmd);

$style_files = [];
foreach ($overlay_groups as $name => $group) {
  $style_files[] = "/vagrant/test/test-overlay-".str_replace('_','-',$style["name"])."-pdf.pdf";
}

$cmd = "pdfjum --suffix nup --quiet --nup 5x5 --papersize '{594mm,841mm}' --outfile all-overlays-poster.pdf " . join(" ", $style_files);

system($cmd);





