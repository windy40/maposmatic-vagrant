<?php

foreach(file("php://stdin") as $line) {
	if (preg_match('|(\s*)<Font face-name="([^"]+)"/>|', $line, $m)) {
		$indent = $m[1];
		$fonts = explode(",", $m[2]);
		foreach ($fonts as $font) {
			echo "$indent<Font face-name=\"".trim($font)."\"/>\n";
		}
	} else {
		echo $line;
	}
}




/*
 * ./toner/toner.xml:  <Font face-name="Noto Sans UI Regular, Noto Sans CJK JP Regular, Noto Sans Armenian Regular, Noto Sans Balinese Regular, Noto Sans Bamum Regular, Noto Sans Batak Regular, Noto Sans Bengali UI Regular, Noto Sans Buginese Regular, Noto Sans Buhid Regular, Noto Sans Canadian Aboriginal Regular, Noto Sans Cham Regular, Noto Sans Cherokee Regular, Noto Sans Coptic Regular, Noto Sans Devanagari UI Regular, Noto Sans Devanagari Regular, Noto Sans Ethiopic Regular, Noto Sans Georgian Regular, Noto Sans Gujarati UI Regular, Noto Sans Gujarati Regular, Noto Sans Gurmukhi UI Regular, Noto Sans Hanunoo Regular, Noto Sans Hebrew Regular, Noto Sans Javanese Regular, Noto Sans Kannada UI Regular, Noto Sans Kayah Li Regular, Noto Sans Khmer UI Regular, Noto Sans Lao UI Regular, Noto Sans Lepcha Regular, Noto Sans Limbu Regular, Noto Sans Lisu Regular, Noto Sans Malayalam UI Regular, Noto Sans Mandaic Regular, Noto Sans Mongolian Regular, Noto Sans Myanmar UI Regular, Noto Sans New Tai Lue Regular, Noto Sans NKo Regular, Noto Sans Ol Chiki Regular, Noto Sans Oriya UI Regular, Noto Sans Oriya Regular, Noto Sans Osmanya Regular, Noto Sans Samaritan Regular, Noto Sans Saurashtra Regular, Noto Sans Shavian Regular, Noto Sans Sinhala Regular, Noto Sans Sundanese Regular, Noto Sans Symbols Regular, Noto Sans Syriac Eastern Regular, Noto Sans Syriac Estrangela Regular, Noto Sans Syriac Western Regular, Noto Sans Tagalog Regular, Noto Sans Tagbanwa Regular, Noto Sans Tai Le Regular, Noto Sans Tai Tham Regular, Noto Sans Tai Viet Regular, Noto Sans Tamil UI Regular, Noto Sans Telugu UI Regular, Noto Sans Thaana Regular, Noto Sans Thai UI Regular, Noto Sans Tibetan Regular, Noto Sans Tifinagh Regular, Noto Sans Vai Regular, Noto Sans Yi Regular, Noto Naskh Arabic UI Regular, Noto Emoji Regular, DejaVu Sans Book, HanaMinA Regular, HanaMinB Regular, Unifont Medium, unifont Medium, Unifont Upper Medium"/>
 */
