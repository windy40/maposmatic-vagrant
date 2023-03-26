<?php

$PAPER_SIZE='{841mm,594mm}' # DinA1 landscape
$PAGE_COUNT=6

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
    $pdf = "test-base-".$style["name"]."-pdf.pdf";
    if (file_exists($pdf)) {
      echo "\\includepdf{".$pdf."}\n";
    }
  }
}

foreach ($overlay_groups as $name => $group) {
  foreach ($group as $style) {
    $pdf = "test-overlay-".str_replace('_','-',$style["name"])."-pdf.pdf";
    if (file_exists($pdf)) {
      echo "\\includepdf{".$pdf."}\n";
    }
  }
}

?>
\end{document}
<?php
file_put_contents("all-styles.tex", ob_get_clean());

$style_files = [];
foreach ($style_groups as $name => $group) {
  foreach ($group as $style) {
    $name = "test-base-".str_replace('_','-',$style["name"])."-pdf.pdf";
    if (file_exists($name)) {
      $style_files[] = $name;
    }
  }
}

$cmd = "pdfjam --suffix nup --quiet --nup ${PAGE_COUNT}x${PAGE_COUNT} --papersize '$PAPSER_SIZE' --outfile all-styles-poster.pdf " . join(" ", $style_files);

system($cmd);

$style_files = [];
foreach ($overlay_groups as $name => $group) {
  foreach ($group as $style) {
    $name = "test-overlay-".str_replace('_','-',$style["name"])."-pdf.pdf";
    if (file_exists($name)) {
      $overlay_files[] = $name;
    }
  }
}

$cmd = "pdfjam --suffix nup --quiet --nup ${PAGE_COUNT}x${PAGE_COUNT} --papersize '$PAPER_SIZE' --outfile all-overlays-poster.pdf " . join(" ", $overlay_files);

system($cmd);

$cmd = "pdfjam --suffix nup --quiet --nup ${PAGE_COUNT}x${PAGE_COUNT} --papersize '$PAPER_SIZE' --outfile all-styles-and-overlays-poster.pdf " . join(" ", $style_files) . " " . join(" ", $overlay_files);




