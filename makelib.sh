#!/bin/bash
aspell -d en dump master | sed 's/ä/ae/g' | sed 's/ö/oe/g' | sed 's/ü/ue/g' | sed 's/ß/sz/g' | sed 's/Ä/Ae/g' | sed 's/Ö/Oe/g' | sed 's/Ü/Ue/g' | shuf | head -n 1000 | tr '\r\n' '\t' | sed 's/\t/\n/5;P;D'
