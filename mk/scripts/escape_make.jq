def escape_make: . | gsub(" ";"_") | gsub(":";"@COLON@") | gsub("[(]";"@LBR@") | gsub("[)]";"@RBR@") | gsub("/";"@SLASH@") | gsub("'";"@SQUOTE@") | gsub("\"";"@DQUOTE@") | gsub("[*]";"@STAR@") | gsub("=";"@EQ@") | gsub("[$]";"@DOLLAR@") | gsub("[#]";"@SHARP@") | gsub("%";"@PERC@");
