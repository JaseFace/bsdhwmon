#
# Copyright (C) 2008-2015 Jeremy Chadwick. All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

.if defined(DEBUG)
CFLAGS+=	-g3 -ggdb
.endif
CFLAGS+=	-Werror -Wall -Wextra -Wformat-security -Waggregate-return -Wbad-function-cast -Wcast-align -Wdeclaration-after-statement -Wdisabled-optimization -Wfloat-equal -Winline -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wold-style-definition -Wpacked -Wpointer-arith -Wredundant-decls -Wstrict-prototypes -Wunreachable-code -Wwrite-strings

OBJS=	main.o boards.o output.o chip_w83792d.o chip_w83793g.o chip_x6dva.o smbus_io.c

all: bsdhwmon man

bsdhwmon: ${OBJS}
	${CC} ${CFLAGS} -o ${.TARGET} ${.ALLSRC}

${OBJS}: global.h
	${CC} ${CFLAGS} -c ${.PREFIX}.c

man: bsdhwmon.8.txt

bsdhwmon.8.txt: bsdhwmon.8
	troff -Tascii -mman bsdhwmon.8 | grotty -c -b -o -u > ${.TARGET}

clean:
	rm -f bsdhwmon *.o *.core

# Assign YYYYMMDD to $NOW variable
NOW!=	/bin/date +%Y%m%d

# http://git-scm.com/book/en/v2/Git-Basics-Tagging
# http://git-scm.com/docs/git-archive
release:
	@echo git tag -a bsdhwmon-${NOW} -m \"Release: bsdhwmon-${NOW}\"
	@echo git archive --prefix=bsdhwmon-${NOW}/ -o /tmp/bsdhwmon-${NOW}.tar.gz bsdhwmon-${NOW}
	@echo chmod 0644 /tmp/bsdhwmon-${NOW}.tar.gz
	@echo ls -l /tmp/bsdhwmon-${NOW}.tar.gz
	@echo git push origin bsdhwmon-${NOW}

