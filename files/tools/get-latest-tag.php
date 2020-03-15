#! /usr/bin/php
<?php

if (empty($argv[1])) {
  $pattern = '/^v.*$/';
} else {
  $pattern = '/^'.$argv[1].'$/';
}

exec("git tag", $tags, $retval);

if ($retval) {
  die("git tag failed");
}

$latest = "";
foreach ($tags as $tag) {
	if (preg_match($pattern, $tag)) {
		if (empty($latest)) {
			$latest = $tag;
		} else {
			echo "$tag - $latest - ".version_compare($latest,$tag)."\n";
			if (version_compare($tag, $latest) > 0) {
				$latest = $tag;
			}
		}
  }
}

echo "$latest\n";
