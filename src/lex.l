%{
#include <ctype.h>

#include "y.tab.h"
%}

%x	COMMENT
ESC	\*[0et*'"n]

%%

"/*"			BEGIN COMMENT;
<COMMENT>"*/"		BEGIN INITIAL;
<COMMENT>.|\n		/* discard comments */

"=*"			return (ASMUL);
=%			return (ASMOD);
"=/"			return (ASDIV);
"=+"			return (ASADD);
=-			return (ASSUB);
=<<			return (ASSHL);
=>>			return (ASSHR);
=<			return (ASLT);
=>			return (ASGT);
=<=			return (ASLE);
=>=			return (ASGE);
===			return (ASEQ);
=!=			return (ASNE);
=&			return (ASAND);
"=^"			return (ASXOR);
=\\			return (ASOR);
"++"			return (INC);
--			return (DEC);
"<<"			return (SHL);
>>			return (SHR);
"<="			return (LE);
>=			return (GE);
==			return (EQ);
!=			return (NE);

[0-9]+			|
\'([^*'\n]|{ESC})*\'	|
\"([^*"\n]|{ESC})*\"	return (CONSTANT);

\"			printf("unterminated string constant\n");
'			printf("unterminated character constant\n");

[A-Za-z_][[:alnum:]_]*	{
				size_t i;
				for (i = 0; yytext[i] != '\0'; i++)
					yytext[i] = toupper(yytext[i]);
				return (NAME);
			}

[[:space:]]		/* ignore white space */

[!-^]			return (yytext[0]);
[`-~]			return (yytext[0] - 040);	/* convert to 6 bit ASCII */

.			printf("stray %03o\n", (unsigned char)yytext[0]);

%%

/*
 * Supply the next input file and return zero or indicate the absence of
 * further input files by returning one.  Since we don't need this
 * feature of lex, this always returns 1.
 */
extern int
yywrap(void)
{
	return (1);
}