<?php
$name = basename($_GET["name"]);

if (!file_exists($name)) {
    echo "No such file: $name";
}

$content = htmlentities(file_get_contents($name));
?>
<html>
  <head>
    <title><?php echo $name; ?></title>
  </head>
  <body>
    <h1><tt><?php echo $name; ?></tt></h1><hr/>
    <pre><?php echo $content; ?></pre>
  </body>
</html>
