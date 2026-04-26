#!/bin/bash

echo "=== ROADMAP STATUS ==="
grep -R "Status:" docs/ROADMAP.md | sort
