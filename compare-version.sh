#!/usr/bin/env python3

import apt_pkg, sys
apt_pkg.init_system()

if len(sys.argv) != 3:
	sys.exit('usage: apt-compare-versions <first-version> <second-version>')

version1 = sys.argv[1]
version2 = sys.argv[2]

comparison_result = apt_pkg.version_compare(version1, version2)
ret = 0

if comparison_result > 0:
	operator = ' > '
	ret=1
elif comparison_result < 0:
	operator = ' < '
	ret=2
elif comparison_result == 0:
	ret=0
	operator = ' == '

print(version1 + operator + version2)
exit(ret)

